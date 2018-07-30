<?php

class SpCtl {
	/*
		获取左侧菜单项
	*/
	public function get_menu_array()
	{
		/*
			activeurl 确定是否为选中状态
		*/
		return array(
			array('name' => '首页', 'icon' => 'am-icon-home', 'link' => '?_a=shop&_u=sp', 'activeurl' => 'sp.index'),
			array('name'  => '会员管理',
				'icon'  => 'am-icon-user',
				'menus' => array(
					array('name'      => '会员列表',
						'icon'      => 'am-icon-user',
						'link'      => '?_a=su&_u=sp.fanslist',
						'activeurl' => 'sp.fanslist'),
				      array('name'      => '留言墙',
				            'icon'      => 'am-icon-edit',
				            'link'      => '?_a=shop&_u=sp.messagelist',
				            'activeurl' => 'sp.messagelist'),
				      array('name'      => '会员卡',
				            'icon'      => 'am-icon-list-alt',
				            'link'      => '?_a=vipcard&_u=sp.index',
				            'activeurl' => 'sp.vipcard'),
				)),
	
			array('name'  => '商品管理',
			      'icon'  => 'am-icon-shopping-cart',
			      'menus' => array(
				      array('name'      => '导入excel商品数据',
				            'icon'      => 'am-icon-file-excel-o',
				            'link'      => '?_a=shop&_u=sp.ugoodsexcel',
				            'activeurl' => 'sp.ugoodsexcel',
				            'hide'      => true),
				      array('name'      => '商品分类',
				            'icon'      => 'am-icon-th-large',
				            'link'      => '?_a=shop&_u=sp.catlist',
				            'activeurl' => 'sp.catlist'),
				      array('name'      => '商品列表',
				            'icon'      => 'am-icon-shopping-cart',
				            'link'      => '?_a=shop&_u=sp.productlist',
				            'activeurl' => 'sp.productlist'),
					  array('name'      => '秒杀列表',
						  'icon'      => 'am-icon-bolt',
						  'link'      => '?_a=shop&_u=sp.productkilllist',
						  'activeurl' => 'sp.productkilllist'),
					  array('name'      => '团购列表',
						  'icon'      => 'am-icon-group',
						  'link'      => '?_a=shop&_u=sp.productgrouplist',
						  'activeurl' => 'sp.productgrouplist'),
					  array('name'      => '评论管理',
						  'icon'      => 'am-icon-file',
						  'link'      => '?_a=shop&_u=sp.productcomment',
						  'activeurl' => 'sp.productcomment'),
			      )),
			/*
			array('name'      => '订单管理',
			      'icon'      => 'am-icon-files-o',
			      'link'      => '?_a=shop&_u=sp.orderlist',
			      'activeurl' => 'sp.orderlist'),
			*/
			array('name'  => '订单管理',
			      'icon'  => 'am-icon-files-o',
			      'menus' => array(
					  array('name'      => '全部订单',
						  'icon'      => 'am-icon-files-o',
						  'link'      => '?_a=shop&_u=sp.orderlist',
						  'activeurl' => 'sp.orderlist&all'),
					  array('name'      => '团购订单',
						  'icon'      => 'am-icon-users',
						  'link'      => '?_a=shop&_u=sp.orderlist&is_group=1',
						  'activeurl' => 'sp.orderlist&is_group=1'),
					  array('name'      => '订单改价',
						  'icon'      => 'am-icon-money',
						  'link'      => '?_a=shop&_u=sp.orderlist&status=1',
						  'activeurl' => 'sp.orderlist&status=1'),
					  array('name'      => '订单发货',
						  'icon'      => 'am-icon-truck',
						  'link'      => '?_a=shop&_u=sp.orderlist&status=2',
						  'activeurl' => 'sp.orderlist&status=2'),
					  array('name'      => '退换货',
						  'icon'      => 'am-icon-info-circle',
						  'link'      => '?_a=shop&_u=sp.orderlist&status=8',
						  'activeurl' => 'sp.orderlist&status=8'),
					),
			),
			array('name'  => '运营统计',
			      'icon'  => 'am-icon-line-chart',
			      'menus' => array(
					  array('name'      => '流量统计',
						  'icon'      => 'am-icon-line-chart',
						  'link'      => '?_a=shop&_u=sp.visit_record',
						  'activeurl' => 'sp.visit_record'),
					  array('name'      => '货单统计',
						  'icon'      => 'am-icon-line-chart',
						  'link'      => '?_a=shop&_u=sp.order_record',
						  'activeurl' => 'sp.order_record'),
					      ),
			),
			array('name'  => '商家管理',
				'icon'  => 'am-icon-university',
				'menus' => array(
					array('name' => '基本设置',
						'icon' => 'am-icon-gear',
						'link' => '?_a=shop&_u=sp.biz_set',
						'activeurl' => 'sp.biz_set'),
					array('name' => '商家分类',
						'icon' => 'am-icon-cubes',
						'link' => '?_a=shop&_u=sp.bizcatlist',
						'activeurl' => 'sp.bizcatlist'),
					array('name' => '商家入驻',
						'icon' => 'am-icon-cubes',
						'link' => '?_a=shop&_u=sp.bizlist',
						'activeurl' => 'sp.bizlist'),
					array('name'      => '入驻须知',
						'icon'      => 'am-icon-file',
						'link'      => '?_a=shop&_u=sp.biz_know',
						'activeurl' => 'sp.biz_know'),
				),
			),

			array('name'  => '营销推广',
			      'icon'  => 'am-icon-bullhorn',
			      'menus' => array(
					array('name'    => '全场满减',
						'icon'  => 'am-icon-money',
						'link'  => '?_a=shop&_u=sp.shop_discount',
						'activeurl' => 'sp.shop_discount'),
					array('name'    => '全场包邮',
						'icon'  => 'am-icon-money',
						'link'  => '?_a=shop&_u=sp.delivery_discount',
						'activeurl' => 'sp.delivery_discount'),
				      array('name'      => '优惠券管理',
				            'icon'      => 'am-icon-money',
				            'link'      => '?_a=shop&_u=sp.shopcoupon',
				            'activeurl' => 'sp.shopcoupon'),
				      array('name'      => '优惠券发放记录',
				            'icon'      => 'am-icon-list',
				            'link'      => '?_a=shop&_u=sp.usercoupon',
				            'activeurl' => 'sp.usercoupon'),
//					array('name'    => '促销活动管理',
//						'icon'  => 'am-icon-bullhorn',
//						'link'  => '?_a=shop&_u=sp.activitylist',
//						'activeurl' => 'sp.activitylist'),
					array('name'    => '二维码海报转发',
						'icon'  => 'am-icon-qrcode',
						'link'  => '?_a=qrposter&_u=sp',
						'activeurl' => 'sp.qrposter'),
//					array('name'    => '大转盘抽奖',
//						'icon'  => 'am-icon-gift',
//						'link'  => '?_a=reward&_u=sp',
//						'activeurl' => 'sp.reward'),
				),),

			array('name'  => '店铺设置',
			      'icon'  => 'am-icon-gear',
			      'menus' => array(
				      array('name'      => '基本设置',
				            'icon'      => 'am-icon-gear',
				            'link'      => '?_a=shop&_u=sp.set',
				            'activeurl' => 'sp.set'),
					  array('name'      => '配送范围',
							'icon'      => 'am-icon-th-list',
							'link'      => '?_a=shop&_u=sp.address',
							'activeurl' => 'sp.address'),
				      array('name'      => '首页轮播图',
				            'icon'      => 'am-icon-image',
				            'link'      => '?_a=shop&_u=sp.slidelist',
				            'activeurl' => 'sp.slidelist'),
				      array('name' => '支付方式', 'icon' => 'am-icon-money', 'link' => '?_a=pay&_u=sp',
				      		'activeurl' => 'sp.paylist'),
				      array('name'      => '运费模板',
				            'icon'      => 'am-icon-truck',
				            'link'      => '?_a=shop&_u=sp.deliverytemplate',
				            'activeurl' => 'sp.deliverytemplate'),
					  array('name' => '网站颜色',
						  'icon' => 'am-icon-eyedropper',
						  'link' => '?_a=shop&_u=sp.setcolors',
						  'activeurl' => 'sp.setcolors'),
					  array('name' => '打印机设置',
						  'icon' => 'am-icon-print',
						  'link' => '?_a=shop&_u=sp.gugujilist',
						  'activeurl' => 'sp.gugujilist'),
					  array('name' => '其他设置',
						  'icon' => 'am-icon-gear',
						  'link' => '?_a=sp&_u=index.slidelist',
						  'activeurl' => 'sp.slidelist'),
//				    array('name'      => '首页设置',
//					    'icon'      => 'am-icon-file',
//					    'link'      => '?_a=shop&_u=sp.index_view',
//					    'activeurl' => 'sp.index_view'),
			      )),
			array('name'  => '文章管理',
				'icon'  => 'am-icon-file',
				'menus' => array(
//					array('name'      => '红包公告',
//						'icon'      => 'am-icon-file',
//						'link'      => '?_a=shop&_u=sp.red_bag',
//						'activeurl' => 'sp.red_bag'),
//					array('name'      => '购前须知',
//						'icon'      => 'am-icon-file',
//						'link'      => '?_a=shop&_u=sp.know_beforelist',
//						'activeurl' => 'sp.know_beforelist'),
					array('name'      => '广播管理',
						'icon'      => 'am-icon-bullhorn',
						'link'      => '?_a=shop&_u=sp.radiolist',
						'activeurl' => 'sp.radiolist'),
//					array('name'      => '基础服务',
//						'icon'      => 'am-icon-file',
//						'link'      => '?_a=shop&_u=sp.baseservices',
//						'activeurl' => 'sp.baseservices'),
				)),
//				array('name'  => 'O2O配送管理',
//				'icon'  => 'am-icon-list',
//				'menus' => array(
//					array('name'      => '地址级名称管理',
//						'icon'      => 'am-icon-th-large',
//						'link'      => '?_a=shop&_u=sp.address_name',
//						'activeurl' => 'sp.address_name'),
//					array('name' => '配送员管理',
//						'icon' => 'am-icon-user',
//						'link' => '?_a=shop&_u=sp.deliveries',
//						'activeurl' => 'sp.deliveries'),
//
//				)),
			array('name'  => '分销管理',
				'icon'  => 'am-icon-users',
				'menus' => array(
					array('name'      => '基本设置',
						'icon'      => 'am-icon-gear',
						'link'      => '?_a=shop&_u=sp.distribution',
						'activeurl' => 'sp.distribution',
						'hide'      => false),
					array('name'      => '分销协议',
						'icon'      => 'am-icon-file',
						'link'      => '?_a=shop&_u=sp.user_agreement',
						'activeurl' => 'sp.user_agreement'),
					array('name'      => '分销商品设置',
						'icon'      => 'am-icon-gear',
						'link'      => '?_a=shop&_u=sp.distribution_productlist',
						'activeurl' => 'sp.distribution_productlist'),

					array('name'      => '分销记录',
						'icon'      => 'am-icon-th-large',
						'link'      => '?_a=shop&_u=sp.distributionlist',
						'activeurl' => 'sp.distributionlist'),
					array('name'      => '分销成员管理',
						'icon'      => 'am-icon-cubes',
						'link'      => '?_a=shop&_u=sp.distribution_user_list',
						'activeurl' => 'sp.distribution_user_list'),
				)),
		);
	}

