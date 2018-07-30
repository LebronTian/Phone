<?php
/*
	微信支付文档地址
	http://pay.weixin.qq.com/wiki/doc/api/index.php?chapter=6_4
*/

require_once UCT_PATH.'vendor/WxpayAPI_php_v3/include.php';
class WxPayMod {
	protected static $has_set_config = false;

	/*
		只设置一次
	*/
	public static function setConfigByOid($oid) {
		if(self::$has_set_config) {
			return;
		}	

		if(!($cls = PayMod::get_order_by_oid($oid)) ||
			!($info = $cls->PreparePayInfo())) {
			return setLastError(ERROR_INVALID_REQUEST_PARAM);
		}
		if(!($cfg = PayMod::is_sp_weixinpay_available($info['sp_uid']))) {
			return setLastError(ERROR_SERVICE_NOT_AVAILABLE);
		}
		WxPayConfig::setConfig($cfg);
		self::$has_set_config = true;
	}

	/*
		只设置一次
	*/
	public static function setConfig($cfg) {
		WxPayConfig::setConfig($cfg);
		self::$has_set_config = true;
	}

	/*
		获取微信支付通知url地址
		地址中不能包含&
	*/
	public static function get_weixin_notify_url() {
		return getUrlName().'/app/pay/weixin.notify2.php';
	}

	/*
		生成URL 扫码支付模式一
		支付回调地址在微信后台设置
	*/
	public static function get_native1_url($product_uid) {
		$notify = new NativePay();
		return $notify->GetPrePayUrl($product_uid);
	}

	/*
		返回结构
		array ( 'appid' => 'wx426b3015555a46be', 'code_url' => 'weixin://wxpay/bizpayurl?pr=X4JuzUT', 'mch_id' => '1225312702', 'nonce_str' => '13vxSItaP3ymhAP4', 'prepay_id' => 'wx20150518151350a9b6ed76240104616506', 'result_code' => 'SUCCESS', 'return_code' => 'SUCCESS', 'return_msg' => 'OK', 'sign' => 'B9A432198F334A8DAEA7244599B0EA9E', 'trade_type' => 'NATIVE', )
	*/
	public static function get_native2_url($option) {
		$input = new WxPayUnifiedOrder();
		$input->SetTrade_type('NATIVE');

		$input->SetBody($option['body']);
		$input->SetAttach($option['attach']);
		$input->SetOut_trade_no($option['trade_no']);
		self::setConfigByOid($option['trade_no']);
		$input->SetTotal_fee($option['total_fee']);
		$input->SetTime_start($option['time_start']);
		$input->SetTime_expire($option['time_expire']);
		$input->SetGoods_tag($option['goods_tag']);
		$input->SetNotify_url($option['notify_url']);
		$input->SetProduct_id($option['product_uid']);

		$notify = new NativePay();
		$result = $notify->GetPayUrl($input);
		Log::DEBUG('get pay url 2'. json_encode($result));
		return $result;
	}

	/*
		企业付款	

		返回结果array (
  'return_code' => 'SUCCESS',
  'return_msg' => 
  array (
  ),
  'mch_appid' => 'wx2cdf8e0dffd4b2b2',
  'mchid' => '1228598202',
  'device_info' => 
  array (
  ),
  'nonce_str' => 'k250hy15osojp5044do8y1duo46p4yts',
  'result_code' => 'SUCCESS',
  'partner_trade_no' => '125',
  'payment_no' => '1000018301201505210190276715',
  'payment_time' => '2015-05-21 18:08:54',
)
	*/
	public static function transfers($option) {
		$input = new WxPayDataBase();
		$input->set('partner_trade_no', $option['trade_no']);
		self::setConfigByOid($option['trade_no']);
		$input->set('openid', $option['openid']);
		$input->set('amount', $option['amount']);
		$input->set('check_name', $option['check_name']); //NO_CHECK, OPTION_CHECK, FORCE_CHECK
		if(isset($option['re_user_name'])) $input->set('re_user_name', $option['re_user_name']);
		$input->set('desc', $option['desc']);
		
		
		$result = WxPayApi::transfers($input);
		#var_export($result);
		Log::DEBUG("transfer return:" . json_encode($result));

		return (!empty($result['return_code'])
			&& !empty($result['result_code'])
			&& ($result['return_code'] == 'SUCCESS')
			&& ($result['result_code'] == 'SUCCESS') 
			&& !empty($result['payment_no'])) ?

			$result : false;
	}

