<?php
$sp_uid = $vip_card_sp_set['sp_uid'];
$ret=WeixinMod::get_current_weixin_public();
if($ret['has_verified'] && $ret['public_type']==2 )
{
	$exit=true;
}
else
{
	$exit=false;
}

uct_use_app('su');
//判断有没有su_uid：
if (!($su_uid = requestInt('su_uid')) )
{
	//没有：取现在用户的su_uid
	($su_uid = SuMod::require_su_uid($exit));

	if($su_uid==0){
		//0代表取不到，取不到代表没有关注//在前端判断处理
		echo '错误，没有登陆信息';
	}
	// 根据su_uid取用户信息
	$vip_card_info = VipcardMod::get_vip_card_info($su_uid,$sp_uid);

	//根据信息里面的su_uid判断有没有会员卡
	if(!empty($vip_card_info['vip_card_su']['su_uid']) && !empty($vip_card_info['vip_card_su']['card_url']) ){
		//有的话也重定向去result看自己的
		redirectTo('?_a=vipcard&_u=index.index&su_uid='.$su_uid);
	}
}
else{
	//有：
	$vip_card_info = VipcardMod::get_vip_card_info($su_uid,$sp_uid);//取会员卡资料
	$pt = SuPointMod::get_user_points_by_su_uid($su_uid);
}


