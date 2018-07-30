<link rel="stylesheet" type="text/css" href="/app/sp/static/css/jquery.Jcrop.css">
<body>
<div class="am-cf am-padding ">
	<div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">海报图片</strong> /
		<small>设置海报以及小程序码码的位置</small>
	</div>
	<hr>
</div>

<div class="am-cf am-padding am-form">
	<div class="am-g am-margin">
		<div class="am-u-sm-3 am-text-right">
			小程序：
		</div>
		<div class="am-u-sm-6 am-u-end">
			<select id="id_public">
				<?php
				  $title_all_public = WeixinMod::get_all_weixin_public_by_sp_uid();
					$now_public = $wx['public_name'];
					$whether_empower = $wx['access_mod'];
					$html = '';
				  foreach($title_all_public as $p){
				  		$html .= '<option value="'.$p['uid'].'"';
				  		if($p['uid'] == $qp['public_uid']){
						$html .= 'selected="selected"';
				  		}
						$html .= '>'.$p['public_name'].'</option>';
				}
				echo $html;
				?>
			</select>
		</div>
	</div>
	<div class="am-g am-margin">
		<div class="am-u-sm-3" style="text-align:right">
			小程序码路径：
		</div>
		<div class="am-u-sm-6 am-u-end">
			<input id="id_path" class="am-form-field am-form-lg" value='<?php
			if(!empty($qp['photo_info']['xcxpath'])) echo $qp['photo_info']['xcxpath'];?>' placeholder="设置扫码跳转对应路径">
		</div>
	</div>
	<div class="am-g am-margin">
		<div class="am-u-sm-3" style="text-align:right">
		小程序码位置：
		</div>
		<div class="am-u-sm-6 am-u-end">
		<input id="id_set_qrcode" class="cset am-form-field am-form-lg" value='<?php
			if(!empty($qp['photo_info']['xcxcode'])) echo json_encode($qp['photo_info']['xcxcode']);?>' placeholder="点击在背景图上进行设置">
		</div>
	</div>

	<div class="am-g am-margin">
		<div class="am-u-sm-3" style="text-align:right">
		头像位置：
		</div>
		<div class="am-u-sm-6 am-u-end">
		<input id="id_set_avatar" class="cset am-form-field am-form-lg" value='<?php 
			if(!empty($qp['photo_info']['avatar'])) echo json_encode($qp['photo_info']['avatar']);?>' placeholder="点击在背景图上进行设置">
		</div>
	</div>

	<div class="am-g am-margin">
		<div class="am-u-sm-3" style="text-align:right">
		<label for="id_avatar_round">使用圆形头像：</label>
		</div>
		<div class="am-u-sm-6 am-u-end">
		<input type="checkbox" id="id_avatar_round" class="cset2" <?php 
			if(!empty($qp['photo_info']['avatar_round'])) echo ' checked="checked"';?>>
		</div>
	</div>

	<div class="am-g am-margin">
		<div class="am-u-sm-3" style="text-align:right">
		昵称位置：
		</div>
		<div class="am-u-sm-6 am-u-end">
		<input id="id_set_nickname" class="cset am-form-field am-form-lg" value='<?php 
			if(!empty($qp['photo_info']['nickname'])) echo json_encode($qp['photo_info']['nickname']);?>' placeholder="点击在背景图上进行设置">
		</div>
	</div>

	<div class="am-g am-margin">
		<div class="am-u-sm-3" style="text-align:right">
		<label for="id_nickname_center">昵称居中显示：</label>
		</div>
		<div class="am-u-sm-6 am-u-end">
		<input type="checkbox" id="id_nickname_center" class="cset2" <?php 
			if(!empty($qp['photo_info']['nickname_center'])) echo ' checked="checked"';?>>
		</div>
	</div>

	<div class="am-g am-margin">
		<div class="am-u-sm-3" style="text-align:right">
		昵称颜色：
		</div>
		<div class="am-u-sm-6 am-u-end">
		<input id="id_set_nickcolor" class="color am-form-field am-form-lg" value='<?php 
			if(!empty($qp['photo_info']['nickcolor'])) echo ($qp['photo_info']['nickcolor']);?>' placeholder="点击设置颜色">
		</div>
	</div>

</div>

<div class="am-form" action="" data-am-validator>
	<div class="am-g am-form-group clearfix " id="parent">
		<label class="am-u-sm-3 am-form-label" style="text-align:right;">背景图片</label>

		<div class="am-u-sm-9">
			<button class="imgBoxBtn client-btn am-btn am-btn-secondary" data-addr="#client-avatar,.jcrop-preview">
				从图片库选择
			</button>
			<p><span class="am-icon-info"></span> 图片格式建议为png, 大小不超过2M, 宽度不超过800px</p>
		<!--预加载的图片-->
			<div id="default_img" class="def_img" style="margin-left:0px;margin-top: 50px">
				<img id="id_back_ground" src="<?php echo((empty($qp['photo_info']['img_url'])?'':$qp['photo_info']['img_url'])); ?>">
			</div>
		</div>
	</div>

	<div class="am-g am-margin-top-sm am-hide" >
		<label class="am-u-sm-3 am-form-label" style="text-align:right;">二维码位置和大小(x,y,w,h)</label>

		<div class="am-u-sm-9 ">
			<input id="id_position_x" class="am-u-sm-2 am-margin-right-sm" value="<?php echo (empty($qp['photo_info']['xcxcode']['x'])?'0':$qp['photo_info']['xcxcode']['x'])?>">
			<input id="id_position_y" class="am-u-sm-2 am-margin-right-sm" value="<?php echo (empty($qp['photo_info']['xcxcode']['y'])?'0':$qp['photo_info']['xcxcode']['y'])?>">
			<input id="id_position_w" class="am-u-sm-2 am-margin-right-sm" value="<?php echo (empty($qp['photo_info']['xcxcode']['w'])?'0':$qp['photo_info']['xcxcode']['w'])?>">
			<input id="id_position_h" class="am-u-sm-2 am-margin-right-sm am-u-end " value="<?php echo (empty($qp['photo_info']['xcxcode']['h'])?'0':$qp['photo_info']['xcxcode']['h'])?>">
		</div>

	</div>

	<div class="am-g am-margin-sm " id="parent">
		<label class="am-u-sm-3 am-form-label"></label>
		<button type="submit" class="am-btn am-btn-primary" id="save-btn">
			保存修改
		</button>
	</div>
</div>
	<img style="display: none" class="justforselect" src="<?php echo((empty($qp['photo_info']['img_url'])?'':$qp['photo_info']['img_url']));?>"/>

	<script type="text/javascript">
		var g_qp = <?php echo (!empty($qp) ? json_encode($qp) : "null") ?>;
		var g_uid = <?php echo (!empty($qp['uid']) ? $qp['uid'] : "0") ?>;
	</script>

	<?php
	$extra_js = array(
		'/app/sp/static/js/jquery.Jcrop.js',
		'/static/js/jscolor.js',
		$static_path . '/js/photoset.js',
	);
	?>

	<script>
		seajs.use(['selectPic']);
	</script>

</body>




