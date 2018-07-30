<?php

// 15分钟未支付取消订单  不再使用
class Shop_Indiana_CancelJob {
	//job 里运行的内容
	public function perform($uid)
	{
		$o = IndianaMod::get_indiana_order_by_uid($uid);
		if($o) {
			IndianaMod::do_cancel_order($o);
		}
	}

}

