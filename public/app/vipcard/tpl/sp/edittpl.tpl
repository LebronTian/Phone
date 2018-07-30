<style>
	.title-span {
		float: left;
		/*line-height: 2.7;*/
	}

	.title-span.margin-left {
		margin-left: 10px;
	}

	.hide-section {
		/*display: none;*/
	}
</style>

<div class="am-u-lg-0 am-u-md-32 am-u-sm-centered">
	<div class="am-cf am-padding">
		<div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">模板编辑</strong> /
			<small>修改模板细节，保存为私有模板</small>
		</div>
	</div>
</div>
<?php $vip_card_tpl_data = $vipcardtpl['data'] ?>

<div class="am-form">
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			预览模板
		</div>
		<div class="am-u-sm-10"><img src="?_a=vipcard&_u=api.get_vip_card_tpl_image&uid=<?php echo $vipcardtpl['uid']; ?>"></div>
	</div>
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			背景图片尺寸
		</div>
		<div class="am-u-sm-5 am-text-left">
				<?php
				$bg_width = (!empty($vip_card_tpl_data['back_ground']['size'][0]))?$vip_card_tpl_data['back_ground']['size'][0]:"0";
				$bg_height = (!empty($vip_card_tpl_data['back_ground']['size'][1]))?$vip_card_tpl_data['back_ground']['size'][1]:"0";
				?>
				长：<?php echo $bg_width?>  x宽：<?php echo $bg_height?>
		</div>
		<div class="am-u-sm-5">
		</div>
	</div>
	<!--图片-->
	<?php
	if (!empty($vip_card_tpl_data['image']))
	{
		$pic_num = 1;
		foreach ($vip_card_tpl_data['image'] as $title => $img)
		{
			//            if(is_numeric($title)) continue;//跳过无键值
			?>
			<div class="am-g am-margin-top-sm image-section">
				<div class="am-u-sm-2 am-text-right image_title" data-keys="<?php echo $title;?>">
					<?php
					$logo_width  = (!empty($img['size'][0])) ? $img['size'][0] : "0";
					$logo_height = (!empty($img['size'][1])) ? $img['size'][1] : "0";
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
				<div class="am-u-sm-10 ">
					<div class="am-u-sm-4 hide-section ">
						<span class="title-span">尺寸</span>
						<span class="title-span margin-left">宽：</span><input class="image_s_w" value="<?php echo $img['size'][0] ?>"
						                                                     style="float:left;width: 20%" type="text">
						<span class="title-span margin-left">高：</span><input class="image_s_h" value="<?php echo $img['size'][1] ?>"
						                                                     style="float:left;width: 20%" type="text">
					</div>
					<div class="am-u-sm-4 hide-section ">
						<span class="title-span">坐标</span>
						<span class="title-span margin-left">X：</span><input  class="image_p_x" value="<?php echo $img['point'][0] ?>"
						                                                     style="float:left;width: 20%" type="text">
						<span class="title-span margin-left">Y：</span><input  class="image_p_y" value="<?php echo $img['point'][1] ?>"
						                                                     style="float:left;width: 20%" type="text">
					</div>
					<div class="am-u-sm-4  hide-section">
						<span class="title-span">圆角:</span>
						  <input class="image_l" style="float:left;width: 20%" type="text"  value="<?php echo empty($img['l'])?0:$img['l'];?>">
						<span class="title-span margin-left">px</span>

					</div>
				</div>
			</div>
			<?php
		}
	}
	?>
	<!--文本-->
	<?php
	if (!empty($vip_card_tpl_data['string']))
	{
		$str_num = 1;
		foreach ($vip_card_tpl_data['string'] as $title => $str)
		{
			//            if(is_numeric($title)) continue;//跳过无键值
			?>
			<div class="am-g am-margin-top-sm string-section ">
				<div class="am-u-sm-2 am-text-right string_title" data-keys="<?php echo $title;?>" >
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
					<div class="am-u-sm-4  hide-section">
						<span class="title-span">文字粗细Bold：</span>
						<input class="string_b" value="<?php echo $str['bold'] ?>" style="float:left;width: 20%" type="text"/>
						<span class="title-span margin-left"></span>
					</div>
					<div class="am-u-sm-4 am-text-left hide-section">
						<span class="title-span">文字颜色Color：</span>
						<input class="string_c color" style="width: 5em"  type="text" value="<?php
						$color = '';
						foreach ($str['color'] as $c)
						{
							$dechex = dechex($c);
							$color .= $dechex;
						}
						echo($color);
						?>">
					</div>
					<div class="am-u-sm-2 am-text-left hide-section">
					</div>
				</div>
<!--			</div>-->
<!--			<div class="am-g am-margin-top-sm string-section">-->
				<div class="am-u-sm-2 am-text-right">
					&nbsp;
				</div>
				<div class="am-u-sm-10 am-margin-top-sm ">
					<div class="am-u-sm-4  hide-section">
						<span class="title-span">文字大小Size：</span>
						<input class="string_s" value="<?php echo $str['size'] ?>" style="float:left;width: 20%" type="text"/>
						<span class="title-span margin-left">px</span>
					</div>
					<div class="am-u-sm-4 am-text-left hide-section">
						<span class="title-span">位置坐标</span>
						<span class="title-span margin-left">X：</span><input class="string_p_x" value="<?php echo $str['point'][0] ?>"
						                                                     style="float:left;width: 20%" type="text">
						<span class="title-span margin-left">Y：</span><input class="string_p_y"  value="<?php echo $str['point'][1] ?>"
						                                                     style="float:left;width: 20%" type="text">
					</div>
					<div class="am-u-sm-2 am-text-left hide-section">
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
	var uid = <?php echo(!empty($vipcardtpl['uid'])? $vipcardtpl['uid']:"null")?>;
	var tpl_datas = <?php echo(!empty($vip_card_tpl_data)? json_encode($vip_card_tpl_data):"null")?>;//有用
	console.log("vip_card_set", uid);
	console.log("$vip_card_tpl_data", tpl_datas);
</script>
<?php
$extra_js = array(

	'/app/site/view/wapsite/static/js/jscolor.js',
	'/app/vipcard/static/js/edittpl.js',
)
?>