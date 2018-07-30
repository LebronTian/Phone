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
<style>
a {
	color:#04BE02;
}

.ca {
width:100%;height:150px;
display:block;
}
.ca img {
width:100%;height:100%;
}
</style>
<title>活动</title>
<link rel="stylesheet" href="/static/css/weui0.42.css" />
<link href="/static/css/font-awesome-4.6.3/css/font-awesome.min.css" rel="stylesheet">
<body>
<div style="max-width:640px;margin:0 auto; text-align:center;">
<h2 style="">全部活动</h2>
<div class="weui_panel weui_panel_access" style="margin-bottom:80px;">
<!-- <div style="color: #3cc51f">我的位置</div> -->
<div class="weui_panel_bd" id="id_list">
</div>
</div>
</div>

<script id="id_tpl" type="text/tpl">
<a class="ca" href="{{=it.link || 'javascript:;'}}">
<img src="{{=it.image}}" alt="{{=it.title}}">
</a>
</script>

<?php include $tpl_path.'/footer.tpl';?>
</body>

<script src="/static/js/jquery2.1.min.js"></script>
<script src="/static/js/doT.min.js"></script>
<script src="/static/js/scroll_load.js"></script>
<script>
scroll_load({'ele_container': '#id_list', 'ele_dot_tpl': '#id_tpl',
'url': '?_a=book&_u=ajax.activity_list'
});
</script>
</html>
