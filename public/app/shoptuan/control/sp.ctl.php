<?php

class SpCtl {
	public function get_menu_array() {
		return array(
			array('name' => '首页', 'icon' => 'am-icon-home', 'link' => '?_a=shoptuan&_u=sp', 'activeurl' => 'sp.index'),
		);
	}

	protected function sp_render($params = array())
	{
		$params['menu_array'] = $this->get_menu_array();
		render_sp_inner('', $params);
	}

	public function index() {
		redirectTo('?_a=shoptuan&_u=sp.productgrouplist');
	}

	//团购商品
	public function productgrouplist()
	{
		uct_use_app('shop');
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['shop_uid']  = $shop['uid'];
		$option['cat_uid']   = requestInt('cat_uid');
		$option['uid']       = requestInt('uid');
		$option['key']       = requestString('key', PATTERN_SEARCH_KEY);
		$option['page']      = requestInt('page');
		$option['limit']     = requestInt('limit', 10);
		$option['low_stock'] = requestInt('low_stock', -1); //低库存
		$option['status']    = requestInt('status', -1); //
		$option['is_group'] = 1;

		$products   = ProductMod::get_shop_products($option, 0);
		$dtb = DistributionMod::get_dtb_rule_by_shop_uid($shop['uid']);

		$cats       = ProductMod::get_product_cats(array('shop_uid'         => $shop['uid'],
			'with_parent_info' => true,
			'parent_uid'       => -1));
		$pagination = uct_pagination($option['page'], ceil($products['count'] / $option['limit']),
			'?_a=shop&_u=sp.productgrouplist&cat_uid=' . $option['cat_uid'] . '&low_stock=' . $option['low_stock'] . '&key='
			. $option['key'] . '&status=' . $option['status'] . '&limit=' . $option['limit'] . '&page=');
		$params = array('shop'       => $shop,
			'dtb'		 => $dtb,
			'option'     => $option,
			'products'   => $products,
			'cats'       => $cats,
			'pagination' => $pagination);

		$this->sp_render($params);
	}

	public function orderlist()
	{
		uct_use_app('shop');
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['shop_uid'] = $shop['uid'];
		$option['user_id']  = requestInt('user_id');
		$option['status']   = requestInt('status');
		$option['key']      = requestString('key', PATTERN_SEARCH_KEY);
		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 10);
		$option['is_group'] = 1;

		$today       = strtotime('today');
		if(isset($_REQUEST['start_time'])) {
		$option['start_time']  = requestInt('start_time');
		$option['start_time']  = (empty($option['start_time']) ? strtotime(date('Y-01',time())) : ($option['start_time']- 8 * 60 * 60 +1));  //JS 提交 是8时
		}
		if(isset($_REQUEST['end_time'])) {
		$option['end_time']    = requestInt('end_time');
		$option['end_time']    = (empty($option['end_time']) ? ($today + 24 * 60 * 60 - 1) : ($option['end_time'] + 16 * 60 * 60 -1));   //JS 提交 是8时
		}

		isset($_REQUEST['is_group']) && $option['is_group']  = requestBool('is_group');
		$orders     = OrderMod::get_order_list($option);
		$pagination = uct_pagination($option['page'], ceil($orders['count'] / $option['limit']),
			'?_a=shop&_u=sp.orderlist&status=' . $option['status'] . '&limit=' . $option['limit'] . '&page=');

		$params = array('shop' => $shop, 'option' => $option, 'data' => $orders, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	/*
		添加编辑商品
	*/
	public function addproduct()
	{
		uct_use_app('shop');
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$product_uid = requestInt('uid');
		$product     = array();
		if ($product_uid)
		{
			$product = ProductMod::get_shop_product_by_uid($product_uid, 0);
			if (!$product || ($product['shop_uid'] != $shop['uid']))
			{
				$product = array();
			}
		}

		if(!$product && ($product_uid=requestInt('copy_uid'))) {
			$product = ProductMod::get_shop_product_by_uid($product_uid, 0);
			if (!$product || ($product['shop_uid'] != $shop['uid']))
			{
				$product = array();
			}else{
				$product['copy_uid'] = $product_uid;
			}

			unset($product['uid']);
		}

		$parents    = ProductMod::get_product_cats(array('shop_uid'         => $shop['uid'],
		                                                 'with_parent_info' => true,
		                                                 'parent_uid'       => -1));
		$deliveries = DeliveryMod::get_shop_delivery($shop['uid']);
		$page = requestInt('page');//跳回本来的页数
		$params     = array('shop' => $shop, 'product' => $product, 'parents' => $parents, 'deliveries' => $deliveries,'page'=>$page);
		$this->sp_render($params);
	}

}

