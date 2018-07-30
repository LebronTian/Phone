<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
	<style type="text/css">
	body, html,#allmap {width: 100%;height: 100%;overflow: hidden;margin:0;font-family:"微软雅黑";}
	</style>
	<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=gNv9hMjFVfBRovS4XwN59w9g"></script>
	<title><?php echo $name;?></title>
</head>
<body>
	<div id="allmap"></div>
</body>
</html>
<script type="text/javascript">
<?php
echo 'var g_lng = '.$lng.';';
echo 'var g_lat = '.$lat.';';
echo 'var g_name= '.json_encode($name).';';
?>
	// 百度地图API功能
	var map = new BMap.Map("allmap");    // 创建Map实例
	var pt = new BMap.Point(g_lng, g_lat);
	map.centerAndZoom(pt, 14);  // 初始化地图,设置中心点坐标和地图级别
	//map.addControl(new BMap.MapTypeControl());   //添加地图类型控件
	map.enableScrollWheelZoom(true);     //开启鼠标滚轮缩放
	
	var marker = new BMap.Marker(pt);
	var label = new BMap.Label(g_name, {offset:new BMap.Size(20,-10)});
	marker.setLabel(label);

	map.addOverlay(marker);	

</script>

