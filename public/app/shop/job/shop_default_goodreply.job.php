<?php

//七天没评论默认好评
class Shop_Default_GoodreplyJob {
	//job 里运行的内容
	public function perform($order)
	{
		$oc['user_id'] = $order['user_id'];
		$oc['order_uid'] = $order['uid'];

		$oc['score']    = 5;
		$oc['brief']    = '5星好评';
		#$oc['images']   = requestStringArray('images', PATTERN_URL);
		$oc['shop_uid'] = $order['shop_uid'];
		foreach($order['products'] as $p){
			$oc['product_uid'] = intval($p['sku_uid']);
			CommentMod::add_product_comment($oc);
		}

	}

}

