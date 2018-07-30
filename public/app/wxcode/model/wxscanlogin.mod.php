<?php

/*
	网页扫一扫登录

	web_ 开头的在网页端调用
	mobile_ 开头的在手机端调用
*/

class WxScanloginMod {
	const SCANLOGIN_STATUS_WAIT_SCAN = 0; //等待手机端扫描
	const SCANLOGIN_STATUS_WAIT_CONFIRM = 1; //等待手机端确认
	const SCANLOGIN_STATUS_OK = 2; //手机端确认登录

	/*
		生成一个网页扫一扫登录二维码 	
		把uidm通过二维码方式传递到手机端
	*/
	public static function web_generate_scanlogin_by_session_id() {
		if(!($session_id = session_id())) {
			setLastError(ERROR_DBG_STEP_1);
			return false;
		}
		
		//直接刷新一遍
		Dba::write('delete from wx_code where session_id = "'.addslashes($session_id).'"');
		$c = array('session_id' => $session_id, 
					'type' => WxCodeMod::WXCODE_TYPE_SCAN_LOGIN, 
					'param' => array('step' => WxScanloginMod::SCANLOGIN_STATUS_WAIT_SCAN),
					'expire_time' => $_SERVER['REQUEST_TIME'] + 60*10);
		Dba::insert('wx_code', $c);
		$c['uid'] = Dba::insertID();

		$c['uidm'] = $c['uid'].substr($session_id, 0, 4);
		return $c;
	}

	protected static function get_scanlogin_by_uidm($uidm) {
		$uid = substr($uidm, 0, -4);
		$session_pre = substr($uidm, -4);
		$c = Dba::readRowAssoc('select * from wx_code where uid = '.$uid);
		if(!$c || strncmp($session_pre, $c['session_id'], 4) || $c['type'] != WxCodeMod::WXCODE_TYPE_SCAN_LOGIN || $c['expire_time'] < $_SERVER['REQUEST_TIME']) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}

		$c['param'] && $c['param'] = json_decode($c['param'], true);
		return $c;
	}

	public static function web_get_scanlogin_by_session() {
		if(!($session_id = session_id())) {
			setLastError(ERROR_DBG_STEP_1);
			return false;
		}

		$c = Dba::readRowAssoc('select * from wx_code where session_id = "'.addslashes($session_id).'"');
		if(!$c || $c['type'] != WxCodeMod::WXCODE_TYPE_SCAN_LOGIN || $c['expire_time'] < $_SERVER['REQUEST_TIME']) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}

		$c['uidm'] = $c['uid'].substr($c['session_id'], 0, 4);
		$c['param'] && $c['param'] = json_decode($c['param'], true);

		//自动登录一下
		if(($c['param']['step'] == WxScanloginMod::SCANLOGIN_STATUS_OK)) {
			$_SESSION['su_login'] = $_SESSION['su_uid'] = $c['param']['su_uid'];
		}
		return $c;
	}

	/*
		手机扫一扫网页登录
	*/
	public static function mobile_scanlogin($su_uid, $uidm) {
		if(!($sl = WxScanloginMod::get_scanlogin_by_uidm($uidm)) ||
			$sl['param']['step'] != WxScanloginMod::SCANLOGIN_STATUS_WAIT_SCAN) {
			if($sl['param']['step'] == WxScanloginMod::SCANLOGIN_STATUS_WAIT_CONFIRM) {
				return true;
			}
			setLastError(ERROR_BAD_STATUS);
			return false;
		}
		
		$update = array('uid' => $sl['uid'], 'param' => array('step' => WxScanloginMod::SCANLOGIN_STATUS_WAIT_CONFIRM,
						'su_uid' => $su_uid, 
					));
		return Dba::update('wx_code', $update, 'uid = '.$sl['uid']);
	}

	/*
		手机扫一扫网页登录
	*/
	public static function mobile_scanlogin_confirm($su_uid, $uidm) {
		if(!($sl = WxScanloginMod::get_scanlogin_by_uidm($uidm)) ||
			($sl['param']['step'] != WxScanloginMod::SCANLOGIN_STATUS_WAIT_CONFIRM) ||
			($sl['param']['su_uid'] != $su_uid)) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}
		
		$update = array('uid' => $sl['uid'], 'param' => array('step' => WxScanloginMod::SCANLOGIN_STATUS_OK,
						'su_uid' => $su_uid, 
					));
		return Dba::update('wx_code', $update, 'uid = '.$sl['uid']);
	}

		
}


