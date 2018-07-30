<?php
/*
	微信群管理
*/

class WechatGroupMod {
	/*
		微信群id 转为 g_uid 
		如果不存在，会自动创建一个
	*/
	public static function wx2gid($wx_group_id, $sp_uid) {
		return WechatGroupMod::add_or_edit_group(array('sp_uid' => $sp_uid, 'wx_group_id' => $wx_group_id));
	}
 
	/*
		判断是否在该群里		
		可以一次判断多个
	*/
	public static function is_in_group($su_uid, $g_uids) {
		if(!is_array($g_uids)) {
			$g_uids = array($g_uids);
		}

		return Dba::readAllOne('select su_uid from wechat_groups_users where g_uid in ('.
										implode(',',$g_uids).') && su_uid  = '.$su_uid);	
	}

	public static function func_get_group($g) {
		return WechatGroupMod::get_group_by_uid($g['g_uid']);
	}

	public static function add_or_edit_group($g) {
		//如果指定了群id， 看看是否存在
		if(!empty($g['wx_group_id'])) {
			if($uid = Dba::readOne('select uid from wechat_groups_all where sp_uid = '.
										$g['sp_uid'].' && wx_group_id = "'.$g['wx_group_id'].'"')) {
				$g['uid'] = $uid;
			}
		}

		if(!empty($g['uid'])) {
			Dba::update('wechat_groups_all', $g, 'uid = '.$g['uid'].' and sp_uid = '.$g['sp_uid']);
		}
		else {
			empty($g['create_time']) && $g['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('wechat_groups_all', $g);
			$g['uid'] = Dba::insertID();
		}

		return $g['uid'];
	}

	public static function get_group_by_uid($uid) {
		$sql = 'select * from wechat_groups_all where uid = '.$uid;
		return Dba::readRowAssoc($sql);
	}

	/*
		获取当前商户的微信群列表, 不分页
	*/
	public static function get_sp_groups($sp_uid = 0) {
		if(!$sp_uid && !($sp_uid = AccountMod::get_current_service_provider('uid'))) {
			setLastError(ERROR_DBG_STEP_1);
			return false;	
		}

		$sql = 'select * from wechat_groups_all where sp_uid = '.$sp_uid;
		return Dba::readAllAssoc($sql);
	}

	/*
		删除分组
		返回删除的条数
	*/
	public static function delete_groups($gids, $sp_uid) {
		if(!is_array($gids)) {
			$gids = array($gids);
		}
		$sql = 'delete from wechat_groups_all where uid in ('.implode(',',$gids).') and sp_uid = '.$sp_uid;

		Dba::beginTransaction(); {
			$ret = Dba::write($sql);
			if($ret) {
				//删除分组下的粉丝关系
				$sql = 'delete from wechat_groups_users where g_uid in ('.implode(',',$gids).')';
				Dba::write($sql);
			}
		} Dba::commit();

		return $ret;
	}

	/*
		获取微信群下的用户uid列表
	*/
	public static function get_group_su_uids($option) {
		$sql = 'select * from wechat_groups_users where g_uid = '.$option['g_uid'];
		$sql .= ' order by create_time desc';
		return Dba::readCountAndLimit($sql, $option['page'], $option['limit']);
	}

	/*
		获取用户所在微信群
		可能属于多个群,不分页
	*/
	public static function get_user_groups($su_uid) {
		$sql = 'select g_uid from wechat_groups_users where su_uid = '.$su_uid;
		return Dba::readAllAssoc($sql, 'WechatGroupMod::func_get_group');
	}

	/*
		批量添加用户到某个分组
		返回添加成功的数目

		可以检查一下用户是否属于该sp_uid
	*/
	public static function add_user_to_group($su_uids, $g_uid, $sp_uid) {
		if(!($g = self::get_group_by_uid($g_uid)) || ($g['sp_uid'] != $sp_uid)) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}
		
		if(!is_array($su_uids)) {
			$su_uids = array($su_uids);
		}
		//不要重复添加
		if($e = Dba::readAllOne('select su_uid from wechat_groups_users where g_uid = '.$g_uid.' && su_uid in ('.implode(',', $su_uids).')')) {
			$su_uids = array_diff($su_uids, $e);
		}
		if(!($cnt = count($su_uids))) {
			return 0;
		}

		foreach($su_uids as $u) {
			$inserts[] = array('g_uid' => $g_uid, 'su_uid' => $u, 'create_time' =>$_SERVER['REQUEST_TIME']);
		}
		Dba::beginTransaction(); {
			Dba::insertS('wechat_groups_users', $inserts);
			Dba::write('update wechat_groups_all set user_cnt = user_cnt + '.$cnt.' where uid = '.$g_uid);
		} Dba::commit();

		return $cnt;
	}

	/*
		批量把用户移动到某个群
		貌似没用
	*/
	public static function move_user_to_group($su_uids, $g_uid, $sp_uid) {
		if(!($g = self::get_group_by_uid($g_uid)) || ($g['sp_uid'] != $sp_uid)) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}
		
		if(!is_array($su_uids)) {
			$su_uids = array($su_uids);
		}

		//1. 先删除旧的分组
		$sql = 'select g_uid, count(*) as cnt from wechat_groups_users where su_uid in ('.implode(',', $su_uids).') group by g_uid';
		if($old = Dba::readAllAssoc($sql)) {
			 foreach($old as $o) {
				Dba::write('update wechat_groups_all set user_cnt = user_cnt - '.$o['cnt'].' where uid = '.$o['g_uid']);
			}
			Dba::write('delete from wechat_groups_users where su_uid in ('.implode(',', $su_uids).')');
		}

		$cnt = count($su_uids);
		foreach($su_uids as $u) {
			$inserts[] = array('g_uid' => $g_uid, 'su_uid' => $u, 'create_time' =>$_SERVER['REQUEST_TIME']);
		}
		Dba::beginTransaction(); {
			Dba::insertS('wechat_groups_users', $inserts);
			Dba::write('update wechat_groups_all set user_cnt = user_cnt + '.$cnt.' where uid = '.$g_uid);
		} Dba::commit();

		return $cnt;
		
	}

	/*
		批量把用户从某个分组删除, 返回删除的数目
	*/
	public static function delete_user_from_group($su_uids, $g_uid, $sp_uid) {
		if(!($g = self::get_group_by_uid($g_uid)) || ($g['sp_uid'] != $sp_uid)) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}
		
		if(!is_array($su_uids)) {
			$su_uids = array($su_uids);
		}
		
		Dba::beginTransaction(); {
			$sql = 'delete from wechat_groups_users where g_uid = '.$g_uid.' && su_uid in ('.implode(',', $su_uids).')';
			if($count = Dba::write($sql)) {
				Dba::write('update wechat_groups_all set user_cnt = user_cnt - '.$count.' where uid = '.$g_uid);
			}
		} Dba::commit();

		return $count;
	}
}

