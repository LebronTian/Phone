<?php
$sp_uid = $vip_card_sp_set['sp_uid'];
$ret=WeixinMod::get_current_weixin_public();
if($ret['has_verified'] && $ret['public_type']==2 )
{
	$exit=true;
}
else
{
	$exit=false;
}
//判断有没有su_uid：
if (!($su_uid = requestInt('su_uid')) )
{
	//没有：取现在用户的su_uid
	uct_use_app('su');
	($su_uid = SuMod::require_su_uid($exit));
//	$su_uid = AccountMod::has_su_login();
//			$su_uid = 1;//test!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	if($su_uid==0){
		//0代表取不到，取不到代表没有关注//在前端判断处理
	}
	// 根据su_uid取用户信息
	$vip_card_info = VipcardMod::get_vip_card_info($su_uid,$sp_uid);
	// var_dump($vip_card_info['vip_card_su']['su_uid']);

	//根据信息里面的su_uid判断有没有会员卡
	if(!empty($vip_card_info['vip_card_su']['su_uid']) && !empty($vip_card_info['vip_card_su']['card_url']) ){
		//有的话也重定向去result看自己的

		redirectTo('?_a=vipcard&_u=index.result&su_uid='.$su_uid);
	}
}
else{
	//有：重定向去result，看自己的或者，其他人的
	redirectTo('?_a=vipcard&_u=index.result&su_uid='.$su_uid);
}
?>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-COMPATIBLE" content="chrome=1,IE=Edge">
	<!--优先谷歌内核，最新ie-->
	<meta name="format-detection" content="telephone=no,email=no,address=no">
	<!--不识别电话邮箱地址-->
	<meta http-equiv="Cache-Control" content="no-siteapp">
	<!--不转码-->
	<!-- Mobile Devices Support @begin 使手机上比例正常-->
	<meta name="viewport"
	      content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
	<!--文档宽度与设备宽度1：1 不允许缩放 -->
	<!-- apple devices -->
	<meta name="apple-mobile-web-app-capable" content="yes"/>
	<!-- wabapp程序支持 -->
	<meta name="apple-mobile-web-app-status-bar-style" content="white"/>
	<!-- 顶端状态条 -->
	<meta name="apple-touch-fullscreen" content="yes">
	<!--全屏显示 -->
	<!-- Mobile Devices Support @end -->
	<title>GirlsGroup</title>
	<link rel="shortcut icon" href="<?php echo $static_path . '/images/logo.png' ?>" type="image/x-icon">

	<link rel="stylesheet" href="<?php echo $static_path . '/css/style.css' ?>">
	<link rel="stylesheet" href="<?php echo $static_path . '/css/index.css' ?>">
	<style>body{background-image: url("<?php echo  $static_path.'/images/bg.png'?>");}</style>

</head>
<body>
<!--todo--------------------------------------------------------------------------start-->
<!--首页-start-->
<div class="index-content div-content">
	<img class="index-vipcard-logo" src="<?php echo $static_path . '/images/logo.png' ?>">
	<p class="index-vipcard-describe">女行团是专属女性的旅行摄影团体</p>
	<p class="index-vipcard-describe">我们除了会组织女孩儿们去全世界女行拍美照</p>
	<p class="index-vipcard-describe">还会在旅途中安排各种独有的分享与活动</p>
	<p class="index-vipcard-describe">让你的女行不再是走马观花。</p>
	<img class="index-vipcard-code" src="<?php echo $static_path . '/images/QRCode.png' ?>">
	<p>
		<button class="content-bottom-button index-next-button">立即加入我们</button>
	</p>
</div>
<!--首页-end-->
<script>
	var su_uid = <?php echo(!empty($su_uid)? json_encode($su_uid):"null")?>;//vipcard的设置
	var vip_card_info = <?php echo(!empty($vip_card_info)? json_encode($vip_card_info):"null")?>;      //用户的信息
	console.log(su_uid, vip_card_info)
</script>
<!--todo----------------------------------------------------------------------------end-->
<script src="/static/js/jquery2.1.min.js"></script>
<script>
$(document).ready(function() {
	var window_height = $(window).height();
    $("body").css("min-height", window_height);
	// body...
	$(".index-next-button").click(function(){
		if(!su_uid){
			alert('长按二维码关注我先咯！');
            return;	
		}
		window.location.href = '?_easy=vipcard.simple.index.form&su_uid='+su_uid;
	});
})

</script>

</body>
</html>