<?php
/*
	微信消息默认处理方式
*/

class Default_WxPlugMod {
	public static function onDefaultWeixinMsg($uid = 0) {
        //点击事件,把地理位置时间不处理
        if(!strcasecmp(WeixinMod::get_weixin_xml_args('Event'), 'LOCATION')) {
            echo '';exit;
        }

        //取消关注事件更新一下数据库
        if(!strcasecmp(WeixinMod::get_weixin_xml_args('Event'), 'unsubscribe')) {
			$sql = 'update weixin_fans set has_subscribed = 2 where uid = '.WeixinMod::get_current_weixin_fan('uid');
			Dba::write($sql);	
            echo '';exit;
        }

        $d = self::get_public_default_action($uid);
		if(!empty($d['type']) && !empty($d[$d['type']])) {
			switch($d['type']) {
				case 'nodo':
					//exit('');
					Weixin::weixin_reply_transfer_kefu();	
					break;
				case 'msg':
				if(!empty($d['msg'])) {
					//WeixinMediaMod::xiaochengxu_reply_media($d['msg']);
					WeixinMediaMod::weixin_reply_media($d['msg']);
				}
				break;
			
				case 'keyword':
				if(!empty($d['keyword']['key'])) {
					WeixinMod::process_weixin_msg_by_keyword($d['keyword']['key']);
				}
				break;
	
				case 'proxy':
				if(!empty($d['proxy']['url']) && !empty($d['proxy']['token'])) {
					self::do_proxy($d['proxy']);
				}
				case 'robot':
				if(!empty($d['robot']['url']) && !empty($d['robot']['token'])) {
					$d['robot']['url'] .= '&info='.WeixinMod::get_weixin_xml_args('Content');
					self::do_proxy($d['robot']);
				}

			}
		}

		$default_txt = AccountMod::get_current_service_user('name').' 尚未设置默认回复 -by '.
                         		 AccountMod::get_current_service_provider('name');
		Weixin::weixin_reply_txt($default_txt);

	}

