<?php

class IndexCtl
{
    public function init_shop()
    {
        if (!($shop = ShopMod::get_shop())) {
            if (getLastError() == ERROR_BAD_STATUS) {
                echo '该网站已经下线!';
            } else {
                echo '微商城内部错误! ' . getErrorString();
            }
            exit();
        }

		//3层返利 下级用户进入时判断
		if(isset($_REQUEST['parent_su_uid']) &&
			($parent_su_uid = requestInt('parent_su_uid')) &&
			($parent_su = AccountMod::get_service_user_by_uid($parent_su_uid)) && 
			($parent_su['sp_uid'] == $shop['sp_uid'] )) {
			$_SESSION['parent_su_uid'] = $parent_su_uid;
			if($su = AccountMod::get_current_service_user()) {
				$GLOBALS['_TMP']['PARENT_SU_UID'] = $parent_su_uid;
				DistributionMod::onAfterSuRegister($su);
			}
		}


		!isset($GLOBALS['_UCT']['TPL']) && ($GLOBALS['_UCT']['TPL'] = $shop['tpl'] ? $shop['tpl'] : 'wap');
        if( (in_array($GLOBALS['_UCT']['TPL'],AgentMod::get_agent_tpl_array()))    //指定开启代理的模板 sp index.tpl 同样需要改
            &&($agent_set = AgentMod::get_agent_set_by_shop_uid($shop['uid']))   //判断是否安装了代理系统
            && (empty($agent_set['status']))                                   //判断是否开启了代理系统
            && !($s_a_uid = AgentMod::require_agent()) //普通用户进入商城
        )
        {
            //            var_dump(__file__.' line:'.__line__,$shop);exit;
//            exit('这个商城链接无效！请重新索取');
        }
        $visit_record = array(
            'shop_uid'=>$shop['uid'],
            'su_uid'=>AccountMod::has_su_login(),
            's_a_uid'=>AgentMod::require_agent(),
            'product_uid'=>(($GLOBALS['_UCT']['ACT']!='product')?0:requestInt('uid'))
        );
        $visit_record_act = array('index','products','product');
        //微商城统计代码 只统计 主页 商品列表 商品详情页的访问情况
        in_array($GLOBALS['_UCT']['ACT'],$visit_record_act) && ShopMod::add_shop_visit_record($visit_record);
		return $shop;
	}