	protected function sp_render($params = array())
	{
		if (!empty($params['shop']) && empty($GLOBALS['_UCT']['TPL']))
		{
			//后台模板选择
			unset($_REQUEST['__tpl']);
			unset($_COOKIE['__tpl_shop']);
			$GLOBALS['_UCT']['TPL'] = $params['shop']['tpl'] ? $params['shop']['tpl'] : 'wap';
		}
		$params['menu_array'] = $this->get_menu_array();

		//todo 部分客户隐藏分销功能
		$hide = empty($_REQUEST['_d']) && 
		in_array(AccountMod::get_current_service_provider('uid'), array(1068, 1070, 1078,1079));
		if($hide) array_pop($params['menu_array']);
		
		//todo 工程设计，先把编辑打开
		if(0 && in_array(AccountMod::get_current_service_provider('uid'), array(2))) {
		array_unshift($params['menu_array'], 
					array('name'      => '小程序首页装修',
						'icon'      => 'am-icon-cubes',
						'link'      => '?_a=shop&_u=sp.index_view',
						'activeurl' => 'sp.index_view'));
		}

		render_sp_inner('', $params);
	}

	public function error()
	{
		echo '内部错误! ' . getErrorString();
	}

	public function index2()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}

		$today = strtotime('today');
		//订单数
		$sql                      = 'select count(*) from shop_order where shop_uid = ' . $shop['uid']
			. ' && status != ' . OrderMod::ORDER_CANCELED;
		$cnts['total_orders_cnt'] = Dba::readOne($sql);
		$sql .= ' && create_time >= ' . $today;
		$cnts['today_orders_cnt'] = Dba::readOne($sql);

		//成交额, 以 已支付为准
		$sql                    = 'select sum(paid_fee) from shop_order where shop_uid = ' . $shop['uid'] . ' && status in (' . implode(',', array(
				OrderMod::ORDER_WAIT_FOR_DELIVERY,
				OrderMod::ORDER_WAIT_USER_RECEIPT,
				OrderMod::ORDER_DELIVERY_OK,
				OrderMod::ORDER_COMMENT_OK)) . ')';
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

		$sql                       = 'select count(*) from shop_order where shop_uid = ' . $shop['uid'] . ' && status = ' . OrderMod::ORDER_WAIT_FOR_DELIVERY;
		$cnts['wait_delivery_cnt'] = Dba::readOne($sql);

		$sql                          = 'select count(*) from shop_order where shop_uid = ' . $shop['uid'] . ' && status = ' . OrderMod::ORDER_UNDER_NEGOTATION;
		$cnts['under_negotation_cnt'] = Dba::readOne($sql);

		//库存报警数
		$sql                   = 'select count(*) from product where shop_uid = ' . $shop['uid'] . ' && status = 0 && quantity <= 5';
		$cnts['stock_low_cnt'] = Dba::readOne($sql);

		$sql             = 'select count(*) from shop_visit_record where shop_uid =' . $shop['uid'] . ' && create_time >= ' . $today;
		$cnts['shop_pv'] = Dba::readOne($sql);

		$sql             = 'select count(distinct(user_ip)) from shop_visit_record where shop_uid =' . $shop['uid'] . ' && create_time >= ' . $today;
		$cnts['shop_uv'] = Dba::readOne($sql);

		$sql                = 'select count(*) from shop_visit_record where shop_uid =' . $shop['uid'] . ' && create_time >= ' . $today . ' && product_uid !=0';
		$cnts['product_pv'] = Dba::readOne($sql);
		$sql                = 'select count(distinct(user_ip)) from shop_visit_record where shop_uid =' . $shop['uid'] . ' && create_time >= ' . $today . ' && product_uid !=0';
		$cnts['product_uv'] = Dba::readOne($sql);

		$params = array('shop' => $shop, 'cnts' => $cnts);
		$this->sp_render($params);
	}

	public function gaikuang() {
		return $this->index();
	}

	public function index()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}

		$today = strtotime('today');
		//订单数
		$sql                      = 'select count(*) from shop_order where shop_uid = ' . $shop['uid']
			. ' && status != ' . OrderMod::ORDER_CANCELED;
		$cnts['total_orders_cnt'] = Dba::readOne($sql);
		$sql .= ' && create_time >= ' . $today;
		$cnts['today_orders_cnt'] = Dba::readOne($sql);
		#if(!empty($_GET['_d'])) die($sql);

		//成交额, 以 已支付为准
		$sql                    = 'select sum(paid_fee) from shop_order where shop_uid = ' . $shop['uid'] . ' && status in (' . implode(',', array(
				OrderMod::ORDER_WAIT_FOR_DELIVERY,
				OrderMod::ORDER_WAIT_USER_RECEIPT,
				OrderMod::ORDER_DELIVERY_OK,
				OrderMod::ORDER_WAIT_GROUP_DONE,
				OrderMod::ORDER_COMMENT_OK)) . ')';
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

		//今日注册会员数
		$sql  = 'select count(*) from shop_biz where shop_uid = ' . $shop['uid'];
		$sql .= ' && create_time >= ' . $today;
		$cnts['today_addbiz_cnt'] = Dba::readOne($sql);
		//今日注册会员数
		$sql  = 'select count(*) from service_user where sp_uid = ' . $shop['sp_uid'];
		$sql .= ' && create_time >= ' . $today;
		$cnts['today_adduser_cnt'] = Dba::readOne($sql);

		$sql                       = 'select count(*) from shop_order where shop_uid = ' . $shop['uid'] . ' && status = ' . OrderMod::ORDER_WAIT_USER_PAY;
		$cnts['wait_pay_cnt'] = Dba::readOne($sql);
		$sql                       = 'select count(*) from shop_order where shop_uid = ' . $shop['uid'] . ' && status = ' . OrderMod::ORDER_WAIT_FOR_DELIVERY;
		$cnts['wait_delivery_cnt'] = Dba::readOne($sql);
		$sql                       = 'select count(*) from shop_order where shop_uid = ' . $shop['uid'] . ' && status = ' . OrderMod::ORDER_WAIT_USER_RECEIPT;
		$cnts['wait_receipt_cnt'] = Dba::readOne($sql);
		$sql                       = 'select count(*) from shop_order where shop_uid = ' . $shop['uid'] . ' && status = ' . OrderMod::ORDER_DELIVERY_OK;
		$cnts['ok_cnt'] = Dba::readOne($sql);
		$sql                          = 'select count(*) from shop_order where shop_uid = ' . $shop['uid'] . ' && status = ' . OrderMod::ORDER_UNDER_NEGOTATION;
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
		$sql[0] .= ' from shop_visit_record where shop_uid = "' . $shop['uid'] . '" ' . $where_time . $where_a_uid . ' group by days;';
		$sql[1] = 'select from_unixtime(create_time,"%Y-%m-%d") as days,count(distinct user_ip) as count ';
		$sql[1] .= ' from shop_visit_record where shop_uid = "' . $shop['uid'] . '" ' . $where_time . $where_a_uid . ' group by days;';
		$sql[2] = 'select from_unixtime(create_time,"%Y-%m-%d") as days,count(*) as count ';
		$sql[2] .= ' from shop_visit_record where shop_uid = "' . $shop['uid'] . '" ' . $where_time . ' && ' . $where . ' ' . $where_a_uid . ' group by days;';
		$sql[3] = 'select from_unixtime(create_time,"%Y-%m-%d") as days,count(distinct user_ip) as count ';
		$sql[3] .= ' from shop_visit_record where shop_uid = "' . $shop['uid'] . '" ' . $where_time . '  && ' . $where . ' ' . $where_a_uid . ' group by days;';
		//统计日订单数
		$sql[4] = 'select from_unixtime(create_time,"%Y-%m-%d") as days,count(*) as count ';
		$sql[4] .= ' from shop_order where shop_uid = "' . $shop['uid'] . '" ' . $where_time . '  group by days;';
		//统计日销售额
		$where_time  = ' && paid_time >=' . $start_time .
			(' && paid_time <=' . $end_time);
		$sql[5] = 'select from_unixtime(create_time,"%Y-%m-%d") as days,sum(paid_fee+cash_fee) as count ';
		$sql[5] .= ' from shop_order where shop_uid = "' . $shop['uid'] . '" ' . $where_time . '  group by days;';

		$echarts = array();


		for ($i = $start_time; $i < $end_time; $i = $i + 60 * 60 * 24)
		{
			$echarts['xAxis']['data'][]  = date('Y-m-d', $i);
		}

		for ($i = 0; $i < 6; $i++)
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

		//获取当前服务号信息
		$uct_token = SpMod::has_weixin_public_set();
		$wx = Dba::readRowAssoc('select * from weixin_public where uct_token = "'.$uct_token.'"', 'WeixinMod::func_get_weixin');

		$params = array('shop' => $shop, 'cnts' => $cnts,'echarts'=>$echarts,'uct_token'=>$uct_token,'wx'=>$wx);
		$this->sp_render($params);
	}
	/*
	 * 分销协议
	 */
	public function user_agreement()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['shop_uid'] = $shop['uid'];
		$option['type_in'] = 3;
		$document = DocumentMod::get_documents_know($option);

		$params     = array('shop' => $shop,'document' => $document);
		$this->sp_render($params);
	}
	/*
	 * 红包公告
	 */
	public function red_bag()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['shop_uid'] = $shop['uid'];
		$option['type_in'] = 2;
		$document = DocumentMod::get_documents_know($option);

		if(!isset($GLOBALS['arraydb_sys']['cfg_set_red_bag'.$shop['sp_uid']])){
			$GLOBALS['arraydb_sys']['cfg_set_red_bag'.$shop['sp_uid']] = 0;
		}

		$send_times = $GLOBALS['arraydb_sys']['cfg_set_red_bag'.$shop['sp_uid']];

		$params     = array('shop' => $shop,'document' => $document,'send_times'=>$send_times);
		$this->sp_render($params);
	}
	/*
	 * 购前须知列表
	 */
	public function know_beforelist()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['shop_uid'] = $shop['uid'];
		$option['type_in'] = 1;
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
		$documents = DocumentMod::get_documents_radio($option);

		$pagination = uct_pagination($option['page'], ceil($documents['count']/$option['limit']),
			'?_a=sp&_u=sp.radiolist&limit='.$option['limit'].'&page=');

		$params = array('documents' => $documents, 'pagination' => $pagination);
		$this->sp_render($params);
	}
	/*
	 * 购前须知
	 */
	public function addknow_before()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$uid = requestInt('uid');
		$document = DocumentMod::get_document_by_uid($uid);


		$params = array('document' => $document);
		$this->sp_render($params);
	}
	/*
    广播例表
	*/
	public function radiolist(){

		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['shop_uid'] = $shop['uid'];
		$option['type_in'] = 0;
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
		$documents = DocumentMod::get_documents_radio($option);

		$pagination = uct_pagination($option['page'], ceil($documents['count']/$option['limit']),
			'?_a=sp&_u=sp.radiolist&limit='.$option['limit'].'&page=');

		$params = array('documents' => $documents, 'pagination' => $pagination);
		$this->sp_render($params);
	}
	/*
		添加和编辑广播
	*/
	public function addradio(){
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$uid = requestInt('uid');
		$document = DocumentMod::get_document_by_uid($uid);


		$params = array('document' => $document);
		$this->sp_render($params);
	}
	/*
	基础服务
	*/
	public function baseservices(){

		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['shop_uid'] = $shop['uid'];
		$option['type_in'] = 5;
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
		$documents = DocumentMod::get_documents_radio($option);

		$pagination = uct_pagination($option['page'], ceil($documents['count']/$option['limit']),
			'?_a=sp&_u=sp.baseservices&limit='.$option['limit'].'&page=');

		$params = array('documents' => $documents, 'pagination' => $pagination);
		$this->sp_render($params);
	}
	/*
    添加和编辑基础服务
	*/
	public function addbaseservice(){
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$uid = requestInt('uid');
		$document = DocumentMod::get_document_by_uid($uid);

		$params = array('document' => $document);
		$this->sp_render($params);
	}

	//活动列表
	public function activitylist()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['shop_uid'] = $shop['uid'];
		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 10);

		$active    = ActivityMod::get_shop_activity($option);

		if(!empty($active['list'])){
			foreach($active['list'] as $k => $va){
				$active['list'][$k]['start_time'] = date('Y-m-d H:i:s', $va['start_time']);
				$active['list'][$k]['end_time'] = date('Y-m-d H:i:s', $va['end_time']);
			}
		}

		$pagination    = uct_pagination($option['page'], ceil($active['count'] / $option['limit']),
			'?_a=shop&_u=sp.activitylist&limit=' . $option['limit'] . '&page=');

		$params = array('shop'  => $shop,'active' => $active['list'] ,'pagination'=>$pagination);

