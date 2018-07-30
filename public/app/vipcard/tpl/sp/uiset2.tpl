<style>
	.title-span {
		float: left;
		line-height: 2.7;
	}

	.title-span.margin-left {
		margin-left: 10px;
	}

	.hide-section {
		display: none;
	}
</style>
<div class="am-u-lg-0 am-u-md-32 am-u-sm-centered">
	<div class="am-cf am-padding">
		<div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">会员卡内容设置</strong> /
			<small>设置打印在会员卡上的内容</small>
		</div>
	</div>
</div>
<?php $vip_card_ui = $vip_card_set['ui_set'];

function option_html($retain_field, $i = '')
{
	$option_html = '<select data-am-selected="{btnSize: \'default\' }" class="option_cat"><option value="0"';
	if (isset($option['status']) && $option['status'] == 0)
	{
		$option_html .= ' selected ';
	}
	$option_html .= '>选一个字段</option>';

	foreach ($retain_field as $ck => $cv)
	{
		foreach ($cv as $cvk => $cvv)
		{
			$option_html .= ' <option data-group="' . $ck . '" value="' . $cvk . '"';
			if (isset($i) && $i == $cvk)
			{
				$option_html .= ' selected';
			}
			$option_html .= '>' . $cvv . '</option>';
		}


	}
	echo $option_html . '</select>';
}


?>

<div class="am-form">
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			预览会员卡
		</div>
		<div class="am-u-sm-10"><img src="?_a=vipcard&_u=api.get_vip_card_image"></div>
	</div>
	<!--图片-->
	<?php
	$temp_index = 1;
	if (!empty($vip_card_ui['image']))
	{
		$pic_num = 1;
		foreach ($vip_card_ui['image'] as $title => $img)
		{
			if (!is_numeric($title))
			{
				continue;
			}//跳过有键值
			?>
			<div class="am-g am-margin-top-sm image-section">
				<div class="am-u-sm-2 am-text-right">
					<?php
					if (!is_numeric($title))
					{
						echo $title;
					}
					else
					{
						echo "图片" . $pic_num;
					}
					?>
				</div>
				<div class="am-u-sm-2">
					<?php
					$temp_arr['user']['avatar'] = $retain_field['user']['avatar'];
					option_html($temp_arr, (isset($connent_show_arr['image'][$temp_index]) ? $connent_show_arr['image'][$temp_index] : ''));
					$pic_num++;
					if (isset($connent_show_arr['image'][$temp_index]))
					{
						$temp_index++;
					}
					?>

				</div>
				<div class="am-u-sm-2 am-text-right">名称:</div>
				<div class="am-u-sm-2"><input class="title-value" type="text" value="<?php
					if (isset($connent_show_arr['image'][$temp_index]) && $key = $connent_show_arr['image'][$temp_index])
					{
						echo(empty($connent[$key]['image']) ? '' : $connent[$key]['title']);
					}
					?>" placeholder="不建议为空，可填头像之类的">
				</div>
				<div class="am-u-sm-4 am-text-left"></div>


			</div>
			<?php
		}
	}
	?>
	<!--文本-->
	<?php
	$temp_index = 1;
	if (!empty($vip_card_ui['string']))
	{
		$str_num = 1;
		unset($retain_field['user']['avatar']);
		foreach ($vip_card_ui['string'] as $title => $str)
		{
			if (!is_numeric($title))
			{
				continue;
			}//跳过有键值
			?>
			<div class="am-g am-margin-top-sm string-section">
				<div class="am-u-sm-2 am-text-right">
					<?php
					if (!is_numeric($title))
					{
						echo $title;
					}
					else
					{
						echo "文本" . $str_num;

					}
					?>
				</div>
				<div class="am-u-sm-2">
					<?php
					option_html($retain_field, (isset($connent_show_arr['string'][$temp_index]) ? $connent_show_arr['string'][$temp_index] : ''));
					?>

				</div>

				<div class="am-u-sm-2 am-text-right">名称:</div>
				<div class="am-u-sm-2"><input class="title-value" type="text" value="<?php
					if (isset($connent_show_arr['string'][$temp_index]) && $key = $connent_show_arr['string'][$temp_index])
					{
						echo(empty($connent[$key]['title']) ? '' : $connent[$key]['title']);
					}
					?>" placeholder="打印时必填"></div>

				<div class="am-u-sm-4 am-text-center ">打印名称:
<!--				</div>-->
<!--				<div class="am-u-sm-1 am-text-left ">-->
					<input type="checkbox" class="show_title" <?php
					if (isset($connent_show_arr['string'][$temp_index]) && $key = $connent_show_arr['string'][$temp_index])
					{
						echo(empty($connent[$key]['show_title']) ? '' : 'checked');
					}
					?>></div>
			</div>
			<?php
			$temp_index++;
			$str_num++;
		}
	}
	?>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			&nbsp;
		</div>
		<div class="am-u-sm-10">
			<button class="am-btn am-btn-primary saveBtn">保存</button>
		</div>
	</div>
</div>
<script>
	var uid = <?php echo(!empty($vip_card_set['uid']) ? $vip_card_set['uid']:0) ?>;
	var connent_Data = <?php echo(!empty($connent) ? json_encode($connent):'') ?>;
</script>

<?php
$extra_js = array(
	'/app/vipcard/static/js/uiset2.js',
)
?>