    /*
        首页
    */
    public function index()
    {
        $shop = $this->init_shop();
        //
        if(($a_uid = AgentMod::require_agent()) && ($agent = AgentMod::get_agent_by_uid($a_uid)))
        {
            $shop['notice'] = $agent['notice'];
            $shop['title'] = (empty($agent['title'])?'':$agent['title']);
        }
        $slides = ShopMod::get_shop_slides(array('shop_uid' => $shop['uid'], 'status' => 0, 'slides_in' => 0));

        $option['shop_uid'] = $shop['uid'];
        //$option['cat_uid'] = requestInt('cat_uid'); //分类uid
        $option['cat_uid'] = requestIntArray('cat_uid'); //分类uid,用分号分开多个分类

        $option['page'] = requestInt('page');
        $option['limit'] = requestInt('limit', -1);
        $option['key'] = requestString('key', PATTERN_SEARCH_KEY);
        $option['sort'] = requestInt('sort');
        $option['status'] = 0;//只要上架的商品
        //获取优惠券
        $option2['available']  = true;
        $option2['page']  = requestInt('page',1);
        $option2['limit'] = requestInt('limit', -1);
        $option2['shop_uid']  = $shop['uid'];
        // var_dump($_REQUEST['available'],$option['available']);
        $coupons = CouponMod::get_shop_coupon_list($option2);
        $products = ProductMod::get_shop_products($option);
        //优惠券
        $today       = strtotime('today');
//        $coupons = CouponMod::get_shop_coupon_list(array('shop_uid'=>$shop['uid'],'page'=>0,'limit'=>-1));

        //检查登录用户总领取券数/今天领取数
        if ($su_uid = AccountMod::has_su_login())
        {

            foreach($coupons['list'] as $k => $cou){
                $sql = 'select count(uid) from shop_user_coupon where user_id = '.$su_uid.' and coupon_uid = '.$cou['uid'].' and shop_uid = '.$shop['uid'];
                $sql2 = 'select count(*) from shop_user_coupon where shop_uid =' . $shop['uid'] . ' and create_time >= ' . $today .' and user_id = '.$su_uid.' and coupon_uid = '.$cou['uid'];

                $coupons['list'][$k]['had_coupon'] = Dba::readOne($sql);
                $coupons['list'][$k]['had_coupon_day'] = Dba::readOne($sql2);
            }
        }

        //广告
        $radio = DocumentMod::get_documents_radio(array('shop_uid'=>$shop['uid'],'type_in'=>0,'page'=>0,'limit'=>-1));

        foreach($coupons['list'] as $k=> $c){
            $coupons['list'][$k]['expire_time'] =  ($c['duration'] ? ($c['create_time'] + $c['duration']) : 0);
            if($c['publish_cnt'] >0 && $c['publish_cnt'] <= $c['used_cnt']) {
                unset($coupons['list'][$k]);
            }
        }
//
        $cats = ProductMod::get_product_cats(array('shop_uid' => $shop['uid']));

		$params = array('shop' => $shop,'coupons'=>$coupons,'radio'=>$radio['list'], 'slides' => $slides, 'option' => $option, 'products' => $products, 'cats' => $cats);

	if($shop['sp_uid'] == 1054) {
		//$GLOBALS['_UCT']['ACT'] = 'index_'.$shop['sp_uid'];
	}
        render_fg('', $params);
    }


    /*
        茅台PC首页
    */
    public function index_pc()
    {
        $shop = $this->init_shop();
        //
        if(($a_uid = AgentMod::require_agent()) && ($agent = AgentMod::get_agent_by_uid($a_uid)))
        {
            $shop['notice'] = $agent['notice'];
            $shop['title'] = (empty($agent['title'])?'':$agent['title']);
        }
        $slides = ShopMod::get_shop_slides(array('shop_uid' => $shop['uid'], 'status' => 0, 'slides_in' => 2));
        // var_dump($slides);

        $option['shop_uid'] = $shop['uid'];
        //$option['cat_uid'] = requestInt('cat_uid'); //分类uid
        $option['cat_uid'] = requestIntArray('cat_uid'); //分类uid,用分号分开多个分类

        $option['page'] = requestInt('page');
        $option['limit'] = requestInt('limit', -1);
        $option['key'] = requestString('key', PATTERN_SEARCH_KEY);
        $option['sort'] = requestInt('sort');
        $option['status'] = 0;//只要上架的商品
        //获取优惠券
        $option2['available']  = true;
        $option2['page']  = requestInt('page',1);
        $option2['limit'] = requestInt('limit', -1);
        $option2['shop_uid']  = $shop['uid'];
        // var_dump($_REQUEST['available'],$option['available']);
        $coupons = CouponMod::get_shop_coupon_list($option2);
        $products = ProductMod::get_shop_products($option);
        //优惠券
        $today       = strtotime('today');
//        $coupons = CouponMod::get_shop_coupon_list(array('shop_uid'=>$shop['uid'],'page'=>0,'limit'=>-1));

        //检查登录用户总领取券数/今天领取数
        if ($su_uid = AccountMod::has_su_login())
        {

            foreach($coupons['list'] as $k => $cou){
                $sql = 'select count(uid) from shop_user_coupon where user_id = '.$su_uid.' and coupon_uid = '.$cou['uid'].' and shop_uid = '.$shop['uid'];
                $sql2 = 'select count(*) from shop_user_coupon where shop_uid =' . $shop['uid'] . ' and create_time >= ' . $today .' and user_id = '.$su_uid.' and coupon_uid = '.$cou['uid'];

                $coupons['list'][$k]['had_coupon'] = Dba::readOne($sql);
                $coupons['list'][$k]['had_coupon_day'] = Dba::readOne($sql2);
            }
        }

        //广告
        $radio = DocumentMod::get_documents_radio(array('shop_uid'=>$shop['uid'],'type_in'=>0,'page'=>0,'limit'=>-1));

        foreach($coupons['list'] as $k=> $c){
            $coupons['list'][$k]['expire_time'] =  ($c['duration'] ? ($c['create_time'] + $c['duration']) : 0);
            if($c['publish_cnt'] >0 && $c['publish_cnt'] <= $c['used_cnt']) {
                unset($coupons['list'][$k]);
            }
        }
//
        $cats = ProductMod::get_product_cats(array('shop_uid' => $shop['uid']));


        $params = array('shop' => $shop,'coupons'=>$coupons,'radio'=>$radio['list'], 'slides' => $slides, 'option' => $option, 'products' => $products, 'cats' => $cats);

    if($shop['sp_uid'] == 1054) {
        //$GLOBALS['_UCT']['ACT'] = 'index_'.$shop['sp_uid'];
    }
        render_fg('', $params);
    }



