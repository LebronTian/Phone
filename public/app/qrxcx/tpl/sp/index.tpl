<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">生成小程序二维码</strong> / <small></small></div>
</div>

<div class="am-form">
	<div class="am-cf am-padding">
		<p><span class="am-icon-info"></span>
			确认所选择的服务号AppID(应用ID)、AppSecret(应用密钥)是否正确</p>
		<p><span class="am-icon-info"></span> 路径、参数 详情看 <a target="_blank" href="http://weixin.uctphp.com/?_a=web&_u=index.problem&uid=63">文档</a></p>
	</div>
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			小程序：
		</div>
		<div class="am-u-sm-3 am-u-end">
			<select id="id_public">
				<?php
				  $title_all_public = WeixinMod::get_all_weixin_public_by_sp_uid();
					$now_public = $wx['public_name'];
					$whether_empower = $wx['access_mod'];
					$html = '';
				  foreach($title_all_public as $p){
						$html .= '<option value="'.$p['uid'].'" >'.$p['public_name'].'</option>';
				}
				echo $html;
				?>
			</select>
		</div>
	</div>
	<hr>
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2">
			&nbsp;
		</div>
		<div class="am-u-sm-6 am-u-end">
			1、生成永久有效，数量限制为10万二维码
		</div>
	</div>
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			路径+参数：
		</div>
		<div class="am-u-sm-8 am-u-end">
			<input type="text" id="id_path" value="">
		</div>
	</div>
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2">
			&nbsp;
		</div>
		<div class="am-u-sm-8 am-u-end">
			路径+参数：pages/../..?uid=...
		</div>

	</div>
	<div class="am-g am-margin-top-sm margin-top">
		<div class="am-u-sm-2 am-text-right">
			&nbsp;
		</div>
		<div class="am-u-sm-8 am-u-end" >
			<label class="am-radio am-radio-inline" style="padding-top: 0">
				<input type="radio" name="rad-status" value="0" data-am-ucheck checked>
				小程序码
			</label>
			<label class="am-radio am-radio-inline" style="margin-top: 10px">
				<input type="radio" name="rad-status" value="1" data-am-ucheck>
				小程序二维码
			</label>
		</div>
	</div>
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2">
			&nbsp;
		</div>
		<div class="am-u-sm-2 am-u-end">
			<p><button class="am-btn am-btn-lg am-btn-primary save1">立即生成</button></p>
		</div>
	</div>
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2">
			&nbsp;
		</div>
		<div class="am-u-sm-6 am-u-end">
			2、生成永久有效，数量无限制二维码
		</div>

	</div>
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			路径：
		</div>
		<div class="am-u-sm-8 am-u-end">
			<input type="text" id="id_page" value="">
		</div>
	</div>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			参数：
		</div>
		<div class="am-u-sm-8 am-u-end">
			<input type="text" placeholder="选填" id="id_val" value="">
		</div>
	</div>
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2">
			&nbsp;
		</div>
		<div class="am-u-sm-8 am-u-end">
			路径：pages/../..
			<br/>
			参数：xxx
		</div>
	</div>
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2">
			&nbsp;
		</div>
		<div class="am-u-sm-2 am-u-end">
			<p><button class="am-btn am-btn-lg am-btn-primary save2">立即生成</button></p>
		</div>
	</div>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2">
			&nbsp;
		</div>
		<div class="am-u-sm-8 am-u-end">
			微信扫一扫,访问小程序
			<br/>
			<div id="qrcode"></div>
		</div>

	</div>
</div>


<script>

	var uct_token = '<?php echo (!empty($uct_token))?$uct_token:'null' ?>';

	$('.save1').click(function(){

		var type = $('input[name="rad-status"]:checked').val();
		var public_uid = $('#id_public').val();
		var path = $('#id_path').val();
		if(!path){
			alert('路径不能为空');
			return
		}

		var encodeUrl = encodeURIComponent(path);
		$("#qrcode").append('<img style="width:150px;height:150px;" src="?_uct_token='+uct_token+'&_u=xiaochengxu.qrcode&path='+encodeUrl+'&type='+type+'&public_uid='+public_uid+'">');
	})

	$('.save2').click(function(){
		var public_uid = $('#id_public').val();
		var page = $('#id_page').val();
		var val = $('#id_val').val();
		if(!page){
			alert('路径不能为空');
			return
		}

//		var encodeUrl = encodeURIComponent(page);
		var encodeval = encodeURIComponent(val);
		$("#qrcode").append('<img style="width:150px;height:150px;" src="?_uct_token='+uct_token+'&_u=xiaochengxu.qrcode&page='+page+'&scene='+encodeval+'&public_uid='+public_uid+'">');
	})




</script>

