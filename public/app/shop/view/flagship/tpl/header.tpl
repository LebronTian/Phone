<?php $shop = ShopMod::get_shop() ?>
<?php if(!empty($shop['sp_uid'])) $color1 = $GLOBALS['arraydb_sys']['cfg_shop_setcolor_1'.$shop['sp_uid']];?>
<?php if(!empty($shop['sp_uid'])) $color2 = $GLOBALS['arraydb_sys']['cfg_shop_setcolor_2'.$shop['sp_uid']];?>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit"><!--360优先使用极速核-->
    <meta http-equiv="X-UA-COMPATIBLE" content="chrome=1,IE=Edge"><!--优先谷歌内核，最新ie-->
    <meta http-equiv="Cache-Control" content="no-siteapp"><!--不转码-->
    <!-- Mobile Devices Support @begin 针对移动端设置-->
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no">
    <!--文档宽度与设备宽度1：1 不允许缩放 -->
    <!-- apple devices -->
    <meta name="apple-mobile-web-app-title" content="快马加鞭
"> <!--添加到主屏后的标题-->
    <meta name="apple-mobile-web-app-capable" content="yes"/> <!--启用WebApp全屏模式 -->
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent"/><!-- 顶端状态条 -->
    <meta name="apple-touch-fullscreen" content="yes"><!--全屏显示 -->
    <meta name="format-detection" content="telephone=no,email=no,address=no"><!--不识别电话邮箱地址-->
    <!-- Mobile Devices Support @end -->
    <meta name="keywords" content="">
    <meta name="description" content="">
    <meta name="author" content="Near"><!--作者-->
    <title><?php if(!empty($shop['title'])) echo $shop['title'] ?></title>
    <link rel="shortcut icon" href="<?php echo $static_path;?>/images/logo.ico" type="image/x-icon">
    <!-- External CSS -->
	<link rel="stylesheet" href="<?php echo $static_path;?>/css/weui0.42.css" />
	<link rel="stylesheet" href="<?php echo $static_path;?>/css/font-awesome.min.css" />
    <!--todo：涉及UI的框架css，思考如果实现可配置-->
    <!--todo：初步想法，使用php里的 include 外链一段css，测试可行，可以通过后台传入参数-->
    <!--todo：开发注意提取元素就好-->
    <!--用php输出下面style-->
   <script src="/static/js/jquery1.7.min.js" type="text/javascript" charset="utf-8"></script>
   <script src="/static/js/jquery.cookie.js" type="text/javascript" charset="utf-8"></script>
    <style><?php include UCT_PATH.'app/shop/tpl/sp/color.tpl' ?></style>
    <link rel="stylesheet" href="<?php echo $static_path;?>/css/style.css">
    	<style type="text/css">
    		.container{padding: 1%;margin-bottom: 60px;}
			.b-main,.color-main,.active-bg,.bg-primary,.order-green-ball{background: #<?php echo ($color1)? $color1:'fff' ?> !important;color: #fff;}
			.c-green,.text-active,.secondary-font,.text-primary,.big-text .fa,.active-border{color:#<?php echo ($color1)? $color1:'333'?> !important;}
			.svg-main{fill:#<?php echo ($color1)? $color1:'333'?> !important;}
			.active-bottom{border-bottom: thin solid #<?php echo ($color1)? $color1:'eee'?>}
    	</style>
</head>
<body>