//		$str = var_export($params,TRUE);
//		file_put_contents("../tt.txt",$str);
		$this->sp_render($params);
	}

	/*
    添加编辑活动
	*/
	public function addactivity()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$product_uid = requestInt('uid');
		$product     = array();
		if ($product_uid)
		{
			$product = ActivityMod::get_shop_activity_by_uid($product_uid);

			if (!$product || ($product['shop_uid'] != $shop['uid']))
			{
				$product = array();
			}
		}

		$params     = array('shop' => $shop, 'product' => $product);
		$this->sp_render($params);
	}

	/*
	 * 砍价活动
	 */
	public function bargainlsit(){

	}

	/*
	 * 支持配送地址管理
	 */
	public function address()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}

		$option['shop_uid'] = $shop['uid'];
		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 10);

		$address  = AddressMod::get_shop_address($option);

		$pagination    = uct_pagination($option['page'], ceil($address['count'] / $option['limit']),
			'?_a=shop&_u=sp.address&limit=' . $option['limit'] . '&page=');
//		var_export($address);
		$params = array('shop' => $shop,'address' => $address ,'pagination'=>$pagination);
		$this->sp_render($params);
	}
	/*
	 * 添加修改配送地址
	 */
	public function addaddress()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$uid = requestInt('uid');
		$address     = array();
		if ($uid)
		{
			$address = AddressMod::get_shop_address_by_uid($shop['uid'],$uid);

			if (!$address || ($address['shop_uid'] != $shop['uid']))
			{
				$address = array();
			}
		}

		$params     = array('shop' => $shop, 'address' => $address);
		$this->sp_render($params);
	}
	/*
	 * 地址级管理
	 */
	public function address_name()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}

		$address  = Address_NameMod::get_shop_address_name($shop['uid']);

