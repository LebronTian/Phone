<?php
/*
	商户消息通知

	发送短信
*/

class SpMsgMod {
	public static function func_get_spmsg($item) {
		$item['title'] = htmlspecialchars($item['title']);
		$item['content'] = XssHtml::clean_xss($item['content']);
		return $item;
	}

	public static function func_get_sms($item) {
		$item['content'] = htmlspecialchars($item['content']);
		return $item;
	}

	/*
		通知列表
	*/
	public static function get_sp_msg($option) {
		$sql = 'select * from service_provider_msg';
		if(!empty($option['sp_uid'])) {
			$where_arr[] = 'sp_uid = '.$option['sp_uid'];
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

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'SpMsgMod::func_get_spmsg');
	}

	public static function get_sp_msg_by_uid($uid) {
		return Dba::readRowAssoc('select * from service_provider_msg where uid = '.$uid, 'SpMsgMod::func_get_spmsg');
	}

	/*
		未读通知数目
	*/
	public static function get_unread_sp_msg_cnt($sp_uid = 0) {
		if(!$sp_uid && !($sp_uid = AccountMod::get_current_service_provider('uid'))) {
			setLastError(ERROR_DBG_STEP_1);
			return false;	
		}
		$key = 'umc_'.$sp_uid;
		if(!($ret = $GLOBALS['arraydb_sys'][$key])) {
			$ret = 0;
		}

		return $ret;
	}

