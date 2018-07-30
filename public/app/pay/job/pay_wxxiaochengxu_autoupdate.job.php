<?php

/*
	xiaochengxu支付5分钟后自动刷新一下订单状态
*/
class Pay_Wxxiaochengxu_AutoupdateJob {
	public function  perform($oid) {
		$shop_uid = Dba::readOne('select shop_uid from shop_order where uid = '.substr($oid, 1));
		if(!$shop_uid) return;
		$sp_uid = Dba::readOne('select sp_uid from shop where uid = '.$shop_uid);
		if(!$sp_uid) return;
		$uct_token = Dba::readOne('select uct_token from service_provider where uid = '.$sp_uid);		
		if(!$uct_token) return;
		$_REQUEST['_sp_uid'] = $sp_uid;		

		#$url = 'http://weixin.uctphp.com/?_a=pay&_u=index.wxxiaochengxu_update_order&oid='.$oid.'&_uct_token='.$uct_token;
		$url = AccountMod::require_wx_redirect_uri().'/?_a=pay&_u=index.wxxiaochengxu_update_order&oid='.$oid.'&_uct_token='.$uct_token;
		echo 'update xiaochengxu order '.$oid.'-> '.file_get_contents($url);
	}
}




