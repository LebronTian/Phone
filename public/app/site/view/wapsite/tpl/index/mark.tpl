<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no, width=device-width">
	<title>深圳市高速广告有限公司</title>
	<style type="text/css">
		html, body {
			margin: 0;
			height: 100%;
			width: 100%;
			position: absolute;
		}

		#container {
			position: absolute;
			top: 0;
			left: 0;
			right: 0;
			bottom: 0;
			width: 100%;
			height: 100%;
		}
		#table-wrap{
			position: absolute;
			left: 0;
			top: 0;
			z-index: 9999;
			width: 90%;
			margin: 10px 5%;
			background: rgba(255,255,255,0.7);
			box-sizing: border-box;
			border: 1px solid #0D9BF2;
			border-radius: 2px;
		}
		#table-wrap table,
		.info-wrap table{
			width: 100%;
			font-size: 12px;
			text-align: center;
			
		}
		#table-wrap table tbody{
			border-top: 1px solid #0D9BF2;
		}
		#table-wrap table tbody tr{
			height: 18px;
		}
		.info-wrap{
			display: none;
			border-top: 1px solid #EEE;
			position: absolute;
			left: 0;
			bottom: 0;
			z-index: 9999;
			width: 100%;
			padding: 5px;
			background: rgba(255,255,255,0.9);
			box-sizing: border-box;
		}
	</style>
	<script type="text/javascript" src="static/js/jquery2.1.min.js"></script>
	<script src="http://webapi.amap.com/maps?v=1.3&key=1ff92ce2b1add61202283e7683f50de7"></script>
	<script type="text/javascript" src="app/site/view/wapsite/static/js/data.js"></script>
</head>
<body>
	<div id="container"></div>
	<div id="table-wrap">
		<table>
			<thead>
				<th>标识</th>
				<th>类型</th>
				<th>规格</th>
				<th>面积</th>
			</thead>
			<tbody>
				<tr>
					<td>蓝</td>
					<td>双面立柱</td>
					<td>18mX6m X2面</td>
					<td>216㎡</td>
				</tr>
				<tr>
					<td>红</td>
					<td>三面立柱</td>
					<td>18mX6m X3面</td>
					<td>324㎡</td>
				</tr>
				<tr>
					<td>绿</td>
					<td>站顶</td>
					<td>以实际尺寸为准</td>
					<td>以实际尺寸为准</td>
				</tr>
				<tr>
					<td>紫</td>
					<td>跨线桥</td>
					<td>46.5mX3m X2面</td>
					<td>300㎡</td>
				</tr>
			</tbody>
		</table>
	</div>
	<!-- <div class="info-wrap">
		<table>
			<thead>
				<th>尺寸</th>
				<th>面积</th>
				<th>人流量</th>
				<th>车流量</th>
			</thead>
			<tbody>
				<tr>
					<td>18mX6mX3面</td>
					<td>324㎡</td>
					<td>25万人次/日</td>
					<td>13万辆次/日</td>
				</tr>
			</tbody>
		</table>
	</div> -->
	<!-- <div class="info-wrap">
		<table>
			<thead>
				<th>类型</th>
			</thead>
			<tbody>
				<tr>
					<td>双面立体</td>
				</tr>
			</tbody>
		</table>
	</div> -->
	<script>
		console.log(data);
		// 初始化地图
	    var map = new AMap.Map('container', {
	        resizeEnable: true,
	        zoom:11,
	        center: [114.085947,22.547]
	        
	    });

	    // 点标记 
	    var mapObj = new AMap.Map('container',{zoom:11});

	    mapObj.plugin(["AMap.ToolBar"],function(){
		    //加载工具条
		    var tool = new AMap.ToolBar();
		    mapObj.addControl(tool);   
		});

	   	var markers = [];   
	   	var reg_type_d = /双面立柱/g;
	   	var reg_type_s = /三面立柱/g;
	   	var reg_type_k = /跨线桥/g;
	   	var reg_type_z = /站顶/g;
	   	var reg_type_sd = /隧道/g;
	   	for(var i = 0; i < data.length; i++){
	       // TODO 根据类别创建不同样式的marker
	       	
	       	// var html = '';
	       	// html = '<div class="info-wrap" data-id="'
	       	// 	+data[i].center
	       	// 	+'">'
	       	// 	+'<table>'
	       	// 	+'<thead><th>类型</th></thead>'
	       	// 	+'<tbody><tr><td>'
	       	// 	+data[i].type
	       	// 	+'</td></tr></tbody></table></div>';
	       	// $('body').append(html);
	       	
	       if (reg_type_d.test(data[i].type)) {
	       		marker = new AMap.Marker({
				    position: data[i].center.split(','),
				    id: data[i].id,
				    map: mapObj
				});
	       }
	       else if (reg_type_s.test(data[i].type)) {
	       		marker = new AMap.Marker({
		       		icon: "app/site/view/wapsite/static/images/amap/mark_2.png", // 红
				    position: data[i].center.split(','),
				    id: data[i].id,
				    map: mapObj
				});
	       }
	       else if (reg_type_k.test(data[i].type)) {
	       		marker = new AMap.Marker({
	       			icon: "app/site/view/wapsite/static/images/amap/mark_3.png", // 紫
				    position: data[i].center.split(','),
				    id: data[i].id,
				    map: mapObj
				});
	       }
	       else if (reg_type_z.test(data[i].type)) {
	       		marker = new AMap.Marker({
	       			icon: "app/site/view/wapsite/static/images/amap/mark_5.png", // 绿
				    position: data[i].center.split(','),
				    id: data[i].id,
				    map: mapObj
				});
	       }
	       else if (reg_type_sd.test(data[i].type)) {
	       		marker = new AMap.Marker({
	       			icon: "app/site/view/wapsite/static/images/amap/mark_7.png", // 棕
				    position: data[i].center.split(','),
				    id: data[i].id,
				    map: mapObj
				});
	       }

	       	var _showFunc = function(e){
				var url = 'http://m.amap.com/navi/?dest='+e.lnglat.lng+','+e.lnglat.lat+'&destName=广告牌位置&key=1ff92ce2b1add61202283e7683f50de7';
				window.location.href = url;
		    }
		    // 事件交互click	http://x.eqxiu.com/s/lwa2RGVi 公司简介
		    AMap.event.addListener(marker, 'click', _showFunc);
	       				
	   	}

	</script>
</body>
</html>