	/*
		发送消息通知给商户
		$msg = array(
			'sp_uid' => 
			'title' => 
			'content' => 
		)
	*/
	public static function add_sp_msg($msg) {
		if(!$msg['sp_uid'] && !($msg['sp_uid'] = AccountMod::get_current_service_provider('uid'))) {
			setLastError(ERROR_DBG_STEP_1);
			return false;	
		}
		$msg['create_time'] = $_SERVER['REQUEST_TIME'];
		Dba::insert('service_provider_msg', $msg);
		$msg['uid'] = Dba::insertID();

		//未读数目+1
		$key = 'umc_'.$msg['sp_uid'];
		if(!($cnt = $GLOBALS['arraydb_sys'][$key])) {
			$cnt = 0;
		}
		$GLOBALS['arraydb_sys'][$key] = $cnt + 1;
		Queue::add_job('sp_msgnoticeJob', array($msg['uid']));
        // 发送模板消息
 //       uct_use_app('templatemsg');
//        $args = Tmsg_sp_msgMod::get_args($msg);
//        Template_Msg_WxPlugMod::after_even_send_template_msg(__CLASS__ . '.' . __FUNCTION__, $msg['sp_uid'], '', $args);
		return $msg['uid'];
	}

	
	/*
		标记为已读,未读
		$time =0 标记为未读, > 0 标记为已读
		支持批量
	*/
	public static function read_sp_msg($time, $uids, $sp_uid = 0) {
		if(!$sp_uid && !($sp_uid = AccountMod::get_current_service_provider('uid'))) {
			setLastError(ERROR_DBG_STEP_1);
			return false;	
		}
		if($time) {
			$time = $_SERVER['REQUEST_TIME'];
		}
		$sql = 'update service_provider_msg set read_time = '.$time.' where uid in ('.
				implode(',', $uids).') && sp_uid = '.$sp_uid;
		$acnt = Dba::write($sql);
		$key = 'umc_'.$sp_uid;
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
	public static function delete_sp_msg($uids, $sp_uid = 0) {
		if(!$sp_uid && !($sp_uid = AccountMod::get_current_service_provider('uid'))) {
			setLastError(ERROR_DBG_STEP_1);
			return false;	
		}

		//已读
		$sql = 'select count(*) from service_provider_msg where uid in ('.
				implode(',', $uids).') && sp_uid = '.$sp_uid.' && read_time = 0';
		if($acnt = Dba::readOne($sql)) {
			$key = 'umc_'.$sp_uid;
			if(!($cnt = $GLOBALS['arraydb_sys'][$key])) {
				$cnt = 0;
			}
			$GLOBALS['arraydb_sys'][$key] = max(0, $cnt - $acnt);
		}

		$sql = 'delete from service_provider_msg where uid in ('.
				implode(',', $uids).') && sp_uid = '.$sp_uid;
		
		return Dba::write($sql);
	}

	/*
		获取发送短信记录
	*/
	public static function get_sp_sms($option) {
		$sql = 'select * from sms_record';
		if(!empty($option['sp_uid'])) {
			$where_arr[] = 'sp_uid = '.$option['sp_uid'];
		}
		if(isset($option['status'])) {
			$where_arr[] = 'status = '.$option['status'];
		}
		if(!empty($option['mobile'])) {
			$where_arr[] = 'mobile= "'.addslashes($option['mobile']).'"';
		}
		//搜索
		if(!empty($option['key'])) {
			$where_arr[] = '(content like "%'.$option['key'].'%")';
		}
		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}
		$sql .= ' order by create_time desc';
		
		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'SpMsgMod::func_get_sms');
	}
	
	/*
		发送短信
	
		@param $mobile 手机号码, 也可以给su_uid, 会自动判断去取用户手机
		@param $sp_uid 商户uid ,可以显式指定为0, 0表示uctphp系统发送,不检查短信配额
		todo 是否要异步
	*/
	public static function sp_send_sms($mobile, $msg, $sp_uid = null) {
		if(($sp_uid === null) && !($sp_uid = AccountMod::get_current_service_provider('uid'))) {

			setLastError(ERROR_DBG_STEP_1);
			return false;	
		}
		
		if(!checkString($mobile, PATTERN_MOBILE)) {
			if(!($mobile = Dba::readOne('select account from service_user where uid = '.$mobile)) ||
				!checkString($mobile, PATTERN_MOBILE)) {

				setLastError(ERROR_DBG_STEP_1);
				return false;	
			}
		}

		//检查短信数目是否足够, 发送成功后减少短信配额 
		if($sp_uid) {
			if(SpLimitMod::get_current_sp_limit('sms_remain', $sp_uid) < 1) {
				setLastError(ERROR_OUT_OF_LIMIT);
				return false;
			}
		}

		//调试模式不发送短信 
		if(defined('DEBUG_CHECK_CODE') && DEBUG_CHECK_CODE) {
			$ret = true;
		}
		else {
			include_once UCT_PATH.'vendor/sms/smsbao.php';
			$ret = send_sms($mobile, $msg);
		}
		$status = $ret ? 0 : 2;

		$insert = array('sp_uid' => $sp_uid, 
						'create_time' => $_SERVER['REQUEST_TIME'],
						'mobile' => $mobile,
						'content' => $msg,
						'status' => $status,
						);
		Dba::insert('sms_record', $insert);
		if($ret && $sp_uid) {
			SpLimitMod::decrease_current_sms_cnt(1, $sp_uid);
		}
		
		return $ret;
	}

	/*
		重新发送短信
		$uid record_uid
	*/
	public static function resend_sms($uid, $sp_uid = null) {
		if(($sp_uid === null) && !($sp_uid = AccountMod::get_current_service_provider('uid'))) {
			setLastError(ERROR_DBG_STEP_1);
			return false;	
		}
		if(!($s = Dba::readRowAssoc('select * from sms_record where uid = '.$uid)) || 
			($s['sp_uid'] != $sp_uid)) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}
		if($s['status'] == 0) {
			setLastError(ERROR_OBJECT_ALREADY_EXIST);
			return true;
		}
		//检查短信数目是否足够, 发送成功后减少短信配额 
		if($sp_uid) {
			if(SpLimitMod::get_current_sp_limit('sms_remain', $sp_uid) < 1) {
				setLastError(ERROR_OUT_OF_LIMIT);
				return false;
			}
		}

		//调试模式不发送短信 
		if(defined('DEBUG_CHECK_CODE') && DEBUG_CHECK_CODE) {
			$ret = true;
		}
		else {
			include_once UCT_PATH.'vendor/sms/smsbao.php';
			$ret = send_sms($s['mobile'], $s['content']);
		}
		$status = $ret ? 0 : 2;
		if($ret && $sp_uid) {
			SpLimitMod::decrease_current_sms_cnt(1, $sp_uid);
		}
		if($status != $s['status']) {
			Dba::write('update sms_record set status = '.$status.' where uid = '.$s['uid']);
		}

		return $ret;
	}

	/*
		通知管理员
		$msg = array('title', 'content')
	*/
	public static function notice_admin($msg) {
		$origin_id = SYS_WX_ORIGINID;
		$public_uid = Dba::readOne('select uid from weixin_public where origin_id = "'.$origin_id.'"');
		//todo  改一下
		$tid = 'KpiwXik_2753gtfbmI6R3FC5cTgdQfWuYPWMRJ1m1kQ';
		$open_ids = array(
			'oHlOkw35QmUACO--_oVtnJ7PHYWA', //刘路浩
		);

		$data = array(
			'template_id' => $tid,
			'topcolor' => '#DC143C',
			'data' => array(	
				'first' => array(
					'value' => '[快马加鞭] 管理员通知',
					'color' => 	'#C0C0C0',
				),
				'keyword1' => array(
					'value' => $msg['title'],
					'color' => 	'#FF0000',
				),
				'keyword2' => array(
					'value' => strip_tags($msg['content']), //简单去掉a标签
					'color' => '#173177',
				),
				'keyword3' => array(
					'value' => date('Y-m-d H:i:s'),
					'color' => 	'#C0C0C0',
				),
				'remark' => array(
					'value' => '',
					'color' => '#173177',
				),
			),
		);
		if(isset($msg['url'])) $data['url'] = $msg['url'];

		foreach($open_ids as $open_id) {
			$data['touser'] = $open_id;
			WeixinMod::send_template_msg($data, $public_uid);
		}

		return true;
	}

}

