<?php
/*
	服务提供商模块	
*/
// header("content-type:text/html; charset=utf8");
class SpMod {
	public static function func_get_sp_profile($item) {
		$item['address'] = htmlspecialchars($item['address']);
		$item['brief'] = XssHtml::clean_xss($item['brief']);

		return $item;
	}
	public static function func_get_document($item){
		$item['content'] = XssHtml::clean_xss($item['content']);

		return $item;
	}

	/*
		检查商户是否登陆, 通过$_SESSION['sp_login']进行判断
	*/
	public static function has_sp_login() {
		return AccountMod::has_sp_login();
	}

	/*
		检查商户是否设置了公众号, 通过uct_token进行判断
		注意这里没有检查uct_token的合法性
	*/
	public static function has_weixin_public_set() {
		if(!empty($_SESSION['uct_token'])) {
			return $_SESSION['uct_token'];
		}
		if(!empty($_GET['uct_token'])) {
			return $_GET['uct_token'];
		}

		
		//后台页面看看是否子账号登录
		if(uct_is_backend_page() &&
			($subsp_uid = AccountMod::has_subsp_login()) && (
			$uct_token = Dba::readOne('select uct_token from sub_sp where uid = '.$subsp_uid))) {
			return $uct_token;
		}

		//前台页面看看当前商户
		if(!uct_is_backend_page() &&
			($sp_uid = AccountMod::require_sp_uid(false)) && (
			$uct_token = Dba::readOne('select uct_token from service_provider where uid = '.$sp_uid))) {
			return $uct_token;
		}

		return 0;
	}


	/*
		商户后台系统
		检查是否登陆， 是否设置了公众号
	*/
	public static function checkActionPermission() {
		if(!self::has_sp_login()) { 
			if(!in_array($GLOBALS['_UCT']['CTL'].'.'.$GLOBALS['_UCT']['ACT'], array('index.login', 'index.register', 'index.forget','index.scanlogin', 
				'index.verifycode', 'api.register_invite', 'api.check_account', 'api.mobilecode', 'api.reset_password', 'api.check_invite_code', 'api.register_test'))) {
				$r = getUrlName().'/?'.http_build_query($_GET);
				redirectTo('?_a=sp&_u=index.login&goto_uri='.urlencode($r));
			}
		}	
		else {
			if(!self::has_weixin_public_set() && !WeixinMod::get_current_weixin_public('', false)) { 
				if(!in_array($GLOBALS['_UCT']['CTL'].'.'.$GLOBALS['_UCT']['ACT'], array('index.addpublic', 'index.logout', 'index.addpublic_real',
					'api.add_public', 'api.add_fake_public','api.get_component_url'))) {
					redirectTo('?_a=sp&_u=index.addpublic');
				}
			}	

			//子账号访问权限检查
			if(!SpInviteMod::check_current_sp_access()) {
				//如果访问的是模块后台,那么跳转到插件商城安装页
				if(($GLOBALS['_UCT']['CTL'] == 'sp') &&	
					((!WeixinPlugMod::is_plugin_installed_to_sp_uid($GLOBALS['_UCT']['APP'])) 
						)) {
					redirectTo('?_a=sp&_u=index.plugindetail&dir='.$GLOBALS['_UCT']['APP']);
				}
				//登录退出首页始终可以访问
				else if(in_array($GLOBALS['_UCT']['CTL'].'.'.$GLOBALS['_UCT']['ACT'], array('index.login', 'index.logout',
					'index.index', 'index.map', 'index.password'))) {
				}
				else {
					//子账号跳到后台导航
					if(AccountMod::has_subsp_login()) {
						redirectTo('?_a=sp&_u=index.map');
					}
					header('Content-type:text/html; charset=utf-8');
					echo '<a href="?_a=sp&_u=index.plugindetail&dir='.$GLOBALS['_UCT']['APP'].
							'">抱歉!访问权限受限!请检查服务是否到期!</a>'; exit(1);
				}
			}

			if(AccountMod::has_subsp_login()) {
				uct_use_app('subsp');
			}
		}
	}

