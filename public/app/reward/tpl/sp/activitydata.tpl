<div class="am-cf am-padding">
    <div class="am-fl am-cf">
	<strong class="am-text-primary am-text-lg">
	<?php if($rewards['count']==0){echo '请创建一个抽奖</strong> <small></small></div></div> </div>';exit;}?>
	</strong> 
	</div>
	<div class="am-fl am-cf">
	<a href="?_a=reward&_u=sp">
  	<strong class="am-text-primary am-text-lg">通用抽奖</strong></a>
	<span class="am-icon-angle-right"></span>
		活动数据 </div>
</div>
<div class="am-padding">
	<div class="am-u-md-6">
            <div class="am-form-group am-margin-left am-fl">
              <select data-am-selected="{btnSize: 'lg' }" class="option_cat">
				<?php
				
					$i=0;
					$html = '';
					foreach($rewards['list'] as  $r) {
					$html .= '<option value="'.$r['uid'].'"';
					if($option['r_uid'] == $r['uid']||(!isset($option['r_uid'])&&$i==0)) $html .= ' selected';
					$html .= '>'.$r['title'].'</option>';
					$i++;
					}
					echo $html;
				?>
              </select>
            </div>
     </div>
</div>
<div class="am-padding"><div class="am-g">

	<ul class="am-avg-sm-1 am-avg-md-4 am-margin am-padding am-text-center admin-content-list " style="margin-top: 10px;">
      <li><a href="?_a=reward&_u=sp.recordlist&r_uid=<?php echo $option['r_uid'];?>"><span class="am-icon-btn am-icon-file-text"></span><br>参与总人数<br>
			<?php echo $cnts['total_users_cnt'];?></a></li>
      <li><span class="am-icon-btn am-icon-plus"></span><br>日增人数<br>
			<?php echo $cnts['today_users_cnt'];?></li>
      <li><span class="am-icon-btn am-icon-file-text"></span><br>总中奖数<br>
			<?php echo $cnts['today_reward_cnt'];?></li>
      <li><span class="am-icon-btn am-icon-plus"></span><br>日增中奖数<br>
			<?php echo $cnts['today_rewards_cnt'];?></li>
    </ul>

	<div id="id_echart" class="am-padding am-margin admin-content-list" style="height: 500px;">
		图表加载中...
	</div>
	
	<div id="id_echart2" class="am-padding am-margin admin-content-list" style="height: 500px;">
		图表加载中...
	</div>
	
	<div class="am-padding am-margin admin-content-list" style="height: 130px;">
	<div class="am-g">
		<div class="am-u-sm-12"><small>导出某一天新增报名数据到excel表格</small></div>
		
		<div class="am-u-sm-3">
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

</div></div>

<?php
	echo "<script>var r_uid=".$option['r_uid'] .";</script>";
	$extra_js = array(
					'/static/js/echarts/echarts.js',
					$static_path.'/js/activitydata.js',
	);

	echo '<script>var g_echarts='.json_encode($echarts).';</script>';
	echo '<script>var g_echarts2='.json_encode($echarts2).';</script>';
?>

