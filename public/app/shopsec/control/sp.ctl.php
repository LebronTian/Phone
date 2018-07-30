<?php

class SpCtl {
	public function get_menu_array() {
		return array(
			array('name' => '首页', 'icon' => 'am-icon-home', 'link' => '?_a=shopsec&_u=sp', 'activeurl' => 'sp.index'),
		);
	}

	protected function sp_render($params = array())
	{
		$params['menu_array'] = $this->get_menu_array();
		render_sp_inner('', $params);
	}

	public function index() {
		redirectTo('?_a=shopsec&_u=sp.productkilllist');
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

	public function productkilllist()
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
		$option['is_kill']   = 1; //
		$option['info']      = 32; //

		$products   = ProductMod::get_shop_products($option, 0);
		$dtb = DistributionMod::get_dtb_rule_by_shop_uid($shop['uid']);

		$cats       = ProductMod::get_product_cats(array('shop_uid'         => $shop['uid'],
			'with_parent_info' => true,
			'parent_uid'       => -1));
		$pagination = uct_pagination($option['page'], ceil($products['count'] / $option['limit']),
			'?_a=shop&_u=sp.productkilllist&cat_uid=' . $option['cat_uid'] . '&low_stock=' . $option['low_stock'] . '&key='
			. $option['key'] . '&status=' . $option['status'] . '&limit=' . $option['limit'] . '&page=');
		//		var_dump(__file__.' line:'.__line__,$products);exit;
		$params = array('shop'       => $shop,
			'dtb'		 => $dtb,
			'option'     => $option,
			'products'   => $products,
			'cats'       => $cats,
			'pagination' => $pagination);

		$this->sp_render($params);
	}

}
