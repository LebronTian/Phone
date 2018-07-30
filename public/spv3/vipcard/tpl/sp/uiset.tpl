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
		<div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">界面设置</strong> /
			<small>至少设置一张背景图片，有设计团队的可以把 logo 文字类 可直接放在背景图片中</small>
		</div>
	</div>
</div>
<?php $vip_card_ui  = $vip_card_set['ui_set'];
$vip_card_rank_rule = $vip_card_set['rank_rule']; ?>

<div class="am-form">
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			预览会员卡
		</div>
		<div class="am-u-sm-10"><img src="?_a=vipcard&_u=api.get_vip_card_image"></div>
	</div>
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			背景图片（必填）
		</div>
		<div class="am-u-sm-10">
			<button class="am-btn am-btn-primary imgBoxBtn" data-addr="#bg-img">点击选择图片</button>
			<div style="margin-top: 0.5em">
				<?php
				$bg_width  = (!empty($vip_card_ui['back_ground']['size'][0])) ? $vip_card_ui['back_ground']['size'][0] : "0";
				$bg_height = (!empty($vip_card_ui['back_ground']['size'][1])) ? $vip_card_ui['back_ground']['size'][1] : "0";
				?>
				<img id="bg-img"
				     alt="推荐长宽：<?php echo $bg_width ?> x <?php echo $bg_height ?>"
				     style="width:<?php echo $bg_width ?>px ;height: <?php echo $bg_height ?>px; text-align: center;line-height: <?php echo $bg_height ?>px;background: #eee"
				     src="<?php if (!empty($vip_card_ui['back_ground']['path']))
				     {
					     echo $vip_card_ui['back_ground']['path'];
				     } ?>"
					>
			</div>
		</div>
	</div>
	<!--图片-->
	<?php
	$rank_image = 0;
	if (!empty($vip_card_ui['image']))
	{
		$pic_num = 1;
		foreach ($vip_card_ui['image'] as $title => $img)
		{

			if (is_numeric($title))
			{
				continue;
			}//跳过无键值
			if ($title == 'rank_image')
			{
				$rank_image = 1;
			}
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
						$pic_num++;
					}
					?>
				</div>
				<div class="am-u-sm-10">
					<button class="am-btn am-btn-primary imgBoxBtn" data-addr="#<?php echo $title; ?>-img">点击选择图片
					</button>
					<div style="margin-top: 0.5em">
						<?php
						$logo_width  = (!empty($img['size'][0])) ? $img['size'][0] : "0";
						$logo_height = (!empty($img['size'][1])) ? $img['size'][1] : "0";
						?>
						<img class="vipcard-img"
						     id="<?php echo $title; ?>-img"
						     data-title="<?php echo $title; ?>"
						     alt="<?php echo $logo_width ?> x <?php echo $logo_height ?>"
						     style="width:<?php echo $logo_width ?>px ;height: <?php echo $logo_height ?>px; text-align: center;line-height: <?php echo $logo_height ?>px;background: #eee"
						     src="<?php echo $img['path'] ?>"
							>

						<div class="am-u-sm-6 am-padding-sm hide-section" style="float: none">
							<span class="title-span">位置坐标</span>
							<span class="title-span margin-left">X：</span><input value="<?php echo $img['point'][0] ?>"
							                                                     style="float:left;width: 4em"
							                                                     type="text">
							<span class="title-span margin-left">Y：</span><input value="<?php echo $img['point'][1] ?>"
							                                                     style="float:left;width: 4em"
							                                                     type="text">
						</div>
					</div>
				</div>
			</div>
			<?php
		}
	}

	?>
	<!--等级不同的图片-->
	<?php

	if (($rank_image == 1) && !empty($vip_card_rank_rule))
	{
		?>
		<div class="am-g am-margin-top-sm ">
			<div class="am-u-sm-5 am-margin-sm am-text-center am-text-primary ">
				此模板支持不同会员卡等级拥有不同会员卡。
			</div>
		</div>
		<?php
		$pic_num = 0;
		foreach ($vip_card_rank_rule as $rank_point => $rank_data)
		{
			?>
			<div class="am-g am-margin-top-sm rank_image-section">
				<div class="am-u-sm-2 am-text-right">
					<?php
					if (!empty($rank_data['rank_name']))
					{
						echo $rank_data['rank_name'];
					}
					else
					{
						echo "会员卡级别" . $pic_num . '图片';

					}
					?>
				</div>
				<div class="am-u-sm-10">
					<button class="am-btn am-btn-primary imgBoxBtn" data-addr="#<?php echo $pic_num ?>-img">点击选择图片
					</button>
					<div style="margin-top: 0.5em">
						<img class="rank_image-img"
						     id="<?php echo $pic_num; ?>-img"
						     data-title="<?php echo $pic_num; ?>"
						     alt="不同会员等级的自定义图片"
						     style="width:100px ;height: 100px; text-align: center;background: #eee"
						     src="<?php echo(empty($vip_card_ui['rank_image_list'][$pic_num]) ? '' : $vip_card_ui['rank_image_list'][$pic_num]); ?>"
							>

					</div>
				</div>
			</div>
			<?php
			$pic_num++;
		}
	}

	?>
	<!--文本-->
	<?php
	if (!empty($vip_card_ui['string']))
	{
		$str_num = 1;
		foreach ($vip_card_ui['string'] as $title => $str)
		{
			if (is_numeric($title))
			{
				continue;
			}//跳过无键值
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
						$str_num++;
					}
					?>
				</div>
				<div class="am-u-sm-10">
					<input type="text" class="vipcard-input" value="<?php echo $str['content'] ?>"
					       data-title="<?php echo $title ?>"/>
					<!--属性-->
					<div class="am-u-sm-6 am-padding-sm hide-section">
						<span class="title-span">文字粗细Bold：</span>
						<input value="<?php echo $str['bold'] ?>" style="float:left;width: 4em" type="text"/>
						<span class="title-span margin-left">px</span>
					</div>
					<div class="am-u-sm-6 am-padding-sm hide-section">
						<span class="title-span">文字颜色Color：</span>
						<input style="width: 5em" class="color" type="text" value="<?php
						$color = '';
						foreach ($str['color'] as $c)
						{
							$dechex = dechex($c);
							$color .= $dechex;
						}
						echo($color);
						?>">
					</div>
					<div class="am-u-sm-6 am-padding-sm hide-section">
						<span class="title-span">文字大小Size：</span>
						<input value="<?php echo $str['size'] ?>" style="float:left;width: 4em" type="text"/>
						<span class="title-span margin-left">px</span>
					</div>
					<div class="am-u-sm-6 am-padding-sm hide-section">
						<span class="title-span">位置坐标</span>
						<span class="title-span margin-left">X：</span><input value="<?php echo $str['point'][0] ?>"
						                                                     style="float:left;width: 4em" type="text">
						<span class="title-span margin-left">Y：</span><input value="<?php echo $str['point'][1] ?>"
						                                                     style="float:left;width: 4em" type="text">
					</div>
				</div>
			</div>
			<?php
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
	var setData = <?php echo(!empty($vip_card_set)? json_encode($vip_card_set):"null")?>;
	var uiData = <?php echo(!empty($vip_card_ui)? json_encode($vip_card_ui):"null")?>;//有用
	console.log("vip_card_set", setData);
	console.log("$vip_card_ui", uiData);
</script>
<?php
$extra_js = array(
	'/app/site/view/wapsite/static/js/jscolor.js',
	'/app/vipcard/static/js/uiset.js',
)
?>
<script>
	seajs.use(['selectPic']);
</script>
