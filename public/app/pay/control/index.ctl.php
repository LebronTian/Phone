<?php
/*
	通用收银台
*/
class IndexCtl {
	public function __construct() {
		//todo 收银台模板
		$GLOBALS['_UCT']['TPL'] = 'uct';
	}

	/*
		获取订单信息
	*/
	protected function init_order_info() {
		if(!($oid = requestString('oid', PATTERN_ORDER_UID)) ||
			!($cls = PayMod::get_order_by_oid($oid)) ||
			!($info = $cls->GetOrderInfo())) {
			header("Content-Type: text/html; charset=utf-8");
			echo '收银台参数错误!'; exit;
		}
		/*
			检查访问权限
			todo	
			可以支持发起代付款
		*/
		$sp_uid = AccountMod::has_sp_login();
		$su_uid = AccountMod::has_su_login();
		if($info['sp_uid'] == 0) {//服务订单
			if($info['su_uid'] != $sp_uid) {
				$not_allow = 1;
			}
		}
		else {//其他订单
			if($info['su_uid'] != $su_uid && $info['sp_uid'] != $sp_uid) {
				$not_allow = 1;
			}
		}
		if(0 && !empty($not_allow)) {
			header("Content-Type: text/html; charset=utf-8");
			echo '收银台参数错误1!'; exit;
		}
		$info = PayMod::extend_order_info($info);
		if($pi = $cls->PreparePayInfo()) {
			$info = array_merge($info, $pi);
		}

		return $info;
	}

	/*
		收银台, 选择支付方式
	*/
	public function index() {
		$info = $this->init_order_info();
		if($info['sp_uid'] == 1054) {
			redirectTo('?_a=pay&_u=index.huarongwxwap&oid='.$info['trade_no']);
			return;
		}

		$params = array('info' => $info);
		render_fg('', $params);
	}

	/*
		测试支付
	*/
	public function test() {
		if(!defined('DEBUG_WXPAY') || !DEBUG_WXPAY) {
			//exit;	
		}

		if($_SERVER['REQUEST_METHOD'] == 'POST') {
			if(!($oid = requestString('oid', PATTERN_ORDER_UID))) {
				outError(ERROR_INVALID_REQUEST_PARAM);
			} 

			outRight(PayMod::test_pay($oid));
		}

		$info = $this->init_order_info();
		if((getLastError() == ERROR_BAD_STATUS)) {
			header("Content-Type: text/html; charset=utf-8");
			echo '该订单无需支付! <a href="'.$info['return_url'].'">点击返回</a>';exit;
		}

		if(!(PayMod::is_sp_testpay_available($info['sp_uid']))) {
			header("Content-Type: text/html; charset=utf-8");
			echo '测试支付已关闭!';exit;
		}
		$params = array('info' => $info);
		render_fg('', $params);
	}

	/*
		微信扫码支付
	*/
	public function wxnative2() {
		$info = $this->init_order_info();
		if((getLastError() == ERROR_BAD_STATUS)) {
			header("Content-Type: text/html; charset=utf-8");
			echo '该订单无需支付! <a href="'.$info['return_url'].'">点击返回</a>';exit;
		}

		if(!($cfg = PayMod::is_sp_weixinpay_available($info['sp_uid']))) {
			header("Content-Type: text/html; charset=utf-8");
			echo '微信支付配置错误!';exit;
		}
		if(!empty($cfg['spname']) && !PayMod::is_sp_uctpay_available($info['sp_uid'])) $info['spname'] = $cfg['spname'];

		$params = array('info' => $info, 'cfg' => $cfg);
		render_fg('', $params);
	}

