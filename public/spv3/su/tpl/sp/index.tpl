<style>
.zhicwl-yxclsj-left {
	width:48px;
	height:48px;
	background:white;
}
.zhicwl-yxclsj-left span{
color: #0e90d2;
}
</style>
<!-- <div class="am-cf am-padding">
	<div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">客户概况</strong> /
		<small></small>
	</div>
</div> -->

<div class="zhicwl-yxclsj-self">
<ul>
	<li>
		<a href="?_a=su&_u=sp.fanslist">
			<div class="zhicwl-yxclsj-right">
			<h6><?php echo $fans_total; ?></h6>
			<samp>总用户数</samp>
		</div>
		</a>
	</li>
	<li>
		<a href="?_a=su&_u=sp.fanslist">
			<div class="zhicwl-yxclsj-right">
			<h6><?php echo $fans_yesterday; ?></h6>
			<samp>昨日新增粉丝</samp>
		</div>
		</a>
	</li>
	</ul>
</div>

<div class="am-padding"><div class="am-g">
	<div id="id_echart" class="admin-content-list" style="height: 300px;padding-right:255px;">
		图表加载中...
	</div>
	
	<div id="id_echart2" class= admin-content-list" style="height: 300px;padding-right:255px;">
		图表加载中...
	</div>
	
	<div id="id_echart3" class="admin-content-list" style="height: 500px;padding-right:255px;">
		图表加载中...
	</div>
	<!--
	<div class="am-padding am-margin admin-content-list" style="height: 130px;">
	<div class="am-g">
		<div class="am-u-sm-12"><small>导出某一天新增报名数据到excel表格</small></div>
		
		<div class="am-u-sm-2"> 
			<div class="am-form-group am-form-icon"><i class="am-icon-calendar"></i><input type="text" class="am-form-field am-input-lg"
			<?php echo 'value="'.date('Y-m-d', strtotime('yesterday')).'"';?>  data-am-datepicker id="doc-datepicker"></div>
			</div>
			<div class="am-u-sm-2"> 
				<button class="am-btn am-btn-lg am-btn-secondary" id="id_download">
				<span class="am-icon-file-excel-o"></span> 下载</button>
			</div>
			<div class="am-u-sm-2"> 
			</div>
	</div>
	</div>
	-->
</div>
</div>

<?php
	
	$extra_js = array(
					'/static/js/echarts/echarts.js',
					$static_path.'/js/index.js',
	);

	echo '<script>var g_echarts='.json_encode($echarts).';</script>';
	echo '<script>var g_echarts2='.json_encode($echarts2).';</script>';
	echo '<script>var g_echarts3='.json_encode($echarts3).';</script>';
?>

