<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-COMPATIBLE" content="IE=Edge,chrome=1">   <!--优先谷歌内核，最新ie-->
    <meta name="format-detection" content="telephone=no,email=no,address=no">     <!--不识别电话邮箱地址-->
    <meta http-equiv="Cache-Control" content="no-siteapp">    <!--不转码-->
    <!-- Mobile Devices Support @begin 使手机上比例正常-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <!--文档宽度与设备宽度1：1 不允许缩放 -->
    <!-- apple devices -->
    <meta name="apple-mobile-web-app-capable" content="yes"/> <!-- wabapp程序支持 -->
    <meta name="apple-mobile-web-app-status-bar-style" content="white"/><!-- 顶端状态条 -->
    <meta name="apple-touch-fullscreen" content="yes"><!--全屏显示 -->
    <!-- Mobile Devices Support @end -->
    <link rel="stylesheet" href="/app/su/view/bigidea/css/style.css">
</head>
<body>
<header>
    <div class="header-background">
        <img src="/app/su/view/bigidea/images/header.png"/>
        <img id="header-logo" src="/app/su/view/bigidea/images/logo.png"/>
    </div>
<!----------------------------------------------------------------------------------------------------------------------------------------------------------->
    <div class="header-top">
        <img class="header-font-title" src="/app/su/view/bigidea//images/font-title1.png"/>
        <img class="header-pic-title" src="/app/su/view/bigidea/images/title2.png"/>
    </div>
</header>
<article class="body-content">
    <section>
        <span class="font-left">参赛编码：</span><input class="input-right" type="text"/>
    </section>
    <section>
        <span class="font-left">上传作品：</span>
        <button class="upload-btn">请选择作品</button><small class="upload-describe">仅限一张图片<br/>2M以内</small>
    </section>
    <section>
        <span class="font-left">作品名称：</span><input class="input-right" type="text"/>
    </section>
    <section>
        <span class="font-left">创意描述：</span><textarea class="textarea-right"></textarea>
    </section>
</article>
<div class="bottom-button">
    <img class="bottom-2button" id="upload-pic" src="/app/su/view/bigidea/images/upload.png"/>
    <img class="bottom-2button" src="/app/su/view/bigidea/images/reload.png"/>
</div>
<!----------------------------------------------------------------------------------------------------------------------------------------------------------->
<footer></footer>
<script src="/app/su/view/bigidea/js/zepto.min.js"></script>
<script>
    $(document).ready(function () {
        $("#upload-pic").click(function () {

        })
    })
</script>
</body>
</html>
















