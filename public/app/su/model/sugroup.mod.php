<?php
/*
	用户分组管理
	绑定手机管理
*/

class SuGroupMod {
	public static function func_get_group($g) {
		return SuGroupMod::get_group_by_uid($g['g_uid']);
	}

	public static function add_or_edit_group($g) {
		if(!empty($g['uid'])) {
			Dba::update('groups_all', $g, 'uid = '.$g['uid'].' and sp_uid = '.$g['sp_uid']);
		}
		else {
			empty($g['create_time']) && $g['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('groups_all', $g);
			$g['uid'] = Dba::insertID();
		}

		return $g['uid'];
	}

	public static function get_group_by_uid($uid) {
		$sql = 'select * from groups_all where uid = '.$uid;
		return Dba::readRowAssoc($sql);
	}

	public static function func_get_oauth_mobile($item) {
		if(!empty($item['from_name'])) $item['from_name'] = htmlspecialchars($item['from_name']);
		if($item['su_uid']) $item['su'] = AccountMod::get_service_user_by_uid($item['su_uid']);
		return $item;
	}

	/*
		获取当前商户的粉丝分组列表, 不分页
	*/
	public static function get_sp_groups($sp_uid = 0) {
		if(!$sp_uid && !($sp_uid = AccountMod::get_current_service_provider('uid'))) {
			setLastError(ERROR_DBG_STEP_1);
			return false;	
		}

		$sql = 'select * from groups_all where sp_uid = '.$sp_uid;
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
		$sql = 'delete from groups_all where uid in ('.implode(',',$gids).') and sp_uid = '.$sp_uid;

		Dba::beginTransaction(); {
			$ret = Dba::write($sql);
			if($ret) {
				//删除分组下的粉丝关系
				$sql = 'delete from groups_users where g_uid in ('.implode(',',$gids).')';
				Dba::write($sql);
			}
		} Dba::commit();

		return $ret;
	}

	/*
		获取分组下的用户uid列表
	*/
	public static function get_group_su_uids($option) {
		$sql = 'select * from groups_users where g_uid = '.$option['g_uid'];
		$sql .= ' order by create_time desc';
		return Dba::readCountAndLimit($sql, $option['page'], $option['limit']);
	}

	/*
		获取用户所在分组
		可能属于多个分组,不分页
	*/
	public static function get_user_groups($su_uid) {
		$sql = 'select g_uid from groups_users where su_uid = '.$su_uid;
		return Dba::readAllAssoc($sql, 'SuGroupMod::func_get_group');
	}

	public static function get_user_group($su_uid) {
		$sql = 'select g_uid from groups_users where su_uid = '.$su_uid;
		return Dba::readOne($sql);
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
		if($e = Dba::readAllOne('select su_uid from groups_users where g_uid = '.$g_uid.' && su_uid in ('.implode(',', $su_uids).')')) {
			$su_uids = array_diff($su_uids, $e);
		}
		if(!($cnt = count($su_uids))) {
			return 0;
		}

		foreach($su_uids as $u) {
			$inserts[] = array('g_uid' => $g_uid, 'su_uid' => $u, 'create_time' =>$_SERVER['REQUEST_TIME']);
		}
		Dba::beginTransaction(); {
			Dba::insertS('groups_users', $inserts);
			Dba::write('update groups_all set user_cnt = user_cnt + '.$cnt.' where uid = '.$g_uid);
		} Dba::commit();

		return $cnt;
	}

	/*
		批量把用户移动到某个分组
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
		$sql = 'select g_uid, count(*) as cnt from groups_users where su_uid in ('.implode(',', $su_uids).') group by g_uid';
		if($old = Dba::readAllAssoc($sql)) {
			 foreach($old as $o) {
				Dba::write('update groups_all set user_cnt = user_cnt - '.$o['cnt'].' where uid = '.$o['g_uid']);
			}
			Dba::write('delete from groups_users where su_uid in ('.implode(',', $su_uids).')');
		}

		$cnt = count($su_uids);
		foreach($su_uids as $u) {
			$inserts[] = array('g_uid' => $g_uid, 'su_uid' => $u, 'create_time' =>$_SERVER['REQUEST_TIME']);
		}
		Dba::beginTransaction(); {
			Dba::insertS('groups_users', $inserts);
			Dba::write('update groups_all set user_cnt = user_cnt + '.$cnt.' where uid = '.$g_uid);
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
			$sql = 'delete from groups_users where g_uid = '.$g_uid.' && su_uid in ('.implode(',', $su_uids).')';
			if($count = Dba::write($sql)) {
				Dba::write('update groups_all set user_cnt = user_cnt - '.$count.' where uid = '.$g_uid);
			}
		} Dba::commit();

		return $count;
	}

	/*
		获取绑定的手机列表 
	*/
	public static function get_oauth_mobile_list($option) {
		$sql = 'select * from oauth_su_mobile';
		if(!empty($option['sp_uid'])) {
			$where_arr[] = 'sp_uid = '.$option['sp_uid'];
		}
		if(!empty($option['sp_remark'])) {
			$where_arr[] = 'sp_remark = '.$option['sp_remark'];
		}
		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' && ', $where_arr);
		}
		$sql .= ' order by uid desc';

		Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'SuGroupMod::func_get_oauth_mobile');
	}

	/*
		绑定或修改绑定手机
		$osm = array(
			'mobile' => 15822222222
			'sp_uid' => 1
			'su_uid' => 可选, 用户uid,不填将自动添加一个新su_uid. 
						比如从分享链接进来的用户是没有su_uid的
		)

		返回 su_uid或false
	*/
	public static function bind_or_change_mobile($osm) {
		if(!SafetyCodeMod::check_mobile_code()) {
			return false;
		}

		$sql = 'select uid, su_uid from oauth_su_mobile where sp_uid = '.$osm['sp_uid'].' && mobile = "'.$osm['mobile'].'"';
		if($old = Dba::readRowAssoc($sql)) {
			if($old['su_uid'] && empty($osm['su_uid'])) {
				//以前绑定过, 修改绑定?
				setLastError(ERROR_OBJECT_ALREADY_EXIST);
				return $old['su_uid'];
			}
			else { //之前登记过手机,但没绑定su_uid, 可以绑定到su_uid
				$old_uid = $old['uid'];
			}
		}

		//没有su_uid那么 自动添加一个
		if(empty($osm['su_uid'])) {
			$su = array('sp_uid' => $osm['sp_uid'], 'name' => $osm['mobile']);
			$osm['su_uid'] = AccountMod::add_or_edit_service_user($su);
		}

		if((!empty($old_uid) && ($uid = $old_uid)) || 
			(!empty($osm['su_uid']) && ($uid = Dba::readOne('select uid from oauth_su_mobile where su_uid = '
															.$osm['su_uid'])))) {
				Dba::update('oauth_su_mobile', $osm, 'uid = '.$uid);
				$osm['uid'] = $uid;
		}
		else {
			$osm['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('oauth_su_mobile', $osm);
			$osm['uid'] = Dba::insertID();
		}

		return $osm['su_uid'];
	}

	/*
		标记绑定用户
		返回标记成功的个数
	*/
	public static function remark_oauth_mobile($remark, $uids, $sp_uid) {
		$sql = 'update oauth_su_mobile set remark = '.$remark.' where uid in ('.
				implode(',', $uids).') && sp_uid = '.$sp_uid;

		return Dba::write($sql);
	}

}

