<?php
/*
 * 多商户后台管理
 */
class AdminCtl {

    /*
    获取左侧菜单项
    */
    public function get_menu_array()
    {
        return array(
            array('name' => '首页', 'icon' => 'am-icon-home', 'link' => '?_a=shop&_u=admin', 'activeurl' => 'admin.index'),
            array('name'      => '到店红包',
                'icon'      => 'am-icon-files-o',
                'link'      => '?_a=shop&_u=admin.bizcoupon',
                'activeurl' => 'admin.bizcoupon'),
            array('name'  => '商品管理',
                'icon'  => 'am-icon-shopping-cart',
                'menus' => array(
                    array('name'      => '导入excel商品数据',
                        'icon'      => 'am-icon-file-excel-o',
                        'link'      => '?_a=shop&_u=admin.ugoodsexcel',
                        'activeurl' => 'admin.ugoodsexcel',
                        'hide'      => true),
                    array('name'      => '商品列表',
                        'icon'      => 'am-icon-shopping-cart',
                        'link'      => '?_a=shop&_u=admin.productlist',
                        'activeurl' => 'admin.productlist'),
                    array('name'      => '秒杀列表',
                        'icon'      => 'am-icon-bolt',
                        'link'      => '?_a=shop&_u=admin.productkilllist',
                        'activeurl' => 'admin.productkilllist'),
                    array('name'      => '团购列表',
                        'icon'      => 'am-icon-group',
                        'link'      => '?_a=shop&_u=admin.productgrouplist',
                        'activeurl' => 'admin.productgrouplist'),
                    array('name'      => '评论管理',
                        'icon'      => 'am-icon-file',
                        'link'      => '?_a=shop&_u=admin.productcomment',
                        'activeurl' => 'admin.productcomment'),
                )),
            array('name'      => '订单管理',
                'icon'      => 'am-icon-files-o',
                'link'      => '?_a=shop&_u=admin.orderlist',
                'activeurl' => 'admin.orderlist'),
			array('name' => '登录密码', 'icon' => 'am-icon-key', 'link' => '?_a=shop&_u=admin.password',
				'activeurl' => 'admin.password'),

        );
    }

    public function init_shop()
    {
        if(!isset($_SESSION['admin_login']))
        {
            #redirectTo('?_a=shop&_u=admin.login');
        }
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


        return $shop;
    }

    public function init_biz()
    {
        $shop = $this->init_shop();
        $su_uid = AccountMod::has_su_login();

        if(isset($_SESSION['admin_login']))
        {
            $biz_uid = $_SESSION['admin_login'];
        }elseif(!empty($su_uid)){
            $biz_uid = ShopBizMod::get_shop_biz_uid_by_su_uid($su_uid,$shop['uid']);
            if(empty($biz_uid)){
                redirectTo('?_a=shop&_u=admin.login');
            }
            $_SESSION['admin_login'] = $_SESSION['admin_uid'] = $biz_uid;
        }else{
            redirectTo('?_a=shop&_u=admin.login');
        }

        $biz = ShopBizMod::get_shop_biz_by_uid($biz_uid);

        return $biz;
    }

    /*
    sp用户商品后台的模板渲染函数, 在一个框架页面内输出模板

    @param $view 模板文件 默认为 $ctl/$act.tpl
    模板文件路径 默认为 app/$app/view/对应前端模板/

    @param $param 模板文件内可用的变量, 默认导出了 $tpl_path 模板路径 和 $static_path 静态文件路径
    如果指定了$param['menu_array'], 那么使用 app/sp/view/对应前端模板/menuframe.tpl, 否则使用 app/sp/view/对应前端模板/frame.tpl
    */
    function render_admin_inner($view = '', $param = array()) {
        if (empty($param['tpl_path'])) {
            #$param['tpl_path']    = UCT_PATH . 'app' . DS . $GLOBALS['_UCT']['APP'] . DS . 'tpl';
            #$param['static_path'] = DS . 'app' . DS . $GLOBALS['_UCT']['APP'] . DS . 'static';
            $param['tpl_path']    = !empty($GLOBALS['_UCT']['TPL']) ?
                UCT_PATH . 'app' . DS . $GLOBALS['_UCT']['APP'] . DS . 'view' . DS . $GLOBALS['_UCT']['TPL'] :
                UCT_PATH . 'app' . DS . $GLOBALS['_UCT']['APP'] . DS . 'tpl';
            $param['static_path'] = !empty($GLOBALS['_UCT']['TPL']) ?
                DS . 'app' . DS . $GLOBALS['_UCT']['APP'] . DS . 'view' . DS . $GLOBALS['_UCT']['TPL'] . DS . 'static' :
                DS . 'app' . DS . $GLOBALS['_UCT']['APP'] . DS . 'static';
        }
        if (empty($view)) {
            if(!empty($GLOBALS['_UCT']['TPL'])) {
                if(isAjax() || $_SERVER['REQUEST_METHOD'] == 'POST') {
                    $view = $param['tpl_path'] . DS . $GLOBALS['_UCT']['CTL'] . DS . $GLOBALS['_UCT']['ACT'] . '.php.tpl';
                    if(file_exists($view)) {
                        extract($param);
                        include($view);
                        return;
                    }
                }
            }

            $view = $param['tpl_path'] . DS . $GLOBALS['_UCT']['CTL'] . DS . $GLOBALS['_UCT']['ACT'] . '.tpl';
            if(!empty($GLOBALS['_UCT']['TPL']) && !file_exists($view)) {
                $param['tpl_path'] = UCT_PATH . 'app' . DS . $GLOBALS['_UCT']['APP'] . DS . 'tpl';
                $view = $param['tpl_path'] . DS . $GLOBALS['_UCT']['CTL'] . DS . $GLOBALS['_UCT']['ACT'] . '.tpl';
            }
        }
        $param['view_path'] = isset($param['menu_array']) ? array(
            $view,
            UCT_PATH . 'app' . DS . 'shop' . DS . 'tpl' . DS . 'menuframe.tpl'
        ) : $view;

        extract($param);

        $file = UCT_PATH . 'app' . DS . 'shop' . DS . 'tpl' . DS . 'frame.tpl';
        if (file_exists($file)) {
            include($file);
        } else {
            echo 'warning! tpl file not found! ' . substr($file, strlen(UCT_PATH));
        }
    }


