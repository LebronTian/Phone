<?php

class ApiCtl {
	/*
		检查邀请码是否可用
	*/
	public function check_invite_code()
	{
		if (!($invitecode = requestString('invitecode', PATTERN_TOKEN)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight((bool)SpInviteMod::check_invite_code($invitecode, false));
	}

	/*
		注册7天试用
	*/
	public function register_test() {
		$ic = SpinviteMod::add_a_test_invite_code();
		$_REQUEST['invitecode'] = $ic['invite_code'];
		return $this->register_invite();
	}

	/*
		邀请码注册
	*/
	public function register_invite()
	{
		$account    = requestString('account', PATTERN_PHONE);
		$password   = requestString('password', PATTERN_PASSWD);
		$invitecode = requestString('invitecode', PATTERN_TOKEN);
		if (!$account || !$password || !$invitecode)
		{
			#var_export($invitecode);
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$name = requestString('name', PATTERN_USER_NAME);
		$sp   = array(
			'account'    => $account,
			'passwd'     => $password,
			'name'       => $name,
			'invitecode' => $invitecode,
		);
		if ($ret = SpMod::do_sp_register($sp))
		{
			$p = array();
			isset($_REQUEST['email']) && $p['email'] = requestString('email', PATTERN_EMAIL);
			//isset($_REQUEST['phone']) && $p['phone'] = requestString('phone', PATTERN_PHONE);
			$p['phone'] = $account;
			isset($_REQUEST['type']) && $p['type'] = requestInt('type');
			isset($_REQUEST['fullname']) && $p['fullname'] = requestString('fullname', PATTERN_FILE_NAME);
			if ($p)
			{
				SpMod::update_sp_profile($ret['uid'], $p);
			}
		}
		
		//todo 发短信通知一下运营人员  
		outRight($ret);
	}
	
	/*
	检查账号是否注册
	*/
	public function check_account()
	{
		$account = requestString('account', PATTERN_USER_NAME);
		if (!$account)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		outRight(SpMod::check_sp_account($account));
	}

	/*
	修改账号密码
	*/
	public function change_password()
	{
		$old = requestString('old', PATTERN_PASSWD);
		$new = requestString('new', PATTERN_PASSWD);
		//旧密码可能为空
		if ( /*!$old || */
		!$new
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		//子账号修改密码 
		if (AccountMod::has_subsp_login())
		{
			uct_use_app('subsp');
			outRight(SubspMod::change_subsp_password($old, $new));
		}
		else
		{
			outRight(SpMod::change_sp_password($old, $new));
		}
	}
	/*
	修改账号密码
	*/
	public function change_name()
	{
		if(!($uid = AccountMod::get_current_service_provider('uid'))) {
			setLastError(ERROR_DBG_STEP_1);
			return false;
		}
		$option['account'] = requestString('account');
		outRight(SpMod::update_sp($uid,$option));
	}
	
	/*
	 uctoo系统 发送短信验证码 
	*/
	public function mobilecode()
	{
		if (!($phone = requestString('phone', PATTERN_MOBILE)))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		/*
		if ( !SafetyCodeMod::check_verify_code() ) {
			outError();
		}
		*/
		
		if (!($code = SafetyCodeMod::get_a_mobile_code()))
		{
			outError(ERROR_OPERATION_TOO_FAST);
		}
		
		$msg = '【微信小程序】 您的验证码是 ' . $code . ' ,10分钟内有效.请勿将验证码告诉他人';
		$ret = SpMsgMod::sp_send_sms($phone, $msg, 0);
		
		//调试模式下返回验证码给客户端
		(defined('DEBUG_CHECK_CODE') && DEBUG_CHECK_CODE) && $ret = $code;
		outRight($ret);
	}
	
	/*
	通过手机 重置密码
	*/
	public function reset_password()
	{
		$phone    = requestString('phone', PATTERN_PHONE);
		$password = requestString('password', PATTERN_PASSWD);
		if (!$phone || !$password)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$_REQUEST['account'] = $phone;
		
		outRight(SpMod::reset_sp_password($phone, $password));
	}
	
	/*
	修改插件触发关键字
	*/
	public function set_plugin_keywords()
	{
		$uid = requestInt('uid');
		if (!$uid)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (!WeixinPlugMod::is_plugin_installed($uid))
		{
			outError(ERROR_DBG_STEP_1);
		}
		
		if (!empty($_REQUEST['is_string']))
		{
			$keywords = requestString('keywords');
		}
		else
		{
			$keywords = requestStringArray('keywords', PATTERN_USER_NAME);
			$keywords = array_slice($keywords, 0, 5);
			$keywords = implode(',', $keywords);
		}
		
		$update = array(
			'keywords' => $keywords,
		);
		outRight(WeixinPlugMod::update_weixin_public_plugin_installed($uid, $update));
	}
	
	/*
	禁用/启用插件
	*/
	public function enable_plugin()
	{
		$uid = requestInt('uid');
		if (!$uid)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (!($p = WeixinPlugMod::is_plugin_installed($uid)))
		{
			outError(ERROR_DBG_STEP_1);
		}
		
		$update = array(
			'enabled' => $p['enabled'] > 0 ? 0 : 2,
		);
		outRight(WeixinPlugMod::update_weixin_public_plugin_installed($uid, $update));
	}
	
	public function add_plugin()
	{
	}
	
	public function del_plugin()
	{
		$uid = requestInt('uid');
		if (!$uid)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		outRight(WeixinPlugMod::del_weixin_public_plugi($uid));
	}
	
	public function add_public()
	{
		$public = array();
		
		isset($_REQUEST['origin_id']) && $public['origin_id'] = requestString('origin_id', PATTERN_NORMAL_STRING);
		isset($_REQUEST['app_id']) && $public['app_id'] = requestString('app_id', PATTERN_NORMAL_STRING);
		isset($_REQUEST['app_secret']) && $public['app_secret'] = requestString('app_secret', PATTERN_NORMAL_STRING);
		isset($_REQUEST['aes_key']) && $public['aes_key'] = requestString('aes_key', PATTERN_NORMAL_STRING);
		isset($_REQUEST['msg_mode']) && $public['msg_mode'] = requestInt('msg_mode');
		isset($_REQUEST['public_name']) && $public['public_name'] = requestString('public_name', PATTERN_USER_NAME);
		isset($_REQUEST['public_type']) && $public['public_type'] = requestInt('public_type');
		isset($_REQUEST['weixin_name']) && $public['weixin_name'] = requestString('weixin_name', PATTERN_USER_NAME);
		isset($_REQUEST['weixin_brief']) && $public['weixin_brief'] = requestStringLen('weixin_brief', 512);
		isset($_REQUEST['qrcode_url']) && $public['qrcode_url'] = requestString('qrcode_url', PATTERN_URL);
		isset($_REQUEST['head_img']) && $public['head_img'] = requestString('head_img', PATTERN_URL);
		if (!count($public))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		isset($_REQUEST['uid']) && $public['uid'] = requestInt('uid');
		if($public_uid = WeixinMod::add_or_edit_weixin_public($public)) {
			if(isset($_REQUEST['biz']) && ($biz = requestString('biz', '/^([\w\._\-=]{6,24})$/'))) {
				WeixinMod::set_weixin_public_biz($biz, $public_uid);
			}
		}

		outRight($public_uid);
	}
	
	public function add_fake_public()
	{
		outRight(WeixinMod::add_fake_weixin_public());
	}
	
	/*
		设置公众号biz参数	
	*/
	public function set_biz() {
		if(!($uid = requestInt('uid')) ||
			!($public = WeixinMod::get_weixin_public_by_uid($uid)) ||
			$public['sp_uid'] != AccountMod::get_current_service_provider('uid')) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$biz = requestString('biz', '/^([\w\._\-=]{6,24})$/');
		outRight(WeixinMod::set_weixin_public_biz($biz, $public['uid']));
	}

	/*
	删除公众号
	仅供调试使用,不应该有删除功能
	*/
	public function del_public()
	{
		$uid = requestInt('uid');
		if (!$uid)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		outRight(WeixinMod::delete_weixin_public($uid));
	}
	
	/*
	添加或编辑微信素材
	content = [{Title:Title, Description:Description, PicUrl:PicUrl, Url:Url}, ...]
	*/
	public function add_media()
	{
		$media['content'] = requestString('content');
		switch ($media['media_type'] = requestInt('media_type', 1))
		{
			case 1:
			{
				$media['content'] = html_entity_decode($media['content']);
				break;
			}
			case 2:
			case 3:
			{
				$as = json_decode($media['content'], true);
				if (!$as || !is_array($as))
				{
					outError(ERROR_INVALID_REQUEST_PARAM);
				}
				$media['content'] = array();
				foreach ($as as $a)
				{
					$i          = array();
					$i['Title'] = isset($a['Title']) ? checkString($a['Title']) : '';
					//$i['Author'] = isset($a['Author']) ? checkString($a['Author']) : '';//yhc
					$i['Description'] = isset($a['Description']) ? checkString($a['Description']) : '';
					$i['PicUrl']      = isset($a['PicUrl']) ? checkString($a['PicUrl'], PATTERN_URL) : '';
					$i['Url']         = isset($a['Url']) ? checkString($a['Url'], PATTERN_URL) : '';
					
					$media['content'][] = $i;
				}
				break;
			}
			
			default:
				outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		if (empty($media['content']))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		isset($_REQUEST['uid']) && $media['uid'] = requestInt('uid');
		$media['sp_uid'] = AccountMod::get_current_service_provider('uid');
		
		outRight(WeixinMediaMod::add_or_edit_weixin_media($media));
	}
	
	/*
	获取服务商素材列表
	*/
	public function sp_media_list()
	{
		$option['media_type'] = requestInt('media_type');
		$option['page']       = requestInt('page');
		$option['limit']      = requestInt('limit', 10);
		$option['sp_uid']     = AccountMod::get_current_service_provider('uid');
		
		return outRight(WeixinMediaMod::get_weixin_media($option));
	}
	
	public function del_media()
	{
		$uids = requestIntArray('uids');
		if (!$uids)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		outRight(WeixinMediaMod::delete_weixin_media($uids));
	}
	
	/*
	商户消息通知 标记为已读,未读
	$time =0 标记为未读, > 0 标记为已读
	*/
	public function read_sp_msg()
	{
		$uids = requestIntArray('uids');
		if (!$uids)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$time = requestInt('time');
		
		outRight(SpMsgMod::read_sp_msg($time, $uids));
	}
	
	/*
	删除商户消息通知
	*/
	public function del_sp_msg()
	{
		$uids = requestIntArray('uids');
		if (!$uids)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		outRight(SpMsgMod::delete_sp_msg($uids));
	}
	
	/*
	取消服务订单
	*/
	public function cancel_service_order()
	{
		if (!($uid = requestInt('uid')) || !($o = SpServiceMod::get_service_order_by_uid($uid)) || ($o['sp_uid'] != AccountMod::get_current_service_provider('uid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
//		Event::addHandler('AfterCancelServiceOrder', array('SpServiceMod', 'onAfterCancelServiceOrder'));
		outRight(SpServiceMod::do_cancle_order($o));
	}
	
	/*
	删除服务订单
	*/
	public function delete_service_order()
	{
		if (!($uid = requestInt('uid')) || !($o = SpServiceMod::get_service_order_by_uid($uid)) || ($o['sp_uid'] != AccountMod::get_current_service_provider('uid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(SpServiceMod::delete_order($o));
	}
	
	/*
	服务订单收货
	*/
	public function receipt_service_order()
	{
		if (!($uid = requestInt('uid')) || !($o = SpServiceMod::get_service_order_by_uid($uid)) || ($o['sp_uid'] != AccountMod::get_current_service_provider('uid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		outRight(SpServiceMod::do_receipt_order($o));
	}
	
	/*
	根据公众号uid获取详细信息
	*/
	public function get_weixin_public_info()
	{
		if (!($uid = requestInt('uid')) || !($uid = WeixinMod::get_current_weixin_public('uid')) || !($wx = WeixinMod::get_weixin_public_by_uid($uid)) || $wx['sp_uid'] != AccountMod::get_current_service_provider('uid'))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		WeixinMod::set_current_weixin_public($wx);
		$wx['url']   = WeixinMod::get_tencent_callback_url();
		$wx['token'] = WeixinMod::get_tencent_token();
		
		outRight($wx);
	}
	
	/*
	修改登陆时默认进入的公众号
	*/
	public function change_default_weixin()
	{
		if (!($uid = requestInt('uid')) || !($wx = WeixinMod::get_weixin_public_by_uid($uid)) ||
			$wx['sp_uid'] != AccountMod::get_current_service_provider('uid')
		)
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if (empty($wx['uct_token']))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		//子账号
		if ($subsp_uid = AccountMod::has_subsp_login())
		{
			if (($uct_tokens = Dba::readOne('select uct_tokens from sub_sp where uid = ' . $subsp_uid)) &&
				false === strpos($uct_tokens, $wx['uct_token'])
			)
			{
				outError(ERROR_INVALID_REQUEST_PARAM);
			}
			else
			{
				$sql = 'update sub_sp set uct_token ="' . $wx['uct_token'] . '" where uid =' . $subsp_uid;
			}
		}
		else
		{
			$sql = 'update service_provider set uct_token ="' . $wx['uct_token'] . '" where uid =' . $wx['sp_uid'];
		}
		outRight(Dba::write($sql));
	}
	
	/*
	更换公众号
	*/
	public function change_weixin()
	{
		if (!($uid = requestInt('uid')) || !($wx = WeixinMod::get_weixin_public_by_uid($uid)) || $wx['sp_uid'] != AccountMod::get_current_service_provider('uid'))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		// WeixinMod::set_current_weixin_public($wx['uct_token']);
		$_SESSION['uct_token'] = $wx['uct_token'];

		outRight(true);
	}

	
	/*
		增加和编辑方案
	*/
	public function add_document()
	{

		isset($_REQUEST['title']) && $document['title'] = requestString('title');
		isset($_REQUEST['content']) && $document['content'] = requestString('content');
		isset($_REQUEST['video_link']) && $document['video_link'] = requestString('video_link',PATTERN_URL);
		isset($_REQUEST['uid']) && $document['uid'] = requestInt('uid');

		$document['sp_uid'] = AccountMod::get_current_service_provider('uid');

		if (empty($document))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(SpMod::add_or_edit_document($document));
	}

	/*
		删除相应的方案
	*/
	public function delete_document()
	{

		if (!($dids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}


		outRight(SpMod::delete_document($dids));
	}

	public function get_document_list(){
		$option['page'] = requestInt('page');
		$option['limit'] = requestInt('limit', 10);
		$option['sp_uid'] = AccountMod::get_current_service_provider('uid');

		outRight(SpMod::get_documents($option));
	}


	/*
		根据文案的标题获取相应的内容；
	*/
	public function get_document_by_title()
	{

		if (!($title = requestString('title')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		// $sp_uid = AccountMod::get_current_service_provider( 'uid' );

		outRight(SpMod::get_document_by_title($title));
	}

	/*
		删除工单
	*/
	public function delete_feedback()
	{
		if (!$uids = requestIntArray('uids'))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		$sp_uid = AccountMod::get_current_service_provider('uid');
		outRight(SpFeedbackMod::delete_sp_feedback($uids, $sp_uid));
	}

	/*
		添加工单
	*/
	public function add_feedback()
	{
		isset($_REQUEST['content']) && $fb['content'] = requestString('content');
		isset($_REQUEST['status']) && $fb['status'] = requestInt('status');
		isset($_REQUEST['type']) && $fb['type'] = requestInt('type');

		if (empty($fb))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['uid']) && $fb['uid'] = requestInt('uid');
		$fb['sp_uid'] = AccountMod::get_current_service_provider('uid');

		outRight(SpFeedbackMod::add_or_edit_sp_feedback($fb));
	}

	/*
	 *  cat 类型
	 */
	public function plugin_use_status()
	{
		$cats          = WeixinPlugMod::get_weixin_plugin_cats();
		$option['cat'] = requestString('cat');
		if ($option['cat'] && !isset($cats[$option['cat']]))
		{
			$option['cat'] = '';
		}
		$option['page']      = requestInt('page', 0);
		$option['limit']     = requestInt('limit', -1);
		$option['installed'] = requestInt('installed', 0);

		$data = WeixinPlugMod::get_store_plugins_list(0, $option);

		outRight($data);
	}


	/*
	 *  设置 新手教程 已看
	 *  app 页面  ?_a=sp&_u=api.set_visit&app=sp
	 */
	public function set_visit()
	{
		if(!($sp_uid = AccountMod::get_current_service_provider('uid')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);

		}

		$visit                                      = json_decode($GLOBALS['arraydb_sys']['visit_' . $sp_uid], true);
		$app                                        = requestString('app','', $GLOBALS['_UCT']['APP']);
		$visit[$app]                                = 1;

		$GLOBALS['arraydb_sys']['visit_' . $sp_uid] = json_encode($visit);
	}


	public function test()
	{
		$public_uid = WeixinMod::get_current_weixin_public('uid');
		$ret= WeixinMod::get_weixin_user_info($public_uid,'oF71MwdTLhdmtEXwGePhclObViqo');

		var_dump($ret);

	}


	//开启同步自动回复 任务  2015年10月29日16:06:21 改到componenet里
	public function set_autoreply()
	{
		$sp_uid     = AccountMod::get_current_service_provider('uid');
		$public_uid = WeixinMod::get_current_weixin_public('uid');


		$data = weixin::weixin_get_current_autoreply_info(WeixinMod::get_weixin_access_token($public_uid));
		uct_use_app('job');
		$args = array('basic_arg' => array('sp_uid'        => $sp_uid,
		                                   'public_uid'    => $public_uid,
		                                   'job_uid'       => '',
		                                   'job_parent_id' => (isset($this->job_uid) ? $this->job_uid : '')),
		              'fun_args'  => array($data));
		$ret  = JobMod::add_job('SyncaAutoreplyJob', $args);
		echo '任务已经添加，开始加载》》自动回复消息配置';
		echo '<script> setTimeout(function(){window.location.href="?_a=sp"},3000)</script>';
//		outRight($ret);
	}

	/*
		!!!
	*/
	public function get_component_url()
	{
		$pre_auth_code = ComponentMod::get_pre_auth_code();
		$url='https://mp.weixin.qq.com/cgi-bin/componentloginpage?component_appid='.COMPONENT_APPID.
				'&pre_auth_code='.$pre_auth_code.'&redirect_uri=';
		$real_redirect_uri = (isHttps() ? 'https://' : 'http://').getDomainName().'/rewrite.web.component.uricallbcak.sp_uid='.accountMod::get_current_service_provider('uid').'._ap_uid='.which_agent_provider().'.sb.php';
		$url .= urlencode($real_redirect_uri);

		
		if(0 && getDomainName() != 'weixin.uctphp.com')
		{
			$url = (isHttps() ? 'https://' : 'http://').'weixin.uctphp.com?_a=web&_u=index.goto_url&url='.urlencode($url);
		}

		outRight($url);

	}

	public function set_about_link() {
		$url = requestString('url', PATTERN_URL);

		outRight(SpMod::set_sp_about_link($url, AccountMod::get_current_service_provider('uid')));
	}

	public function add_sp_wx() {
		if(!($sw['open_id'] = requestString('open_id', PATTERN_NORMAL_STRING))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['cfg']) && $sw['cfg'] = requestKvJson('cfg');

		$sw['sp_uid'] = AccountMod::get_current_service_provider('uid');
		outRight(SpwxMod::add_or_edit_sp_wx($sw));
	}

	public function delete_spwx() {
		if(!$uids = requestStringArray('uids', PATTERN_NORMAL_STRING)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$ret = 0;
		$sp_uid = AccountMod::get_current_service_provider('uid');
		foreach($uids as $openid) {
			if(SpwxMod::delete_sp_wx($openid, $sp_uid)) $ret++;
		}

		outRight($ret);
	}

    /*
        添加编辑幻灯片
    */
    public function addslide()
    {
        $slide['sp_uid'] = $sp_uid = AccountMod::get_current_service_provider('uid');
        if (isset($_REQUEST['title']) && !($slide['title'] = requestStringLen('title', 64))) {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }
        if (isset($_REQUEST['pos']) && !($slide['pos'] = requestString('pos', PATTERN_SEARCH_KEY))) {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }
        isset($_REQUEST['link']) && $slide['link'] = requestString('link', PATTERN_URL);
        isset($_REQUEST['link_type']) && $slide['link_type'] = requestString('link_type');
        isset($_REQUEST['image']) && $slide['image'] = requestString('image', PATTERN_URL);
        isset($_REQUEST['sort']) && $slide['sort'] = requestInt('sort');
        isset($_REQUEST['status']) && $slide['status'] = requestInt('status');
        if($on_time = requestString('on_time', PATTERN_DATETIME)) $slide['on_time'] = strtotime($on_time);
        if($off_time = requestString('off_time', PATTERN_DATETIME)) $slide['off_time'] = strtotime($off_time);

        if (empty($slide)) {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }
        isset($_REQUEST['uid']) && $slide['uid'] = requestInt('uid');

        outRight(SlidesMod::add_or_edit_slide($slide));
    }

    /*
        删除幻灯片
    */
    public function delslide()
    {

        $slide['sp_uid'] = $sp_uid = AccountMod::get_current_service_provider('uid');
        if (!($sids = requestIntArray('uids'))) {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }

        outRight(SlidesMod::delete_slides($sids, $slide['sp_uid']));
    }

	/*
		增加预设幻灯片
	*/
	public function add_tpl_slide() {
		$sp_uid = AccountMod::get_current_service_provider('uid');
		$key = requestString('key');

		outRight(SlidesMod::add_tpl_slide($key, $sp_uid));
	}

    /*
        添加编辑附件
    */
    public function addattach()
    {
        $attach['sp_uid'] = $sp_uid = AccountMod::get_current_service_provider('uid');
        if (isset($_REQUEST['title']) && !($attach['title'] = requestStringLen('title', 64))) {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }
        if (isset($_REQUEST['pos']) && !($attach['pos'] = requestString('pos', PATTERN_SEARCH_KEY))) {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }
        isset($_REQUEST['link']) && $attach['link'] = requestString('link', PATTERN_URL);
        isset($_REQUEST['link_type']) && $attach['link_type'] = requestString('link_type');
        isset($_REQUEST['image']) && $attach['image'] = requestString('image', PATTERN_URL);
        isset($_REQUEST['sort']) && $attach['sort'] = requestInt('sort');
        isset($_REQUEST['status']) && $attach['status'] = requestInt('status');
        if($on_time = requestString('on_time', PATTERN_DATETIME)) $attach['on_time'] = strtotime($on_time);
        if($off_time = requestString('off_time', PATTERN_DATETIME)) $attach['off_time'] = strtotime($off_time);

        if (empty($attach)) {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }
        isset($_REQUEST['uid']) && $attach['uid'] = requestInt('uid');

        outRight(AttachesMod::add_or_edit_attach($attach));
    }

    /*
        删除附件
    */
    public function delattach()
    {

        $attach['sp_uid'] = $sp_uid = AccountMod::get_current_service_provider('uid');
        if (!($sids = requestIntArray('uids'))) {
            outError(ERROR_INVALID_REQUEST_PARAM);
        }

        outRight(AttachesMod::delete_attaches($sids, $attach['sp_uid']));
    }

	public function upload_xiaochengxu() {
		$sp_uid = AccountMod::get_current_service_provider('uid');
		if(!($public_uid = requestInt('public_uid')) || 
		  !($public = WeixinMod::get_weixin_public_by_uid($public_uid)) ||
		  $public['sp_uid'] != $sp_uid) {
			$public = Dba::readRowAssoc('select * from weixin_public where sp_uid = '.$sp_uid.
					' && public_type & 8 = 8', 'WeixinMod::func_get_weixin');	
		}

		if(!$public) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		#var_export($public);

		$template_id = requestInt('template_id');
		XiaochengxuMod::auto_domain_xiaochengxu($public); //设置一下域名
		outRight(XiaochengxuMod::upload_xiaochengxu($template_id, $public));	
	}
	
	/*
		获取预览二维码
	*/
	public function get_xiaochengxu_qrcode() {
		$sp_uid = AccountMod::get_current_service_provider('uid');
		if(!($public_uid = requestInt('public_uid')) || 
		  !($public = WeixinMod::get_weixin_public_by_uid($public_uid)) ||
		  $public['sp_uid'] != $sp_uid) {
			$public = Dba::readRowAssoc('select * from weixin_public where sp_uid = '.$sp_uid.
					' && public_type & 8 = 8', 'WeixinMod::func_get_weixin');	
		}

		if(!$public) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(XiaochengxuMod::get_qrcode($public));	
	}
	
	/*
		提交审核
	*/
	public function audit_xiaochengxu() {
		$sp_uid = AccountMod::get_current_service_provider('uid');
		if(!($public_uid = requestInt('public_uid')) || 
		  !($public = WeixinMod::get_weixin_public_by_uid($public_uid)) ||
		  $public['sp_uid'] != $sp_uid) {
			$public = Dba::readRowAssoc('select * from weixin_public where sp_uid = '.$sp_uid.
					' && public_type & 8 = 8', 'WeixinMod::func_get_weixin');	
		}

		if(!$public) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		//
		$data = array();
		if(!$data['title'] = requestStringLen('title', 32)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if(!$data['tag'] = requestString('tag')) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if(!$data['first_class'] = requestString('first_class')) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if(!$data['second_class'] = requestString('second_class')) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		if(!empty($_REQUEST['third_class'])) $data['third_class'] = requestString('third_class'); 

		outRight(XiaochengxuMod::audit_xiaochengxu($data, $public));	
	}
	
	/*
		发布
	*/
	public function release_xiaochengxu() {
		$sp_uid = AccountMod::get_current_service_provider('uid');
		if(!($public_uid = requestInt('public_uid')) || 
		  !($public = WeixinMod::get_weixin_public_by_uid($public_uid)) ||
		  $public['sp_uid'] != $sp_uid) {
			$public = Dba::readRowAssoc('select * from weixin_public where sp_uid = '.$sp_uid.
					' && public_type & 8 = 8', 'WeixinMod::func_get_weixin');	
		}

		if(!$public) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(XiaochengxuMod::release_xiaochengxu($public));	
	}
	
	/*
		绑定体验者
	*/
	public function bindtester_xiaochengxu() {
		if(!$wechatid = requestString('wechatid', PATTERN_NORMAL_STRING)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$sp_uid = AccountMod::get_current_service_provider('uid');
		if(!($public_uid = requestInt('public_uid')) || 
		  !($public = WeixinMod::get_weixin_public_by_uid($public_uid)) ||
		  $public['sp_uid'] != $sp_uid) {
			$public = Dba::readRowAssoc('select * from weixin_public where sp_uid = '.$sp_uid.
					' && public_type & 8 = 8', 'WeixinMod::func_get_weixin');	
		}

		if(!$public) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(XiaochengxuMod::bindtester_xiaochengxu($wechatid, $public));	
	}

	/*
    增加和编辑问题
	*/
	public function add_problem()
	{

		isset($_REQUEST['title']) && $document['title'] = requestString('title');
		isset($_REQUEST['type']) && $document['type'] = requestString('type');
		isset($_REQUEST['sort']) && $document['sort'] = requestString('sort');
		isset($_REQUEST['content']) && $document['content'] = requestString('content');
		isset($_REQUEST['uid']) && $document['uid'] = requestInt('uid');

		$document['sp_uid'] = AccountMod::get_current_service_provider('uid');

		if (empty($document))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(SpMod::add_or_edit_problem($document));
	}

	/*
		删除相应的问题
	*/
	public function delete_problem()
	{

		if (!($dids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}


		outRight(SpMod::delete_problem($dids));
	}

	/*
	增加和编辑链接
	*/
	public function add_link()
	{

		isset($_REQUEST['title']) && $data['title'] = requestString('title');
		isset($_REQUEST['link']) && $data['link'] = requestString('link');

		if (empty($data))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		isset($_REQUEST['uid']) && $data['uid'] = requestInt('uid');

		outRight(SpMod::add_or_edit_link($data));
	}

	/*
    删除相应的链接
	*/
	public function del_link()
	{

		if (!($dids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}


		outRight(SpMod::delete_link($dids));
	}

	/*
	 * 编辑文件分组
	 * 参数                   必要              说明
	 * file_group_list       是                用于修改组名和添加新分组   {"2":"我的分组"} 当编号为2的分组存在时 更新组名为【我的分组】 不存在时添加【我的分组】
	 */
	public function edit_file_group_list()
	{
		$sp_uid  = AccountMod::get_current_service_provider('uid');
		$type = requestInt('type','1');
		uct_use_app('upload');
		$new_file_group_lists = requestKvJson('file_group_list');
		outRight(UploadMod::add_or_edit_file_group_list($new_file_group_lists,$sp_uid,$type));
	}
	/*
	 * 删除图片分类
	 */
	public function del_file_group()
	{
		$sp_uid  = AccountMod::get_current_service_provider('uid');
		$type = requestInt('type','1');
		if (!($file_group_id = requestInt('file_group_id')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		uct_use_app('upload');
		outRight(UploadMod::delete_a_file_group($sp_uid,$type,$file_group_id));
	}

	/*
		获取小程序页面
	*/
	public function get_xcxpage() {
		$sp_uid = AccountMod::get_current_service_provider('uid');
		$public_uid = WeixinMod::get_current_weixin_public('uid');
		
		if($uid = requestInt('uid')) {
			$page = XiaochengxuPagesMod::get_xiaochengxu_pages_by_uid($uid);
			if((!$page || ($page['sp_uid'] != $sp_uid))) {
				outError(ERROR_OBJ_NOT_EXIST);
			}
		} else {
			$page = XiaochengxuPagesMod::get_xiaochengxu_pages_by_default($sp_uid, $public_uid);
		}
		outRight($page);
	}

	/*
		增加编辑小程序页面
	*/
	public function add_xcxpage() {
		isset($_REQUEST['title']) && $p['title'] = requestString('title');
		isset($_REQUEST['content']) && $p['content'] = requestString('content');
		isset($_REQUEST['type']) && $p['type'] = requestString('type');
		isset($_REQUEST['public_uid']) && $p['public_uid'] = requestInt('public_uid');

		if(isset($_REQUEST['uid'])) {
			$p['uid'] = requestInt('uid');
			if($p['uid'] <= 0) unset($p['uid']);
		}
		isset($_REQUEST['sort']) && $p['sort'] = requestInt('sort');
		isset($_REQUEST['status']) && $p['status'] = requestInt('status');

		$p['sp_uid'] = AccountMod::get_current_service_provider('uid');
		if (empty($p)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(XiaochengxuPagesMod::add_or_edit_xiaochengxu_pages($p));
	}

	/*
		删除相应的方案
	*/
	public function delete_xcxpage()
	{
		if (!($dids = requestIntArray('uids')))
		{
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$sp_uid = AccountMod::get_current_service_provider('uid');
		outRight(XiaochengxuPagesMod::delete_xiaochengxu_pages($dids, $sp_uid));
	}

	
}

