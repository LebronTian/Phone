<?php

/*
	代实现微信 oauth2 网页授权登录		

	没服务号的商户可以方便使用
*/

class  SuWxloginMod {
	/*	
		获取代授权设置
		
		@return array(
			'enabled' => true 
			'public_uid' => 1
			'join_field'
		)
	*/
	public static function get_proxy_wxlogin_cfg($sp_uid = 0) {
		if(!$sp_uid && !($sp_uid = AccountMod::get_current_service_provider('uid'))) {
			return false;
		}

		$key = 'proxy_wxlogin_'.$sp_uid;
		if(isset($GLOBALS['arraydb_sys'][$key])) {
			return json_decode($GLOBALS['arraydb_sys'][$key], true);
		}
		
		return false;
	}

	//设置代授权设置
	public static function set_proxy_wxlogin_cfg($cfg, $sp_uid = 0) {
		if(!$sp_uid && !($sp_uid = AccountMod::get_current_service_provider('uid'))) {
			return false;
		}

		$key = 'proxy_wxlogin_'.$sp_uid;
		if(is_array($cfg)) {
			$cfg = json_encode($cfg);
		}
		return $GLOBALS['arraydb_sys'][$key] = $cfg;
	}

	public static function is_proxy_wxlogin_available($sp_uid = 0) {
		if(($cfg = self::get_proxy_wxlogin_cfg($sp_uid)) && !empty($cfg['enabled']) &&
			!empty($cfg['public_uid'])) {
			return $cfg;
		}

		return false;
	}

	/*
		代理授权成功回调
		@param  $sp_uid 当前商户uid
		@param  $proxy_wx  授权公众号 array('uid' => )
		@param  $oauth_return 授权返回值 array('openid' => , 'access_token' => )

		@return  $su_uid 或false

	*/
	public static function on_proxy_wxlogin_oauth2_ok($sp_uid, $proxy_wx, $oauth_return) {
		$sql = 'select uid, su_uid, last_time from oauth_weixin_fans where sp_uid = '.$sp_uid
			.' && public_uid = '.$proxy_wx['uid'].' && open_id = "'.addslashes($oauth_return['openid']).'"';
				
		if(($o = Dba::readRowAssoc($sql)) && ($o['last_time'] > 0)) {
			Dba::update('oauth_weixin_fans', array('last_time' => $_SERVER['REQUEST_TIME']), 'uid = '.$o['uid']);
			$su_uid = $o['su_uid'];
			goto onlogin;
		}

		$param = array(	
					'access_token' => $oauth_return['access_token'],
					'openid'       => $oauth_return['openid'],
					'lang'         => 'zh-CN',
		);
		$url = 'https://api.weixin.qq.com/sns/userinfo?'.http_build_query($param);
		$ret = Weixin::weixin_https_get($url);
		$su['sp_uid'] = $sp_uid;
		if($ret && ($ret = json_decode($ret, true)) &&
				!empty($ret['nickname'])) {
			$su['name'] = $ret['nickname'];
			$su['gender'] = $ret['sex'];
			$su['avatar'] = $ret['headimgurl'];
			/*	
				试着绑定一个已存在的用户, avatar貌似经常不一样
				如何防止重复用户？
		
				1. 先进公众号， 再从网页进入  在get_user_info ok的情况下没问题
				2. 先从网页进入，再进公众号
			*/
			$su_uid = Dba::readOne('select uid from service_user where sp_uid = '.$sp_uid.' && name = "'.
						addslashes($su['name']).'" limit 1');
 
			if($su_uid) {
				$su['uid'] = $su_uid;
			}
			else {
				//没找到的话每次都刷新，这样可能会导致后续找到su_uid变动！
				$_SERVER['REQUEST_TIME'] = 0;
			}
		}
		else {
			//...
		}

		$su_uid = AccountMod::add_or_edit_service_user($su);

		$insert = array('sp_uid' => $sp_uid, 'su_uid' => $su_uid, 'public_uid' => $proxy_wx['uid'],
						'open_id' => $oauth_return['openid'], 'last_time' => $_SERVER['REQUEST_TIME']);
		Dba::write('delete from oauth_weixin_fans where sp_uid = '.$sp_uid.' && public_uid = '
				.$proxy_wx['uid'].' && open_id = "'.addslashes($oauth_return['openid']).'"');
		Dba::insert('oauth_weixin_fans', $insert);


onlogin:
		return $_SESSION['su_login'] = $_SESSION['su_uid'] = $su_uid;
	}

}
                                                                            