    protected function admin_render($params = array())
    {
        if (!empty($params['shop']) && empty($GLOBALS['_UCT']['TPL']))
        {
            //后台模板选择
            unset($_REQUEST['__tpl']);
            unset($_COOKIE['__tpl_shop']);
            #$GLOBALS['_UCT']['TPL'] = $params['shop']['tpl'] ? $params['shop']['tpl'] : 'wap';
        }
        $params['menu_array'] = $this->get_menu_array();
        $this->render_admin_inner('', $params);
    }

    public function error()
    {
        echo '内部错误! ' . getErrorString();
    }


    public function login() {
        if($_SERVER['REQUEST_METHOD'] == 'POST') {
            $account = requestString('account', PATTERN_USER_NAME);
            $password = requestString('password', PATTERN_PASSWD);
            if(!$account || !$password) {
                outError(ERROR_INVALID_REQUEST_PARAM);
            }
            outRight(ShopBizMod::do_admin_login($account, $password));
        }
        render();
    }

    public function logout() {
        unset($_SESSION['admin_login']);
        unset($_SESSION['admin_uid']);
//        session_unset();
//        session_destroy();
        if(!$url = requestString('url', PATTERN_URL)) {
            $url = '?_a=shop&_u=admin.login&sp_uid='.AccountMod::require_sp_uid();
        }
        redirectTo($url);
//        redirectTo('?_a=shop&_u=admin.login');
    }

	/*
		使用会员账号登陆
	*/
	public function login_by_su_account() {
		uct_use_app('su');
		SuMod::require_su_uid();	
		redirectTo('?_a=shop&_u=admin.index');
	}

    public function index(){
        $shop = $this->init_shop();
        $biz   = $this->init_biz();

        $today = strtotime('today');
        //今日付款金额
        $today = strtotime('today');
        $sql = 'select sum(paid_fee) from shop_order where shop_uid = ' . $shop['uid']
            . ' && paid_time >= ' . $today . ' && biz_uid = '.$biz['uid'];
        $cnts['today_orders_paid'] = Dba::readOne($sql);
        if($cnts['today_orders_paid'] == null ||$cnts['today_orders_paid'] == false){
            $cnts['today_orders_paid'] = 0;
        }
        //订单数
        $sql = 'select count(*) from shop_order where shop_uid = ' . $shop['uid']
            . ' && status != ' . OrderMod::ORDER_CANCELED . ' && biz_uid = '.$biz['uid'];
        $cnts['total_orders_cnt'] = Dba::readOne($sql);
        $sql .= ' && create_time >= ' . $today;
        $cnts['today_orders_cnt'] = Dba::readOne($sql);

        //成交额, 只计算 确认收货 和 已评价 的订单
        $sql                    = 'select sum(paid_fee) from shop_order where shop_uid = ' . $shop['uid'] . ' && status in (' . implode(',', array(
                OrderMod::ORDER_DELIVERY_OK,
                OrderMod::ORDER_COMMENT_OK)) . ')' . ' && biz_uid = '.$biz['uid'];
        $cnts['total_deal_cnt'] = Dba::readOne($sql);
        if (!$cnts['total_deal_cnt'])
        {
            $cnts['total_deal_cnt'] = 0;
        }
        $sql .= ' && recv_time >= ' . $today;
        $cnts['today_deal_cnt'] = Dba::readOne($sql);
        if (!$cnts['today_deal_cnt'])
        {
            $cnts['today_deal_cnt'] = 0;
        }

        $sql                       = 'select count(*) from shop_order where shop_uid = ' . $shop['uid'] . ' && status = ' . OrderMod::ORDER_WAIT_USER_PAY . ' && biz_uid = '.$biz['uid'];
        $cnts['wait_pay_cnt'] = Dba::readOne($sql);
        $sql                       = 'select count(*) from shop_order where shop_uid = ' . $shop['uid'] . ' && status = ' . OrderMod::ORDER_WAIT_FOR_DELIVERY . ' && biz_uid = '.$biz['uid'];
        $cnts['wait_delivery_cnt'] = Dba::readOne($sql);
        $sql                       = 'select count(*) from shop_order where shop_uid = ' . $shop['uid'] . ' && status = ' . OrderMod::ORDER_WAIT_USER_RECEIPT . ' && biz_uid = '.$biz['uid'];
        $cnts['wait_receipt_cnt'] = Dba::readOne($sql);
        $sql                       = 'select count(*) from shop_order where shop_uid = ' . $shop['uid'] . ' && status = ' . OrderMod::ORDER_DELIVERY_OK . ' && biz_uid = '.$biz['uid'];
        $cnts['ok_cnt'] = Dba::readOne($sql);
        $sql                          = 'select count(*) from shop_order where shop_uid = ' . $shop['uid'] . ' && status = ' . OrderMod::ORDER_UNDER_NEGOTATION . ' && biz_uid = '.$biz['uid'];
        $cnts['wait_negotation_cnt'] = Dba::readOne($sql);

        $a_uid = requestInt('a_uid');
        $p_uid = requestInt('p_uid');
        $today       = strtotime('today');
        $start_time  = requestInt('start_time');
        $end_time    = requestInt('end_time');
        $start_time  = (empty($start_time) ? ($today - 60 * 60 * 24 * 10) : (($start_time - 8 * 24 * 24)));  //JS 提交 是8时
        $end_time    = (empty($end_time) ? ($today + 24 * 60 * 60 - 1) : ($end_time + 16 * 60 * 60 - 1));   //JS 提交 是8时  在今晚24点前数据
        $where_time  = ' && create_time >=' . $start_time .
            (' && create_time <=' . $end_time);
        $where_a_uid = (empty($a_uid) ? '' : ' && s_a_uid =' . $a_uid);
        $where       = (empty($p_uid) ? 'product_uid !=0' : ('product_uid =' . $p_uid));

        $sql             = 'select count(*) from shop_visit_record where shop_uid =' . $shop['uid'] . ' && create_time >= ' . $today . ' ' . $where_a_uid;
        $cnts['shop_pv'] = Dba::readOne($sql);

        $sql             = 'select count(distinct(user_ip)) from shop_visit_record where shop_uid =' . $shop['uid'] . ' && create_time >= ' . $today . ' ' . $where_a_uid;
        $cnts['shop_uv'] = Dba::readOne($sql);

        $sql                = 'select count(*) from shop_visit_record where shop_uid =' . $shop['uid'] . ' && create_time >= ' . $today . ' &&  ' . $where . ' ' . $where_a_uid;
        $cnts['product_pv'] = Dba::readOne($sql);
        $sql                = 'select count(distinct(user_ip)) from shop_visit_record where shop_uid =' . $shop['uid'] . ' && create_time >= ' . $today . ' && ' . $where . ' ' . $where_a_uid;

        $cnts['product_uv'] = Dba::readOne($sql);
        $sql                = array();
        //ip 统计人数
        $sql[0] = 'select from_unixtime(create_time,"%Y-%m-%d") as days,count(*) as count ';
        $sql[0] .= ' from shop_visit_record where shop_uid = "' . $shop['uid'] . '" ' . $where_time . ' && ' . $where . ' ' . $where_a_uid . ' group by days;';
        $sql[1] = 'select from_unixtime(create_time,"%Y-%m-%d") as days,count(distinct user_ip) as count ';
        $sql[1] .= ' from shop_visit_record where shop_uid = "' . $shop['uid'] . '" ' . $where_time . '  && ' . $where . ' ' . $where_a_uid . ' group by days;';
        //统计日订单数
        $sql[2] = 'select from_unixtime(create_time,"%Y-%m-%d") as days,count(*) as count ';
        $sql[2] .= ' from shop_order where biz_uid = "' . $biz['uid'] . '" ' . $where_time . '  group by days;';
        //统计日销售额
        $where_time  = ' && paid_time >=' . $start_time .
            (' && paid_time <=' . $end_time);
        $sql[3] = 'select from_unixtime(create_time,"%Y-%m-%d") as days,sum(paid_fee+cash_fee) as count ';
        $sql[3] .= ' from shop_order where biz_uid = "' . $biz['uid'] . '"  ' . $where_time . '  group by days;';

        $echarts = array();


        for ($i = $start_time; $i < $end_time; $i = $i + 60 * 60 * 24)
        {
            $echarts['xAxis']['data'][]  = date('Y-m-d', $i);
        }

        for ($i = 0; $i < 4; $i++)
        {
            $ret   = Dba::readAllAssoc($sql[$i]);

            $ipret = array();
            foreach ($ret as $rets)
            {
                //以日期为键值
                $ipret[$rets['days']] = $rets['count'];
            }
            foreach ($echarts['xAxis']['data'] as $r)
            {

                $echarts['series'][$i]['data'][] = (empty($ipret[$r]) ? 0 : $ipret[$r]);
            }
        }

        $echarts['xAxis']['data'] = array_unique($echarts['xAxis']['data']);


        $params = array('shop' => $shop, 'cnts' => $cnts,'biz' => $biz,'echarts'=>$echarts);
        $this->admin_render($params);
    }

