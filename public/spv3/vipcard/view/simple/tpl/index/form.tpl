<?php
$sp_uid = $vip_card_sp_set['sp_uid'];
$su_uid = requestInt('su_uid');

$vip_card_info = VipcardMod::get_vip_card_info($su_uid,$sp_uid);
// var_dump($vip_card_info);
//根据信息里面的su_uid判断有没有会员卡
// if(!empty($vip_card_info['vip_card_su']['su_uid'])){
//有的话也重定向去result,看自己的
// redirectTo('?_a=vipcard&_u=index.result&su_uid='.$vip_card_info['vip_card_su']['su_uid']);
// }

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
	<title>GirlsGroup</title>
	<link rel="shortcut icon" href="<?php echo $static_path . '/images/logo.png' ?>" type="image/x-icon">

	<link rel="stylesheet" href="<?php echo $static_path . '/css/style.css' ?>">
	<link rel="stylesheet" href="<?php echo $static_path . '/css/index.css' ?>">
</head>
<body>
<!--todo--------------------------------------------------------------------------start-->
<!--表单页-start-->
<div class="form-content div-content">
	<?php
	if(!empty($vip_card_sp_set['ui_set']['back_ground'])){

		$bg = $vip_card_sp_set['ui_set']['back_ground'];
		$avatar = $vip_card_sp_set['ui_set']['image']['0'];
		$logo = $vip_card_sp_set['ui_set']['image']['logo'];

		function changePiToPercentage($arr_bg,$arr_img){
			$x = $arr_img[0]/$arr_bg[0]*100;
			$y = $arr_img[1]/$arr_bg[1]*100;
			return array('0' => $x, '1' =>$y);
		}
		$avatar_point = changePiToPercentage($bg['size'],$avatar['point']);
		$avatar_size = $avatar['size'];
		$logo_point = changePiToPercentage($bg['size'],$logo['point']);
		$logo_size = $logo['size'];
	}
	?>



	<div class="vipcard-demo">
		<img class="vipcard-background" src="<?php if(!empty($vip_card_sp_set['ui_set']['back_ground']['path'])) echo $vip_card_sp_set['ui_set']['back_ground']['path'] ?>">

		<?php
		if(!empty($vip_card_sp_set['ui_set']['image']['logo']['path'])){
			?>
			<div class="vipcard-logo"
				 style="left:<?php echo $logo_point[0] ?>%;
						 top:<?php echo $logo_point[1] ?>%;
						 width:40px;
						 height: 40px;
						 ">
				<img class="vipcard-logo-img" src="<?php echo $vip_card_sp_set['ui_set']['image']['logo']['path'] ?>"
					 style="width:100%;height:100%;">
			</div>
			<?php
		}
		?>

		<div class="vipcard-avatar"
			 style="left: <?php echo $avatar_point[0] ?>%;
					 top:<?php echo $avatar_point[1] ?>%;
					 width:<?php echo $avatar_size[0] ?>px;
					 height: <?php echo $avatar_size[1] ?>px;
					 ">
			<img class="vipcard-avatar-img" id="uploadBtn" src=""
				 alt="点击上传头像"
			>
		</div>


	</div>


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
					$value = (empty($vip_card_info['vip_card_su']['connent'][$i]['value']) ? '' : $vip_card_info['vip_card_su']['connent'][$i]['value']);

					$html .= '<section style="border-bottom: none"> <span class="form-title" style="display:none;" ><span>' .
							$c['title'] . '</span></span><input class="form-input special-input-' .
							$ck . '" data-type="' . $ck . '" data-need="' . $c['need'] . '" data-group="' . $c['group'] . '"
                        type="hidden" value="' .
							//					(empty($c['value']) ?$value : $c['value']) .
							'"/></section>';
					//				$avatar = $value;
				}
				else
				{
					$value = (empty($vip_card_info['vip_card_su']['connent'][$i]['value']) ? '' : $vip_card_info['vip_card_su']['connent'][$i]['value']);

					$html .= '
                <section>
                <span class="form-title"><span>' . $c['title'] . '</span></span>
				<input class="form-input border-box" data-type="' . $ck . '" data-need="' . $c['need'] . '" data-group="' . $c['group'] . '"
		        type="text" value="' .
							//					(empty($c['value']) ? $value : $c['value']) .
							'" placeholder="'.(empty($c['placeholder'])?'':$c['placeholder']).'" />
		        </section>';
				}
				$i++;
			}
		}
		echo $html;

		?>
	</div>
	<p>
		<button class="simple-bottom-btn form-next-button">立即生成会员卡</button>
	</p>
</div>
<div class="loading-box">
	<img src="<?php echo $static_path . '/images/waiting2.png' ?>"/>
	<p style="font-size:20px" class="index-vipcard-describe">正在生成，请稍候。</p>
</div>
<!--表单页-end-->
<!--todo----------------------------------------------------------------------------end-->
<script src="/static/js/jquery2.1.min.js"></script>
<script src="/static/js/plupload.full.min.js"></script>
<script>
	var vip_card_sp_set = <?php echo(!empty($vip_card_sp_set)? json_encode($vip_card_sp_set):"null")?>;//vipcard的设置
	var vip_card_info = <?php echo(!empty($vip_card_info)? json_encode($vip_card_info):"null")?>;      //用户的信息
	var su_uid = <?php echo(!empty($su_uid)? json_encode($su_uid):"null")?>;      //用户的信息
	console.log(vip_card_sp_set, vip_card_info)
</script>
<script>
	$(document).ready(function () {

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
			$(".form-box").find(".form-input").each(function () {
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
					window.location.href = "?_a=vipcard&_u=index.result&su_uid=" + su_uid;
				}
				else alert('提交失败');
			});
		});


	});

</script>
</body>
</html>