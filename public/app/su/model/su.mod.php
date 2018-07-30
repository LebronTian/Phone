<?php

/*
	用户管理
*/
class SuMod {
	public static function func_get_su_profile($item) {
		if(!empty($item['address'])) $item['address'] = htmlspecialchars($item['address']);
		if(!empty($item['brief'])) $item['brief'] = XssHtml::clean_xss($item['brief']);
		if(!empty($item['extra_info'])) $item['extra_info'] = json_decode($item['extra_info'], true);

		return $item;
	}

	/*
		构造一个微信网页授权登陆链接,只有认证服务号才有权限
		参考文档:  	http://mp.weixin.qq.com/wiki/17/c0f37d5704f0b64713d5d2c37b468d75.html
		$option = array(
						'public_uid' => 授权公众号, 默认当前服务商的公众号
						'scope'  => 默认 snsapi_userinfo, 可选值为snsapi_base
						'redirect_uri' => 回调地址, 默认 [su]index.weixin_oauth2_login
						'state' => 暂时未使用,可以传到回调url中
					)

		返回形如
https://open.weixin.qq.com/connect/oauth2/authorize?appid=APPID&redirect_uri=REDIRECT_URI&response_type=code&scope=SCOPE&state=STATE#wechat_redirect
	*/
	public static function  get_weixin_oauth2_login_url($option = array()) {
		$this_sp_uid = AccountMod::require_sp_uid();
		$url = 'https://open.weixin.qq.com/connect/oauth2/authorize?';
		$public_uid = !empty($option['public_uid']) ? $option['public_uid'] : 
        Dba::readOne('select weixin_public.uid from weixin_public join service_provider on service_provider.uct_token = weixin_public.uct_token  where service_provider.uid = '.$this_sp_uid);


        if(!$public_uid || !($wx = WeixinMod::get_weixin_public_by_uid($public_uid)) ||
			!(($wx['public_type'] == 2) && $wx['has_verified'])) {

			setLastError(ERROR_DBG_STEP_2);
			return false;
		}

		$appid = $wx['app_id'];
		//回调地址
		if(!empty($option['redirect_uri'])) {
			$redirect_uri = str_replace(array('{$public_uid}', '{$sp_uid}'), array($public_uid, $this_sp_uid), $option['redirect_uri']);
		}
		else {
			$redirect_uri = AccountMod::require_wx_redirect_uri().'/?_a=su&_u=index.weixin_oauth2_login&public_uid='.$public_uid.'&sp_uid='.$this_sp_uid;
		}
		$scope = !empty($option['scope']) ? $option['scope'] : 'snsapi_userinfo';
		//静默授权登录
		if(!empty($GLOBALS['_TMP']['SILENT_WX_LOGIN'])) {
			$scope = 'snsapi_base';	
		}

		$state = !empty($option['state']) ? $option['state'] : '';
        if($wx['app_secret']=='0')
        {
            $param = array('appid' => $appid, 'redirect_uri' => $redirect_uri,
                'response_type' => 'code', 'scope' => $scope, 'state' => $state,'component_appid'=>COMPONENT_APPID);
        }
        else
        {
            $param = array('appid' => $appid, 'redirect_uri' => $redirect_uri,
                'response_type' => 'code', 'scope' => $scope, 'state' => $state);
        }

		return $url . http_build_query($param) . '#wechat_redirect';
	}