    public function index2()
    {
        $shop = $this->init_shop();
        $biz   = $this->init_biz();

        $today = strtotime('today');
        //今日付款金额
        $today = strtotime('today');
        $sql = 'select sum(paid_fee) from shop_order where shop_uid = ' . $shop['uid']
            . ' && paid_time >= ' . $today . ' && biz_uid = '.$biz['uid'];
        $cnts['today_orders_paid'] = Dba::readOne($sql);
        if($cnts['today_orders_paid'] == null ||$cnts['today_orders_paid'] == false){
            $cnts['today_orders_paid'] = 0;
        }
        //订单数
        $sql = 'select count(*) from shop_order where shop_uid = ' . $shop['uid']
            . ' && status != ' . OrderMod::ORDER_CANCELED . ' && biz_uid = '.$biz['uid'];
        $cnts['total_orders_cnt'] = Dba::readOne($sql);
        $sql .= ' && create_time >= ' . $today;
        $cnts['today_orders_cnt'] = Dba::readOne($sql);

        //成交额, 只计算 确认收货 和 已评价 的订单
        $sql                    = 'select sum(paid_fee) from shop_order where shop_uid = ' . $shop['uid'] . ' && status in (' . implode(',', array(
                OrderMod::ORDER_DELIVERY_OK,
                OrderMod::ORDER_COMMENT_OK)) . ')' . ' && biz_uid = '.$biz['uid'];
        $cnts['total_deal_cnt'] = Dba::readOne($sql);
        if (!$cnts['total_deal_cnt'])
        {
            $cnts['total_deal_cnt'] = 0;
        }
        $sql .= ' && recv_time >= ' . $today;
        $cnts['today_deal_cnt'] = Dba::readOne($sql);
        if (!$cnts['today_deal_cnt'])
        {
            $cnts['today_deal_cnt'] = 0;
        }

        $sql                       = 'select count(*) from shop_order where shop_uid = ' . $shop['uid'] . ' && status = ' . OrderMod::ORDER_WAIT_FOR_DELIVERY . ' && biz_uid = '.$biz['uid'];
        $cnts['wait_delivery_cnt'] = Dba::readOne($sql);

        $sql                          = 'select count(*) from shop_order where shop_uid = ' . $shop['uid'] . ' && status = ' . OrderMod::ORDER_UNDER_NEGOTATION . ' && biz_uid = '.$biz['uid'];
        $cnts['under_negotation_cnt'] = Dba::readOne($sql);

        //库存报警数
        $sql                   = 'select count(*) from product where shop_uid = ' . $shop['uid'] . ' && status = 0 && quantity <= 5' . ' && biz_uid = '.$biz['uid'];
        $cnts['stock_low_cnt'] = Dba::readOne($sql);

        $public_uid = WeixinMod::get_current_weixin_public('uid');
        $public = WeixinMod::get_weixin_public_by_uid($public_uid);
        $uct_token = $public['uct_token'];


        $params = array('shop' => $shop, 'cnts' => $cnts,
            'biz' => $biz,'uct_token'=>$uct_token);
        $this->admin_render($params);

    }