    /*
        商品列表页
        todo 评论列表
    */ 
    public function products()
    {
        $shop = $this->init_shop();
        $option['shop_uid'] = $shop['uid'];
        $option['cat_uid'] = requestIntArray('cat_uid'); //分类uid,用分号分开多个分类

        $option['page'] = requestInt('page');
        $option['limit'] = requestInt('limit', 10);
        $option['key'] = requestString('key', PATTERN_SEARCH_KEY);
        $option['sort'] = requestInt('sort');
        $option['status'] = 0; //只要上架的商品
        $products = ProductMod::get_shop_products($option);

        $cats = ProductMod::get_product_cats(array('shop_uid' => $shop['uid'])); 

        $params = array('shop' => $shop, 'option' => $option, 'products' => $products ,'cats' => $cats);
        render_fg('', $params);
    }
   

    /*
        商品详情
    */
    public function product()
    {
        
		uct_use_app('sp');
        $shop = $this->init_shop();
		$sp = SpMod::get_sp_profile($shop['sp_uid']);
        if (!($uid = requestInt('uid')) ||
            !($product = ProductMod::get_shop_product_by_uid($uid)) ||
            ($product['shop_uid'] != $shop['uid'])
        ) {
            redirectTo('?_a=shop');
        }

        $option['user_id'] = AccountMod::has_su_login();
        if($option['user_id']){
            $option['product_uid'] = $uid;
            $product['hadfav'] = ProductMod::get_product_fav($option);
        }



        //商品点击数+1
        Dba::write('update product set click_cnt = click_cnt + 1 where uid = ' . $uid);
	$shop['title'] = $product['title'].' - '.$shop['title'];
        $params = array('shop' => $shop,'sp'=>$sp, 'product' => $product);
        render_fg('', $params);
    }

    /*
        商品详情
    */
    public function photo()
    {
        
        $shop = $this->init_shop();

        if (!($uid = requestInt('uid')) ||
            !($product = ProductMod::get_shop_product_by_uid($uid)) ||
            ($product['shop_uid'] != $shop['uid'])
        ) {
            redirectTo('?_a=shop');
        }
        //商品点击数+1
        Dba::write('update product set click_cnt = click_cnt + 1 where uid = ' . $uid);
        $params = array('shop' => $shop, 'product' => $product);
        render_fg('', $params);
    }

