<?php
class WxPayApi
{
	/**
	 * 
	 * 统一下单
	 * @param WxPayUnifiedOrder $inputObj
	 * @param int $timeOut
	 * @throws WxPayException
	 * @return 成功时返回，其他抛异常
	 */
	public static function unifiedOrder($inputObj, $timeOut = 6)
	{
		$url = "https://api.mch.weixin.qq.com/pay/unifiedorder";
		//检测必填参数
		if(!$inputObj->IsOut_trade_noSet()) {
			throw new WxPayException("缺少统一支付接口必填参数out_trade_no！");
		}else if(!$inputObj->IsBodySet()){
			throw new WxPayException("缺少统一支付接口必填参数body！");
		}else if(!$inputObj->IsTotal_feeSet()) {
			throw new WxPayException("缺少统一支付接口必填参数total_fee！");
		}else if(!$inputObj->IsTrade_typeSet()) {
			throw new WxPayException("缺少统一支付接口必填参数trade_type！");
		}
		
		//关联参数
		if($inputObj->GetTrade_type() == "JSAPI" && !$inputObj->IsOpenidSet()){
			throw new WxPayException("统一支付接口中，缺少必填参数openid！trade_type为JSAPI时，openid为必填参数！");
		}
		if($inputObj->GetTrade_type() == "NATIVE" && !$inputObj->IsProduct_idSet()){
			throw new WxPayException("统一支付接口中，缺少必填参数product_id！trade_type为JSAPI时，product_id为必填参数！");
		}
		
		//异步通知url未设置，则使用配置文件中的url
		if(!$inputObj->IsNotify_urlSet()){
			$inputObj->SetNotify_url(WxPayConfig::getConfig('NOTIFY_URL'));//异步通知url
		}
		
		$inputObj->SetAppid(WxPayConfig::getConfig('APPID'));//公众账号ID
		$inputObj->SetMch_id(WxPayConfig::getConfig('MCHID'));//商户号
		$inputObj->SetSpbill_create_ip(requestClientIP());//终端ip	  
		//$inputObj->SetSpbill_create_ip("1.1.1.1");  	    
		$inputObj->SetNonce_str(self::getNonceStr());//随机字符串
		
		//签名
		$inputObj->SetSign();
		$xml = $inputObj->ToXml();
		
		$startTimeStamp = self::getMillisecond();//请求开始时间
		$response = self::postXmlCurl($xml, $url, false, $timeOut);
		#Log::DEBUG("unified_h5 post xml: " . ($xml).' ===response is==='.$response);
		$result = WxPayResults::Init($response);
		self::reportCostTime($url, $startTimeStamp, $result);//上报请求花费时间
		
		return $result;
	}
	
	/**
	 * 
	 * 查询订单
	 * @param WxPayOrderQuery $inputObj
	 * @param int $timeOut
	 * @throws WxPayException
	 * @return 成功时返回，其他抛异常
	 */
	public static function orderQuery($inputObj, $timeOut = 6)
	{
		$url = "https://api.mch.weixin.qq.com/pay/orderquery";
		//检测必填参数
		if(!$inputObj->IsOut_trade_noSet() && !$inputObj->IsTransaction_idSet()) {
			throw new WxPayException("订单查询接口中，out_trade_no、transaction_id至少填一个！");
		}
		$inputObj->SetAppid(WxPayConfig::getConfig('APPID'));//公众账号ID
		$inputObj->SetMch_id(WxPayConfig::getConfig('MCHID'));//商户号
		$inputObj->SetNonce_str(self::getNonceStr());//随机字符串
		
		$inputObj->SetSign();//签名
		$xml = $inputObj->ToXml();
		
		$startTimeStamp = self::getMillisecond();//请求开始时间
		$response = self::postXmlCurl($xml, $url, false, $timeOut);
		$result = WxPayResults::Init($response);
		self::reportCostTime($url, $startTimeStamp, $result);//上报请求花费时间
		
		return $result;
	}
	