//		var_export($address);
		$params = array('shop' => $shop,'address' => $address);
		$this->sp_render($params);
	}

	/*
    获取配送员订单信息1
	*/
	public function deliveries(){

        $option['su_uid']     = requestInt('su_uid');
		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 10);

		$list = DeliveriesMod::get_deliveries($option);

		$pagination    = uct_pagination($option['page'], ceil($list['count'] / $option['limit']),
			'?_a=shop&_u=sp.deliveries&su_uid='.$option['su_uid'].'&limit=' . $option['limit'] . '&page=');

		$params = array('list' => $list,'pagination'=>$pagination);
		$this->sp_render($params);
	}
	/*
    添加编辑配送员订单信息
	*/
	public function adddeliveries(){

		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}

		$uid = requestInt('uid');
		$d_order     = array();
		if ($uid)
		{
			$d_order = DeliveriesMod::get_deliveries_by_uid($uid);
		}

		$sql = 'select uid from groups_all where name="配送员" and sp_uid ='.$shop['sp_uid'];
		$g_uid = Dba::readOne($sql);
		$g_uid = (!empty($g_uid))?$g_uid:0;

		$params     = array( 'g_uid'=>$g_uid,'d_order' => $d_order);
		$this->sp_render($params);
	}

	public function catlist()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['shop_uid']         = $shop['uid'];
		$option['with_parent_info'] = true;
		$option['parent_uid']       = requestInt('parent_uid');
		$option['sort']             = requestInt('sort');

		$option2['shop_uid']         = $shop['uid'];
		$option2['with_parent_info'] = true;
		$option2['parent_uid']       = -1;

		$catsAll = ProductMod::get_product_cats($option2);

		$cats    = ProductMod::get_product_cats($option);
		$parents = ProductMod::get_product_cats(array('shop_uid' => $shop['uid'], 'parent_uid' => 0));
		
		$params = array('shop'    => $shop,
		                'option'  => $option,
		                'cats'    => $cats,
		                'parents' => $parents,
		                'catsAll' => $catsAll);
		$this->sp_render($params);
	}

	/*
		添加编辑分类页面
	*/
	public function addcat()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$cat_uid = requestInt('uid');
		$cat     = array();
		$parent  = null;
		if ($cat_uid)
		{
			$cat = ProductMod::get_product_cat_by_uid($cat_uid);
			if (!$cat || ($cat['shop_uid'] != $shop['uid']))
			{
				$cat = array();
			}
			if ($cat['parent_uid'])
			{

				$parent = ProductMod::get_product_cat_by_uid($cat['parent_uid']);
			}

		}
		$parents = ProductMod::get_product_cats(array('shop_uid'         => $shop['uid'],
		                                              'with_parent_info' => true,
		                                              'parent_uid'       => -1));
		$params  = array('shop' => $shop, 'cat' => $cat, 'parents' => $parents, 'parent' => $parent);
		$this->sp_render($params);
	}

	public function productlist()
	{	
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['shop_uid']  = $shop['uid'];
		$option['cat_uid']   = requestInt('cat_uid');
		$option['biz_uid']   = requestInt('biz_uid');
		$option['uid']       = requestInt('uid');
		$option['key']       = requestString('key', PATTERN_SEARCH_KEY);
		$option['page']      = requestInt('page');
		$option['limit']     = requestInt('limit', 10);
		$option['low_stock'] = requestInt('low_stock', -1); //低库存
		$option['status']    = requestInt('status',-1); //
		$option['sort']      = requestInt('sort');

		

		$option['sort']      = requestInt('sort', SORT_CREATE_TIME); //排序

		$products   = ProductMod::get_shop_products($option, 0);
		$dtb = DistributionMod::get_dtb_rule_by_shop_uid($shop['uid']);

		$cats       = ProductMod::get_product_cats(array('shop_uid'         => $shop['uid'],
		                                                 'with_parent_info' => true,
		                                                 'parent_uid'       => -1));
		$pagination = uct_pagination($option['page'], ceil($products['count'] / $option['limit']),
			'?_a=shop&_u=sp.productlist&cat_uid=' . $option['cat_uid'] . '&biz_uid=' . $option['biz_uid'] . '&low_stock=' . $option['low_stock'] . '&key='
			. $option['key'] . '&status=' . $option['status'] . '&limit=' . $option['limit'] . '&page=');
		//		var_dump(__file__.' line:'.__line__,$products);exit;
		$params = array('shop'       => $shop,
						'dtb'		 => $dtb,
		                'option'     => $option,
		                'products'   => $products,
		                'cats'       => $cats,
		                'pagination' => $pagination);
		// var_dump($option);die;

		$this->sp_render($params);
	}

	//秒杀商品
	public function productkilllist()
	{
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
		$option['info'] = 32;

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

	//团购商品
	public function productgrouplist()
	{
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
		//		var_dump(__file__.' line:'.__line__,$products);exit;
		$params = array('shop'       => $shop,
			'dtb'		 => $dtb,
			'option'     => $option,
			'products'   => $products,
			'cats'       => $cats,
			'pagination' => $pagination);

		$this->sp_render($params);
	}
	/*
	 * 评论管理
	 */
	public function productcomment()
	{
		uct_check_mirror_tpl_access(); //搜索框可能会有需要

		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['shop_uid'] = $shop['uid'];
		$option['key']      = requestString('key', PATTERN_SEARCH_KEY);
		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 10);

		$comment   = CommentMod::get_product_comments($option);
		$pagination = uct_pagination($option['page'], ceil($comment['count'] / $option['limit']),
			'?_a=shop&_u=sp.productcomment&key=' . $option['key'] . '&limit=' . $option['limit'] . '&page=');

//		var_dump($comment);
		$params = array('shop' => $shop, 'option' => $option, 'comment' => $comment, 'pagination' => $pagination);
		$this->sp_render($params);

	}

	/*
	 * 评论管理v3
	 */
	public function commentslist()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['shop_uid'] = $shop['uid'];
		$option['key']      = requestString('key', PATTERN_SEARCH_KEY);
		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 10);

		$comment   = CommentMod::get_product_comments($option);
		$pagination = uct_pagination($option['page'], ceil($comment['count'] / $option['limit']),
			'?_a=shop&_u=sp.commentslist&key=' . $option['key'] . '&limit=' . $option['limit'] . '&page=');

		$cfg = CommentMod::get_comment_cfg($shop['uid']);
		$params = array('shop' => $shop, 'cfg' => $cfg, 'option' => $option, 'comment' => $comment, 'pagination' => $pagination);
		// var_dump($params);die;
		$this->sp_render($params);

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
		$this->sp_render($params);
	}

	/*
	 * 评论回复
	 */
	public function edit_comment()
	{
		uct_check_mirror_tpl_access();

		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		};
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
		$this->sp_render($params);
	}

	/*
		添加编辑商品
	*/
	public function addproduct()
	{
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

	/*
		订单详情
	*/
	public function orderdetail()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		if (!($uid = requestInt('uid')) ||
			!($o = OrderMod::get_order_by_uid($uid)) ||
			!($o['shop_uid'] == $shop['uid'])
		)
		{
			redirectTo('?_a=shop&_u=sp.orderlist');
		}

		$params = array('shop' => $shop, 'order' => $o);
		$this->sp_render($params);
	}

	/*
		二次购买折扣
	*/
	public function discount()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$dtb = DistributionMod::get_dtb_rule_by_shop_uid($shop['uid']);

		$params = array('shop' => $shop, 'dtb' => $dtb);
		$this->sp_render($params);
	}

	public function orderlist()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['shop_uid'] = $shop['uid'];
		$option['user_id']  = requestInt('user_id');
		$option['biz_uid']  = requestInt('biz_uid');
		$option['status']   = requestInt('status');
		$option['isnormal'] = requestInt('isnormal');
		$option['key']      = requestString('key', PATTERN_SEARCH_KEY);

		$option['key_uid']  = requestInt('key_uid'); //订单编号搜
		$option['key_productname']= requestString('key_productname', PATTERN_SEARCH_KEY); //商品名称搜
		$option['key_suname']= requestString('key_suname', PATTERN_SEARCH_KEY); //买家姓名搜
		$option['key_suphone']= requestString('key_suphone', PATTERN_SEARCH_KEY);//买家手机搜
		$option['paytype']  = requestInt('paytype'); //支付方式 11微信支付 1余额支付

		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 10);

		$today       = strtotime('today');
		if(isset($_REQUEST['start_time'])) {
		$option['start_time']  = requestInt('start_time');
		$option['start_time']  = (empty($option['start_time']) ? strtotime(date('Y-01',time())) : ($option['start_time']- 8 * 60 * 60 +1));  //JS 提交 是8时
		}
		if(isset($_REQUEST['end_time'])) {
		$option['end_time']    = requestInt('end_time');
		$option['end_time']    = (empty($option['end_time']) ? ($today + 24 * 60 * 60 - 1) : ($option['end_time'] + 16 * 60 * 60 -1));   //JS 提交 是8时
		}

		if(isset($_REQUEST['when'])) {
			switch($_REQUEST['when']) {
				case 'today': $option['start_time'] = strtotime('today'); break;
				case 'yesterday': $option['start_time'] = strtotime('yesterday'); break;
				case 'last month': $option['start_time'] = strtotime('last month'); break;
				case 'last year': $option['start_time'] = strtotime('last year'); break;
				default: break;
			}
		}

		isset($_REQUEST['is_group']) && $option['is_group']  = requestBool('is_group');
		$orders     = OrderMod::get_order_list($option);
		$pagination = uct_pagination($option['page'], ceil($orders['count'] / $option['limit']),
			'?_a=shop&_u=sp.orderlist&biz_uid='.$option['biz_uid'].'&status=' . $option['status'] . '&isnormal='.$option['isnormal'].'&limit=' . $option['limit'] . '&key='.$option['key'].'&page=');

		$params = array('shop' => $shop, 'option' => $option, 'data' => $orders, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	public function orderlistjiaoyi()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['shop_uid'] = $shop['uid'];
		$option['user_id']  = requestInt('user_id');
		$option['status']   = requestInt('status');
		$option['isjiaoyi'] = requestInt('isjiaoyi');
		$option['key']      = requestString('key', PATTERN_SEARCH_KEY);
		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 10);

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
			'?_a=shop&_u=sp.orderlistjiaoyi&status=' . $option['status'] . '&limit=' . $option['limit'] . '&page=');

		$params = array('shop' => $shop, 'option' => $option, 'data' => $orders, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	public function orderlist8()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['shop_uid'] = $shop['uid'];
		$option['user_id']  = requestInt('user_id');
		$option['status']   = requestInt('status');
		$option['statuss']   = array(6,8);
		$option['key']      = requestString('key', PATTERN_SEARCH_KEY);
		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 10);

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
			'?_a=shop&_u=sp.orderlist8&status=' . $option['status'] . '&limit=' . $option['limit'] . '&page=');

		$params = array('shop' => $shop, 'option' => $option, 'data' => $orders, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	/*
		全场包邮规则
	*/
	public function delivery_discount() {
		if (!($shop = ShopMod::get_shop_by_sp_uid())) {
			return $this->error();
		}

		if(isAjax()) {
			$rule = requestKvJson('rule');
			outRight($GLOBALS['arraydb_sys']['delivery_discount_'.$shop['uid']] = json_encode($rule));
		}

		$this->sp_render(array('shop' => $shop));
	}

	/*
		全场满减规则
	*/
	public function shop_discount() {
		if (!($shop = ShopMod::get_shop_by_sp_uid())) {
			return $this->error();
		}

		if(isAjax()) {
			if(requestString('del')) {
				$key = requestInt('man');
					if(!$key) outError(ERROR_INVALID_REQUEST_PARAM);
					$f = isset($GLOBALS['arraydb_sys']['shop_discount_'.$shop['uid']]) ? 
								$GLOBALS['arraydb_sys']['shop_discount_'.$shop['uid']] : ''; 
					$f = json_decode($f, true);
					if($f)
					foreach($f as $k => $ff) {
						if($ff['man'] == $key) {
							unset($f[$k]);
							break;
						}
					}
					outRight($GLOBALS['arraydb_sys']['shop_discount_'.$shop['uid']] = json_encode($f));    
			}

			$man = requestInt('man');
			$jian = requestInt('jian');
			if(!$man || !$jian) outError(ERROR_INVALID_REQUEST_PARAM);
			$f = isset($GLOBALS['arraydb_sys']['shop_discount_'.$shop['uid']]) ? 
						$GLOBALS['arraydb_sys']['shop_discount_'.$shop['uid']] : ''; 
			$f = json_decode($f, true);
			$f[] = array('man' => $man, 'jian' => $jian);
			outRight($GLOBALS['arraydb_sys']['shop_discount_'.$shop['uid']] = json_encode($f));    
		}

		$this->sp_render(array('shop' => $shop));
	}

	/*
		店铺优惠劵
	*/
	public function shopcoupon()
	{
		//uct_check_mirror_tpl_access();
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['shop_uid'] = $shop['uid'];
		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 10);
		$data               = CouponMod::get_shop_coupon_list($option);
		$pagination         = uct_pagination($option['page'], ceil($data['count'] / $option['limit']),
			'?_a=shop&_u=sp.shopcoupon&limit=' . $option['limit'] . '&page=');

		$params = array('shop' => $shop, 'option' => $option, 'data' => $data, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	/*
		添加编辑优惠劵
	*/
	public function addshopcoupon()
	{
		uct_check_mirror_tpl_access();

		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$coupon_uid = requestInt('uid');
		$coupon     = array();
		if ($coupon_uid)
		{
			$coupon = CouponMod::get_shop_coupon_by_uid($coupon_uid);
			if (!$coupon || ($coupon['shop_uid'] != $shop['uid']))
			{
				$coupon = array();
			}
		}

		$params = array('shop' => $shop, 'coupon' => $coupon);
		$this->sp_render($params);
	}

	/*
		已发放的优惠劵
	*/
	public function usercoupon()
	{
		uct_check_mirror_tpl_access();

		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['shop_uid'] = $shop['uid'];
		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 10);
		$data               = CouponMod::get_user_coupon_list($option);
		$pagination         = uct_pagination($option['page'], ceil($data['count'] / $option['limit']),
			'?_a=shop&_u=sp.usercoupon&limit=' . $option['limit'] . '&page=');

		$params = array('shop' => $shop, 'option' => $option, 'data' => $data, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	/*
		发放用户优惠劵
	*/
	public function addusercoupon()
	{
		uct_check_mirror_tpl_access();

		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$coupon_uid = requestInt('coupon_uid');
		$coupons    = CouponMod::get_shop_coupon_list(array('shop_uid'  => $shop['uid'],
		                                                    'available' => 1,
		                                                    'page'      => 0,
		                                                    'limit'     => -1));
		$params     = array('shop' => $shop, 'coupon_uid' => $coupon_uid, 'coupons' => $coupons);
		$this->sp_render($params);
	}

	public function set()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}

		$language = array(
			array('uid' => 'zh_cn', 'title' => '中文'),
			array('uid' => 'en', 'title' => '英文'),
		);


		if(!isset($GLOBALS['arraydb_sys']['cfg_set_shop_discount'.$shop['uid']])){
			//$data['sendscope'] = 0;//配送距离，0表示不限制
			$data['point_limit'] = 0;//积分抵扣比例最多抵扣百分之100
			$data['discount_limit'] = 5000;//积分使用下限50元才能使用积分
			$data['discount'] = 100;//积分抵扣率100相当于1元
			$GLOBALS['arraydb_sys']['cfg_set_shop_discount'.$shop['uid']] = json_encode($data);
		}
		$point = $GLOBALS['arraydb_sys']['cfg_set_shop_discount'.$shop['uid']];

//		var_dump(json_decode($point,true));
		$params = array('shop' => $shop, 'language' => $language,'point' => json_decode($point,true));
		$this->sp_render($params);
	}


	public function paylist()
	{
		$this->sp_render();
	}

	public function deliverytemplate()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$deliveries = DeliveryMod::get_shop_delivery($shop['uid']);
		$params     = array('shop' => $shop, 'deliveries' => $deliveries);

		$this->sp_render($params);
	}

	public function addtemplate()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}


		$delivery = array();
		if ($uid = requestInt('uid'))
		{
			if ($delivery = DeliveryMod::get_shop_delivery_by_uid($uid))
			{
				if (!$delivery || ($delivery['shop_uid'] != $shop['uid']))
				{
					$product = array();
				}
			}
		}
		$params = array('shop' => $shop, 'delivery' => $delivery);

		$this->sp_render($params);
	}

	/*
		excel导入商品数据	
	*/
	public function ugoodsexcel()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$params = array('shop' => $shop);

		$this->sp_render($params);
	}

	/*
		方案例表
	*/
	public function documentlist()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['shop_uid'] = $shop['uid'];
		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 8);

		$documents  = ShopMod::get_shop_documents($option);
		$pagination = uct_pagination($option['page'], ceil($documents['count'] / $option['limit']),
			'?_a=shop&_u=sp.documentlist&limit=' . $option['limit'] . '&page=');

		$params = array('shop' => $shop, 'documents' => $documents, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	/*
		留言列表
	*/
	public function messagelist()
	{
		uct_check_mirror_tpl_access(); //搜索框可能会有需要

		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['shop_uid'] = $shop['uid'];
		$option['key']      = requestString('key', PATTERN_SEARCH_KEY);
		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 10);

		$messages   = ShopMod::get_shop_messages($option);
		$pagination = uct_pagination($option['page'], ceil($messages['count'] / $option['limit']),
			'?_a=shop&_u=sp.messagelist&key=' . $option['key'] . '&limit=' . $option['limit'] . '&page=');

		$params = array('shop' => $shop, 'option' => $option, 'messages' => $messages, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	/*
		幻灯片列表
	*/
	public function slidelist()
	{
		uct_check_mirror_tpl_access();

		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['shop_uid'] = $shop['uid'];

		$slides = ShopMod::get_shop_slides($option);

		$params = array('shop' => $shop, 'option' => $option, 'slides' => $slides);
		$this->sp_render($params);
	}

	/*
		添加编辑幻灯片
	*/
	public function addslide()
	{
		uct_check_mirror_tpl_access();

		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$slide_uid = requestInt('uid');
		$slide     = array();
		if ($slide_uid)
		{
			$slide = ShopMod::get_shop_slide_by_uid($slide_uid);
			if (!$slide || ($slide['shop_uid'] != $shop['uid']))
			{
				$slide = array();
			}
		}
		$params = array('shop' => $shop, 'slide' => $slide);
		$this->sp_render($params);
	}

	public function edit_message()
	{
		uct_check_mirror_tpl_access();

		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		};
		$uid     = requestInt('uid');
		$message = array();
		if ($uid)
		{
			$message = ShopMod::get_shop_message_by_uid($uid);
			if (!$message || ($message['shop_uid'] != $shop['uid']))
			{
				$message = array();
			}
		}
		$params = array('shop' => $shop, 'message' => $message);
		$this->sp_render($params);
	}


	/*
	 * 三级分销主页
	 */
	public function distribution()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$dtb = DistributionMod::get_dtb_rule_by_shop_uid($shop['uid']);
		if(!$dtb){
			//默认设置
			$dtb_rule['shop_uid'] = $shop['uid'];
			$dtb_rule['create_time'] = $_SERVER['REQUEST_TIME'];
			$dtb_rule['rule_data'] = array(array(0,0),array(0,0),array(0,0),array(0,0));
			DistributionMod::add_or_edit_dtb_rule($dtb_rule);
			$dtb = DistributionMod::get_dtb_rule_by_shop_uid($shop['uid']);
		}

		$params = array('shop' => $shop, 'dtb' => $dtb);
		$this->sp_render($params);
	}

    /*
     * 分销商品列表
     */
    public function distribution_productlist()
    {
        if (!($shop = ShopMod::get_shop_by_sp_uid()))
        {
            return $this->error();
        }
        $option['shop_uid']  = $shop['uid'];
        $option['page']      = requestInt('page');
        $option['limit']     = requestInt('limit', 10);
        $option['status']    = requestInt('status',-1); //

        $products   = DistributionMod::get_product_dtb_rule_by_shop_uid($option);

        $pagination = uct_pagination($option['page'], ceil($products['count'] / $option['limit']),'?_a=shop&_u=sp.distribution_productlist&status=' . $option['status'] . '&limit=' . $option['limit'] . '&page=');
        //		var_dump(__file__.' line:'.__line__,$products);exit;
        $params = array('shop'       => $shop,
                        'option'     => $option,
                        'products'   => $products,
                        'pagination' => $pagination);

        $this->sp_render($params);
    }

    /*
     * 分销商品详情
     */
    public function adddistribution_product()
    {

        if (!($shop = ShopMod::get_shop_by_sp_uid()))
        {
            return $this->error();
        }
        $dtb_uid = requestInt('uid');
        $dtb     = array();
        $dtb['p_uid'] = requestInt('p_uid');
        if ($dtb_uid)
        {
            $dtb = DistributionMod::get_product_dtb_rule_by_uid($dtb_uid);
            if (!$dtb || ($dtb['shop_uid'] != $shop['uid']))
            {
                $dtb = array();
            }
        }else if($dtb['p_uid'])
        {
            $dtb = DistributionMod::get_dtb_rule_by_shop_product_uid($shop['uid'],$dtb['p_uid']);
            if (!$dtb || ($dtb['shop_uid'] != $shop['uid']))
            {
                $dtb['p_uid'] = requestInt('p_uid');
            }
        }
//var_export($dtb);
        $params     = array('shop' => $shop, 'dtb' => $dtb);
        $this->sp_render($params);
    }

	/*
	 * 分销记录
	 */
	public function distributionlist()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['key']    = requestString('key', PATTERN_SEARCH_KEY);
		$option['su_uid'] = requestInt('su_uid');
		isset($_REQUEST['parent_su_uid']) && $option['parent_su_uid'] = requestInt('parent_su_uid');
		isset($_REQUEST['level']) && $option['level'] = requestInt('level');
		$option['order_uid'] = requestInt('order_uid');
		$option['limit']     = requestInt('limit', 10);
		$option['page']      = requestInt('page', 0);
		$option['sp_uid'] = $shop['sp_uid'];
		$dtblist = DistributionMod::get_dtb_record_list($option);

		$pagination = uct_pagination($option['page'], ceil($dtblist['count'] / $option['limit']),
			'?_a=shop&_u=sp.distributionlist&key=' . $option['key'] . '&limit=' . $option['limit'] . '&page=');
		$params     = array('shop' => $shop, 'dtblist' => $dtblist, 'option' => $option, 'pagination' => $pagination);
		//		var_dump(__file__.' line:'.__line__,$params);exit;
