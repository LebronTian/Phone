<div class="am-cf am-padding">
    <div class="am-fl am-cf">
	<strong class="am-text-primary am-text-lg">
	用户推荐关系图
	</strong> 
	<small></small></div>
</div>	

<div class="am-padding"><div class="am-g">
	<div id="id_echart" class="am-padding am-margin admin-content-list" style="height: 500px;">
		图表加载中...
	</div>
</div>
	
<?php
	
	$extra_js = array(
					'/static/js/echarts/echarts3.full.min.js',
					$static_path.'/js/fansgraph.js',
	);

	echo '<script>var g_su='.json_encode($user).';</script>';
	echo '<script>var g_echarts='.json_encode($echarts).';</script>';
?>