	/**
	 * 
	 * 关闭订单
	 * @param WxPayCloseOrder $inputObj
	 * @param int $timeOut
	 * @throws WxPayException
	 * @return 成功时返回，其他抛异常
	 */
	public static function closeOrder($inputObj, $timeOut = 6)
	{
		$url = "https://api.mch.weixin.qq.com/pay/closeorder";
		//检测必填参数
		if(!$inputObj->IsOut_trade_noSet()) {
			throw new WxPayException("订单查询接口中，out_trade_no至少填一个！");
		}
		$inputObj->SetAppid(WxPayConfig::getConfig('APPID'));//公众账号ID
		$inputObj->SetMch_id(WxPayConfig::getConfig('MCHID'));//商户号
		$inputObj->SetNonce_str(self::getNonceStr());//随机字符串
		
		$inputObj->SetSign();//签名
		$xml = $inputObj->ToXml();
		
		$startTimeStamp = self::getMillisecond();//请求开始时间
		$response = self::postXmlCurl($xml, $url, false, $timeOut);
		$result = WxPayResults::Init($response);
		self::reportCostTime($url, $startTimeStamp, $result);//上报请求花费时间
		
		return $result;
	}

	/**
	 * 
	 * 申请退款
	 * @param WxPayRefund $inputObj
	 * @param int $timeOut
	 * @throws WxPayException
	 * @return 成功时返回，其他抛异常
	 */
	public static function refund($inputObj, $timeOut = 6)
	{
		$url = "https://api.mch.weixin.qq.com/secapi/pay/refund";
		//检测必填参数
		if(!$inputObj->IsOut_trade_noSet() && !$inputObj->IsTransaction_idSet()) {
			throw new WxPayException("退款申请接口中，out_trade_no、transaction_id至少填一个！");
		}else if(!$inputObj->IsOut_refund_noSet()){
			throw new WxPayException("退款申请接口中，缺少必填参数out_refund_no！");
		}else if(!$inputObj->IsTotal_feeSet()){
			throw new WxPayException("退款申请接口中，缺少必填参数total_fee！");
		}else if(!$inputObj->IsRefund_feeSet()){
			throw new WxPayException("退款申请接口中，缺少必填参数refund_fee！");
		}else if(!$inputObj->IsOp_user_idSet()){
			throw new WxPayException("退款申请接口中，缺少必填参数op_user_id！");
		}
		$inputObj->SetAppid(WxPayConfig::getConfig('APPID'));//公众账号ID
		$inputObj->SetMch_id(WxPayConfig::getConfig('MCHID'));//商户号
		$inputObj->SetNonce_str(self::getNonceStr());//随机字符串
		
		$inputObj->SetSign();//签名
		$xml = $inputObj->ToXml();
		$startTimeStamp = self::getMillisecond();//请求开始时间
		$response = self::postXmlCurl($xml, $url, true, $timeOut);
		$result = WxPayResults::Init($response);
		self::reportCostTime($url, $startTimeStamp, $result);//上报请求花费时间
		
		return $result;
	}
	
	/**
	 * 
	 * 查询退款
	 * 提交退款申请后，通过调用该接口查询退款状态。退款有一定延时，
	 * 用零钱支付的退款20分钟内到账，银行卡支付的退款3个工作日后重新查询退款状态。
	 * @param WxPayRefundQuery $inputObj
	 * @param int $timeOut
	 * @throws WxPayException
	 * @return 成功时返回，其他抛异常
	 */
	public static function refundQuery($inputObj, $timeOut = 6)
	{
		$url = "https://api.mch.weixin.qq.com/pay/refundquery";
		//检测必填参数
		if(!$inputObj->IsOut_refund_noSet() &&
			!$inputObj->IsOut_trade_noSet() &&
			!$inputObj->IsTransaction_idSet() &&
			!$inputObj->IsRefund_idSet()) {
			throw new WxPayException("退款查询接口中，out_refund_no、out_trade_no、transaction_id、refund_id四个参数必填一个！");
		}
		$inputObj->SetAppid(WxPayConfig::getConfig('APPID'));//公众账号ID
		$inputObj->SetMch_id(WxPayConfig::getConfig('MCHID'));//商户号
		$inputObj->SetNonce_str(self::getNonceStr());//随机字符串
		
		$inputObj->SetSign();//签名
		$xml = $inputObj->ToXml();
		
		$startTimeStamp = self::getMillisecond();//请求开始时间
		$response = self::postXmlCurl($xml, $url, false, $timeOut);
		$result = WxPayResults::Init($response);
		self::reportCostTime($url, $startTimeStamp, $result);//上报请求花费时间
		
		return $result;
	}
	
