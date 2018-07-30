<?php

class IndexCtl {
	/*
		获取左侧菜单项
	*/
	public function get_menu_array() {
		/*
			activeurl 确定是否为选中状态
		*/
		return array(
			array('name' => '欢迎页', 'icon' => 'am-icon-home', 'link' => '?_a=sp', 'activeurl' => 'index.index'),
			//array('name' => '页面制作', 'icon' => 'am-icon-gear', 'link' => '?_a=sp&_u=index.xcxpagelist', 'activeurl' => 'index.xcxpagelist'),
			array('name' => '微信相关', 'icon' => 'am-icon-weixin', 'menus' => array(
				array('name' => '公众号列表', 'icon' => 'am-icon-weixin', 'link' => '?_a=sp&_u=index.publiclist', 
						'activeurl' => 'index.publiclist'),
				array('name' => '微信素材列表', 'icon' => 'am-icon-copy', 'link' => '?_a=sp&_u=index.medialist&mp.weixin.qq.com',
						'activeurl' => 'index.medialist'),
				/*
				array('name' => '添加公众号', 'icon' => 'am-icon-plus', 'link' => '?_a=sp&_u=index.addpublic', 
						'activeurl' => 'index.addpublic'),
				*/
				array('name' => '插件列表', 'icon' => 'am-icon-puzzle-piece', 'link' => '?_a=sp&_u=index.pluginlist', 
						'activeurl' => 'index.pluginlist'),
				array('name' => '关键词维护', 'icon' => 'am-icon-key', 'link' => '?_a=sp&_u=index.keywordlist', 
						'activeurl' => 'index.keywordlist'),
				)),
			array('name' => '商户账号', 'icon' => 'am-icon-user', 'menus' => array(
				array('name' => '基本资料', 'icon' => 'am-icon-user', 'link' => '?_a=sp&_u=index.profile', 
						'activeurl' => 'index.profile'),
			#	array('name' => '绑定微信', 'icon' => 'am-icon-weixin', 'link' => '?_a=sp&_u=index.spwxlist', 
			#			'activeurl' => 'index.spwxlist'),
				array('name' => '修改密码', 'icon' => 'am-icon-cog', 'link' => '?_a=sp&_u=index.password', 
						'activeurl' => 'index.password'),
				)),
			array('name' => '消息通知', 'icon' => 'am-icon-comment', 'link' => '?_a=sp&_u=index.msg', 
					'activeurl' => 'index.msg'),
			array('name' => '其他设置', 'icon' => 'am-icon-gears', 'menus' => array(
				array('name' => '首页设置', 'icon' => 'am-icon-gear', 'link' => '?_a=sp&_u=index.setindex', 
						'activeurl' => 'index.setindex'),
				array('name' => '文案编辑', 'icon' => 'am-icon-copy', 'link' => '?_a=sp&_u=index.documentlist', 
						'activeurl' => 'index.documentlist'),
				array('name' => '幻灯片管理', 'icon' => 'am-icon-photo', 'link' => '?_a=sp&_u=index.slidelist',
						'activeurl' => 'index.slidelist'),
				array('name' => '图片管理', 'icon' => 'am-icon-photo', 'link' => '?_a=sp&_u=index.imgmanage','activeurl' => 'index.imgmanage'),
				)),
			array('name' => '增值服务', 'icon' => 'am-icon-money', 'menus' => array(
				array('name' => '工单', 'icon' => 'am-icon-cubes', 'link' => '?_a=sp&_u=index.feedbacklist&status=-1', 
						'activeurl' => 'index.feedbacklist'),
				array('name' => '服务订单', 'icon' => 'am-icon-ticket', 'link' => '?_a=sp&_u=index.orderlist', 
						'activeurl' => 'index.orderlist'),
				array('name' => '插件商城', 'icon' => 'am-icon-puzzle-piece', 'link' => '?_a=sp&_u=index.pluginstore', 
						'activeurl' => 'index.pluginstore'),
				array('name' => '服务商城', 'icon' => 'am-icon-cloud', 'link' => '?_a=sp&_u=index.servicestore', 
						'activeurl' => 'index.servicestore'),
				)),
			//array('name' => '插件商城', 'icon' => 'am-icon-cloud', 'link' => '?_a=sp&_u=index.pluginstore', 'activeurl' => 'index.pluginstore'),
		);
	}