	/*
		微信用户同意授权后,

		1. 获取accesstoken
		2. 获取openid
		3. 自动登陆
		
	*/
	public static function on_weixin_oauth2_ok($public_uid, $code) {
		if(!($wx = WeixinMod::get_weixin_public_by_uid($public_uid)) ||
			!(($wx['public_type'] == 2) && $wx['has_verified'])) {
			setLastError(ERROR_DBG_STEP_2);
			return false;
		}
		$appid = $wx['app_id'];
        //当app_secret 为 0 时 为第三方服务平台接入 使用网页代授权方式  参数有区别
		if($wx['app_secret']=='0')
        {
            $param = array('appid'   => $wx['app_id'],
                'secret' => $wx['app_secret'],
                'code'   => $code,
                'grant_type' => 'authorization_code',
                'component_appid'=>COMPONENT_APPID,
                'component_access_token'=>Component::get_component_token()
            );
            $url = 'https://api.weixin.qq.com/sns/oauth2/component/access_token?' . http_build_query($param);

        }
        else
        {
            $param = array('appid'   => $wx['app_id'],
                'secret' => $wx['app_secret'],
                'code'   => $code,
                'grant_type' => 'authorization_code',
            );
            $url = 'https://api.weixin.qq.com/sns/oauth2/access_token?' . http_build_query($param);
        }

		$ret = Weixin::weixin_https_get($url);
		if(!$ret || !($ret = json_decode($ret, true)) ||
			empty($ret['openid'])) {
			setLastError(ERROR_DBG_STEP_3);
			return false;
		}

		if(!empty($_SESSION['REQUIRE_OPEN_ID_ONCE'])) {
			return $ret['openid'];
		}

		//如果是代理授权, 这个判断方式
		$this_sp_uid = AccountMod::require_sp_uid();
		if(!empty($_REQUEST['_is_proxy']) || ($this_sp_uid != $wx['sp_uid'])) {
			return SuWxloginMod::on_proxy_wxlogin_oauth2_ok($this_sp_uid, $wx, $ret);
		}

		$GLOBALS['service_provider']['uid'] = $wx['sp_uid'];
		WeixinMod::set_current_weixin_public($wx);
		WeixinMod::set_current_weixin_fan($ret['openid']);
		$_SESSION['su_login'] = $_SESSION['su_uid'] = $su_uid = WeixinMod::get_current_weixin_fan('su_uid');
		$_SESSION['open_id'] = $ret['openid'];

		//自动获取一下用户信息
		if((WeixinMod::get_current_weixin_fan('is_new') ||
			WeixinMod::get_current_weixin_fan('has_subscribed') != 1) &&
			in_array('snsapi_userinfo', explode(',', $ret['scope']))) {
			$param = array(	
						'access_token' => $ret['access_token'],
						'openid'       => $ret['openid'],
						'lang'         => 'zh-CN',
			);
			$url = 'https://api.weixin.qq.com/sns/userinfo?'.http_build_query($param);
			$ret = Weixin::weixin_https_get($url);
			#Weixin::weixin_log('returnnnn '.$ret);
			if($ret && ($ret = json_decode($ret, true)) &&
				!empty($ret['nickname'])) {

			//todo mb4
			$ret['nickname'] = preg_replace('/[\x{10000}-\x{10FFFF}]/u', '', $ret['nickname']);
				$update = array(
					'name' => $ret['nickname'],
					'gender' => $ret['sex'],
					'avatar' => $ret['headimgurl'],
				);	
				if(!empty($ret['unionid'])) {
					$update['union_id'] = checkString($ret['unionid'], PATTERN_NORMAL_STRING);
				}
				self::update_su($su_uid, $update);
				//忽略城市信息
			}
			else {
				Weixin::weixin_log('get user info failed! retrying ... '.$su_uid);
				//试着再刷新一下
				return Queue::do_job_at(1, 'su_updateinfoJob', array($su_uid, 3));	
			}
		}

		return $su_uid;
	}

	/*
		在 SuMod::require_su_uid 前调用
		微信自动授权静默登录
	*/
	public static function keep_silent() {
		$GLOBALS['_TMP']['SILENT_WX_LOGIN'] = true;
	}

	/*
		返回用户open_id 而不是su_uid, 并且不会作登陆操作 	
		可用于微信端支付获取open_id
	*/
	public static function require_open_id() {
		SuMod::keep_silent();
		$_SESSION['REQUIRE_OPEN_ID_ONCE'] = true;
		$openid = SuMod::require_su_uid(false);	
		unset($_SESSION['REQUIRE_OPEN_ID_ONCE']);
		return $openid;
	}


