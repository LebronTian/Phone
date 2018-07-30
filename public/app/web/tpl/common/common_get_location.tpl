<?php
/*
	本文件提供2个函数

	1. web 获取地理位置
	auto_get_location(callback);
		callback = function(lng, lat)
		微信浏览器中调用微信js sdk，h5环境使用h5 api

	2. 计算2个经纬度之间的距离
	get_geo_distance(lat1,lng1, lat2,lng2)
*/

if(isWeixinBrowser()) {
?>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script>
var wx_cfg = <?php echo json_encode(WeixinMod::get_jsapi_params());?>;
wx_cfg['debug'] = <?php echo !empty($_REQUEST['_d']) ? 'true' : 'false';?>;
wx_cfg['jsApiList'] = ["getLocation"];
wx.config(wx_cfg);
function auto_get_location(callback) {
wx.ready(function(){
	// 默认为wgs84的gps坐标，如果要返回直接给openLocation用的火星坐标，可传入"gcj02"
	wx.getLocation({
		'type': 'wgs84',
		'success': function(res) {
			var lat = res.latitude; // 纬度，浮点数，范围为90 ~ -90
			var lng = res.longitude; // 经度，浮点数，范围为180 ~ -180。
			var speed = res.speed; // 速度，以米/每秒计
			var accuracy = res.accuracy; // 位置精度
			$.get('?_easy=web.index.geo2name&lat='+lat+'&lng='+lng+'&type=tencent', function(ret){
				ret = $.parseJSON(ret);
				console.log('location... ', ret);
				if(ret.data && ret.data.address) {
					callback(lng, lat, ret.data.address);
				} else {
					callback(lng, lat, '-');
				}
			});
		}
	});
});
}
</script>
<?php
} else {
?>
<script>
function auto_get_location(callback) {
navigator.geolocation.getCurrentPosition(function(p){
	var lat = p.coords.latitude//纬度
	var lng = p.coords.longitude;
	$.get('?_easy=web.index.geo2name&lat='+lat+'&lng='+lng+'&type=gps', function(ret){
		ret = $.parseJSON(ret);
		console.log('location... ', ret);
		if(ret.data && ret.data.address) {
			callback(lng, lat, ret.data.address);
		} else {
			callback(lng, lat, '-');
		}
	});
});
}
</script>
<?php
}
?>

<script>
var EARTH_RADIUS = 6378137.0;    //单位M
function Rad(d){
	return d*Math.PI/180.0;
}
function get_geo_distance(lat1,lng1, lat2,lng2) {
  var radLat1 = Rad(lat1);
  var radLat2 = Rad(lat2);
  var a = radLat1 - radLat2;
  var b = Rad(lng1) - Rad(lng2);
  var s = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a/2),2) +
  Math.cos(radLat1)*Math.cos(radLat2)*Math.pow(Math.sin(b/2),2)));
  s = s *6378.137 ;// EARTH_RADIUS;
  //s = Math.round(s * 10000) / 10000; //输出为公里
  //s=s.toFixed(4);
  return s;
}
</script>

