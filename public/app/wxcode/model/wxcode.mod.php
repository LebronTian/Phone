<?php

/*
	微信验证码
*/
class WxCodeMod {
	const WXCODE_TYPE_CHECK_CODE = 0; //验证码
	const WXCODE_TYPE_SET_UCTPAY_TRANSFER = 1; //设置uct代收款提现用户
	const WXCODE_TYPE_SCAN_LOGIN = 2; //扫一扫登录

	const WXCODE_TYPE_EXPTUI_TRACK = 3; //快递推扫码关注追踪
	const WXCODE_TYPE_QRPOSTER  = 4; //关注海报
		
	const WXCODE_TYPE_SET_SP_WX = 5; //绑定商户微信号
	const WXCODE_TYPE_SCAN_SP_LOGIN = 6; //扫一扫商户登录


	/*
		生成一个二维码和验证码

		@param $session_id 唯一值, 可以自己生成也可以使用默认

		目前使用了自定义值的情况
		exptui_track_{$track_uid}
		qrposter_{$su_uid}

		@return 返回 成功 array('img_url' => 临时二维码地址, 'uid' => 场景唯一uid) ,失败 false
	*/
	public static function generate_wxcode_by_session_id($public_uid = 0, $type = WxCodeMod::WXCODE_TYPE_CHECK_CODE, $param='', $session_id = '') {

		if(!$session_id && !($session_id = session_id())) {
			setLastError(ERROR_DBG_STEP_1);
			return false;
		}
		
		if(!($c = Dba::readRowAssoc('select * from wx_code where session_id = "'.addslashes($session_id).'"'))) {
			$c = array('session_id' => $session_id, 'short_code' => rand(100000, 999999), 'type' => $type, 'param' => $param);
			Dba::insert('wx_code', $c);
			$c['uid'] = Dba::insertID();
		}
		
		//$param 不能这样比
		if(($c['type'] != $type) /*|| ($c['param'] != $param)*/) {
			Dba::write('delete from wx_code where session_id = "'.addslashes($session_id).'"');
			setLastError(ERROR_DBG_STEP_2);
			Weixin::weixin_log('warning! wxcode type already exist! just delete all '.$c['uid']);
			return false;
		}

		if(!empty($c['img_url']) && $c['expire_time'] > $_SERVER['REQUEST_TIME']) {
			return $c;
		}
		
		if(!($c['img_url'] = WeixinMod::get_temp_qrcode($c['uid'], $public_uid))) {
			return false;
		}

		//todo 二维码的失效时间
		$c['expire_time'] =  $_SERVER['REQUEST_TIME'] + 86400 * 30;
		Dba::update('wx_code', $c, 'uid = '.$c['uid']);

		return $c;
	}

	/*
		
	*/
	public static function get_wxcode_by_scene_uid($scene_id) {
		$c = Dba::readRowAssoc('select * from wx_code where uid = '.$scene_id);
		if(!$c || $c['expire_time'] < $_SERVER['REQUEST_TIME']) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}

		return $c;
	}

	public static function get_wxcode_by_session_id($session_id = '') {
		if(!$session_id && !($session_id = session_id())) {
			setLastError(ERROR_DBG_STEP_1);
			return false;
		}
		
		$c = Dba::readRowAssoc('select * from wx_code where session_id = "'.addslashes($session_id).'"');
		if(!$c || $c['expire_time'] < $_SERVER['REQUEST_TIME']) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}

		return $c;
	}

	public static function check_short_code($code) {
		return ($c = WxCodeMod::get_wxcode_by_session_id()) && ($c['short_code'] == $code);
	}

}