//		var_dump($dtblist);
		$this->sp_render($params);
	}

	/*
	 * 分销成员设置
	 */
	public function distribution_user_set()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$this->sp_render();
	}

	/*
	 * 分销用户表
	 */
	public function distribution_user_list()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['sp_uid'] = $shop['sp_uid'];
		$option['su_uid'] = requestInt('su_uid');
		isset($_REQUEST['parent_su_uid']) && $option['parent_su_uid'] = requestInt('parent_su_uid');
		$option['status'] = requestInt('status');
		$option['limit']  = requestInt('limit', 10);
		$option['page']   = requestInt('page', 0);
		$option['key']    = requestString('key', PATTERN_SEARCH_KEY);

		$dtb_user_list = DistributionMod::get_user_dtb_list($option);

		$pagination = uct_pagination($option['page'], ceil($dtb_user_list['count'] / $option['limit']),
			'?_a=shop&_u=sp.distribution_user_list&key=' . $option['key'] . '&limit=' . $option['limit'] . '&page=');

		$params = array('shop'          => $shop,
		                'dtb_user_list' => $dtb_user_list,
		                'option'        => $option,
		                'pagination'    => $pagination);
		//				var_dump(__file__.' line:'.__line__,$params);exit;
		$this->sp_render($params);
	}

	public function agent_product()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		if (!($agent_set = $this->init_agent_set($shop['uid'])))
		{
			$GLOBALS['_UCT']['ACT'] = 'agent_set';

			return $this->agent_set();
		}
		$option['shop_uid'] = $shop['uid'];
		$option['limit']    = requestInt('limit', 10);
		$option['uid']      = requestInt('uid');
		$option['page']     = requestInt('page', 0);
		$option['key']      = requestString('key', PATTERN_SEARCH_KEY);
		$option['cat_uid']  = requestInt('cat_uid');

		$agent_products = AgentMod::get_agent_product_list($option);
		$cats           = ProductMod::get_product_cats(array('shop_uid'         => $shop['uid'],
		                                                     'with_parent_info' => true,
		                                                     'parent_uid'       => -1));
		$pagination     = uct_pagination($option['page'], ceil($agent_products['count'] / $option['limit']),
			'?_a=shop&_u=sp.agent_product&key=' . $option['key'] . '&limit=' . $option['limit'] . '&page=');
		$params         = array('shop'           => $shop,
		                        'option'         => $option,
		                        'agent_products' => $agent_products,
		                        'cats'           => $cats,
		                        'pagination'     => $pagination);
		$this->sp_render($params);
	}

	public function agent()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		if (!($agent_set = $this->init_agent_set($shop['uid'])))
		{
			$GLOBALS['_UCT']['ACT'] = 'agent_set';

			return $this->agent_set();
		}
		isset($_REQUEST['status']) && $option['status'] = requestInt('status');
		isset($_REQUEST['su_uid']) && $option['su_uid'] = requestInt('su_uid');
		$option['shop_uid'] = $shop['uid'];

		$option['uid']   = requestInt('uid');
		$option['limit'] = requestInt('limit', 10);
		$option['page']  = requestInt('page', 0);
		$option['key']   = requestString('key');
		$agent_list      = AgentMod::get_agent_list($option);
		$pagination      = uct_pagination($option['page'], ceil($agent_list['count'] / $option['limit']),
			'?_a=shop&_u=sp.agent&key=' . $option['key'] . '&limit=' . $option['limit'] . '&page=');
		$params          = array('shop'       => $shop,
		                         'option'     => $option,
		                         'agent_list' => $agent_list,
		                         'pagination' => $pagination);
		//		var_dump(__file__.' line:'.__line__,$agent_list);exit;
		$this->sp_render($params);
	}

	/*
	 *  查看代理商 的订单
	 */
	public function agent_order()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		if (!($agent_set = $this->init_agent_set($shop['uid'])))
		{
			$GLOBALS['_UCT']['ACT'] = 'agent_set';

			return $this->agent_set();
		}
		$option['shop_uid'] = $shop['uid'];
		if (!($option['a_uid'] = requestInt('a_uid')))
		{
			$option['a_uid'] = Dba::readAllOne('select uid from shop_agent where shop_uid = ' . $option['shop_uid']);
		}
		$option['status'] = requestInt('status');
		$option['key']    = requestString('key', PATTERN_SEARCH_KEY);
		$option['page']   = requestInt('page');
		$option['limit']  = requestInt('limit', 10);
		if (empty($option['a_uid']))
		{
			$agent_order = array('count' => '', 'list' => array());
		}
		else
		{
			$agent_order = OrderMod::get_order_list($option);

		}
		$pagination = uct_pagination($option['page'], ceil($agent_order['count'] / $option['limit']),
			'?_a=shop&_u=sp.agent_order&key=' . $option['key'] . '&limit=' . $option['limit'] . '&page=');
		$params     = array(
			'shop'        => $shop,
			'option'      => $option,
			'agent_order' => $agent_order,
			'pagination'  => $pagination);

		$this->sp_render($params);
	}

	public function agent_user()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		if (!($agent_set = $this->init_agent_set($shop['uid'])))
		{
			$GLOBALS['_UCT']['ACT'] = 'agent_set';

			return $this->agent_set();
		}
		if (!($option['a_uid'] = requestInt('a_uid')))
		{
			$option['a_uid'] = Dba::readAllOne('select uid from shop_agent where shop_uid = ' . $shop['uid']);
		}
		$option['su_uid'] = requestInt('su_uid');
		$option['page']   = requestInt('page');
		$option['limit']  = requestInt('limit', 10);
		if (empty($option['a_uid']))
		{
			$agent_user_list = array('count' => '', 'list' => array());
		}
		else
		{
			$agent_user_list = AgentMod::get_agent_user_list($option);


		}
		//		var_dump(__file__.' line:'.__line__, $agent_user_list   );exit;
		$pagination = uct_pagination($option['page'], ceil($agent_user_list['count'] / $option['limit']),
			'?_a=shop&_u=sp.agent_user&limit=' . $option['limit'] . '&page=');
		$params     = array(
			'shop'            => $shop,
			'option'          => $option,
			'agent_user_list' => $agent_user_list,
			'pagination'      => $pagination);

		$this->sp_render($params);
	}

	public function agent_to_user_product()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		if (!($agent_set = $this->init_agent_set($shop['uid'])))
		{
			$GLOBALS['_UCT']['ACT'] = 'agent_set';

			return $this->agent_set();
		}
		$option['p_uid'] = requestInt('p_uid');
		$option['a_uid'] = requestInt('a_uid');
		if (!($option['a_uid'] = requestInt('a_uid')))
		{
			$option['a_uid'] = Dba::readAllOne('select uid from shop_agent where shop_uid = ' . $shop['uid']);
		}
		$option['limit'] = requestInt('limit', 10);
		$option['page']  = requestInt('page', 0);
		$option['key']   = requestString('key');
		if (empty($option['a_uid']))
		{
			$agent_to_user_produnct = array('count' => '', 'list' => array());
		}
		else
		{
			$agent_to_user_produnct = AgentMod::get_agent_to_user_product_list($option);


		}
		$pagination = uct_pagination($option['page'], ceil($agent_to_user_produnct['count'] / $option['limit']),
			'?_a=shop&_u=sp.agent_to_user_product&key=' . $option['key'] . '&limit=' . $option['limit'] . '&page=');
		$params     = array(
			'shop'                  => $shop,
			'agent_to_user_product' => $agent_to_user_produnct,
			'option'                => $option,
			'pagination'            => $pagination);
		//		var_dump(__file__.' line:'.__line__,$params);exit;

		$this->sp_render($params);
	}

	public function agent_set()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		if (!($agent_set = $this->init_agent_set($shop['uid'])))
		{
			$agent_set = array();
		}
		$params = array('shop' => $shop, 'shop_agent_set' => $agent_set);
		$this->sp_render($params);
	}


	public function editagentproduct()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		if (!($agent_set = $this->init_agent_set($shop['uid'])))
		{
			$GLOBALS['_UCT']['ACT'] = 'agent_set';

			return $this->agent_set();
		}
		if (($uid = requestInt('uid'))
			&& ($a_uid = requestInt('a_uid'))
			&& ($agent = AgentMod::get_agent_by_uid($a_uid))
			&& ($agent['shop_uid'] == $shop['uid'])
			&& ($agent_to_user_product = AgentMod::get_agent_to_user_product_by_uid($uid))
			&& ($agent_to_user_product['a_uid'] == $a_uid)
		)
		{
			$agent_product = AgentMod::get_agent_product_by_uid($agent_to_user_product['p_uid']);
		}
		else
		{
			$GLOBALS['_UCT']['ACT'] = 'addagentproduct';

			return $this->addagentproduct();
		}
		$params = array('shop'                  => $shop,
		                'agent'                 => $agent,
		                'agent_product'         => $agent_product,
		                'agent_to_user_product' => $agent_to_user_product);
		//		var_dump(__file__.' line:'.__line__,$agent_product);exit;
		$this->sp_render($params);
	}

	public function addagentproduct()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}

		if (!($agent_set = $this->init_agent_set($shop['uid'])))
		{
			$GLOBALS['_UCT']['ACT'] = 'agent_set';

			return $this->agent_set();
		}

		if (($a_uid = requestInt('a_uid')))
		{
			$a_uid = requestInt('a_uid');
			if (!($agent = AgentMod::get_agent_by_uid($a_uid))
				|| !($agent['shop_uid'] == $shop['uid'])
			)
			{
				$GLOBALS['_UCT']['ACT'] = 'agent_to_user_product';

				return $this->agent_to_user_product();
			}
			$option['shop_uid'] = $shop['uid'];
			$option['limit']    = requestInt('limit', 10);
			$option['page']     = requestInt('page', 0);
			$option['status']   = 0; // 只取 允许代理的商品
			$option['key']      = requestString('key', PATTERN_SEARCH_KEY);
			$option['no_a_uid'] = $a_uid; //不取该代理已经设置的商品
			$agent              = AgentMod::get_agent_by_uid($a_uid);
			$agent_products     = AgentMod::get_agent_product_list($option);

			$cats       = ProductMod::get_product_cats(array('shop_uid'         => $shop['uid'],
			                                                 'with_parent_info' => true,
			                                                 'parent_uid'       => -1));
			$pagination = uct_pagination($option['page'], ceil($agent_products['count'] / $option['limit']),
				'?_a=shop&_u=sp.agent_product&key=' . $option['key'] . '&limit=' . $option['limit'] . '&page=');

			$params     = array('shop'           => $shop,
			                    'agent'          => $agent,
			                    'option'         => $option,
			                    'agent_products' => $agent_products,
			                    'cats'           => $cats,
			                    'pagination'     => $pagination);

		}
		else
		{
			$GLOBALS['_UCT']['ACT'] = 'choose_a_agent';

			return $this->agent_to_user_product();
		}
		$this->sp_render($params);
	}

	public function choose_a_agent()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$url                = requestString('url');
		$option['shop_uid'] = $shop['uid'];
		$option['limit']    = requestInt('limit', 10);
		$option['page']     = requestInt('page', 0);
		$option['status']   = 0; //只去通过审核的
		$option['key']      = requestString('key');
		$agent_list         = AgentMod::get_agent_list($option);
		$pagination         = uct_pagination($option['page'], ceil($agent_list['count'] / $option['limit']),
			'?_a=shop&_u=sp.choose_a_agent&key=' . $option['key'] . '&limit=' . $option['limit'] . '&page=');
		$params             = array(
			'shop'       => $shop,
			'option'     => $option,
			'agent_list' => $agent_list,
			'pagination' => $pagination,
			'url'        => $url,
		);

		$this->sp_render($params);
	}

	//初始化 代理系统
	public function init_agent_set($shop_uid)
	{
		if (($agent_set = AgentMod::get_agent_set_by_shop_uid($shop_uid)))
		{
			return $agent_set;
		}
		else
		{
			return false;
		}

	}


	public function __construct()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
			exit(1);
		}
		//todo 做一个步骤流程 第一次进入选择模板页面
		if (empty($shop['tpl']))
		{
			if (!in_array($GLOBALS['_UCT']['ACT'], array('set')))
			{
				redirectTo('?_a=shop&_u=sp.set');
			}
		}
		//带代理分销的模板
		if (in_array($shop['tpl'], AgentMod::get_agent_tpl_array())
			&& (!($agent_set = AgentMod::get_agent_set_by_shop_uid($shop['uid'])))
		)
		{
			if (!in_array($GLOBALS['_UCT']['ACT'], array('agent_set', 'set')))
			{
				redirectTo('?_a=shop&_u=sp.agent_set');
			}
		}
	}

	//后台模板设置
	public function __call($act, $args)
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		#echo 'hehe '.$act.PHP_EOL;
		#var_export($args);
		$params = array('shop' => $shop,);
		$this->sp_render($params);
	}

	public function visit_record()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$agent_list = Dba::readAllAssoc('select a.uid,s.name from shop_agent as a left join service_user as s on a.su_uid = s.uid where a.shop_uid = ' . $shop['uid']);

		if (($a_uid = requestInt('a_uid')))
		{
			$product_list = Dba::readAllAssoc('select p_uid as uid,title from shop_agent_to_user_product where a_uid = ' . $a_uid);
		}
		else
		{
			$product_list = Dba::readAllAssoc('select uid,title from product where shop_uid = ' . $shop['uid']);
		}
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
		$sql[0] .= ' from shop_visit_record where shop_uid = "' . $shop['uid'] . '" ' . $where_time . $where_a_uid . ' group by days;';
		$sql[1] = 'select from_unixtime(create_time,"%Y-%m-%d") as days,count(distinct user_ip) as count ';
		$sql[1] .= ' from shop_visit_record where shop_uid = "' . $shop['uid'] . '" ' . $where_time . $where_a_uid . ' group by days;';
		$sql[2] = 'select from_unixtime(create_time,"%Y-%m-%d") as days,count(*) as count ';
		$sql[2] .= ' from shop_visit_record where shop_uid = "' . $shop['uid'] . '" ' . $where_time . ' && ' . $where . ' ' . $where_a_uid . ' group by days;';
		$sql[3] = 'select from_unixtime(create_time,"%Y-%m-%d") as days,count(distinct user_ip) as count ';
		$sql[3] .= ' from shop_visit_record where shop_uid = "' . $shop['uid'] . '" ' . $where_time . '  && ' . $where . ' ' . $where_a_uid . ' group by days;';
		$echarts = array();


		for ($i = $start_time; $i < $end_time; $i = $i + 60 * 60 * 24)
		{
			$echarts['xAxis']['data'][]  = date('Y-m-d', $i);
			$echarts2['xAxis']['data'][] = date('Y-m-d', $i);
		}
		//		$echarts['xAxis']['data'] = Dba::readAllOne('select from_unixtime(create_time,"%Y-%m-%d") as days from shop_visit_record where shop_uid = "' . $shop['uid'] . '" '.$where_time . $where_a_uid . ' group by days;');

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


		//奖品分布情况
		$sql = 'select from_unixtime(create_time,"%Y-%m-%d") as days ,count( case product_uid  when 0 then 0 end) as "0"';
		foreach ($product_list as $it)
		{
			$sql .= ',count( case product_uid  when ' . $it['uid'] . ' then ' . $it['uid'] . ' end) as "' . $it['uid'] . '"';
		}
		$sql .= ' from shop_visit_record where shop_uid = "' . $shop['uid'] . '" ' . $where_time . ' ' . $where_a_uid . 'group by days;';
		$ret = Dba::readAllAssoc($sql);
		foreach ($ret as $r)
		{
			$day = $r['days'];
			unset($r['days']);
			$ret2[$day] = $r;
		}
		$ret = array();
		foreach ($echarts2['xAxis']['data'] as $k => $d)
		{
			//			$echarts2[ 'xAxis' ][ 'data' ][$k] = date('m-d', strtotime($d));
			//			$ret[$echarts2[ 'xAxis' ][ 'data' ][$k]] = (empty($ret2[$d])?array():$ret2[$d]);
			$ret[$d] = (empty($ret2[$d]) ? array() : $ret2[$d]);
		}
		//		var_dump(__file__.' line:'.__line__,$ret);exit;
		$count           = count($ret);
		$i               = 0;
		$product_lists   = $product_list;
		$product_lists[] = array('title' => '未进入商品页', 'uid' => 0);
		foreach ($ret as $k => $v)
		{
			if (count($product_lists) > 0)
			{
				$j = 0;
				foreach ($product_lists as $it)
				{
					if ($i == 0)
					{
						$echarts2['count']                       = $count;
						$echarts2['options']['legend']['data'][] = $it['title'];
					}
					$echarts2['options'][$i]['series'][0]['name']              = 'pv';
					$echarts2['options'][$i]['series'][0]['type']              = 'pie';
					$echarts2['options'][$i]['series'][0]['center']            = array('50%','55%',);
					$echarts2['options'][$i]['series'][0]['radius']            = array('35%', '50%');
					$echarts2['options'][$i]['series'][0]['data'][$j]['value'] = (empty($ret[$k][$it['uid']]) ? 0 : $ret[$k][$it['uid']]);
					$echarts2['options'][$i]['series'][0]['data'][$j]['name']  = $it['title'];



					$j++;
				}
			}
			$i++;
		}
		//		var_dump(__file__.' line:'.__line__,$echarts2);exit;
		$option = array(
			'a_uid'      => $a_uid,
			'p_uid'      => $p_uid,
			'start_time' => $start_time,
			'end_time'   => $end_time,
		);
		$params = array(
			'shop'         => $shop,
			'cnts'         => $cnts,
			'echarts'      => $echarts,
			'echarts2'     => $echarts2,
			'agent_list'   => $agent_list,
			'product_list' => $product_list,
			'option'       => $option,
		);
		$this->sp_render($params);
	}

	public function setcolors(){
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}

		if(!isset($GLOBALS['arraydb_sys']['cfg_shop_setcolor_1'.$shop['sp_uid']])){
			$GLOBALS['arraydb_sys']['cfg_shop_setcolor_1'.$shop['sp_uid']] = '00FF00';
		}
		if(!isset($GLOBALS['arraydb_sys']['cfg_shop_setcolor_2'.$shop['sp_uid']])){
			$GLOBALS['arraydb_sys']['cfg_shop_setcolor_2'.$shop['sp_uid']] = 'FF0000';
		}
