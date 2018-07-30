<style>
	.table-main tr {
		cursor: pointer;
	}

</style>
<link rel="stylesheet" href="/app/shop/static/css/fadeInBox.css"/>

<div class="am-cf am-padding">
	<div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">分销记录</strong> /
		<small>总计 <?php echo $dtblist['count']; ?> 条</small>
	</div>
</div>

<div class="am-g am-padding">
	<div class="am-u-md-6">
	</div>

	<div class="am-u-md-3 am-cf">
		<div class="am-fr">
			<div class="am-input-group am-input-group-sm">
				<input type="text" class="am-form-field option_key" placeholder="订单号" value="<?php echo $option['key']; ?>">
                <span class="am-input-group-btn">
                  <button class="am-btn am-btn-default option_key_btn" type="button">搜索</button>
                </span>
			</div>
		</div>
	</div>

</div>

<?php
//var_export($dtblist);
?>

<div class="am-u-sm-12">
	<table class="am-table am-table-striped am-table-hover table-main">
		<thead>
		<tr>
<!--			<th class="table-check">-->
<!--				<input type="checkbox" class="ccheckall">-->
<!--				<a href="javascript:;" class="am-text-danger am-text-lg cdeleteall" style="margin-left:10px;"><span-->
<!--						class="am-icon-trash"></span></a>-->
<!--			</th>-->
			<th class="table-uid" data-uid=>编号</th>
			<th class="table-name" data-uid=>用户名</th>

			<th class="table-order_uid">订单号</th>
			<th class="table-cash">佣金金额</th>
			<th class="table-weight">分成比例</th>
			<th class="table-level">分成级别</th>
			<th class="table-paid_fee">订单付款金额</th>
			<th class="table-create_time">时间</th>
			<th class="table-parent_su_uid">上级用户</th>

		</tr>
		</thead>
		<tbody>
		<?php
		if (!$dtblist['list'])
		{
			echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
		}
		else
		{
			$html     = '';
			foreach ($dtblist['list'] as $m)
			{

				$html .= '<tr data-id="' . $m['uid'] . '">' .
//					'<td class="table-check"><input type="checkbox" class="ccheck"></td>' .
					'<td>'.$m['uid']. '</td><td><a href="?_a=shop&_u=sp.distributionlist&su_uid='.$m['su_uid'].'">' .
					$m['user']['name'] . '</a></td><td>' .

					'<a href="?_a=shop&_u=sp.orderlist&key='.$m['order_uid'].'">' .$m['order_uid'].'</a></td><td>' .
					sprintf('%.2f', $m['cash'] / 100) . '</td><td>' .
					sprintf('%.2f', $m['weight'] / 100) . '%</td><td>' .
					$m['level'] . '</td><td>'.
					sprintf('%.2f', $m['paid_fee'] / 100) . '</td><td>' .
					date('Y-m-d H:i:s', $m['create_time']) . '</td><td>' .
					(empty($m['parent_user']['name']) ? '无' : $m['parent_user']['name']) . '</td>';
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
	$static_path . '/js/distributionlist.js',
);
?>
<script>

</script>