	/*
		企业付款到银行卡	

		返回结果
	*/
	public static function pay_bank($option) {
		$input = new WxPayDataBase();
		$input->set('partner_trade_no', $option['trade_no']);
		self::setConfigByOid($option['trade_no']);
		$input->set('enc_bank_no', $option['bank_no']);
		$input->set('enc_true_name', $option['true_name']);
		$input->set('bank_code', $option['bank_name']);
		$input->set('amount', $option['amount']);
		$input->set('desc', $option['desc']);
		
		$result = WxPayApi::pay_bank($input);
		#var_export($result);
		Log::DEBUG("pay bank return:" . json_encode($result));

		return (!empty($result['return_code'])
			&& !empty($result['result_code'])
			&& ($result['return_code'] == 'SUCCESS')
			&& ($result['result_code'] == 'SUCCESS') 
			&& !empty($result['payment_no'])) ?

			$result : false;
	}

	/*
		发红包
		返回
		array (
  'return_code' => 'SUCCESS',
  'return_msg' => '发放成功',
  'result_code' => 'SUCCESS',
  'mch_billno' => '128',
  'mch_id' => '1228598202',
  'wxappid' => 'wx2cdf8e0dffd4b2b2',
  're_openid' => 'oWhGnjjYvTd0aQf-IRH9w4KJM6vU',
  'total_amount' => '100',
  'send_listid' => '100000000020150522315138563738',
  'send_time' => '19700101080000',
)
	*/
	public static function redpack($option) {
		$input = new WxPayDataBase();
		$input->set('mch_billno', $option['trade_no']);
		self::setConfigByOid($option['trade_no']);
		$input->set('re_openid', $option['openid']);
		//$input->set('nick_name', $option['nick_name']);
		$input->set('send_name', $option['send_name']);
		$input->set('total_amount', $option['total_amount']);
		//$input->set('min_value', isset($option['min_value']) ? $option['min_value'] : $option['total_amount']);
		//$input->set('max_value', isset($option['max_value']) ? $option['max_value'] : $option['total_amount']);
		$input->set('total_num', isset($option['total_num']) ? $option['total_num'] : 1);
		$input->set('wishing', $option['wishing']);
		$input->set('act_name', $option['act_name']);
		$input->set('remark', $option['remark']);
		//$input->set('logo_imgurl', $option['logo_imgurl']);
		//$input->set('share_url', $option['share_url']);
		//$input->set('share_content', $option['share_content']);
		//$input->set('share_imgurl', $option['share_imgurl']);
		
		
		$result = WxPayApi::redpack($input);
		#var_export($result);
		Log::DEBUG("redpack return:" . json_encode($result));

		return (!empty($result['return_code'])
			&& !empty($result['result_code'])
			&& ($result['return_code'] == 'SUCCESS')
			&& ($result['result_code'] == 'SUCCESS') 
			&& !empty($result['send_listid'])) ?

			$result : false;
	}

	/*
		h5支付统一下订单
		app支付也用这个
		正确的返回
		array ( 'appid' => 'wx2cdf8e0dffd4b2b2', 'mch_id' => '1228598202', 'nonce_str' => 'o6iV5J7OZfs0RPNE', 'prepay_id' => 'wx20150619165928e566a1d8380083049626', 'result_code' => 'SUCCESS', 'return_code' => 'SUCCESS', 'return_msg' => 'OK', 'sign' => '2D935B3F947651F2FEF9C9125539AD16', 'trade_type' => 'JSAPI', )array ( 'appid' => 'wx2cdf8e0dffd4b2b2', 'mch_id' => '1228598202', 'nonce_str' => 'o6iV5J7OZfs0RPNE', 'prepay_id' => 'wx20150619165928e566a1d8380083049626', 'result_code' => 'SUCCESS', 'return_code' => 'SUCCESS', 'return_msg' => 'OK', 'sign' => '2D935B3F947651F2FEF9C9125539AD16', 'trade_type' => 'JSAPI', )

	*/
	public static function unified_h5($option) {
		$input = new WxPayUnifiedOrder();
		if(isset($option['openid'])) $input->SetOpenid($option['openid']);
		//$input->SetBody($option['title']);
		$input->SetBody(mb_substr($option['title'],0, 32, 'utf8'));
		$input->SetOut_trade_no($option['trade_no']);
		self::setConfigByOid($option['trade_no']); 
		$input->SetTotal_fee($option['total_fee']);
		$input->SetTime_start(date('YmdHis', $_SERVER['REQUEST_TIME']));
		$input->SetTime_expire(date('YmdHis', $_SERVER['REQUEST_TIME'] + (isset($option['expire']) ? $option['expire'] : 7200 *360)));
		$input->SetNotify_url(WxPayMod::get_weixin_notify_url());
		$input->SetTrade_type(isset($option['trade_type']) ? $option['trade_type'] : 'JSAPI');

		//接口不太稳定多试几次
		$retry = 5;
		do {
		try {
		$result = WxPayApi::unifiedOrder($input);
		Log::DEBUG("unified_h5 return: [$retry] [{$_SERVER['REQUEST_URI']}] " . json_encode($result));
		}
		catch(Exception $e) {
		//Log::DEBUG("unified_h5 exception!: [$retry] " /*. var_export($e, true)*/);
		Log::DEBUG("unified_h5 exception!: [$retry] " . ($e->getMessage()));
		}
		} while(empty($result['result_code']) && --$retry > 0);

		return (!empty($result['return_code'])
			&& !empty($result['result_code'])
			&& ($result['return_code'] == 'SUCCESS')
			&& ($result['result_code'] == 'SUCCESS') 
			) ?

			$result : false;
	}

