<?php 
AccountMod::require_sp_uid();
uct_use_app('su');
SuMod::require_su_uid();

$app_id = 'wx22e2988bab0ca12a';
$app_secret= 'bc681f45fbdaf46b8acc966e9fac1eb1';
if(empty($_SESSION['3rd_openid'])) {
	if(empty($_GET['code'])) {
		$rurl = urlencode('http://weixin.uctphp.com/?'.http_build_query($_GET));
		$url = 'https://open.weixin.qq.com/connect/oauth2/authorize?appid='.$app_id.'&redirect_uri='.$rurl.
			'&response_type=code&scope=snsapi_base&state=STATE#wechat_redirect';
		redirectTo($url);
	}
	$param = array('appid'   => $app_id,
		'secret' => $app_secret,
		'code'   => $_GET['code'],
		'grant_type' => 'authorization_code',
	);
	$url = 'https://api.weixin.qq.com/sns/oauth2/access_token?' . http_build_query($param);
	$ret = Weixin::weixin_https_get($url);
	if(!$ret || !($ret = json_decode($ret, true)) ||
		    empty($ret['openid'])) {
		    setLastError(ERROR_DBG_STEP_3);
		    return false;
	}
	$_SESSION['3rd_openid'] = $ret['openid'];
}
?>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit"><!--360优先使用极速核-->
    <meta http-equiv="X-UA-COMPATIBLE" content="chrome=1,IE=Edge"><!--优先谷歌内核，最新ie-->
    <meta http-equiv="Cache-Control" content="no-siteapp"><!--不转码-->
    <!-- Mobile Devices Support @begin 针对移动端设置-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <!--文档宽度与设备宽度1：1 不允许缩放 -->
    <!-- apple devices -->
    <meta name="apple-mobile-web-app-title" content="N家原创"> <!--添加到主屏后的标题-->
    <meta name="apple-mobile-web-app-capable" content="yes"/> <!--启用WebApp全屏模式 -->
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent"/><!-- 顶端状态条 -->
    <meta name="apple-touch-fullscreen" content="yes"><!--全屏显示 -->
    <meta name="format-detection" content="telephone=no,email=no,address=no"><!--不识别电话邮箱地址-->
    <!-- Mobile Devices Support @end -->
    <meta name="keywords" content="your keywords"><!--关键字-->
    <meta name="description" content="your description"><!--描述-->
    <meta name="author" content="Near"><!--作者-->
    <title><?php echo $reward['title'];?></title>
    <!-- External CSS -->
    <link rel="stylesheet" href="<?php echo $static_path;?>/css/com.css">
    <style>
        
    </style>
</head>
<body>
<?php
if(empty($_GET['_d']) && !empty($su['uid'])) {
	if($me_record = Dba::readRowAssoc('select * from reward_record where r_uid = '.
		$reward['uid'].' && su_uid='.$su['uid'].' limit 1', 'RewardMod::func_get_reward_record')) {	
		include $tpl_path.'/index/userlist.tpl';
		exit;
	}
}

$key = 'accesstoken_'.$app_id;
if(!$t = $GLOBALS['arraydb_weixin_public'][$key]) {
	$t = Weixin::weixin_get_access_token($app_id, $app_secret);
	$GLOBALS['arraydb_weixin_public'][$key] = array('expire' => 6400, 'value' => $t);
}
$param = array(
                'access_token' => $t,
                'openid'       => $_SESSION['3rd_openid'],
                'lang'         => 'zh-CN',
);
$url = 'https://api.weixin.qq.com/cgi-bin/user/info?'.http_build_query($param);
$ret = Weixin::weixin_https_get($url);
if($ret && ($ret = json_decode($ret, true)) && !empty($ret['subscribe'])) {
	$has_subscribed_3rd = true;
}

?>
