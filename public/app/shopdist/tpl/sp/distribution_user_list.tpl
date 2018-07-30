<style>
	.table-main tr {
		cursor: pointer;
	}

</style>
<link rel="stylesheet" href="/app/shop/static/css/fadeInBox.css"/>

<div class="am-cf am-padding">
	<div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">分销成员管理</strong> /
		<small>总计 <?php echo $dtb_user_list['count']; ?> </small>
	</div>
</div>

<div class="am-g am-padding">
	<div class="am-u-md-2">
		<div class="am-fr">
			<div class="am-input-group am-input-group-sm">
                <span class="am-input-group-btn" <?php if(empty($option['parent_su_uid']) && empty($option['su_uid'])) echo 'style="display:none;"'; ?>>
                  <a class="am-btn am-btn-default " type="button" href="?_a=shopdist&_u=sp.distribution_user_list">查看全部</a>
                </span>
				<span class="am-input-group-btn"> 
                <a class="am-btn" href="?_a=shopdist&_u=sp.distribution_user_group_set">[用户分组]</a>
                </span>
			</div>
		</div>
	</div>
	<div class="am-u-md-4">
		<a  href="?_a=shopdist&_u=sp.distribution_user_set" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 添加分销成员</a>
	</div>
	<div class="am-u-md-3 am-cf">
		<div class="am-fr">
			<div class="am-input-group am-input-group-sm">
				<input type="text" class="am-form-field option_key" value="<?php echo $option['key']; ?>">
                <span class="am-input-group-btn">
                  <button class="am-btn am-btn-default option_key_btn" type="button">搜索</button>
                </span>
			</div>
		</div>
	</div>

</div>

<?php
//var_export($dtb_user_list);
?>

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
			<th class="table-family_order_fees_sum">家族订单总额</th>
			<th class="table-order_sum">订单数量</th>
			<th class="table-family_order_sum">家族订单总数</th>
			<th class="table-parent_user_name">上级用户名</th>
			<th class="table-L1_cnt">下一级数量</th>
			<th class="table-L2_cnt">下二级数量</th>
			<th class="table-L3_cnt">下三级数量</th>
			<th class="table-create_time">时间</th>
			<th class="table-status">状态</th>
			<th class="table-set">操作</th>
		</tr>
		</thead>
		<tbody>
		<?php
		if (!$dtb_user_list['list'])
		{
			echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
		}
		else
		{
			$reviews  = array(
				0 => 'am-btn-default',
				1 => 'am-btn-success',
				2 => 'am-btn-danger',
			);
			$btn_word = array(
				0 => '未审核',
				1 => '通过',
				2 => '拒绝',
			);
			$html     = '';
			foreach ($dtb_user_list['list'] as $m)
			{
				$html .= '<tr';

				if ($m['status'])
				{
					if ($m['status'] == 1)
					{
						$html .= ' class="am-success "';
					}
					else
					{
						$html .= ' class="am-danger "';
					}
				}
				else
				{
					$html .= 'class="am-default"';
				}

				$html .= ' data-id="' . $m['su_uid'] . '">' .
					'<td><a href="?_a=su&_u=sp.fansdetail&uid='.$m['su_uid'].'">' . $m['user']['name'] . '</a>';
				if(!empty($m['rule_data']) && array_sum(array_column($m['rule_data'], '0'))) {
					$html .= '<br><strong class="am-text-danger">['.implode(' , ', array_map(function($it){ return $it[0]/100;}, $m['rule_data'])).']</strong>';
				}
				$html .= '</td>';

				$html .= '<td>' . (empty($m['cash_sum']) ? '0' : sprintf('%.2f', $m['cash_sum'] / 100)) . '</td>';
				$html .= '<td>' . (empty($m['own_order_fee_sum']) ? '0' : sprintf('%.2f', $m['own_order_fee_sum'] / 100)) . '</td>';
				$html .= '<td>' . (empty($m['family_order_fee_sum']) ? '0' : sprintf('%.2f', $m['family_order_fee_sum'] / 100)) . '</td>';
				$html .= '<td>' . (empty($m['own_order_count']) ? '0' : $m['own_order_count']) . '</td>';
				$html .= '<td>' . (empty($m['family_order_count']) ? '0' : $m['family_order_count']) . '</td>';
				if (!empty($m['parent_user']['uid']))
				{
					$html .= '<td><a  class="am-text-warning "  href="?_a=shopdist&_u=sp.distribution_user_list&su_uid=' . $m['parent_user']['uid'] . '">' .
						(empty($m['parent_user']['name']) ? '无' : $m['parent_user']['name']) . '<a></td>';
				}
				else
				{
					$html .= '<td>' . (empty($m['parent_user']['name']) ? '无' : $m['parent_user']['name']) . '</td>';
				}
				if(!empty($m['L1_cnt']))
				{
					$html .= '<td><a  class="am-text-warning "  href="?_a=shopdist&_u=sp.distribution_user_list&parent_su_uid=' . $m['su_uid'] . '">' . (empty($m['L1_cnt']) ? '0' : $m['L1_cnt']) . '</td>';

				}
				else
				{
					$html .= '<td>0</td>';

				}
				$html .= '<td>' . (empty($m['L2_cnt']) ? '0' : $m['L2_cnt']) . '</td>';
				$html .= '<td>' . (empty($m['L3_cnt']) ? '0' : $m['L3_cnt']) . '</td>';
				$html .= '<td>' . date('Y-m-d H:i:s', $m['create_time']) . '</td>

					<td>
					    <div class="am-dropdown" data-am-dropdown>
					        <button class="' . (isset($reviews[$m['status']]) ? $reviews[$m['status']] : "am-btn-white") . ' am-btn am-btn-sm am-dropdown-toggle" data-am-dropdown-toggle >
					            ' . (isset($btn_word[$m['status']]) ? $btn_word[$m['status']] : "") . '
					        </button>
					        <ul data-uid="' . $m['su_uid'] . '" style="min-width:100%;text-align:center" class="am-dropdown-content status-sel">
					            <li data-pass="1" class="am-btn-success">通过</li>
					            <li data-pass="2" class="am-btn-danger">拒绝</li>
					        </ul>
					    </div>
					</td>

					<td><div class="am-btn-toolbar"><div class="am-btn-group am-btn-group-xs">';

				            $html .= '<a class="am-text-secondary" href="?_a=shopdist&_u=sp.distribution_user_set&uid='.$m['su_uid'].'"><span class="am-icon-edit"></span> 编辑</a>';
				////            $html .= '<button class="am-btn am-btn-secondary am-btn-xs message-more" data-uid="'.$m['uid'].'">查看详情</button>';
				//
				if(!empty($_REQUEST['_d'])){
								$html .= '<button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id="'.$m['su_uid'].'"><span class="am-icon-trash-o"></span> 删除</button>';
								}


				$html .= '</div></div></td>' . '</tr>';

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
