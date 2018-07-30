<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
	<style type="text/css">
	body, html{width: 100%;height: 100%;margin:0;font-family:"微软雅黑";}
	#allmap {height: 500px;66.66666667%;overflow: hidden;position: relative;}
	#result {width:100%;font-size:12px;}
	dl,dt,dd,{
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
	<title></title>
</head>
<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">地图设置</strong> / <small></small></div>
</div>
	
	<div class="am-form">
			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             地图选址
   		         </div>
       		     <div class="am-u-sm-8 am-u-end">
       		       
					<div id="allmap" data-lat="<?php if(!empty($site['more_info']))echo $site['more_info']['latitude'];?>" data-lng = "<?php if(!empty($site['more_info'])) echo $site['more_info']['longitude'];?>">	
					</div>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             公司地址
   		         </div>
       		     <div class="am-u-sm-8 am-u-end">
       		       <input type="text" id="address" <?php if(!empty($site['location'])) echo 'value="'.$site['location'].'"';?>>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             公司名称
   		         </div>
       		     <div class="am-u-sm-8 am-u-end">
       		       <input type="text" id="company" <?php if(!empty($site['brief'])) echo 'value="'.$site['brief'].'"';?>>
       		     </div>
			</div>
			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
					<p><button class="am-btn am-btn-lg am-btn-primary save">保存</button></p>
				</div>
			</div>

</div>
<script  src="/static/js/jquery2.1.min.js"></script>
<script  src="http://api.map.baidu.com/api?v=2.0&ak=O2TlUoWwlRSpccEMM2Kr5fpZ"></script>
<!-- <script type="text/javascript" src="http://api.map.baidu.com/api?v=1.5&ak=gNv9hMjFVfBRovS4XwN59w9g"></script> -->
<script  src="/static/js/baidumap/SearchInfoWindow_min.js"></script>
<script src="/app/site/static/js/map1.js"></script>
