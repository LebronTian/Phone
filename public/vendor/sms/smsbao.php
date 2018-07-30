<?php
/*
	http://smsbao.com/
	短息宝发送短信

	可以一次发送多个号码

	返回说明
	$statusStr = array(
		'0' => '短信发送成功',
		'-1' => '参数不全',
		'-2' => '服务器空间不支持,请确认支持curl或者fsocket，联系您的空间商解决或者更换空间！',
		'30' => '密码错误',
		'40' => '账号不存在',
		'41' => '余额不足',
		'42' => '帐户已过期',
		'43' => 'IP地址限制',
		'50' => '内容含有敏感词'
	);
*/
function send_sms($phone, $msg) {
	if(!function_exists('send_sms_siring')) {
		include UCT_PATH.'vendor/sms/siring.php';
	}
	return send_sms_siring($phone, $msg); 


	$account = SMSBAO_ACCOUNT;
	$password = SMSBAO_PASSWORD;

	if(is_array($phone)) {
		$phone = implode(',', $phone);
	}

	$smsapi = 'http://api.smsbao.com/'; //短信网关
	$sendurl = $smsapi.'sms?u='.$account.'&p='.md5($password).'&m='.$phone.'&c='.urlencode($msg);
	$ret = file_get_contents($sendurl) ;

	if($ret != '0') {
		Weixin::weixin_log('smsbao sms FAILED! -> msg ['.$msg.']'.$ret);
	}

	return $ret == '0';
}



