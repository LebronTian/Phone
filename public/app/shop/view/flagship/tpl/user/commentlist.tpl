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
    <title><?php if(!empty($shop['title'])) echo $shop['title'] ?></title>
    <link rel="shortcut icon" href="/static/images/logo.ico" type="image/x-icon">
    <!-- External CSS -->
    <link rel="stylesheet" href="/static/css/style.css">
    <!--todo：涉及UI的框架css，思考如果实现可配置-->
    <!--todo：初步想法，使用php里的 include 外链一段css，测试可行，可以通过后台传入参数-->
    <!--todo：开发注意提取元素就好-->
    <!--用php输出下面style-->
    <style>/*echo.css*/</style>
    <link rel="stylesheet" href="/static/css/echo.css">
</head>
<body>
<!--todo*************************************************************************************************************-->
<style>
    body{background: white}
    .commentlist-section{border-bottom: thin solid #dadada;padding-bottom: 1rem}
    .commentlist-section.left-right-section .right-section{padding-left: 5rem;padding-right: 0.834rem}
    .avatar-img{width: 5rem;height: 5rem;border-radius: 50%;padding: 1rem}
    .commentlist-title{padding-top: 1rem;height: 3rem;line-height: 3rem;}
    .commentlist-star-group{float: right;vertical-align: middle}
    .commentlist-star-group>img{width: 1.5rem;}
    /**/
    .commentlist-pic-article section{ height: 0;width: 22%;position: relative;padding:0 0 22%;float: left;margin-right: 4%;margin-bottom: 1rem;background: white}
    .commentlist-pic-article section:nth-child(4n){margin-right: 0}
    .commentlist-pic-article section>.square-div{ position: absolute;height: 100%;width: 100%;border: thin solid #dadada;text-align: center}
    .square-div>img{width: 100%;height: 100%;}
    .square-div.text-square span{vertical-align: middle;}
</style>
<header class="color-main vertical-box">
    <span class="header-title">评价</span>
    <div class="header-left vertical-box">
        <img class="img-btn" src="/static/images/back.png" onclick="history.back()">
    </div>
    <div class="header-right vertical-box">
        <img class="img-btn" src="/static/images/home.png" onclick="window.location.href='/index'">
    </div>
</header>
<article class="margin-top margin-bottom">
    <section class="commentlist-section left-right-section">
        <div class="left-section">
            <img class="avatar-img border-box" src="/static/images/demo1.png">
        </div>
        <div class="right-section border-box">
            <div class="commentlist-title vertical-box">
                <span class="tips-font">asdasdasd</span>
                <div class="commentlist-star-group">
                    <img src="/static/images/star1.png">
                    <img src="/static/images/star1.png">
                    <img src="/static/images/star1.png">
                    <img src="/static/images/star1.png">
                    <img src="/static/images/star1_.png">
                </div>
            </div>
            <p class="comment-content tips-font">大爱啊！原本就是红色控，看见这件衣服太符合我的口味咯～</p>
            <article class="commentlist-pic-article">
                <section><div class="square-div">
                    <img src="/static/images/demo1.png">
                </div></section>
                <section><div class="square-div">
                    <img src="/static/images/demo1.png">
                </div></section>
                <section><div class="square-div">
                    <img src="/static/images/demo1.png">
                </div></section>
                <section><div class="square-div">
                    <img src="/static/images/demo1.png">
                </div></section>
            </article>
            <p class="white-tips-font small-text">2015-10-24    颜色：红色    尺码：S</p>
        </div>
    </section>


    <section class="commentlist-section left-right-section">
        <div class="left-section">
            <img class="avatar-img border-box" src="/static/images/demo1.png">
        </div>
        <div class="right-section border-box">
            <div class="commentlist-title vertical-box">
                <span class="tips-font">asdasdasd</span>
                <div class="commentlist-star-group">
                    <img src="/static/images/star1.png">
                    <img src="/static/images/star1.png">
                    <img src="/static/images/star1.png">
                    <img src="/static/images/star1.png">
                    <img src="/static/images/star1_.png">
                </div>
            </div>
            <p class="comment-content tips-font">大爱啊！原本就是红色控，看见这件衣服太符合我的口味咯～</p>
            <article class="commentlist-pic-article">
                <section><div class="square-div">
                    <img src="/static/images/demo1.png">
                </div></section>
                <section><div class="square-div">
                    <img src="/static/images/demo1.png">
                </div></section>
                <section><div class="square-div">
                    <img src="/static/images/demo1.png">
                </div></section>
                <section><div class="square-div text-square vertical-box">
                    <span class="active-font">更多...</span>
                </div></section>
            </article>
            <p class="white-tips-font small-text">2015-10-24    颜色：红色    尺码：S</p>
        </div>
    </section>
</article>
<!--end*************************************************************************************************************-->
<script src="/static/js/sea.js"></script>
<script src="/static/js/seajs-css.js"></script>
<!--<script src="/static/js/seajs-preload.js"></script>-->
<script src="/static/js/seajs_option.js"></script>
<!--todo:************************************************************************************************************-->
<script>
    //'jquery' or 'zepto' 脚本入口,按情况选择加载
    seajs.use('zepto', function () {
        $(document).ready(function () {

        })
    });
</script>
</body>
</html>