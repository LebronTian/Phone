<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">发放统计</strong> / <small><?php
if(count($stores) == 1) {
	echo $stores[0]['name'];
}
else {
	echo '共 '.count($stores).' 家门店';
}
 ?></small></div>
</div>

<?php
	if(count($stores) > 1) {
$html = '
<div class="am-g am-padding">
	<div class="am-form-group am-margin-left am-fl">
	指定门店: 
	<select data-am-selected="{btnSize: \'lg\' }" class="option_cat">';
	$cats = $stores;
	array_unshift($cats, array('uid' => 0, 'name' => '不限'));
	foreach($cats as  $c) {
		$html .= '<option value="'.$c['uid'].'"';
		if($store_uid == $c['uid']) $html .= ' selected';
			$html .= '>'.$c['name'].'</option>';
	}
     $html .=  '</select>
	</div>
</div>';
	
	echo $html;
	}
?>

<div class="am-padding"><div class="am-g">

	<ul class="am-avg-sm-1 am-avg-md-4 am-margin am-padding am-text-center admin-content-list ">
      <li><a href="?_a=store&_u=sp.usercoupon&store_uid=<?php echo $store_uid;?>" class=""><span class="am-icon-btn am-icon-file-text"></span><br>发放总数<br>
			<?php echo $cnts['total_coupons_cnt'];?></a></li>
      <li><a href="?_a=store&_u=sp.usercoupon&writeoff=1" class=""><span class="am-icon-btn am-icon-briefcase"></span><br>核销总数<br>
			<?php echo $cnts['total_writeoff_cnt'];?></a></li>
      <li><a href="?_a=store&_u=sp.usercoupon&store_uid=<?php echo $store_uid;?>" class="am-text-success"><span class="am-icon-btn am-icon-file-text"></span><br>今日新增发放<br>
			<?php echo $cnts['today_coupons_cnt'];?></a></li>
      <li><a href="?_a=store&_u=sp.usercoupon&writeoff=1" class="am-text-success"><span class="am-icon-btn am-icon-briefcase"></span><br>今日新增核销<br>
			<?php echo $cnts['today_writeoff_cnt'];?></a></li>
    </ul>

	<div id="id_echart" class="am-padding am-margin admin-content-list" style="height: 500px;">
		图表加载中...
	</div>

	<div id="id_echart2" class="am-padding am-margin admin-content-list" style="height: 500px;">
		图表加载中...
	</div>
</div></div>

<?php
	$extra_js = array(
					'/static/js/echarts/echarts.js',
					$static_path.'/js/couponecharts.js',
	);

	echo '<script>var g_echarts='.json_encode($echarts).';</script>';
	echo '<script>var g_echarts2='.json_encode($echarts2).';</script>';
?>