	/**
	 * 下载对账单
	 * @param WxPayDownloadBill $inputObj
	 * @param int $timeOut
	 * @throws WxPayException
	 * @return 成功时返回，其他抛异常
	 */
	public static function downloadBill($inputObj, $timeOut = 6)
	{
		$url = "https://api.mch.weixin.qq.com/pay/downloadbill";
		//检测必填参数
		if(!$inputObj->IsBbill_dateSet()) {
			throw new WxPayException("对账单接口中，缺少必填参数bill_date！");
		}
		$inputObj->SetAppid(WxPayConfig::getConfig('APPID'));//公众账号ID
		$inputObj->SetMch_id(WxPayConfig::getConfig('MCHID'));//商户号
		$inputObj->SetNonce_str(self::getNonceStr());//随机字符串
		
		$inputObj->SetSign();//签名
		$xml = $inputObj->ToXml();
		
		$response = self::postXmlCurl($xml, $url, false, $timeOut);
		if(substr($response, 0 , 5) == "<xml>"){
			return "";
		}
		return $response;
	}
	
	/**
	 * 提交被扫支付API
	 * 收银员使用扫码设备读取微信用户刷卡授权码以后，二维码或条码信息传送至商户收银台，
	 * 由商户收银台或者商户后台调用该接口发起支付。
	 * @param WxPayWxPayMicroPay $inputObj
	 * @param int $timeOut
	 */
	public static function micropay($inputObj, $timeOut = 10)
	{
		$url = "https://api.mch.weixin.qq.com/pay/micropay";
		//检测必填参数
		if(!$inputObj->IsBodySet()) {
			throw new WxPayException("提交被扫支付API接口中，缺少必填参数body！");
		} else if(!$inputObj->IsOut_trade_noSet()) {
			throw new WxPayException("提交被扫支付API接口中，缺少必填参数out_trade_no！");
		} else if(!$inputObj->IsTotal_feeSet()) {
			throw new WxPayException("提交被扫支付API接口中，缺少必填参数total_fee！");
		} else if(!$inputObj->IsAuth_codeSet()) {
			throw new WxPayException("提交被扫支付API接口中，缺少必填参数auth_code！");
		}
		
		$inputObj->SetSpbill_create_ip($_SERVER['REMOTE_ADDR']);//终端ip
		$inputObj->SetAppid(WxPayConfig::getConfig('APPID'));//公众账号ID
		$inputObj->SetMch_id(WxPayConfig::getConfig('MCHID'));//商户号
		$inputObj->SetNonce_str(self::getNonceStr());//随机字符串
		
		$inputObj->SetSign();//签名
		$xml = $inputObj->ToXml();
		
		$startTimeStamp = self::getMillisecond();//请求开始时间
		$response = self::postXmlCurl($xml, $url, false, $timeOut);
		$result = WxPayResults::Init($response);
		self::reportCostTime($url, $startTimeStamp, $result);//上报请求花费时间
		
		return $result;
	}
	
	/**
	 * 
	 * 撤销订单API接口
	 * @param WxPayReverse $inputObj
	 * @param int $timeOut
	 * @throws WxPayException
	 */
	public static function reverse($inputObj, $timeOut = 6)
	{
		$url = "https://api.mch.weixin.qq.com/secapi/pay/reverse";
		//检测必填参数
		if(!$inputObj->IsOut_trade_noSet() && !$inputObj->IsTransaction_idSet()) {
			throw new WxPayException("撤销订单API接口中，参数out_trade_no和transaction_id必须填写一个！");
		}
		
		$inputObj->SetAppid(WxPayConfig::getConfig('APPID'));//公众账号ID
		$inputObj->SetMch_id(WxPayConfig::getConfig('MCHID'));//商户号
		$inputObj->SetNonce_str(self::getNonceStr());//随机字符串
		
		$inputObj->SetSign();//签名
		$xml = $inputObj->ToXml();
		
		$startTimeStamp = self::getMillisecond();//请求开始时间
		$response = self::postXmlCurl($xml, $url, true, $timeOut);

		$result = WxPayResults::Init($response);
		self::reportCostTime($url, $startTimeStamp, $result);//上报请求花费时间
		
		return $result;
	}
	
