<div class="am-cf am-padding">
	<div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">代理商的用户管理</strong> /
		<small>总计 <?php  echo empty($agent_user_list['count'])?0:$agent_user_list['count']; ?> </small>
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
	<!--	<div class="am-u-md-3 am-cf">-->
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
	<div class="am-u-md-8 am-u-end">

		<div class="am-fl am-u-sm-2 am-u-end">
			<?php
			echo '<a class="am-btn am-btn-default " type="button" href="?_a=shop&_u=sp.agent_user">查看全部</a>';
			?>
		</div>
		<div class="am-fl am-u-sm-2 am-u-end">
			<?php
			echo '<a class="am-btn am-btn-primary " type="button" href="?_a=shop&_u=sp.choose_a_agent&url='.
				urlencode('?_a=shop&_u=sp.agent_user').'">查看某个代理商的用户</a>';
			?>
		</div>
	</div>
</div>

<?php
//var_export($agent_user_list);
?>

<div class="am-u-sm-12">
	<table class="am-table am-table-striped am-table-hover table-main">
		<thead>
		<tr>
			<th class="table-name" data-uid="<?php echo $shop['sp_uid'] ?>">用户名</th>
			<th class="table-create_time">加入时间</th>
			<th class="table-agent_uid">所属代理</th>
			<th class="table-order_list">他的订单</th>
			<th class="table-user_info">更多信息</th>
		</tr>
		</thead>
		<tbody>
		<?php
		if (empty($agent_user_list['list']))
		{
			echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
		}
		else
		{
			$html='';

			foreach ($agent_user_list['list'] as $m)
			{
//				var_dump(__file__.' line:'.__line__,$m);exit;
				$html .= '<tr data-id="' . $m['su_uid'] . '">';
				$html .= '<td>' . $m['user']['name'] . '</td>';
				$html .= '<td>' . date('Y-m-d H:i:s', $m['create_time']) . '</td>';

				$html .= '<td><a target="_blank" class="am-btn am-btn-primary  " href="?_a=shop&_u=sp.agent&uid=' . $m['agent']['uid'] . '"><span>' . $m['agent']['user']['name'] . '</span></a></td>';
				$html .= '<td><a target="_blank" class="am-btn am-btn-primary  " href="?_a=shop&_u=sp.orderlist&user_id='.$m['su_uid'].'"><span>订单</span></a></td>';
				$html .= '<td><a target="_blank" class="am-btn am-btn-primary  " href="?_a=su&_u=sp.fanslist&uid='.$m['su_uid'].'"><span>更多资料</span></a></td>';



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
