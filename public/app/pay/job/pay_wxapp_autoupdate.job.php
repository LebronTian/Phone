<?php

/*
	app支付5分钟后自动刷新一下订单状态
*/
class Pay_Wxapp_AutoupdateJob {
	public function  perform($oid) {
		$url = 'http://weixin.uctphp.com/?_a=pay&_u=index.wxapp_update_order&oid='.$oid;
		echo 'update app order '.$oid.'-> '.file_get_contents($url);
	}
}