	/*
		申请退款
		成功返回
		{"appid":"wx2cdf8e0dffd4b2b2","cash_fee":"1","cash_refund_fee":"1","coupon_refund_count":"0","coupon_refund_fee":"0","mch_id":"1228598202","nonce_str":"qU5sv6gBcRYNf76I","out_refund_no":"11003520374201507090375643192","out_trade_no":"c5","refund_channel":[],"refund_fee":"1","refund_id":"2003520374201507090015508321","result_code":"SUCCESS","return_code":"SUCCESS","return_msg":"OK","sign":"DBC3D0A1F14AB79C664CB796D0F99B16","total_fee":"1","transaction_id":"1003520374201507090375643192"}
	*/
	public static function refund($option) {
		$input = new WxPayRefund();
		$input->SetTransaction_id($option['transaction_id']);
		$input->SetTotal_fee($option['total_fee']);
		$input->SetOp_user_id($option['op_user_id']);
		$input->SetOut_refund_no(isset($option['refund_no']) ? $option['refund_no'] : '1'.$option['transaction_id']);
		$input->SetRefund_fee(isset($option['refund_fee']) ? $option['refund_fee'] : $option['total_fee']);

		$result = WxPayApi::refund($input);
		Log::DEBUG("refund return:" . json_encode($result));
		return (!empty($result['return_code'])
			&& !empty($result['result_code'])
			&& ($result['return_code'] == 'SUCCESS')
			&& ($result['result_code'] == 'SUCCESS') 
			) ?

			$result : false;
	}


	/*
		获取h5支付js参数
		$info = array(
				'trade_no' => 订单号
				'openid' => 支付用户微信openid, 可选, 会自动获取
				'title'  => 订单名称
				'total_fee' => 费用
		)
	*/
	public static function get_unified_h5_js_param($info, $cls = null) {
		//每次都认证获取用户openid
		$tools = new JsApiPay();
		if(empty($info['openid'])) {
			$info['openid'] = $tools->GetOpenid();
		}
		$ret =	WxPayMod::unified_h5($info); 
		if(!$ret) {
			setLastError(ERROR_DBG_STEP_2);
			return false;
		}

		if(!$cls) {
			$cls = PayMod::get_order_by_oid($info['trade_no']);
		}
		if(!($info2 = $cls->GetOrderInfo())) {
			return false;
		}

		$pay_info= array(
						'pay_type' => SpServiceMod::PAY_TYPE_WEIXINPAY,
						'pay_info' => array(	
										'time' => $_SERVER['REQUEST_TIME'],
										'prepay_id' => $ret['prepay_id'],
										'trade_type' => $ret['trade_type'],
										'appid' => $ret['appid'],
										'mch_id' => $ret['mch_id'],
										'is_uct_pay' => PayMod::is_sp_uctpay_available($info2['sp_uid']),
									),
		);
		$cls->SavePayInfo($pay_info);

		return $tools->GetJsApiParameters($ret);
	}

