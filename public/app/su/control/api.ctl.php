<?php

class ApiCtl {
	/*
		创建编辑分组
	*/
	public function addgroup()
	{
		isset($_REQUEST['name']) && $g['name'] = requestString('name', PATTERN_USER_NAME);
		isset($_REQUEST['group_type']) && $g['group_type'] = requestInt('group_type');
		if (empty($g))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		isset($_REQUEST['uid']) && $g['uid'] = requestInt('uid');
		$g['sp_uid'] = AccountMod::get_current_service_provider('uid');
		
		outRight(SuGroupMod::add_or_edit_group($g));
	}

	/*
		删除分组 
	*/
	public function delgroup()
	{
		if (!($uids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$sp_uid = AccountMod::get_current_service_provider('uid');
		outRight(SuGroupMod::delete_groups($uids, $sp_uid));
	}
	/*
		添加用户到分组, 一个用户可以添加到多个分组
	*/
	public function add_user_to_group()
	{
		if (!($uids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (!($gid = requestInt('gid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$sp_uid = AccountMod::get_current_service_provider('uid');
		outRight(SuGroupMod::add_user_to_group($uids, $gid, $sp_uid));
	}

	/*
		移动用户到分组
	*/
	public function move_user_to_group()
	{
		if (!($uids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (!($gid = requestInt('gid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$sp_uid = AccountMod::get_current_service_provider('uid');
		outRight(SuGroupMod::move_user_to_group($uids, $gid, $sp_uid));
	}

	/*
		把用户从分组删除
	*/
	public function delete_user_from_group()
	{
		$sp_uid = AccountMod::get_current_service_provider('uid');
		if (!($uids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (!($gid = requestInt('gid')))
		{
			//全部删除
			$gids = Dba::readAllOne('select g_uid from groups_users where su_uid in ('.implode(',', $uids).')');
			if(!$gids) {
				outError(ERROR_INVALID_REQUEST_PARAM);
			}
			$ret = 0;
			foreach($gids as $gid) {
				$ret += SuGroupMod::delete_user_from_group($uids, $gid, $sp_uid);
			}
			outRight($ret);
		}

		outRight(SuGroupMod::delete_user_from_group($uids, $gid, $sp_uid));
	}

	/*
		创建编辑微信群内
	*/
	public function addwechatgroup()
	{
		isset($_REQUEST['name']) && $g['name'] = requestString('name', PATTERN_USER_NAME);
		isset($_REQUEST['group_type']) && $g['group_type'] = requestInt('group_type');
		isset($_REQUEST['wx_group_id']) && $g['wx_group_id'] = requestString('wx_group_id');
		if (empty($g))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		isset($_REQUEST['uid']) && $g['uid'] = requestInt('uid');
		$g['sp_uid'] = AccountMod::get_current_service_provider('uid');
		
		outRight(WechatGroupMod::add_or_edit_group($g));
	}

	/*
		删除微信群
	*/
	public function delwechatgroup()
	{
		if (!($uids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$sp_uid = AccountMod::get_current_service_provider('uid');
		outRight(WechatGroupMod::delete_groups($uids, $sp_uid));
	}
	/*
		添加用户到微信群, 一个用户可以添加到多个群
	*/
	public function add_user_to_wechatgroup()
	{
		if (!($uids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (!($gid = requestInt('gid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$sp_uid = AccountMod::get_current_service_provider('uid');
		outRight(WechatGroupMod::add_user_to_group($uids, $gid, $sp_uid));
	}

	/*
		移动用户到微信群
	*/
	public function move_user_to_wechatgroup()
	{
		if (!($uids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (!($gid = requestInt('gid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$sp_uid = AccountMod::get_current_service_provider('uid');
		outRight(WechatGroupMod::move_user_to_group($uids, $gid, $sp_uid));
	}

	/*
		把用户从群删除
	*/
	public function delete_user_from_wechatgroup()
	{
		if (!($uids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (!($gid = requestInt('gid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$sp_uid = AccountMod::get_current_service_provider('uid');
		outRight(WechatGroupMod::delete_user_from_group($uids, $gid, $sp_uid));
	}

	/*
		手机绑定标记
	*/
	public function remark_mobile()
	{
		if (!($uids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$sp_remark = requestInt('sp_remark');

		$sp_uid = AccountMod::get_current_service_provider('uid');
		outRight(SuGroupMod::remark_oauth_mobile($sp_remark, $uids, $sp_uid));
	}

	/*
		获取用户列表
	*/
	public function users()
	{
		if (!($option['sp_uid'] = AccountMod::has_sp_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
		$option['g_uid']   = requestInt('g_uid',0);
		$option['key']   = requestString('key', PATTERN_SEARCH_KEY);
		$option['page']  = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
		isset($_REQUEST['public_uid']) && $option['public_uid'] = requestInt('public_uid');

		outRight(AccountMod::get_service_user_list($option));
	}
	
	/*
		用户审核
	*/
	public function review_user()
	{
		if (!($uids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$status = requestInt('status');
		
		$sp_uid = AccountMod::get_current_service_provider('uid');
		outRight(SuMod::review_user($uids, $status, $sp_uid));
	}


	/*
		获取用户资料
	*/
	public function get_su_profile()
	{
		$sp_uid = AccountMod::get_current_service_provider('uid');
		if (!($uid = requestint('uid')) || !($su = AccountMod::get_service_user_by_uid($uid)) || !($sp_uid == $su['sp_uid']))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);

			return false;
		}
		outRight(SuMod::get_su_profile($uid));
	}

	// public_uid 为空 则 获取当前公众号 微信分组     15min 自动刷新 立刻刷新调用refresh_weixin_all_group
	//            不为空 则取对应公众号 微信分组
	public function weixin_get_all_group()
	{
		$sp_uid = AccountMod::get_current_service_provider('uid');
		if (($public_uid = requestInt('public_uid')) && !($public = WeixinMod::get_weixin_public_by_uid($public_uid)) && !($public['sp_uid'] == $sp_uid))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);

			return false;
		}
		outRight(WeixinMod::weixin_get_all_group($public_uid));
	}

	//刷新 微信分组
	public function refresh_weixin_all_group()
	{
		$sp_uid = AccountMod::get_current_service_provider('uid');
		if (($public_uid = requestInt('public_uid')) && !($public = WeixinMod::get_weixin_public_by_uid($public_uid)) && !($public['sp_uid'] == $sp_uid))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);

			return false;
		}
		unset($GLOBALS[ 'arraydb_weixin_public' ][ 'public_groups_' . $public_uid ]);
		outRight(WeixinMod::weixin_get_all_group($public_uid));
	}

	public function weixin_fans()
	{
		if (!($option['sp_uid'] = AccountMod::has_sp_login()))
		{
			outError(ERROR_USER_HAS_NOT_LOGIN);
		}
        $option['key']   = requestString('key', PATTERN_SEARCH_KEY);
		$option['page']  = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
		isset($_REQUEST['public_uid']) && $option['public_uid'] = requestInt('public_uid');
		outRight(AccountMod::get_weixin_fans_list($option));

	}

	/*
		会员余额充值
	*/
	public function make_sucharge_order() {
		if(!($su_uid = requestInt('su_uid'))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		//充值金额，单位为分
		if(!$charge_price = requestInt('charge_price')) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		//充1份
		if(!$quantity = requestInt('quantity', 1)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$order = array(
			'sp_uid' => AccountMod::get_current_service_provider('uid'),
			'su_uid' => $su_uid,
			'paid_fee' => $charge_price * $quantity,
			'charge_uid' => 0,
			'charge' => array(
				'charge_price' => $charge_price,
				'quantity' => $quantity,
				'uid' => 0,
				'paid_price' => $charge_price,
			)
		);

		outRight(SuChargeMod::make_a_sucharge_order($order));
	}

	/*
		开启/关闭注册功能
	*/
	public function disable_register() {
		$sp_uid = AccountMod::get_current_service_provider('uid');
		$disable = requestInt('disable'); //0 开启， 1关闭

		outRight(SuMod::disable_register($sp_uid, $disable));
	}

	/*
		批量注册	
		@param $su = array('account' =>   //登陆账号 可为空
							'passwd' => //密码
						)
	*/
	public function batregister() {
		$account = requestStringArray('account', PATTERN_ACCOUNT);
		$passwd = requestString('passwd', PATTERN_PASSWD);
		$count = max(1, min(100, requestInt('count', 1)));
		$sp_uid = AccountMod::get_current_service_provider('uid');
		$tpl = array('sp_uid' => $sp_uid, 'passwd' => md5($passwd));

		isset($_REQUEST['from_su_uid']) && $tpl['from_su_uid'] = requestInt('from_su_uid');

		outRight(SuMod::bat_register($account, $count, $tpl));
	}

	//微信公众号代理网页oauth2授权设置
	public function wxlogin() {
		$cfg = array(	
			'enabled'  => requestInt('enabled'),	
		);

		if($cfg['enabled']) {
			$origin_id = SYS_WX_ORIGINID;
			$public_uid = Dba::readOne('select uid from weixin_public where origin_id = "'.$origin_id.'"');
			if(!$public_uid) {
				exit('系统内部错误!');
			}
		
			$cfg['public_uid'] = $public_uid;
		}

		$sp_uid = AccountMod::get_current_service_provider('uid');
		SuWxLoginMod::set_proxy_wxlogin_cfg($cfg, $sp_uid);
		outRight('ok');	
	}

	public function set_cashnotice() {
		$cfg = requestKvJson('cfg');
		$cfg['public_uid'] = WeixinMod::get_current_weixin_public('uid');

		$sp_uid = AccountMod::get_current_service_provider('uid');
		SuPointMod::set_cashnotice_cfg($cfg, $sp_uid);
		outRight('ok');
	}

	/*
		设置来源用户
	*/
	public function set_from_su_uid() {
		$sp_uid = AccountMod::get_current_service_provider('uid');

		if(!($uid = requestInt('uid')) ||
			!($su = AccountMod::get_service_user_by_uid($uid)) ||
			$su['sp_uid'] != $sp_uid) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if(!($from_uid = requestInt('from_uid')) ||
			!($from_su = AccountMod::get_service_user_by_uid($from_uid)) ||
			($from_su['sp_uid'] != $sp_uid) ||
			($from_uid == $uid)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		//只能改1次
		if($su['from_su_uid'] || ($uid == $from_uid)) {
			#if(empty($_REQUEST['_d']))
			#outError(ERROR_BAD_STATUS);
		}
		
		//Dba::write('update service_user set from_su_uid = '.$from_uid.' where uid = '.$uid);
		SuMod::update_su($uid, array('from_su_uid' => $from_uid));
		//支持一下三级分销的用户体系实现方式
		if(WeixinPlugMod::is_plugin_installed_to_sp_uid('shop', $sp_uid)) {
			uct_use_app('shop');
			$GLOBALS['_TMP']['PARENT_SU_UID'] = $from_uid;
			DistributionMod::onAfterSuRegister($su);
		}

		outRight('ok');
	}

	/*
		修改用户基本资料
	*/
	public function update_su() {
		$sp_uid = AccountMod::get_current_service_provider('uid');
		if(!($uid = requestInt('uid')) ||
			!($su = AccountMod::get_service_user_by_uid($uid)) ||
			$su['sp_uid'] != $sp_uid) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		isset($_REQUEST['gender']) && $p['gender'] = requestInt('gender');  //性别 1 男， 2女
		isset($_REQUEST['name']) && $p['name'] = requestString('name', PATTERN_USER_NAME); 
		isset($_REQUEST['brithday']) && $p['birthday'] = requestInt('birthday'); //生日如 19910315 
		isset($_REQUEST['avatar']) && $p['avatar'] = requestString('avatar', PATTERN_URL); 
		if(empty($p)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
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
		$sp_uid = AccountMod::get_current_service_provider('uid');
		if(!($uid = requestInt('uid')) ||
			!($su = AccountMod::get_service_user_by_uid($uid)) ||
			$su['sp_uid'] != $sp_uid) {
			outError(ERROR_INVALID_REQUEST_PARAM);
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


		if(empty($p)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(SuMod::update_su_profile($uid, $p));
	}

	/*
		根据微信信息刷新用户昵称头像
	*/
	public function update_su_info() {
		$sp_uid = AccountMod::get_current_service_provider('uid');

		if(!($uid = requestInt('uid')) ||
			!($su = AccountMod::get_service_user_by_uid($uid)) ||
			$su['sp_uid'] != $sp_uid) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$force = requestInt('force', 1);

		outRight(SuMod::update_su_by_weixin_info($uid, $force));
	}

	/*
		删除用户	
	*/
	public function delete_user() {
		$sp_uid = AccountMod::get_current_service_provider('uid');

		if(!($uid = requestInt('uid')) ||
			!($su = AccountMod::get_service_user_by_uid($uid)) ||
			$su['sp_uid'] != $sp_uid) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(SuMod::delete_user($uid, $sp_uid));
	}

	/*
		会员赠送积分
	*/
	public function send_point() {
		if(!($su_uid = requestInt('su_uid')) || !($su = AccountMod::get_service_user_by_uid($su_uid)) ||
			$su['sp_uid'] != AccountMod::get_current_service_provider('uid')) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		//赠送积分
		if(!$point = requestInt('point')) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$brief = requestString('brief');
		$record = array('su_uid' => $su_uid, 'point' => abs($point), 'info' => $brief);

		$ret = $point > 0 ? SuPointMod::increase_user_point($record) : 
							SuPointMod::decrease_user_point($record);
		outRight($ret);
	}

	/*
		会员赠送余额
	*/
	public function send_cash() {
		if(!($su_uid = requestInt('su_uid')) || !($su = AccountMod::get_service_user_by_uid($su_uid)) ||
			$su['sp_uid'] != AccountMod::get_current_service_provider('uid')) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		//赠送积分
		if(!$cash = requestInt('cash')) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$brief = requestString('brief','','管理员操作');
		$record = array('su_uid' => $su_uid, 'cash' => abs($cash), 'info' => $brief);

		$ret = $cash > 0 ? SuPointMod::increase_user_cash($record) : 
							SuPointMod::decrease_user_cash($record);
		outRight($ret);
	}

	public function synwxfans()
    {
        $quick = requestInt('quick');
        $sp_uid = AccountMod::get_current_service_provider('uid');
        if(!empty($GLOBALS['arraydb_job']['syn_fans_'.$sp_uid])){
            outError(ERROR_BAD_STATUS);
        }else
        {
//            $a = new Su_synwxuserJob();
//            $ret  = $a->perform($sp_uid,$quick);
            $ret  = Queue::add_job('Su_synwxuserJob', array($sp_uid,$quick));
            $GLOBALS['arraydb_job']['syn_fans_'.$sp_uid] = array('value'=>$ret,'expire'=> 60*60*24);
            outRight(0);
        }
    }

	/*
	 * 优惠设置
	 */
	public function setcashrule()
	{
		//rule[[0 =>'',1 =>'',2 => '']] 0为支付价格 1为赠送 2为分组信息
		$option['rule'] = requestStringArray('rule');
		isset($_REQUEST['status']) && $option['status'] = requestInt('status');
		isset($_REQUEST['cgroup']) && $option['cgroup'] = requestInt('cgroup');

		if(empty($option)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['uid']) && $option['uid'] = requestInt('uid');
		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');

		outRight(SuPointMod::set_cash_rule($option));
	}

}