	/**
	 * 
	 * 测速上报
	 * @param WxPayReport $inputObj
	 * @param int $timeOut
	 * @throws WxPayException
	 * @return 成功时返回，其他抛异常
	 */
	public static function report($inputObj, $timeOut = 1)
	{
		$url = "https://api.mch.weixin.qq.com/payitil/report";
		//检测必填参数
		if(!$inputObj->IsInterface_urlSet()) {
			throw new WxPayException("接口URL，缺少必填参数interface_url！");
		} if(!$inputObj->IsReturn_codeSet()) {
			throw new WxPayException("返回状态码，缺少必填参数return_code！");
		} if(!$inputObj->IsResult_codeSet()) {
			throw new WxPayException("业务结果，缺少必填参数result_code！");
		} if(!$inputObj->IsUser_ipSet()) {
			throw new WxPayException("访问接口IP，缺少必填参数user_ip！");
		} if(!$inputObj->IsExecute_time_Set()) {
			throw new WxPayException("接口耗时，缺少必填参数execute_time_！");
		}
		$inputObj->SetAppid(WxPayConfig::getConfig('APPID'));//公众账号ID
		$inputObj->SetMch_id(WxPayConfig::getConfig('MCHID'));//商户号
		$inputObj->SetUser_ip($_SERVER['REMOTE_ADDR']);//终端ip
		$inputObj->SetTime(date("YmdHis"));//商户上报时间	 
		$inputObj->SetNonce_str(self::getNonceStr());//随机字符串
		
		$inputObj->SetSign();//签名
		$xml = $inputObj->ToXml();
		
		$startTimeStamp = self::getMillisecond();//请求开始时间
		$response = self::postXmlCurl($xml, $url, false, $timeOut);
		return $response;
	}
	
	/**
	 * 
	 * 生成二维码规则,模式一生成支付二维码
	 * @param WxPayBizPayUrl $inputObj
	 * @param int $timeOut
	 * @throws WxPayException
	 * @return 成功时返回，其他抛异常
	 */
	public static function bizpayurl($inputObj, $timeOut = 6)
	{
		if(!$inputObj->IsProduct_idSet()){
			throw new WxPayException("生成二维码，缺少必填参数product_id！");
		}
		
		$inputObj->SetAppid(WxPayConfig::getConfig('APPID'));//公众账号ID
		$inputObj->SetMch_id(WxPayConfig::getConfig('MCHID'));//商户号
		$inputObj->SetTime_stamp(time());//时间戳	 
		$inputObj->SetNonce_str(self::getNonceStr());//随机字符串
		
		$inputObj->SetSign();//签名
		
		return $inputObj->GetValues();
	}
	
	/**
	 * 
	 * 转换短链接
	 * 该接口主要用于扫码原生支付模式一中的二维码链接转成短链接(weixin://wxpay/s/XXXXXX)，
	 * 减小二维码数据量，提升扫描速度和精确度。
	 * @param WxPayShortUrl $inputObj
	 * @param int $timeOut
	 * @throws WxPayException
	 * @return 成功时返回，其他抛异常
	 */
	public static function shorturl($inputObj, $timeOut = 6)
	{
		$url = "https://api.mch.weixin.qq.com/tools/shorturl";
		//检测必填参数
		if(!$inputObj->IsLong_urlSet()) {
			throw new WxPayException("需要转换的URL，签名用原串，传输需URL encode！");
		}
		$inputObj->SetAppid(WxPayConfig::getConfig('APPID'));//公众账号ID
		$inputObj->SetMch_id(WxPayConfig::getConfig('MCHID'));//商户号
		$inputObj->SetNonce_str(self::getNonceStr());//随机字符串
		
		$inputObj->SetSign();//签名
		$xml = $inputObj->ToXml();
		
		$startTimeStamp = self::getMillisecond();//请求开始时间
		$response = self::postXmlCurl($xml, $url, false, $timeOut);
		$result = WxPayResults::Init($response);
		self::reportCostTime($url, $startTimeStamp, $result);//上报请求花费时间
		
		return $result;
	}
	
 	/**
 	 * 
 	 * 支付结果通用通知
 	 * @param function $callback
 	 * 直接回调函数使用方法: notify(you_function);
 	 * 回调类成员函数方法:notify(array($this, you_function));
 	 * $callback  原型为：function function_name($data){}
 	 */
	public static function notify($callback, &$msg)
	{
		//如果返回成功则验证签名
		try {
			//获取通知的数据
			$xml = @$GLOBALS['HTTP_RAW_POST_DATA'];
			$result = WxPayResults::Init($xml);
		} catch (WxPayException $e){
			$msg = $e->errorMessage();
			return false;
		}
		
		return call_user_func($callback, $result);
	}
	
	/**
	 * 
	 * 产生随机字符串，不长于32位
	 * @param int $length
	 * @return 产生的随机字符串
	 */
	public static function getNonceStr($length = 32) 
	{
		if(isset($_SERVER['wx_nonce'])) return $_SERVER['wx_nonce'];
		$chars = "abcdefghijklmnopqrstuvwxyz0123456789";  
		$str ="";
		for ( $i = 0; $i < $length; $i++ )  {  
			$str .= substr($chars, mt_rand(0, strlen($chars)-1), 1);  
		} 
		return $_SERVER['wx_nonce'] = $str;
	}
	
