<?php
/*
	支付
*/

class PayMod {
	public static function extend_order_info($info) {
		if($info['sp_uid'] == 0) {
			$info['spname'] = '深圳市快马加鞭科技公司';
			$sp = AccountMod::get_service_provider_by_uid($info['su_uid']);
			$info['suname'] = $sp['name'] ? $sp['name'] : $sp['account'];
		}
		else {
			$sp = AccountMod::get_service_provider_by_uid($info['sp_uid']);
			$su = AccountMod::get_service_user_by_uid($info['su_uid']);
			$info['spname'] = $sp['name'] ? $sp['name'] : $sp['account'];
			$info['suname'] = $su['name'] ? $su['name'] : $su['account'];
			if(PayMod::is_sp_uctpay_available($info['sp_uid'])) {
				$info['spname'] .= ' (深圳市快马加鞭科技公司 代收)';
			}
		}

		return $info;
	}

	/*
		根据订单号获取订单类
	*/
	public static function get_order_by_oid($oid) {
		$type = substr($oid, 0, 1);
		$uid = substr($oid, 1);
		
		$cls = $type.'OrderMod';
		if(!class_exists($cls)) {
			setLastError(ERROR_DBG_STEP_1);
			return false;
		}
		return new $cls($uid);
	}
	
	/*
		测试支付
	*/
	public static function test_pay($oid) {
		if(!($cls = PayMod::get_order_by_oid($oid)) ||
			!($info = $cls->PreparePayInfo())) {
			return false;
		}
		if(!($cfg = PayMod::is_sp_testpay_available($info['sp_uid']))) {
			setLastError(ERROR_SERVICE_NOT_AVAILABLE);
			return false;
		}

		$update = array(
			'pay_type' => SpServiceMod::PAY_TYPE_TESTPAY,
			'pay_info' => array(
				'info' => 'this is test pay',
			),
		);

		Dba::beginTransaction(); { Dba::disableTransaction(true); {
			if($cls->PaySucceedCallback($update)) {
				PayMod::onPaySucceed($cls, $update);
			}
		}Dba::disableTransaction(false); } Dba::commit();

		return true;
	}

	/*
		余额支付
	*/
	public static function balance_pay($oid) {
		if(!($cls = PayMod::get_order_by_oid($oid)) ||
			!($info = $cls->PreparePayInfo())) {
			return false;
		}
		if(!($cfg = PayMod::is_sp_balancepay_available($info['sp_uid']))) {
			setLastError(ERROR_SERVICE_NOT_AVAILABLE);
			return false;
		}

		uct_use_app('su');
		if((!$su_uid = AccountMod::has_su_login()) ||
			$su_uid != $info['su_uid']) {
			setLastError(ERROR_USER_HAS_NOT_LOGIN);
			return false;
		}
		$point = SuPointMod::get_user_points_by_su_uid($su_uid);
		if($point['cash_remain'] < $info['total_fee']) {
			setLastError(ERROR_OUT_OF_LIMIT);
			return false;
		}
		
		$update = array(
			'pay_type' => SpServiceMod::PAY_TYPE_BALANCEPAY,
			'pay_info' => array(
				'info' => 'this is balance pay',
			),
		);

		$record = array('su_uid' => $su_uid,
						'cash' => $info['total_fee'],
						'info' =>  '订单支付 #'.$info['trade_no'],
						'create_time' => $_SERVER['REQUEST_TIME'],
		);

		$ret = false;
		Dba::beginTransaction(); { Dba::disableTransaction(true); {
			if(SuPointMod::decrease_user_cash($record)) {
				if($cls->PaySucceedCallback($update)) {
					$ret = PayMod::onPaySucceed($cls, $update);
				}
			}
		}Dba::disableTransaction(false); } Dba::commit();

		return $ret;
	}


	/*		
		判断商户是否配置了微信支付
	*/
	public static function is_sp_weixinpay_available($sp_uid) {
		if($sp_uid && ($cfg = PayMod::is_sp_uctpay_available($sp_uid))) {
			if(empty($cfg['wxpay'])) {
				return false;
			}	
			
			$sp_uid = 0;
		}

		$cfg = self::get_sp_weixinpay_cfg($sp_uid);
		if(!$cfg || !empty($cfg['disabled']) || 
			empty($cfg['APPID']) || empty($cfg['MCHID']) ||
			empty($cfg['KEY']) || empty($cfg['APPSECRET']) ) {
			return false;
		}

		return $cfg;
	}

