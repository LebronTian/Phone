<?php
/*
	关注欢迎插件
*/

class Welcome_WxPlugMod {
	public static function onWeixinEventMsg() {
		if(WeixinMod::get_weixin_xml_args('Event') === 'subscribe') {
			//给其他模块处理机会
			Event::handle('WeixinSubscribeMsg');

			self::onWeixinNormalMsg();
		}
	}

	//支持关键字触发
	public static function onWeixinNormalMsg() {
		//$msg = AccountMod::get_current_service_user('name').' 感谢您关注 '.AccountMod::get_current_service_provider('name');
		//刷新一下用户资料
		$su_uid = WeixinMod::get_current_weixin_fan('su_uid');
		Queue::do_job_at(1, 'su_updateinfoJob', array($su_uid));	

		$msg = self::get_public_welcome_msg();
		if($msg) {
			WeixinMediaMod::weixin_reply_media($msg);
		}
	}

	/*
		获取公众号欢迎内容
	*/
	public static function get_public_welcome_msg($uid = 0) {
		if(!$uid && !($uid = WeixinMod::get_current_weixin_public('uid'))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}

		$key = 'welcome_'.$uid;
		$msg = $GLOBALS['arraydb_weixin_public'][$key];
		if(!$msg || !($msg = json_decode($msg, true))) {
			setLastError(ERROR_DBG_STEP_1);
			return false;
		}
		if($msg && is_numeric($msg)){
			//$msg = htmlspecialchars($msg);
			$msg = WeixinMediaMod::func_get_weixin_media($msg);
		}

		return $msg;
	}

	/*
		设置公众号欢迎内容
	*/
	public static function set_public_welcome_msg($msg, $uid = 0) {
		if(!$uid && !($uid = WeixinMod::get_current_weixin_public('uid'))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}

		if(!empty($msg['media_uid'])) {
			if(!($msg = WeixinMediaMod::get_weixin_media_by_uid($msg['media_uid'])) || 
				($msg['sp_uid'] != AccountMod::get_current_service_provider('uid'))) {
				setLastError(ERROR_DBG_STEP_1);
				return false;
			}
		}
		
		$key = 'welcome_'.$uid;
		$GLOBALS['arraydb_weixin_public'][$key] = json_encode($msg);

		return true;
	}

}


