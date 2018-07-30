<?php

class SpCtl {
	public function get_menu_array() {
		return array(
			array('name' => '首页', 'icon' => 'am-icon-home', 'link' => '?_a=shopbiz&_u=sp', 'activeurl' => 'sp.index'),
		);
	}

	protected function sp_render($params = array())
	{
		$params['menu_array'] = $this->get_menu_array();
		render_sp_inner('', $params);
	}

	public function index() {
		redirectTo('?_a=shopbiz&_u=sp.bizlist');
	}

	/*
	 * 商家入驻基本设置
	 */
	public function biz_set(){
		uct_use_app('shop');
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}

		$key = 'biz_set'.$shop['uid'];

		if(!$GLOBALS['arraydb_sys'][$key]){
			$GLOBALS['arraydb_sys'][$key] = json_encode(array('default_status'=>'1'));
		}

		$data = $GLOBALS['arraydb_sys'][$key];

		$params = array('shop' => $shop, 'data' => json_decode($data,true));
		$this->sp_render($params);
	}

	/*
		商家入驻	
	*/
	public function bizlist() {
		uct_use_app('shop');
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['shop_uid'] = $shop['uid'];
		$option['key']      = requestString('key', PATTERN_SEARCH_KEY);
		$option['status']   = requestInt('status', -1);
		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 10);

		$data = ShopBizMod::get_shop_biz_list($option);
		$pagination = uct_pagination($option['page'], ceil($data['count'] / $option['limit']),
			'?_a=shop&_u=sp.bizlist&status=' . $option['status'] . '&limit=' . $option['limit'] . '&page=');

		$params = array('shop' => $shop,'option' => $option, 'data' => $data, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	/*
	 *
	 */
	public function biz_know()
	{
		uct_use_app('shop');
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['shop_uid'] = $shop['uid'];
		$option['type_in'] = 4;
		$document = DocumentMod::get_documents_know($option);

		$params     = array('shop' => $shop,'document' => $document);
		$this->sp_render($params);
	}

	/*
		添加编辑商家
	*/
	public function addbiz() {
		uct_use_app('shop');
		if (!($shop = ShopMod::get_shop_by_sp_uid())) {
			return $this->error();
		}
		if(!($uid = requestInt('uid')) || !($biz = ShopBizMod::get_shop_biz_by_uid($uid)) ||
			($biz['shop_uid'] != $shop['uid'])) {
			$biz = array();
		}

		$parents    = ShopBizMod::get_biz_cats(array('shop_uid'         => $shop['uid'],
			'with_parent_info' => true,
			'parent_uid'       => -1));

		$params = array('shop' => $shop, 'biz' => $biz, 'parents'=>$parents);
		$this->sp_render($params);
	}

	/*
		商家详情
	*/
	public function bizdetail() {
		uct_use_app('shop');
		if (!($shop = ShopMod::get_shop_by_sp_uid())) {
			return $this->error();
		}
		if(!($uid = requestInt('uid')) || !($biz = ShopBizMod::get_shop_biz_by_uid($uid)) ||
			($biz['shop_uid'] != $shop['uid'])) {
			redirectTo('?_a=shopbiz&_u=sp.bizlist');
		}

		$parents    = ShopBizMod::get_biz_cats(array('shop_uid'         => $shop['uid'],
			'with_parent_info' => true,
			'parent_uid'       => -1));

		$params = array('shop' => $shop, 'biz' => $biz, 'parents'=>$parents);
		$this->sp_render($params);
	}

	/*
	 * 商家分类列表
	 */
	public function bizcatlist(){
		uct_use_app('shop');
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['shop_uid']         = $shop['uid'];
		$option['parent_uid']       = requestInt('parent_uid');

		$cats    = ShopBizMod::get_biz_cats($option);

		$params = array('shop'    => $shop,
			'option'  => $option,
			'cats'    => $cats
		);
		$this->sp_render($params);
	}

	/*
    添加编辑分类页面
	*/
	public function addbizcat()
	{
		uct_use_app('shop');
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$cat_uid = requestInt('uid');
		$cat     = array();

		if ($cat_uid)
		{
			$cat = ShopBizMod::get_biz_cat_by_uid($cat_uid);
			if (!$cat || ($cat['shop_uid'] != $shop['uid']))
			{
				$cat = array();
			}
		}

		$params  = array('shop' => $shop, 'cat' => $cat);
		$this->sp_render($params);
	}

	/*
	 * 商家优惠券页面
	 */
	public function bizcoupon(){
		uct_use_app('shop');
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}

		if(!($option['biz_uid'] = requestInt('biz_uid'))){
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$biz = ShopBizMod::get_shop_biz_by_uid($option['biz_uid'] );

		$option['key']      = requestString('key', PATTERN_SEARCH_KEY);
		$option['status']   = requestInt('status');
		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 10);

		$data = BizCouponMod::get_biz_coupon_list($option);

		$pagination = uct_pagination($option['page'], ceil($data['count'] / $option['limit']),
			'?_a=shop&_u=sp.bizcoupon&biz_uid=' . $option['biz_uid'] . '&limit=' . $option['limit'] . '&page=');

		$params = array('shop' => $shop,'biz' => $biz,'option' => $option, 'data' => $data, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	/*
	添加编辑优惠劵
	*/
	public function addbizcoupon()
	{
		uct_use_app('shop');
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		if(!($biz_uid = requestInt('biz_uid'))){
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$biz   = ShopBizMod::get_shop_biz_by_uid($biz_uid);

		$coupon_uid = requestInt('uid');
		$coupon     = array();
		if ($coupon_uid)
		{
			$coupon = BizCouponMod::get_biz_coupon_by_uid($coupon_uid);
			if (!$coupon || ($coupon['biz_uid'] != $biz['uid']))
			{
				$coupon = array();
			}
		}

		$params = array('shop' => $shop,'biz' => $biz, 'coupon' => $coupon);
		$this->sp_render($params);
	}

	/*
	 * 优惠券领取页
	 */
	public function bizusercoupon(){
		uct_use_app('shop');
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}

		$option['coupon_uid'] = requestInt('coupon_uid');

		$coupon = '';
		if($option['coupon_uid']){
			$coupon = BizCouponMod::get_biz_coupon_by_uid($option['coupon_uid'] );
		}
		$option['biz_uid'] = requestInt('biz_uid');
		//$option['key']      = requestString('key', PATTERN_SEARCH_KEY);
		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 10);

		$data = BizCouponMod::get_user_coupon_list($option);

		$pagination = uct_pagination($option['page'], ceil($data['count'] / $option['limit']),
			'?_a=shop&_u=sp.bizusercoupon&biz_uid=' . $option['biz_uid'] . '&coupon_uid=' . $option['coupon_uid'] . '&limit=' . $option['limit'] . '&page=');

		$params = array('shop' => $shop,'coupon' => $coupon,'option' => $option, 'data' => $data, 'pagination' => $pagination);
		$this->sp_render($params);
	}

}