	/*
		确保用户登陆, 
			微信环境下自动调用微信授权登陆	
		    否则跳转到登录页面
	*/
	public static function require_su_uid($exit=true) {
		if($su_uid = AccountMod::has_su_login()) {
			//禁止被封号的用户
			if(!($su = AccountMod::get_service_user_by_uid($su_uid)) ||
				$su['status'] >= 2)	 {
				if($exit) {
					echo 'this account has been forbidden! '.$su_uid;
					session_destroy();
					exit();
				}
				return false;
			}

			if(!empty($_SESSION['REQUIRE_OPEN_ID_ONCE'])) {
				//不取了重新获取一下openid
			} else {
				return $su_uid;
			}
		}

		if(isWeixinBrowser()) {
			if(isset($_REQUEST['public_uid']) && isset($_REQUEST['code'])) {
				if(($real_host_uri = requestString('real_host_uri', PATTERN_URL)) &&
					$real_host_uri != getUrlName()) {
					$r = $real_host_uri.'/?'.http_build_query($_GET);
					redirectTo($r);	
				}

				$public_uid = requestInt('public_uid');
				$code = requestString('code', PATTERN_TOKEN);
				if(!$public_uid || !$code || !$su_uid = SuMod::on_weixin_oauth2_ok($public_uid, $code)) {
					if(empty($_GET['fix_bug'])) {
						unset($_GET['code']);
						$_GET['fix_bug'] = 1;
						$r = getUrlName().'/?'.http_build_query($_GET);
						redirectTo($r);	
					}

					//通常是公众号没有权限, 只有认证服务号才有权限
					goto normallogin;
				}


				if(!empty($_SESSION['REQUIRE_OPEN_ID_ONCE'])) {
					return $su_uid;
				}
				/*
					xxxx 授权成功后把这个code去掉，防止分享到朋友圈等也带上了code从而导致失败
					还是再redirect一下？
				*/
				unset($_GET['code']);
				$r = getUrlName().'/?'.http_build_query($_GET);
				redirectTo($r);	

				if(!($su = AccountMod::get_service_user_by_uid($su_uid)) ||
					$su['status'] >= 2)	 {
					if($exit) {
						echo 'this account has been forbidden! '.$su_uid;
						session_destroy();
						exit();
					}
					return false;
				}
				return $su_uid;
			}

			//尝试微信oauth2授权登陆
			$real_host_uri = getUrlName();
			if($real_host_uri != AccountMod::require_wx_redirect_uri()) {
				$_GET['real_host_uri'] = $real_host_uri;
				//域名绑定情况下要显式指定
				$_GET['_a'] = $GLOBALS['_UCT']['APP'];
				$_GET['_u'] = $GLOBALS['_UCT']['CTL'].'.'.$GLOBALS['_UCT']['ACT'];
			}
			$option =  array('redirect_uri' => AccountMod::require_wx_redirect_uri().'/?'.http_build_query($_GET).'&public_uid={$public_uid}&sp_uid={$sp_uid}');

			if($proxy = SuWxloginMod::is_proxy_wxlogin_available(AccountMod::require_sp_uid())) {
				$option['public_uid'] = $proxy['public_uid'];
			}

			if(!$url = SuMod::get_weixin_oauth2_login_url($option)) {
				goto normallogin;
			}


			redirectTo($url);
		}

normallogin:
		if($exit) {
			if(!empty($_SESSION['REQUIRE_OPEN_ID_ONCE'])) {
				return false;
			}
				

			$r = getUrlName().'/?'.http_build_query($_GET);
			//redirectTo('?_a=su&_u=index.login&goto_uri='.urlencode($r));	

			$sp_uid = AccountMod::require_sp_uid();
			if(file_exists(UCT_PATH.'app/su/view/common/tpl/index/login_'.$sp_uid.'.tpl')) {
				uct_set_mirror_tpl('su', 'index', 'login_'.$sp_uid);
			} else {
				uct_set_mirror_tpl('su', 'index', 'login');
			}
			$GLOBALS['_UCT']['TPL'] = 'common';
			$param = array('goto_uri' => $r);
			render_fg('', $param);
			exit();

		}

		return false;
	}

