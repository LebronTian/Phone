<?php

/*
	顾客 
*/

class UserCtl {
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

//		if(($agent_set = AgentMod::get_agent_set_by_shop_uid($shop['uid']))   //判断是否安装了代理系统
//			&& (empty($agent_set['status']))                                   //判断是否开启了代理系统
//			&& ($GLOBALS['_UCT']['ACT']!='agent_apply'  && !(AgentMod::require_agent())) //普通用户进入商城
//		)
//		{
//			exit('这个商城链接无效！请重新索取');
//		}
		isset($_REQUEST['parent_su_uid']) && $_SESSION['parent_su_uid'] = requestInt('parent_su_uid');
		$GLOBALS['_UCT']['TPL'] = $shop['tpl'] ? $shop['tpl'] : 'wap';

		return $shop;
	}
	
	public function init_user()
	{
//		$_SESSION['su_login']=$_SESSION['su_uid']=163;
		if (!($su_uid = AccountMod::has_su_login()) && !in_array($GLOBALS['_UCT']['ACT'], array('login')))
		{
			redirectTo('?_a=shop&_u=user.login');
		}

		$su = AccountMod::get_service_user_by_uid($su_uid);

		//如果用户是代理的用户 设置为代理的商城
		$agent_user = AgentMod::get_agent_user_by_su_uid($su['uid']);
		if( !empty($agent_user)
			&& ($agent = AgentMod::get_agent_by_uid($agent_user['uid']))
			&& empty($agent['status'])
			&& !($agent['uid'] == AgentMod::require_agent())
			)
		{
			setcookie('__s_a_uid', $agent['uid'], 0, '/');
			redirectTo(DomainMod::get_app_url('shop',$su['sp_uid'],array('_u'=>'user')));
		}

		$shop = ShopMod::get_shop_by_sp_uid($su['sp_uid']);
		//取出 分销设置
		$dtb_rule = DistributionMod::get_dtb_rule_by_shop_uid($shop['uid']);
		//开启分销的时候 开始记录用户信息
		if(!$dtb_rule['status'])
		{
			if(isset($_SESSION['parent_su_uid']))
			{
				$GLOBALS['_TMP']['PARENT_SU_UID'] = $_SESSION['parent_su_uid'];
				Event::addHandler('AfterSuRegister',array('DistributionMod','onAfterSuRegister'));
			}
			if(!($user_dtb = DistributionMod::get_user_dtb_by_su_uid($su['uid'])))
			{
				//初始化 用户信息
				DistributionMod::init_distribution_user($su);
			}
		}
		return $su;
	}

	/*
		顾客个人中心
	*/
	public function index()
	{
		$shop = $this->init_shop();
		$su   = $this->init_user();
		uct_use_app('su');
		uct_use_app('sp');
		$profile = SuMod::get_su_profile($su['uid']);
		$sp = SpMod::get_sp_profile($shop['sp_uid']);
		$agent_set = AgentMod::get_agent_set_by_shop_uid($shop['uid']);
		$dtb_set = DistributionMod::get_dtb_rule_by_shop_uid($shop['uid']);
		$option['sp_uid'] = $shop['uid'];
		$option['user_id'] = $su['uid'];
		$order_count_group_by_status = OrderMod::get_count_order_by_status($option);
		$sql = 'select g_uid from groups_users where su_uid ='.$su['uid'];
		$g_uid = Dba::readOne($sql);
		$params = array(
			'shop' => $shop,
			'sp'=>$sp,
			'su' => $su,
			'profile' => $profile,
			'agent_set' =>$agent_set,
			'dtb_set' =>$dtb_set,
			'g_uid' =>$g_uid,
			'order_count_group_by_status'=>$order_count_group_by_status);

		render_fg('', $params);
	}

	/*
		修改密码
	*/
	public function change_password()
	{
		$shop = $this->init_shop();
		$su   = $this->init_user();
		uct_use_app('su');
		$profile = SuMod::get_su_profile($su['uid']);

		$params = array('shop' => $shop, 'su' => $su, 'profile' => $profile);
		render_fg('', $params);
	}

	/*
		登陆
	*/
	public function login()
	{
		$shop = $this->init_shop();
		if (AccountMod::has_su_login())
		{
			redirectTo('?_a=shop');
		}
		$params = array('shop' => $shop);
		render_fg('', $params);
	}

	/*
	 * zux
	 */

	/*
		注册
	*/
	public function register()
	{
		$shop = $this->init_shop();

		$params = array('shop' => $shop);
		render_fg('', $params);
	}

	/*
		顾客个人资料
	*/
	public function profile()
	{
		$shop = $this->init_shop();
		$su   = $this->init_user();
			uct_use_app('su');
		$from = AccountMod::get_service_user_by_uid($su['from_su_uid']);
		$profile = SuMod::get_su_profile($su['uid']);
//		var_dump($from);

		$params = array('shop' => $shop, 'su' => $su,'profile'=>$profile,'from'=>$from);
		render_fg('', $params);
	}

	/*
		顾客收货地址
	*/
	public function address()
	{
		$shop    = $this->init_shop();
		$su      = $this->init_user();
		$address = DeliveryMod::get_shop_user_address($shop['uid'], $su['uid']);

		$type = requestString('type');

		$params = array('shop' => $shop, 'su' => $su, 'address' => $address, 'type' => $type);
		render_fg('', $params);
	}


	/*
		编辑顾客收货地址
	*/
	public function addaddress()
	{
		$shop    = $this->init_shop();
		$su      = $this->init_user();
		$type = requestInt('uid');

		$option['shop_uid'] = $shop['uid'];

		$address = DeliveryMod::get_shop_user_address_by_uid( $type);
		$addr_name = Address_nameMod::get_shop_address_name($shop['uid']);

		$params = array('shop' => $shop,
						'su' => $su,
						'address' => $address,
						'addr_name'=>$addr_name,
						'type' => $type);
		render_fg('', $params);	
	}
	/*
		顾客收货地址
	*/
	public function add_address()
	{
		$shop    = $this->init_shop();
		$su      = $this->init_user();
		$a = '';

		if (!($uid = requestInt('uid')) ||
			!$address = DeliveryMod::get_shop_user_address($shop['uid'], $su['uid'])
		)
		{
			$address = DeliveryMod::get_shop_user_address($shop['uid'], $su['uid']);
		}
		
		// 取该条数据
		foreach ($address as $k) {
			if ($k['uid'] == $uid) {
				$a = $k;
			}
		}

		$params = array('shop' => $shop, 'su' => $su, 'address' => $address, 'detail' => $a);
		render_fg('', $params);
	}

	/*
		所有订单	
	*/
	public function orders()
	{
		$shop              = $this->init_shop();
		$su                = $this->init_user();
		$option['status']  = requestInt('status');
		$option['user_id'] = $su['uid'];
		$option['sort']    = requestInt('sort');
		$option['page']    = requestInt('page');
		$option['limit']   = requestInt('limit', 10);
		$option['key']     = requestString('key', PATTERN_SEARCH_KEY);
		isset($_REQUEST['create_time']) && $option['create_time'] = requestInt('create_time'); //最近一段时间的订单
		
		$orders = OrderMod::get_order_list($option);

		$params = array('shop' => $shop, 'su' => $su, 'option' => $option, 'orders' => $orders);
		render_fg('', $params);
	}
	/*
		退款详情
	*/
	public function refund()
	{
		$shop = $this->init_shop();
		$su   = $this->init_user();
		if (!($uid = requestInt('uid')) ||
			!($order = OrderMod::get_order_by_uid($uid)) ||
			($order['user_id'] != $su['uid'])
		)
		{
			echo '订单不存在!';

			return;
		}

		$params = array('shop' => $shop, 'order' => $order);
		render_fg('', $params);
	}
	/*
	    配送员订单
	*/
	public function orders_d(){
		$shop              = $this->init_shop();
		$su                = $this->init_user();
		$status    = requestInt('status',0);

		$order = OrderMod::get_develop_order($su['uid'],$status);

		$params = array('shop' => $shop, 'su' => $su, 'order' => $order);

		render_fg('', $params);
	}

	/*
		订单详情	
	*/
	public function orderdetail()
	{
		$shop = $this->init_shop();
		$su   = $this->init_user();
		if (!($uid = requestInt('uid')) ||
			!($order = OrderMod::get_order_by_uid($uid)) ||
			($order['user_id'] != $su['uid'])
		)
		{
			echo '订单不存在!';

			return;
		}

		$params = array('shop' => $shop, 'order' => $order);
		render_fg('', $params);
	}

	/*
		优惠劵 todo
	*/
	public function coupons()
	{
		$shop = $this->init_shop();
		$su   = $this->init_user();

		/*选择模式*/
		$type  = requestString('type');
		isset($_REQUEST['paid_fee']) && $GLOBALS['_TMP']['paid_fee'] = requestInt('paid_fee');

		$option['page']  = requestInt('page');
		$option['limit'] = requestInt('limit', -1);

		isset($_REQUEST['available']) && $_REQUEST['available'] = ($_REQUEST['available'] == "true" ? true : false);
		//$option['available'] = requestBool('available'); //只要可用的优惠劵;
		$option['available'] = true; //只要可用的优惠劵;
		$option['shop_uid']  = $shop['uid'];
		$option['user_id']   = $su['uid'];
		//        var_dump($_REQUEST['available'],$option['available']);
		$coupons = CouponMod::get_user_coupon_list($option);


		$params = array('shop' => $shop,'coupons' => $coupons,'type'=>$type);
		render_fg('', $params);
	}

	/*
		意见建议 todo
	*/
	public function suggest()
	{
		$shop = $this->init_shop();

		$params = array('shop' => $shop);
		render_fg('', $params);
	}

	/*
		积分
	*/
	public function points()
	{
		$shop = $this->init_shop();
		$su   = $this->init_user();
		uct_use_app('su');
		$profile = SuMod::get_su_profile($su['uid']);

		$params = array('shop' => $shop, 'su' => $su, 'profile' => $profile);
		render_fg('', $params);
	}

	/*
		我来邀请
	*/
	public function invite()
	{
		$shop = $this->init_shop();
		$su   = $this->init_user();
		uct_use_app('su');
		$profile = SuMod::get_su_profile($su['uid']);

		$params = array('shop' => $shop, 'su' => $su, 'profile' => $profile);
		render_fg('', $params);
	}

	/*
		订单评论页
	*/
	public function comment()
	{
		$shop = $this->init_shop();
		$su   = $this->init_user();
		if (!($uid = requestInt('uid')) ||
			!($order = OrderMod::get_order_by_uid($uid)) ||
			($order['user_id'] != $su['uid'])
		)
		{
			echo '订单不存在!';

			return;
		}

		$params = array('shop' => $shop, 'order' => $order);
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
    public function distribution_center()
    {
        $shop = $this->init_shop();
        $su = $this->init_user();
	    $user_dtb = DistributionMod::get_user_dtb_by_su_uid($su['uid']);

	    //取到自己的信息
        $user_dtb_info = DistributionMod::get_user_dtb_info($su['uid']);
		//要3级数据 并且 只要统计数据
//        var_dump($user_dtb_info);
        $dtb_tree = DistributionMod::get_user_dtb_tree($su['uid'], 3, 0);
		$option = array('shop_uid' => $shop['uid'], 'user_id' => $su['uid'],'status'=>4,'page'=>0,'limit'=> -1);//用户全部订单
		$user_orders = OrderMod::get_order_list($option);
//		header('Content-Type:text/html;charset=utf-8');
//		print_r($user_orders);die();

	    /*分销商铺首页链接*/
	    $url = DomainMod::get_app_url('shop',$shop['sp_uid'],array('_u'=>'user','parent_su_uid'=>$su['uid']));
	    $params = array('shop' => $shop,'su'=>$su,'$user_orders'=>$user_orders, 'user_dtb'=>$user_dtb,'user_dtb_info' => $user_dtb_info, 'dtb_tree' => $dtb_tree,'url'=> $url);
//        var_dump($url);
//        var_dump(__files__ . ' line:' . __line__, $url);
//        exit;
        render_fg('', $params);
    }

	//分销申请
	public function distribution_apply()
	{
		$shop = $this->init_shop();
		$su = $this->init_user();
		if (($distribution = DistributionMod::get_user_dtb_by_su_uid($su['uid']))
			&& ($distribution['status']==1) )
		{
			redirectTo('?_a=shop&_u=user.distribution_center');//有申请过的,且已经通过审核 ，进入分销中心
		}
		$params = array('shop' => $shop, 'distribution' => $distribution);
		render_fg('', $params);
	}

    //代理用户中心
    public function agent_center()
    {
        $shop = $this->init_shop();
        $su = $this->init_user();
        if (!($agent = AgentMod::get_agent_by_su_uid($su['uid']))
            || !($agent['status']==0))
        {
            //木申请过或,或没通过,返回申请页（有待审核和不通过的子页）
            redirectTo('?_a=shop&_u=user.agent_apply');
        }
		uct_use_app('sp');
		$info = SpMod::get_sp_profile($shop['sp_uid']);

		/*分销商铺首页链接*/
		$url = DomainMod::get_app_url('shop',$shop['sp_uid'],array('s_a_uid'=>$agent['uid']));

        $params = array('shop' => $shop, 'agent' => $agent, 'info' => $info , 'url'=> $url);

        render_fg('', $params);
    }

	//代理申请
	public function agent_apply()
	{
		$shop = $this->init_shop();
		$su = $this->init_user();
		if (($agent = AgentMod::get_agent_by_su_uid($su['uid']))
			&& ($agent['status']==0) )
		{
			redirectTo('?_a=shop&_u=user.agent_center');//有申请过的,且已经通过审核 ，进入分销中心

		}
		$params = array('shop' => $shop, 'agent' => $agent);
		render_fg('', $params);
	}

	public function imageurl()
    {
        $shop = $this->init_shop();
        $su = $this->init_user();
//        http://127.0.0.1:84/?_a=shop&__sp_uid=1028
        $url = DomainMod::get_app_url('shop',$shop['sp_uid'],array('_u'=>'user.login','parent_su_uid'=>$su['uid']));
//        var_dump($url);
        $params = array('shop' => $shop, 'url' => $url);
        render_fg('', $params);
    }
	//我的收藏
    public function favlist()
    {
        $shop = $this->init_shop();
        $su = $this->init_user();


        $params = array('shop' => $shop, 'su' => $su);
        render_fg('', $params);
    }
	//我的足迹
    public function history()
    {
        $shop = $this->init_shop();
        $su = $this->init_user();


        $params = array('shop' => $shop, 'su' => $su);
        render_fg('', $params);
    }

}


