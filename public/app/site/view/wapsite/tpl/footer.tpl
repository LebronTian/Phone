<?php
$k = 'cfg_site_wapsite_setcolor_'.AccountMod::require_sp_uid();
$color = SpExtMod::get_sp_ext_cfg($k);
#var_export($site)
?>

<input type="hidden" id="longitude" value="<?php echo(!empty($site['more_info']) ? $site['more_info']['longitude'] : '113.923967')?>">
<input type="hidden" id="latitude" value="<?php echo(!empty($site['more_info']) ? $site['more_info']['latitude'] : '22.500355')?>">
<input type="hidden" id="brief" value="<?php echo(!empty($site['brief']) ? $site['brief'] : '')?>">

	<div class="footer">
			<div><a href="/?_a=site&sp_uid=<?php echo $site['sp_uid']?>&_u=index.index"><img src="/app/site/view/wapsite/static/images/index1.png"></a></div>
			<div><a href="tel:<?php echo $site['phone'];?>"><img src="/app/site/view/wapsite/static/images/phone.png"></a></div>
			<div><a href="/?_a=site&sp_uid=<?php echo $site['sp_uid']?>&_u=index.message"><img src="/app/site/view/wapsite/static/images/message.png"></a></div>
			<!-- <div><a href="/?_a=site&sp_uid=<?php echo $site['sp_uid']?>&_u=index.map"><img src="/app/site/view/wapsite/static/images/map.png"></a></div> -->
			<div><a href="javascript:;" onclick="go();"><img src="/app/site/view/wapsite/static/images/map.png"></a></div>

<!--
			<div><a href="tel:400-600-0120"><img src="/app/site/view/wapsite/static/images/phone.png"></a></div>
			<div><a href="/?_a=site&sp_uid=<?php echo $site['sp_uid']?>&_u=index.message"><img src="/app/site/view/wapsite/static/images/message.png"></a></div>
			<div><a href="/?_a=site&sp_uid=<?php echo $site['sp_uid']?>"><img src="/app/site/view/wapsite/static/images/index.png" style="margin-top:-10px;max-height:60px;margin-left:-5px;"></a></div>
			<div><a class="wx" href="weixin://qr/gh_e221ee860460"><img src="/app/site/view/wapsite/static/images/wx.png"></a></div>
			<div><a href="/?_a=site&sp_uid=<?php echo $site['sp_uid']?>&_u=index.map"><img src="/app/site/view/wapsite/static/images/map.png"></a></div>
-->
	</div>
</body>
<script src="/static/js/jquery2.1.min.js"></script>
<script src="/app/site/view/wapsite/static/js/style.js"></script>
<script type="text/javascript">
	console.log("<?php echo $site['stat_code']?>");
	
	//终点坐标（由微官网地图选择生成）
	var longitude = $('#longitude').val();
	var latitude = $('#latitude').val();
	var brief = $('#brief').val();
	//将百度坐标转成火星坐标（高德，腾讯，谷歌）
	function bd_decrypt(bd_lon,bd_lat)
    {	
    	data = [];
        var x_pi = 3.14159265358979324 * 3000.0 / 180.0;
        var x = bd_lon - 0.0065;
        var y = bd_lat - 0.006;
        var z = Math.sqrt(x * x + y * y) - 0.00002 * Math.sin(y * x_pi);
        var theta = Math.atan2(y, x) - 0.000003 * Math.cos(x * x_pi);
        data['bd_lon'] = z * Math.cos(theta);
        data['bd_lat'] = z * Math.sin(theta);
        return data;
    }
    var data = bd_decrypt(longitude,latitude);//转换后的坐标（火星坐标）
    console.log(data.bd_lon,data.bd_lat);
	
	var url = 'http://m.amap.com/navi/?dest='+data.bd_lon+','+data.bd_lat+'&destName='+brief+'&key=fe8d0e9cfe462f86662a359a0168d173';//高德地图组件，起始地址可为空（为空则h5手机定位到当前位置）
	function go(){
		window.location.href = url;
	}
</script>
</html>