	/*
		要求用户绑定手机号码
	*/
	public static function require_su_phone($exit = true) {
		$uid = self::require_su_uid($exit);
		$p = self::get_su_profile($uid);
	
		if(!empty($p['phone'])) {
			return $p['phone'];
		}

		if($exit) {
			$r = getUrlName().'/?'.http_build_query($_GET);
			//redirectTo('?_a=su&_u=index.login&goto_uri='.urlencode($r));	
			$sp_uid = AccountMod::require_sp_uid();
			if(file_exists(UCT_PATH.'app/su/view/common/tpl/index/setphone_'.$sp_uid.'.tpl')) {
				uct_set_mirror_tpl('su', 'index', 'setphone_'.$sp_uid);
			} else {
				uct_set_mirror_tpl('su', 'index', 'setphone');
			}
			$GLOBALS['_UCT']['TPL'] = 'common';
			$param = array('goto_uri' => $r);
			render_fg('', $param);
			exit();
		}
		return false;
	}

	//alias
	public static function has_su_login() {	
		return AccountMod::has_su_login();
	}
	
	/*
		用户登陆	
	*/
	public static function do_su_login($account, $password, $sp_uid) {
		$sql = 'select * from service_user where account = "'.addslashes($account).'" && sp_uid = '.$sp_uid;
		if(!($su = Dba::readRowAssoc($sql))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}

		//验证码
		/*
		if(!SafetyCodeMod::check_verify_code()) {
			return false;
		}
		*/

		//账号被锁定
		if(!($su = self::check_su_status($su))) {
			return false;
		}

		if(($su['passwd'] != md5($password))) {
			self::try_disable_su_1_hour($su['uid']);
			setLastError(ERROR_INVALID_EMAIL_OR_PASSWD);
			return false;
		}

		//不要把商户踢了
		//$_SESSION = array();
		$_SESSION['su_login'] = $_SESSION['su_uid'] = $su['uid'];
	
		$update = array('last_time' => $_SERVER['REQUEST_TIME'], 'last_ip' => requestClientIP(), 'status' => $su['status']);
		Dba::update('service_user', $update, 'uid = '.$su['uid']);
		Event::handle('AfterSuLogin');

		return array('uid' => $su['uid'], 'name' => $su['name']);
	}

	/*
		检查用户状态
		成功返回$su,失败返回false
		会自动解除锁定状态	
	*/
	public static function check_su_status($su) {
		if(is_numeric($su)) {
			if(!($su = Dba::readRowAssoc('select * from service_user where uid = '.$su))) {
				setLastError(ERROR_OBJ_NOT_EXIST);
				return false;
			}
		}
		if($su['status'] >= 60) {
			if(($su['last_time'] + 3600) >= $_SERVER['REQUEST_TIME']) {
				setLastError(ERROR_DENYED_FOR_SAFETY);
				return false;
			}
			else {
				$su['status'] -= 60;
			}
		}
		if($su['status'] > 1) {
			setLastError(ERROR_BAD_STATUS);
			return false;
		}

		return $su;
	}

	/*
		检查账号是否被注册
	*/
	public static function check_su_account($account, $sp_uid) {
		$sql = 'select uid from service_user where account = "'.addslashes($account).'" && sp_uid = '.$sp_uid;

		return Dba::readOne($sql);
	}

