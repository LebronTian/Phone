<?php

class AlipayCtl {
	/*
		即时到帐测试	
	*/
	public function directpay() {
		return;
		$option = array(
			'trade_no' => 123,
			'total_fee' => '0.01', //注意这个单位是元不是分
			'subject'  => '商品标题',
			'body'     => '手机 X1 \n 平板 X2',
		);
	
		$ret = AlipayMod::direct_pay($option);
		echo $ret;
	}	

	/*
		即时到帐		
	*/
	public function dodirectpay() {
		if(!($oid = requestString('oid', PATTERN_ORDER_UID))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		outRight(AlipayMod::do_direct_pay_by_oid($oid));
	}	

	//支付宝异步通知, 成功输出 success
	public function direct_notify() {
		//删除框架添加的  _a, _u, _sp_uid 等, 这些会导致支付宝签名验证出错
		if($_POST) 
		foreach($_POST as $k => $v) {
			if(is_string($k) && ($k[0] == '_')) unset($_POST[$k]);
		}
		
		if(AlipayMod::direct_notify()) {
			echo 'success';
			exit();
		}
		else {
			echo 'fail';
		}
	}

	//支付宝同步通知, 成功跳转到订单详情页
	public function direct_return() {
		//删除框架添加的  _a, _u, _sp_uid 等, 这些会导致支付宝签名验证出错
		if($_GET) 
		foreach($_GET as $k => $v) {
			if(is_string($k) && ($k[0] == '_')) unset($_GET[$k]);
		}
		
		if($info = AlipayMod::direct_return()) {
			redirectTo($info['return_url']);
		}
		else {
			outError(null, '支付宝支付错误, 请联系客服!');
		}
	}

	//支付宝退款异步通知, 成功输出 success
	public function refund_notify() {
		//删除框架添加的  _a, _u, _sp_uid 等, 这些会导致支付宝签名验证出错
		if($_POST) 
		foreach($_POST as $k => $v) {
			if(is_string($k) && ($k[0] == '_')) unset($_POST[$k]);
		}
		
		if(AlipayMod::refund_notify()) {
			logResult('ali refund notify  succeed');
			echo 'success';
			exit();
		}
		else {
			logResult('ali refund notify  failed!'.getLastError());
			echo 'fail';
		}
	}


}

