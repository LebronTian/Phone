<?php
/*
	支付宝转账接口
*/

require_once UCT_PATH.'vendor/alipay_v33/include.php';
class AlipayMod {
	public static function setConfig($cfg) {
		AliPayConfig::setConfig($cfg);
	}

	/*
		获取支付宝异步通知url地址
		地址中不能包含?
	*/
	public static function get_alipay_notify_url() {
		return getUrlName().'/app/pay/alipay.notify.php';
	}

	/*
		获取支付宝同步通知url地址
		地址中不能包含?
	*/
	public static function get_alipay_return_url() {
		return getUrlName().'/app/pay/alipay.return.php';
	}

	/*
		获取支付宝退款异步通知url地址
		地址中不能包含?
	*/
	public static function get_alipay_refundnotify_url() {
		return getUrlName().'/app/pay/alipay.refundnotify.php';
	}

	//退款通知
	public static function refund_notify() {
		logResult('ali refund notify '. json_encode($_REQUEST, true));

		if(empty($_REQUEST['batch_no']) || !($oid = checkString(substr($_REQUEST['batch_no'], 8), PATTERN_ORDER_UID))) {
			setLastError(ERROR_INVALID_REQUEST_PARAM);
			return false;
		}
		if(!$cls = PayMod::get_order_by_oid($oid)) {
			return false;
		}
		if(!($info = $cls->GetOrderInfo())) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}
		if(!($cfg = PayMod::is_sp_alipay_available($info['sp_uid']))) {
			setLastError(ERROR_SERVICE_NOT_AVAILABLE);
			return false;
		}
		AliPayConfig::setConfig($cfg);
		$alipayNotify = new AlipayNotify(AliPayConfig::getConfig());
		if(!$alipayNotify->verifyNotify()) { 
			setLastError(ERROR_DBG_STEP_2);
			return false;
		}
		
		//退款操作
		uct_use_app('shop');
		$uid = substr($oid, 1);
		if(!($refund = RefundMod::get_refund_by_order_uid($uid))) {
			return false;
		} 
			