	/*
		微信客户端H5支付
	    无感支付前端代码
        pay: function(uid) {
            var oid = 'b'+uid
            if($('#oid'+oid).length==0){
                var script = document.createElement("script");
                script.type = "text/javascript";
                script.src = "?_a=pay&_u=index.wxjs&ACT=wxjs_call&oid="+oid;
                script.id = "oid"+oid;
                document.body.appendChild(script);
            }else{
                eval('__wxjs_call_'+oid+'.callpay()')
            }
            return
        }
	*/
	public function wxjs() {
		if(!(defined('DEBUG_WXPAY') && DEBUG_WXPAY) && !isWeixinBrowser()) {
			header("Content-Type: text/html; charset=utf-8");
			echo '微信H5支付只能在微信客户端使用!';exit;
		}

		$info = $this->init_order_info();
		if((getLastError() == ERROR_BAD_STATUS)) {
			header("Content-Type: text/html; charset=utf-8");
			echo '该订单无需支付! <a href="'.$info['return_url'].'">点击返回</a>';exit;
		}

		if(!($cfg = PayMod::is_sp_weixinpay_available($info['sp_uid']))) {
			header("Content-Type: text/html; charset=utf-8");
			echo '微信支付配置错误!';exit;
		}
		WxPayMod::setConfig($cfg);
		if(!empty($cfg['spname']) && !PayMod::is_sp_uctpay_available($info['sp_uid'])) $info['spname'] = $cfg['spname'];
	
		if(!empty($_REQUEST['auto_openid'])) {
		$info['openid'] = SuMod::require_open_id();
		#var_export(getLastError());
		#var_export($info['openid']);die;
		} else {
        //默认openid
        if($su_uid = AccountMod::has_su_login()) {
            $info['openid'] =  Dba::readOne('select open_id from weixin_fans where su_uid = '.$su_uid);
        }
		//指定openid
		if(isset($_REQUEST['openid'])) $info['openid'] = requestString('openid', PATTERN_TOKEN);
		}

		//debug
		if((defined('DEBUG_WXPAY') && DEBUG_WXPAY)) {
			$info['trade_no'] = $info['trade_no'];
			$info['openid']   = 'oWhGnjjYvTd0aQf-IRH9w4KJM6vU';
			$jsApiParameters  = '{}';
		}
		else {
			if(!($jsApiParameters = WxPayMod::get_unified_h5_js_param($info))) {
				header("Content-Type: text/html; charset=utf-8");
				echo '微信H5支付错误!请重新下单!';exit;
			}
		}

		//api
		if(isAjax()) {
			$ret = array('oid' => $info['trade_no'], 'return_url' => $info['return_url'], 'jsApiParameters' => json_decode($jsApiParameters, true));
			outRight($ret);	
		}
		else {
			$params = array('info' => $info, 'cfg' => $cfg, 'jsApiParameters' => $jsApiParameters);
            empty($_GET['TPL']) || $GLOBALS['_UCT']['TPL'] = checkString($_GET['TPL'], PATTERN_NORMAL_STRING);
            empty($_GET['APP']) || $GLOBALS['_UCT']['APP'] = checkString($_GET['APP'], PATTERN_NORMAL_STRING);
            empty($_GET['ACT']) || $GLOBALS['_UCT']['ACT'] = checkString($_GET['ACT'], PATTERN_NORMAL_STRING);
			render_fg('', $params);
		}
	}

	/*
		微信客户端APP支付
	*/
	public function wxapp() {
		$info = $this->init_order_info();
		if((getLastError() == ERROR_BAD_STATUS)) {
			outError();
		}

		/* kuaidilaila app
		if(!($cfg = PayMod::is_sp_weixinpay_available($info['sp_uid']))) {
			//echo '微信支付配置错误!';exit;
			outError(ERROR_SERVICE_NOT_AVAILABLE);
		}
		*/
		
		$cfg = array(
			'APPID' => 'wxc57b15993cea8f69',
			'APPSECRET' => '40b5bddf128204a350a8c1188ebe3b4a',
			'MCHID' => '1326749801',
			'KEY' => 'db3aa5ca1dd97febbd3299c79b9bd012',
			'SSLCERT_PATH' => CERT_PATH.'578/wx/app/apiclient_cert.pem',
			'SSLKEY_PATH' => CERT_PATH.'578/wx/app/apiclient_key.pem',
		);
		WxPayMod::setConfig($cfg);
		if(!empty($cfg['spname']) && !PayMod::is_sp_uctpay_available($info['sp_uid'])) $info['spname'] = $cfg['spname'];

		if(!($appParameters = WxPayMod::get_unified_app_param($info))) {
			//echo '微信H5支付错误!请重新下单!';exit;
			outError();
		}

		//5分钟后自动刷新一下订单状态 防止没有回调
		Queue::do_job_at($_SERVER['REQUEST_TIME'] + 5 * 60, 'Pay_Wxapp_AutoupdateJob', array($info['trade_no']));
		//api
		$ret = array('oid' => $info['trade_no'], 'return_url' => $info['return_url'], 'appParameters' => $appParameters);
		outRight($ret);	
	}