//var_dump($GLOBALS['arraydb_sys']['cfg_shop_setcolor_1'.$shop['sp_uid']]);
		$color1 = $GLOBALS['arraydb_sys']['cfg_shop_setcolor_1'.$shop['sp_uid']];
		$color2 = $GLOBALS['arraydb_sys']['cfg_shop_setcolor_2'.$shop['sp_uid']];

		$params = array(
			'shop' => $shop,
			'color1'         => $color1,
			'color2'         => $color2,
		);
		$this->sp_render($params);
	}

	//货单统计
	public function order_record(){

		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['shop_uid'] = $shop['uid'];

		$option['status']   = requestInt('status',2);
//		$option['key']      = requestString('key', PATTERN_SEARCH_KEY);
//		$option['page']     = requestInt('page');
//		$option['limit']    = requestInt('limit', 10);

		$today       = strtotime('today');
		$option['start_time']  = requestInt('start_time');
		$option['end_time']    = requestInt('end_time');

		$option['start_time']  = (empty($option['start_time']) ? strtotime(date('Y-01',time())) : ($option['start_time']- 8 * 60 * 60 +1));  //JS 提交 是8时
		$option['end_time']    = (empty($option['end_time']) ? ($today + 24 * 60 * 60 - 1) : ($option['end_time'] + 16 * 60 * 60 -1));   //JS 提交 是8时

		$orders     = OrderMod::get_order_record($option);

		$res = array();
		foreach ($orders as $k => $v) {   $res[$v[0]['sku_uid']][] = $v[0]; }

		$res2 = array();
		foreach($res as $k => $v){
			$res2[$k]['quantity'] = 0;
			foreach($v as $k2 => $v2){
//				var_dump($v2);
				$res2[$k]['title'] =  $v2['title'];
				$as = strpos($v2['sku_uid'], ';');//去掉id;留下规格
				if ($as) {
					$res2[$k]['sku_uid'] = substr($v2['sku_uid'], $as+1);
				} else {
					$res2[$k]['sku_uid'] = null;
				}
//				$res2[$k]['sku_uid'] =  $v2['sku_uid'];
				$res2[$k]['quantity'] += $v2['quantity'];
				$res2[$k]['paid_price'] =  $v2['paid_price'];
				$res2[$k]['main_img'] =  $v2['main_img'];
			}
		}

		$params = array('res2'=>$res2,'shop' => $shop, 'option' => $option, 'data' => $orders);

		$this->sp_render($params);
	}

	/*
	 * 打印机设置
	 */
	public function gugujilist(){
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option['sp_uid'] = $shop['sp_uid'];
		$option['key']      = requestString('key', PATTERN_SEARCH_KEY);
		$option['status']   = requestInt('status');
		$option['page']     = requestInt('page');
		$option['limit']    = requestInt('limit', 10);

		$data = GugujiMod::get_guguji_list($option);

		$pagination = uct_pagination($option['page'], ceil($data['count'] / $option['limit']),
			'?_a=shop&_u=sp.gugujilist&status=' . $option['status'] . '&limit=' . $option['limit'] . '&page=');

		$params = array('shop' => $shop,'option' => $option, 'data' => $data, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	/*
		添加编辑打印机
	*/
	public function addguguji() {
		if (!($shop = ShopMod::get_shop_by_sp_uid())) {
			return $this->error();
		}
		if(!($uid = requestInt('uid')) || !($guguji = GugujiMod::get_guguji_by_uid($uid)) ||
			($guguji['sp_uid'] != $shop['sp_uid'])) {
			$guguji = array();
		}

		if(!empty($guguji) && $guguji['type'] == 'yilianyun') {
			redirectTo('?_a=shop&_u=sp.addprinter&uid='.$guguji['uid']);
		}

		$params = array('shop' => $shop, 'data' => $guguji);
		$this->sp_render($params);
	}
	/*
		添加编辑打印机 易联云
	*/
	public function addprinter() {
		if (!($shop = ShopMod::get_shop_by_sp_uid())) {
			return $this->error();
		}
		if(!($uid = requestInt('uid')) || !($guguji = GugujiMod::get_guguji_by_uid($uid)) ||
			($guguji['sp_uid'] != $shop['sp_uid'])) {
			$guguji = array();
		}

		$params = array('shop' => $shop, 'data' => $guguji);
		$this->sp_render($params);
	}

	//分拣单
	public function order_address_excel(){
		ini_set('memory_limit', '15M');
		ini_set("max_execution_time", "0");
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option = array(
			'header' => array(
				'订单号',
				'店铺名称',
				'买家姓名',
				'宝贝详情',
						
				'买家应付货款',
				'买家应付邮费',
				'买家支付积分',
				'返点积分',
				'实际支付金额',
				'支付方式',
				'收货地址', 
				'联系电话',
				'订单创建时间',
				'订单付款时间 ',
				'订单发货时间',
				'确认收货时间',
				'订单状态',
				'物流公司',
				'物流单号',
				'订单备注',
				'发票抬头',
				'退款金额',
			),
			'title' => iconv("UTF-8", "GBK", '订单信息'),
		);

		$option['shop_uid'] = $shop['uid'];
		$option['status']   = requestInt('status');

		$today       = strtotime('today');
		$option['start_time']  = requestInt('start_time');
		$option['end_time']    = requestInt('end_time');

		$option['start_time']  = (empty($option['start_time']) ? 0 : ($option['start_time']- 8 * 60 * 60 +1));  //JS 提交 是8时
		$option['end_time']    = (empty($option['end_time']) ? ($today + 24 * 60 * 60 - 1) : ($option['end_time'] + 16 * 60 * 60 -1));   //JS 提交 是8时

		$order     = OrderMod::get_order_address($option);
		if(!$order) {
			header('Content-Type:text/html;charset=utf-8');
			echo '暂无数据!';
			return;
		}
		// var_dump($order);die;
		
		$data = null;
		foreach($order as  $k=>$or){
			
			
			$data[$k]['uid'] = $or['uid'];
			$data[$k]['shop_name'] = $shop['title'];
			$data[$k]['name'] = isset($or['address']['name'])?$or['address']['name']:'-';//买家姓名
			$data[$k]['sku'] = '';
			foreach($or['products'] as $o){
				
				if($o['sku_uid'] = explode(';',$o['sku_uid'],2)){ 
					if(isset($o['sku_uid'][1])) $data[$k]['sku'] .= $o['title'].'^'.$o['sku_uid'][1].'*'.$o['quantity']."/";
				} else{
					$data[$k]['sku'] = '-';
				}
				$data[$k]['receipt'] = 0; //货款
				$data[$k]['receipt'] += $o['quantity'] * $o['paid_price'] / 100;
				
			}
			$data[$k]['delivery_fee'] = isset($or['delivery_fee'])?$or['delivery_fee']:'-';//邮费
			
			$data[$k]['use_point'] = isset($or['use_point'])?$or['use_point']:'-';//使用积分多少
			$data[$k]['back_point'] = isset($or['back_point'])?$or['back_point']:'-';//返还积分多少
		 	$data[$k]['paid_fee'] = sprintf("%.2f", (($or['paid_fee']+$or['cash_fee'])/100));//实际支付
		 	//支付方式
		 	$klop = array('未设置','免费无需付款','货到付款', 10 =>'支付宝', 11 =>'微信支付');
		 	$data[$k]['pay_type'] =  $klop[$or['pay_type']];
		 	//收货地址
			if(isset($or['address']['province'])&&isset($or['address']['city'])&&isset($or['address']['town'])&&isset($or['address']['address'])){
			$data[$k]['address'] = $or['address']['province'].$or['address']['city'].$or['address']['town'].$or['address']['address'];
			}else{
	 		$data[$k]['address'] = '-';
	 		}

		 	$data[$k]['phone'] = isset($or['address']['phone'])?$or['address']['phone']:'-';//收货电话
			$data[$k]['create_time'] = $or['create_time']?date('Y:m:d H:i:s',$or['create_time']):'-';//订单创建时间
			$data[$k]['paid_time'] = $or['paid_time']?date('Y:m:d H:i:s',$or['paid_time']):'-';//支付时间
			$data[$k]['send_time'] = $or['send_time']?date('Y:m:d H:i:s',$or['send_time']):'-';//发货时间
			$data[$k]['recv_time'] = $or['recv_time']?date('Y:m:d H:i:s',$or['recv_time']):'-';//收货时间


			/*订单状态*/
			$or_status = array(1=>'待付款', 2=>'待发货', 3=>'已发货', 4=>'已收货', 5 => '维权完成', 8=> '维权中', 10=> '已取消');
			$data[$k]['status'] = isset($or_status[$or['status']]) ? $or_status[$or['status']] : $or['status'];

			if(isset($or['delivery_info']['name']) && isset($or['delivery_info']['order'])){
				$data[$k]['transport'] = $or['delivery_info']['name'];//物流公司
				$data[$k]['or_num'] = $or['delivery_info']['order'];//物流单号
			} else{
				$data[$k]['transport'] = '-';//物流公司
				$data[$k]['or_num'] = '-';//物流单号
			}

			$data[$k]['remark'] = isset($or['info']['remark'])?$or['info']['remark']:'-';
			$data[$k]['fapiao'] = isset($or['info']['fapiao'])?$or['info']['fapiao']:'-';
				
			$refund = RefundMod::get_refund_by_order_uid($or['uid']);
			$data[$k]['refund_fee'] = $refund['refund_fee'] / 100;

			

			
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

	/*
      导出货单列表
      */
	public function order_record_excel() {
		ini_set('memory_limit', '15M');
		ini_set("max_execution_time", "0");
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option = array(
			'header' => array(
				'编号',
				'商品名',
				'商品规格',
				'数量',
			),
			'title' => iconv("UTF-8", "GBK", '货单列表'),
		);

		$option['shop_uid'] = $shop['uid'];
		$option['status']   = requestInt('status',2);
		$today       = strtotime('today');
		$option['start_time']  = requestInt('start_time');
		$option['end_time']    = requestInt('end_time');

		$option['start_time']  = (empty($option['start_time']) ? ($today - 60 * 60 * 24 * 10) : (($option['start_time'] - 8 * 24 * 24)));  //JS 提交 是8时
		$option['end_time']    = (empty($option['end_time']) ? ($today + 24 * 60 * 60 - 1) : ($option['end_time'] + 16 * 60 * 60 - 1));   //JS 提交 是8时

		$orders     = OrderMod::get_order_record($option);

		$res = array();
		foreach ($orders as $k => $v) {   $res[$v[0]['sku_uid']][] = $v[0]; }
		$res2 = array();
		foreach($res as $k => $v){
			$res2[$k][4] = null;
			foreach($v as $k2 => $v2){
//				var_dump($v2);
				$res2[$k][2] =  $v2['title'];
				$as = strpos($v2['sku_uid'], ';');//去掉id;留下规格
				if ($as) {
					$res2[$k][1] = substr($v2['sku_uid'],0,$as);
					$res2[$k][3] = substr($v2['sku_uid'], $as+1);
				} else {
					$res2[$k][1] = $v2['sku_uid'];
					$res2[$k][3] = null;
				}
				$res2[$k][4] += $v2['quantity'];
				ksort($res2[$k]);
			}
		}
//		header('Content-Type:text/html;charset=utf-8');
//		var_dump($res2);die();
		$data = $res2;
		if(!empty($data)){
			$option['i'] = 0;
			$this->csv($data, $option);
			unset($data);
			$data = null;
		}
		exit;

	}

	/*
      导出商品库存表
      */
	public function product_quantity_excel() {
		ini_set('memory_limit', '15M');
		ini_set("max_execution_time", "0");
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}
		$option = array(
			'header' => array(
				'编号',
				'商品名',
				'状态',
				'价格',
				'库存',
				'参考销量',
			),
			'title' => iconv("UTF-8", "GBK", '商品库存表'),
		);
		$option['shop_uid'] = $shop['uid'];
		$page = 0;
		$option['limit'] = 100;


		while(1) {
			$option['i'] = $option['page'] = $page++;
			$ps = ProductMod::get_shop_products($option);
			$ps = $ps['list'];
			if(!$ps) {
				if($option['i'] == 0) {
					header('Content-Type:text/html;charset=utf-8');
					echo '暂无数据!';
					return;
				}
				exit;
			}

			$data = array();
			foreach($ps as $k => $p){
				$data[$k]['uid'] = $p['uid'];
				$data[$k]['title'] = $p['title'];
				$data[$k]['status'] = $p['status'] == 0 ? '正常' : '已下架';
				$data[$k]['price'] = $p['price']/100;
				if(!empty($p['sku_table']['info'])) {
					$data[$k]['quantity'] = '';
					foreach($p['sku_table']['info'] as $kk => $vv) {
						$data[$k]['quantity'] .= $kk.': '.$vv['quantity'].' ';
					}
				} else {
					$data[$k]['quantity'] = $p['quantity'];
				}
				$data[$k]['sell_cnt'] = $p['sell_cnt'];
			}

			$this->csv($data, $option);
			unset($data);
		}
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
		echo mb_convert_encoding($ret, "GBK", "UTF-8");
	}
	/*
	 * 订单打印
	 */
	public function print_order()
	{
		if(!$uids = requestIntArray('uid')){
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		include_once UCT_PATH.'vendor/gugu/memobird.php';
		$type = 'T';
		$profile = SpMod::get_sp_profile();

		$guguji = GugujiMod::get_used_guguji($profile['uid']);
		if(empty($guguji)){
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$mem = new memobird($guguji['ak']);
		$showapi = $mem->getUserId($guguji['memobirdid'],$guguji['useridentifying']);
		$user = json_decode($showapi,true);
		if(empty($user['showapi_userid'])){
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		foreach($uids as $uid){
			$content = null;
			$order = OrderMod::get_order_by_uid($uid);
			if(empty($order)){
				continue;
			}
//			$content = "-----------------------------";
			foreach($order['products'] as $op){
				$content .= $op['title'].'x'.$op['quantity'];
//				$content .= $op['title'].'-'.$op['quantity'].'-'.sprintf('%.2f',$op['paid_price']).'-'.sprintf('%.2f',($op['paid_price']*$op['quantity']));
				$content .= "\r\n";
			}
			$content .= "\r\n";
			$content .= "支付金额:".sprintf('%.2f',($order['paid_fee']+$order['cash_fee'])/100);
			$content .= "￥\r\n";
			$content .= "下单时间:".date('Y-m-d H:i:s',$order['create_time']);;
			$content .= "\r\n";
			$content .= "地址:".$order['address']['province'].$order['address']['city'].$order['address']['town'].$order['address']['address'];
			$content .= "\r\n";
			$content .= "用户:".$order['address']['name'];
			$content .= "\r\n";
			$content .= "电话:".$order['address']['phone'];
			$content .= "\r\n";
			$content .= "备注:".(isset($order['info']['remark'])?$order['info']['remark']:'');
			$content .= "\r\n"."-----------------------------";
			#$content .= "\r\n           ".'快马加鞭科技'."           \r\n";

//			header('Content-Type:text/html;charset=utf-8');

			$data =$mem->contentSet($type,$content);
			$ret =$mem->printPaper($data,$guguji['memobirdid'],$user['showapi_userid']);

		}

	}

	/*
	 * 商家入驻基本设置
	 */
	public function biz_set(){
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
	 * 商家分类列表
	 */
	public function bizcatlist(){
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

	/*
	 * 页面编辑
	 */
	public function index_view()
	{
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{
			return $this->error();
		}

		$params  = array('shop' => $shop);
		//$this->sp_render($params);
		render_sp_inner('', $params);
	}

	/*设置评论积分页*/
	public function edit_comment_point(){
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{	
			return $this->error();
		}
		$point = CommentMod::get_comment_point_by_shop_uid($shop['uid']);
		$params = array('text_point'=>$point['text_point'],'img_point'=>$point['img_point']);
		$this->sp_render($params);
		
	}
	/*处理设置评论分页*/
	public function do_edit_comment_point(){
		if (!($shop = ShopMod::get_shop_by_sp_uid()))
		{	
			return $this->error();
		}
		$text_point = requestInt('text_point');
		$img_point = requestInt('img_point');
		return CommentMod::set_comment_point($shop['uid'],$text_point,$img_point);


		
		
		
	}

}


