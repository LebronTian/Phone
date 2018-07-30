<?php


class  Site_WxPlugMod {
	public static function onWeixinNormalMsg() {
		#$msg = '<a href="'.'http://'.$_SERVER['HTTP_HOST'].'?WEIXINSESSIONID='.WeixinMod::get_a_weixin_session_id().'">点击进入</a>';
		$msg = '<a href="'. DomainMod::get_app_url('site') .'">点击进入微官网</a>';
		Weixin::weixin_reply_txt($msg);
	}	

	public static function onWeixinEventMsg() {
	}	
}

