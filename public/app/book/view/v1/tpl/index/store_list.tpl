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
</style>
<title>门店列表</title>
<link rel="stylesheet" href="/static/css/weui0.42.css" />
<link href="/static/css/font-awesome-4.6.3/css/font-awesome.min.css" rel="stylesheet">
<body>
<div style="max-width:640px;margin:0 auto; text-align:center;">
<h2 style="">门店列表</h2>
<div class="weui_panel weui_panel_access" style="margin-bottom:80px;">
<div style="color: #3cc51f" id="id_address">我的位置</div>
<div class="weui_panel_bd" id="id_list">
</div>
</div>
</div>

<script id="id_tpl" type="text/tpl">
<div class="weui_media_box weui_media_appmsg">
    <div class="weui_media_hd">
        <img class="weui_media_appmsg_thumb" src="{{=it.main_img}}"/>
    </div>
    <div class="weui_media_bd" style="text-align:left;">
        <h4 class="weui_media_title">{{=it.name}}</h4>
		<a href="?_easy=web.index.map&lat={{=it.lat}}&lng={{=it.lng}}&name={{=it.name}}">
        <p class="weui_media_desc"><b class="fa fa-map-marker"></b> {{=it.address}}</p>
        <p class="weui_media_desc">距离 
		<span class="cdistance" style="color:red;" data-lat="{{=it.lat}}" data-lng="{{=it.lng}}">-</span>
		</p>
		</a>
    </div>
    <div class="" style="width:32px;">
		<a href="tel:{{=it.telephone}}" class="fa fa-phone"></a>
	</div>
</div>
</script>

<?php include $tpl_path.'/footer.tpl';?>
</body>

<script src="/static/js/jquery2.1.min.js"></script>
<script src="/static/js/doT.min.js"></script>
<script src="/static/js/scroll_load.js"></script>
<?php include UCT_PATH.'app/web/tpl/common/common_get_location.tpl';?>
<script>
scroll_load({'ele_container': '#id_list', 'ele_dot_tpl': '#id_tpl',
'url': '?_a=book&_u=ajax.store_list'
});
var g_lng = null;
var g_lat = null;
var g_name= '我的位置';

$('#id_address').click(function(){
auto_get_location(function(lng, lat, addr){
	g_lng = lng;
	g_lat = lat;
	g_name = addr;
	//console.log('get location... ', lng, lat);
	$('#id_address').text(g_name);
	update_distance();
});
});
$('#id_address').click();

function update_distance() {
	if(g_lng === null || g_lat === null) return;
	$('.cdistance').each(function(){
		var lng = $(this).attr('data-lng');
		var lat = $(this).attr('data-lat');
		if(!lng || !lat || (lng == 0 && lat == 0)) {
			return;
		}
		var dist = get_geo_distance(lat, lng, g_lat, g_lng);	
		//console.log('ooooo', lat, lng, g_lat, g_lng, dist);

		dist = dist >= 1 ? dist.toFixed(1)+'km' : (dist*1000).toFixed(0)+'m' 
		$(this).text(dist);
	});
}


</script>
</html>