    /*
     * 实体店优惠券管理
     */
    public function bizcoupon()
    {
        $shop = $this->init_shop();
        $biz   = $this->init_biz();

        $option['biz_uid'] = $biz['uid'];

        $option['key']      = requestString('key', PATTERN_SEARCH_KEY);
        $option['status']   = requestInt('status', -1);
        $option['page']     = requestInt('page');
        $option['limit']    = requestInt('limit', 10);

        $data = BizCouponMod::get_biz_coupon_list($option);

        $pagination = uct_pagination($option['page'], ceil($data['count'] / $option['limit']),
            '?_a=shop&_u=admin.bizcoupon&biz_uid=' . $option['biz_uid'] . '&limit=' . $option['limit'] . '&page=');

        $params = array('shop' => $shop,'biz' => $biz,'option' => $option, 'data' => $data, 'pagination' => $pagination);
        $this->admin_render($params);

    }
    /*
     * 优惠券领取页
     */
    public function bizusercoupon(){

        $shop = $this->init_shop();
        $biz   = $this->init_biz();

        $option['coupon_uid'] = requestInt('coupon_uid');

        $coupon = array();
        if($option['coupon_uid']){
            $coupon = BizCouponMod::get_biz_coupon_by_uid($option['coupon_uid'] );
        }

        $option['key']      = requestString('key', PATTERN_SEARCH_KEY);
        $option['status']   = requestInt('status', -1);
        $option['page']     = requestInt('page');
        $option['limit']    = requestInt('limit', 10);

        $data = BizCouponMod::get_user_coupon_list($option);

        $pagination = uct_pagination($option['page'], ceil($data['count'] / $option['limit']),
            '?_a=shop&_u=admin.bizusercoupon&coupon_uid=' . $option['coupon_uid'] . '&limit=' . $option['limit'] . '&page=');

        $params = array('shop' => $shop,'coupon' => $coupon,'option' => $option, 'data' => $data, 'pagination' => $pagination);
        $this->admin_render($params);
    }

    /*
    添加编辑优惠劵
    */
    public function addbizcoupon()
    {
        uct_check_mirror_tpl_access();

        $shop = $this->init_shop();
        $biz   = $this->init_biz();

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
        $this->admin_render($params);
    }


    /*
     * 商品列表
     */
    public function productlist()
    {
        $shop = $this->init_shop();
        $biz   = $this->init_biz();

        $option['shop_uid']  = $shop['uid'];
        $option['cat_uid']   = requestInt('cat_uid');
        $option['uid']       = requestInt('uid');
        $option['key']       = requestString('key', PATTERN_SEARCH_KEY);
        $option['page']      = requestInt('page');
        $option['limit']     = requestInt('limit', 10);
        $option['low_stock'] = requestInt('low_stock', -1); //低库存
        $option['status']    = requestInt('status', -1); //
        $option['biz_uid'] = $biz['uid'];

        $products   = ProductMod::get_shop_products($option, 0);
        $dtb = DistributionMod::get_dtb_rule_by_shop_uid($shop['uid']);

        $cats       = ProductMod::get_product_cats(array('shop_uid'         => $shop['uid'],
            'with_parent_info' => true,
            'parent_uid'       => -1));
        $pagination = uct_pagination($option['page'], ceil($products['count'] / $option['limit']),
            '?_a=shop&_u=admin.productlist&cat_uid=' . $option['cat_uid'] . '&low_stock=' . $option['low_stock'] . '&key='
            . $option['key'] . '&status=' . $option['status'] . '&limit=' . $option['limit'] . '&page=');

        $params = array('shop'       => $shop,
                        'biz'         => $biz,
                        'dtb'		 => $dtb,
                        'option'     => $option,
                        'products'   => $products,
                        'cats'       => $cats,
                        'pagination' => $pagination);

        $this->admin_render($params);
    }

    //秒杀商品
    public function productkilllist()
    {
        $shop = $this->init_shop();
        $biz   = $this->init_biz();

        $option['shop_uid']  = $shop['uid'];
        $option['cat_uid']   = requestInt('cat_uid');
        $option['uid']       = requestInt('uid');
        $option['key']       = requestString('key', PATTERN_SEARCH_KEY);
        $option['page']      = requestInt('page');
        $option['limit']     = requestInt('limit', 10);
        $option['low_stock'] = requestInt('low_stock', -1); //低库存
        $option['status']    = requestInt('status', -1); //
        $option['info'] = 32;
        $option['biz_uid'] = $biz['uid'];

        $products   = ProductMod::get_shop_products($option, 0);
        $dtb = DistributionMod::get_dtb_rule_by_shop_uid($shop['uid']);

        $cats       = ProductMod::get_product_cats(array('shop_uid'         => $shop['uid'],
            'with_parent_info' => true,
            'parent_uid'       => -1));
        $pagination = uct_pagination($option['page'], ceil($products['count'] / $option['limit']),
            '?_a=shop&_u=admin.productkilllist&cat_uid=' . $option['cat_uid'] . '&low_stock=' . $option['low_stock'] . '&key='
            . $option['key'] . '&status=' . $option['status'] . '&limit=' . $option['limit'] . '&page=');
        //		var_dump(__file__.' line:'.__line__,$products);exit;
        $params = array('shop'       => $shop,
            'dtb'		 => $dtb,
            'option'     => $option,
            'products'   => $products,
            'cats'       => $cats,
            'pagination' => $pagination);

        $this->admin_render($params);
    }


