<?php

/*
	思瑞短信接口
	http://www.siring.com.cn/
	
	网页地址 http://120.26.38.54:8000/login.aspx
			 
	账户：
	密码：
*/

/*
	$phone 手机号码, 多个用逗号分开
	$msg  短信内容 


	返回码
	0：提交成功
	
	[-1]：账号、密码都不能为空 
	[-2]：账号、密码不匹配
	[-3]：手机号码为空或者超过最大发送数目300
	[-4]：内容不能为空或者超过268个字
	[-5]: 号码格式错误,只对提交单一号码时候检测返回,如果是多个号码提交,当中某个号码不正确,系统会过滤掉,但不返回错误.
	[-6]: 发送内容含有明显的违法词组.
	[-100]：帐号没有余额

*/
function send_sms_siring($phone, $msg, $cfg = array()) {
	if(!isset($cfg['sign'])) {
		#$cfg['sign'] = checkString($msg, '/【(.*?)】/u');
		#$msg = str_replace('【'.$cfg['sign'].'】', '', $msg);
		#if(!$cfg['sign']) $cfg['sign'] = '快马加鞭';
	}

	//营销通道
	$username = SMSBAO_ACCOUNT;
	$pwd = SMSBAO_PASSWORD;

	if(isset($cfg['username'])) {
		$username = $cfg['username'];
	}
	if(isset($cfg['pwd'])) {
		$pwd = $cfg['pwd'];
	}
	$url = 'http://120.26.38.54:8000/interface/smssend.aspx';

	$params = array(
			   'account'=> $username,
			   'password' => $pwd,
			   'mobile' => $phone,
			   'content' => $msg,
				#'port' => '', //下发端口(总长度21) 如果需要指定端口，地址要换成这个 smssend02.aspx 
	);

	$c = curl_init();
	curl_setopt($c, CURLOPT_URL, $url);
	curl_setopt($c, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($c, CURLOPT_SSL_VERIFYPEER, false);
	curl_setopt($c, CURLOPT_SSL_VERIFYHOST, false);
	curl_setopt($c, CURLOPT_POST, true);
	curl_setopt($c, CURLOPT_POSTFIELDS, $params);
	$ret = curl_exec($c);
	curl_close($c);
	//echo $ret; 返回示例  1,EE1DA965-66C1-44E7-915E-5F7C08BFC880
	$ok = current(explode(',', $ret, 2));
	if($ok <= 0) {
		Weixin::weixin_log('siring sms FAILED! -> msg ['.$msg.'], ret '.$ret);
		return false;
	} 	
	return true;
}

