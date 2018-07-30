<?php


class usign_WxPlugMod {
	public static function onWeixinNormalMsg() {

		self::Wxdousign();
	}	

	public static function onWeixinEventMsg() {
		//self::Wxdousign();
	}

	public static function Wxdousign()
	{
		$_REQUEST['sp_uid'] = AccountMod::get_current_service_provider('uid');
		if (!($usign_set = UsignMod::get_usign_set_sp()))
		{
			if (getLastError() == ERROR_BAD_STATUS)
			{
				$msg = '该签到已经下线!';
			}
			else
			{
				$msg = '签到内部错误! ' . getErrorString();
			}
			Weixin::weixin_reply_txt($msg);
		}
		$su_uid = AccountMod::get_current_service_user('uid');
		if(UsignMod::check_usign_status($su_uid))
		{
			$msg = '今天已签到过了';

		}
		else
		{
			UsignMod::do_usign($su_uid);
			$msg = '恭喜你，完成签到。'.(empty($GLOBALS['_TMP']['INFO_DATA'])?'':$GLOBALS['_TMP']['INFO_DATA']);
		}
		Weixin::weixin_reply_txt($msg);
	}
}

