<?php
/*
	用户消息通知
	
*/

class SuMsgMod {
	public static function func_get_sumsg($item) {
		$item['title'] = htmlspecialchars($item['title']);
		$item['content'] = XssHtml::clean_xss($item['content']);
		return $item;
	}

	/*
		通知列表
	*/
	public static function get_su_msg($option) {
		$sql = 'select * from user_msg';
		if(!empty($option['su_uid'])) {
			$where_arr[] = 'su_uid = '.$option['su_uid'];
		}
		if(!empty($option['from_uid']) && $option['from_uid'] >= 0) {
			$where_arr[] = 'from_uid = '.$option['from_uid'];
		}
		//未读
		if(!empty($option['unread_only'])) {
			$where_arr[] = 'read_time = 0';	
		}
		//搜索
		if(!empty($option['key'])) {
			$where_arr[] = '(title like "%'.$option['key'].'%" or content like "%'.$option['key'].'%")';
		}
		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}
		$sql .= ' order by create_time desc';

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'SuMsgMod::func_get_sumsg');
	}

	/*
		未读通知数目
	*/
	public static function get_unread_su_msg_cnt($su_uid = 0) {
		if(!$su_uid && !($su_uid = AccountMod::get_current_service_user('uid'))) {
			setLastError(ERROR_DBG_STEP_1);
			return false;	
		}
		$key = 'su_umc_'.$su_uid;
		if(!($ret = $GLOBALS['arraydb_sys'][$key])) {
			$ret = 0;
		}

		return $ret;
	}

	/*
		发送消息通知给用户
		$msg = array(
			'su_uid' => 
			'title' => 
			'content' => 
			
			'from_uid' => 选填
		)
	*/
	public static function add_su_msg($msg) {
		if(!$msg['su_uid']) {
			setLastError(ERROR_DBG_STEP_1);
			return false;	
		}
		$msg['create_time'] = $_SERVER['REQUEST_TIME'];
		Dba::insert('user_msg', $msg);
		$msg['uid'] = Dba::insertID();

		//未读数目+1
		$key = 'su_umc_'.$msg['su_uid'];
		if(!($cnt = $GLOBALS['arraydb_sys'][$key])) {
			$cnt = 0;
		}
		$GLOBALS['arraydb_sys'][$key] = $cnt + 1;
		
		return $msg['uid'];
	}

	
	/*
		标记为已读,未读
		$time =0 标记为未读, > 0 标记为已读
		支持批量
	*/
	public static function read_su_msg($time, $uids, $su_uid = 0) {
		if(!$su_uid && !($su_uid = AccountMod::get_current_service_user('uid'))) {
			setLastError(ERROR_DBG_STEP_1);
			return false;	
		}
		if($time) {
			$time = $_SERVER['REQUEST_TIME'];
		}
		$sql = 'update user_msg set read_time = '.$time.' where uid in ('.
				implode(',', $uids).') && su_uid = '.$su_uid;
		$acnt = Dba::write($sql);
		$key = 'su_umc_'.$su_uid;
		if(!($cnt = $GLOBALS['arraydb_sys'][$key])) {
			$cnt = 0;
		}
		$GLOBALS['arraydb_sys'][$key] = max(0, $cnt + $acnt * ($time ? -1 : 1));

		return $acnt;
	}

	/*
		删除消息通知
		支持批量
	*/
	public static function delete_su_msg($uids, $su_uid = 0) {
		if(!$su_uid && !($su_uid = AccountMod::get_current_service_user('uid'))) {
			setLastError(ERROR_DBG_STEP_1);
			return false;	
		}

		//已读
		$sql = 'select count(*) from user_msg where uid in ('.
				implode(',', $uids).') && su_uid = '.$su_uid.' && read_time = 0';
		if($acnt = Dba::readOne($sql)) {
			$key = 'su_umc_'.$msg['su_uid'];
			if(!($cnt = $GLOBALS['arraydb_sys'][$key])) {
				$cnt = 0;
			}
			$GLOBALS['arraydb_sys'][$key] = max(0, $cnt - $acnt);
		}

		$sql = 'delete from user_msg where uid in ('.
				implode(',', $uids).') && su_uid = '.$su_uid;
		
		return Dba::write($sql);
	}

}

