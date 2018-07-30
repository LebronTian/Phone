<?php 
include $tpl_path.'/header.tpl';
?>

<!-- <head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
	<style type="text/css">
	body, html{width: 100%;height: 100%;margin:0;font-family:"微软雅黑";}
	#allmap {height: 100%;width:100%;overflow: hidden;}
	#result {width:100%;font-size:12px;}
	dl,dt,dd{
		margin:0;
		padding:0;
		list-style:none;
	}
	dt{
		font-size:14px;
		font-family:"微软雅黑";
		font-weight:bold;
		border-bottom:1px dotted #000;
		padding:5px 0 5px 5px;
		margin:5px 0;
	}
	dd{
		padding:5px 0 0 5px;
	}
	</style>
	<link rel="stylesheet" href="/static/css/baidumap/SearchInfoWindow_min.css" />
</head>

<iframe src="http://api.map.baidu.com/marker?location=<?php echo(!empty($site['more_info']) ? $site['more_info']['latitude'] : '22.500355')?>,<?php echo(!empty($site['more_info']) ? $site['more_info']['longitude'] : '113.923967')?>&title=<?php echo $site['location']?>&content=<?php echo $site['brief']?>&output=html" style="width:100%;height:85%"></iframe> -->
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
	<style type="text/css">
	#container {width:100%; height: 500px; }
	</style>
</head>

<!-- <head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
	<style type="text/css">
	body, html{width: 100%;height: 100%;margin:0;font-family:"微软雅黑";}
	#allmap {height: 500px;width:100%;overflow: hidden;}
	#result {width:100%;font-size:12px;}
	dl,dt,dd,ul,li{
		margin:0;
		padding:0;
		list-style:none;
	}
	dt{
		font-size:14px;
		font-family:"微软雅黑";
		font-weight:bold;
		border-bottom:1px dotted #000;
		padding:5px 0 5px 5px;
		margin:5px 0;
	}
	dd{
		padding:5px 0 0 5px;
	}
	li{
		line-height:28px;
	}
	</style>
	<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=ChNiw5pq03tmYVDeNGARA6vN"></script>
	<script type="text/javascript" src="http://api.map.baidu.com/library/SearchInfoWindow/1.5/src/SearchInfoWindow_min.js"></script>
	<link rel="stylesheet" href="http://api.map.baidu.com/library/SearchInfoWindow/1.5/src/SearchInfoWindow_min.css" />
	<title>带检索功能的信息窗口</title>
</head> -->

<body>
	<input type="hidden" id="longitude" value="<?php echo(!empty($site['more_info']) ? $site['more_info']['longitude'] : '113.923967')?>">
	<input type="hidden" id="latitude" value="<?php echo(!empty($site['more_info']) ? $site['more_info']['latitude'] : '22.500355')?>">
	<div id="container"></div>

	<!-- 百度地图 -->
	<!--<div id="allmap"></div>-->


</body>
<script type="text/javascript" src="/static/js/jquery2.1.min.js"></script>
<script type="text/javascript" src="http://webapi.amap.com/maps?v=1.3&key=1ff92ce2b1add61202283e7683f50de7"></script>
<script type="text/javascript">
	//获取设置的地址
	var longitude = parseFloat($('#longitude').val());
	var latitude = parseFloat($('#latitude').val());
	console.log(longitude,latitude);

	//实例化地图
	var map = new AMap.Map('container');	
	var map = new AMap.Map('container',{
    	zoom: 16,
    	center: [longitude,latitude]
		 });
		 var marker = new AMap.Marker({
    	position: [longitude,latitude],
    	map:map
	});
    
    //覆盖物
    marker.setMap(map);
    var circle = new AMap.Circle({
        center: [longitude,latitude],
        radius: 100,
        fillOpacity:0.2,
        strokeWeight:1
    });
    circle.setMap(map);
		
    //信息框
    AMap.plugin('AMap.AdvancedInfoWindow',function(){
      var infowindow = new AMap.AdvancedInfoWindow({
        content: '',
        offset: new AMap.Pixel(0, -30),
        asOrigin:false
      });
      infowindow.open(map,new AMap.LngLat(longitude,latitude));
    });
    
    //标尺插件
    AMap.plugin(['AMap.ToolBar','AMap.Scale'],function(){
        var toolBar = new AMap.ToolBar();
        var scale = new AMap.Scale();
        map.addControl(toolBar);
        map.addControl(scale);
    });
</script>

<!--<script type="text/javascript">
	//获取设置的地址
	var longitude = parseFloat($('#longitude').val());

	var latitude = parseFloat($('#latitude').val());
	console.log(longitude,latitude);
	// 百度地图API功能
    var map = new BMap.Map('allmap');

    longitude = map.pixelToPoint(pixel:longitude);
    console.log('aaaaaaaaaaaa',longitude);

    var poi = new BMap.Point(longitude,latitude);
    console.log(poi);
    map.centerAndZoom(poi, 16);
    map.enableScrollWheelZoom();

    
    var content = '';

    //创建检索信息窗口对象
    var searchInfoWindow = null;
	searchInfoWindow = new BMapLib.SearchInfoWindow(map, content, {
			title  : "",      //标题
			width  : 290,             //宽度
			height : 0,              //高度
			panel  : "panel",         //检索结果面板
			enableAutoPan : true,     //自动平移
			searchTypes   :[
				BMAPLIB_TAB_SEARCH,   //周边检索
				BMAPLIB_TAB_TO_HERE,  //到这里去
				BMAPLIB_TAB_FROM_HERE //从这里出发
			]
		});
    var marker = new BMap.Marker(poi); //创建marker对象
    marker.enableDragging(); //marker可拖拽
    marker.addEventListener("click", function(e){
	    searchInfoWindow.open(marker);
    })
    map.addOverlay(marker); //在地图中添加marker
	//样式1
	var searchInfoWindow1 = new BMapLib.SearchInfoWindow(map, "信息框1内容", {
		title: "信息框1", //标题
		panel : "panel", //检索结果面板
		enableAutoPan : true, //自动平移
		searchTypes :[
			BMAPLIB_TAB_FROM_HERE, //从这里出发
			BMAPLIB_TAB_SEARCH   //周边检索
		]
	});
	function openInfoWindow1() {
		searchInfoWindow1.open(new BMap.Point(longitude,latitude));
	}


	
</script>-->

<?php 
include $tpl_path.'/footer.tpl';
?>
















