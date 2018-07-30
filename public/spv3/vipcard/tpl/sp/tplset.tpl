<div class="am-cf am-padding">
	<div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">会员卡样式选择</strong> /
		<small>选择一个适合的样式。您可以直接使用官方样式，或者自制独享样式，再次应用生效。应用后<a href="?_a=vipcard&_u=sp.uiset">界面设置</a>会被重置。</small>
	</div>
</div>


<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
	<div class="am-modal-dialog">
		<div class="am-modal-hd">删除模板</div>
		<div class="am-modal-bd">
			确定要删除吗？
		</div>
		<div class="am-modal-footer">
			<span class="am-modal-btn" data-am-modal-confirm>确定</span>
			<span class="am-modal-btn" data-am-modal-cancel>取消</span>
		</div>
	</div>
</div>
<div class="am-u-sm-12">
	<table class="am-table am-table-striped am-table-hover table-main">
		<thead>
		<tr>
			<th class="table-contact">模板编号</th>
			<th class="table-contact">原模板编号</th>
			<th class="table-brief">类型</th>
			<th class="table-contact">示例图片</th>

			<!--            <th class="table-status">状态</th>-->
			<th class="table-set">操作</th>
			<th class="table-set">状态</th>
		</tr>
		</thead>
		<tbody>
		<?php
		if (!$vip_card_tpl_list['list'])
		{
			echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
		}
		else
		{
			$html = '';
			foreach ($vip_card_tpl_list['list'] as $m)
			{
				$html .= '<tr>';
				$html .= '<td>' . $m['uid'] . '</td>';

				$html .= '<td>' . (empty($m['original_uid']) ? '官方模板' : $m['original_uid']) . '</td>';
				$html .= '<td>' . (empty($m['sp_uid']) ? '公用模板' : '独享模板') . '</td>';
				$html .= '<td style="max-width: 20em">
							<img style="max-width:250px;max-height:250px;" src="'.((!empty($m['tpl_img']))?$m['tpl_img']:'?_a=vipcard&_u=api.get_vip_card_tpl_image&uid='.$m['uid']).'">
							<p style="word-break: break-all;">'.(!empty($m['brief'])?$m['brief']:'').'</p>
						  </td>';
				$html .= '<td><button class="am-btn set_tpl" data-tpl_uid="' . $m['uid'] . '">应用</button>';
				$html .= '<a class="am-btn am-btn-primary  " href="?_a=vipcard&_u=sp.edittpl&uid=' . $m['uid'] . '">编辑</a>';
				empty($m['sp_uid']) || $html .= '<span target="_self" class="am-btn am-btn-danger cdelete" data-id="' . $m['uid'] . '">删除</span>';
				$html .= '</td>';
				if ($vip_card_set['vip_card_tpl_uid'] == $m['uid'])
				{
					$html .= '<td><button class="am-btn am-btn-success">使用中</button></td>';
				}
				else{
					$html .= '<td></td>';

				}
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

<script>
	var uid = <?php echo(!empty($vip_card_set['uid']) ? $vip_card_set['uid']:0) ?>;
</script>
<?php
$extra_js = array(
	'/app/vipcard/static/js/tplset.js',
);
?>
