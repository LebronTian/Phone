<?php

class IndexCtl {
	public function index() {
	}


	/*
		uct 扫一扫获取邀请码
	*/
	public function uct_invite_code() {
		$origin_id = SYS_WX_ORIGINID;
		$public_uid = Dba::readOne('select uid from weixin_public where origin_id = "'.$origin_id.'"');
		if(!$public_uid) {
			exit('系统内部错误!');
		}
		
		$c = WxCodeMod::generate_wxcode_by_session_id($public_uid, WxCodeMod::WXCODE_TYPE_CHECK_CODE);
		if(!$c)	 {
			outError();
		}
		$ret = array('img_url' => $c['img_url']);
		if(defined('DEBUG_CHECK_CODE') && DEBUG_CHECK_CODE) {
			$ret['short_code'] = $c['short_code'];
		}

		outRight($ret);
	}

	/*
		uct 扫一扫设置uct代收款提现账号
	*/
	public function uct_uctpay_transfer() {
		$origin_id = SYS_WX_ORIGINID;
		$public_uid = Dba::readOne('select uid from weixin_public where origin_id = "'.$origin_id.'"');
		if(!$public_uid) {
			exit('系统内部错误!1');
		}
		
		$param = ''.AccountMod::get_current_service_provider('uid');
		$c = WxCodeMod::generate_wxcode_by_session_id($public_uid, WxCodeMod::WXCODE_TYPE_SET_UCTPAY_TRANSFER, $param);
		if(!$c)	 {
			outError();
		}
		$ret = array('img_url' => $c['img_url']);
		if(defined('DEBUG_CHECK_CODE') && DEBUG_CHECK_CODE) {
			//$ret['short_code'] = $c['short_code'];
		}

		outRight($ret);
	}

	/*
		uct 扫一扫绑定商户微信号
	*/
	public function uct_sp_wx() {
		$origin_id = SYS_WX_ORIGINID;
		$public_uid = Dba::readOne('select uid from weixin_public where origin_id = "'.$origin_id.'"');
		if(!$public_uid) {
			exit('系统内部错误!2');
		}
		
		$param = ''.AccountMod::get_current_service_provider('uid');
		$c = WxCodeMod::generate_wxcode_by_session_id($public_uid, WxCodeMod::WXCODE_TYPE_SET_SP_WX, $param);
		if(!$c)	 {
			outError();
		}
		$ret = array('img_url' => $c['img_url']);
		if(defined('DEBUG_CHECK_CODE') && DEBUG_CHECK_CODE) {
			//$ret['short_code'] = $c['short_code'];
		}

		outRight($ret);
	}

	/*
		商户微信扫一扫快捷登陆	
	*/
	public function uct_sp_scanlogin() {
		$c = SpScanloginMod::generate_sp_scanlogin_by_session_id();
		if(!$c)	 {
			outError();
		}
		$ret = array('img_url' => $c['img_url']);
		if(defined('DEBUG_CHECK_CODE') && DEBUG_CHECK_CODE) {
			//$ret['short_code'] = $c['short_code'];
		}

		outRight($ret);
	}

	public function poll_has_sp_login() {
		!AccountMod::has_sp_login() && SpScanloginMod::get_sp_scanlogin_by_session();

		outRight(AccountMod::has_sp_login());
	}

	public function poll_has_su_login() {
		!AccountMod::has_su_login() && WxScanloginMod::web_get_scanlogin_by_session();

		outRight(AccountMod::has_su_login());
	}

	/*
		手机扫一扫网页登录
	*/
	public function mobile_scanlogin() {
		if(!$su_uid = AccountMod::has_su_login()) {	
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if(!$uidm = requestString('uidm', PATTERN_UIDM)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(WxScanloginMod::mobile_scanlogin($su_uid, $uidm));
	}

	/*
		手机扫一扫网页登录确认
	*/
	public function mobile_scanlogin_confirm() {
		if(!$su_uid = AccountMod::has_su_login()) {	
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if(!$uidm = requestString('uidm', PATTERN_UIDM)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(WxScanloginMod::mobile_scanlogin_confirm($su_uid, $uidm));
	}

}

