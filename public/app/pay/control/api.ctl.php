<?php

class ApiCtl {
	public function weixinpay() {
		$cfg = array(	
			'APPID'     => requestString('appid', PATTERN_NORMAL_STRING),	
			'APPSECRET' => requestString('appsecret', PATTERN_NORMAL_STRING),	
			'MCHID'     => requestString('mchid', PATTERN_NORMAL_STRING),	
			'KEY'       => requestString('key', PATTERN_NORMAL_STRING),	
			'spname'    => requestString('spname', PATTERN_USER_NAME),	
			'disabled'  => requestInt('disabled'),	
		);

		$sp_uid = AccountMod::get_current_service_provider('uid');
		PayMod::set_sp_weixinpay_cfg($sp_uid, $cfg);
		outRight('ok');	
	}

	public function xiaochengxupay() {
		$sp_uid = AccountMod::get_current_service_provider('uid');
		if(!($uid = requestInt('public_uid')) ||
		  !($public = WeixinMod::get_weixin_public_by_uid($uid)) ||
		  $public['sp_uid'] != $sp_uid) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$cfg = array(	
			'APPID'     => requestString('appid', PATTERN_NORMAL_STRING),	
			'APPSECRET' => requestString('appsecret', PATTERN_NORMAL_STRING),	
			'MCHID'     => requestString('mchid', PATTERN_NORMAL_STRING),	
			'KEY'       => requestString('key', PATTERN_NORMAL_STRING),	
			'spname'    => requestString('spname', PATTERN_USER_NAME),	
			'disabled'  => requestInt('disabled'),	
		);

		PayMod::set_sp_xiaochengxupay_cfg($public['uid'], $cfg);
		outRight('ok');	
	}

	public function alipay() {
		$cfg = array(	
			'seller_email' => requestString('seller_email', PATTERN_ACCOUNT),	
			'partner'   => requestString('partner', PATTERN_NORMAL_STRING),	
			'key'       => requestString('key', PATTERN_NORMAL_STRING),	
			'spname'    => requestString('spname', PATTERN_USER_NAME),	
			'disabled'  => requestInt('disabled'),	
		);

		$sp_uid = AccountMod::get_current_service_provider('uid');
		PayMod::set_sp_alipay_cfg($sp_uid, $cfg);
		outRight('ok');	
	}

	public function testpay() {
		$cfg = array(	
			'disabled'  => requestInt('disabled'),	
		);

		$sp_uid = AccountMod::get_current_service_provider('uid');
		PayMod::set_sp_testpay_cfg($sp_uid, $cfg);
		outRight('ok');	
	}

	public function balancepay() {
		$cfg = array(	
			'disabled'  => requestInt('disabled'),	
		);

		$sp_uid = AccountMod::get_current_service_provider('uid');
		PayMod::set_sp_balancepay_cfg($sp_uid, $cfg);
		outRight('ok');	
	}

	public function uctpay() {
		$cfg = array(	
			'disabled'  => requestInt('disabled'),	
			'wxpay'  => requestInt('wxpay'),	
			'alipay'  => requestInt('alipay'),	
		);

		$sp_uid = AccountMod::get_current_service_provider('uid');
		PayMod::set_sp_uctpay_cfg($sp_uid, $cfg);
		outRight('ok');	
	}

	/*
		提现设置
	*/
	public function withdraw() {
		$wd = array(	
			'enabled'  => requestInt('enabled'),	
			'wd_type'  => requestInt('wd_type', 1),	
			'withdraw_rule'  => requestKvJson('withdraw_rule', array(
							array('min_price', 'Int'),
							array('max_price', 'Int'),
							array('max_price_day', 'Int'),
							array('need_check', 'Int'),
							array('check_price', 'Int'),
							array('max_cnt_day', 'Int'),
						))	
		);

		$sp_uid = AccountMod::get_current_service_provider('uid');
		WithDrawMod::set_sp_withdraw($sp_uid, $wd);
		outRight('ok');	
	}

	/*
		提现
	*/
	public function do_transfer() {
		if(!$cash = requestInt('cash')) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		$_REQUEST['account'] = UctpayMod::get_current_phone();
		if(!SafetyCodeMod::check_mobile_code()) {
			outError();
		}
		
		outRight(UctpayMod::do_transfer($cash, AccountMod::get_current_service_provider('uid')));
	}

	/*
		管理员为用户充值或提现
	*/
	public function do_balance() {
		if(!($record['su_uid'] = requestInt('uid')) ||
			!($su = AccountMod::get_service_user_by_uid($record['su_uid'])) ||
			$su['sp_uid'] != AccountMod::get_current_service_provider('uid')) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		if(!$record['cash'] = requestInt('cash')) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		$record['info'] = requestStringLen('info');
		uct_use_app('su');
		if(1 == requestInt('type', 1)) {
			$record['info'] = '[管理员操作] 提现 '.$record['info'];
			outRight(SuPointMod::decrease_user_cash($record));
		}
		else {
			$record['info'] = '[管理员操作] 充值 '.$record['info'];
			outRight(SuPointMod::increase_user_cash($record));
		}
	}

	/*
		提现确定打款
	*/
	public function confirm_pay_withdraw() {
		$sp_uid = AccountMod::get_current_service_provider('uid');
		if((!$uid = requestInt('uid')) ||
			(!$wd = WithdrawMod::get_sp_user_withdraw_record_by_uid($uid)) ||
			($wd['sp_uid'] != $sp_uid)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(WithdrawMod::confirm_pay_withdraw($wd, $sp_uid));
	}

	/*
		提现拒绝打款
	*/
	public function refuse_pay_withdraw() {
		$sp_uid = AccountMod::get_current_service_provider('uid');
		if((!$uid = requestInt('uid')) ||
			(!$wd = WithdrawMod::get_sp_user_withdraw_record_by_uid($uid)) ||
			($wd['sp_uid'] != $sp_uid)) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}

		outRight(WithdrawMod::refuse_pay_withdraw($wd, $sp_uid));
	}

	public function set_refund() {
		$cfg = array(
			'type'  => requestInt('type'),
		);

		$sp_uid = AccountMod::get_current_service_provider('uid');
		PayMod::set_sp_refund_cfg($sp_uid, $cfg);
		outRight('ok');
	}


}