	/*
		记录最近使用的插件
	*/
	public static function recordRecentUsedApp() {
		if(in_array($GLOBALS['_UCT']['APP'], array('sp', 'upload', 'admin'))) {
			return;
		}

		$key = 'rua_'.AccountMod::get_current_service_provider('uid');
		$rua = self::getRecentUsedApp($key);
		if(($k = array_search($GLOBALS['_UCT']['APP'], $rua)) !== false) {
			unset($rua[$k]);
		}
		array_unshift($rua, $GLOBALS['_UCT']['APP']);
		$rua = array_slice($rua, 0, 7);
		$GLOBALS['arraydb_sys'][$key] = json_encode($rua);	
	}

	/*
		获取最近使用的插件列表	
	*/
	public static function getRecentUsedApp($key = '') {
		!$key && $key = 'rua_'.AccountMod::get_current_service_provider('uid');
		if(isset($GLOBALS['arraydb_sys'][$key])) {
			$ret = json_decode($GLOBALS['arraydb_sys'][$key], true);
		}
		if(empty($ret)) {
			$ret = array('welcome', 'default');
		}

		return $ret;
	}

	/*
		商户登陆	
	*/
	public static function do_sp_login($account, $password) {
		$sql = 'select * from service_provider where account = "'.addslashes($account).'"';
		if(!($sp = Dba::readRowAssoc($sql))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}

		//验证码
		if(!SafetyCodeMod::check_verify_code()) {
			return false;
		}

		//账号被锁定
		if(!($sp = self::check_sp_status($sp))) {
			return false;
		}

		if(($sp['passwd'] != md5($password))) {
			self::try_disable_sp_1_hour($sp['uid']);
			setLastError(ERROR_INVALID_EMAIL_OR_PASSWD);
			return false;
		}

		//不要把用户删了
		//$_SESSION = array();
		$_SESSION['sp_login'] = $_SESSION['sp_uid'] = $sp['uid'];
		if($sp['uct_token']) {
			$_SESSION['uct_token'] = $sp['uct_token'];
		}
		else {
			unset($_SESSION['uct_token']);
		}
	
		$update = array('last_time' => $_SERVER['REQUEST_TIME'], 'last_ip' => requestClientIP(), 'status' => $sp['status']);
		Dba::update('service_provider', $update, 'uid = '.$sp['uid']);
		Event::handle('AfterSpLogin');

		return array('uid' => $sp['uid'], 'name' => $sp['name']);
	}

	/*
		检查账号是否被注册
	*/
	public static function check_sp_account($account) {
		$sql = 'select uid from service_provider where account = "'.addslashes($account).'"';

		return Dba::readOne($sql);
	}

	/*
		修改密码
	*/
	public static function change_sp_password($old, $new, $uid = 0) {
		if(!$uid && !($uid = AccountMod::get_current_service_provider('uid'))) {
			setLastError(ERROR_DBG_STEP_1);
			return false;	
		}
		if(!($sp = Dba::readRowAssoc('select uid, passwd from service_provider where uid = '.$uid))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;	
		}
		if($sp['passwd'] && (md5($old) != $sp['passwd'])) {
			setLastError(ERROR_DBG_STEP_2);
			return false;
		}

		self::update_sp($uid, array('passwd' => md5($new)));
		return true;
	}

	/*
		重置密码
	*/
	public static function reset_sp_password($phone, $password) {
		if(!($sp = Dba::readRowAssoc('select uid, status, last_time from service_provider where account = "'.addslashes($phone).'"'))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;	
		}
		if(!($sp = self::check_sp_status($sp))) {
			return false;
		}
		//短信验证码
		if(!SafetyCodeMod::check_mobile_code()) {
			self::try_disable_sp_1_hour($sp['uid'], 5);
			return false;
		}

		self::update_sp($sp['uid'], array('passwd' => md5($password), 'status' => $sp['status']));
		return true;
	}