	/*		
		判断商户是否配置了微信支付证书
	*/
	public static function is_sp_weixinpay_cert_available($sp_uid) {
		if($sp_uid && ($cfg = PayMod::is_sp_uctpay_available($sp_uid))) {
			if(empty($cfg['wxpay'])) {
				return false;
			}	
			
			$sp_uid = 0;
		}

		$cfg = self::get_sp_weixinpay_cfg($sp_uid);
		if(!$cfg || !empty($cfg['disabled']) || 
			empty($cfg['SSLCERT_PATH']) ||
			empty($cfg['SSLKEY_PATH']) 
			) {
			return false;
		}

		return $cfg;
	}

	/*
		获取商户微信支付配置
		sp_uid = 0 表示UCT运营系统设置
	*/
	public static function get_sp_weixinpay_cfg($sp_uid) {
		if($sp_uid && ($cfg = PayMod::is_sp_uctpay_available($sp_uid))) {
			if(empty($cfg['wxpay'])) {
				return false;
			}	
			
			$sp_uid = 0;
		}

		$key = 'weixin_'.$sp_uid;
		$cfg = isset($GLOBALS['arraydb_pay'][$key]) ? json_decode($GLOBALS['arraydb_pay'][$key], true) : false;
		if($cfg) {
			$cfg['SSLCERT_PATH'] = CERT_PATH.''.$sp_uid.'/wx/apiclient_cert.pem';
			$cfg['SSLKEY_PATH'] = CERT_PATH.''.$sp_uid.'/wx/apiclient_key.pem';
			if(!file_exists($cfg['SSLCERT_PATH'])) unset($cfg['SSLCERT_PATH']);
			if(!file_exists($cfg['SSLKEY_PATH'])) unset($cfg['SSLKEY_PATH']);
		}
		return $cfg;
	}

	public static function set_sp_weixinpay_cfg($sp_uid, $cfg) {
		$key = 'weixin_'.$sp_uid;
		return $GLOBALS['arraydb_pay'][$key] = json_encode($cfg);	
	}

	/*		
		判断商户是否配置了小程序支付
	*/
	public static function is_sp_xiaochengxupay_available($public_uid) {
		$cfg = self::get_sp_xiaochengxupay_cfg($public_uid);
		if(!$cfg || !empty($cfg['disabled']) || 
			empty($cfg['APPID']) || empty($cfg['MCHID']) ||
			empty($cfg['KEY']) || empty($cfg['APPSECRET']) ) {
			return false;
		}

		return $cfg;
	}

	/*		
		判断商户是否配置了小程序微信支付证书
	*/
	public static function is_sp_xiaochengxupay_cert_available($public_uid) {
		$cfg = self::get_sp_xiaochengxupay_cfg($public_uid);
		if(!$cfg || !empty($cfg['disabled']) || 
			empty($cfg['SSLCERT_PATH']) ||
			empty($cfg['SSLKEY_PATH']) 
			) {
			return false;
		}

		return $cfg;
	}

	/*
		获取商户小程序支付配置
	*/
	public static function get_sp_xiaochengxupay_cfg($public_uid) {
		$key = 'xiaochengxu_'.$public_uid;
		$cfg = isset($GLOBALS['arraydb_pay'][$key]) ? json_decode($GLOBALS['arraydb_pay'][$key], true) : false;
		if($cfg) {
			//证书认为和当前商户是同样的证书
			$sp_uid = Dba::readOne('select sp_uid from weixin_public where uid = '.$public_uid);
			$cfg['SSLCERT_PATH'] = CERT_PATH.''.$sp_uid.'/wx/apiclient_cert.pem';
			$cfg['SSLKEY_PATH'] = CERT_PATH.''.$sp_uid.'/wx/apiclient_key.pem';
			if(!file_exists($cfg['SSLCERT_PATH'])) unset($cfg['SSLCERT_PATH']);
			if(!file_exists($cfg['SSLKEY_PATH'])) unset($cfg['SSLKEY_PATH']);
		}
		return $cfg;
	}

	public static function set_sp_xiaochengxupay_cfg($public_uid, $cfg) {
		$key = 'xiaochengxu_'.$public_uid;
		return $GLOBALS['arraydb_pay'][$key] = json_encode($cfg);	
	}

	/*		
		判断商户是否配置了支付宝
	*/
	public static function is_sp_alipay_available($sp_uid) {
		if($sp_uid && ($cfg = PayMod::is_sp_uctpay_available($sp_uid))) {
			if(empty($cfg['alipay'])) {
				return false;
			}	
			
			$sp_uid = 0;
		}

		$cfg = self::get_sp_alipay_cfg($sp_uid);
		if(!$cfg || !empty($cfg['disabled']) || 
			empty($cfg['key']) || empty($cfg['partner']) || empty($cfg['seller_email']) ) {
			return false;
		}

		return $cfg;
	}