	/**
	 * 直接输出xml
	 * @param string $xml
	 */
	public static function replyNotify($xml)
	{
		Log::DEBUG($xml);
		echo $xml;
	}
	
	/**
	 * 
	 * 上报数据
	 * @param string $usrl
	 * @param int $startTimeStamp
	 * @param array $data
	 */
	private static function reportCostTime($url, $startTimeStamp, $data)
	{
		return;
		//如果不需要上报数据
		if(WxPayConfig::getConfig('REPORT_LEVENL') == 0){
			return;
		} 
		//如果仅失败上报
		if(WxPayConfig::getConfig('REPORT_LEVENL') == 1 &&
			 array_key_exists("return_code", $data) &&
			 $data["return_code"] == "SUCCESS" &&
			 array_key_exists("result_code", $data) &&
			 $data["result_code"] == "FAIL")
		 {
		 	return;
		 }
		 
		//上报逻辑
		$endTimeStamp = self::getMillisecond();
		$objInput = new WxPayReport();
		$objInput->SetInterface_url($url);
		$objInput->SetExecute_time_($endTimeStamp - $startTimeStamp);
		//返回状态码
		if(array_key_exists("return_code", $data)){
			$objInput->SetReturn_code($data["return_code"]);
		}
		//返回信息
		if(array_key_exists("return_msg", $data)){
			$objInput->SetReturn_msg($data["return_msg"]);
		}
		//业务结果
		if(array_key_exists("result_code", $data)){
			$objInput->SetResult_code($data["result_code"]);
		}
		//错误代码
		if(array_key_exists("err_code", $data)){
			$objInput->SetErr_code($data["err_code"]);
		}
		//错误代码描述
		if(array_key_exists("err_code_des", $data)){
			$objInput->SetErr_code_des($data["err_code_des"]);
		}
		//商户订单号
		if(array_key_exists("out_trade_no", $data)){
			$objInput->SetOut_trade_no($data["out_trade_no"]);
		}
		//设备号
		if(array_key_exists("device_info", $data)){
			$objInput->SetDevice_info($data["device_info"]);
		}
		
		try{
			self::report($objInput);
		} catch (WxPayException $e){
			//不做任何处理
		}
	}

	/**
	 * 以post方式提交xml到对应的接口url
	 * Enter description here ...
	 * @param string $xml  需要post的xml数据
	 * @param string $url  url
	 * @param bool $useCert 是否需要证书，默认不需要
	 * @param int $second   url执行超时时间，默认30s
	 * @throws WxPayException
	 */
	private static function postXmlCurl($xml, $url, $useCert = false, $second = 30)
	{		
        //初始化curl        
       	$ch = curl_init();
		//设置超时
		curl_setopt($ch, CURLOPT_TIMEOUT, $second);
		
        //如果有配置代理这里就设置代理
		if(WxPayConfig::getConfig('CURL_PROXY_HOST') != "0.0.0.0" 
			&& WxPayConfig::getConfig('CURL_PROXY_PORT') != 0){
			curl_setopt($ch,CURLOPT_PROXY, WxPayConfig::getConfig('CURL_PROXY_HOST'));
			curl_setopt($ch,CURLOPT_PROXYPORT, WxPayConfig::getConfig('CURL_PROXY_PORT'));
		}
        curl_setopt($ch,CURLOPT_URL, $url);
		//设置header
		curl_setopt($ch, CURLOPT_HEADER, FALSE);
		//要求结果为字符串且输出到屏幕上
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
	
		if($useCert == true){
			//设置证书
			//使用证书：cert 与 key 分别属于两个.pem文件

			/*
				lhliu 支持一下mac os (if curl was built against Secure Transport)
      			使用p12格式的证书 
			*/
			if(false && stripos(PHP_OS, 'darwin') !== false) {
				curl_setopt($ch,CURLOPT_SSLCERT, substr(WxPayConfig::getConfig('SSLCERT_PATH'), 0, -strlen('.pem')).'.p12');
				curl_setopt($ch,CURLOPT_SSLCERTPASSWD, WxPayConfig::getConfig('MCHID'));
				echo substr(WxPayConfig::getConfig('SSLCERT_PATH'), 0, -strlen('.pem')).'.p12';
				die();
			}
			else {
				curl_setopt($ch,CURLOPT_SSLCERTTYPE,'PEM');
				curl_setopt($ch,CURLOPT_SSLCERT, WxPayConfig::getConfig('SSLCERT_PATH'));
				curl_setopt($ch,CURLOPT_SSLKEYTYPE,'PEM');
				curl_setopt($ch,CURLOPT_SSLKEY, WxPayConfig::getConfig('SSLKEY_PATH'));
				//因为微信红包在使用过程中需要验证服务器和域名，故需要设置下面两行
				//curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, true); // 只信任CA颁布的证书 
				//curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 2); // 检查证书中是否设置域名，并且是否与提供的主机名匹配


				//curl_setopt($ch,CURLOPT_CAINFO, '/home/php/code/uct_weixin/cert/31/wx/rootca.pem'); 
				Log::DEBUG('cert is ca '. WxPayConfig::getConfig('SSLCERT_PATH').'...'.WxPayConfig::getConfig('SSLKEY_PATH'));
				//Log::DEBUG('xml is '.$xml);
			}
		} else {
        		curl_setopt($ch,CURLOPT_SSL_VERIFYPEER,FALSE);
		        curl_setopt($ch,CURLOPT_SSL_VERIFYHOST,FALSE);
		}
		//post提交方式
		curl_setopt($ch, CURLOPT_POST, TRUE);
		curl_setopt($ch, CURLOPT_POSTFIELDS, $xml);
		//运行curl
        $data = curl_exec($ch);
		//返回结果
		if($data){
			curl_close($ch);
			return $data;
		} else { 
			$error = curl_errno($ch);
			curl_close($ch);
			throw new WxPayException("curl出错，错误码:$error");
		}
	}
	
