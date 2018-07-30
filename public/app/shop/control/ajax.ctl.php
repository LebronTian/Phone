<?php
/**
 * 求两个已知经纬度之间的距离,单位为米
 *
 * @param lng1 $ ,lng2 经度
 * @param lat1 $ ,lat2 纬度
 * @return float 距离，单位米
 */
function getdistance($lng1, $lat1, $lng2, $lat2) {
	// 将角度转为狐度
	$radLat1 = deg2rad($lat1); //deg2rad()函数将角度转换为弧度
	$radLat2 = deg2rad($lat2);
	$radLng1 = deg2rad($lng1);
	$radLng2 = deg2rad($lng2);
	$a = $radLat1 - $radLat2;
	$b = $radLng1 - $radLng2;
	$s = 2 * asin(sqrt(pow(sin($a / 2), 2) + cos($radLat1) * cos($radLat2) * pow(sin($b / 2), 2))) * 6378.137 * 1000;
	return $s;
}
/*
	前端接口
*/

class AjaxCtl {
	public function init_shop()
	{
		if (!($shop = ShopMod::get_shop()))
		{
			if (getLastError() == ERROR_BAD_STATUS)
			{
				echo '该网站已经下线!';
			}
			else
			{
				echo '微商城内部错误! ' . getErrorString();
			}
			exit();
		}

		$visit_record = array(
			'shop_uid'=>$shop['uid'],
			'su_uid'=>AccountMod::has_su_login(),
			's_a_uid'=>AgentMod::require_agent(),
			'product_uid'=>(($GLOBALS['_UCT']['ACT']!='product')?0:requestInt('uid'))
		);
		//主页，使用slides幻灯片代替
		$visit_record_act = array('slides','products','product');
		//微商城统计代码 只统计 主页 商品列表 商品详情页的访问情况
		in_array($GLOBALS['_UCT']['ACT'],$visit_record_act) && ShopMod::add_shop_visit_record($visit_record);

		return $shop;
	}
	
	public function shop() {
		$shop = $this->init_shop();
		$shop['phone'] = Dba::readOne('select phone from service_provider_profile where uid = '.$shop['sp_uid']);
		$shop['address'] = Dba::readRowAssoc('select lng,lat from service_provider_profile where uid ='.$shop['sp_uid']);

		if(!isset($GLOBALS['arraydb_sys']['cfg_set_shop_discount'.$shop['uid']])){
			$data['sendscope'] = 0;
			$data['point_limit'] = 0;
			$data['discount_limit'] = 5000;
			$data['discount'] = 100;
			$GLOBALS['arraydb_sys']['cfg_set_shop_discount'.$shop['uid']] = json_encode($data);
		}
		$point = $GLOBALS['arraydb_sys']['cfg_set_shop_discount'.$shop['uid']];
		$shop['point'] = json_decode($point,true);
		
		if(!isset($GLOBALS['arraydb_sys']['cfg_shop_setcolor_1'.$shop['sp_uid']])){
			$GLOBALS['arraydb_sys']['cfg_shop_setcolor_1'.$shop['sp_uid']] = '3CAE48';
		}
		$shop['color1'] = $GLOBALS['arraydb_sys']['cfg_shop_setcolor_1'.$shop['sp_uid']];
		if(!isset($GLOBALS['arraydb_sys']['cfg_shop_setcolor_2'.$shop['sp_uid']])){
			$GLOBALS['arraydb_sys']['cfg_shop_setcolor_2'.$shop['sp_uid']] = 'FFFFFF';
		}
		$shop['color2'] = $GLOBALS['arraydb_sys']['cfg_shop_setcolor_2'.$shop['sp_uid']];
		outRight($shop);
	}
	
	/*
		获取各种状态订单的数目
	*/
	public function status_cnt() {
		$shop = $this->init_shop();
		if (!$su_uid = AccountMod::has_su_login()) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		$option['sp_uid'] = $shop['uid'];
		$option['user_id'] = $su_uid;
		$cnt = OrderMod::get_count_order_by_status($option);
		outRight($cnt);	
	}

	/*
	    广播例表
	*/
	public function radio_list(){
		$shop = $this->init_shop();
		$option['shop_uid'] = $shop['uid'];
		$option['type_in'] = 0;
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
		$documents = DocumentMod::get_documents_radio($option);
		outRight($documents);
	}

	/**/
	public function shop_radio() {
		$shop = $this->init_shop();
		if(!$uid = requestInt('uid')) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$doc = DocumentMod::get_document_by_uid($uid);
		outRight($doc);
	}

	/*
		获取商品列表
	*/
	public function products()
	{
		$shop               = $this->init_shop();
		$option['shop_uid'] = $shop['uid'];
		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 10);
		$option['key']      = requestString('key', PATTERN_SEARCH_KEY);
		$option['sort']     = requestInt('sort');
		$option['cat_uid']  = requestInt('cat_uid');
		//获取分类子项
		if(!empty($option['cat_uid'])){
			$cats = ProductMod::get_all_sons_product_cats(array('shop_uid'=>$shop['uid'],'uid'=>$option['cat_uid']));
			if(!is_array($option['cat_uid'])){
				$option['cat_uid'] = array($option['cat_uid']);
			}
			foreach($cats as $c){
				array_push($option['cat_uid'],$c['uid']);
				foreach($c['son_cats'] as $sc){
					array_push($option['cat_uid'],$sc['uid']);
				}
			}
		}
		//指定商家的商品 
		$option['biz_uid']  = requestInt('biz_uid');
		//只要平台的商品
		isset($_REQUEST['is_biz']) && $option['is_biz'] = requestBool('is_biz');
		//是否为团购商品
		isset($_REQUEST['is_group']) && $option['is_group'] = requestBool('is_group');
		$option['status']   = 0; //只要上架的商品
		if (isset($_REQUEST['ukeys']))
		{
			//多选分类搜索 如 {品牌:[iphone, nokia], 厂家:[富士康]}
			if (!($option['ukeys'] = requestKvJson('ukeys')))
			{
				$option['ukeys'] = true;
			}
		}
		isset($_REQUEST['uids']) && $option['uids'] = requestIntArray('uids');

		//32秒杀商品 64 热门商品, 128 推荐商品
		isset($_REQUEST['info']) && $option['info'] = requestInt('info');
		$products = ProductMod::get_shop_products($option);