	/*
		获取商户支付宝配置
		sp_uid = 0 表示UCT运营系统设置
	*/
	public static function get_sp_alipay_cfg($sp_uid) {
		if($sp_uid && ($cfg = PayMod::is_sp_uctpay_available($sp_uid))) {
			if(empty($cfg['alipay'])) {
				return false;
			}	
			
			$sp_uid = 0;
		}

		$key = 'ali_'.$sp_uid;
		$cfg = isset($GLOBALS['arraydb_pay'][$key]) ? json_decode($GLOBALS['arraydb_pay'][$key], true) : false;
		return $cfg;
	}

	public static function set_sp_alipay_cfg($sp_uid, $cfg) {
		$key = 'ali_'.$sp_uid;
		return $GLOBALS['arraydb_pay'][$key] = json_encode($cfg);	
	}

	/*
		获取商户测试支付配置
		sp_uid = 0 表示UCT运营系统设置
	*/
	public static function get_sp_testpay_cfg($sp_uid) {
		$key = 'test_'.$sp_uid;
		$cfg = isset($GLOBALS['arraydb_pay'][$key]) ? json_decode($GLOBALS['arraydb_pay'][$key], true) : false;
		return $cfg;
	}

	public static function set_sp_testpay_cfg($sp_uid, $cfg) {
		$key = 'test_'.$sp_uid;
		return $GLOBALS['arraydb_pay'][$key] = json_encode($cfg);	
	}

	/*		
		判断商户是否配置了测试支付
		默认关闭
	*/
	public static function is_sp_testpay_available($sp_uid) {
		$cfg = self::get_sp_testpay_cfg($sp_uid);
		return $cfg && empty($cfg['disabled']);
	}

	/*
		获取商户余额支付配置
		sp_uid = 0 表示UCT运营系统设置
	*/
	public static function get_sp_balancepay_cfg($sp_uid) {
		$key = 'balance_'.$sp_uid;
		$cfg = isset($GLOBALS['arraydb_pay'][$key]) ? json_decode($GLOBALS['arraydb_pay'][$key], true) : false;
		return $cfg;
	}

	public static function set_sp_balancepay_cfg($sp_uid, $cfg) {
		$key = 'balance_'.$sp_uid;
		return $GLOBALS['arraydb_pay'][$key] = json_encode($cfg);	
	}

	/*		
		判断商户是否配置了余额支付
		默认关闭
	*/
	public static function is_sp_balancepay_available($sp_uid) {
		$cfg = self::get_sp_balancepay_cfg($sp_uid);
		return $cfg && empty($cfg['disabled']);
	}

	/*
		获取商户UCT代收款配置
	*/
	public static function get_sp_uctpay_cfg($sp_uid) {
		/*
		$key = 'uct_'.$sp_uid;
		$cfg = isset($GLOBALS['arraydb_pay'][$key]) ? json_decode($GLOBALS['arraydb_pay'][$key], true) : false;
		return $cfg;
		*/

		return UctpayMod::get_uctpay_by_sp_uid($sp_uid);
	}

	public static function set_sp_uctpay_cfg($sp_uid, $cfg) {
		/*
		$key = 'uct_'.$sp_uid;
		return $GLOBALS['arraydb_pay'][$key] = json_encode($cfg);	
		*/
		$cfg['sp_uid'] = $sp_uid;
		return UctpayMod::add_or_edit_uctpay($cfg);
	}

	/*		
		判断商户是否配置了代收款支付
		默认关闭
	*/
	public static function is_sp_uctpay_available($sp_uid) {
		$cfg = self::get_sp_uctpay_cfg($sp_uid);
		if(!$cfg || !empty($cfg['disabled'])) {
			return false;
		}

		return $cfg;
	}