	/*
		获取app支付参数
		$info = array(
				'trade_no' => 订单号
				'title'  => 订单名称
				'total_fee' => 费用
		)
	*/
	public static function get_unified_app_param($info, $cls = null) {
		$info['trade_type'] = 'APP';
		$ret =	WxPayMod::unified_h5($info); 
		if(!$ret) {
			setLastError(ERROR_DBG_STEP_2);
			return false;
		}

		if(!$cls) {
			$cls = PayMod::get_order_by_oid($info['trade_no']);
		}
		if(!($info2 = $cls->GetOrderInfo())) {
			return false;
		}

		$pay_info= array(
						'pay_type' => SpServiceMod::PAY_TYPE_WEIXINPAY,
						'pay_info' => array(	
										'time' => $_SERVER['REQUEST_TIME'],
										'prepay_id' => $ret['prepay_id'],
										'trade_type' => $ret['trade_type'],
										'appid' => $ret['appid'],
										'mch_id' => $ret['mch_id'],
										'is_uct_pay' => PayMod::is_sp_uctpay_available($info2['sp_uid']),
									),
		);
		$cls->SavePayInfo($pay_info);

		//获取app所需参数
		//return $tools->GetAppParameters($ret);
		if(!isset($_SERVER['wx_nonce'])) $_SERVER['wx_nonce'] = substr(md5(uniqid()), 8, 16);
		$_SERVER['wx_nonce'] = strtoupper($_SERVER['wx_nonce']);
		$arr = array(
			'appid'      => $ret['appid'],
			'partnerid' => $ret['mch_id'],
			'prepayid'  => $ret['prepay_id'],
			'package'    => 'Sign=WXPay',
			'noncestr'  => $_SERVER['wx_nonce'],
			'timestamp'  => ''.$_SERVER['REQUEST_TIME'],
		);
		ksort($arr);	
		$str = urldecode(http_build_query($arr)).'&key='.WxPayConfig::getConfig('KEY');
		$str = str_replace('Sign%3DWXPay', 'Sign=WXPay', $str);
		$arr['sign'] = strtoupper(md5($str));

		return $arr;
	}

	/*
		获取小程序支付参数
		$info = array(
				'trade_no' => 订单号
				'title'  => 订单名称
				'total_fee' => 费用
		)
	*/
	public static function get_unified_xiaochengxu_param($info, $cls = null) {
		//这个还是 公众号支付
		//$info['trade_type'] = 'JSAPI';
		//Log::DEBUG("unified_h5 xiaochengxu param!:  " . var_export($info, true));
		$ret =	WxPayMod::unified_h5($info); 
		if(!$ret) {
			setLastError(ERROR_DBG_STEP_2);
			return false;
		}

		if(!$cls) {
			$cls = PayMod::get_order_by_oid($info['trade_no']);
		}
		if(!($info2 = $cls->GetOrderInfo())) {
			return false;
		}

		$pay_info= array(
						'pay_type' => SpServiceMod::PAY_TYPE_WEIXINPAY,
						'pay_info' => array(	
										'time' => $_SERVER['REQUEST_TIME'],
										'prepay_id' => $ret['prepay_id'],
										'trade_type' => $ret['trade_type'],
										'appid' => $ret['appid'],
										'mch_id' => $ret['mch_id'],
										'is_uct_pay' => PayMod::is_sp_uctpay_available($info2['sp_uid']),
									),
		);
		$cls->SavePayInfo($pay_info);

		//获取app所需参数
		//return $tools->GetAppParameters($ret);
		if(!isset($_SERVER['wx_nonce'])) $_SERVER['wx_nonce'] = substr(md5(uniqid()), 8, 16);
		$_SERVER['wx_nonce'] = strtoupper($_SERVER['wx_nonce']);
		$arr = array(
			'appId' => WxPayConfig::getConfig('APPID'),
			'timeStamp'  => ''.$_SERVER['REQUEST_TIME'],
			'nonceStr'  => $_SERVER['wx_nonce'],
			'package'  => 'prepay_id='.$ret['prepay_id'],
			'signType'    => 'MD5',
		);
		ksort($arr);	
		$str = urldecode(http_build_query($arr)).'&key='.WxPayConfig::getConfig('KEY');
		//Log::DEBUG('going to sign ... '.$str);
		$str = str_replace('prepay_id%3D', 'prepay_id=', $str);
		$arr['paySign'] = strtoupper(md5($str));

		return $arr;
	}

	/*
		回调通知	
	*/
	public static function native2_notify() {
		Log::DEBUG("begin notify2");
		$notify = new PayNotifyCallBack();
		$notify->Handle(false);
	}