		outRight($products);
	}

	//商品全部分类
	public function product_cats() {
		$shop               = $this->init_shop();
        $cats = ProductMod::get_product_cats(array('shop_uid' => $shop['uid'],'status' => 0));
		outRight($cats);
	}
	//商品分类 parent_uid
	public function product_cats_by_parent_uid(){
		$shop               = $this->init_shop();
		$option['shop_uid'] = $shop['uid'];
		$option['parent_uid'] = requestInt('parent_uid');
		$cats = ProductMod::get_product_cats($option);
		outRight($cats);
	}
	//商家分类 parent_uid
	public function biz_cats(){
		$shop               = $this->init_shop();
		$option['shop_uid'] = $shop['uid'];
		$option['parent_uid'] = requestInt('parent_uid');
		$option['status'] = requestInt('status');
		$cats = ShopBizMod::get_biz_cats($option);
		outRight($cats);
	}

	//首页轮播图
	public function slides() {
		$shop               = $this->init_shop();
		$slides_in = requestInt('slides_in', 0);
        $slides = ShopMod::get_shop_slides(array('shop_uid' => $shop['uid'], 'status' => 0, 'slides_in' => $slides_in));

		outRight($slides);
	}

	/*
    	商品
	*/
	public function product()
	{
		$shop = $this->init_shop();
		//商品uid
		if (!$uid = requestInt('uid')) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		outRight(ProductMod::get_shop_product_by_uid($uid));
	}

	/*
    商品content
	*/
	public function product_content()
	{
		if (!$option['product_uid'] = requestInt('uid'))
		{ //商品uid
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$content = ProductMod::get_product_content($option['product_uid']);

		outRight($content);
	}

	/*
		类似商品
	*/
	public function similar_products()
	{
		$shop = $this->init_shop();
		if (!$option['product_uid'] = requestInt('uid'))
		{ //商品uid
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 5);
		$option['status']   = 0; //只要上架的商品
		$option['shop_uid'] = $shop['uid'];

		$products = FavMod::suggest_products($option);

		outRight($products);
	}

	/*
		猜你喜欢商品
	*/
	public function recommend_products()
	{
		$shop = $this->init_shop();
		if (!$su_uid = AccountMod::has_su_login())
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 5);
		$option['status']   = 0; //只要上架的商品
		$option['shop_uid'] = $shop['uid'];
		$option['sort']     = SORT_SALSE_COUNT_DESC;

		$products = ProductMod::get_shop_products($option);

		outRight($products);
	}

	/*
		商品评论列表
		重复
		@see get_product_comments
	*/
	public function comments()
	{
		$shop = $this->init_shop();

		if (!($option['product_uid'] = requestInt('uid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$option['page']   = requestInt('page');
		$option['limit']  = requestInt('limit', 10);
		$cfg = CommentMod::get_comment_cfg($shop['uid']);
		if(!empty($cfg['need_check'])) {
			$option['status'] = 1;//审核成功
		} else {
			$option['no_need_check'] = 1;//默认显示
		}
			
		$option['shop_uid'] = $shop['uid'];
		$comment          = CommentMod::get_product_comments($option);
		outRight($comment);
	}

	/*
		购物车商品列表
	*/
	public function cart()
	{
		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}

		outRight(OrderMod::get_shop_cart($shop['uid'], $su_uid));
	}

	/*
		添加到购物车, 会自动覆盖重复添加
	*/
	public function add_to_cart()
	{
		$shop = $this->init_shop();
		if (!($item['user_id'] = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if (!($item['sku_uid'] = requestString('sku_uid', PATTERN_SKU_UID)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (($item['quantity'] = requestInt('quantity', 1)) <= 0)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
//		if (!($item['date_time'] = requestString('date_time')))
//		{
//			outError(ERROR_INVALID_REQUEST_PARAM);
//		}
		$item['date_time'] = requestString('date_time',null);	
		$item['shop_uid'] = $shop['uid'];

		outRight(OrderMod::add_to_shop_cart($item));
	}

	/*
		删除购物车内商品
	*/
	public function delete_cart()
	{
		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if (!($uids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(OrderMod::delete_shop_cart($uids, $shop['uid'], $su_uid));
	}

	/*
		收藏列表
	*/
	public function favlist()
	{
		$shop = $this->init_shop();
		if (!($option['user_id'] = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}

		$option['page']         = requestInt('page');
		$option['limit']        = requestInt('limit', 10);
		$option['notify_price'] = requestInt('notify_price'); //1, 降价通知列表, 0 全部
		$option['shop_uid']     = $shop['uid'];
		outRight(FavMod::get_user_fav_list($option));
	}

	/*
		添加到收藏
	*/
	public function add_to_fav()
	{
		$shop = $this->init_shop();
		if (!($item['user_id'] = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if (!($item['product_uid'] = requestInt('product_uid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		isset($_REQUEST['notify_price']) && $item['notify_price'] = requestInt('notify_price'); //降价通知,单位为分
		isset($_REQUEST['email']) && $item['email'] = requestString('email', PATTERN_EMAIL);
		isset($_REQUEST['phone']) && $item['phone'] = requestString('phone', PATTERN_PHONE);

		outRight(FavMod::add_or_edit_fav($item));
	}

	/*
		根据收藏记录uid 删除收藏商品
	*/
	public function delete_fav()
	{
		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if (!($uids = requestIntArray('uids')))
		{ //收藏记录uid, 而不是商品uid
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(FavMod::delete_fav($uids, $su_uid));
	}

	/*
		根据商品uid 删除收藏商品
	*/
	public function delete_fav_product()
	{
		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if (!($uids = requestIntArray('uids')))
		{ //商品uid
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(FavMod::delete_fav_product($uids, $su_uid));
	}

	/*
		移动购物车内商品到收藏
	*/
	public function mv_cart_to_fav()
	{
		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if (!($uid = requestInt('uid')))
		{ //购物车项uid
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(OrderMod::move_cart_to_fav($uid, $su_uid));
	}

	/*
		运费预览
	*/
	public function preview_delivery()
	{
		$address = array(
			'province' => requestString('province', PATTERN_USER_NAME),
			'city'     => requestString('city', PATTERN_USER_NAME),
			'town'     => requestString('town', PATTERN_USER_NAME),
		);

		if (isset($_REQUEST['products']))
		{
			if (!($products = requestKvJson('products')))
			{
				outError(ERROR_INVALID_REQUEST_PARAM);
			}
			foreach ($products as $k => $p)
			{
				if (!$products[$k] = checkKvJson($p, array(
					array('uid', 'int'),
					array('quantity', 'int'),
				))
				)
				{
					outError(ERROR_INVALID_REQUEST_PARAM);
				}
				$products[$k]['count'] = $products[$k]['quantity'];
			}
		}
		else
		{
			$products = array(array(
				                  'uid'   => requestInt('uid'), //商品uid
				                  'count' => requestInt('quantity', 1), //商品数目
			                  ));
		}

		#outRight(DeliveryMod::preview_delivery(array('uid' => $uid, 'count' => $quantity), $address));
		outRight(DeliveryMod::precalc_delivery($products, $address));
	}


	/*
		下订单
	*/
	public function make_order()
	{
		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}

		//todo 也可以通过购物车uid来取, 下单完成后可以清除下购物车
		if (isset($_REQUEST['products']) && !($products = requestKvJson('products')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		if (isset($_REQUEST['cart_uid']) && (!($cart_uid = requestStringArray('cart_uid'))
				|| !($GLOBALS['_TMP']['cart_uid'] = $cart_uid)
				|| !($products = OrderMod::get_shop_cart_by_uids($cart_uid, $shop['uid'])))
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (empty($products))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		foreach ($products as $k => $p)
		{
			if (!$products[$k] = checkKvJson($p, array(
				array('sku_uid', 'String', PATTERN_SKU_UID),
				array('quantity', 'int'),
			))
			)
			{
				outError(ERROR_INVALID_REQUEST_PARAM);
			}
			if($products[$k]['quantity'] <= 0) {
				outError(ERROR_INVALID_REQUEST_PARAM);
			}

            if(isset($products[$k]['product']['else_info'])){
                $products[$k]['else_info'] = $products[$k]['product']['else_info'];
            }

		}
		$order = array(
			'shop_uid' => $shop['uid'],
			'user_id'  => $su_uid,
			'products' => $products,
		);

		//收货地址, 虚拟物品不要收货地址
		if (isset($_REQUEST['address_uid']))
		{
			if (!($aid = requestInt('address_uid')) ||
				!($address = DeliveryMod::get_shop_user_address_by_uid($aid)) ||
				!($address['user_id'] == $su_uid)
			)
			{
				//outError(ERROR_INVALID_REQUEST_PARAM);
				unset($address); //虚拟产品不要地址
			}
		}
		else
		{
			isset($_REQUEST['name']) && $address['name'] = requestString('name', PATTERN_USER_NAME);
			isset($_REQUEST['phone']) && $address['phone'] = requestString('phone', PATTERN_PHONE);
			isset($_REQUEST['province']) && $address['province'] = requestString('province', PATTERN_USER_NAME);
			isset($_REQUEST['city']) && $address['city'] = requestString('city', PATTERN_USER_NAME);
			isset($_REQUEST['town']) && $address['town'] = requestString('town', PATTERN_USER_NAME);
			//如果这里要5级分类,用冒号分开多级 如 ${town}:车公庙:金地花园:48栋301
			isset($_REQUEST['address']) && $address['address'] = requestString('address', PATTERN_USER_NAME);
		}

		
		isset($order['date_time']) && $order['date_time'] = requestString('date_time');	

		//运送方式 express, ems, mail, self, virtual
		isset($_REQUEST['delivery']) && $address['delivery'] = requestString('delivery', PATTERN_NORMAL_STRING);
		isset($address) && $order['address'] = $address;

		//支付方式
		isset($_REQUEST['pay_type']) && $order['pay_type'] = requestInt('pay_type', OrderMod::PAY_TYPE_WEIXINPAY);
		//使用优惠劵
		!empty($_REQUEST['coupon_uid']) && $order['coupon_uid'] = requestInt('coupon_uid');
		//使用积分
		isset($_REQUEST['point']) && $order['use_point'] = requestInt('point');
		//使用余额
		isset($_REQUEST['cash_fee']) && $order['cash_fee'] = requestInt('cash_fee');

		//留言 发票 提货时间 等其他信息
		$order['info'] = requestKvJson('info');
		Event::addHandler('AfterMakeOrder', array('OrderMod', 'onAfterMakeOrder'));
// return;

		//拼团 购买， 有值为加入别人的团, 0表示开团
		if(isset($_REQUEST['go_uid'])) {
			$order['go_uid'] = requestInt('go_uid');
		}
		//砍价的shop_bargain_user中的uid
		$bu_uid = requestInt('bu_uid');
		if(!empty($bu_uid)){
			//不拼团-1
			if($order['go_uid']==-1){
				unset($order['go_uid']);
			}
			uct_use_app('bargain');
			if(!$bargain_user = BargainMod::get_bargain_user_by_uid($bu_uid)){
				outError(ERROR_OBJ_NOT_EXIST);
			}
		}


		$order_uid = OrderMod::make_a_order($order,$bu_uid);

		outRight($order_uid);
	}

	public function preview_order_fee() {
		$GLOBALS['_TMP']['preview_order_fee'] = 1;
		return $this->make_order();
	}

	public function preview_order_send(){
		$shop = $this->init_shop();

		if((!($lng = requestFloat('lng')))||(!($lat = requestFloat('lat')))){
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		//仅用于计算能否配送
		$can_send = 1;//默认能配送

		$address = AddressMod::get_shop_address(array('shop_uid'=>$shop['uid'],'page'=>0,'limit'=>-1));
		if(!empty($address['list'])){
			foreach($address['list'] as $al){
				if(empty($al['address_data']) || empty($al['address_data']['sendscope'])){
					continue;
				}
				if(!isset($al['address_data']['sendscope'])){
					continue;
				}
				$sendscope = $al['address_data']['sendscope'];
				$juli = getdistance($al['address_data']['lng'],$al['address_data']['lat'],$lng,$lat);
				if($sendscope >= ($juli/1000)){
					$can_send = 1;
					break;
				}else{
					$can_send = 0;
				}
			}
		}

		outRight($can_send);
	}
	/*
		获取收货地址
	*/
	public function get_address()
	{
		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}

		//支持 传个uid，取那个uid的地址
		if($uid = requestInt('uid')) {
			$ret = DeliveryMod::get_shop_user_address_by_uid($uid);
			if(!$ret || ($ret['user_id'] != $su_uid)) {
				outError(ERROR_INVALID_REQUEST_PARAM);	
			}
			outRight($ret);
		}

		outRight(DeliveryMod::get_shop_user_address($shop['uid'], $su_uid));
	}

	/*
		删除收货地址
	*/
	public function delete_address()
	{
		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if (!($uids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(DeliveryMod::delete_shop_user_address($uids, $shop['uid'], $su_uid));
	}

	/*
		新增或编辑收货地址
	*/
	public function add_address()
	{
		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		isset($_REQUEST['name']) && $ua['name'] = requestString('name', PATTERN_USER_NAME);
		isset($_REQUEST['phone']) && $ua['phone'] = requestString('phone', PATTERN_PHONE);
		isset($_REQUEST['province']) && $ua['province'] = requestString('province', PATTERN_USER_NAME);
		isset($_REQUEST['city']) && $ua['city'] = requestString('city', PATTERN_USER_NAME);
		isset($_REQUEST['town']) && $ua['town'] = requestString('town', PATTERN_USER_NAME);
		isset($_REQUEST['lng']) && $biz['lng'] = requestFloat('lng');
		isset($_REQUEST['lat']) && $biz['lat'] = requestFloat('lat');

		isset($_REQUEST['uid']) && $ua['uid'] = requestInt('uid');

		isset($_REQUEST['is_default']) && $ua['is_default'] = requestInt('is_default');

		//如果这里要5级分类,用冒号分开多级 如 ${town}:车公庙:金地花园:48栋301
		#isset($_REQUEST['address']) && $ua['address'] = requestString('address', PATTERN_USER_NAME);
		isset($_REQUEST['address']) && $ua['address'] = requestStringLen('address', 32);
		if (empty($ua))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$ua['user_id']  = $su_uid;
		$ua['shop_uid'] = $shop['uid'];

		outRight(DeliveryMod::add_or_edit_user_address($ua));
	}

	/*
		获取用户优惠劵列表
	*/
	public function get_coupon()
	{
		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		$option['page']  = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
		//        var_dump($_REQUEST['available'],$option['available']);
		isset($_REQUEST['available']) && $_REQUEST['available'] = ($_REQUEST['available'] == "true" ? true : false);
		isset($_REQUEST['paid_fee']) && $GLOBALS['_TMP']['paid_fee'] = requestInt('paid_fee');
		$option['available'] = requestBool('available'); //只要可用的优惠劵;
		$option['shop_uid']  = $shop['uid'];
		$option['user_id']   = $su_uid;
		//        var_dump($_REQUEST['available'],$option['available']);
		outRight(CouponMod::get_user_coupon_list($option));
	}

	/*
		登陆用户领取优惠劵
		返回发放的张数
	*/
	public function addusercoupon()
	{
		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if (!($uid = requestInt('coupon_uid')) ||
				!($coupon = CouponMod::get_shop_coupon_by_uid($uid)) ||
				($coupon['shop_uid'] != $shop['uid'])
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		//默认一张
		if (!($publish_cnt = requestInt('publish_cnt', 1)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$ret = 0;
		for ($i = 0; $i < $publish_cnt; $i++)
		{
			if (!CouponMod::add_a_coupon_to_user($coupon, $su_uid))
			{
				break;
			}
			$ret++;
		}

		outRight($ret);
	}

	/*
		删除优惠券
	*/
	public function delete_coupon()
	{
		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if (!($uids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(CouponMod::delete_user_coupon($uids, $su_uid));
	}

	/*
		申请退款
	*/
	public function add_refund()
	{
		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if (!($uid = requestInt('uid')) ||       //订单号uid
			!($order = OrderMod::get_order_by_uid($uid)) ||
			!($order['user_id'] == $su_uid)
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$r['refund_fee'] = requestInt('refund_fee'); //退款金额 单位为分

		//退款信息 理由,图片等  {refund_info: 质量不好, images: [1.jpg,2.jpg]}
		$r['refund_info'] = requestKvJson('refund_info');
		Event::addHandler('AfterAddRefund', array('RefundMod', 'onAfterAddRefund'));
		outRight(RefundMod::do_add_refund($order, $r));
	}

	/*
		取消退款
	*/
	public function cancel_refund()
	{
		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if (!($uid = requestInt('uid')) ||       //订单号uid
			!($refund = RefundMod::get_refund_by_order_uid($uid)) ||
			!($refund['user_id'] == $su_uid)
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		Event::addHandler('AfterCancelRefund', array('RefundMod', 'onAfterCancelRefund'));
		outRight(RefundMod::do_cancel_refund($refund));
	}

	/*
		留言
	*/
	public function add_message()
	{
		$shop = $this->init_shop();
		if (!$m['user_id'] = AccountMod::has_su_login())
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}

		if (!($m['brief'] = requestString('brief')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		//留言更多信息  格式如 {联系方式:1580000, 所在区域: 蛇口}
		isset($_REQUEST['extra_info']) && $m['extra_info'] = requestString('extra_info');

		$m['shop_uid'] = $shop['uid'];
		outRight(ShopMod::add_or_edit_message($m));
	}

	/*
		顾客调用 收货
	*/
	public function do_receipt()
	{
		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if (!($uid = requestInt('uid')) ||
			!($o = OrderMod::get_order_by_uid($uid)) ||
			!($o['user_id'] == $su_uid)
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		Event::addHandler('AfterRecvGoods', array('OrderMod', 'onAfterRecvGoods'));
		outRight(OrderMod::do_recv_goods($o));
	}

	/*
		获取留言列表
	*/
	public function get_messages()
	{
		$shop = $this->init_shop();
		if (!($option['user_id'] = AccountMod::has_su_login()))
		{//某个用户的留言
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 10);
		$option['key']      = requestString('key', PATTERN_SEARCH_KEY);
		$option['status']   = 1; //默认只要审核成功的
		$option['shop_uid'] = $shop['uid'];

		outRight(ShopMod::get_shop_messages($option));
	}

	/*
		商品评价
	*/
	public function do_product_comment()
	{
		$shop = $this->init_shop();
		if (!($oc['user_id'] = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if (!($oc['order_uid'] = requestInt('order_uid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (!($oc['product_uid'] = requestInt('product_uid')) &&
			(!($sku = requestString('product_uid', PATTERN_SKU_UID)) || !($oc['product_uid'] = @current(explode(';', $sku, 2))))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$oc['score']    = requestInt('score', 5);
		$oc['brief']    = requestString('brief');
		$oc['images']   = requestStringArray('images', PATTERN_URL);
		$oc['shop_uid'] = $shop['uid'];

		outRight(CommentMod::add_product_comment($oc));
	}

	/*
		获取评价
	*/
	public function get_product_comments()
	{
		$shop                  = $this->init_shop();
		$option['shop_uid']    = $shop['uid'];
		$option['page']        = requestInt('page');
		$option['limit']       = requestInt('limit', 10);
		$option['user_uid']    = requestInt('user_uid');
		$option['product_uid'] = requestInt('product_uid');
		$option['status']      = requestInt('status', 1); //只要成功的

		outRight(CommentMod::get_product_comments($option));
	}

	/*
		获取成交记录
	*/
	public function get_product_sell()
	{
		$shop = $this->init_shop();
		if (!($option['product_uid'] = requestInt('product_uid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$option['shop_uid'] = $shop['uid'];
		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 10);

		//只要本月成交记录
		if (!empty($_REQUEST['this_month']))
		{
			$option['min_time'] = strtotime(date('Y-m-01'));
		}

		outRight(CommentMod::get_product_sell($option));
	}

	/*
		取消订单
	*/
	public function cancel_order()
	{
		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if (!($uid = requestInt('uid')) ||
			!($o = OrderMod::get_order_by_uid($uid)) ||
			!($o['user_id'] == $su_uid)
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		Event::addHandler('AfterCancelOrder', array('OrderMod', 'onAfterCancelOrder'));
		outRight(OrderMod::do_cancel_order($o));
	}

	/*
		删除订单
	*/
	public function delete_order()
	{
		//默认不删除
		if(empty($_REQUEST['f'])) return $this->cancel_order();

		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if (!($uid = requestInt('uid')) ||
			!($o = OrderMod::get_order_by_uid($uid)) ||
			!($o['user_id'] == $su_uid)
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(OrderMod::delete_order($o));
	}

	/*
		用户订单列表
	*/
	public function orders()
	{
		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}

		$option['status']  = requestInt('status');
		$option['user_id'] = $su_uid;
		$option['sort']    = requestInt('sort');
		$option['page']    = requestInt('page');
		$option['limit']   = requestInt('limit', 10);
		//是否为拼团订单
		isset($_REQUEST['is_group']) && $option['is_group'] = requestBool('is_group');
		$option['key']     = requestString('key', PATTERN_SEARCH_KEY);
		isset($_REQUEST['create_time']) && $option['create_time'] = requestInt('create_time'); //最近一段时间的订单

		outRight(OrderMod::get_order_list($option));
	}

	/*
		根据uid获取订单
	*/
	public function order()
	{
		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}

		if(!($uid = requestInt('uid')) || !($order = OrderMod::get_order_by_uid($uid)) 
			|| ($order['user_id'] != $su_uid)) {
			$order = array();
		}

		outRight($order);
	}

	//配送员订单配送
	public function set_order(){
		if(!$option['su_uid'] = AccountMod::has_su_login()) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		$option['order_uid'] = requestInt('order_uid');
		$option['status'] = requestInt('status',1);

		outRight(OrderMod::set_order_by_uid($option));
	}


    /*
        代理
    */
	//代理申请
	public function agent_apply()
	{

		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if (!($shop_agent_set =  AgentMod::get_agent_set_by_shop_uid($shop['uid']))
			|| !(empty($shop_agent_set['status']))
		)
		{
			outError(ERROR_BAD_STATUS);//该商品并木有开代理系统
		}
		$agent = array(
			'su_uid' => $su_uid,
			'status' => (empty($shop_agent_set['need_check']) ?0:1),//need_check 为0 不用审核
		    'shop_uid'=>$shop['uid']
		);
		outRight(AgentMod::add_or_edit_agent($agent));
	}

	//获取  代理申请按钮字符
	public function get_agent_bt()
	{
		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login())
			|| !($agent = AgentMod::get_agent_by_su_uid($su_uid))
			|| !($agent['shop_uid']==$shop['uid'])
		)
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}

		outRight(DomainMod::get_app_bt($shop['uid']));
	}

	//获取  代理商城链接
	public function get_agent_url()
	{
		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login())
			|| !($agent = AgentMod::get_agent_by_su_uid($su_uid))
			|| !($agent['shop_uid']==$shop['uid'])
		)
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		outRight(DomainMod::get_app_url('shop',0,array('s_a_uid'=>$agent['uid'])));
	}

	//编辑 代理的商品
	public function edit_shop_agent_to_user_product()
	{

		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login())
			|| !($agent = AgentMod::get_agent_by_su_uid($su_uid))
			|| !($agent['shop_uid']==$shop['uid'])
		)
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if (isset($_REQUEST['title']) && !($product['title'] = requestStringLen('title', 64)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		isset($_REQUEST['content']) && $product['content'] = requestString('content');
		isset($_REQUEST['main_img']) && $product['main_img'] = requestString('main_img', PATTERN_URL);
		isset($_REQUEST['images']) && $product['images'] = implode(';', requestStringArray('images', PATTERN_URL, ';'));
		isset($_REQUEST['price']) && $product['price'] = requestInt('price');
		isset($_REQUEST['ori_price']) && $product['ori_price'] = requestInt('ori_price');
		isset($_REQUEST['status']) && $product['status'] = requestInt('status');
		if (empty($product)
			|| !($product['uid'] = requestInt('uid'))
			||!($agent_to_user_product = AgentMod::get_agent_to_user_product_by_uid($product['uid']))
			//代理商品的uid
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		//对售价 设置判断
		if(!(empty($product['price']))
			&&
			(!($agent_product = AgentMod::get_agent_product_by_uid($agent_to_user_product['p_uid']))
			|| ($product['price'] >$agent_product['price_h'])
			||($product['price'] <$agent_product['price_l']))
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$product['a_uid'] = $agent['uid'];
		outRight(AgentMod::add_or_edit_agent_to_user_product($product));
	}

	//添加可被被代理的商品为代理商品
	public function add_shop_agent_to_user_product()
	{
		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login())
			|| !($agent = AgentMod::get_agent_by_su_uid($su_uid))
			|| !($agent['shop_uid']==$shop['uid'])
		)
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}

		$user_product['a_uid'] = $agent['uid'];

		$p_uids = requestIntArray('p_uids');  //要添加商品的uid 数组 [1,2,3]
		$p_uids = Dba::readAllOne('select uid from shop_agent_product where uid in ('.implode(',',$p_uids).')'); //过滤下

		$user_product['status']  = 1;  //添加时 默认处于下架状态

		foreach($p_uids as $p_uid)
		{
			$user_product['p_uid']  = $p_uid;
			$product = ProductMod::get_shop_product_by_uid($p_uid,0);//取原商品 不要代理设置的
			$agent_product = AgentMod::get_agent_product_by_uid($p_uid);
			$user_product['price'] = $agent_product['price_h']; // 默认配置 最高价格
			$user_product['ori_price'] = $product['ori_price'];
			$user_product['title'] = $product['title'];
			$user_product['content'] = $product['content'];
			$user_product['main_img'] = $product['main_img'];
			$user_product['images'] = (!empty($product['images']))?implode(';', $product['images']):'';
			AgentMod::add_or_edit_agent_to_user_product($user_product);
		}
		outRight(Dba::affectedRows());
	}
	/*
 		编辑某个代理
 	*/
	public function edit_shop_agent()
	{

		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login())
				|| !($agent = AgentMod::get_agent_by_su_uid($su_uid))
				|| !($agent['shop_uid']==$shop['uid'])
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$shop_agent['uid'] = $agent['uid'];
		if (isset($_REQUEST['notice']) && !($shop_agent['notice'] = requestStringLen('notice',128)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (isset($_REQUEST['title']) && !($shop_agent['title'] = requestStringLen('title',64)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		outRight(AgentMod::add_or_edit_agent($shop_agent));
	}


    /*yhc*/
    //获取正在代理的物品列表
    public function get_agent_products(){
        $shop = $this->init_shop();
        if (!($su_uid = AccountMod::has_su_login())
            || !($agent = AgentMod::get_agent_by_su_uid($su_uid))
            || !($agent['shop_uid']==$shop['uid'])
        )
        {
            outError(ERROR_USER_HAS_NOT_LOGIN);
        }
        $option['a_uid']        = $agent['uid'];
        $option['limit']        = -1;//requestInt('limit', 10);
        $option['page']         = requestInt('page', 0);
        $option['key']          = requestString('key');
        outRight(AgentMod::get_agent_to_user_product_list($option));
    }
    //获取可以代理的物品列表
    public function add_agent_products(){
        $shop = $this->init_shop();
        if (!($su_uid = AccountMod::has_su_login())
            || !($agent = AgentMod::get_agent_by_su_uid($su_uid))
            || !($agent['shop_uid']==$shop['uid'])
        )
        {
            outError(ERROR_USER_HAS_NOT_LOGIN);
        }
        $option['no_a_uid'] = $agent['uid']; //不取该代理已经设置的商品
        $option['shop_uid'] = $shop['uid'];
        $option['limit']    = -1;//requestInt('limit', 10);
        $option['page']     = requestInt('page', 0);
        $option['status']   = 0; // 只取 允许代理的商品
        $option['key']      = requestString('key', PATTERN_SEARCH_KEY);
        outRight(AgentMod::get_agent_product_list($option));
    }
    /*获取订单*/
    public function get_agent_order(){
        $shop = $this->init_shop();
        if (!($su_uid = AccountMod::has_su_login())
            || !($agent = AgentMod::get_agent_by_su_uid($su_uid))
            || !($agent['shop_uid']==$shop['uid'])
        )
        {
            outError(ERROR_USER_HAS_NOT_LOGIN);
        }
        $option['a_uid'] =  $agent['uid'];
        $option['status'] = requestInt('status');
        $option['key']    = requestString('key', PATTERN_SEARCH_KEY);
        $option['page']   = requestInt('page');
        $option['limit']  = requestInt('limit', 10);
        $agent_order      = OrderMod::get_order_list($option);
        outRight($agent_order);
    }


	/*
		一元夺宝订单
	*/
	public function make_indiana_order() {
		$shop = $this->init_shop();
		if(!$su_uid = AccountMod::has_su_login()) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		
		if (isset($_REQUEST['products']) && !($products = requestKvJson('products')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		if (isset($_REQUEST['cart_uid']) && (!($cart_uid = requestStringArray('cart_uid'))
				|| !($GLOBALS['_TMP']['cart_uid'] = $cart_uid)
				|| !($products = OrderMod::get_shop_cart_by_uids($cart_uid, $shop['uid'])))
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		//        var_dump($GLOBALS['_TMP']);exit;
		if (empty($products))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		foreach ($products as $k => $p)
		{
			if (!$products[$k] = checkKvJson($p, array(
				array('sku_uid', 'String', PATTERN_SKU_UID),
				array('quantity', 'int'),
			))
			)
			{
				outError(ERROR_INVALID_REQUEST_PARAM);
			}
			if($products[$k]['quantity'] <= 0) {
				outError(ERROR_INVALID_REQUEST_PARAM);
			}
			
			$sku_uid = explode(';', $products[$k]['sku_uid'], 2);
			if(empty($sku_uid[1]) || (!$i_uid = checkNatInt($sku_uid[1])) ||
				(!$indiana = IndianaMod::get_indiana_by_uid($i_uid)) || ($indiana['product_uid'] != $sku_uid[0])) {
				outError(ERROR_INVALID_REQUEST_PARAM);
			}
			
			$indianas[$k] = array('i_uid' => $indiana, 'quantity' => $products[$k]['quantity']);
			/*
			$products[$k] = array(
				'sku_uid'  => $products[$k]['sku_uid'],
				'quantity' => $products[$k]['quantity']);
			*/
		}

		Event::addHandler('AfterMakeIndianaOrder', array('IndianaMod', 'onAfterMakeIndianaOrder'));
		$order = array(
			'shop_uid' => $shop['uid'],
			'user_id'  => $su_uid,
		);


		$ret = array();
		foreach($indianas as $i) {
			$order['quantity'] = $i['quantity'];
			$order['i_uid'] = $i['i_uid'];
			$ret[] = IndianaMod::make_a_indiana_order($order);
		}

		outRight($ret);
	}


	public function distributionlist()
	{
		$shop = $this->init_shop();
		if(!$option['su_uid'] = AccountMod::has_su_login()) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		$option['key']    = requestString('key', PATTERN_SEARCH_KEY);
		isset($_REQUEST['parent_su_uid']) && $option['parent_su_uid'] = requestInt('parent_su_uid');
		isset($_REQUEST['level']) && $option['level'] = requestInt('level');
		$option['order_uid'] = requestInt('order_uid');
		$option['limit']     = requestInt('limit', 10);
		$option['page']      = requestInt('page', 0);

		$dtblist = DistributionMod::get_dtb_record_list($option);

		$params     = array('dtblist' => $dtblist,
		                    'option' => $option);
		//		var_dump(__file__.' line:'.__line__,$params);exit;
		outRight($params);
	}

	public function distribution_user_list()
	{
		$shop = $this->init_shop();
		if(!$option['su_uid'] = AccountMod::has_su_login()) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		$option['sp_uid'] = $shop['sp_uid'];
		isset($_REQUEST['parent_su_uid']) && $option['parent_su_uid'] = requestInt('parent_su_uid');
		$option['status'] = requestInt('status');
		$option['limit']  = requestInt('limit', 10);
		$option['page']   = requestInt('page', 0);
		$option['key']    = requestString('key', PATTERN_SEARCH_KEY);

		$dtb_user_list = DistributionMod::get_user_dtb_list($option);

		$params = array('dtb_user_list' => $dtb_user_list,
		                'option'        => $option,
		);
		//				var_dump(__file__.' line:'.__line__,$params);exit;
		outRight($params);
	}

	/*
		获取我的团队
	*/
	public function get_sub_user_list() {
		$shop = $this->init_shop();
		if(!$su_uid = AccountMod::has_su_login()) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		
		//1级 2级 3级团队
		$level = requestInt('level', 1);
		if($level == 3) {
			$option['from_su_uid3'] = $su_uid;
		}else if($level == 2) {
			$option['from_su_uid2'] = $su_uid;
		} else {
			$option['from_su_uid'] = $su_uid;
		}
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);

		//是否需要用户总计消费
		if(requestBool('with_cash')) {
		$option['func'] = function($item) use ($shop) {
			$item['paid_cash'] = Dba::readOne('select sum(paid_fee) from shop_order where shop_uid = '
					.$shop['uid'].' && user_id = '.$item['uid'].' && paid_time > 0');
			return AccountMod::func_get_service_user($item);
		};
		}

		$ret = AccountMod::get_service_user_list($option);

		outRight($ret);
	}

	/*
	 * 获取分销用户树
	 */
	public function get_user_dtb_tree()
	{
		$shop = $this->init_shop();
		if(!$option['su_uid'] = AccountMod::has_su_login()) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		$option['level'] = requestInt('level',1);
		$option['not_list'] = requestInt('not_list',0);
		$user_dtb_tree = DistributionMod::get_user_dtb_tree($option['su_uid'],$option['level'],$option['not_list']);
		$params = array('user_dtb_tree' => $user_dtb_tree,
		                'option'        => $option,
		);
		outRight($params);
	}

	//分销申请
	public function distribution_apply()
	{

		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		$user = AccountMod::get_service_user_by_uid($su_uid);
		if (!($shop_distribution_set =  DistributionMod::get_dtb_rule_by_shop_uid($shop['uid']))
			|| !(empty($shop_distribution_set['status']))
		)
		{
			outError(ERROR_BAD_STATUS);//该店并没有开启分销系统
		}
		$agent = array(
			'su_uid' => $su_uid,
			'status' => (empty($shop_distribution_set['need_check']) ?1:0),//need_check 为0 不用审核
			'parent_su_uid'=>$user['from_su_uid'],
			'create_time'=> $_SERVER['REQUEST_TIME']
		);

		outRight(DistributionMod::add_or_edit_user_dtb($agent));
	}

	//查看分销申请状态
	public function get_user_distribution(){
		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}

		outRight(DistributionMod::get_user_dtb_by_su_uid($su_uid));
	}

	//获取所有活动接口
	public function get_activity_all()
	{
		outRight(ActivityMod::get_activity_all());
	}

	//获取普通/促销活动接口
	public function get_activity_by_type()
	{
		$type = requestString('type');
		outRight(ActivityMod::get_activity_by_type($type));
	}

	//获取商店活动接口
	public function get_activity_by_sp_uid(){
		if (!($sp_uid = requestString('sp_uid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		outRight(ActivityMod::get_activity_by_sp_uid($sp_uid));
	}

	//点赞
	public function add_message_good(){
		if(!$option['su_uid'] = AccountMod::has_su_login()) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		$option['me_uid'] = requestInt('me_uid');

		$option2['good'] = requestInt('me_good');

		outRight(ShopMod::set_good_by_id($option,$option2));
	}
	//获取主题色
	public function getcolor1(){
		$shop = $this->init_shop();
		if(!isset($GLOBALS['arraydb_sys']['cfg_shop_setcolor_1'.$shop['sp_uid']])){
			$GLOBALS['arraydb_sys']['cfg_shop_setcolor_1'.$shop['sp_uid']] = '00FF00';
		}
		$color1 = $GLOBALS['arraydb_sys']['cfg_shop_setcolor_1'.$shop['sp_uid']];
		outRight($color1);

	}
	public function get_color2(){
		$shop = $this->init_shop();
		if(!isset($GLOBALS['arraydb_sys']['cfg_shop_setcolor_2'.$shop['sp_uid']])){
			$GLOBALS['arraydb_sys']['cfg_shop_setcolor_2'.$shop['sp_uid']] = 'FF0000';
		}
		$color2 = $GLOBALS['arraydb_sys']['cfg_shop_setcolor_2'.$shop['sp_uid']];
		outRight($color2);
	}

	//入驻须知/用户协议
	public function get_user_agreement(){
		$shop = $this->init_shop();
		$option['type_in'] = requestInt('type_in',3);//默认用户协议
		$option['shop_uid'] = $shop['uid'];
		$konw = DocumentMod::get_documents_know($option);

		outRight($konw);
	}
	//红包公告
	public function get_red_bag(){
		$shop = $this->init_shop();
		$option['shop_uid'] = $shop['uid'];

		$konw = DocumentMod::get_documents_know(array('shop_uid' => $shop['uid'], 'type_in' => 2));
		if(!isset($GLOBALS['arraydb_sys']['cfg_set_red_bag'.$shop['sp_uid']])){
			$GLOBALS['arraydb_sys']['cfg_set_red_bag'.$shop['sp_uid']] = 0;
		}
		$konw['send_times'] = $GLOBALS['arraydb_sys']['cfg_set_red_bag'.$shop['sp_uid']];

		outRight($konw);
	}

	//获取用户余额、积分
    public function get_point(){
        if(!$su_uid = AccountMod::has_su_login()) {
            outError(ERROR_USER_HAS_NOT_LOGIN);
        }
        uct_use_app('su');
        $point = SuPointMod::get_user_points_by_su_uid($su_uid);
        outRight($point);
    }
    //获取用户优惠券
    public function get_coupons(){
        if(!$su_uid = AccountMod::has_su_login()) {
            outError(ERROR_USER_HAS_NOT_LOGIN);
        }
        $shop = $this->init_shop();

        $option['page']  = requestInt('page');
        $option['limit'] = requestInt('limit', -1);
        $option['available'] = true; //只要可用的优惠劵;
        $option['shop_uid']  = $shop['uid'];
        $option['user_id']   = $su_uid;
        //        var_dump($_REQUEST['available'],$option['available']);
        $coupons = CouponMod::get_user_coupon_list($option);

        outRight($coupons);
    }
    //获取客服电话
    public function get_sp_phone(){
        $shop = $this->init_shop();
        $service_provider_phone = Dba::readone('select phone from service_provider_profile where uid = ' . $shop['sp_uid']);
        outRight($service_provider_phone);
    }
    //获取各订单数量
    public function get_shop_order(){
        if(!$su_uid = AccountMod::has_su_login()) {
            outError(ERROR_USER_HAS_NOT_LOGIN);
        }
        $shop = $this->init_shop();
        $option['sp_uid'] = $shop['uid'];
        $option['user_id'] = $su_uid;
        $order_count_group_by_status = OrderMod::get_count_order_by_status($option);
        outRight($order_count_group_by_status);
    }

	//获取可用优惠券列表
	public function get_couponlist(){

		$shop = $this->init_shop();
		//获取优惠券
		$option['available']  = true;
		$option['page']  = requestInt('page',0);
		$option['limit'] = requestInt('limit', 10);
		$option['shop_uid']  = $shop['uid'];

		$coupons = CouponMod::get_shop_coupon_list($option);

		outRight($coupons);
	}

    public function logout(){
    	unset($_SESSION['su_login']);
		unset($_SESSION['su_uid']);
		outRight(1);
    }

	/*
		获取商品参团列表
	*/
	public function get_product_order_list() {
		if(!$option['product_uid'] = requestInt('uid')) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 5);
		$option['status'] = OrderMod::ORDER_WAIT_GROUP_DONE;
		$option['is_under_group'] = 1;
		outRight(OrderMod::get_order_list($option));
	}

	/*
		申请退团
	*/
	public function do_refund_group() {
		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login())) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if (!($uid = requestInt('uid')) ||       //订单号uid
			!($order = OrderMod::get_order_by_uid($uid)) ||
			!($order['user_id'] == $su_uid)
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		Event::addHandler('AfterAddRefund', array('RefundMod', 'onAfterAddRefundGroup'));
		outRight(RefundMod::do_refund_group($order));
	}

	//获取商家销售信息
	public function get_biz_cnt(){
		$shop = $this->init_shop();
		if (!($su_uid = AccountMod::has_su_login())) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		$biz_uid = ShopBizMod::get_shop_biz_uid_by_su_uid($su_uid,$shop['uid']);
		if(empty($biz_uid)){
			outError(ERROR_OBJ_NOT_EXIST);
		}

		//今日付款金额
		$today = strtotime('today');
		$sql = 'select sum(paid_fee) from shop_order where shop_uid = ' . $shop['uid']
			. ' && paid_time >= ' . $today . ' && biz_uid = '.$biz_uid;
		$cnts['today_orders_paid'] = Dba::readOne($sql);
		if($cnts['today_orders_paid'] == null ||$cnts['today_orders_paid'] == false){
			$cnts['today_orders_paid'] = 0;
		}
		//待发货订单
		$sql = 'select count(*) from shop_order where shop_uid = ' . $shop['uid'] . ' && status = ' . OrderMod::ORDER_WAIT_FOR_DELIVERY . ' && biz_uid = '.$biz_uid;
		$cnts['wait_delivery_cnt'] = Dba::readOne($sql);
		if($cnts['wait_delivery_cnt'] == null ||$cnts['wait_delivery_cnt'] == false){
			$cnts['wait_delivery_cnt'] = 0;
		}

		//订单总数
		$sql = 'select count(*) from shop_order where shop_uid = ' . $shop['uid']
			. ' && status != ' . OrderMod::ORDER_CANCELED . ' && biz_uid = '.$biz_uid;
		$cnts['total_orders_cnt'] = Dba::readOne($sql);
		if($cnts['total_orders_cnt'] == null ||$cnts['total_orders_cnt'] == false){
			$cnts['total_orders_cnt'] = 0;
		}

		//订单总金额
		$sql = 'select sum(paid_fee) from shop_order where shop_uid = ' . $shop['uid']
			. ' && status != ' . OrderMod::ORDER_CANCELED . ' && biz_uid = '.$biz_uid;
		$cnts['total_orders_paid'] = Dba::readOne($sql);
		if($cnts['total_orders_paid'] == null ||$cnts['total_orders_paid'] == false){
			$cnts['total_orders_paid'] = 0;
		}

		//昨日成功支付用户数
		$sql = 'select count(*) from shop_order where shop_uid = ' . $shop['uid']
			. ' && status != ' . OrderMod::ORDER_CANCELED . ' && biz_uid = '.$biz_uid;
		$yesterday = strtotime ("today") - 86400;
		$sql .= ' && paid_time >= ' . $yesterday . ' && paid_time <= ' . $today . ' group by user_id';
		$cnts['yesterday_orders_paid_su_cnt'] = Dba::readOne($sql);
		if($cnts['yesterday_orders_paid_su_cnt'] == null ||$cnts['yesterday_orders_paid_su_cnt'] == false){
			$cnts['yesterday_orders_paid_su_cnt'] = 0;
		}

		//昨日成功订单数
		$sql = 'select count(*) from shop_order where shop_uid = ' . $shop['uid']
			. ' && status != ' . OrderMod::ORDER_CANCELED . ' && biz_uid = '.$biz_uid;

		$sql .= ' && recv_time >= ' . $yesterday . ' && recv_time <= ' . $today;
		$cnts['yesterday_orders_recv_cnt'] = Dba::readOne($sql);
		if($cnts['yesterday_orders_recv_cnt'] == null ||$cnts['yesterday_orders_recv_cnt'] == false){
			$cnts['yesterday_orders_recv_cnt'] = 0;
		}

		//昨日成功下金额
		$sql = 'select sum(paid_fee) from shop_order where shop_uid = ' . $shop['uid']
			. ' && status != ' . OrderMod::ORDER_CANCELED . ' && biz_uid = '.$biz_uid;

		$sql .= ' && create_time >= ' . $yesterday . ' && create_time <= ' . $today;
		$cnts['yesterday_orders_create_paid'] = Dba::readOne($sql);
		if($cnts['yesterday_orders_create_paid'] == null ||$cnts['yesterday_orders_create_paid'] == false){
			$cnts['yesterday_orders_create_paid'] = 0;
		}

		//过去一周下单金额
		$sql = 'select count(paid_fee) from shop_order where shop_uid = ' . $shop['uid']
			. ' && status != ' . OrderMod::ORDER_CANCELED . ' && biz_uid = '.$biz_uid;
		$weekd = strtotime("-7 days");
		$sql .= ' && create_time >= ' . $weekd . ' && create_time <= ' . $today;
		$cnts['weekd_orders_create_paid'] = Dba::readOne($sql);
		if($cnts['weekd_orders_create_paid'] == null ||$cnts['weekd_orders_create_paid'] == false){
			$cnts['weekd_orders_create_paid'] = 0;
		}

		//待退款订单数
		$sql   = 'select count(*) from shop_order where shop_uid = ' . $shop['uid'] . ' && status = ' . OrderMod::ORDER_UNDER_NEGOTATION . ' && biz_uid = '.$biz_uid;
		$cnts['under_negotation_cnt'] = Dba::readOne($sql);
		if($cnts['under_negotation_cnt'] == null ||$cnts['under_negotation_cnt'] == false){
			$cnts['under_negotation_cnt'] = 0;
		}

		//上架商品总数
		$sql   = 'select count(*) from product where shop_uid = ' . $shop['uid'] . ' && status = 0 ' . ' && biz_uid = '.$biz_uid;
		$cnts['product_cnt'] = Dba::readOne($sql);
		if($cnts['product_cnt'] == null ||$cnts['product_cnt'] == false){
			$cnts['product_cnt'] = 0;
		}
		//商家商品总销售量
		$sql   = 'select sum(sell_cnt) from product where shop_uid = ' . $shop['uid'] . ' && status = 0 ' . ' && biz_uid = '.$biz_uid;
		$cnts['product_sell_cnt'] = Dba::readOne($sql);
		if($cnts['product_sell_cnt'] == null ||$cnts['product_sell_cnt'] == false){
			$cnts['product_sell_cnt'] = 0;
		}
		//商家商品库存量
		$sql   = 'select sum(quantity) from product where shop_uid = ' . $shop['uid'] . ' && status = 0 ' . ' && biz_uid = '.$biz_uid;
		$cnts['product_quantity_cnt'] = Dba::readOne($sql);
		if($cnts['product_quantity_cnt'] == null ||$cnts['product_quantity_cnt'] == false){
			$cnts['product_quantity_cnt'] = 0;
		}

		//库存报警数
		$sql                   = 'select count(*) from product where shop_uid = ' . $shop['uid'] . ' && status = 0 && quantity <= 5' . ' && biz_uid = '.$biz_uid;
		$cnts['stock_low_cnt'] = Dba::readOne($sql);
		if($cnts['stock_low_cnt'] == null ||$cnts['stock_low_cnt'] == false){
			$cnts['stock_low_cnt'] = 0;
		}

		outRight($cnts);
	}

	/*
	 * 获取首页排版
	 */
	public function get_index_view(){
		$shop = $this->init_shop();

		$data = ShopMod::get_index($shop['uid']);

		outRight($data);
	}

	/*
	 * 	快递查询
	 * 	http://api.kuaidiwo.cn:88/api/?key=7B7gBUUtT7UV&com=shentong&cno=888888888888
	 */
	public function get_kuaidi_msg(){
		$com_arr = array(
			'EMS' => 'ems',
			'顺丰' => 'shunfeng',
			'申通' => 'shentong',
			'圆通' => 'yuantong',
			'中通' => 'zhongtong',
			'汇通' => 'huitong',
			'天天' => 'tiantian',
			'韵达' => 'yunda',
			'全峰' => 'quanfeng',
			'中国邮政' => 'zhongguoyouzheng',
			'邮政平邮' => 'youzhengpingyou',
			'港中能达' => 'nengda',
			'宅急送快递' => 'zhaijisong'
		);
		$kuaidi = requestString('kuaidi');
		$com = 0;
		foreach($com_arr as $k => $ca){
			if(strpos($kuaidi,$k) !== false){
				$com = $ca;
				break;
			}
		}


		$key = '7B7gBUUtT7UV';
		//$com快递参数 EMS(ems) 顺丰快递(shunfeng) 申通快递(shentong)	详见 http://api.kuaidiwo.cn:88/api/list.html
		//$cno快递编号
		if(!($cno = requestString('cno'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$url = 'http://api.kuaidiwo.cn:88/api/?key='.$key.'&com='.$com.'&cno='.$cno;
		$kuaidi =  file_get_contents($url);

		outRight(json_decode($kuaidi,true));

	}

	/*
	 * 保存页面设置
	 */
	public function save_index_set(){
		$shop = $this->init_shop();

		isset($_REQUEST['content']) && $data['content'] = requestKvJson('content');
		isset($_REQUEST['status']) && $data['status'] = requestInt('status');

		if(empty($data)){
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$data['sp_uid'] = $shop['sp_uid'];
//		isset($_REQUEST['uid']) && $data['uid'] = requestInt('uid');

		outRight(ShopMod::add_or_edit_index_set($data));
	}
	/*
	 * 获取页面设置
	 */
	public function get_index_set(){
		$shop = $this->init_shop();

		outRight(ShopMod::get_index_set($shop['sp_uid']));
	}

}