	/*
		修改密码
	*/
	public static function change_su_password($old, $new, $uid = 0) {
		if(!$uid && !($uid = AccountMod::get_current_service_user('uid'))) {
			setLastError(ERROR_DBG_STEP_1);
			return false;	
		}
		if(!($su = Dba::readRowAssoc('select uid, passwd from service_user where uid = '.$uid))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;	
		}
		if($su['passwd'] && (md5($old) != $su['passwd'])) {
			setLastError(ERROR_INVALID_EMAIL_OR_PASSWD);
			return false;
		}

		self::update_su($uid, array('passwd' => md5($new)));
		return true;
	}

	/*
		重置密码
	*/
	public static function reset_su_password($phone, $password, $sp_uid) {
		if(!($su = Dba::readRowAssoc('select uid, status, last_time from service_user where account = "'.addslashes($phone)
									.'" && sp_uid = '.$sp_uid))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;	
		}
		if(!($su = self::check_su_status($su))) {
			return false;
		}
		//短信验证码
		if(!SafetyCodeMod::check_mobile_code()) {
			self::try_disable_su_1_hour($su['uid'], 5);
			return false;
		}

		self::update_su($su['uid'], array('passwd' => md5($password), 'status' => $su['status']));
		return true;
	}

	/*
		商户注册	@param $su = array('account' =>   //登陆账号
							'passwd' => //密码
						)
	*/
	public static function do_su_register($su) {
		if(!SuMod::is_register_open($su['sp_uid'])) {
			setLastError(ERROR_SERVICE_NOT_AVAILABLE);
			return false;
		}

//		短信验证码
		if(!empty($_REQUEST['mobilecode']) && !SafetyCodeMod::check_mobile_code()) {
			return false;
		}

		if((self::check_su_account($su['account'], $su['sp_uid']))) {
			setLastError(ERROR_OBJECT_ALREADY_EXIST);
			return false;
		}
		$su['passwd'] = md5($su['passwd']);
		$su['create_time'] = $_SERVER['REQUEST_TIME'];
//		Dba::beginTransaction();
//		{
		Dba::insert('service_user', $su);
		$su['uid'] = Dba::insertID();
		Event::handle('AfterSuRegister', array($su));
//		}
//		Dba::commit();
		return array('uid' => $su['uid']);
	}

	/*
		修改户基本资料
	*/
	public static function update_su($uid, $update) {
		if(!$uid && !($uid = AccountMod::get_current_service_user('uid'))) {
			setLastError(ERROR_DBG_STEP_1);
			return false;	
		}

		if(isset($update['union_id'])) {
			/*	
				已经存在的union_id 并且 不是同一个人
			
				比如 先授权了小程序(或另一个公众号)， 后授权公众号 时，就会出现这种情况	
				此时直接把当前用户修改到旧的用户
			*/
			if(($su_uid = Dba::readOne('select su_uid from weixin_unionid where union_id = "'.
					addslashes($update['union_id']).'"')) && ($su_uid != $uid)) {
				Weixin::weixin_log('[warning!] update user '.$uid.' to '.$su_uid.' by union_id');
				$uid = $su_uid;	
				if(WeixinMod::get_current_weixin_fan('is_new')) {
					$GLOBALS['weixin_fan']['su_uid'] = $su_uid;
					Dba::write('update weixin_fans set su_uid = '.$su_uid.
						' where uid = '.$GLOBALS['weixin_fan']['uid']);
				}
			} 

			Dba::replace('weixin_unionid', array('su_uid' => $uid, 
						'union_id' => $update['union_id']));
			unset($update['union_id']);
		}

		if(!empty($update['from_su_uid'])) {
			$old_from_su_uid = Dba::readOne('select from_su_uid from service_user where uid = '.$uid);
		}
		Dba::update('service_user', $update, 'uid = '.$uid);

		//推荐人关系变化, 注意这个消息是发给推荐人的
		if(isset($old_from_su_uid) && ($update['from_su_uid'] != $old_from_su_uid)) {
			if(uct_class_exists('Template_Msg_WxPlugMod', 'templatemsg')) {
				$sp_uid = Dba::readOne('select sp_uid from service_user where uid = '.$uid);
				$args = array('su_uid' => $uid, 'from_su_uid' => $update['from_su_uid']);		
				Template_Msg_WxPlugMod::after_even_send_template_msg(__CLASS__.'.'.__FUNCTION__, 
								$sp_uid, $update['from_su_uid'], Tmsg_suMod::get_args($args));
			}
		}

		return $uid;
	}

