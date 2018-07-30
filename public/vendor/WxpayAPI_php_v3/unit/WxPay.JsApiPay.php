<?php
class JsApiPay
{
	public function GetOpenid()
	{
		/*
			ajax方式下无法通过oauth2获取openid
			试着看看当前有没有登录
			!!! 不能这样，appid不相同
		*/
		if(0 && isAjax()) {
			if($su_uid = AccountMod::has_su_login()) {
				return Dba::readOne('select open_id from weixin_fans where su_uid = '.$su_uid);
			}

			return false;
		}


		//接口不太稳定多试几次
		$retry = (isset($_GET['_retry'])) ? min(3, requestInt('_retry')) : 3;
		do {
		//通过code获得openid
		if (!isset($_GET['code'])){
			//触发微信返回code码
			//$baseUrl = urlencode('http://'.$_SERVER['HTTP_HOST'].$_SERVER['PHP_SELF'].$_SERVER['QUERY_STRING']);
			$real_host_uri = getUrlName();
			if($real_host_uri != AccountMod::require_wx_redirect_uri()) {
				$_GET['real_host_uri'] = $real_host_uri;
				//域名绑定情况下要显式指定
				$_GET['_a'] = $GLOBALS['_UCT']['APP'];
				$_GET['_u'] = $GLOBALS['_UCT']['CTL'].'.'.$GLOBALS['_UCT']['ACT'];
				$_GET['_retry'] = $retry;
			}

			$baseUrl = urlencode(AccountMod::require_wx_redirect_uri().'/?'.http_build_query($_GET));
			$url = $this->__CreateOauthUrlForCode($baseUrl);
			Log::DEBUG('wx jsapi redirect to => '.$url);
			Header("Location: $url");
			exit();
		} else {
			if(($real_host_uri = requestString('real_host_uri', PATTERN_URL)) &&
				$real_host_uri != getUrlName()) {
				$r = $real_host_uri.'/?'.http_build_query($_GET);
				redirectTo($r);	
			}

			//获取code码，以获取openid
		    $code = $_GET['code'];
			$openid = $this->GetOpenidFromMp($code);
		}
		unset($_GET['code']);
		} while(empty($openid) && --$retry > 0);

		return $openid;
	}
	
	public function GetJsApiParameters($UnifiedOrderResult)
	{
		if(!array_key_exists("appid", $UnifiedOrderResult)
		|| !array_key_exists("prepay_id", $UnifiedOrderResult)
		|| $UnifiedOrderResult['prepay_id'] == "")
		{
			throw new WxPayException("参数错误");
		}
		$jsapi = new WxPayJsApiPay();
		$jsapi->SetAppid($UnifiedOrderResult["appid"]);
		$timeStamp = (string)($_SERVER['REQUEST_TIME']);
		$jsapi->SetTimeStamp($timeStamp);
		$jsapi->SetNonceStr(WxPayApi::getNonceStr());
		$jsapi->SetPackage("prepay_id=" . $UnifiedOrderResult['prepay_id']);
		$jsapi->SetSignType("MD5");
		$jsapi->SetPaySign($jsapi->MakeSign());
		$parameters = json_encode($jsapi->GetValues());
		return $parameters;
	}
	
	public function GetOpenidFromMp($code)
	{
		$url = $this->__CreateOauthUrlForOpenid($code);

		//接口不太稳定多试几次, 在GetOpenid那里retry
		$retry = 1;
		do {
		//初始化curl
		$ch = curl_init();
		//设置超时
		#curl_setopt($ch, CURLOPT_TIMEOUT, $this->curl_timeout);
		curl_setopt($ch, CURLOPT_TIMEOUT, 5);
		curl_setopt($ch, CURLOPT_URL, $url);
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER,FALSE);
		curl_setopt($ch, CURLOPT_SSL_VERIFYHOST,FALSE);
		curl_setopt($ch, CURLOPT_HEADER, FALSE);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
		if(WxPayConfig::getConfig('CURL_PROXY_HOST') != "0.0.0.0" 
			&& WxPayConfig::getConfig('CURL_PROXY_PORT') != 0){
			curl_setopt($ch,CURLOPT_PROXY, WxPayConfig::getConfig('CURL_PROXY_HOST'));
			curl_setopt($ch,CURLOPT_PROXYPORT, WxPayConfig::getConfig('CURL_PROXY_PORT'));
		}
		//运行curl，结果以jason形式返回
		$res = curl_exec($ch);
		curl_close($ch);
		//取出openid
		Weixin::weixin_log("return sth code = $code,$retry --->".$res);
		$data = json_decode($res,true);
		} while(empty($data['openid']) && --$retry > 0);

		$openid = $data['openid'];
		return $openid;
	}
	
	private function ToUrlParams($urlObj)
	{
		$buff = "";
		foreach ($urlObj as $k => $v)
		{
			if($k != "sign"){
				$buff .= $k . "=" . $v . "&";
			}
		}
		
		$buff = trim($buff, "&");
		return $buff;
	}
	
	private function __CreateOauthUrlForCode($redirectUrl)
	{
		$urlObj["appid"] = WxPayConfig::getConfig('APPID');
		$urlObj["redirect_uri"] = "$redirectUrl";
		$urlObj["response_type"] = "code";
		$urlObj["scope"] = "snsapi_base";
		$urlObj["state"] = "STATE"."#wechat_redirect";
		$bizString = $this->ToUrlParams($urlObj);
		return "https://open.weixin.qq.com/connect/oauth2/authorize?".$bizString;
	}
	
	private function __CreateOauthUrlForOpenid($code)
	{
		$urlObj["appid"] = WxPayConfig::getConfig('APPID');
		$urlObj["secret"] = WxPayConfig::getConfig('APPSECRET');
		$urlObj["code"] = $code;
		$urlObj["grant_type"] = "authorization_code";
		$bizString = $this->ToUrlParams($urlObj);
		return "https://api.weixin.qq.com/sns/oauth2/access_token?".$bizString;
	}
}