	/*
		app	todo
	*/
	public function wxapp_update_order() {
		if(!($oid = requestString('oid', PATTERN_ORDER_UID))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		$cfg = array(
			'APPID' => 'wxc57b15993cea8f69',
			'APPSECRET' => '40b5bddf128204a350a8c1188ebe3b4a',
			'MCHID' => '1326749801',
			'KEY' => 'db3aa5ca1dd97febbd3299c79b9bd012',
			'SSLCERT_PATH' => CERT_PATH.'578/wx/app/apiclient_cert.pem',
			'SSLKEY_PATH' => CERT_PATH.'578/wx/app/apiclient_key.pem',
		);
		WxPayMod::setConfig($cfg);
		outRight(WxPayMod::query_and_update_weixin_order(array('trade_no' => $oid)));
	}


	/*
		微信小程序支付
	*/
	public function wxxiaochengxu() {
		$info = $this->init_order_info();
		if((getLastError() == ERROR_BAD_STATUS)) {
			outError();
		}

		$public_uid = WeixinMod::get_current_weixin_public('uid');
		if(!$info['openid'] = requestString('openid', PATTERN_NORMAL_STRING)) {
			$info['openid'] = Dba::readOne('select open_id from weixin_fans_xiaochengxu where su_uid = '.$info['su_uid'].' && public_uid="'.$public_uid.'"');
		}

		if(!($cfg = PayMod::is_sp_xiaochengxupay_available($public_uid))) {
			outError(ERROR_SERVICE_NOT_AVAILABLE);
		}
		WxPayMod::setConfig($cfg);
		if(!empty($cfg['spname']) && !PayMod::is_sp_uctpay_available($info['sp_uid'])) $info['spname'] = $cfg['spname'];

		if(!($xiaochengxuParameters = WxPayMod::get_unified_xiaochengxu_param($info))) {
			//echo '微信H5支付错误!请重新下单!';exit;
			outError();
		}

		//5分钟后自动刷新一下订单状态 防止没有回调
		Queue::do_job_at($_SERVER['REQUEST_TIME'] + 5 * 60, 'Pay_Wxxiaochengxu_AutoupdateJob', array($info['trade_no']));
		//api
		$ret = array('oid' => $info['trade_no'], 'return_url' => $info['return_url'], 'xiaochengxuParameters' => $xiaochengxuParameters);
		outRight($ret);	
	}

	public function wxxiaochengxu_update_order() {
		if(!($oid = requestString('oid', PATTERN_ORDER_UID))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		$public_uid = WeixinMod::get_current_weixin_public('uid');
		if(!($cfg = PayMod::is_sp_xiaochengxupay_available($public_uid))) {
			outError(ERROR_SERVICE_NOT_AVAILABLE);
		}
		WxPayMod::setConfig($cfg);
		outRight(WxPayMod::query_and_update_weixin_order(array('trade_no' => $oid)));
	}





	/*
		支付宝即时到帐
	*/
	public function alipaydirect() {
		$info = $this->init_order_info();
		if((getLastError() == ERROR_BAD_STATUS)) {
			echo '该订单无需支付! <a href="'.$info['return_url'].'">点击返回</a>';exit;
		}

		if(!($cfg = PayMod::is_sp_alipay_available($info['sp_uid']))) {
			echo '支付宝配置错误!';exit;
		}
		if(!empty($cfg['spname']) && !PayMod::is_sp_uctpay_available($info['sp_uid'])) $info['spname'] = $cfg['spname'];

		$params = array('info' => $info, 'cfg' => $cfg);
		render_fg('', $params);
	}

	/*
		余额支付
	*/
	public function balance() {
		if($_SERVER['REQUEST_METHOD'] == 'POST') {
			if(!($oid = requestString('oid', PATTERN_ORDER_UID))) {
				outError(ERROR_INVALID_REQUEST_PARAM);
			} 

			outRight(PayMod::balance_pay($oid));
		}

		uct_use_app('su');
		$su_uid = SuMod::require_su_uid();	
		$point = SuPointMod::get_user_points_by_su_uid($su_uid);

		$info = $this->init_order_info();
		if((getLastError() == ERROR_BAD_STATUS)) {
			echo '该订单无需支付! <a href="'.$info['return_url'].'">点击返回</a>';exit;
		}

		if(!($cfg = PayMod::is_sp_balancepay_available($info['sp_uid']))) {
			echo '余额支付配置错误!';exit;
		}
		if(!empty($cfg['spname']) && !PayMod::is_sp_uctpay_available($info['sp_uid'])) $info['spname'] = $cfg['spname'];

		$params = array('info' => $info, 'cfg' => $cfg, 'point' => $point);
		render_fg('', $params);
	}

	/*
		获取提现设置
	*/
	public function get_wd_cfg() {
		$sp_uid = AccountMod::require_sp_uid();
		outRight(WithdrawMod::get_sp_withdraw($sp_uid));
	}

	/*
		获取银行列表
	*/
	public function get_banks() {
		require_once UCT_PATH.'vendor/WxpayAPI_php_v3/include.php';
		$banks = WxPayApi::get_wx_support_bank();
		$banks = array_keys($banks);
		
		outRight($banks);
	}

	/*
		用户提现
	*/
	public function do_withdraw() {
		if($_SERVER['REQUEST_METHOD'] == 'POST') {
			if(!$wd['su_uid'] = AccountMod::has_su_login()) {
				outError(ERROR_USER_HAS_NOT_LOGIN);
			}

			if(($wd['cash'] = requestInt('cash')) <= 0) { //提现金额，单位为分
				outError(ERROR_INVALID_REQUEST_PARAM);
			}

			$wd['info'] = '自助提现';
			$wd['sp_uid'] = AccountMod::require_sp_uid();
			
			outRight(WithdrawMod::do_withdraw($wd));
		}

		uct_use_app('su');
		$su_uid = SuMod::require_su_uid();
		$point = SuPointMod::get_user_points_by_su_uid($su_uid);
		$cfg = WithdrawMod::get_sp_withdraw(AccountMod::require_sp_uid());
		$info = array('sp_uid' => AccountMod::require_sp_uid(), 'su_uid' => $su_uid);

		$info = PayMod::extend_order_info($info);
		$params = array('point' => $point, 'cfg' => $cfg, 'info' => $info);
		render_fg('', $params);
	}

	/*
		华融微信支付
		仅用于茅台酒商城
	*/
	public function huarongwxwap() {
		return $this->huarongkuaijie();
		return $this->huarongb2c();

		$info = $this->init_order_info();
		if((getLastError() == ERROR_BAD_STATUS)) {
			outError();
		}
		if($info['sp_uid'] != 1054) {
			outError(ERROR_SERVICE_NOT_AVAILABLE);	
		}

		include UCT_PATH.'vendor/hrwxpay/Hrpay_Wxpay.class.php';
		$params_arr = array('requestno' => date('YmdHis', $info['create_time']), 
				'orderNo' => $info['trade_no'].''.rand(1000,9999),
				'transAmt' => $info['total_fee'],
				'title' => $info['title']);

		$hrpay_wxpay  = new Hrpay_Wxpay($params_arr,'');
		$return_param = $hrpay_wxpay->qrpay();

		/*
		array ( 'codeUrl' => 'weixin://wxpay/bizpayurl?pr=PsJuLMt', 'commodityName' => '郑世茅酒三十年 ', 'imgUrl' => 'http://www.ryfpay.com/payment-gate-web/gateway/api/getQRCodeImage?weixin://wxpay/bizpayurl?pr=PsJuLMt', 'merNo' => '850520089993957', 'notifyUrl' => 'http://weixin.uctphp.com/vendor/hrwxpay/notify_url.php', 'orderDate' => '20170606', 'orderNo' => 'b376', 'productId' => '0108', 'requestNo' => '20170606115513', 'respCode' => 'P000', 'respDesc' => '交易处理中', 'returnUrl' => 'http://weixin.uctphp.com/vendor/hrwxpay/return_url.php', 'transAmt' => '569900', 'transId' => '17', 'version' => 'V1.0', 'signature' => 'aFv9CHQ5Na4oRNhMGeLdfsOpLb7RkQ5VahkCJk9dNNo5rmhNwkf/zoj8qWNqAI229zZA+7l4AKQKllNDkoHebd96jmLyzQOqiXT3Ysv5112E7NoDa2IQkSevKG2TaBlO0R4I6/wM9hHjXWw/Y6E3GAgjHXqKckhn6QYn2FRWMubSJ37cL9VgmyzKJum08/bmTBAOpODbMTrdwavcrMswtUQLn5uxmsNl9Krsy44Fupv3wKcLKQAZvedJ/EITUE5YXEnXkIu9O39bPL38u4UdTQUEZI56Gpz9ALbSD7GadLhU7lzeLuMk4S+ZNnbp7YCRkYARQ7hXPfaTnOon/ZNQ3A==', )
		*/
		//var_export($return_param);
		//outRight($ret);	
		if(!$return_param || empty($return_param['imgUrl'])) {
			Weixin::weixin_log(var_export($return_param, true));
			outError(ERROR_DBG_STEP_1);	
		}

		header('content-type:text/html; charset=utf8');
		echo '<body style="text-align:center;">';
		echo '<h2 style="margin-top:200px;">请长按识别二维码进行付款</h2>';
		echo '<img style="width:480px;height:480px;" src="'.$return_param['imgUrl'].'">';
		echo '</body>';
		
	}

	/*
		华融微信支付
		仅用于茅台酒商城
	*/
	public function huarongb2c() {
		$info = $this->init_order_info();
		if((getLastError() == ERROR_BAD_STATUS)) {
			outError();
		}
		if($info['sp_uid'] != 1054) {
			outError(ERROR_SERVICE_NOT_AVAILABLE);	
		}

		include UCT_PATH.'vendor/hrwxpay/Hrpay_Wxpay.class.php';
		$params_arr = array('requestNo' => date('YmdHis', $info['create_time']), 
				'orderNo' => $info['trade_no'].''.rand(1000,9999),
				'transAmt' => $info['total_fee'],
				'goodsname' => $info['title'],
				#'bankCode' => 'BOC',
			);
if(!$bank = requestString('bank')) {
$bs = array(
'ICBC'=>'工商银行',
'ABC'=>'农业银行',
'BOC'=>'中国银行',
'CCB'=>'建设银行',
'CMB'=>'招商银行',
'BOCM'=>'交通银行',
'CMBC'=>'民生银行',
'CNCB'=>'中信银行',
'CEBB'=>'光大银行',
'CIB'=>'兴业银行',
'BOB'=>'北京银行',
'GDB'=>'广发银行',
'HXB'=>'华夏银行',
'PSBC'=>'邮储银行',
'SPDB'=>'浦发银行',
'PAB'=>'平安银行',
'BOS'=>'上海银行',
'HCCB'=>'杭州银行',
'ZSBK'=>'浙商银行',
'QDBK'=>'青岛银行',
'NBCB'=>'宁波银行',
'TCCB'=>'天津银行',
'LZB'=>'兰州银行',
'NJCB'=>'南京银行',
'CDCB'=>'成都银行',
'BJRC'=>'北京农村商业银行',
'SHRB'=>'上海农村商业银行',
);
			header("Content-Type: text/html; charset=utf-8");
echo '
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no">
<title>支付</title>
</head>
<body style="text-align:center;">
<h2>请选择支付银行</h2>
<form style="font-size:2em;" name="hrb2cpay" action="?_a=pay&_u=index.huarongb2c&oid='.$info['trade_no'].'" method="post">
<select name="bank">';
foreach($bs as $k=>$v) {
echo '<option value="'.$k.'">'.$v.'</option>';
}

echo '</select><input type="submit" name="" value="确定">
</form>
</body>
</html>';

return;
} 
	$params_arr['bankCode'] =  $bank;


		$hrpay_wxpay  = new Hrpay_Wxpay($params_arr,'');
		$return_param = $hrpay_wxpay->b2cpay();

		/*
array ( 'requestNo' => NULL, 'version' => 'V1.0', 'productId' => '0208', 'transId' => '12', 'merNo' => '850520089993957', 'orderDate' => '20170627', 'orderNo' => 'b4069985', 'returnUrl' => 'http://weixin.uctphp.com/vendor/hrwxpay/return_url.php', 'notifyUrl' => 'http://weixin.uctphp.com/vendor/hrwxpay/notify_url.php', 'transAmt' => 10000, 'commodityName' => 'xxxxx', 'bankCode' => 'BOC', 'signature' => '0tnKpKaxDHbwgsnRlq2P6PXIR5vwBekLq07m7XN1+0VElBKwnLzuqi7uS4R92moyWrVUcfYAZnFqZUaUU5sJ20ggyVyH/9tIZeVMUeQznb2bcQQFbUiffTTJ95tWGQMCgeWbTbaWzZngue13wdN8rSRxlWrzPKfqGEcV3avJfSVxZLkZoNHsBPG0nl3r5rqehPXZ6/bxbSw6WH7df2c5ShsxUOa9q9+3S522Yf05zLZACYKEOHgKcm0zngtaIvQG6tiyWI+nl5xWEWUNEZbCVGQRT90rSVebmTB80LsXTZZMngqz/MqjEax9T0NyBsbs1hQS3IEF4Vf8mpQr2AzTEQ==', ){"errno":0,"errstr":"ERROR_OK","data":null,"errpos":""}
		*/
/*
		var_export($return_param);return;
		if(!$return_param || empty($return_param['signature'])) {
			Weixin::weixin_log(var_export($return_param, true));
			outError(ERROR_DBG_STEP_1);	
		}
*/

		//var_export($return_param);return;
		$url = "http://www.ryfpay.com/payment-gate-web/gateway/api/backTransReq";
		$params_post = $return_param;
echo '
<html>
<head>
<title>支付</title>
</head>
<body onLoad="document.hrpay.submit();">
<form name="hrpay" action="'.$url.'" method="post">
<input type="hidden" name="requestNo" value="'.$params_post['requestNo'].'">
<input type="hidden" name="version" value="'.$params_post['version'].'">
<input type="hidden" name="productId" value="'.$params_post['productId'].'">
<input type="hidden" name="transId" value="'.$params_post['transId'].'">
<input type="hidden" name="merNo" value="'.$params_post['merNo'].'">
<input type="hidden" name="orderDate" value="'.$params_post['orderDate'].'">
<input type="hidden" name="orderNo" value="'.$params_post['orderNo'].'">
<input type="hidden" name="returnUrl" value="'.$params_post['returnUrl'].'">
<input type="hidden" name="notifyUrl" value="'.$params_post['notifyUrl'].'">
<input type="hidden" name="transAmt" value="'.$params_post['transAmt'].'">
<input type="hidden" name="commodityName" value="'.$params_post['commodityName'].'">
<input type="hidden" name="bankCode" value="'.$params_post['bankCode'].'">
<input type="hidden" name="signature" value="'.$params_post['signature'].'">
</form>
</body>
</html>';
	}

	/*
		华融快捷支付
		仅用于茅台酒商城
	*/
	public function huarongkuaijie() {
		$info = $this->init_order_info();
		if((getLastError() == ERROR_BAD_STATUS)) {
			outError();
		}
		if($info['sp_uid'] != 1054) {
			outError(ERROR_SERVICE_NOT_AVAILABLE);	
		}

		include UCT_PATH.'vendor/hrwxpay/Hrpay_Wxpay.class.php';
$requestno = requestString('requestno');
$orderno = requestString('orderno');
$vericode= requestString('vericode');
if(!$requestno || !$orderno || !$vericode) {
		$params_arr = array('requestNo' => date('YmdHis', $info['create_time']), 
				'orderNo' => $info['trade_no'].''.rand(1000,9999),
				'transAmt' => $info['total_fee'],
				'goodsname' => $info['title'],
				#'bankCode' => 'BOC',
			);
		$cardIdcardNo = requestString('cardidcardno'); //身份证
		$cardName = requestString('cardname'); //持卡人姓名
		$cardNo = requestString('cardno'); //银行卡
		$phoneNo= requestString('phoneno'); //手机号码
		$cardType= requestString('cardtype'); //01 借记卡 02 贷记卡
if(!$cardIdcardNo || !$cardNo || !$cardType || !$phoneNo) {
			header("Content-Type: text/html; charset=utf-8");
echo '
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no">
<title>支付</title>
</head>
<body style="text-align:center;">
<h2>华融快捷支付</h2>
<form style="font-size:2em;" name="hrb2cpay" action="?_a=pay&_u=index.huarongkuaijie&oid='.$info['trade_no'].'" method="post">
<div>身份证：<input type="text" name="cardidcardno"></div>
<div>持卡人姓名：<input type="text" name="cardname"></div>
<div>手机号码：<input type="text" name="phoneno"></div>
<div>银行卡号：<input type="text" name="cardno"></div>
<div>卡片类型：<select name="cardtype">
<option value="01" selected="true">借记卡</option>
<option value="02">贷记卡</option>
</select>
</div>
<input type="submit" name="" value="确定">
</form>
</body>
</html>';

return;
} 
		$params_arr['cardIdcardNo'] =  $cardIdcardNo;
		$params_arr['cardName'] =  $cardName;
		$params_arr['phoneNo'] =  $phoneNo;
		$params_arr['cardNo'] =  $cardNo;
		$params_arr['cardType'] =  $cardType;

		$hrpay_wxpay  = new Hrpay_Wxpay($params_arr,'');
		$return_param = $hrpay_wxpay->kuaijie1pay();
		#header("Content-Type: text/html; charset=utf-8");
		#var_export($return_param);
		if(!$return_param || !isset($return_param['respCode']) || 
			$return_param['respCode'] != '0000') {
			header("Content-Type: text/html; charset=utf-8");
			echo '交易失败！'.$return_param['respDesc'].'!';
			return;
		}

			header("Content-Type: text/html; charset=utf-8");
echo '
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no">
<title>支付</title>
</head>
<body style="text-align:center;">
<h2>华融快捷支付</h2>
<form style="font-size:2em;" name="hrb2cpay" action="?_a=pay&_u=index.huarongkuaijie&oid='.$info['trade_no'].'" method="post">
<div>验证码：<input type="text" name="vericode"></div>
<div><input type="hidden" name="requestno" value="'.$params_arr['requestNo'].'"></div>
<div><input type="hidden" name="orderno" value="'.$params_arr['orderNo'].'"></div>
<input type="submit" name="" value="确定">
</form>
</body>
</html>';
return;
}
	
		$params_arr2 = array(
			'requestNo' => $requestno,
			'orderNo' => $orderno,
			'veriCode' => $vericode,
		);
		$hrpay_wxpay2  = new Hrpay_Wxpay($params_arr2,'');
		$return_param2 = $hrpay_wxpay2->kuaijie2pay();
		header("Content-Type: text/html; charset=utf-8");
		//var_export($return_param2);return;
		if(!$return_param2 || !isset($return_param2['respCode']) || 
			$return_param2['respCode'] != '0000') {
			echo '交易失败！'.$return_param['respDesc'].'!';
		} else {
			redirectTo($info['return_url']);
			echo '支付成功！';
		}
	}

}