	/*
		商户注册	@param $sp = array('account' =>   //登陆账号
							'passwd' => //密码, 明文 
							'invitecode' => //邀请码
						)
	*/
	public static function do_sp_register($sp) {
		//短信验证码
		if(!SafetyCodeMod::check_mobile_code()) {
			return false;
		}

		//邀请码 
		if(isset($sp['invitecode'])) {
			if((!$ic = SpInviteMod::check_invite_code($sp['invitecode']))) {
				return false;
			}
			unset($sp['invitecode']);
		}

		if((self::check_sp_account($sp['account']))) {
			setLastError(ERROR_OBJECT_ALREADY_EXIST);
			return false;
		}
		$sp['passwd'] = md5($sp['passwd']);
		$sp['create_time'] = $_SERVER['REQUEST_TIME'];
		if(!empty($ic['free_limit']['public'])) {
			$sp['max_public_cnt'] = $ic['free_limit']['public'];
		}

		Dba::insert('service_provider', $sp);
		$sp['uid'] = Dba::insertID();

		/*
			注册时更新sp_uid, 也要同时更新auto_increment,不然下次注册将会出错
		*/
		uct_use_app('domain');
		$sp_uid = DomainMod::get_a_sp_uid_for_current_top_domain($sp['uid']);
		if($sp_uid != $sp['uid']) {
			/*
				或者这样, 更新sp_uid, 更新auto_increment
				Dba::write('update service_provider set uid = '.$sp_uid.' where uid = '.$sp['uid']);
				Dba::write('alter table service_provider auto_increment = '.($sp_uid + 1));
			*/
			Dba::write('delete from service_provider where uid = '.$sp['uid']);
			$sp['uid'] = $sp_uid;
			Dba::insert('service_provider', $sp);
		}

		if($sp['uid'] && !empty($ic['uid'])) {
			//更新邀请码并作些商户资料初始化
			SpInviteMod::invalidate_invite_code($ic, $sp);
		}

		Event::handle('AfterSpRegister', array($sp));

		return array('uid' => $sp['uid']);
	}

	/*
		获取商户资料
	*/
	public static function get_sp_profile($uid = 0) {
		if(!$uid && !($uid = AccountMod::get_current_service_provider('uid'))) {
			setLastError(ERROR_DBG_STEP_1);
			return false;	
		}

		$sql = 'select * from service_provider_profile where uid = '.$uid;
		if($p = Dba::readRowAssoc($sql, 'SpMod::func_get_sp_profile')) {
			if($uid == AccountMod::get_current_service_provider('uid')) {
				$p['avatar'] = AccountMod::get_current_service_provider('avatar');
			}
			else {
				$p['avatar'] = Dba::readOne('select avatar from service_provider where uid = '.$uid);
			}
		}

		return $p;
	}

	/*
		修改商户基本资料
	*/
	public static function update_sp($uid, $update) {
		if(!$uid && !($uid = AccountMod::get_current_service_provider('uid'))) {
			setLastError(ERROR_DBG_STEP_1);
			return false;	
		}

		Dba::update('service_provider', $update, 'uid = '.$uid);
		return true;
	}


	/*
		修改商户资料
	*/
	public static function update_sp_profile($uid, $profile) {
		if(!$uid && !($uid = AccountMod::get_current_service_provider('uid'))) {
			setLastError(ERROR_DBG_STEP_1);
			return false;	
		}

		Event::handle('BeforeUpdateSpProfile', array($uid, $profile));

		//avatar字段不在同一张表里
		if(isset($profile['avatar'])) {
			self::update_sp($uid, array('avatar' => $profile['avatar']));
			unset($profile['avatar']);
		}

		if($profile) {
			if(Dba::readRowAssoc('select 1 from service_provider_profile where uid = '.$uid)) {
				Dba::update('service_provider_profile', $profile, 'uid = '.$uid);
			}
			else {
				$profile['uid'] = $uid;
				Dba::insert('service_provider_profile', $profile);
			}
		}

		return true;
	}

	/*
		获取商户后台顶部菜单数据
		* cacheable
	*/
	public static function get_sp_header_menu($uid = 0) {
		$ps = WeixinPlugMod::get_weixin_public_plugins_all($uid);
		$cats = WeixinPlugMod::get_weixin_plugin_cats();
		foreach($ps as $p) {
			$key = isset($cats[$p['type']]) ? $p['type'] : 'other';
			$cats[$key]['menu'][] = $p;
			if($GLOBALS['_UCT']['APP'] == $p['dir']) {
				$cats[$key]['active'] = 1;
			}
		}

		return $cats;
	}

