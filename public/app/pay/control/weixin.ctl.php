<?php
/*
	微信支付
*/

class WeixinCtl {
	/*
		暂不支持 扫码支付模式一
	*/
	public function native1() {
		return;
		$product_uid = 123456;
		$url = WxPayMod::get_native1_url($product_uid);	
		echo $url;
	}

	/*
		测试 扫码支付模式二
	*/
	public function native2() {
		return;
		$option = array(
			'body' => '商品标题',
			'detail' => '商品详情\n第二行\n第三行',
			'attach' => 'xxx',
			'goods_tag' => 'ggg',
			'trade_no' => 124,
			'product_uid' => 456,
			'total_fee' => 1,
			'time_start' => date('YmdHis', $_SERVER['REQUEST_TIME']),
			'time_expire' => date('YmdHis', $_SERVER['REQUEST_TIME'] + 7200),
			'notify_url' => WxPayMod::get_weixin_notify_url(),
		);
		$ret = WxPayMod::get_native2_url($option);
		var_export($ret);	
	}

	/*
		测试 企业付款
	*/
	public function transfers() {
		$option = array(
			'trade_no' => 125,
			'openid' => 'oWhGnjjYvTd0aQf-IRH9w4KJM6vU',
			'amount' => 1,
			'check_name' => 'OPTION_CHECK',
			're_user_name' => '刘路浩',
			'desc' => '企业付款\n 注意查收',
		);

		WxPayMod::setConfig(array(
							'SSLCERT_PATH' => CERT_PATH.'uct/wx/apiclient_cert.pem',
							'SSLKEY_PATH' => CERT_PATH.'uct/wx/apiclient_key.pem',
							));
		$ret = WxPayMod::transfers($option);
		var_export($ret);
	}

	/*
		测试 发送红包
	*/
	public function redpack() {
		$option = array(
			'trade_no' => 128,
			'openid' => 'oWhGnjjYvTd0aQf-IRH9w4KJM6vU',
			'total_amount' => 100,
			'nick_name' => '快马加鞭',
			'send_name' => '小优',
			'wishing' => '小优祝您恭喜发财 注意查收',
			'act_name' => '新版上线庆祝红包',
			'remark' => '备注',
			'logo_imgurl' => 'http://weixin.uctphp.com/app/sp/static/images/logo-b.png',
			'share_url' => 'http://weixin.uctphp.com/',
			'share_imgurl' => 'http://weixin.uctphp.com/app/sp/static/images/login-bj.png',
			'share_content' => '小优发红包啦,快来领取吧!',
		);

		WxPayMod::setConfig(array(
							'SSLCERT_PATH' => CERT_PATH.'uct/wx/apiclient_cert.pem',
							'SSLKEY_PATH' => CERT_PATH.'uct/wx/apiclient_key.pem',
							));
		#$ret = WxPayMod::redpack($option);
		#var_export($ret);
	}

#-------------------


	/*
		生成扫码支付二维码 模式二
		订单号oid 
	*/
	public function native2qrcode() {
		if(!($oid = requestString('oid', PATTERN_ORDER_UID))) { 
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		if(!($url = WxPayMod::get_native2_url_by_oid($oid))) {
			outError();
		}

		require_once UCT_PATH.'vendor/phpQrcode/PHPQRCode.php';
		\PHPQRCode\QRcode::png($url);
	}

	/*
		扫码支付模式一回调通知
	*/
	public function native1_notify() {
		WxPayMod::native1_notify();
	}

	/*
		扫码支付模式二回调通知
	*/
	public function native2_notify() {
		WxPayMod::native2_notify();
	}

	/*
		当没有收到微信支付结果回调通知时,
		可以主动查询微信并更新订单支付情况

		注意这里没有检查用户权限
	*/
	public function update_order() {
		if(!($oid = requestString('oid', PATTERN_ORDER_UID))) {
			outError(ERROR_INVALID_REQUEST_PARAM);
		}
		
		outRight(WxPayMod::query_and_update_weixin_order(array('trade_no' => $oid)));
	}
}

