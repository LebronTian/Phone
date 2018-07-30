<!DOCTYPE html>
<html>
<head>
<meta http-equiv=Content-Type content="text/html;charset=utf-8">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="format-detection" content="telephone=no">
<script>
window.scale=1;
if (window.devicePixelRatio === 2 && window.navigator.appVersion.match(/iphone/gi)) {
    //scale = 0.5;
}
var text = '<meta name="viewport" content="initial-scale=' + scale + ', maximum-scale=' + scale +', minimum-scale=' + scale + ', user-scalable=no" />';
document.write(text);
</script>
<title>分享给好友</title>
<link rel="stylesheet" href="/static/css/weui0.42.css" />
<!-- <link href="//netdna.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css" rel="stylesheet">-->
<body style="max-width:640px;margin:0 auto; text-align:center;">

    <div class="page">
        <div class="hd small-hd">
            <h1 class="page_title">我来邀请</h1>
        </div>
        <div class="bd spacing">
            <article class="">
                <p class="qrcode-title tips-font">我的邀请二维码</p>
                <div class="qrcode-box">
                    <img src="?_a=web&_u=index.qrcode&url=<?php if(!empty($url)) echo rawurlencode($url) ?>">
                </div>
                <p class="qrcode-title active-font margin-bottom">
                    您可以保存二维码发送给朋友<br>
                </p>
            </article>
        </div>
    </div>

</body>
</html>