    /*
        商品分类
    */
    public function classify()
    {
        $shop = $this->init_shop();

        $option['shop_uid'] = $shop['uid'];
        //$option['cat_uid'] = requestInt('cat_uid'); //分类uid
        $option['cat_uid'] = requestIntArray('cat_uid'); //分类uid,用分号分开多个分类
        $option['parent_uid'] = requestInt('parent_uid');
        $option['page'] = requestInt('page');
        $option['limit'] = requestInt('limit', -1);
        $option['key'] = requestString('key', PATTERN_SEARCH_KEY);
        $option['sort'] = requestInt('sort');
        $option['status'] = 0; //只要上架的商品
        $products = ProductMod::get_shop_products($option);

        $f_cats = ProductMod::get_product_cats(array('shop_uid' => $shop['uid'], 'status'=>0,'parent_uid'=>0));
        $parent_uid = requestInt('parent_uid', (empty($f_cats['0']['uid'])?0:$f_cats['0']['uid']) );
        $s_cats =array();   
        if(!empty($parent_uid))
        {
            $s_cats = ProductMod::get_product_cats(array('shop_uid' => $shop['uid'],'parent_uid'=>$parent_uid));    
        }
    
        $params = array('shop'=>$shop,'f_cats' => $f_cats,'s_cats'=>$s_cats, 'products' => $products, 'parent_uid' => $parent_uid);
        //var_dump($f_cats['0']['uid'],$s_cats);
        render_fg('', $params);
    }   

    /*
        商品分类详情
    */
    public function classify_detail()
    {
        $shop = $this->init_shop();

        $option['shop_uid'] = $shop['uid'];
        //$option['cat_uid'] = requestInt('cat_uid'); //分类uid
        $option['cat_uid'] = requestIntArray('cat_uid'); //分类uid,用分号分开多个分类
        $option['parent_uid'] = requestInt('parent_uid');
        $option['page'] = requestInt('page');
        $option['limit'] = requestInt('limit', -1);
        $option['key'] = requestString('key', PATTERN_SEARCH_KEY);
        $option['sort'] = requestInt('sort');
        $option['status'] = 0; //只要上架的商品
        $products = ProductMod::get_shop_products($option);
    
        $params = array('products' => $products);
        render_fg('', $params);
    }
      
    /*
        购物车
    */
    public function cart()
    {
        $shop = $this->init_shop();
        if (!($su_uid = AccountMod::has_su_login())) {
            redirectTo('?_a=shop&_u=user');
        }

        $cart = OrderMod::get_shop_cart($shop['uid'], $su_uid);

        $option['page'] = requestInt('page');
        $option['limit'] = requestInt('limit', 5);
        $option['status'] = 0; //只要上架的商品
        $option['shop_uid'] = $shop['uid'];
        $option['sort'] = SORT_SALSE_COUNT_DESC;

        $guess = ProductMod::get_shop_products($option);
//        var_dump(__file__.' line:'.__line__,$guess);exit;
        $params = array('shop' => $shop, 'cart' => $cart, 'guess' => $guess);
        render_fg('', $params);
    }

