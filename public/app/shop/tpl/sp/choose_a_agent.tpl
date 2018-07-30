	<div class="am-cf am-padding">
		<div class="am-fl am-cf" id="edit-id">
			<strong class="am-text-primary am-text-lg"> 请先选择一个代理商</strong> /
		</div>
	</div>
	<div class="am-form am-form-horizontal" data-am-validator>

<!--		<div class="am-g am-margin-top-sm" style="margin-bottom: 20px">-->
<!--			<div class="am-u-sm-2 am-text-right">-->
<!--				<span class="am-btn am-btn-warning">请先选择一个代理商</span>-->
<!--			</div>-->
<!--		</div>-->
		<div class="am-u-sm-12">
			<table class="am-table am-table-striped am-table-hover table-main">
				<thead>
				<tr>
					<!--			<th class="table-check">-->
					<!--				<input type="checkbox" class="ccheckall">-->
					<!--				<a href="javascript:;" class="am-text-danger am-text-lg cdeleteall" style="margin-left:10px;"><span class="am-icon-trash"></span></a>-->
					<!--			</th>-->
					<th class="table-name" data-uid="<?php echo $shop['sp_uid'] ?>">用户名</th>
					<th class="table-cash_sum">佣金总额</th>
					<th class="table-order_fees_sum">订单总额</th>
					<th class="table-order_sum">订单数量</th>
					<th class="table-agent_user_count">用户数</th>
					<th class="table-create_time">时间</th>
					<th class="table-set">操作</th>
				</tr>
				</thead>
				<tbody>
				<?php
				if (!$agent_list['list'])
				{
					echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
				}
				else
				{
					$html = '';
					foreach ($agent_list['list'] as $m)
					{
						$html .= '<tr data-uid="' . $m['uid'] . '">';
						$html .= '<td><a target="_blank" class="am-btn am-btn-default  " href="?_a=su&_u=sp.fanslist&uid=' . $m['su_uid'] . '">' . $m['user']['name'] . '</td>';

						$html .= '<td>' . (empty($m['cash_sum']) ? '0' : sprintf('%.2f', $m['cash_sum'] / 100)) . '</td>';
						$html .= '<td>' . (empty($m['order_fee_sum']) ? '0' : sprintf('%.2f', $m['order_fee_sum'] / 100)) . '</td>';
						$html .= '<td>' . (empty($m['order_count']) ? '0' : $m['order_count']) . '</td>';
						$html .= '<td>' . (empty($m['user_count']) ? '0' : $m['user_count']) . '</td>';


						$html .= '<td>' . date('Y-m-d H:i:s', $m['create_time']) . '</td>';
						$html .= '<td><a class="am-btn am-btn-primary" href="'.$url.'&a_uid=' . $m['uid'] . '">选择</a></td>';


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
	</div>


<?php

echo '
    <script>
            var a_uid = ' . (!empty($agent) ? $agent['uid'] : "null") . ';
    </script>';

$extra_js = array(

	$static_path . '/js/addagentproduct.js',

);
?>
