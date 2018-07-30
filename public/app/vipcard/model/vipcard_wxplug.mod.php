<?php
/*
	自定义关键词回复

	注意 本插件要在默认回复插件之前加载
*/
class  Vipcard_WxPlugMod {

	public static function onWeixinNormalMsg() {
		$msg = '<a href="'.DomainMod::get_app_url('vipcard').'">会员卡</a>';
		Weixin::weixin_reply_txt($msg);
	}	

	public static function onWeixinEventMsg() {
	}	

	

}

