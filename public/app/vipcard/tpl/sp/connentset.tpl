<div class="am-u-lg-0 am-u-md-32 am-u-sm-centered">
	<div class="am-cf am-padding">
		<div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">领会员卡的表单设置</strong> /
			<small>领取会员卡是需填写的表单，修改后<a href="?_a=vipcard&_u=sp.uiset2">会员卡内容设置</a>会重置，记得再去设置哦！</small>
		</div>
	</div>

</div>
<div class="am-form">
	<div class="am-g am-margin-top-sm ">
		<div class="am-u-sm-12">
			<?php

			unset($retain_field['user_point']);
			unset($retain_field['vip_card_su']['card_id']);
			unset($retain_field['vip_card_su']['rank']);
			$html = '';
			foreach ($retain_field as $rk => $rv)
			{
				foreach ($rv as $vk => $v)
				{
					$html .= '<div ><button disable="disable" class="am-margin-sm  am-fl am-btn  am-btn-success add_connent_item" data-group="' .
						$rk . '" data-key="' . $vk . '"><span class="am-icon-plus"> ' . $v . '</span></button></div>';
				}
			}
			$html .= '<div><button class="am-margin-sm  am-btn  am-btn-success add_connent_item" data-group="vip_card_su" data-key="other"><span class="am-icon-plus"> 自定义</span></button></div>';
			echo $html;
			?>

		</div>
	</div>
	<div class="am-u-sm-12">
		<table class="am-table am-table-striped am-table-hover table-main">
			<thead>
			<tr>
				<th class="table-sort" style="width: 100px;">序号</th>
				<th class="table-extitle">原名称</th>
				<th class="table-title">自定义名称</th>
				<th class="table-placeholder">提示语</th>
				<th class="table-need">必填</th>
				<th class="table-do">操作</th>
			</tr>
			</thead>
			<tbody class="table-tbody">
			<?php

			if (!$vip_card_set['ui_set'])
			{
				echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
			}
			else
			{
				$html = '';
				$i    = 1;
				foreach ($vip_card_set['connent'] as $ck => $cv)
				{
					if (($cv['group'] == 'vip_card_su'))
					{
						$ck = 'other';
					}
					if (empty($cv['protect']))
					{
						$html .= '<tr>';
						$html .= '<td><input  class="sort-value" type="number" min="1" value="' . $i . '"></td>';
						$html .= '<td class="group-value" data-group="' . $cv['group'] . '" data-key="' . $ck . '">' . (empty($retain_field[$cv['group']][$ck]) ? '自定义' : $retain_field[$cv['group']][$ck]) . '</td>';
						$html .= '<td ><input class="title-value" type="text" value="' . (empty($cv['title']) ? '' : $cv['title']) . '" placeholder="非必填"></td>';
						$html .= '<td ><input class="placeholder-value" type="text" value="' . (empty($cv['placeholder']) ? '' : $cv['placeholder']) . '" placeholder="非必填"></td>';
						$html .= '<td ><input class="need-value" type="checkbox"  ' . (empty($cv['need']) ? '' : 'checked') . '></td>';
						$html .= '<td ><span class="am-btn  am-btn-danger delete_connent_item">删除<span></td>';
						$html .= '</tr>';
						$i++;
					}

				}

				echo $html;
			}
			?>
			</tbody>
		</table>
	</div>
</div>

<div class="am-g am-margin-top-sm">
	<div class="am-u-sm-12 am-u-end">
		<p>
			<button class="am-u-sm-12 am-btn am-btn-lg am-btn-primary saveBtn">保存</button>
		</p>
	</div>
</div>
<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
	<div class="am-modal-dialog">
		<div class="am-modal-hd">删除内容项</div>
		<div class="am-modal-bd">
			确定要删除吗？
		</div>
		<div class="am-modal-footer">
			<span class="am-modal-btn" data-am-modal-confirm>确定</span>
			<span class="am-modal-btn" data-am-modal-cancel>取消</span>
		</div>
	</div>
</div>
<div class="hide-explame" style="display:none">
	<table>
		<tbody>
		<tr>
			<td><input class="sort-value" type="number" min="1" value="$sort-value$"></td>
			<td class="group-value" data-group="$group$" data-key="$key$">$title$</td>
			<td><input class="title-value" type="text" value="$title$"  placeholder="非必填"></td>
			<td><input class="placeholder-value" type="text" value=""  placeholder="非必填"></td>
			<td><input class="need-value" type="checkbox"></td>
			<td><span class="am-btn  am-btn-danger delete_connent_item">删除<span></td>
		</tr>
		</tbody>
	</table>
</div>

<script>
	var uid = <?php echo(!empty($vip_card_set['uid']) ? $vip_card_set['uid']:0) ?>;
	var connent_Data = <?php echo(!empty($connent) ? json_encode($connent):'') ?>;
</script>

<?php

$extra_js = $static_path . '/js/connentset.js';
?>