<?php

/*
	扫一扫登录商户管理后台

*/

class SpScanloginMod {
	/*
		生成一个网页扫一扫登录二维码 	
		把uidm通过二维码方式传递到手机端
	*/
	public static function generate_sp_scanlogin_by_session_id() {
		$origin_id = SYS_WX_ORIGINID;
		$public_uid = Dba::readOne('select uid from weixin_public where origin_id = "'.$origin_id.'"');
		if(!$public_uid) {
			exit('系统内部错误10!');
		}

		return WxCodeMod::generate_wxcode_by_session_id($public_uid, WxCodeMod::WXCODE_TYPE_SCAN_SP_LOGIN);
	}

	public static function get_sp_scanlogin_by_session() {
		if(!($session_id = session_id())) {
			setLastError(ERROR_DBG_STEP_1);
			return false;
		}

		$c = Dba::readRowAssoc('select * from wx_code where session_id = "'.addslashes($session_id).'"');
		if(!$c || $c['type'] != WxCodeMod::WXCODE_TYPE_SCAN_SP_LOGIN || $c['expire_time'] < $_SERVER['REQUEST_TIME']) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}

		$c['param'] && $c['param'] = json_decode($c['param'], true);

		//自动登录一下
		if(!empty($c['param']['sp_uid'])) {
			$_SESSION['sp_login'] = $_SESSION['sp_uid'] = $c['param']['sp_uid'];
			$_SESSION['uct_token'] = Dba::readOne('select uct_token from service_provider where uid = '
													.$_SESSION['sp_uid']);
			if(!empty($c['param']['sub_sp_uid'])) {
				$_SESSION['subsp_login'] = $_SESSION['subsp_uid'] = $c['param']['sub_sp_uid'];
				$_SESSION['uct_token'] = Dba::readOne('select uct_token from sub_sp where uid = '
														.$_SESSION['sub_sp_uid']);
			}
		}

		return $c;
	}

	/*
		微信扫一扫商户登录
	*/
	public static function on_sp_scanlogin_confirm($open_id, $c) {
		uct_use_app('sp');
		if(!$sw = SpwxMod::get_sp_wx_by_openid($open_id)) {
			//todo 可以注册一个新商户？

			return '您尚未绑定商户号,无法使用快捷登陆！';
			return false;
		}

		if(!empty($sw['cfg']['disable_login'])) {
			
			return '此微信号权限不足,无法使用快捷登陆！';
			return false;
		}

		$update = array('uid' => $c['uid'], 'param' => array(
						'sp_uid' => $sw['sp_uid'], 'sub_sp_uid' => $sw['sub_sp_uid'], 
					));
		$ret = Dba::update('wx_code', $update, 'uid = '.$c['uid']);

		return '商户快捷登陆成功，请刷新页面！';
		return $ret;
	}

		
}