	protected function sp_render($params = array()) {
		$params['menu_array'] = $this->get_menu_array();
		render_sp_inner('', $params);
	}

	public function index() {
		SpMod::process_index();
        $public = WeixinMod::get_current_weixin_public();
        $sp_uid = AccountMod::get_current_service_provider('uid');
		$public_uid = $public['uid'];
		if(!empty($public['has_verified']))
		{
			$all_group = WeixinMod::weixin_get_all_group($public_uid);
			$fans_total = (empty($all_group['groups'])?array(0):array_column($all_group['groups'],'count'));
			$fans_total = array_sum($fans_total);
		}
		empty($fans_total) && $fans_total = Dba::readOne('select count(*) from service_user as su '
            .'inner join  weixin_fans as wf on wf.su_uid=su.uid where su.sp_uid = '.$sp_uid.' and wf.public_uid='.$public_uid);
		$fans_yesterday= Dba::readOne('select count(*) from service_user as su '
            .'inner join  weixin_fans as wf on wf.su_uid=su.uid where wf.public_uid= '.$public_uid.' && su.create_time > '.strtotime('yesterday').' && su.sp_uid = '.$sp_uid);


		$visit = json_decode($GLOBALS['arraydb_sys']['visit_'.$sp_uid],true);
		$visit =(isset($visit[$GLOBALS['_UCT']['APP']])?$visit[$GLOBALS['_UCT']['APP']]:0);



		$params = array('fans_total' => $fans_total, 'fans_yesterday' => $fans_yesterday,'visit'=>$visit);
		$this->sp_render($params);
	}

	/*
		分组列表
	*/
	public function fansgroups() {
		$groups = SuGroupMod::get_sp_groups(AccountMod::get_current_service_provider('uid'));
		$params = array('groups' => $groups);
		$this->sp_render($params);
	}
	
	public function addgroup() {
		$groups = SuGroupMod::get_sp_groups(AccountMod::get_current_service_provider('uid'));
		
		$group_uid = requestInt('uid');
		$group = array();
		if($group_uid) {
			$group = SuGroupMod::get_group_by_uid($group_uid);
		}

		$params = array('groups' => $groups, 'group' => $group);
		$this->sp_render($params);
	}

	/*
	  新版后台管理首页
	 */
	public function index_2() {
		SpMod::process_index();

		$this->sp_render();
	}

	public function login() {
		if($_SERVER['REQUEST_METHOD'] == 'POST') {
			$account = requestString('account', PATTERN_USER_NAME);
			$password = requestString('password', PATTERN_PASSWD);
			if(!$account || !$password) {
				outError(ERROR_INVALID_REQUEST_PARAM);
			}

			//支持子账号登陆
			uct_use_app('subsp');
			if(is_numeric(SubspMod::check_subsp_account($account))) {
				outRight(SubspMod::do_subsp_login($account, $password));
			}	
			else {
				outRight(SpMod::do_sp_login($account, $password));
			}
		}

		if(!empty($_REQUEST['_spv3']) || defined('DEBUG_WXPAY') && DEBUG_WXPAY) {
			render('/index/login.tpl', array('tpl_path' => UCT_PATH.'spv3/sp/tpl','static_path' => '/spv3/sp/static'));
		} else
		render();
	}

	/*
		微信扫码登陆	
	*/
	public function scanlogin() {
		uct_use_app('wxcode');
		if(AccountMod::has_sp_login() || SpScanloginMod::get_sp_scanlogin_by_session()) {
			if(!$goto_uri = requestString('goto_uri', PATTERN_URL)) {
				$goto_uri = '?_a=sp';
			}	

			if(AccountMod::has_sp_login()) {
				redirectTo($goto_uri);
			}
		}

		render();
	}

	/*
		输出验证码图像
	*/
	public function verifycode() {
	    include_once UCT_PATH.'vendor/images/image.php';
		$image = getImageineInstance();
		$code = SafetyCodeMod::get_a_verify_code();
		//header('sb:code is'.$code);
	    $image->out_verify_code($code);
	}

