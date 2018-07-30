 <div class="am-cf am-padding">
	<div class=" am-cf">
		<strong class="am-text-primary am-text-lg">商城统计数据</strong>
		<span class="am-icon-angle-right"></span>
	</div>
</div>


<div class="am-padding  am-cf">
	<?php
	$agent_set = AgentMod::get_agent_set_by_shop_uid($shop['uid']);
	if (!empty($agent_set) && empty($agent_set['status']) && (in_array($shop['tpl'],AgentMod::get_agent_tpl_array())))
	{
	?>
	<div class="am-margin-left am-u-sm-2 am-u-end ">
		<span>选择代理：</span>
	</div>
	<div class="am-form-group  am-u-sm-3">
		<select data-am-selected="{btnSize: 'lg' }" class="option_agent">
			<?php

			$html = '<option value="0"';
			if (empty($option['a_uid']))
			{
				$html .= ' selected ';
			}
			$html .= '>所有代理</option>';
			foreach ($agent_list as $r)
			{
				$html .= '<option value="' . $r['uid'] . '"';
				if ($option['a_uid'] == $r['uid'])
				{
					$html .= ' selected';
				}
				$html .= '>' . $r['name'] . '</option>';
				$i++;
			}
			echo $html;
			?>
		</select>
	</div>
		<?php
	}
	?>
	<div class="am-margin-left am-u-sm-2 am-u-end ">
		<span>选择商品：</span>
	</div>
	<div class="am-form-group  am-u-sm-3 am-u-end">
		<select data-am-selected="{btnSize: 'lg' }" class="option_product">
			<?php
			$html = '<option value="0"';
			if (empty($option['p_uid']))
			{
				$html .= ' selected ';
			}
			$html .= '>所有商品</option>';
			foreach ($product_list as $r)
			{
				$html .= '<option value="' . $r['uid'] . '"';
				if ($option['p_uid'] == $r['uid'])
				{
					$html .= ' selected';
				}
				$html .= '>' . $r['title'] . '</option>';
				$i++;
			}
			echo $html;
			?>
		</select>
	</div>

</div>
<div class="am-padding  am-cf">
	<div class="am-u-sm-3 am-margin-left am-u-end">
		<button type="button" class="am-btn am-btn-default am-margin-right" id="my-start">开始日期</button>
		<span
			id="my-startDate"><?php echo date('Y-m-d', (empty($option['start_time']) ? time() : $option['start_time'])) ?></span>
	</div>
	<div class="am-u-sm-3 am-margin-left am-u-end">
		<button type="button" class="am-btn am-btn-default am-margin-right" id="my-end">结束日期</button>
		<span
			id="my-endDate"><?php echo date('Y-m-d', (empty($option['end_time']) ? time() : $option['end_time'])) ?></span>
	</div>
	<div class=" am-margin-left am-u-sm-3 am-u-end">
		<span class="am-btn am-btn-primary btn_show">查看</span>
	</div>
</div>

<div class="am-padding am-margin-top">
	<div class="am-g">

		<ul class="am-avg-sm-1 am-avg-md-4 am-margin am-padding am-text-center admin-content-list "
		    style="margin-top: 10px;">
			<li><a class="am-text-default">
				<span
					class="am-icon-btn am-icon-file-text am-text-primary"></span><br>今日商城pv<br><?php echo $cnts['shop_pv']; ?>
				</a></li>

			<li><a class="am-text-success">
				<span
					class="am-icon-btn am-icon-file-text am-text-success"></span><br>今日商城uv<br><?php echo $cnts['shop_uv']; ?>
				</a></li>
			<li><a class="am-text-default">
				<span
					class="am-icon-btn am-icon-file-text am-text-primary"></span><br>今日商品pv<br><?php echo $cnts['product_pv']; ?>
				</a></li>

			<li><a  class="am-text-success">
				<span
					class="am-icon-btn am-icon-file-text am-text-success"></span><br>今日商品uv<br><?php echo $cnts['product_uv']; ?>
				</a></li>
		</ul>

		<div id="id_echart" class="am-padding am-margin admin-content-list" style="height: 500px;">
			图表加载中...
		</div>


		<div id="id_echart2" class="am-padding am-margin admin-content-list" style="height: 600px;">
			图表加载中...
		</div>


		<!--		<div class="am-padding am-margin admin-content-list" style="height: 130px;">-->
		<!--			<div class="am-g">-->
		<!--				<div class="am-u-sm-12">-->
		<!--					<small>导出某一天新增报名数据到excel表格</small>-->
		<!--				</div>-->
		<!---->
		<!--				<div class="am-u-sm-2">-->
		<!--					<div class="am-form-group am-form-icon"><i class="am-icon-calendar"></i><input type="text"-->
		<!--					                                                                               class="am-form-field am-input-lg"-->
		<!--							-->
		<?php //echo 'value="' . date('Y-m-d', strtotime('yesterday')) . '"'; ?><!-- data-am-datepicker-->
		<!--							                                                                       id="doc-datepicker">-->
		<!--					</div>-->
		<!--				</div>-->
		<!--				<div class="am-u-sm-2">-->
		<!--					<button class="am-btn am-btn-lg am-btn-secondary" id="id_download">-->
		<!--						<span class="am-icon-file-excel-o"></span> 下载-->
		<!--					</button>-->
		<!--				</div>-->
		<!--				<div class="am-u-sm-2">-->
		<!--				</div>-->
		<!--			</div>-->
		<!--		</div>-->

	</div>
</div>

<?php
//echo "<script>var r_uid=" . $option['r_uid'] . ";</script>";
$extra_js = array(
	'/static/js/echarts/echarts.js',
	$static_path . '/js/visit_record.js',
);

echo '<script>var g_echarts=' . json_encode($echarts) . ';</script>';
echo '<script>var g_echarts2=' . json_encode($echarts2) . ';</script>';
?>