		return RefundMod::do_accept_refund($refund);
	}
	
	public static function direct_notify() {
		logResult('ali notify '. json_encode($_REQUEST, true));
		return self::update_alipay_order('notify');
	}
	
	/*	
		同步返回示例
		{"body":"\u77ed\u4fe11000\u6761      X 1","buyer_email":"407761858@qq.com","buyer_id":"2088502704338428","exterface":"create_direct_pay_by_user","is_success":"T","notify_id":"RqPnCoPT3K9%2Fvwbh3InSMaWuFvdLUb51SoveKRTcKJTXYkSDti5Q0ejy6m1p6w7D69l4","notify_time":"2015-07-26 17:14:29","notify_type":"trade_status_sync","out_trade_no":"a9","payment_type":"1","seller_email":"2529270756@qq.com","seller_id":"2088911784361848","subject":"\u77ed\u4fe11000\u6761","total_fee":"0.01","trade_no":"2015072600001000420063642046","trade_status":"TRADE_SUCCESS","sign":"3665fdafb488d1c5f973ea46bac8870a","sign_type":"MD5","_a":"pay","_u":"alipay.direct_return","_sp_uid":"2"}
	*/
	public static function direct_return() {
		logResult('ali direct return'. json_encode($_REQUEST, true));
		return self::update_alipay_order('return');
	}
	
	/*
		即时到帐
	*/
	public static function direct_pay($option, $alipay_config = array()) {
		if(!$alipay_config) {
			$alipay_config = AlipayConfig::getConfig();
		}

		$alipaySubmit = new AlipaySubmit($alipay_config);
		$anti_phishing_key = $alipaySubmit->query_timestamp();
		$param = array(
					'service' => 'create_direct_pay_by_user',
					'partner' => trim($alipay_config['partner']),
					'seller_email' => trim($alipay_config['seller_email']),
					'payment_type' => 1,
					'notify_url'   => self::get_alipay_notify_url(),
					'return_url'   => self::get_alipay_return_url(),
					'out_trade_no' => $option['trade_no'],
					'total_fee'    => $option['total_fee'],
					'subject'      => $option['subject'],
					'body'         => $option['body'],
					'show_url'     => isset( $option['show_url']) ? $option['show_url'] : '',
					'anti_phishing_key' => $anti_phishing_key,
					'exter_invoke_ip' => requestClientIP(),
					'_input_charset' => $alipay_config['input_charset'],
			);
	
			$html_text = $alipaySubmit->buildRequestForm($param, 'get', '确认');
			return $html_text;
	}

	/*
		根据订单号
		@param  $oid 订单号
				axxxx 表示商户服务订单
				bxxxx 表示微商城订单
				cxxxx 表示微外卖订单
	*/
	public static function do_direct_pay_by_oid($oid) {
		if(!$cls = PayMod::get_order_by_oid($oid)) {
			return false;
		}
		if(!($info = $cls->PreparePayInfo())) {
			return false;
		}
		if(!($cfg = PayMod::is_sp_alipay_available($info['sp_uid']))) {
			setLastError(ERROR_SERVICE_NOT_AVAILABLE);
			return false;
		}
		AliPayConfig::setConfig($cfg);

		$info2 = $cls->GetOrderInfo();
		$option = array(
						'trade_no' => $oid,
						'subject'  => $info['title'],
						'body'     => $info['detail'],
						'total_fee' => $info['total_fee']/100,
						'show_url'  => $info2['return_url'],
					);
		$pay_info= array(
						'pay_type' => SpServiceMod::PAY_TYPE_ALIPAY,
						'pay_info' => array(	
										'time' => $_SERVER['REQUEST_TIME'],
										'seller_email' => $cfg['seller_email'],
										'is_uct_pay' => PayMod::is_sp_uctpay_available($info['sp_uid']),
						),
		);
		$cls->SavePayInfo($pay_info);

		return self::direct_pay($option);
	}

	/*
		根据支付宝回调信息更新本地订单信息
		
		@param $return_or_notify 同步return, 异步notify
	*/
	public static function update_alipay_order($return_or_notify = 'return') {
		if(!($oid = requestString('out_trade_no', PATTERN_ORDER_UID))) {
			setLastError(ERROR_INVALID_REQUEST_PARAM);
			return false;
		}
		if(!$cls = PayMod::get_order_by_oid($oid)) {
			return false;
		}
		if(!($info = $cls->GetOrderInfo())) {
			setLastError(ERROR_OBJ_NOT_EXIST);
			return false;
		}
		if(!($cfg = PayMod::is_sp_alipay_available($info['sp_uid']))) {
			setLastError(ERROR_SERVICE_NOT_AVAILABLE);
			return false;
		}
		AliPayConfig::setConfig($cfg);
		$alipayNotify = new AlipayNotify(AliPayConfig::getConfig());
		if(!(($return_or_notify == 'return') ? $alipayNotify->verifyReturn() : $alipayNotify->verifyNotify()) ||
			!in_array($_REQUEST['trade_status'], array('TRADE_SUCCESS', 'TRADE_FINISHED'))) {
			setLastError(ERROR_DBG_STEP_2);
			return false;
		}
		
		$update = array(
			'paid_time' => strtotime(requestString('notify_time', PATTERN_DATETIME)),
			'pay_type' => SpServiceMod::PAY_TYPE_ALIPAY,
			'pay_info' => array(	
							'callback_time' => $_SERVER['REQUEST_TIME'],
							'out_trade_no' => requestString('out_trade_no', PATTERN_NORMAL_STRING),
							'trade_no' => requestString('trade_no', PATTERN_NORMAL_STRING),
							'payment_type' => requestString('payment_type', PATTERN_NORMAL_STRING),
							'seller_email' => requestString('seller_email', PATTERN_ACCOUNT),
							'seller_id' => requestString('seller_id', PATTERN_NORMAL_STRING),
							'buyer_email' => requestString('buyer_email', PATTERN_ACCOUNT),
							'buyer_id' => requestString('buyer_id', PATTERN_NORMAL_STRING),
							'total_fee' => requestFloat('total_fee'),
						),
		);

		Dba::beginTransaction(); { Dba::disableTransaction(true); {
			if($cls->PaySucceedCallback($update)) {
				PayMod::onPaySucceed($cls, $update);
			}
		}Dba::disableTransaction(false); } Dba::commit();

		return $info;
	}

	/*
		即时到帐退款
		退款结果异步通知
	*/
	public static function refund($option, $alipay_config = array()) {
		if(!$alipay_config) {
			$alipay_config = AlipayConfig::getConfig();
		}

		$alipaySubmit = new AlipaySubmit($alipay_config);
		$param = array(
			'service'        => 'refund_fastpay_by_platform_pwd',
			'partner'        => trim($alipay_config['partner']),
			'notify_url'     => self::get_alipay_refundnotify_url(),
			'seller_email'   => trim($alipay_config['seller_email']),
			'refund_date'    => isset($option['refund_date']) ? $option['refund_date'] : date('Y-m-d H:i:s'),
			'batch_no'       => isset($option['refund_no']) ? $option['refund_no'] : (date('Ymd').$option['out_trade_no']),
			'batch_num'      => 1,
			'detail_data'    => $option['trade_no'].'^'.(isset($option['refund_fee']) ? $option['refund_fee'] : $option['total_fee'])
								.'^'.(isset($option['refund_reason']) ? $option['refund_reason'] : '协商退款'),
			'_input_charset' => $alipay_config['input_charset'],
		);

		$html_text = $alipaySubmit->buildRequestForm($param, 'get', '确认');
		return $html_text;
	}

}