	/*
		退款

		$order = array(
			'sp_uid' => 
			'pay_type' => 
			'pay_info' => 
			'paid_fee' => 
			'refund_fee' => 

			'refund_no'  => 选填,退款单号
			'op_user_id'  => 选填,操作员编号
		);
		
		返回 退款成功已退款 如微信支付, {obj}同意退款,但还没有转账 如支付宝,  false 退款失败
	*/
	public static function do_refund($order) {
		$cfg = PayMod::get_sp_refund_cfg($order['sp_uid']);
		if($cfg['type'] == 2){ //退到余额
			uct_use_app('su');
			$record = array(
				'su_uid' => $order['user_id'],
				'cash'   => $order['refund_fee'],
				'info'   => '订单退款 #'.$order['uid'],
			);
			return SuPointMod::increase_user_cash($record);//增加用户收入
		} 
		if($cfg['type'] == 3){ //线下转账
			return true;
		}
	


		switch($order['pay_type']) {
			//微信支付退款
			case SpServiceMod::PAY_TYPE_WEIXINPAY: {
				if(!($cfg = self::is_sp_weixinpay_cert_available($order['sp_uid']))) { 
					//小程序支付
					$public_uid = Dba::readOne('select weixin_public.uid from service_provider join weixin_public on service_provider.uct_token = weixin_public.uct_token where service_provider.uid = '.$order['sp_uid']);
					if(!$public_uid || !($cfg = self::is_sp_xiaochengxupay_cert_available($public_uid))) {
						setLastError(ERROR_CONFIG_ERROR);
						return false;
					}
				}
				WxPayMod::setConfig($cfg);
				if(empty($order['pay_info']['transaction_id'])) {
					setLastError(ERROR_UNKNOWN_DB_ERROR);			
					return false;
				}

				$option = array('transaction_id' => $order['pay_info']['transaction_id'],
								'total_fee' => $order['paid_fee'],
								'refund_fee' => $order['refund_fee'],
				);
				isset($order['refund_no']) && $option['refund_no'] = $order['refund_no'];
				$option['op_user_id'] = isset($order['op_user_id']) ? $order['op_user_id'] : $order['sp_uid'];
				return WxPayMod::refund($option);
			}

			//支付宝退款
			case SpServiceMod::PAY_TYPE_ALIPAY: {
				if(!($cfg = self::is_sp_alipay_available($order['sp_uid']))) { 
					setLastError(ERROR_CONFIG_ERROR);
					return false;
				}
				AlipayMod::setConfig($cfg);
				if(empty($order['pay_info']['trade_no']) || empty($order['pay_info']['out_trade_no'])) {
					setLastError(ERROR_UNKNOWN_DB_ERROR);			
					return false;
				}

				$option = array('trade_no' => $order['pay_info']['trade_no'],
								'out_trade_no' => $order['pay_info']['out_trade_no'],
								'refund_fee' => $order['refund_fee']/100,
				);
				isset($order['refund_no']) && $option['refund_no'] = $order['refund_no'];
				//需要跳转, 等退款成功后再进行处理
				$GLOBALS['_UCT']['ACT'] != 'refund_notify' &&  setLastError(ERROR_NEED_REDIRECT);
				return AlipayMod::refund($option);
			}

			case SpServiceMod::PAY_TYPE_TESTPAY: 
			case SpServiceMod::PAY_TYPE_FREE: 
			case SpServiceMod::PAY_TYPE_CACHE: 
			{
				return 1;
			}
			//余额退款
			case SpServiceMod::PAY_TYPE_BALANCEPAY:
			{
				uct_use_app('su');
				$record = array(
					'su_uid' => $order['user_id'],
					'cash'   => $order['refund_fee'],
					'info'   => '余额退款',
				);
				return SuPointMod::increase_user_cash($record);//增加用户收入
			}

			default:
			return false;
		}
	}

	/*
		支付成功
		用于uct代收款记录一下

		$params = array(
						'pay_type' => 
						'pay_info' => 

						'paid_time' =>  //支付时间 可选
		)
	
	*/
	public static function onPaySucceed($cls, $params) {
		$order = $cls->GetOrderInfo();
		if($order && !empty($order['sp_uid']) && !empty($order['pay_info']['is_uct_pay']) &&
			PayMod::is_sp_uctpay_available($order['sp_uid'])) {
			$record = array(
						'sp_uid' => $order['sp_uid'],
						'cash' => $order['total_fee'],
						'create_time' => $order['paid_time'],
						'info' => '订单收入 - 订单号 ['.$order['trade_no'].'] -'.$order['title'],
					);

			return UctpayMod::increase_uctpay_cash($record);
		}

		return true;
	}

	/*
    获取商户退款配置
    sp_uid = 0 表示UCT运营系统设置
	*/
	public static function get_sp_refund_cfg($sp_uid) {
		$key = 'refund_set_'.$sp_uid;
		if(isset($GLOBALS['arraydb_pay'][$key])){
			$cfg = json_decode($GLOBALS['arraydb_pay'][$key], true);
		}else{
			$cfg = array('type'  => 1);
		}
		return $cfg;
	}
	/*
	设置商户退款配置
	*/
	public static function set_sp_refund_cfg($sp_uid, $cfg) {
		$key = 'refund_set_'.$sp_uid;
		return $GLOBALS['arraydb_pay'][$key] = json_encode($cfg);
	}

}

