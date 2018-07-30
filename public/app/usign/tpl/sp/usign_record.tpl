<div class="am-cf am-padding">
	<div class="am-fl am-cf">
		<a href="?_a=reward&_u=sp">
			<strong class="am-text-primary am-text-lg">签到记录</strong></a>
		<span class="am-icon-angle-right"></span>
		/
		<small>总计 <?php echo $usign_record['count']; ?> 条记录</small>
	</div>
</div>

<div class="am-g am-padding ">
<!--	<div class="am-u-md-3 am-fr ">-->
<!--		<div class="am-input-group am-input-group-sm">-->
<!--			<input type="text" class="am-form-field option_key" value="--><?php //echo $option['key'];?><!--">-->
<!--                <span class="am-input-group-btn">-->
<!--                  <button class="am-btn am-btn-default option_key_btn" type="button">搜索</button>-->
<!--                </span>-->
<!--		</div>-->
<!--	</div>-->

</div>


<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm">
	<div class="am-modal-dialog">
		<div class="am-modal-hd">删除签到吗</div>
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
			<?php
			$html = '';
			$html = '<th style="min-width: 95px"><input type="checkbox" class="ccheckall">
				<a href="javascript:;" class="am-text-danger am-text-lg cdeleteall" style="margin-left:10px;"><span class="am-icon-trash"></span></a>
				</th>';
			$html .= '<th>用户名</th>';
			$html .= '<th>签到时间</th>';
			$html .= '<th>其他信息</th>';
			if(!empty($_REQUEST['_d']))
			{
				$html .= '<th>操作</th>';

			}
			echo $html;
			?>
		</tr>
		</thead>
		<tbody>
		<?php
		if (!$usign_record['list'])
		{
			echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
		}
		else
		{
			$html = '';
			foreach ($usign_record['list'] as $ur)
			{
				$html .= '<tr data-uid="' . $ur['uid'] . '"">';
				$html .= '<td class="table-check"><input type="checkbox" class="ccheck"></td>';
				$html .= '<td>' . (empty($ur['user']['name'])?'':$ur['user']['name']) . '</td>';
				$html .= '<td>' . date('Y-m-d H:i:s', $ur['create_time']) . '</td>';
				$html .= '<td>'.(empty($ur['info_data'])?'':$ur['info_data']).'</td>';
				if(!empty($_REQUEST['_d']))
				{
					$html .='<td><span target="_blank" class="am-btn am-btn-danger cdelete" data-id="' . $ur['uid'] . '">删除</span></td>';
				}
				$html . '</tr>';
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
//	'/app/vipcard/static/js/vip_card_list.js',
);
?>