	/**
	 * 获取毫秒级别的时间戳
	 */
	private static function getMillisecond()
	{
		//获取毫秒的时间戳
		$time = explode ( " ", microtime () );
		$time = $time[1] . ($time[0] * 1000);
		$time2 = explode( ".", $time );
		$time = $time2[0];
		return $time;
	}

	/*
		微信支付 对字符串 $str 进行   RSA  加密
		https://pay.weixin.qq.com/wiki/doc/api/tools/mch_pay.php?chapter=24_7&index=4
		
		返回base64 格式加密数据
	*/
	public static function wx_enc_rsa($str) {
		$mchid = WxPayConfig::getConfig('MCHID');	
		if(!isset($GLOBALS['wx_pay_public_pem'][$mchid])) {
			$url = 'https://fraud.mch.weixin.qq.com/risk/getpublickey';
			$input = new WxPayDataBase();
			$input->set('mch_id', $mchid);
			$input->set('nonce_str', self::getNonceStr());//随机字符串
			$input->set('sign_type', 'MD5');
			$input->SetSign();
			$xml = $input->ToXml();
			$response = self::postXmlCurl($xml, $url, true, 6);
			Weixin::weixin_log('['.$mchid.'] get rsa public key -> '.$response);	
			$result = WxPayResults::Init($response);
			if(empty($result['pub_key'])) {
				return false;
			}

			#xxxxxx 证书格式转换 PKCS #1  -> PKCS #8 
			if(0) {
				$result['pub_key'] = str_replace('-----BEGIN RSA PUBLIC KEY-----', '', $result['pub_key']);
				$result['pub_key'] = trim(str_replace('-----END RSA PUBLIC KEY-----', '', $result['pub_key']));
				$result['pub_key'] = 'MIICIjANBgkqhkiG9w0BAQEFAAOCAg8A' . str_replace("\n", '', $result['pub_key']);
				$result['pub_key'] = "-----BEGIN PUBLIC KEY-----\n" . wordwrap($result['pub_key'], 64, "\n", true) 
									. "\n-----END PUBLIC KEY-----";
				
				$GLOBALS['wx_pay_public_pem'][$mchid] = openssl_get_publickey($result['pub_key']);
			}

			$GLOBALS['wx_pay_public_pem'][$mchid] = $result['pub_key'];
		}
		
		uct_use_vendor('phpsec_v1');
		$rsa = new Crypt_RSA();
		$rsa->loadKey($GLOBALS['wx_pay_public_pem'][$mchid]);
		$rsa->setEncryptionMode(CRYPT_RSA_ENCRYPTION_OAEP);
		$ret = $rsa->encrypt($str);
		
		return base64_encode($ret);
	}