    /*
        订单确认(结算页)
        todo 优惠券,可用积分
    */
    public function makeorder()
    {
        $shop = $this->init_shop();
        if (!($su_uid = AccountMod::has_su_login())) {
            redirectTo('?_a=shop&_u=user');
        }
        /*11月16*/
        if (!($uid = requestInt('uid'))
         || !($product = ProductMod::get_shop_product_by_uid($uid))
         || ($product['shop_uid'] != $shop['uid'])
        ) {
            $product = array();
        }
        if (!($quantity = requestInt('quantity'))) {//立即购买时传购买数量
            $quantity = 1;
        }
        /*12月28*/
        if (empty($_COOKIE['coupon_uid'])
         || !($coupon_uid = checkInt($_COOKIE['coupon_uid']))
         || !($coupon = CouponMod::get_user_coupon_by_uid($coupon_uid))
         || ($coupon['shop_uid']!=$shop['uid'])
        ){
            $coupon = array();
        }
        /**/

        $sku = requestString('sku');//立即购买时传sku
        if ($sku && (!empty($product['sku_table']['info'][$sku]))) {
            $product['price'] = $product['sku_table']['info'][$sku]['price'];
        }
        else {
            $sku = '';
        }

        $address = DeliveryMod::get_shop_user_address($shop['uid'], $su_uid);

        $cart = OrderMod::get_shop_cart($shop['uid'], $su_uid);
        $cart_list_products = array();
        $cart_uid[0] = '';
        if (isset($_REQUEST['cart_uid'])
            && (!($cart_uid = requestStringArray('cart_uid'))
                || !($cart_list_products = OrderMod::get_shop_cart_by_uids($cart_uid, $shop['uid'])))
        ) {
            redirectTo('?_a=shop&_u=user');
        }

        uct_use_app('vipcard');
        $vipcard_discount = VipcardMod::get_rank_discount($su_uid);
        $discount = $GLOBALS['arraydb_sys']['cfg_set_shop_discount'.$shop['uid']];

        $point = requestString('point');

        $params = array(
        	'su_uid'=>$su_uid,
            'shop' => $shop,
            'address' => $address,
            'cart' => $cart,
            'product' => $product,
            'sku' => $sku,
            'quantity' => $quantity,
            'cart_uid' => $cart_uid[0],
            'cart_list_products' => $cart_list_products,
            'vipcard_discount' => $vipcard_discount,
            'discount'=>$discount,
            'coupon' => $coupon
        );

        render_fg('', $params);
    }

    /*
        支付成功后的订单页面
    */
    public function orderdetail()
    {
        $shop = $this->init_shop();
        if (!($su_uid = AccountMod::has_su_login())) {
            redirectTo('?_a=shop&_u=user');
        }

        if (!($uid = requestInt('uid')) ||
            !($order = OrderMod::get_order_by_uid($uid)) ||
            ($order['user_id'] != $su_uid)
        ) {
            echo '订单不存在!';
            return;
        }


        $params = array('shop' => $shop, 'order' => $order);
        render_fg('', $params);
    }

    /*
        购买指南
    */
    public function buyhelp()
    {
        $shop = $this->init_shop();

        if (!($title = requestString('title'))) {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }
        uct_use_app('sp');
        $document = SpMod::get_document_by_title($title, $shop['sp_uid']);

        $params = array('shop' => $shop, "document" => $document);
        render_fg('', $params);
    }

    /*
        客服中心
    */
    public function about()
    {
        $shop = $this->init_shop();

        $params = array('shop' => $shop);
        render_fg('', $params);
    }

    /*
        在线留言
    */
    public function leave_word_online()
    {
        $shop = $this->init_shop();

        $params = array('shop' => $shop);
        render_fg('', $params);
    }

    /*
        自助指南
    */
    public function self_help()
    {
        $shop = $this->init_shop();

        $params = array('shop' => $shop);
        render_fg('', $params);
    }

    /*
        咨询回复
    */
    public function consult()
    {
        $shop = $this->init_shop();

        $params = array('shop' => $shop);
        render_fg('', $params);
    }

    /*
        降价商品
    */
    public function pricecuts()
    {
        $shop = $this->init_shop();

        $params = array('shop' => $shop);
        render_fg('', $params);
    }


    /*
        服务条款
    */
    public function terms()
    {
        $shop = $this->init_shop();
        $params = array('shop' => $shop);
        render_fg('', $params);
    }

    /*
        重置密码
    */
    public function reset()
    {
        $shop = $this->init_shop();
        $params = array('shop' => $shop);
        render_fg('', $params);
    }

