<div class="am-cf am-padding">
    <div class="am-fl am-cf">
	<strong class="am-text-primary am-text-lg">
	用户管理主页
	</strong> 
	<small></small></div>
</div>	
<div class="am-padding"><div class="am-g">

	<ul class="am-avg-sm-1 am-avg-md-2 am-margin am-padding am-text-center admin-content-list " style="margin-top: 10px;">
      <li><a href="?_a=su&_u=sp.fanslist"><span class="am-icon-btn am-icon-file-text"></span>
			<br>总用户数<br>
			<?php echo $fans_total;?></a></li>
      <li><span class="am-icon-btn am-icon-plus"></span><br>昨天新增粉丝数<br>
			<?php echo $fans_yesterday;?></li>
    </ul>

	<div id="id_echart" class="am-padding am-margin admin-content-list" style="height: 300px;">
		图表加载中...
	</div>
	
	<div id="id_echart2" class="am-padding am-margin admin-content-list" style="height: 300px;">
		图表加载中...
	</div>
	
	<div id="id_echart3" class="am-padding am-margin admin-content-list" style="height: 500px;">
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

