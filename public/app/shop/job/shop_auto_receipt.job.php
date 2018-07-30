<?php

//15天自动收货
class Shop_auto_receiptJob {
	//job 里运行的内容
	public function perform($order)
	{
		uct_use_app('shop');
		$o = OrderMod::get_order_by_uid($order['uid']);
		if($o && ($o['status'] == OrderMod::ORDER_WAIT_USER_RECEIPT) &&
			($o['send_time'] < time() - 86400*15)) {
			Event::addHandler('AfterRecvGoods', array('OrderMod', 'onAfterRecvGoods'));
			OrderMod::do_recv_goods($o);
		}

	}

}