	/*
		回调通知	
	*/
	public static function native1_notify() {
		Log::DEBUG("begin notify1");
		$notify = new PayNotifyCallBack();
		$notify->Handle(false);
	}

	/*
		根据transaction_id 或 out_trade_no 查询订单
		@param $option = array(
							'transaction_id' => 二者填其一
							'trade_no' => 
						)

		未支付返回false

		返回已支付示例
{"appid":"wx2cdf8e0dffd4b2b2","attach":[],"bank_type":"CFT","cash_fee":"1","fee_type":"CNY","is_subscribe":"Y","mch_id":"1228598202","nonce_str":"B228lgEJNUA94Wnx","openid":"oWhGnjjYvTd0aQf-IRH9w4KJM6vU","out_trade_no":"a3","result_code":"SUCCESS","return_code":"SUCCESS","return_msg":"OK","sign":"D22DB5D62286D9233BE61620E60ED8FC","time_end":"20150519141810","total_fee":"1","trade_state":"SUCCESS","trade_type":"NATIVE","transaction_id":"1003520374201505190140907906"}
		
		返回未支付示例
		{"appid":"wx2cdf8e0dffd4b2b2","mch_id":"1228598202","nonce_str":"0D1zsHIkpYNH6BDv","out_trade_no":"a6","result_code":"SUCCESS","return_code":"SUCCESS","return_msg":"OK","sign":"BD21FC4EF45863F76D945BE1408AFFCC","trade_state":"NOTPAY","trade_state_desc":"\u8ba2\u5355\u672a\u652f\u4ed8"}
	*/
	public static function query_weixin_order($option)
	{
		$input = new WxPayOrderQuery();
		if(!empty($option['transaction_id'])) $input->SetTransaction_id($option['transaction_id']);
		if(!empty($option['trade_no'])) {
			 $input->SetOut_trade_no($option['trade_no']);
			//设置微信支付配置
			self::setConfigByOid($option['trade_no']);
		}
		$result = WxPayApi::orderQuery($input);
		Log::DEBUG("query:" . json_encode($result));

		return (!empty($result['return_code'])
			&& !empty($result['result_code'])
			&& ($result['return_code'] == 'SUCCESS')
			&& ($result['result_code'] == 'SUCCESS') 
			&& !empty($result['time_end'])) ?

			$result : false;
	}
	
	/*
		根据微信回调信息更新本地订单信息
	*/
	public static function query_and_update_weixin_order($option) {
		if(!$wo = self::query_weixin_order($option)) {
			setLastError(ERROR_DBG_STEP_1);
			return false;
		}

		if(!($cls = PayMod::get_order_by_oid($wo['out_trade_no']))) {
			return false;
		}
		
		$update = array(
			'paid_time' => strtotime($wo['time_end']),
			'pay_type' => SpServiceMod::PAY_TYPE_WEIXINPAY,
			'pay_info' => array(	
							'callback_time' => $_SERVER['REQUEST_TIME'],
							'transaction_id' => $wo['transaction_id'],
							'trade_type' => $wo['trade_type'],
							'appid' => $wo['appid'],
							'mch_id' => $wo['mch_id'],
							'openid' => $wo['openid'],
							'bank_type' => $wo['bank_type'],
							'fee_type' => $wo['fee_type'],
							'total_fee' => $wo['total_fee'],
						),
		);
		
		Dba::beginTransaction(); { Dba::disableTransaction(true); {
			if($cls->PaySucceedCallback($update)) {
				$ret = PayMod::onPaySucceed($cls, $update);
			}
		}Dba::disableTransaction(false); } Dba::commit();
		
		//如果是小程序支付成功 保存form_id 放在这里, 一个prepay_id可以用3次
		if(($public_uid = Dba::readOne('select uid from weixin_public where app_id = "'.$wo['appid'].'" && (public_type & 8) = 8')) 
			&& ($order = $cls->GetOrderInfo()) && !empty($order['su_uid']) && !empty($order['pay_info']['prepay_id'])) {
			$it = array('su_uid' => $order['su_uid'], 'public_uid' => $public_uid, 'form_id' => $order['pay_info']['prepay_id'], 
						'create_time' => $_SERVER['REQUEST_TIME']);
			for($i=0;$i<3;$i++) {
				XiaochengxuMod::save_form_id($it);
			}
		}

		return true;
	}

