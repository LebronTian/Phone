<?php 
include $tpl_path.'/header.tpl';
?>

<head>
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

<iframe src="http://api.map.baidu.com/marker?location=<?php echo(!empty($site['more_info']) ? $site['more_info']['latitude'] : '22.500355')?>,<?php echo(!empty($site['more_info']) ? $site['more_info']['longitude'] : '113.923967')?>&title=<?php echo $site['location']?>&content=<?php echo $site['brief']?>&output=html" style="width:100%;height:85%"></iframe>
<?php 
include $tpl_path.'/footer.tpl';
?>
