    //团购商品
    public function productgrouplist()
    {
        $shop = $this->init_shop();
        $biz   = $this->init_biz();

        $option['shop_uid']  = $shop['uid'];
        $option['cat_uid']   = requestInt('cat_uid');
        $option['uid']       = requestInt('uid');
        $option['key']       = requestString('key', PATTERN_SEARCH_KEY);
        $option['page']      = requestInt('page');
        $option['limit']     = requestInt('limit', 10);
        $option['low_stock'] = requestInt('low_stock', -1); //低库存
        $option['status']    = requestInt('status', -1); //
        $option['is_group'] = 1;
        $option['biz_uid'] = $biz['uid'];

        $products   = ProductMod::get_shop_products($option, 0);
        $dtb = DistributionMod::get_dtb_rule_by_shop_uid($shop['uid']);

        $cats       = ProductMod::get_product_cats(array('shop_uid'         => $shop['uid'],
            'with_parent_info' => true,
            'parent_uid'       => -1));
        $pagination = uct_pagination($option['page'], ceil($products['count'] / $option['limit']),
            '?_a=shop&_u=admin.productgrouplist&cat_uid=' . $option['cat_uid'] . '&low_stock=' . $option['low_stock'] . '&key='
            . $option['key'] . '&status=' . $option['status'] . '&limit=' . $option['limit'] . '&page=');
        //		var_dump(__file__.' line:'.__line__,$products);exit;
        $params = array('shop'       => $shop,
            'dtb'		 => $dtb,
            'option'     => $option,
            'products'   => $products,
            'cats'       => $cats,
            'pagination' => $pagination);

        $this->admin_render($params);
    }

