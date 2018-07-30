<style>
	.table-main tr {
		cursor: pointer;
	}

</style>
<link rel="stylesheet" href="/app/shop/static/css/fadeInBox.css"/>

<div class="am-cf am-padding">
	<div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">代理商设置</strong> /
		<small>总计 <?php echo empty($agent_to_user_product['count']) ? 0 : $agent_to_user_product['count']; ?> </small>
	</div>
</div>

<div class="am-g am-padding">
	<!--	<div class="am-u-md-6">-->
	<!--		<div class="am-fr">-->
	<!--			<div class="am-input-group am-input-group-sm">-->
	<!---->
	<!--                <span class="am-input-group-btn">-->
	<!--                  <a class="am-btn am-btn-default " type="button" href="?_a=shop&_u=sp.distribution_user_list">查看全部</a>-->
	<!--                </span>-->
	<!--			</div>-->
	<!--		</div>-->
	<!--	</div>-->
	<!--	<div class="am-u-md-3 am-cf-right">-->
	<!--		<div class="am-fr">-->
	<!--			<div class="am-input-group am-input-group-sm">-->
	<!--				<input type="text" class="am-form-field option_key" value="-->
	<?php //echo $option['key']; ?><!--">-->
	<!--                <span class="am-input-group-btn">-->
	<!--                  <button class="am-btn am-btn-default option_key_btn" type="button">搜索</button>-->
	<!--                </span>-->
	<!--			</div>-->
	<!--		</div>-->
	<!--	</div>-->

</div>

<?php
//var_export($agent_to_user_product);
?>
<div class="am-g am-padding am-u-sm-12">
	<div class="am-u-md-8 am-u-end">

	<div class="am-fl am-u-sm-2 am-u-end">
		<?php
		echo '<a class="am-btn am-btn-default " type="button" href="?_a=shop&_u=sp.agent_to_user_product">查看全部</a>';
		?>
	</div>
	<div class="am-fl am-u-sm-2 am-u-end">
		<?php
		echo '<a class="am-btn am-btn-primary " type="button" href="?_a=shop&_u=sp.choose_a_agent&url='.
			urlencode('?_a=shop&_u=sp.agent_to_user_product').'">查看某个代理商的商品设置</a>';
		?>
	</div>
	</div>
	<div class="am-fl am-u-sm-2">
		<a class="am-btn am-btn-primary " type="button"
		   href="?_a=shop&_u=sp.choose_a_agent&url=<?php echo urlencode('?_a=shop&_u=sp.addagentproduct'); ?>">替代理商增加商品</a>
	</div>

</div>
<div class="am-u-sm-12">
	<table class="am-table am-table-striped am-table-hover table-main">
		<thead>
		<tr>
			<!--			<th class="table-check">-->
			<!--				<input type="checkbox" class="ccheckall">-->
			<!--				<a href="javascript:;" class="am-text-danger am-text-lg cdeleteall" style="margin-left:10px;"><span class="am-icon-trash"></span></a>-->
			<!--			</th>-->
			<th class="table-name" data-uid="<?php echo $shop['sp_uid'] ?>">原商品编号</th>
			<th class="table-a_uid">所属代理商</th>
			<th class="table-title">商品标题</th>
			<th class="table-price">价格(&yen;)</th>
			<th class="table-bonus">佣金(&yen;)</th>
			<th class="table-main_image">主图</th>
			<th class="table-modify_time">状态</th>
			<th>统计情况</th>
			<th class="table-set">操作</th>
		</tr>
		</thead>
		<tbody>
		<?php
		//		var_dump(__file__.' line:'.__line__,$agent_to_user_product);exit;
		if (empty($agent_to_user_product['list']))
		{
			echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
		}
		else
		{
			$html = '';
			foreach ($agent_to_user_product['list'] as $m)
			{
				$html .= '<tr data-id="' . $m['uid'] . '">';
				$html .= '<td><a target="_blank" class="am-btn am-btn-primary  " href = "?_a=shop&_u=sp.productlist&uid=' . $m['product']['uid'] . '">' . $m['product']['uid'] . '</a></td>';
				$html .= '<td><a target="_blank" class="am-btn am-btn-primary  " href="?_a=shop&_u=sp.agent&uid=' . $m['a_uid'] . '">' . $m['a_uid'] . '</a></td>';
				$html .= '<td>' . (empty($m['title']) ? $m['product']['title'] : $m['title']) . '</td>';
				$html .= '<td>' . sprintf('%.2f', (empty($m['price']) ? $m['product']['price'] : $m['price']) / 100) . '</td>';
				$html .= '<td>' . sprintf('%.2f', (empty($m['bonus']) ? 0 : $m['bonus']) / 100) . '</td>';
				$html .= '<td>' . '<img src="' . (empty($m['main_iamge']) ? $m['product']['main_img'] : $m['main_img']) . '&w=100&h=100" style="max-width:100px;max-height:100px"></td>';
				$html .= '<td>' .(empty($m['agent_product']['status'])?(empty($m['product']['status']) ? (empty($m['status']) ? '上架' : '下架') : '供货商下架'):'不允许代理')  . '</td>';
				$html .= ' <td><a  target="_blank" href="?_a=shop&_u=sp.visit_record&p_uid='.$m['uid'].'&a_uid='.$m['a_uid'].'"><span class="am-icon-line-chart" ></span></a></td>';
				$html .= '<td><a target="_blank" class="am-btn am-btn-primary  " href="?_a=shop&_u=sp.editagentproduct&uid=' . $m['uid'] . '&a_uid=' . $m['a_uid'] . '"><span >编辑</span></a></td>';
				$html .= '</tr>';

			}
			echo $html;
		}
		?>
		</tbody>
	</table>
</div>

<div class="am-u-sm-12">
	<?php
	echo $pagination;
	?>
</div>

<?php
$extra_js = array(
	$static_path . '/js/distributionlist_user_list.js',
	//'/app/takeaway/static/js/fadeInBox.js'
);
?>
<script>
</script>