	/*
		商户注册功能是否开放
		true 开启
		false 关闭
	*/
	public static function is_register_open($sp_uid) {
		$key = 'register_disabled_'.$sp_uid;	
		return empty($GLOBALS['arraydb_sys'][$key]);
	}

	/*
		关闭注册功能
		disable 1 关闭， 0 开启
	*/
	public static function disable_register($sp_uid, $disable = 1) {
		$key = 'register_disabled_'.$sp_uid;	
		return $GLOBALS['arraydb_sys'][$key] = $disable;
	}

	/*
		修改用户资料
	*/
	public static function update_su_profile($uid, $profile) {
		if(!$uid && !($uid = AccountMod::get_current_service_user('uid'))) {
			setLastError(ERROR_DBG_STEP_1);
			return false;	
		}

		Event::handle('BeforeUpdateSuProfile', array($uid, $profile));

		//avatar字段不在同一张表里
		if(!empty($profile['avatar'])) {
			self::update_su($uid, array('avatar' => $profile['avatar']));
			unset($profile['avatar']);
		}

		if($profile) {
			if(Dba::readRowAssoc('select 1 from service_user_profile where uid = '.$uid)) {
				Dba::update('service_user_profile', $profile, 'uid = '.$uid);
			}
			else {
				$profile['uid'] = $uid;
				Dba::insert('service_user_profile', $profile);
			}
		}

		return true;
	}

	/*
		锁定用户账号1小时, 禁止登陆

		5分钟内连续10次出错才禁止账号
		$failcnt 出错次数
	*/
	public static function try_disable_su_1_hour($uid, $failcnt = 1) {
		$key = 'failsu_'.$uid;
		if(!($old = $GLOBALS['arraydb_sys'][$key])) {
			$old = 0;
		}
		$old += $failcnt;
		$GLOBALS['arraydb_sys'][$key] = array('expire' => 300, 'value' => $old);
		if($old < 10) {
			return 0;
		}

		$sql = 'update service_user set status = if(status < 60, status + 60, status), last_time = '.$_SERVER['REQUEST_TIME']
				.' where uid = '.$uid;
		Dba::write($sql);

		return Dba::affectedRows();
	}

	/*
		刷新用户资料 昵称头像	
		$force 强制刷新
	*/
	public static function update_su_by_weixin_info($su_uid, $force = 0) {
		$su = Dba::readRowAssoc('select uid, sp_uid, name from service_user where uid = '.$su_uid);
		if(!$su) {
			return false;
		}
		if(!$force && (!$su['name'] || !strncmp($su['name'], '微信粉丝', strlen('微信粉丝')))) {
			return false;
		}
		
		$fan = Dba::readRowAssoc('select open_id, public_uid, has_subscribed from weixin_fans where su_uid = '.$su_uid);

		if(!$fan || !$fan['open_id'] || !$fan['public_uid']) {
			//支持一下代理授权
			if(SuWxLoginMod::is_proxy_wxlogin_available($su['sp_uid'])) {
				if(!$fan = Dba::readRowAssoc('select open_id, public_uid from oauth_weixin_fans where sp_uid = '.
										$su['sp_uid'].' && su_uid = '.$su_uid)) {
					return false;
				}
				$fan['has_subscribed'] = 0;
			}
			else {
				return false;
			}
		}
	
		if(!$force && ($fan['has_subscribed'] == 2)) {
			return false;
		}

		$access_token = WeixinMod::get_weixin_access_token($fan['public_uid']);
		$openid = $fan['open_id'];
		$param = array( 
                        'access_token' => $access_token,
                        'openid'       => $openid,
                        'lang'         => 'zh-CN',
        );
		$url = 'https://api.weixin.qq.com/cgi-bin/user/info?'.http_build_query($param);
		$ret = Weixin::weixin_https_get($url);
			#Weixin::weixin_log('returnnnn '.$ret);
		if($ret && ($ret = json_decode($ret, true)) &&
			!empty($ret['nickname'])) {

			//todo mb4
			$ret['nickname'] = preg_replace('/[\x{10000}-\x{10FFFF}]/u', '', $ret['nickname']);

			$update = array(
				'name' => $ret['nickname'],
				'gender' => $ret['sex'],
				'avatar' => $ret['headimgurl'],
			);	
			if(!empty($ret['unionid'])) {
				$update['union_id'] = checkString($ret['unionid'], PATTERN_NORMAL_STRING);
			}
			self::update_su($su_uid, $update);
			//忽略城市信息
		}

		return true;
	}