?>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-COMPATIBLE" content="chrome=1,IE=Edge">
	<!--优先谷歌内核，最新ie-->
	<meta name="format-detection" content="telephone=no,email=no,address=no">
	<!--不识别电话邮箱地址-->
	<meta http-equiv="Cache-Control" content="no-siteapp">
	<!--不转码-->
	<!-- Mobile Devices Support @begin 使手机上比例正常-->
	<meta name="viewport"
		  content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
	<!--文档宽度与设备宽度1：1 不允许缩放 -->
	<!-- apple devices -->
	<meta name="apple-mobile-web-app-capable" content="yes"/>
	<!-- wabapp程序支持 -->
	<meta name="apple-mobile-web-app-status-bar-style" content="white"/>
	<!-- 顶端状态条 -->
	<meta name="apple-touch-fullscreen" content="yes">
	<!--全屏显示 -->
	<!-- Mobile Devices Support @end -->
	<title><?php echo (empty($vip_card_sp_set['title'])?'':$vip_card_sp_set['title']) ?></title>
	<!--<link rel="shortcut icon" href="<?php /*echo $static_path . '/images/logo.png' */?>" type="image/x-icon">-->

	<link rel="stylesheet" href="<?php echo $static_path . '/css/style.css' ?>">
	<link rel="stylesheet" href="<?php echo $static_path . '/css/index.css' ?>">
	<style>
		.status-text{font-size: 1.5rem}
		/*flex左右*/
		.flex-left-right{
			display: -webkit-box;
			display: -webkit-flex;
			display: -ms-flexbox;
			display: flex;
			-webkit-box-align: center;
			-webkit-align-items: center;
			-ms-flex-align: center;
			align-items: center;
		}
		.flex-left{
			height: 100%;
			line-height: 3em;
			text-align: right;
			color: #808080;
		}
		.flex-right{
			border: none;
			padding: 1em;
			margin-left: 1em;
			background: none;
			-webkit-box-flex: 1;
			-webkit-flex: 1;
			-ms-flex: 1;
			flex: 1;
		}
		/*积分和余额*/
		.more-info{  border-top:1px solid #ddd;  border-bottom:1px solid #ddd;  color:#666666  }
		.more-info li{  padding: 0.5em 0;  border-right: thin solid #ddd;  }
		.more-info li:last-child{  border-right: none;  }
		.more-info .info-brief{  width: 10em;  margin:0 auto;  text-align: center;  }
		.more-info .info-value{  margin-top: 0.5em;  font-size: 1.5em;  }
	</style>
</head>
<body>
<!--todo--------------------------------------------------------------------------start-->
<!--表单页-start-->
<div class="form-content div-content">

	<div class="vipcard-demo">
		<img class="vipcard-background" src="<?php
		/*判断有没有卡*/
		if(
				!empty($vip_card_info['vip_card_su']['su_uid'])
				&& !empty($vip_card_info['vip_card_su']['card_url'])
				&& ($vip_card_info['vip_card_su']['status']==0)
		){
			echo $vip_card_info['vip_card_su']['card_url'];
		}
		else{
			echo $vip_card_sp_set['ui_set']['back_ground']['path'];
		}
		?>">

		<span class="status-text" onclick="window.location.reload()"><?php
		if(!empty($vip_card_info['vip_card_su']['status']) && ($vip_card_info['vip_card_su']['status']==1)){
			echo '等待审核中';
		}
		if(!empty($vip_card_info['vip_card_su']['status']) && ($vip_card_info['vip_card_su']['status']==2)){
			echo '暂不满足加入条件';
		}
		?></span>
	</div>
	<?php
	if(!empty($pt) && ($vip_card_info['vip_card_su']['status']==0)){
		?>
		<div class="more-info display-table">
			<ul>
				<li onclick="window.location.href='?_easy=vipcard.single.index.point'">
					<div class="info-brief">
						<p class="info-title">我的积分</p>
						<p class="info-value" style="color: #5eb95e;">
							<?php echo((!empty($pt['point_remain']))?$pt['point_remain']:0)?>
						</p>
					</div>
				</li>
				<li onclick="window.location.href='?_easy=vipcard.single.index.cash'">
					<div class="info-brief">
						<p class="info-title">我的余额</p>
						<p class="info-value" style="color: #F37B1D;">
							￥<?php if(isset($pt['cash_remain'])) echo sprintf('%.2f',($pt['cash_remain']/100)) ?>
						</p>
					</div>
				</li>
			</ul>
		</div>
	<?php
	}
	?>
	<div class="form-box">
		<?php
		$html = '';
		if (!empty($vip_card_sp_set['connent']))
		{
			$i = 0;
			foreach ($vip_card_sp_set['connent'] as $ck => $c)
			{
				if (!empty($c['protect']))
				{
					$i++;
					continue;
				}
				if ($ck == 'avatar')
				{
					/**/
				}
				else
				{
					$value = (empty($vip_card_info['vip_card_su']['connent'][$i]['value']) ? '' : $vip_card_info['vip_card_su']['connent'][$i]['value']);

					$html .= '
                <section class="flex-left-right">
                <span class="flex-left "><span>' . $c['title'] . '</span></span>
				<input class="flex-right vipcard-input" type="text"
						data-type="' . $ck . '"
						data-need="' . $c['need'] . '"
						data-group="' . $c['group'] . '"
		        		value="' . (empty($c['value']) ? $value : $c['value']) . '"
		        		placeholder="'.(empty($c['placeholder'])?'':$c['placeholder']).'"
		        		'.((!empty($vip_card_info['vip_card_su']['su_uid']) && !empty($vip_card_info['vip_card_su']['card_url']))?'readonly':'').' >
		        </section>';
				}
				$i++;
			}
		}
		echo $html;

		?>
	</div>
	<p>
		<?php
		//当无会员卡或未审核 可以修改会员申请信息
		if(empty($vip_card_info['vip_card_su']['su_uid'])
				|| ($vip_card_info['vip_card_su']['status']==1)
		){
			/**/
			?>
			<button class="simple-bottom-btn form-next-button">领取我的会员卡</button>
			<?php
		}
		?>
	</p>
</div>
<div class="loading-box">
	<img src="<?php echo $static_path . '/images/waiting2.png' ?>"/>
	<p style="font-size:20px" class="index-vipcard-describe">正在提交，请稍候。</p>
</div>
<!--表单页-end-->
<!--todo----------------------------------------------------------------------------end-->
<script src="/static/js/jquery2.1.min.js"></script>
<script src="/static/js/plupload.full.min.js"></script>
<script>
	$(document).ready(function () {
		/*左边设置统一最宽*/
		var max_width = 0;
		$('.form-box .flex-left').each(function () {
			var width = $(this).width();
			max_width = (max_width<width)?width:max_width
		}).width(max_width);
		/**/

		var window_height = $(window).height();
		$("body").css("min-height", window_height);


		/*初始化上传按钮*/
		var uploader_img = new plupload.Uploader({
			browse_button: "uploadBtn", // you can pass an id...
			url: '?_a=upload&_u=index.upload&type=1',
			filters: {
				mime_types: [
					{title: "Image files", extensions: "jpg,gif,png,bmp"}
				]
			},
			init: {
				PostInit: function (ret) {
					//console.log("Post", ret)
				},
				FilesAdded: function (up, files) {
					uploader_img.start();
					plupload.each(files, function (file) {
					});
				},
				FileUploaded: function (up, files, res) {
					res = JSON.parse(res.response); //PHP上传成功后返回的参数
					console.log(res);

					if(res.data.url){
						$("#uploadBtn").addClass("card-user-pic").attr("src", res.data.url);
						$(".special-input-avatar").val(res.data.url);
					}
					else{
						alert('上传失败，请确认上传的是：0-1mb的jpg,gif,png,bmp格式的文件，错误码：'+res.errno)
					}
					/*plupload.each(files, function (file) {
					 });*/
				},
				UploadProgress: function (up, file) {
//					console.log("Progress",up,file);
					$('#uploadBtn').attr('alt',file.percent+'%');

//					$('.form-title').text(file.percent+'%')


				},
				UploadComplete: function (up, file) {
				},
				Error: function (up, error) {
					var alert_text = '';
					switch (error.code){
						case (-100):
							alert_text='通用错误，请稍后再试';
							return;
						case (-200):
							alert_text='网络错误，请稍后再试';
							return;
						case (-300):
							alert_text='保密协议输入输出错误，请稍后再试';
							return;
						case (-400):
							alert_text='安全错误，请稍后再试';
							return;
						case (-500):
							alert_text='初始化，请稍后再试';
							return;
						case (-600):
							alert_text='图片大小范围在0-1mb内';
							return;
						case (-601):
							alert_text='图片格式不符合要求，请上传jpg,gif,png,bmp格式文件';
							return;
						case (-602):
							alert_text='文件复制错误，请稍后再试';
							return;
						case (-700):
							alert_text='图像格式错误，请稍后再试';
							return;
						case (-701):
							alert_text='内存错误，请稍后再试';
							return;
						case (-702):
							alert_text='图像尺寸误差，请稍后再试';
							return;
						default :
							alert_text='上传失败，未知错误:' + error.code;
					}
					alert(alert_text)
				}
			}
		});
		uploader_img.init();

		$(".form-next-button").click(function () {
			var form_data = {};
			var status = false;
			$(".form-box").find(".vipcard-input").each(function () {
				var type = $(this).data("type");
				var group = $(this).data("group");
				var need = $(this).data("need");
				var val = $(this).val();

				if (need && (val == "")) {
					var text = $(this).siblings().children("span").text();
					alert(text + "不能为空");
					status = true;
					return false
				}

				//if(group=="vip_card_su"){
				//    if(form_data['vip_card_su'] ==undefined) form_data['vip_card_su']={};
				//    if(form_data['vip_card_su'][group] ==undefined) form_data['vip_card_su'][group]={};
				//    form_data['vip_card_su'][group][type] = val;
				//}
				//else{
				if (form_data[group] == undefined) form_data[group] = {};
				form_data[group][type] = val;
				//}
			});
			if (status) return;

			console.log(form_data);
			var real_data = {
				vip_card_info: form_data
			};
			$(".loading-box").show();
			$.post("?_a=vipcard&_u=ajax.edit_vip_card", real_data, function (ret) {
				console.log(ret);
				ret = $.parseJSON(ret);
				if (ret.errno == 0) {
					window.location.reload()
				}
				else alert('提交失败');
			});
		});


	});

</script>
</body>
</html>