	public function logout() {
		//unset($_SESSION['sp_login']);
		session_destroy();
		redirectTo('?_a=sp');
	}

	public function register() {
		if($_SERVER['REQUEST_METHOD'] == 'POST') {
			$account = requestString('account', PATTERN_ACCOUNT);
			$password = requestString('password', PATTERN_PASSWD);
			if(!$account || !$password) {
				outError(ERROR_INVALID_REQUEST_PARAM);
			}
			$name = requestString('name', PATTERN_USER_NAME);
			$sp = array('account' => $account, 'passwd' => $password, 'name' => $name);
			outRight(SpMod::do_sp_register($sp));
		}

		if(!empty($_REQUEST['_spv3']) || defined('DEBUG_WXPAY') && DEBUG_WXPAY) {
			render('/index/register.tpl', array('tpl_path' => UCT_PATH.'spv3/sp/tpl','static_path' => '/spv3/sp/static'));
		} else
		render();
	}

	/*
		对于子账号而言, 这里只显示了有权限访问的公众号
	*/
	public function publiclist() {
		$component=array('pre_auth_code'=>ComponentMod::get_pre_auth_code(),
						'sp_uid'=>accountMod::get_current_service_provider('uid'));
		$all_public = WeixinMod::get_all_weixin_public_by_sp_uid();
		$cnt=count($all_public);
		$max_public_cnt=AccountMod::get_current_service_provider('max_public_cnt');
		$server_provider = AccountMod::get_service_provider_by_uid(AccountMod::get_current_service_provider('uid'));
		$uct_token=$server_provider['uct_token'];

		$params = array('list' => $all_public,'cnt'=>$cnt,'max_public_cnt'=>$max_public_cnt,'uct_tokens'=>$uct_token,'component'=>$component);
		$this->sp_render($params);
	}

	/*
		添加或编辑公众号
		主要用于代理后台
	*/
	public function addpublic() {
		$_GET['_u'] = 'index.addpublic_real';
		$_GET['_PHPSESSID'] = session_id();
		$_GET['_ap_uid'] = which_agent_provider();

		//有效代理
		if($_GET['_ap_uid']) {
			$params['url'] = (isHttps() ? 'https://' : 'http://').'weixin.uctphp.com/?'.http_build_query($_GET);
		} else {
			$params['url'] = '/?'.http_build_query($_GET);
		}

		render_sp_inner('', $params);
	}

	//默认小程序
	public function default_public() {
		$public = WeixinMod::get_current_weixin_public();
		if(!$public) {
			redirectTo('/?_a=sp');
		}

		$public['url'] = WeixinMod::get_tencent_callback_url();
		$public['token'] = WeixinMod::get_tencent_token();
		$params = array('public'=>$public);	

		//render_sp_inner('', $params);
		$this->sp_render($params);
	}

	/*
		添加或编辑公众号
	*/
	public function addpublic_real() {
		$params = array();
		if(($uid = requestInt('uid')) && ($public = WeixinMod::get_weixin_public_by_uid($uid)) &&
			$public['sp_uid'] == AccountMod::get_current_service_provider('uid')) {
			WeixinMod::set_current_weixin_public($public);
			$public['url'] = WeixinMod::get_tencent_callback_url();
			$public['token'] = WeixinMod::get_tencent_token();
			$params = array('public'=>$public);	
		}
		else {
			//超过限制
			$cnt = Dba::readOne('select count(*) from weixin_public where sp_uid = '.AccountMod::get_current_service_provider('uid'));
			if($cnt && $cnt >= AccountMod::get_current_service_provider('max_public_cnt')) {
				//redirectTo('?_a=sp&_u=index.publiclist');
				echo '<script>
var url = "?_a=sp&_u=index.publiclist";
if(top!=self) top.location.href=url;
else window.location.href=url;
</script>';
				exit();
			}
		}

		render_sp_inner('', $params);
	}

	/*
		消息通知
	*/
	public function msg() {
		$option['page'] = requestInt('page', 0);
		if(!$option['limit'] = requestInt('limit', 10)) {
			$option['limit'] = 10;
		}

		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		$option['sp_uid']  = AccountMod::get_current_service_provider('uid');

		$data = SpMsgMod::get_sp_msg($option);
		$pagination = uct_pagination($option['page'], ceil($data['count']/$option['limit']), 
						'?_a=sp&_u=index.msg&key='.$option['key'].'&limit='.$option['limit'].'&page=');

		$params = array('option' => $option, 'data' => $data, 'pagination' => $pagination);
		$this->sp_render($params);
	}


