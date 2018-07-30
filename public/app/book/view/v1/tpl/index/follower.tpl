<?php
	uct_use_app('su');
	$su = SuMod::require_su_uid();
	$option['level'] = requestInt('level', 1);
?>

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
<title>我的团队</title>
<link rel="stylesheet" href="/static/css/weui0.42.css" />
<link href="/static/css/font-awesome-4.6.3/css/font-awesome.min.css" rel="stylesheet">
<link rel="stylesheet" href="<?php echo $static_path;?>/css/point_orders.css" />

<style>
@media screen and (device-aspect-ratio: 2/3) {
	.shop_module_slist .banner_logo{top:40px;}
	.shop_module_slist .category_list{bottom:40px;}
	.ratio2{
		.shop_module_slist .banner_logo{top:80px;}
		.shop_module_slist .category_list{bottom:80px;}
	}
}
</style>
</head>

<script>
    if(window.scale==0.5){document.write('<body class="zh_CN ratio2 ">');}
    else{document.write('<body class="zh_CN ">');}
</script>


<style>
    .orderlist-section{background: white;border-top: thin solid #e2e2e2}
    .orderlist-section li{padding: 1rem 0;width: 3rem}
    .btn-group button{border: none;border-radius: 3px;padding: 8px;}

    .load-more{text-align: center}

</style>
<div class="weui_navbar" style="position:fixed">
            <a href="?_easy=qrposter.v2.index.follower" class="weui_navbar_item 
					<?php if(($option['level']=="1")) echo 'weui_bar_item_on'?>">
                我的粉丝
            </a>
<!--
            <a href="?_easy=qrposter.v2.index.follower&level=2" class="weui_navbar_item
					<?php if(($option['level']=="2")) echo 'weui_bar_item_on'?>">
				二级粉丝
            </a>
            <a href="?_easy=qrposter.v2.index.follower&level=3" class="weui_navbar_item
					<?php if(($option['level']=="3")) echo 'weui_bar_item_on'?>">
				三级粉丝
            </a>
-->
</div>

<div style="margin: 0 auto;max-width:640px;">
	<div class="weui_panel weui_panel_access" style="margin-top:50px;margin-bottom:0px;">
		<div class="weui_panel_bd">
		</div>
	</div>
</div>

<script id="id_tpl" type="text/tpl">
<a href="javascript:;" class="weui_media_box weui_media_appmsg">
    <div class="weui_media_hd">
        <img class="weui_media_appmsg_thumb" src="{{=it.avatar || '/static/images/null_avatar.png'}}">
    </div>
    <div class="weui_media_bd">
        <h4 class="weui_media_title">{{=it.name || it.account}}</h4>
        <p class="weui_media_desc">{{=date('Y-m-d H:i:s', it.create_time)}}</p>
    </div>
</a>
</script>

<script src="/static/js/jquery2.1.min.js"></script>
<script src="/static/js/doT.min.js"></script>
<script src="/static/js/php/date.js"></script>
<script src="/static/js/scroll_load.js"></script>

<script>
if(!$.parseJSON) {
$.parseJSON = function(str) {
	return JSON.parse(str);
};
}

var option = <?php echo json_encode($option);?>;

scroll_load({'ele_container': '.weui_panel_bd', 'ele_dot_tpl': '#id_tpl',
'url': '?_a=qrposter&_u=ajax.follower&level='+option.level
});
</script>
</body>
</html>
