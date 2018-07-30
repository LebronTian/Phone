<style>
	.table-main tr {
		cursor: pointer;
	}

</style>
<link rel="stylesheet" href="/app/shop/static/css/fadeInBox.css"/>

<div class="am-cf am-padding">
	<div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">代理商管理</strong> /
		<small>总计 <?php echo $agent_list['count']; ?> </small>
	</div>
</div>

<div class="am-modal am-modal-confirm" tabindex="-1" id="Editnotice">
	<div class="am-modal-dialog">
		<div class="am-modal-hd">代理商的设置
			<a href="javascript: void(0)" class="am-close am-close-spin" data-am-modal-close>&times;</a>
		</div>
		<div class="am-modal-bd am-form">

			<div class="am-g am-margin-top-sm">
				<div class="am-u-sm-2 am-text-right">
					店铺名称
				</div>
				<div class="am-u-sm-10 am-u-end">
					<input type="text" id="id_title" value="$title$">
				</div>
			</div>
			<div class="am-g am-margin-top-sm">
				<div class="am-u-sm-2 am-text-right">
					店铺公告
				</div>
				<div class="am-u-sm-10 am-u-end">
					<input type="text" id="id_notice" value="$notice$">
				</div>
			</div>
			<div class="am-g am-margin-top-sm agent_bonus">
				<div class="Editnotice_tips am-text-center"></div>
			</div>
		</div>

		<div class="am-modal-footer">
			<span class="am-modal-btn" data-am-modal-confirm>确定</span>
			<span class="am-modal-btn" data-am-modal-cancel>取消</span>
		</div>
	</div>
</div>
<div class="am-g am-padding">
	<div class="am-u-md-6">
		<div class="am-form-group am-margin-left am-fl">
			<select data-am-selected="{btnSize: 'lg' }" class="option_cat">
				<?php
				$status_arr = array('0' => '通过', '1' => '等待审核', '2' => '不通过');
				$html       = '<option value="-1"';
				if (!isset($option['status']))
				{
					$html .= ' selected ';
				}
				$html .= '>全部状态</option>';

				foreach ($status_arr as $sk => $sv)
				{
					$html .= '<option value="' . $sk . '"';
					if (isset($option['status'] ) && $option['status'] == $sk)
					{
						$html .= ' selected';
					}
					$html .= '>' . $sv . '</option>';
				}
				echo $html;
				?>
			</select>
		</div>
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
//var_export($agent_list);
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
			<th class="table-cash_sum">佣金总额(&yen;)</th>
				<th class="table-order_fees_sum">订单总额(&yen;)</th>
			<th class="table-order_sum">订单数量</th>
			<th class="table-agent_user_count">用户数量</th>
			<th class="table-create_time">申请时间</th>
			<th class="table-status">状态</th>
			<th class="table-set">他的设置</th>

			<th class="table-set">他的店</th>
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
			$reviews  = array(
				0 => 'am-btn-success',
				1 => 'am-btn-default',
				2 => 'am-btn-danger',
			);
			$btn_word = array(
				0 => '通过审核',
				1 => '等待审核',
				2 => '不通过',
			);
			$html     = '';
			foreach ($agent_list['list'] as $m)
			{
				$html .= '<tr';
				$html .= ($m['status']==1)?' class="am-default"':(($m['status'] == 0)?' class="am-success "':' class="am-danger "');
				$html .= ' data-uid="' . $m['uid'] . '">' .
					'<td><a target="_blank" class="am-btn am-btn-primary  " href="?_a=su&_u=sp.fanslist&uid='.$m['su_uid'].'">' . $m['user']['name'] . '</td>';

				$html .= '<td>' . (empty($m['cash_sum']) ? '0' : sprintf('%.2f', $m['cash_sum'] / 100)) . '</td>';
				$html .= '<td>' . (empty($m['order_fee_sum']) ? '0' : sprintf('%.2f', $m['order_fee_sum'] / 100)) . '</td>';
				$html .= '<td><a target="_blank" class="am-btn am-btn-primary  " href="?_a=shop&_u=sp.agent_order&a_uid='.$m['uid'].'"><span>' . (empty($m['order_count']) ? '0' : $m['order_count']) . '</span></a></td>';
				$html .= '<td> <a target="_blank" class="am-btn am-btn-primary  " href="?_a=shop&_u=sp.agent_user&a_uid='.$m['uid'].'"><span>' . (empty($m['user_count']) ? '0' : $m['user_count']) . '</span></a></td>';
				$html .= '<td>' . date('Y-m-d H:i:s', $m['create_time']) . '</td>';
				$html .= '<td><select data-am-selected="{btnSize: \'sm\' ,btnWidth: \'100px\'}" class="option_check">';
				foreach ($status_arr as $sk => $sv)
				{
					$html .= '<option value="' . $sk . '"';
					if ($sk== $m['status'])
					{
						$html .= ' selected';
					}
					$html .= '>' . $sv . '</option>';
				}
				$html .='</select></td>';

				$html .= '</div></div></td>' ;
				$html .= '<td><span class="am-btn am-btn-primary  edit_notice" >编辑</span>'.
					'<input class="agent_notice" style="display: none;" value="'.(empty($m['notice'])?'':$m['notice']).'">'.
					'<input class="agent_title" style="display: none;" value="'.(empty($m['title'])?'':$m['title']).'">'.
					'</td>';

				$html .= '<td><a class="am-btn am-btn-success  " target="_blank" href="'.DomainMod::get_app_url('shop',0,array('s_a_uid'=>$m['uid'])).'" ><span class="am-icon-shopping-cart"> '.(empty($m['title'])?'他的店':$m['title']).'</span></a></td>';
				$html .='</tr>';

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
	$static_path . '/js/agent_list.js',
);
?>
<script>
</script>