	/*
		支付到银行卡要求订单号最少8位
		商户订单号，需保持唯一（只允许数字[0~9]或字母[A~Z]和[a~z]，最短8位，最长32位）
	*/
	public static function pad_trade_no_to_8($no){
		if(strlen($no) >= 8) return $no;
		if($no[0] == 'z') {
			return substr($no, 0, 2) . str_pad(substr($no, 2), 6, '0', STR_PAD_LEFT);
		} else {
			return substr($no, 0, 1) . str_pad(substr($no, 1), 7, '0', STR_PAD_LEFT);
		}
	}

	/*
		支付到银行卡的17家银行编号
	*/
	public static function get_wx_support_bank($key = null) {
		$arr = array(
			'招商银行' => '1001',
			'工商银行' => '1002',
			'建设银行' => '1003',
			'浦发银行' => '1004',
			'农业银行' => '1005',
			'民生银行' => '1006',
			'兴业银行' => '1009',
			'平安银行' => '1010',
			'交通银行' => '1020',
			'中信银行' => '1021',
			'光大银行' => '1022',
			'华夏银行' => '1025',
			'中国银行' => '1026',
			'广发银行' => '1027',
			'北京银行' => '1032',
			'宁波银行' => '1056',
			'邮储银行' => '1066',
		);

		return $key ? (isset($arr[$key]) ? $arr[$key] : false) : $arr;
	}

	/**
	 * 
	 * 企业支付到银行卡接口  lhliu add
	参考文档 https://pay.weixin.qq.com/wiki/doc/api/tools/mch_pay.php?chapter=24_2

	 * @param WxPayDataBase $inputObj
	 * @param int $timeOut
	 * @throws WxPayException
	 * @return 成功时返回，其他抛异常
	 */
	public static function pay_bank($inputObj, $timeOut = 6)
	{
		$url = 'https://api.mch.weixin.qq.com/mmpaysptrans/pay_bank';
		//检测必填参数
		if(!$inputObj->get('partner_trade_no')) {
			throw new WxPayException("缺少企业支付到银行卡接口必填参数partner_trade_no！");
		}
		if(!$inputObj->get('enc_bank_no')) {
			throw new WxPayException("企业支付接口到银行卡中，缺少必填参数 银行卡号！");
		}
		if(!$inputObj->get('enc_true_name')) {
			throw new WxPayException("企业支付接口到银行卡中，缺少必填参数 用户名！");
		}
		if(!$inputObj->get('bank_code')) {
			throw new WxPayException("企业支付接口到银行卡中，缺少必填参数 开户行！");
		}
		
		$inputObj->set('partner_trade_no', self::pad_trade_no_to_8($inputObj->get('partner_trade_no')));
		$inputObj->set('enc_bank_no', self::wx_enc_rsa($inputObj->get('enc_bank_no')));
		$inputObj->set('enc_true_name', self::wx_enc_rsa($inputObj->get('enc_true_name')));
		$inputObj->set('bank_code', self::get_wx_support_bank($inputObj->get('bank_code')));
		if(!$inputObj->get('amount')) {
			throw new WxPayException("企业支付接口到银行卡中，缺少必填参数 付款金额！");
		}
		if($inputObj->get('desc') === false) {
			throw new WxPayException("企业支付到银行接口中，缺少必填参数 说明信息！");
		}
		
		
		$inputObj->set('mch_id', WxPayConfig::getConfig('MCHID'));//商户号
		$inputObj->set('nonce_str', self::getNonceStr());//随机字符串
		
		//签名
		$inputObj->SetSign();
		$xml = $inputObj->ToXml();
		
		$startTimeStamp = self::getMillisecond();//请求开始时间
		
		Weixin::weixin_log('xml go ..' . $xml);
		$response = self::postXmlCurl($xml, $url, true, $timeOut);
		$result = WxPayResults::Init($response);
		self::reportCostTime($url, $startTimeStamp, $result);//上报请求花费时间
		
		return $result;
	}
	