	/*
		根据订单号生成扫码二维码 模式二
		@param  $oid 订单号
				axxxx 表示商户服务订单
				bxxxx 表示微商城订单
	*/
	public static function get_native2_url_by_oid($oid) {
		if(!$cls = PayMod::get_order_by_oid($oid)) {
			return false;
		}
		if(!($info = $cls->PreparePayInfo())) {
			return false;
		}
		if(!($cfg = PayMod::is_sp_weixinpay_available($info['sp_uid']))) {
			setLastError(ERROR_SERVICE_NOT_AVAILABLE);
			return false;
		}
		WxPayConfig::setConfig($cfg);

		$option = array(
						'trade_no' => $oid,
						'body'     => mb_substr($info['title'],0, 32, 'utf8'),
						'detail'   => $info['detail'],
						'attach' => '',
						'goods_tag' => '',
						'product_uid' => isset($info['product_uid']) ? $info['product_uid'] : $info['trade_no'],
						'total_fee' => $info['total_fee'],
						'time_start' => date('YmdHis', $_SERVER['REQUEST_TIME']),
						'time_expire' => date('YmdHis', $_SERVER['REQUEST_TIME'] + (isset($info['expire']) ? $info['expire'] : 7200 * 360)), //2小时
						'notify_url' => WxPayMod::get_weixin_notify_url(),
		);
		
		$ret = self::get_native2_url($option);

		//保存一下支付信息
		if(!empty($ret['prepay_id']) && !empty($ret['trade_type']) &&
			!empty($ret['appid']) && !empty($ret['mch_id'])) {
			$pay_info= array(
							'pay_type' => SpServiceMod::PAY_TYPE_WEIXINPAY,
							'pay_info' => array(	
											'time' => $_SERVER['REQUEST_TIME'],
											'prepay_id' => $ret['prepay_id'],
											'trade_type' => $ret['trade_type'],
											'appid' => $ret['appid'],
											'mch_id' => $ret['mch_id'],
											'is_uct_pay' => PayMod::is_sp_uctpay_available($info['sp_uid']),
										),
			);
			$cls->SavePayInfo($pay_info);
		}
		else {
			setLastError(ERROR_DBG_STEP_2);
		}

		return !empty($ret['code_url']) ? $ret['code_url'] : false;
	}

	/*
		取微信h5支付所需要的open_id

		二者传其一即可,主要用于确定商户配置参数
		不传将自动判断
		$order = array(
			'sp_uid' => 商户uid, 0表示系统 如代收款
			'oid' => 订单oid
		)
	*/
	public static function require_order_wxjs_open_id($order = array()) {
		if(isset($order['sp_uid'])) {
			$sp_uid = $order['sp_uid'];
		}
		else if(isset($order['oid'])) {
			if(!($cls = PayMod::get_order_by_oid($order['oid'])) ||
				!($info = $cls->GetOrderInfo())) {
				echo 'oid 参数错误！'; exit;
			}
			$sp_uid = $info['sp_uid'];
		}
		else {
			$sp_uid = AccountMod::require_sp_uid();
		}
		if(!($cfg = PayMod::is_sp_weixinpay_available($sp_uid))) {
			echo '微信支付配置错误!'.$sp_uid; exit;
		}
		WxPayMod::setConfig($cfg);

		$tools = new JsApiPay();
		return $tools->GetOpenid();
	}

}

/*
	微信支付回调通知
	
	回调参数示例
	{"appid":"wx2cdf8e0dffd4b2b2","bank_type":"CFT","cash_fee":"1","fee_type":"CNY","is_subscribe":"Y","mch_id":"1228598202","nonce_str":"5pbzm5uls4nqct9ja2xxjgnvq25pml11","openid":"oWhGnjjYvTd0aQf-IRH9w4KJM6vU","out_trade_no":"a3","result_code":"SUCCESS","return_code":"SUCCESS","sign":"EDAB3F22D3422665F8898BFEDFDAB86B","time_end":"20150519141811","total_fee":"1","trade_type":"NATIVE","transaction_id":"1003520374201505190140907906"}
*/
class PayNotifyCallBack extends WxPayNotify
{
	//重写回调处理函数
	public function NotifyProcess($data, &$msg)
	{
		Log::DEBUG("notify call back:" . json_encode($data));
		//查询订单，判断订单真实性
		if(empty($data['transaction_id'])) {
			setLastError(ERROR_INVALID_REQUEST_PARAM);
			return false;
		}

		return WxPayMod::query_and_update_weixin_order(array('transaction_id' => $data["transaction_id"], 'trade_no' => $data['out_trade_no']));
	}
}