	/*
		获取用户资料
	*/
	public static function get_su_profile($uid = 0) {
		if(!$uid && !($uid = AccountMod::get_current_service_user('uid'))) {
			setLastError(ERROR_DBG_STEP_1);
			return false;	
		}

		$sql = 'select * from service_user_profile where uid = '.$uid;
		if($p = Dba::readRowAssoc($sql, 'SuMod::func_get_su_profile')) {
			if($uid == AccountMod::get_current_service_user('uid')) {
				$p['avatar'] = AccountMod::get_current_service_user('avatar');
			}
			else {
				$p['avatar'] = Dba::readOne('select avatar from service_user where uid = '.$uid);
			}
		}else{
			$profile['uid'] = $uid;
			Dba::insert('service_user_profile', $profile);
			$p = Dba::readRowAssoc($sql, 'SuMod::func_get_su_profile');
		}

		return $p;
	}

	/*
		解除锁定用户账号1小时,
	*/
	public static function enable_su_1_hour($uid) {
		$sql = 'update service_user set status = if(status >= 60, status - 60, status), last_time = '.$_SERVER['REQUEST_TIME']
				.' where uid = '.$uid;
		Dba::write($sql);

		return Dba::affectedRows();
	}

	/*		
		设置用户地理位置
	*/
	public static function set_user_geo($ul) {
		$ul['create_time'] = $_SERVER['REQUEST_TIME'];
		Dba::insert('user_location', $ul);
		return Dba::insertID();
	}

	/*
		用户审核
	*/
	public static function review_user($uids, $status, $sp_uid) {
		$sql = 'update service_user set status = '.$status.' where uid in ('.implode(',', $uids).') && sp_uid = '.$sp_uid;
		return Dba::write($sql);
	}

	/*
		获取最近来源用户

		若有返回 array(
			'from_su_uid' => 
			'update_time' => 
		)
		若无返回false
	*/
	public static function get_last_from_su_uid($su_uid) {
		$key = 'last_from_su_'.$su_uid;
		return !empty($GLOBALS['arraydb_weixin_fan'][$key]) ? 
				json_decode($GLOBALS['arraydb_weixin_fan'][$key], true) : false;
	}

	/*
		设置最近来源用户
		通常在扫描用户专属二维码后更新
	*/
	public static function set_last_from_su_uid($su_uid, $from_su_uid) {
		$key = 'last_from_su_'.$su_uid;
		return $GLOBALS['arraydb_weixin_fan'][$key] = json_encode(array('from_su_uid' => $from_su_uid, 
													'update_time' => $_SERVER['REQUEST_TIME']));	
	}
	