	/**
	 * 
	 * 企业支付接口  lhliu add
	参考文档 http://pay.weixin.qq.com/wiki/doc/api/mch_pay.php?chapter=14_2

	 * @param WxPayDataBase $inputObj
	 * @param int $timeOut
	 * @throws WxPayException
	 * @return 成功时返回，其他抛异常
	 */
	public static function transfers($inputObj, $timeOut = 6)
	{
		$url = 'https://api.mch.weixin.qq.com/mmpaymkttransfers/promotion/transfers';
		//检测必填参数
		if(!$inputObj->get('partner_trade_no')) {
			throw new WxPayException("缺少企业支付接口必填参数partner_trade_no！");
		}
		if(!$inputObj->get('openid')) {
			throw new WxPayException("企业支付接口中，缺少必填参数openid！");
		}
		if(!$inputObj->get('amount')) {
			throw new WxPayException("企业支付接口中，缺少必填参数 付款金额！");
		}
		if(in_array($inputObj->get('check_name'), array('OPTION_CHECK', 'FORCE_CHECK')) && 
			!($inputObj->get('re_user_name'))) {
			throw new WxPayException("企业支付接口中，缺少必填参数 收款用户姓名！");
		}
		if($inputObj->get('desc') === false) {
			throw new WxPayException("企业支付接口中，缺少必填参数 说明信息！");
		}
		
		
		$inputObj->set('mch_appid', WxPayConfig::getConfig('APPID'));//公众账号ID
		$inputObj->set('mchid', WxPayConfig::getConfig('MCHID'));//商户号
		$inputObj->set('spbill_create_ip', requestClientIP());//终端ip	  
		$inputObj->set('nonce_str', self::getNonceStr());//随机字符串
		
		//签名
		$inputObj->SetSign();
		$xml = $inputObj->ToXml();
		
		$startTimeStamp = self::getMillisecond();//请求开始时间
		$response = self::postXmlCurl($xml, $url, true, $timeOut);
		$result = WxPayResults::Init($response);
		self::reportCostTime($url, $startTimeStamp, $result);//上报请求花费时间
		
		return $result;
	}
	
	/**
	 * 
	 * 发红包接口  lhliu add
	参考文档 http://pay.weixin.qq.com/wiki/doc/api/cash_coupon.php?chapter=13_5

	 * @param WxPayDataBase $inputObj
	 * @param int $timeOut
	 * @throws WxPayException
	 * @return 成功时返回，其他抛异常
	 */
	public static function redpack($inputObj, $timeOut = 6)
	{
		$url = 'https://api.mch.weixin.qq.com/mmpaymkttransfers/sendredpack ';
		//检测必填参数
		if(!$inputObj->get('mch_billno')) {
			throw new WxPayException("缺少红包接口必填参数 商户订单号mch_billno！");
		}
		if(!$inputObj->get('re_openid')) {
			throw new WxPayException("红包接口中，缺少必填参数openid！");
		}
		/*if($inputObj->get('nick_name') === false) {
			throw new WxPayException("红包接口中，缺少必填参数 提供方名称！");
		}*/
		if($inputObj->get('send_name') === false) {
			throw new WxPayException("红包接口中，缺少必填参数 红包发送者名称！");
		}
		if(!$inputObj->get('total_amount')) {
			throw new WxPayException("红包接口中，缺少必填参数 付款金额！");
		}
		/*if(!$inputObj->get('min_value')) {
			throw new WxPayException("红包接口中，缺少必填参数 最小红包金额！");
		}
		if(!$inputObj->get('max_value')) {
			throw new WxPayException("红包接口中，缺少必填参数 最大红包金额！");
		}*/
		if(!$inputObj->get('total_num')) {
			throw new WxPayException("红包接口中，缺少必填参数 红包发放总人数！");
		}
		if($inputObj->get('wishing') === false) {
			throw new WxPayException("红包接口中，缺少必填参数 红包祝福语！");
		}
		if($inputObj->get('act_name') === false) {
			throw new WxPayException("红包接口中，缺少必填参数 活动名称！");
		}
		if($inputObj->get('remark') === false) {
			throw new WxPayException("红包接口中，缺少必填参数 备注信息！");
		}
		
		
		$inputObj->set('wxappid', WxPayConfig::getConfig('APPID'));//公众账号ID
		$inputObj->set('mch_id', WxPayConfig::getConfig('MCHID'));//商户号
		$inputObj->set('client_ip', requestClientIP());//终端ip	  
		$inputObj->set('nonce_str', self::getNonceStr());//随机字符串
		
		//签名
		$inputObj->SetSign();
		$xml = $inputObj->ToXml();
		
		$startTimeStamp = self::getMillisecond();//请求开始时间
		$response = self::postXmlCurl($xml, $url, true, $timeOut);
		$result = WxPayResults::Init($response);
		self::reportCostTime($url, $startTimeStamp, $result);//上报请求花费时间
		
		return $result;
	}
	
}