	/*
		微信代理转发
	*/
	public static function do_proxy($proxy) {
		$proxy_url = $proxy['url'];
		$proxy_token = $proxy['token'];
		$proxy_mode = $proxy['msg_mode'];
		$proxy_aes_key= $proxy['aes_key'];
		
		$nonce = isset($_GET['nonce']) ? $_GET['nonce'] : 'xxxxxx';
		$timestamp = isset($_GET['timestamp']) ? $_GET['timestamp'] : time();
		$proxy_url .= (strpos($proxy_url, '?') ? '&'	: '?') . 'timestamp='.$timestamp.'&nonce='.$nonce;
		
		$xml = Weixin::array_to_weixin_xml($GLOBALS['weixin_args']);
		$wx = WeixinMod::get_current_weixin_public();

		if($proxy_mode == 3) {
			include_once UCT_PATH . 'vendor/weixin_encrypt/wxBizMsgCrypt.php';
			$pc = new WXBizMsgCrypt($proxy_token, $proxy_aes_key, $wx['app_id']);
			$xml_enc = '';
			if(0 != ($code = $pc->encryptMsg($xml, $timestamp, $nonce, $xml_enc))) {
			    Weixin::weixin_log('ERROR in weixin proxy! encrypt data fail! '.$code);
				return false;
			}
			$xml = $xml_enc;
			libxml_disable_entity_loader();
			$args = @ array_map(function($v){ return is_object($v) ? (array)$v : $v;},
								(array)(simplexml_load_string($xml, 'SimpleXMLElement', LIBXML_NOCDATA)));

			//$msg_signature = $args['MsgSignature'];
		 	$tmpArr = array($proxy_token, $timestamp, $nonce, $args['Encrypt']);
			sort($tmpArr, SORT_STRING);
			$msg_signature = sha1(implode($tmpArr));
			$proxy_url .= '&encrypt_type=aes&msg_signature='.$msg_signature;

		 	$tmpArr = array($proxy_token, $timestamp, $nonce);
		}
		else {
		 	$tmpArr = array($wx['uct_token'], $timestamp, $nonce);
		}
		sort($tmpArr, SORT_STRING);
		$signature = sha1(implode($tmpArr));
		$proxy_url .= '&signature='.$signature;

		Weixin::weixin_log('do proxy '.$proxy_url.' --- '.$xml);

		$c = curl_init ();
		curl_setopt($c, CURLOPT_URL, $proxy_url);
		curl_setopt($c, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($c, CURLOPT_POST, true);
		curl_setopt($c, CURLOPT_POSTFIELDS, $xml);
		curl_setopt($c, CURLOPT_HTTPHEADER, array('Content-type: text/xml',));
		curl_setopt($c, CURLOPT_USERAGENT,'Mozilla/4.0');
		curl_setopt($c, CURLOPT_TIMEOUT, 4);
		$ret = curl_exec($c);
		curl_close($c);

		if(!$ret) {
			Weixin::weixin_log('ERROR in weixin proxy! curl failed!');
			return false;
		}

		Weixin::weixin_log('proxy return '.$ret);
		if($proxy_mode == 3) {
			$ret_dec = '';
			libxml_disable_entity_loader();
			$args = @ array_map(function($v){ return is_object($v) ? (array)$v : $v;},
								(array)(simplexml_load_string($ret, 'SimpleXMLElement', LIBXML_NOCDATA)));
			//第三方服务端可能会设置不同的timestamp和nonce
			if(!empty($args['TimeStamp'])) $timestamp = $args['TimeStamp'];
			if(!empty($args['Nonce'])) $nonce = $args['Nonce'];
				
			if(empty($args['MsgSignature']) || 0 != ($code = $pc->decryptMsg($args['MsgSignature'], $timestamp, $nonce, $ret, $ret_dec))) {
			    Weixin::weixin_log('ERROR in weixin proxy! seems the backend svr response incorrect data! '.$code.',timestamp =>'.$timestamp.',nonce =>'.$nonce);
				return false;
			}
			$ret = $ret_dec;
		}

		//图灵机器人返回了json格式
		if(($robot = @json_decode($ret, true)) && !empty($robot['text'])) {
			Weixin::weixin_reply_txt($robot['text']);
		}

		Weixin::weixin_reply($ret);
	}


	/*
		获取公众号默认回复
		@return 
		        未设置默认回复 array()
				或 array(
					'type' => 'msg',
					'msg' => array('media_type' => 1, 'content' => 'xxxxxx'),
					'keyword' => array('key' => 'xxxxxx'),
					'proxy' => array('url' => 'xxxxxx',
									'token' => 'xxxxxx',
									'msg_mode' => '1',
									'aes_key' => 'xxxxxx',
							),
				)
	*/
	public static function get_public_default_action($uid = 0) {
		if(!$uid && !($uid = WeixinMod::get_current_weixin_public('uid'))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}

		$key = 'default_'.$uid;
		$d = $GLOBALS['arraydb_weixin_public'][$key];
		if(!$d|| !($d = json_decode($d, true))) {
			setLastError(ERROR_DBG_STEP_1);
			return false;
		}
		if(!empty($d['msg'])) {			
			//这里可能会二次json_decode
     		$d['msg'] = WeixinMediaMod::func_get_weixin_media($d['msg']);     		
		}

		return $d;
	}

	/*
		设置公众号默认回复
	*/
	public static function set_public_default_action($default, $uid = 0) {
		if(!$uid && !($uid = WeixinMod::get_current_weixin_public('uid'))) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}
		 if(!empty($default['msg']['media_uid'])) {
		     if(!($default['msg'] = WeixinMediaMod::get_weixin_media_by_uid($default['msg']['media_uid'])) ||
       		  ($default['msg']['sp_uid'] != AccountMod::get_current_service_provider('uid'))) {
		         setLastError(ERROR_DBG_STEP_1);
       		  return false;
     		}
 		}


		$key = 'default_'.$uid;
		$GLOBALS['arraydb_weixin_public'][$key] = json_encode($default);

		return true;
	}



}