	/*
		检查服务商状态
		成功返回$sp,失败返回false
		会自动解除锁定状态	
	*/
	public static function check_sp_status($sp) {
		if(is_numeric($sp)) {
			if(!($sp = Dba::readRowAssoc('select * from service_provider where uid = '.$sp))) {
				setLastError(ERROR_OBJ_NOT_EXIST);
				return false;
			}
		}
		if($sp['status'] >= 60) {
			if(($sp['last_time'] + 3600) >= $_SERVER['REQUEST_TIME']) {
				setLastError(ERROR_DENYED_FOR_SAFETY);
				return false;
			}
			else {
				$sp['status'] -= 60;
			}
		}
		if($sp['status'] > 1) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}

		return $sp;
	}

	/*
		锁定商户账号1小时, 禁止登陆

		5分钟内连续10次出错才禁止账号
		$failcnt 出错次数
	*/
	public static function try_disable_sp_1_hour($uid, $failcnt = 1) {
		$key = 'failsp_'.$uid;
		if(!($old = $GLOBALS['arraydb_sys'][$key])) {
			$old = 0;
		}
		$old += $failcnt;
		$GLOBALS['arraydb_sys'][$key] = array('expire' => 300, 'value' => $old);
		if($old < 10) {
			return 0;
		}

		$sql = 'update service_provider set status = if(status < 60, status + 60, status), last_time = '.$_SERVER['REQUEST_TIME']
				.' where uid = '.$uid;
		Dba::write($sql);

		return Dba::affectedRows();
	}

	/*
		解除锁定商户账号1小时,
	*/
	public static function enable_sp_1_hour($uid) {
		$sql = 'update service_provider set status = if(status >= 60, status - 60, status), last_time = '.$_SERVER['REQUEST_TIME']
				.' where uid = '.$uid;
		Dba::write($sql);

		return Dba::affectedRows();
	}

	/*
		设置首页, 可以设置为跳转到指定模块, 跳转到最近使用,	
		$index = array(	
			'type' => 'redirect' 或 recent
			'url' => '?_a=shop&_u=sp'
		)
	*/
	public static function set_index($index, $key = '') {
		!$key && $key = 'index_'.AccountMod::get_current_service_provider('uid');
		if(is_array($index)) $index = json_encode($index);
		return $GLOBALS['arraydb_sys'][$key] = $index;	
	}

	public static function get_index($key = '') {
		!$key && $key = 'index_'.AccountMod::get_current_service_provider('uid');
		if(!isset($GLOBALS['arraydb_sys'][$key]) ||
			!($index = json_decode($GLOBALS['arraydb_sys'][$key], true)) ||
			!(isset($index['type']))) {
			return false;
		}

		return $index;
	}

	/*
		商户后台首页	
	*/
	public static function process_index($key='') {
		if(!($index = self::get_index($key))) {
			return true;
		}

		switch($index['type']) {
			case 'redirect': {
				redirectTo($index['url']);
				break;
			}
			case 'recent': {
				redirectTo('?_a='.current(SpMod::getRecentUsedApp()).'&_u=sp');
				break;
			}

			default: {
				return true;
			}
		}
	}

	/*
	 * 获取所有问题分类
	 */
	public static function get_all_type(){
		return Dba::readAllOne('select type from service_problem where length(type)>1 group by type');
	}

	/*
		获取问题文案的内容
	*/
	public static function get_problems($option){
		$sql = 'select * from service_problem';

		if(!empty($option['sp_uid'])) {
			$where_arr[] = 'sp_uid = '.$option['sp_uid'];
		}
		if(!empty($option['type'])) {
			$where_arr[] = 'type ="'.addslashes($option['type']).'"';
		}elseif(!isset($option['houtai'])){
			$where_arr[] = 'type !="新闻资讯"';
		}
		if(!empty($option['key'])) {
			$where_arr[] = 'title like "%'.addslashes($option['key']).'%"';
		}

		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}
		$sql .=' order by sort desc, create_time desc';

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'SpMod::func_get_document');
	}

	/*
    	获取问题文案的内容
	*/
	public static function get_links($option){
		$sql = 'select * from links';

		if(!empty($option['key'])) {
			$where_arr[] = 'title like "%'.addslashes($option['key']).'%"';
		}
		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit']);
	}

	/*
    根据商品文案的uid来获取内容；
	*/
	public static function get_problem_by_uid($uid){
		$sql = 'select * from service_problem where uid = '.$uid;
		return Dba::readRowAssoc($sql,'SpMod::func_get_document');
	}

	/*
    添加或者编辑文章
	*/
	public static function add_or_edit_problem($document){
		if(!empty($document['uid'])){
			Dba::update('service_problem', $document, 'uid = '.$document['uid']);
		}else{
			unset($document['uid']);
			$document['create_time'] = isset($document['create_time'])?$document['create_time']:$_SERVER['REQUEST_TIME'];
			Dba::insert('service_problem',$document);
			$document['uid'] = Dba::insertID();
		}
		return $document['uid'];
	}

	/*
		删除文案
	*/
	public static function delete_problem($dids){
		if(!is_array($dids)){
			$dids = array($dids);
		}
		$sql = 'delete from service_problem where uid in ('.implode(',',$dids).')';
		$ret = Dba::write($sql);

		return $ret;
	}

	/*
	根据商品文案的uid来获取内容；
	*/
	public static function get_link_by_uid($uid){
		$sql = 'select * from links where uid = '.$uid;
		return Dba::readRowAssoc($sql);
	}

	/*
	添加或者编辑链接
	*/
	public static function add_or_edit_link($data){
		if(!empty($data['uid'])){
			Dba::update('links', $data, 'uid = '.$data['uid']);
		}else{
			unset($data['uid']);
			$data['create_time'] = isset($data['create_time'])?$data['create_time']:$_SERVER['REQUEST_TIME'];
			Dba::insert('links',$data);
			$data['uid'] = Dba::insertID();
		}
		return $data['uid'];
	}

	/*
    删除文案
	*/
	public static function delete_link($dids){
		if(!is_array($dids)){
			$dids = array($dids);
		}
		$sql = 'delete from links where uid in ('.implode(',',$dids).')';
		$ret = Dba::write($sql);

		return $ret;
	}

	/*
		获取商品文案的内容
	*/

	public static function get_documents($option){
		$sql = 'select * from service_document';

		if(!empty($option['sp_uid'])) {
			$where_arr[] = 'sp_uid = '.$option['sp_uid'];
		}
		if(!empty($option['key'])) {
			$where_arr[] = 'title like "%'.addslashes($option['key']).'%"';
		}


		if(!empty($where_arr)) {
			$sql .= ' where '.implode(' and ', $where_arr);
		}

		return Dba::readCountAndLimit($sql, $option['page'], $option['limit'], 'SpMod::func_get_document');
	}


	/*
		根据商品文案的uid来获取内容；
	*/
	public static function get_document_by_uid($document_uid){
		$sql = 'select * from service_document where uid = '.$document_uid;
		return Dba::readRowAssoc($sql,'SpMod::func_get_document');
	}

	/*
		根据标题获取文案内容；
	*/
	public static function get_document_by_title($title, $sp_uid){
		$sql = 'select * from service_document where sp_uid = '.$sp_uid.' && title like "%'.addslashes($title).'%"';
		return Dba::readRowAssoc($sql,'SpMod::func_get_document');
	}
	
	/*
		添加或者编辑文章
	*/
	public static function add_or_edit_document($document){
		if(!empty($document['uid'])){
			Dba::update('service_document', $document, 'uid = '.$document['uid'].' and sp_uid = '.$document['sp_uid']);
		}else{
			unset($document['uid']);
			$document['create_time'] = $_SERVER['REQUEST_TIME'];
			Dba::insert('service_document',$document);
			$document['uid'] = Dba::insertID();
		}

		return $document['uid'];
	}

	/*
		删除文案
	*/
	public static function delete_document($dids){
		if(!is_array($dids)){
			$dids = array($dids);
		}
		$sql = 'delete from service_document where uid in ('.implode(',',$dids).')';
		$ret = Dba::write($sql);

		return $ret;
	}

	/*
		关于商家
	*/
	public static function get_sp_about_link($sp_uid) {
		$key = 'about_'.$sp_uid;
		return $GLOBALS['arraydb_sys'][$key];
	}

	/*
		设置关于商家url
	*/
	public static function set_sp_about_link($url, $sp_uid) {
		$key = 'about_'.$sp_uid;
		return $GLOBALS['arraydb_sys'][$key] = $url;
	}

}