	/*
		插件列表
	*/
	public function pluginlist() {
		$cats = WeixinPlugMod::get_weixin_plugin_cats();
		$option['cat'] = requestString('cat');
		if($option['cat'] && !isset($cats[$option['cat']])) {
			$option['cat'] = '';
		}
		$option['page'] = requestInt('page', 0);
		if(!$option['limit'] = requestInt('limit', 10)) {
			$option['limit'] = 10;
		}
		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);

		$data = WeixinPlugMod::get_weixin_public_plugins_option(0, $option);
		$pagination = uct_pagination($option['page'], ceil($data['count']/$option['limit']), 
						'?_a=sp&_u=index.pluginlist&cat='.$option['cat'].'&key='.$option['key'].'&limit='.$option['limit'].'&page=');

		$params = array('cats' => $cats, 'option' => $option, 'data' => $data, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	public function keywordlist() {
		$option['page'] = requestInt('page', 0);
		if(!$option['limit'] = requestInt('limit', 10)) {
			$option['limit'] = 10;
		}
		$option['config_keywords'] = true;

		$data = WeixinPlugMod::get_weixin_public_plugins_option(0, $option);
		$pagination = uct_pagination($option['page'], ceil($data['count']/$option['limit']), 
						'?_a=sp&_u=index.keywordlist&limit='.$option['limit'].'&page=');

		$params = array('option' => $option, 'data' => $data, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	/*
		商户资料
	*/
	public function profile() {
		if($_SERVER['REQUEST_METHOD'] == 'POST') {
			$p = array();	
			isset($_REQUEST['type']) && $p['type'] = requestInt('type');
			isset($_REQUEST['industry']) && $p['industry'] = requestInt('industry');
			isset($_REQUEST['fullname']) && $p['fullname'] = requestString('fullname', PATTERN_FILE_NAME);
			isset($_REQUEST['email']) && $p['email'] = requestString('email', PATTERN_EMAIL);
			isset($_REQUEST['qq']) && $p['qq'] = requestString('qq', PATTERN_QQ);
			isset($_REQUEST['phone']) && $p['phone'] = requestString('phone', PATTERN_PHONE);
			isset($_REQUEST['qrcode']) && $p['qrcode'] = requestString('qrcode', PATTERN_URL);
			isset($_REQUEST['brief']) && $p['brief'] = requestString('brief');
			isset($_REQUEST['avatar']) && $p['avatar'] = requestString('avatar', PATTERN_URL);
			isset($_REQUEST['province']) && $p['province'] = requestString('province', PATTERN_USER_NAME);
			isset($_REQUEST['city']) && $p['city'] = requestString('city', PATTERN_USER_NAME);
			isset($_REQUEST['town']) && $p['town'] = requestString('town', PATTERN_USER_NAME);
			isset($_REQUEST['address']) && $p['address'] = requestStringLen('address', 64);
			isset($_REQUEST['lng']) && $p['lng'] = requestFloat('lng');
			isset($_REQUEST['lat']) && $p['lat'] = requestFloat('lat');
			
			if(!$p) {
				outError(ERROR_INVALID_REQUEST_PARAM);
			}	
				
			outRight(SpMod::update_sp_profile(0, $p));
		}

		$profile = SpMod::get_sp_profile();

		#所有行业
		$industries = IndustryDataMod::get_all();
		$params = array('profile' => $profile, 'industries' => $industries);

		$this->sp_render($params);
	}

	/*
	 * 百度转换腾讯地图经纬度坐标
	 */
	public function replay_bd_tx(){
		if((!$p['lat'] = requestFloat('lat'))||(!$p['lng'] = requestFloat('lng'))){
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$link='http://apis.map.qq.com/ws/coord/v1/translate?locations='.$p['lat'].','.$p['lng'].'&output=json&type=3&key=ISDBZ-PNXCF-HUTJL-N3TM3-T3RQQ-ABFU7';
		$data = file_get_contents($link);

		outRight(json_decode($data,true));
	}

	//常见问题
	public function problemlist(){

		$option['type'] = requestString('type');
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
		$option['houtai'] = 1;
//		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');

		$types = SpMod::get_all_type();
		$documents = SpMod::get_problems($option);
		$pagination = uct_pagination($option['page'], ceil($documents['count']/$option['limit']),
			'?_a=sp&_u=index.problemlist&type='.$option['type'].'&limit='.$option['limit'].'&page=');

		$params = array('data' => $documents,'types' => $types,'option' => $option, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	/*
    添加和编辑问题
	*/
	public function addproblem(){
		if(!($uid = requestInt('uid')) ||!($data = SpMod::get_problem_by_uid($uid))) {
			$data = array();
		}

		$params = array('data' => $data);
		$this->sp_render($params);
	}

	//搜索链接
	public function links(){

		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);

		$data = SpMod::get_links($option);
		$pagination = uct_pagination($option['page'], ceil($data['count']/$option['limit']),
			'?_a=sp&_u=index.links&key='.$option['key'].'&limit='.$option['limit'].'&page=');

		$params = array('data' => $data,'option' => $option, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	/*
	添加和编辑链接
	*/
	public function addlink(){
		if(!($uid = requestInt('uid')) ||!($data = SpMod::get_link_by_uid($uid))) {
			$data = array();
		}

		$params = array('data' => $data);
		$this->sp_render($params);
	}

	/*
		todo
		短信记录
		账号配额

		服务订单记录
	*/
	public function orderlist() {
		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');
		$option['status'] = requestInt('status');
		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);

		$data = SpServiceMod::get_service_order_list($option);
		$pagination = uct_pagination($option['page'], ceil($data['count']/$option['limit']), 
						'?_a=sp&_u=index.orderlist&status='.$option['status'].'&key='.$option['key'].'&limit='.$option['limit'].'&page=');
		
		$params = array('option' => $option, 'data' => $data, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	/*
		服务订单详情
	*/
	public function orderdetail() {
		if(!($uid = requestInt('uid')) || !($order = SpServiceMod::get_service_order_by_uid($uid)) ||
			($order['sp_uid'] != AccountMod::get_current_service_provider('uid'))) {
			echo '参数错误!';
			return false;
		}

		$params = array('order' => $order);
		$this->sp_render($params);
	}

	/*
		工单列表
	*/
	public function feedbacklist() {
		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');
		$option['status'] = requestInt('status');
		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);

		$data = SpFeedbackMod::get_sp_feedback_list($option);
		$pagination = uct_pagination($option['page'], ceil($data['count']/$option['limit']), 
						'?_a=sp&_u=index.feedbacklist&status='.$option['status'].'&key='.$option['key'].'&limit='.$option['limit'].'&page=');
		
		$params = array('option' => $option, 'data' => $data, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	/*
		添加编辑工单
	*/
	public function addfeedback() {
		$uid = requestInt('uid');
		$fb = array();
		if($uid) {
			$fb = SpFeedbackMod::get_sp_feedback_by_uid($uid);
			if(!$fb || ($fb['sp_uid'] != AccountMod::get_current_service_provider('uid'))) {
				$fb = array();
			}
		}
		$params = array('fb' => $fb, );
		$this->sp_render($params);
	}

	/*
		修改密码 
	*/
	public function password() {
		$this->sp_render();
	}

	/*
		插件商城
	*/
	public function pluginstore() {
		$cats = WeixinPlugMod::get_weixin_plugin_cats();

		$option['cat'] = requestString('cat');
		if($option['cat'] && !isset($cats[$option['cat']])) {
			$option['cat'] = '';
		}
		$option['page'] = requestInt('page', 0);
		if(!$option['limit'] = requestInt('limit', 8)) {
			$option['limit'] = 8;
		}
		$option['key'] = requestString('key', PATTERN_SEARCH_KEY);
		$option['installed'] =  requestint('installed',0);//0 全部 1只安装 2 未安装
		$data = WeixinPlugMod::get_store_plugins_list(0, $option);
		$pagination = uct_pagination($option['page'], ceil($data['count']/$option['limit']), 
						'?_a=sp&_u=index.pluginstore&cat='.$option['cat'].'&key='.$option['key'].'&limit='.$option['limit'].'&installed='.$option['installed'].'&page=');

		$params = array('cats' => $cats, 'option' => $option, 'data' => $data, 'pagination' => $pagination);

		$this->sp_render($params);
	}

	public function plugindetail() {
		if($_SERVER['REQUEST_METHOD'] == 'POST') {
			if(!($dir = requestString('dir', PATTERN_APP_NAME)) ||
				!($plugin = WeixinPlugMod::get_plugin_by_dir($dir)) ||
				$plugin['has_installed']) {
				outError(ERROR_INVALID_REQUEST_PARAM);
			}

			$plugin['dir'] = $dir;
			//todo sku = 期限:6个月
			outRight(WeixinPlugMod::install_a_plugin($plugin));
		}

		if(!($dir = requestString('dir', PATTERN_APP_NAME)) ||
			!($plugin = WeixinPlugMod::get_plugin_by_dir($dir))) {
			redirectTo('?_a=sp&_u=index.pluginstore');
		}

		$params = array('plugin' => $plugin);
		$this->sp_render($params);
	}

	/*
		服务商城
	*/
	public function servicestore() {
		$option['page'] = requestInt('page', 0);
		if(!$option['limit'] = requestInt('limit', 8)) {
			$option['limit'] = 8;
		}

		$data = SpServiceMod::get_store_service_list($option);
		$pagination = uct_pagination($option['page'], ceil($data['count']/$option['limit']), 
						'?_a=sp&_u=index.servicestore&limit='.$option['limit'].'&page=');

		$params = array('option' => $option, 'data' => $data, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	public function servicedetail() {
		if($_SERVER['REQUEST_METHOD'] == 'POST') {
			if(!($uid = requestString('uid', PATTERN_SKU_UID)) ||
				!($service = SpServiceMod::get_store_service_product_by_sku_uid($uid))) {
				outError(ERROR_INVALID_REQUEST_PARAM);
			}
			$dir = requestString('dir', PATTERN_APP_NAME); //插件
			if($service['is_virtual'] == SpServiceMod::VIRTUAL_ADD_APP) {
				if(!$dir || (!$dir = WeixinPlugMod::get_plugin_by_dir($dir))) {
					outError(ERROR_INVALID_REQUEST_PARAM);
				}
				$service['name'] .=  ' - '.$dir['name'];
				if(!isset($service['price'])) {
					$service['ori_price'] = $service['price'] = $dir['price'];	
				}
				$service['thumb'] =  $dir['thumb'];
			
				$dir = $dir['dir'];
			}
			
			$quantity = requestInt('quantity', 1);
			if($quantity < 1 || (!$service['is_virtual'] && ($quantity > $service['quantity']))) {
				outError(ERROR_OUT_OF_LIMIT);
			}
			//$sku = requestString('sku');
			$address = requestKvJson('address');
			$order = array(
						'sp_uid' => AccountMod::get_current_service_provider('uid'),
						'service' => array('uid'         => $service['uid'], 
											'paid_price' => $service['price'],
											'name'       => $service['name'],
											'main_img'   => $service['thumb'],
											'quantity'   => $quantity,
											'dir'   	 => $dir,
											'sku_uid'    => $uid,
											'is_virtual' => $service['is_virtual'],
											'virtual_sku_uid' => strpos($uid, ';') ? ( $service['is_virtual'].substr($uid, strpos($uid, ';'))) : $service['is_virtual'],
											'address'    => $address,
											),
						'service_uid' => $service['uid'],
						'paid_fee' => $service['price'] * $quantity,
					);

			Dba::beginTransaction(); {
				//Dba::write('update service_store_product set sell_cnt');
				if(!SpServiceMod::decrease_service_product_quantity($uid, $quantity)) {
					Dba::rollBack();	
					outError();
				}
				Event::addHandler('AfterMakeServiceOrder', array('SpServiceMod', 'onAfterMakeServiceOrder'));
				$ret = SpServiceMod::make_a_service_order($order);
			} Dba::commit();
			outRight($ret);
		}

		if(!($uid = requestInt('uid')) ||
			!($service = SpServiceMod::get_service_by_uid($uid))) {
			redirectTo('?_a=sp&_u=index.servicestore');
		}

		$params = array('service' => $service);
		$this->sp_render($params);
	}

	public function forget() {
		if($_SERVER['REQUEST_METHOD'] == 'POST') {
		}

		if(!empty($_REQUEST['_spv3']) || defined('DEBUG_WXPAY') && DEBUG_WXPAY) {
			render('/index/forget.tpl', array('tpl_path' => UCT_PATH.'spv3/sp/tpl','static_path' => '/spv3/sp/static'));
		} else 
		render();
	}

	public function medialist() {
		$option['media_type'] = requestInt('media_type');
		$option['page'] = requestInt('page', 0);
		if(!$option['limit'] = requestInt('limit', 10)) {
			$option['limit'] = 10;
		}
		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');
		$media = WeixinMediaMod::get_weixin_media($option);

		$params = array('option' => $option, 'media' => $media);
		$this->sp_render($params);
	}

	/*
		添加或编辑单个多图文
	*/
    public function picsmedia() {
		//yhc ：编辑图文的uid，0：代表是增加
        if($uid = requestInt('uid')) {
			$media = WeixinMediaMod::get_weixin_media_by_uid($uid);
			if($media && ($media['sp_uid'] != AccountMod::get_current_service_provider('uid'))) {
				setLastError(ERROR_OBJ_NOT_EXIST);
				$media = array();
			}
		}
		else {
			$media = array();
		}

        $params = array('media' => $media);
        $this->sp_render($params);
    }

	/*
		设置首页
	*/
	public function setindex() {
		if($_SERVER['REQUEST_METHOD'] == 'POST') {
			$index = requestKvJson('index');
			outRight(SpMod::set_index($index));
		}

		$index = SpMod::get_index();
        $params = array('index' => $index);
        $this->sp_render($params);
	}

    /*
		方案例表
    */
	public function documentlist(){
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');

		$documents = SpMod::get_documents($option);
		$pagination = uct_pagination($option['page'], ceil($documents['count']/$option['limit']), 
						'?_a=sp&_u=index.documentlist&limit='.$option['limit'].'&page=');

		$params = array('documents' => $documents, 'pagination' => $pagination);
		$this->sp_render($params);
	}



	/*
		添加和编辑文案
	*/
	public function adddocument(){
		if(!($uid = requestInt('uid')) ||
			!($document = SpMod::get_document_by_uid($uid)) ||
			$document['sp_uid'] != AccountMod::get_current_service_provider('uid')) {
			$document = array();
		}

		$params = array('document' => $document);
		$this->sp_render($params);
	}

	/*
		绑定微信号列表	
	*/
	public function spwxlist() {
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');

		$data = SpwxMod::get_sp_wx_list($option);
		$pagination = uct_pagination($option['page'], ceil($data['count']/$option['limit']), 
						'?_a=sp&_u=sp.spwxlist&limit='.$option['limit'].'&page=');

		$params = array('data' => $data, 'pagination' => $pagination);
		$this->sp_render($params);
	}
	
	/*
		添加和编辑微信
	*/
	public function addspwx(){
		if(!($open_id = requestString('open_id', PATTERN_NORMAL_STRING)) ||
			!($sw = SpwxMod::get_sp_wx_by_openid($open_id)) ||
			$sw['sp_uid'] != AccountMod::get_current_service_provider('uid')) {
			$sw = array();
		}

		$params = array('sw' => $sw);
		$this->sp_render($params);
	}


	/*
		幻灯片列表
	*/
	public function slidelist()
	{
		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');
		$option['pos'] = requestString('pos', PATTERN_SEARCH_KEY);
		$option['with_all'] = 1;
		$slides = SlidesMod::get_slides($option);

		$params = array('option' => $option, 'slides' => $slides);
		$this->sp_render($params);
	}

	/*
		添加编辑幻灯片
	*/
	public function addslide()
	{
		$sp_uid = AccountMod::get_current_service_provider('uid');
		$uid = requestInt('uid');
		if(!$uid || !($slide = SlidesMod::get_slide_by_uid($uid)) || 
			($slide['sp_uid'] != $sp_uid)) {
				$slide = array();
		}
		
		if(!$slide && ($copy_uid = requestInt('copy_uid'))) { 
			$slide = SlidesMod::get_slide_by_uid($copy_uid);
			if(!$slide || $slide['sp_uid'] != $sp_uid) {
				$slide = array();
			}
			unset($slide['uid']);
		}
		
		$params = array('slide' => $slide);
		$this->sp_render($params);
	}

	/*
		附件列表
	*/
	public function attachlist()
	{
		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');
		$option['pos'] = requestString('pos', PATTERN_SEARCH_KEY);
		$option['with_all'] = 1;
		$attaches = AttachesMod::get_attaches($option);

		$params = array('option' => $option, 'attaches' => $attaches);
		$this->sp_render($params);
	}

	/*
		添加编辑附件
	*/
	public function addattach()
	{
		$sp_uid = AccountMod::get_current_service_provider('uid');
		$uid = requestInt('uid');
		if(!$uid || !($attach = AttachesMod::get_attach_by_uid($uid)) || 
			($attach['sp_uid'] != $sp_uid)) {
				$attach = array();
		}
		
		if(!$attach && ($copy_uid = requestInt('copy_uid'))) { 
			$attach = AttachesMod::get_attach_by_uid($copy_uid);
			if(!$attach || $attach['sp_uid'] != $sp_uid) {
				$attach = array();
			}
			unset($attach['uid']);
		}
		
		$params = array('attach' => $attach);
		$this->sp_render($params);
	}

	/*
		小程序功能相关
	*/
	public function xiaochengxu() {
		$sp_uid = AccountMod::get_current_service_provider('uid');
		if(!($public_uid = requestInt('uid')) || 
		  !($public = WeixinMod::get_weixin_public_by_uid($public_uid)) ||
		  $public['sp_uid'] != $sp_uid) {
			$public = Dba::readRowAssoc('select * from weixin_public where sp_uid = '.$sp_uid.
					' && (public_type & 8) = 8', 'WeixinMod::func_get_weixin');	
		}

		if(!$public) {
			//echo '参数错误！';exit;
			redirectTo('?_a=sp&_u=index.default_public');
		}

		$params = array('public' => $public);
		$this->sp_render($params);
	}

	/*
    图库管理
	*/
	public function imgmanage(){
		$params = array();
		$this->sp_render($params);
	}

    /*
		小程序页面列表
    */
	public function xcxpagelist(){
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');

		$data = XiaochengxuPagesMod::get_xiaochengxu_pages_list($option);
		$pagination = uct_pagination($option['page'], ceil($data['count']/$option['limit']), 
						'?_a=sp&_u=index.xcxpagelist&limit='.$option['limit'].'&page=');

		$params = array('data' => $data, 'pagination' => $pagination);
		$this->sp_render($params);
	}

	public function friends() {
		$this->sp_render();
	}

	public function gotofriend() {
		if((!$uid = requestInt('uid')) ||
			!($fp = AccountMod::get_service_provider_by_uid($uid)) ||
			($fp['friend_uid'] != AccountMod::get_current_service_provider('friend_uid'))) {
			echo 'not allowed!'; return;
		}

		$_SESSION['has_select_shop'] = 1;
		$_SESSION['sp_login'] = $_SESSION['sp_uid'] = $fp['uid'];
		$_SESSION['uct_token'] = $fp['uct_token'];

		//第一次跳到店铺装修
		if(!Dba::readOne('select uid from xiaochengxu_pages where sp_uid = '.$uid.' limit 1')) {
			redirectTo('?_easy=shop.sp.visualview');
		} else {
			redirectTo('?_a=sp');
		}
	}

	/*
		spv3后台导航
		一般用于子账号
	*/
	public function map() {
		$params = array();
		if(($uid = AccountMod::has_subsp_login()) && ($subsp = SubspMod::get_subsp_by_uid($uid)) &&
			$subsp['sp_uid'] == AccountMod::get_current_service_provider('uid')) {
			$params['subsp'] = $subsp;
		}

		//菜单
		#$params['menus'] = SubspMod::get_all_sp_menu_array_of_sp_uid();
		$this->sp_render($params);
	}

}

