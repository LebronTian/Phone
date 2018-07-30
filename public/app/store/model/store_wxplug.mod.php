<?php


class  Store_WxPlugMod {
	public static function onWeixinNormalMsg() {
	#	$msg = '呵呵 <a href="'.'http://'.$_SERVER['HTTP_HOST'].'?WEIXINSESSIONID='.WeixinMod::get_a_weixin_session_id().'">点击进入</a>';
	#	Weixin::weixin_reply_txt($msg);
	}	

	public static function onWeixinEventMsg() {
	}	
}

