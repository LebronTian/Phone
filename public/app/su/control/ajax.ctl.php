<?php

class AjaxCtl {
	/*
		检查账号是否注册
	*/
	public function check_account() {
		$sp_uid = AccountMod::require_sp_uid();
		$account = requestString('account', PATTERN_USER_NAME);
		if(!$account) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(SuMod::check_su_account($account, $sp_uid));
	}

	/*
		获取当前登录用户信息
	*/
	public function profile() {
		if(!($su_uid = AccountMod::has_su_login())) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}

		$ret = array('su' => AccountMod::get_current_service_user(),
			'groups' => SuGroupMod::get_user_groups($su_uid),
			'profile' => SuMod::get_su_profile($su_uid));
		outRight($ret);
	}
	/*
    获取用户信息
	*/
	public function get_su() {
		if(!($su_uid = requestInt('su_uid'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$ret = array('su' => AccountMod::get_service_user_by_uid($su_uid),
			'groups' => SuGroupMod::get_user_groups($su_uid),
			'profile' => SuMod::get_su_profile($su_uid));
		outRight($ret);
	}

	/*
		修改账号密码
	*/
	public function change_password() {
		if(!($su_uid = AccountMod::has_su_login())) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		$old = requestString('old', PATTERN_PASSWD);
		$new = requestString('new', PATTERN_PASSWD);
		//旧密码可能为空
		if(/*!$old || */!$new) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(SuMod::change_su_password($old, $new, $su_uid));
	}

	/*
		发送短信验证码
	*/
	public function mobilecode() {
		$sp_uid = AccountMod::require_sp_uid();
		if(!($phone = requestString('phone', PATTERN_MOBILE))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		/*
		if(!SafetyCodeMod::check_verify_code()) {
			outError();
		}
		*/

		if(!($code = SafetyCodeMod::get_a_mobile_code())) {
			outError(ERROR_OPERATION_TOO_FAST);
		}

		uct_use_app('sp');
		$sp = AccountMod::get_service_provider_by_uid($sp_uid);
		$name = $sp['name'] ? $sp['name'] : ($sp['account'] ? $sp['account'] : '快马加鞭');
		$msg = '['.$name.'] 您的验证码是 '.$code.' ,10分钟内有效.请勿将验证码告诉他人';
		$ret = SpMsgMod::sp_send_sms($phone, $msg, $sp_uid);

		//调试模式下返回验证码给客户端
		(defined('DEBUG_CHECK_CODE') && DEBUG_CHECK_CODE) && $ret = $code;

		//小程序接口
		if(!empty($_GET['_uct_token']))
		$ret = array('ret' => $ret, 'PHPSESSID' => session_id());

		outRight($ret);
	}

	/*
		忘记,重置密码
	*/
	public function resetpasswd() {
		$sp_uid = AccountMod::require_sp_uid();
		$account = requestString('account', PATTERN_ACCOUNT);
		$password = requestString('password', PATTERN_PASSWD);
		if(!$account || !$password) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		if(empty($_REQUEST['mobilecode'])) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(SuMod::reset_su_password($account, $password, $sp_uid));
	}

	/*
		绑定手机
	*/
	public function setphone() {
		$sp_uid = AccountMod::require_sp_uid();
		if(!$su_uid = AccountMod::has_su_login()) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if(!$phone = requestString('phone', PATTERN_PHONE)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		//信验证码
		if(!empty($_REQUEST['mobilecode']) && !SafetyCodeMod::check_mobile_code()) {
			outError();
		}

		//检查手机号码唯一
		if(($uid = Dba::readOne('select uid from service_user where sp_uid = '.$sp_uid.' && account = "'.addslashes($phone).'"'))
			&& ($uid != $su_uid)) {
			//outError(ERROR_OBJECT_ALREADY_EXIST);
			//不报错了， 直接把旧的手机覆盖掉
			Dba::write('update service_user set account = null where uid = '.$uid);

		}
		Dba::write('update service_user set account = "'.addslashes($phone).'" where uid = '.$su_uid);

		$ret = SuMod::update_su_profile($su_uid, array('phone' => $phone));
		outRight($ret);
	}


	/*
		注册
	*/
	public function register() {
		$sp_uid = AccountMod::require_sp_uid();
		$account = requestString('account', PATTERN_ACCOUNT);
		$password = requestString('password', PATTERN_PASSWD);
		$gender = requestInt('gender');
		if(!$account || !$password) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if(!($name = requestString('name', PATTERN_USER_NAME))) {
			$name = $account;
		}

		$su = array('account' => $account, 'passwd' => $password, 'name' => $name, 'sp_uid' => $sp_uid, 'gender' => $gender);
		if($from_su_uid = requestInt('from_su_uid')) {
			if(($fu = AccountMod::get_service_user_by_uid($from_su_uid)) &&
				$fu['sp_uid'] == $sp_uid) {
				$su['from_su_uid'] = $from_su_uid;
			}
		}

		if($from_su_account = requestString('from_su_account', PATTERN_ACCOUNT)) {
			if($from_su_uid = SuMod::check_su_account($from_su_account, $sp_uid)) {
				$su['from_su_uid'] = $from_su_uid;
			}
		}

		//商城模块的推荐用户的su_uid
		if(uct_class_exists('ShopMod', 'shop')){
			if(isset($_SESSION['parent_su_uid'])) {
				$GLOBALS['_TMP']['PARENT_SU_UID'] = $_SESSION['parent_su_uid'];
				Event::addHandler('AfterSuRegister',array('DistributionMod','onAfterSuRegister'));
			}
			if(($s_a_uid=AgentMod::require_agent()))
			{
				$GLOBALS['_TMP']['SHOP_AGENT_UID'] = $s_a_uid;
				Event::addHandler('AfterSuRegister',array('AgentMod','onAfterSuRegister'));
			}
		}

		if($ret = SuMod::do_su_register($su)) {
			$p = array();
			isset($_REQUEST['realname']) && $p['realname'] = requestString('realname', PATTERN_USER_NAME);
			isset($_REQUEST['email']) && $p['email'] = requestString('email', PATTERN_EMAIL);
			if(checkString($account, PATTERN_PHONE)) $p['phone'] = $account;
			isset($_REQUEST['province']) && $p['province'] = requestString('province', PATTERN_USER_NAME);
			isset($_REQUEST['city']) && $p['city'] = requestString('city', PATTERN_USER_NAME);
			isset($_REQUEST['town']) && $p['town'] = requestString('town', PATTERN_USER_NAME);
			isset($_REQUEST['address']) && $p['address'] = requestStringLen('address', 64);
			isset($_REQUEST['brief']) && $p['brief'] = requestString('brief');
			isset($_REQUEST['extra_info']) && $p['extra_info'] = requestString('extra_info');
			isset($_REQUEST['card_type']) && $p['card_type'] = requestInt('card_type');
			isset($_REQUEST['card_id']) && $p['card_id'] = requestString('card_id', PATTERN_NORMAL_STRING);
			if($p) {
				SuMod::update_su_profile($ret['uid'], $p);
			}
		}

		outRight($ret);
	}

	/*
		登陆
	*/
	public function login() {
		$account = requestString('account', PATTERN_USER_NAME);
		$password = requestString('password', PATTERN_PASSWD);
		if(!$account || !$password) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$sp_uid = AccountMod::require_sp_uid();
		$ret = SuMod::do_su_login($account, $password, $sp_uid);

		//小程序接口
		if($ret && !empty($_GET['_uct_token'])) {
			$ret['su_uid'] = $ret['uid'];
			$ret['PHPSESSID'] = session_id();
			$ret['open_id'] = Dba::readOne('select open_id from weixin_fans_xiaochengxu where su_uid = '.$ret['uid']);
		}
		outRight($ret);
	}

	/*
		设置用户地理位置
	*/
	public function set_user_geo() {
		$c['sp_uid'] = AccountMod::require_sp_uid();
		if(!($c['su_uid'] = AccountMod::has_su_login())) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		$c['lat'] = requestFloat('lat'); //纬度
		$c['lng'] = requestFloat('lng'); //经度

		outRight(SuMod::set_user_geo($c));
	}

	/*
		修改基本资料
	*/
	public function update_su() {
		if(!($uid = AccountMod::has_su_login())) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}

		isset($_REQUEST['gender']) && $p['gender'] = requestInt('gender');  //性别 1 男， 2女
		isset($_REQUEST['name']) && $p['name'] = requestString('name', PATTERN_USER_NAME);
		isset($_REQUEST['brithday']) && $p['birthday'] = requestInt('birthday'); //生日如 19910315

		isset($_REQUEST['avatar']) && $p['avatar'] = requestString('avatar', PATTERN_URL);
		isset($_REQUEST['from_su_uid']) && $p['from_su_uid'] = requestInt('from_su_uid');

		//$from_su 存在，并且不是自己
		if(!empty($p['from_su_uid']) && 
			(!($from_su = AccountMod::get_service_user_by_uid($p['from_su_uid'])) ||
			($p['from_su_uid'] == $uid))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		if(isset($p['from_su_uid'])) {
			$old_from_su_uid = Dba::readOne('select from_su_uid from service_user where uid = '.$uid);
			if(!empty($old_from_su_uid)){
				unset($p['from_su_uid']);
			}else{
				if(uct_class_exists('QrPoster_WxPlugMod', 'qrposter')){
					QrPoster_WxPlugMod::on_confirm_guide($uid, $p['from_su_uid']);
				}
			}
		}

		if(empty($p)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(SuMod::update_su($uid, $p));
	}

	/*
		修改更多资料
	*/
	public function update_su_profile() {
		if(!($uid = AccountMod::has_su_login())) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}

		isset($_REQUEST['realname']) && $p['realname'] = requestString('realname', PATTERN_USER_NAME);
		isset($_REQUEST['email']) && $p['email'] = requestString('email', PATTERN_EMAIL);
		isset($_REQUEST['phone']) && $p['phone'] = requestString('phone', PATTERN_PHONE);
		isset($_REQUEST['province']) && $p['province'] = requestString('province', PATTERN_USER_NAME);
		isset($_REQUEST['city']) && $p['city'] = requestString('city', PATTERN_USER_NAME);
		isset($_REQUEST['town']) && $p['town'] = requestString('town', PATTERN_USER_NAME);
		isset($_REQUEST['address']) && $p['address'] = requestStringLen('address', 64);
		isset($_REQUEST['brief']) && $p['brief'] = requestString('brief');
		isset($_REQUEST['extra_info']) && $p['extra_info'] = requestString('extra_info');
		isset($_REQUEST['card_type']) && $p['card_type'] = requestInt('card_type');
		isset($_REQUEST['card_id']) && $p['card_id'] = requestString('card_id', PATTERN_NORMAL_STRING);

		//信验证码
		if(!empty($_REQUEST['mobilecode']) && !SafetyCodeMod::check_mobile_code()) {
			outError();
		}

		if(empty($p)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(SuMod::update_su_profile($uid, $p));
	}
	/*
    修改姓名
	*/
	public function update_su_realname() {
		if(!($uid = AccountMod::has_su_login())) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		isset($_REQUEST['realname']) && $p['realname'] = requestString('realname', PATTERN_USER_NAME);

		if(empty($p)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(SuMod::update_su_profile($uid, $p));
	}

	/*
		获取用户积分
	*/
	public function point() {
		if(!($su_uid = AccountMod::has_su_login())) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}

		outRight(SuPointMod::get_user_points_by_su_uid($su_uid));
	}


	/*
		获取用户积分明细列表
	*/
	public function get_user_point_list() {
		if(!($option['su_uid'] = AccountMod::has_su_login())) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}

		$option['type'] = requestInt('type');
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);

		outRight(SuPointMod::get_user_point_list($option));
	}

	/*
		获取用户现金账户明细列表
	*/
	public function get_user_cash_list() {
		if(!($option['su_uid'] = AccountMod::has_su_login())) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}

		$option['type'] = requestInt('type');
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);

		outRight(SuPointMod::get_user_cash_list($option));
	}

	/*
		余额充值
	*/
	public function make_sucharge_order() {
		if(!($su_uid = AccountMod::has_su_login())) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}

		//充值金额，单位为分
		if(!$charge_price = requestInt('charge_price')) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		//充1份
		if(!$quantity = requestInt('quantity', 1)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		//0为充值，否则为买会员（分组）
		$pay_vip = requestInt('pay_vip');

		$order = array(
			'sp_uid' => AccountMod::require_sp_uid(),
			'su_uid' => $su_uid,
			'paid_fee' => $charge_price * $quantity,
			'charge_uid' => 0,
			'charge' => array(
				'charge_price' => $charge_price,
				'quantity' => $quantity,
				'uid' => 0,
				'paid_price' => $charge_price,
				'pay_vip' => $pay_vip,
			)
		);

		outRight(SuChargeMod::make_a_sucharge_order($order));
	}

	/*
		取消订单
	*/
	public function cancel_order()
	{
		if (!($su_uid = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if (!($uid = requestInt('uid')) ||
			!($o = SuChargeMod::get_sucharge_order_by_uid($uid)) ||
			!($o['su_uid'] == $su_uid)
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		outRight(SuChargeMod::do_cancel_order($o));
	}

	/*
		删除订单
	*/
	public function delete_order()
	{
		if (!($su_uid = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if (!($uid = requestInt('uid')) ||
			!($o = SuChargeMod::get_sucharge_order_by_uid($uid)) ||
			!($o['su_uid'] == $su_uid)
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(SuChargeMod::delete_order($o));
	}

	/*
		用户充值订单列表
	*/
	public function orders()
	{
		if (!($su_uid = AccountMod::has_su_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}

		$option['status']  = requestInt('status');
		$option['sp_uid'] = AccountMod::require_sp_uid();
		$option['su_uid'] = $su_uid;
		$option['sort']    = requestInt('sort');
		$option['page']    = requestInt('page');
		$option['limit']   = requestInt('limit', 10);
		$option['key']     = requestString('key', PATTERN_SEARCH_KEY);

		outRight(SuChargeMod::get_sucharge_order_order_list($option));
	}

	/*
		重置安全密码
	*/
	public function reset_safety_passwd() {
		if(!AccountMod::has_su_login()) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if(!$new = requestString('new', PATTERN_PASSWD)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(SafetyCodeMod::set_user_safety_passwd($new));
	}

	/*
		设置安全密码
	*/
	public function set_safety_passwd() {
		if(!AccountMod::has_su_login()) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if(!$safetypasswd = requestString('safetypasswd', PATTERN_PASSWD)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		unset($_REQUEST['safetypasswd']);

		if(!SafetyCodeMod::check_verify_code() ||
			!SafetyCodeMod::check_mobile_code()) {
			outError();
		}

		outRight(SafetyCodeMod::set_user_safety_passwd($safetypasswd));
	}

	// public function get_delivery_order($su_uid){

	// 	$option = array('su_uid' => $su_uid);
	// 	outRight(DeliveryMod::get_delivery($su_uid));

	// }

	//根据7位推荐人uid获取推荐人信息
	public function get_service_user_by_recommend_uid(){
		$uid = requestInt('uid');
		$info = SuMod::get_service_user_by_recommend_uid($uid);
		if(empty($info)){
			$info = 0;
		}
	   outRight($info);
	}

	/*
	获取我的团队
	*/
	public function get_sub_user_list() {
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

		$ret = AccountMod::get_service_user_list($option);

		outRight($ret);
	}

	/*
	 * 获取充值优惠规则
	 */
	public function get_cash_rules(){
		$sp_uid  = AccountMod::get_current_service_provider('uid');

		$data = SuPointMod::get_cash_rule($sp_uid);
		if(!empty($data)){
			if($data['status'] == 0){
				$data['rule'] = array();
			}
			foreach($data['rule'] as $k=> $da){
				if(!empty($da['2'])){
					//前端不用
					#$data['rule'][$k]['group'] = SuGroupMod::get_group_by_uid($da['2']);
				}
			}
		}

//		$params = array('data' => $data);
		outRight($data);
	}

	/*
	 * 保存form_uid 用于小程序模板消息，有效期7天
	 */
	public function add_form_id(){
		if(!$it['su_uid'] = AccountMod::has_su_login()) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		if(!($it['form_id'] = requestString('form_id', PATTERN_NORMAL_STRING))){
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$it['public_uid'] = WeixinMod::get_current_weixin_public('uid');

		outRight(XiaochengxuMod::save_form_id($it));
	}

	/*
	 * 提取能使用的form_id
	 */
	public function get_form_id(){
		if(!$su_uid = AccountMod::has_su_login()) {
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		//$public_uid = WeixinMod::get_current_weixin_public('uid');

		outRight(XiaochengxuMod::get_a_form_id($su_uid));
	}

}