    /*
     * 分销中心
     * $user_dtb_info
     *   ["user_dtb_info"]=>
                  array(4) {
                    ["cash_sum"]=>
                    string(6) "104790"  //佣金和
                    ["order_count"]=>
                    string(1) "3"       //自己下单数量
                    ["order_fee"]=>
                    string(6) "299400"  //订单总金额
                    ["uid"]=>
                    string(3) "139"     //用户uid
                  }
        $dtb_tree  分销树 统计下级 各个参数
     */
    public function  distribution_center()
    {
        $shop = $this->init_shop();
        if (!($su_uid = AccountMod::has_su_login())) {
            redirectTo('?_a=shop&_u=user');
        }
        //取到自己的信息
        $user_dtb_info = DistributionMod::get_user_dtb_info($su_uid);
        //要3级数据 并且 只要统计数据
        $dtb_tree = DistributionMod::get_user_dtb_tree($su_uid, 3, 1);

        $params = array('shop' => $shop,'user_dtb_info' => $user_dtb_info, 'dtb_tree' => $dtb_tree);
//        var_dump(__file__ . ' line:' . __line__, $params);
//        exit;
        render_fg('', $params);
    }

    public function get_coupon()
    {
        $shop = $this->init_shop();
        if (!($su_uid = AccountMod::has_su_login())) {
            redirectTo('?_a=shop&_u=user');
        }
        //领取的优惠卷
        if (!($uid = requestInt('coupon_uid')) ||
            !($coupon = CouponMod::get_shop_coupon_by_uid($uid)) ||
            ($coupon['shop_uid'] != $shop['uid'])
        )
        {
            $coupon = CouponMod::get_shop_coupon_list(array('shop_uid'=>$shop['uid'],'page'=>0,'limit'=>-1));
        }
        $today       = strtotime('today');
        //检查登录用户总领取券数/今天领取数
        if ($su_uid &&isset($coupon['list']))
        {
            foreach($coupon['list'] as $k => $cou){
                $sql = 'select count(uid) from shop_user_coupon where user_id = '.$su_uid.' and coupon_uid = '.$cou['uid'].' and shop_uid = '.$shop['uid'];
                $sql2 = 'select count(*) from shop_user_coupon where shop_uid =' . $shop['uid'] . ' and create_time >= ' . $today .' and user_id = '.$su_uid.' and coupon_uid = '.$cou['uid'];

                $coupon['list'][$k]['had_coupon'] = Dba::readOne($sql);
                $coupon['list'][$k]['had_coupon_day'] = Dba::readOne($sql2);
            }
        }

        $params = array('shop' => $shop, 'coupon' => $coupon );
        render_fg('', $params);
    }


    //获取通过审核的留言信息+轮播广告
    public function message(){
        $shop = $this->init_shop();

        $option['shop_uid'] = $shop['uid'];
//         $option['key']      = requestString('key', PATTERN_SEARCH_KEY);
        $slides = ShopMod::get_shop_slides(array('shop_uid' => $shop['uid'], 'status' => 0, 'slides_in' => 1));
        $option['page']     = requestInt('page',0);
        $option['limit']    = requestInt('limit', -1);
        $option['status']   = 1;

        $messages   = ShopMod::get_shop_messages($option);
//		var_dump($slides);
        $user_good = null;
        if (($su_uid = AccountMod::has_su_login())) {
            $user_good  = ShopMod::get_user_good($su_uid);
        }


        $params = array('shop' => $shop,'option' => $option,'slides'=>$slides, 'messages' => $messages['list'],'user_good'=>$user_good);
        render_fg('', $params);
    }

    //购前须知
    public function explain(){
        $shop = $this->init_shop();
        $option['shop_uid'] = $shop['uid'];
        $konw = DocumentMod::get_before_know(array('shop_uid' => $shop['uid'], 'type_in' => 1));
//        var_dump($konw);
        $params = array('shop' => $shop,'konw'=>$konw);
        render_fg('', $params);
    }

    //广播详情
    public function noticedetail(){
        $shop = $this->init_shop();
        $option['shop_uid'] = $shop['uid'];
        $option['uid']     = requestInt('uid');

        $radio = DocumentMod::get_document_by_uid($option['uid']);
        $params = array('shop' => $shop,'radio'=>$radio);
        render_fg('', $params);
    }

    //评论列表
    public function commentlist()
    {
        $shop = $this->init_shop();


        $params = array('shop' => $shop);
        render_fg('', $params);
    }

}