	/*
		统计符合条件的下级用户数目	

		@param $max_depth 最大层级， 默认3级，  -1 不限层

		@param $valid_func  可选， 是否为有效用户 
		注意即使某用户为无效用户, 仍然会继续统计其有效下级的数目
		function($uid) {
			return true;
		}
	*/
	public static function get_sub_user_count($su_uid, $max_depth = 3, $valid_func = null) {
		if(is_numeric($su_uid)) $su_uid = array($su_uid);

		static $visited = array();	
		if(!$visited) {
			$first_call = 1;
			if(count($su_uid) != 1) {
				//die(__FUNCTION__.' param error!');
			}
		}
		else {
			$su_uid = array_diff($su_uid, $visited);
			if(!$su_uid) return 0;
		}
		$visited = array_merge($visited, $su_uid);

		$cnt = 0;

		//不包含自己
		if(empty($first_call)) {
			if($valid_func) {
				foreach($su_uid as $uid) {
					if($valid_func($uid)) {
						$cnt++;
					}
				}
			}
			else {
				$cnt += count($su_uid);
			}
		}

		if($max_depth != 0) {
			if($max_depth > 0) $max_depth--;

			$uids = Dba::readAllOne('select uid from service_user where from_su_uid in ('
									.implode(',', $su_uid).')');
			if(!$uids) {
				return $cnt;
			}

			$cnt += SuMod::get_sub_user_count($uids, $max_depth, $valid_func);
		}
		
		if(!empty($first_call)) {
			//清除静态变量以便下次调用
			$visited = array();
		}

		return $cnt;
	}

	/*
		删除用户
	*/
	public static function delete_user($su_uid, $sp_uid) {
		$ret = Dba::write('update service_user set account = null, name = "该用户已删除", status = 2, avatar = "", from_su_uid = 0, create_time = 0, last_time = 0, last_ip = "" where uid = '.
							$su_uid.' && sp_uid = '.$sp_uid);

		
		//把微信相关的删除
		if($ret) {
			Dba::write('delete from weixin_fans where su_uid = '.$su_uid);
			Dba::write('delete from oauth_weixin_fans where sp_uid = '.$sp_uid.' && su_uid = '.$su_uid);
			Dba::write('delete from weixin_unionid where su_uid = '.$su_uid);
			Dba::write('delete from weixin_fans_xiaochengxu where su_uid = '.$su_uid);
		}
		return $ret;
	}

	/*
		批量注册	
		@param $account = array() 
			指定账号注册，此时忽略$count参数
			若 $account 为空则随机生成 $count 个账号

		@param $tpl = array(
							'sp_uid' => , 必填商户uid
							'passwd' => , 必填密码

							'from_su_uid' => 选填， 推荐用户
							...
				),

		返回成功数目
	*/
	public static function bat_register($account, $count, $tpl) {
		$us = array();
		if(!empty($account)) {
			foreach($account as $a) {
				$k = trim($a);
				$us[$k] = array_merge($tpl, array('account' => $k, 
							  			'create_time' =>$_SERVER['REQUEST_TIME']));
			}	
		}
		else {
			$prefix = 'br'.date('Yis', strtotime('18 years ago'));
			for($i = 0; $i < $count; $i++) {
				$k = $prefix.$i;
				$us[$k] = array_merge($tpl, array('account' => $k, 
							  'create_time' =>$_SERVER['REQUEST_TIME']));
			}
		}

		$exist = Dba::readAllOne('select account from service_user where sp_uid = '.$tpl['sp_uid']
								.' && account in '.Dba::makeIn(array_keys($us)));
		if($exist) $us = array_diff_key($us, $exist);
		if(!$us) {
			return 0;
		}

		return Dba::insertS('service_user', array_values($us));
	}
		/*
		根据7位推荐人id获取用户资料
		*/
		public static function get_service_user_by_recommend_uid($uid) {
		   $uid = ltrim($uid, "0");
		   return Dba::readRowAssoc('select * from service_user where uid = '.$uid);
		
		}



}

