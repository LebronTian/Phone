<?php

//15分钟自动取消订单
class Shop_auto_cancelJob {
	//job 里运行的内容 $order['uid']
	public function perform($order)
	{
		//先看一下有没有支付成功
		$sp_uid = Dba::readOne('select sp_uid from shop where uid = '.$order['shop_uid']);
		$uct_token = Dba::readOne('select uct_token from service_provider where uid = '.$sp_uid);		
		$_REQUEST['_sp_uid'] = $sp_uid;		
		
		$url = AccountMod::require_wx_redirect_uri().'/?_a=pay&_u=index.wxxiaochengxu_update_order&oid=b'.$order['uid'].
				'&_uct_token='.$uct_token;
		echo 'update xiaochengxu order '.$order['uid'].'-> '.file_get_contents($url);

		uct_use_app('shop');
		$o = OrderMod::get_order_by_uid($order['uid']);
		if($o && ($o['status'] == OrderMod::ORDER_WAIT_USER_PAY) && 
			($o['create_time'] < time() - 60*15)) {
			Event::addHandler('AfterCancelOrder', array('OrderMod', 'onAfterCancelOrder'));
			OrderMod::do_cancel_order($o);
		}

	}

}