    /*
     * 添加编辑商品
     */
    public function addproduct()
    {
        $shop = $this->init_shop();
        $biz   = $this->init_biz();

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
            }
            unset($product['uid']);
        }

        $parents    = ProductMod::get_product_cats(array('shop_uid'         => $shop['uid'],
            'with_parent_info' => true,
            'parent_uid'       => -1));
        $deliveries = DeliveryMod::get_shop_delivery($shop['uid']);
        $params     = array('shop' => $shop,'biz' => $biz, 'product' => $product, 'parents' => $parents, 'deliveries' => $deliveries);
        $this->admin_render($params);
    }


    /*
        增加或修改商品额外信息
    */
    public function add_product_extra_info()
    {
        $shop = $this->init_shop();
        $biz   = $this->init_biz();

        if (!($pei['product_uid'] = requestInt('uid')) ||
            !($p = ProductMod::get_shop_product_by_uid($pei['product_uid'])) ||
            !($p['shop_uid'] == $shop['uid'])
        )
        {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }

        if (!($pei['ukey'] = requestString('ukey', PATTERN_SEARCH_KEY)))
        {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }
        if (!($pei['data'] = requestStringLen('data', 512)))
        {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }
        $pei['shop_uid'] = $shop['uid'];

        outRight(ProductMod::add_product_extra_info($pei));
    }

    /*
     * 评论管理
     */
    public function productcomment()
    {
        uct_check_mirror_tpl_access(); //搜索框可能会有需要

        $shop = $this->init_shop();
        $biz   = $this->init_biz();

        $option['shop_uid'] = $shop['uid'];
        $option['key']      = requestString('key', PATTERN_SEARCH_KEY);
        $option['page']     = requestInt('page');
        $option['limit']    = requestInt('limit', 10);
        $option['biz_uid'] = $biz['uid'];

        $comment   = CommentMod::get_product_comments($option);
        $pagination = uct_pagination($option['page'], ceil($comment['count'] / $option['limit']),
            '?_a=shop&_u=admin.productcomment&key=' . $option['key'] . '&biz_uid=' . $option['biz_uid'] . '&limit=' . $option['limit'] . '&page=');

//		var_dump($comment);
        $params = array('shop' => $shop, 'option' => $option, 'comment' => $comment, 'pagination' => $pagination);
        $this->admin_render($params);

    }
    /*
     * 评论回复
     */
    public function edit_comment()
    {
        uct_check_mirror_tpl_access();

        $shop = $this->init_shop();
        $biz   = $this->init_biz();

        $uid     = requestInt('uid');
        $comment = array();
        if ($uid)
        {
            $comment = CommentMod::get_shop_comment_by_uid($uid);
            if (!$comment || ($comment['shop_uid'] != $shop['uid']))
            {
                $comment = array();
            }
        }
        $params = array('shop' => $shop, 'comment' => $comment);
        $this->admin_render($params);
    }

    /*
     * 添加评论回复
     */
    public function add_comment()
    {
        uct_check_mirror_tpl_access();
        $comment = array();
        if (!($shop = ShopMod::get_shop_by_sp_uid()))
        {
            return $this->error();
        };
        $comment['product_uid'] = requestInt('p_uid');
//		var_dump($comment['product_uid']);

        $params = array('shop' => $shop, 'comment' => $comment);
        $this->admin_render($params);
    }


    /*
     *订单列表
     */
    public function orderlist()
    {
        $shop = $this->init_shop();
        $biz   = $this->init_biz();

        $option['shop_uid'] = $shop['uid'];
        $option['user_id']  = requestInt('user_id');
        $option['status']   = requestInt('status');
        $option['key']      = requestString('key', PATTERN_SEARCH_KEY);
        $option['page']     = requestInt('page');
        $option['limit']    = requestInt('limit', 10);
        $option['biz_uid'] = $biz['uid'];

        $today       = strtotime('today');
        $option['start_time']  = requestInt('start_time');
        $option['end_time']    = requestInt('end_time');

        $option['start_time']  = (empty($option['start_time']) ? 1 : ($option['start_time']- 8 * 60 * 60 +1));  //JS 提交 是8时
        $option['end_time']    = (empty($option['end_time']) ? ($today + 24 * 60 * 60 - 1) : ($option['end_time'] + 16 * 60 * 60 -1));   //JS 提交 是8时

        $orders     = OrderMod::get_order_list($option);
        $pagination = uct_pagination($option['page'], ceil($orders['count'] / $option['limit']),
            '?_a=shop&_u=admin.orderlist&status=' . $option['status'] . '&limit=' . $option['limit'] . '&page=');

        $params = array('shop' => $shop, 'option' => $option, 'data' => $orders, 'pagination' => $pagination);
        $this->admin_render($params);
    }

    /*
    订单详情
    */
    public function orderdetail()
    {
        $shop = $this->init_shop();
        $biz   = $this->init_biz();

        if (!($uid = requestInt('uid')) ||
            !($o = OrderMod::get_order_by_uid($uid)) ||
            !($o['shop_uid'] == $shop['uid']) ||
            !($o['biz_uid'] == $biz['uid'])
        )
        {
            redirectTo('?_a=shop&_u=admin.orderlist');
        }

        $params = array('shop' => $shop, 'order' => $o);
        $this->admin_render($params);
    }


    public function order_address_excel(){
        ini_set('memory_limit', '15M');
        ini_set("max_execution_time", "0");
        $shop = $this->init_shop();
        $biz   = $this->init_biz();

        $option = array(
            'header' => array(
                '编号',
                '姓名',
                '电话',
                '商品名/',
                '配送时间',
                '地址',
                '备注',
            ),
            'title' => iconv("UTF-8", "GBK", '订单信息'),
        );

        $option['shop_uid'] = $shop['uid'];
        $option['status']   = requestInt('status');
        $option['biz_uid'] = $biz['uid'];

        $today       = strtotime('today');
        $option['start_time']  = requestInt('start_time');
        $option['end_time']    = requestInt('end_time');

        $option['start_time']  = (empty($option['start_time']) ? 0 : ($option['start_time']- 8 * 60 * 60 +1));  //JS 提交 是8时
        $option['end_time']    = (empty($option['end_time']) ? ($today + 24 * 60 * 60 - 1) : ($option['end_time'] + 16 * 60 * 60 -1));   //JS 提交 是8时

        $order     = OrderMod::get_order_address($option);

        $data = null;
        foreach($order as  $k=>$or){
            $data[$k]['uid'] = $or['uid'];
            $data[$k]['name'] = isset($or['address']['name'])?$or['address']['name']:'-';
            $data[$k]['phone'] = isset($or['address']['phone'])?$or['address']['phone']:'-';
            $data[$k]['product'] = null;
            foreach($or['products'] as $o){
                $data[$k]['product'] .= $o['title']."/";
            }
            $data[$k]['send_time'] = $or['send_time']?date('Y:m:d H:i:s',$or['send_time']):'-';
            if(isset($or['address']['province'])&&isset($or['address']['city'])&&isset($or['address']['town'])&&isset($or['address']['address'])){
                $data[$k]['address'] = $or['address']['province'].$or['address']['city'].$or['address']['town'].$or['address']['address'];
            }else{
                $data[$k]['address'] = '-';
            }

            $data[$k]['remark'] = $or['info']['remark'];

        }
//		header('Content-Type:text/html;charset=utf-8');
//		var_dump($data);return;

        if(!empty($data)){
            $option['i'] = 0;
            $this->csv($data, $option);
            unset($data);
            $data = null;
        }else {
            header('Content-Type:text/html;charset=utf-8');
            echo "<script>alert('没有数据');window.history.back();</script>";
        }
        exit;

    }

    //download 为true 时 即写即输出
    protected function csv($data, $option) {
        $ret = '';
        if ($option[ 'i' ] == 0) {
            foreach ($option['header'] as $h) {
                $ret .= '"' . $h . '",';
            }
            $ret .= "\r\n";
            header("Content-Type: application/text/plain; charset=UTF-8");
//        header("Content-Type: application/vnd.ms-excel; charset=GB2312");
            header("Content-Disposition: attachment;filename=" . $option['title'] . ".csv ");
        }
        foreach ($data as $item) {
            foreach ($item as $it) {
                $ret .= '"' . $it . '",';
            }
            $ret .= "\r\n";
        }
        //转码 不然excel 打开 中文是乱码
        echo iconv("UTF-8", "GBK//IGNORE", $ret);
    }


    /*
     * admin-------ajax
     * 接口
     */

    //添加评论
    public function addcomment(){
        if (!($shop = ShopMod::get_shop_by_sp_uid()))
        {
            outError(ERROR_DBG_STEP_1);
        }
        isset($_REQUEST['product_uid']) && $comm['product_uid'] = requestInt('product_uid');
        isset($_REQUEST['user_id']) && $comm['user_id'] = requestInt('user_id');
        isset($_REQUEST['images']) && $comm['images'] = requestStringArray('images', PATTERN_URL, ';');
        isset($_REQUEST['brief']) && $comm['brief'] = requestString('brief');

        if (empty($comm))
        {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }

        $comm['shop_uid'] = $shop['uid'];
        outRight(CommentMod::add_comment($comm));

    }

    /*
    获取商品额外信息
    */
    public function get_product_extra_info()
    {
        if (!($shop = ShopMod::get_shop_by_sp_uid()) ||
            !($shop_uid = $shop['uid'])
        )
        {
            outError(ERROR_DBG_STEP_1);
        }
        if (!($product_uid = requestInt('product_uid')))
        {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }

        outRight(ProductMod::get_product_extra_info($product_uid, $shop_uid));
    }
    /*
		删除商品额外信息
	*/
    public function delete_product_extra_info()
    {
        if (!($shop = ShopMod::get_shop_by_sp_uid()))
        {
            outError(ERROR_DBG_STEP_1);
        }
        if (!($uid = requestInt('uid')) ||
            !($p = ProductMod::get_shop_product_by_uid($uid)) ||
            !($p['shop_uid'] == $shop['uid'])
        )
        {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }

        if (!($ukey = requestString('ukey', PATTERN_SEARCH_KEY)))
        {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }

        outRight(ProductMod::delete_product_extra_info($uid, $ukey, $shop['uid']));
    }
    /*
        添加编辑商品
    */
    public function add_product()
    {
        if (!($shop = ShopMod::get_shop_by_sp_uid()))
        {
            outError(ERROR_DBG_STEP_1);
        }
        if (isset($_REQUEST['title']) && !($product['title'] = requestStringLen('title', 64)))
        {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }
        isset($_REQUEST['title_second']) && $product['title_second'] = requestString('title_second');
        isset($_REQUEST['title_third']) && $product['title_third'] = requestString('title_third');
        isset($_REQUEST['content']) && $product['content'] = requestString('content');
        isset($_REQUEST['main_img']) && $product['main_img'] = requestString('main_img', PATTERN_URL);
        isset($_REQUEST['images']) && $product['images'] = implode(';', requestStringArray('images', PATTERN_URL, ';'));
        isset($_REQUEST['price']) && $product['price'] = requestInt('price');
        isset($_REQUEST['ori_price']) && $product['ori_price'] = requestInt('ori_price');

        isset($_REQUEST['group_price']) && $product['group_price'] = requestInt('group_price');
        isset($_REQUEST['group_cnt']) && $product['group_cnt'] = requestInt('group_cnt');

        isset($_REQUEST['quantity']) && $product['quantity'] = requestInt('quantity');
        isset($_REQUEST['product_code']) && $product['product_code'] = requestString('product_code', PATTERN_NORMAL_STRING);
        isset($_REQUEST['package']) && $product['package'] = requestInt('package');
        isset($_REQUEST['send_time']) && $product['send_time'] = requestKvJson('send_time');
        isset($_REQUEST['kill_time']) && $product['kill_time'] = requestKvJson('kill_time');

        isset($_REQUEST['info']) && $product['info'] = requestInt('info');
        isset($_REQUEST['point_price']) && $product['point_price'] = requestInt('point_price'); //积分兑换所需积分数
        isset($_REQUEST['back_point']) && $product['back_point'] = requestInt('back_point'); //返还积分点数
        isset($_REQUEST['buy_limit']) && $product['buy_limit'] = requestInt('buy_limit');
        isset($_REQUEST['sku_table']) && $product['sku_table'] = requestString('sku_table');//todo check sku_table
        isset($_REQUEST['location']) && $product['location'] = requestString('location');//todo check location
        isset($_REQUEST['delivery_uid']) && $product['delivery_uid'] = requestInt('delivery_uid');
        isset($_REQUEST['sort']) && $product['sort'] = requestInt('sort');
        isset($_REQUEST['status']) && $product['status'] = requestInt('status');
        isset($_REQUEST['cat_uid']) && $product['cat_uid'] = requestInt('cat_uid');
        isset($_REQUEST['biz_uid']) && $product['biz_uid'] = requestInt('biz_uid');
        isset($_REQUEST['bas_services']) && $product['bas_services'] = requestStringArray('bas_services');
        isset($_REQUEST['else_info']) && $product['else_info'] = requestString('else_info');
        isset($_REQUEST['video_url']) && $product['video_url'] = requestString('video_url',PATTERN_URL);
        isset($_REQUEST['product_uids']) && $product['product_uids'] = requestString('product_uids');

        isset($_REQUEST['virtual_info']) && $product['virtual_info'] = requestKvJson('virtual_info');

        if (empty($product))
        {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }
        isset($_REQUEST['uid']) && $product['uid'] = requestInt('uid');
        $product['shop_uid'] = $shop['uid'];

        outRight(ProductMod::add_or_edit_product($product));
    }
    /*
        复制商品
    */
    public function copyproduct()
    {
        if (!($shop = ShopMod::get_shop_by_sp_uid()))
        {
            outError(ERROR_DBG_STEP_1);
        }
        if (isset($_REQUEST['uid']) && !($uid = requestInt('uid')))
        {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }
//		$product['shop_uid'] = $shop['uid'];

        outRight(ProductMod::copy_product($uid));
    }
    /*
        删除商品
    */
    public function delproduct()
    {
        if (!($shop = ShopMod::get_shop_by_sp_uid()))
        {
            outError(ERROR_DBG_STEP_1);
        }
        if (!($aids = requestIntArray('uids')))
        {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }

        Event::addHandler('Afterdelete_product',array('ProductMod', 'onAfterdelete_product'));

        outRight(ProductMod::delete_products($aids, $shop['uid']));
    }

    /*
        获取运费模板
    */
    public function getdelivery()
    {
        if (!($shop = ShopMod::get_shop_by_sp_uid()))
        {
            outError(ERROR_DBG_STEP_1);
        }
        if ($uid = requestInt('uid'))
        {
            $d = DeliveryMod::get_shop_delivery_by_uid($uid);
            if (!$d || ($d['shop_uid'] != $shop['uid']))
            {
                $d = array();
            }
        }
        else
        {
            $d = DeliveryMod::get_shop_delivery($shop['uid']);
        }

        outRight($d);
    }

    public function reply_comment()
    {
        if (!($shop = ShopMod::get_shop_by_sp_uid()))
        {
            outError(ERROR_DBG_STEP_1);
        }
        //留言uid
        if (!($m['parent_uid'] = requestInt('uid')) ||
            !($m['brief'] = requestString('brief'))
        )
        {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }
        $m['shop_uid'] = $shop['uid'];

        outRight(CommentMod::reply_comment($m));
    }

    /*
    评论状态
    */
    public function reviewcomment()
    {
        if (!($shop = ShopMod::get_shop_by_sp_uid()))
        {
            outError(ERROR_DBG_STEP_1);
        }
        if (!($mids = requestIntArray('uids')))
        {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }
        $status = requestInt('status'); //0正常, 1 隐藏

        outRight(CommentMod::review_comment($mids, $status, $shop['uid']));
    }

    /*
    删除订单
*/
    public function delete_order()
    {
        if (!($shop = ShopMod::get_shop_by_sp_uid()))
        {
            outError(ERROR_DBG_STEP_1);
        }
        if (!($uid = requestInt('uid')) ||
            !($o = OrderMod::get_order_by_uid($uid)) ||
            !($o['shop_uid'] == $shop['uid'])
        )
        {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }
        Event::addHandler('AfterDeleteOrder', array('CouponMod', 'onAfterDeleteOrder'));
        outRight(OrderMod::delete_order($o));
    }

    /*
        发货
    */
    public function do_delivery()
    {
        if (!($shop = ShopMod::get_shop_by_sp_uid()))
        {
            outError(ERROR_DBG_STEP_1);
        }
        $uids = requestIntArray('uid');
        if(!is_array($uids)) {
            $uids = array($uids);
        }
        $outR = array();
        foreach ($uids as $k => $uid){
//            $uid = requestInt('uid')
            if (!($uid) ||
                !($o = OrderMod::get_order_by_uid($uid)) ||
                !($o['shop_uid'] == $shop['uid'])
            )
            {
                outError(ERROR_INVALID_REQUEST_PARAM);
            }

            if (!$deliver_info = requestKvJson('delivery_info'))
            {
                $deliver_info = array();
            }
            Event::addHandler('AfterSendGoods', array('OrderMod', 'onAfterSendGoods'));
            $outR[$k] = OrderMod::do_send_goods($o, $deliver_info);

        }

        outRight($outR);
    }

    /*
        收货
    */
    public function do_receipt()
    {
        if (!($shop = ShopMod::get_shop_by_sp_uid())) {
            outError(ERROR_DBG_STEP_1);
        }
        if (!($uid = requestInt('uid')) ||
            !($o = OrderMod::get_order_by_uid($uid)) ||
            !($o['shop_uid'] == $shop['uid'])
        ) {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }
        Event::addHandler('AfterRecvGoods', array('OrderMod', 'onAfterRecvGoods'));
        outRight(OrderMod::do_recv_goods($o));
    }
    /*
    申请退款
    */
    public function addrefund()
    {
        if (!($shop = ShopMod::get_shop_by_sp_uid()))
        {
            outError(ERROR_DBG_STEP_1);
        }
        if (!($uid = requestInt('uid')) ||       //订单号uid
            !($order = OrderMod::get_order_by_uid($uid)) ||
            !($order['shop_uid'] == $shop['uid'])
        )
        {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }

        //退款信息 理由,图片等  {reason: 质量不好, images: [1.jpg,2.jpg]}
        $r['refund_info'] = requestKvJson('refund_info');
        $r['refund_fee']  = requestInt('refund_fee');
        Event::addHandler('AfterAddRefund', array('RefundMod', 'onAfterAddRefund'));
        outRight(RefundMod::do_add_refund($order, $r));
    }

    /*
    退款处理 同意/拒绝
    */
    public function acceptrefund()
    {
        if (!($shop = ShopMod::get_shop_by_sp_uid()))
        {
            outError(ERROR_DBG_STEP_1);
        }
        if (!($uid = requestInt('uid')) ||       //订单号uid
            !($refund = RefundMod::get_refund_by_order_uid($uid)) ||
            !($refund['shop_uid'] == $shop['uid'])
        )
        {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }

        $accept = requestBool('accept', true); //1同意退款, 0 拒绝退款
        //拒绝理由   {sp_reason: 拒不退款}
        $refund_info = requestKvJson('refund_info');
        if ($accept)
        {
            Event::addHandler('AfterPayRefund', array('RefundMod', 'onAfterPayRefund'));

        }
        else
        {
            Event::addHandler('AfterAcceptRefund', array('RefundMod', 'onAfterAcceptRefund'));

        }
        outRight(RefundMod::do_accept_refund($refund, $accept, $refund_info));
    }

    /*
    退团操作
    */
    public function dorefundgroup()
    {
        if (!($shop = ShopMod::get_shop_by_sp_uid()))
        {
            outError(ERROR_DBG_STEP_1);
        }
        if (!($uid = requestInt('uid')) ||       //订单号uid
            !($order = OrderMod::get_order_by_uid($uid)) ||
            !($order['shop_uid'] == $shop['uid'])
        )
        {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }

        Event::addHandler('AfterPayRefund', array('RefundMod', 'onAfterPayRefundGroup'));
        outRight(RefundMod::do_refund_group($order));
    }

    /*
    添加编辑优惠劵
    */
    public function add_or_edit_bizcoupon()
    {
        $shop = $this->init_shop();
        $biz   = $this->init_biz();

        $d['biz_uid'] = $biz['uid'];

        if (isset($_REQUEST['title']) && !($d['title'] = requestStringLen('title', 64)))
        {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }
        isset($_REQUEST['publish_cnt']) && $d['publish_cnt'] = requestInt('publish_cnt');
        isset($_REQUEST['duration']) && $d['duration'] = requestInt('duration');

        isset($_REQUEST['image']) && $d['img'] = requestString('image', PATTERN_URL);
        isset($_REQUEST['brief']) && $d['brief'] = requestString('brief');
        isset($_REQUEST['valuation']) && $d['valuation'] = requestInt('valuation');
        isset($_REQUEST['rule']) && $d['rule'] = requestKvJson('rule'); //todo check rule

        if (empty($d))
        {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }
        isset($_REQUEST['uid']) && $d['uid'] = requestInt('uid');

        outRight(BizCouponMod::add_or_edit_biz_coupon($d));
    }

	/*
    修改密码
	*/
	public function password() {
        $shop = $this->init_shop();
        $biz   = $this->init_biz();
        if($_SERVER['REQUEST_METHOD'] == 'POST') {
            $old = requestString('old', PATTERN_PASSWD);
            $new = requestString('new', PATTERN_PASSWD);
            if(!$new) {
                outError(ERROR_INVALID_REQUEST_PARAM);
            }
            outRight(ShopBizMod::change_biz_password($old, $new, $biz['uid']));
        }
		
        $params = array('shop' => $shop, 'biz' => $biz);
        $this->admin_render($params);
	}


}
