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
    <title><?php echo(!empty($form['title']))? $form['title']:'女行小课堂'?></title>
    <link rel="shortcut icon" href="/app/shop/view/wap/static/images/logo.png" type="image/x-icon">
    <!-- External CSS -->
    <?php
    if(!empty($form['uid'])){
        $k = 'cfg_form_girl_setcolor_'.AccountMod::require_sp_uid().'_'.$form['uid'];
        $color = SpExtMod::get_sp_ext_cfg($k);
    }
    else{
        $color = '';
    }
    ?>
    <style>
        .php-color{color: #<?php echo $color ?>}
        .php-background{background-color: #<?php echo $color ?>}
    </style>
    <link rel="stylesheet" href="<?php echo $static_path ?>/css/style.css">
    <link rel="stylesheet" href="<?php echo $static_path ?>/css/color.css">
</head>
<body>
<!--todo*************************************************************************************************************-->