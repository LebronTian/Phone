<!DOCTYPE html>
<html>

	<head>
		<meta http-equiv=Content-Type content="text/html;charset=utf-8">
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="apple-mobile-web-app-status-bar-style" content="black">
		<meta name="format-detection" content="telephone=no">
		<script>
			window.scale = 1;
			if(window.devicePixelRatio === 2 && window.navigator.appVersion.match(/iphone/gi)) {
				//scale = 0.5;
			}
			var text = '<meta name="viewport" content="initial-scale=' + scale + ', maximum-scale=' + scale + ', minimum-scale=' + scale + ', user-scalable=no" />';
			document.write(text);
		</script>
		<title>个人中心</title>
		<script src="/static/js/jquery2.1.min.js"></script>
		<script src="/static/js/geo.js"></script>
		<link rel="stylesheet" href="/static/css/weui1.0.2.css" />
		<style>
			.wx_body {
				margin-left: auto;
				margin-right: auto;
				max-width: 640px
			}
			.more_link {
				display: block;
				margin: 20px 10px 20px;
				line-height: 44px;
				background-color: #f2f2f2;
				font-size: 17px;
				color: #000;
				text-align: center
			}
			
			.fix_more_link .more_link {
				position: fixed;
				bottom: 20px;
				left: 10px;
				right: 10px;
				margin: 0
			}
			
			.wap_shop_module_list {
				overflow: hidden
			}
			
			.shop_module_item {
				position: relative;
				margin: 0 10px 10px
			}
			
			.shop_module_item.shop_module_banner {
				margin-left: 0;
				margin-right: 0;
				margin-bottom: 35px
			}
			
			.shop_module_item.shop_module_banner:first-child {
				margin-top: 0
			}
			
			.shop_module_item.shop_module_floor {
				margin-top: 20px;
				margin-bottom: 20px
			}
			
			.shop_module_item .goods_link {
				display: block;
				color: #000;
				font-size: 0
			}
			
			.shop_module_item .shop_modele_mask {
				display: none
			}
			
			.shop_module_item:first-child {
				margin-top: 10px
			}
			
			.shop_module_item .sub_price {
				display: inline-block;
				vertical-align: bottom;
				text-decoration: line-through;
				color: #999;
				font-size: 13px;
				margin-left: 5px
			}
			
			.shop_module_hd h4 {
				font-weight: 400;
				font-style: normal;
				font-size: 18px
			}
			
			.shop_module_hd a {
				display: block;
				position: relative;
				color: #000
			}
			
			.shop_module_hd .icon_arrow {
				position: absolute;
				right: 12px;
				top: 9px;
				width: 7px;
				height: 7px;
				border-color: #c7c7cc;
				border-style: solid;
				border-width: 2px 2px 0 0;
				-webkit-transform: rotate(45deg)
			}
			
			.pic_mask {
				display: none;
				position: absolute;
				top: 0;
				left: 0;
				width: 100%;
				height: 100%
			}
			
			.shop_module_banner {
				height: 150px
			}
			
			.shop_module_banner .banner_bg {
				display: block;
				height: 100%;
				overflow: hidden
			}
			
			.shop_module_banner .banner_pic {
				width: 100%;
				height: 100%
			}
			
			.shop_module_banner .banner_logo {
				position: absolute;
				bottom: -20px;
				left: 10px;
				width: 68px;
				height: 68px;
				background-color: #fff;
				padding: 3px;
				border-radius: 50%;
				-moz-border-radius: 50%;
				-webkit-border-radius: 50%;
				box-shadow: 0 .5px 1px 0 rgba(0, 0, 0, 0.6);
				-moz-box-shadow: 0 0.5px 1px 0 rgba(0, 0, 0, 0.6);
				-webkit-box-shadow: 0 0.5px 1px 0 rgba(0, 0, 0, 0.6);
				overflow: hidden;
			}
			
			.shop_module_banner .banner_logo img {
				width: 100%;
				height: 100%;
				border-radius: 50%;
				-moz-border-radius: 50%;
				-webkit-border-radius: 50%;
				background-color: #eee
			}
			
			.shop_module_banner .shop_banner_title {
				position: absolute;
				z-index: 1;
				bottom: -10px;
				left: 95px;
				font-size: 18px;
				color: #fff;
				text-shadow: 0 1px 0 rgba(0, 0, 0, 0.7)
			}
			
			.shop_module_banner .pic_mask {
				display: block;
				background-repeat: repeat-x;
				width: 100%;
				height: 45px;
				bottom: 0;
				left: 0;
				top: auto;
				filter: none
			}
			#up_avatar{
				font-weight: normal;
				font-size: 13px;
				line-height: 26px;
				background: rgb(230,67,64);
				border-radius: 5px;
				text-align: center;
				cursor: pointer;
				color: #fff;
				visibility:hidden;
			}
			#address_show{
				display: none;
			}
		</style>
	</head>

	<body>
		<div class="wx_page weui_tab">
			<div class="wx_body weui_tab_bd">
				<div class="wap_shop_module_list">
							<div class="shop_module_item shop_module_banner js_shopModuleWrapper" data-moduletype="banner" name="banner">
								<strong class="shop_banner_title" id="js_title"><?php echo $su['name'] ? $su['name'] : $su['account'];?><p id="up_avatar">点击保存头像</p></strong>
								<span class="banner_logo" id="id_avatar"><img src="<?php echo $su['avatar'] ? $su['avatar'] : '/static/images/null_avatar.png';?>"alt=""id="js_logo"></span>


								<span class="banner_bg"><img src="/app/reminder/view/v1/static/image/jnr.jpg" class="banner_pic" id="js_banner"></span>
								<div class="pic_mask"></div>
								<div class="shop_modele_mask"><span class="vm_box"></span>
									<a href="javascript:;" class="icon18_common edit_gray js_edit"></a>
								</div>
							</div>

							<div class="weui_cells" style="margin-bottom:60px;">
								<div class="weui-cell">
									<div class="weui-cell__hd"><label class="weui-label">真实姓名:</label></div>
									<div class="weui-cell__bd">
										<input id="id_realname" class="weui-input" placeholder="请输入姓名" <?php if(!empty($profile[ 'realname'])) echo ' value="'.$profile[ 'realname']. '"';?>>
									</div>
								</div>
								<div class="weui-cell">
									<div class="weui-cell__hd"><label class="weui-label">手机号码:</label></div>
									<div class="weui-cell__bd">
										<input id="id_phone" class="weui-input" placeholder="请输入提醒号码" <?php if(!empty($profile[ 'phone'])) echo ' value="'.$profile[ 'phone']. '"';?>>
									</div>
								</div>
								<div class="weui-cell">
									<div class="weui-cell__hd"><label class="weui-label"> &nbsp;邮 箱 &nbsp;:</label></div>
									<div class="weui-cell__bd">
										<input id="id_email" class="weui-input" placeholder="请输入邮箱" <?php if(!empty($profile[ 'email'])) echo ' value="'.$profile[ 'email']. '"';?>>
									</div>
								</div>
								<div class="weui-cell">
									<div class="weui-cell__hd"><label class="weui-label">所 在 地:</label></div>
									<div class="weui-cell__bd">
										<form name="shareip" action="" method="post"  id="address_show">
											<select class="select" name="province" id="s1">
												<option></option>
											</select>
											<select class="select" name="city" id="s2">
												<option></option>
											</select>
											<select class="select" name="town" id="s3">
												<option></option>
											</select>
											
											<input id="tip" name="address" type="hidden" value="" />
										</form>
										<input id="id_address" class="weui-input" placeholder="请添加信息" <?php if(!empty($profile['address'])) echo ' value="'.$profile['address']. '"';?>>
									</div>
								</div>
								
			
								<div class="weui-cell">
									<div class="weui-cell__hd"><label class="weui-label">个人简介:</label></div>
									<div class="weui-cell__bd">
										<input id="id_brief" class="weui-input" placeholder="" <?php if(!empty($profile['brief'])) echo ' value="'.$profile['brief']. '"';?>>
									</div>
								</div>
							</div>
							<div style="margin-top:20px;margin-bottom:40px;">
							<!-- 	<div class="weui-cell">
									<a style="text-align:center;color:red;width:100%;" href="?_a=reminder&_u=index.welcome">点我关注公众号, 可通过微信消息提醒</a>
								</div> -->
								<a class="weui-btn weui-btn_warn" id="id_m">修改资料</a>
							</div>

				</div>
			</div>
		</div>

		<div id="toast" style="display: none;">
			<div class="weui-mask_transparent"></div>
			<div class="weui-toast">
				<i class="weui-icon-success-no-circle weui-icon_toast"></i>
				<p class="weui-toast__content">设置成功</p>
			</div>
		</div>

<div class="weui-footer" style="position:fixed;z-index:9;margin:0 auto;bottom:5px;width:100%;text-align:center;">
	<a href="http://weixin.uctphp.com">© 深圳市快马加鞭科技有限公司</a>
</div>


			<script src="/static/js/plupload.full.min.js" type="text/javascript" charset="utf-8"></script>
		<script>
		setup();
		preselect('<?php if(!empty($profile[ 'province'])) echo ''.$profile[ 'province']. '';?>');
		promptinfo();
		
	var uploader = new plupload.Uploader({ //实例化一个plupload上传对象
		browse_button: 'id_avatar',
		url: '?_a=upload&_u=index.upload',
	});
	uploader.init(); //初始化

	//绑定文件上传后触发
	uploader.bind('FileUploaded', function(uploader, file, responseObject) {
		var res = $.parseJSON(responseObject.response);
		if(res && res.data.url != "" || res && res.data.url != null) {
			$('#js_logo').attr('src', res.data.url);
		} else {
			alert('无');
		}
	});
	
	//选择文件后触发
	uploader.bind('FilesAdded', function(uploader, files) {
		uploader.start();
		$('#up_avatar').css('visibility','visible')
	});
	
	$('#id_address').click(function() {
		$('#id_address').css('display','none');
		var $address_show =$('#address_show');
		$address_show.fadeIn();
	});

	//上传按钮
	$('#id_m').click(function() {
		uploader.start(); //开始上传
	});

	$('#id_m').click(function() {
				var phone = document.getElementById('id_phone').value;
				if(phone && !(/^1[34578]\d{9}$/.test(phone))) {
					alert("手机号码有误，请重填");
					return false;
				}
				var data = {
					'realname': $('#id_realname').val(),
					'phone': $('#id_phone').val(),
					'email': $('#id_email').val(),
					'brief': $('#id_brief').val(),
					'province':$('#s1').val(),
					'city':$('#s2').val(),
					'town':$('#s3').val(),
					'address':$('#tip').val()
				};
				$.post('?_a=su&_u=ajax.update_su_profile', data, function(ret) {
					ret = $.parseJSON(ret);
					if(ret && ret.errno == 0) {
						var $toast = $('#toast');
						$toast.fadeIn(100);
						setTimeout(function() {
							$toast.fadeOut(100);
						}, 2000);
					} else {
						alert('操作失败！' + ret.errstr);
					}
					});

					
				});
				
	$('#up_avatar').click(function(){
		var data2 = {
						'avatar': $('#js_logo').attr('src')
					};
					$.post('?_a=su&_u=ajax.update_su', data2, function(ret) {
						ret = $.parseJSON(ret);
						if(ret && ret.errno == 0) {
						var $toast = $('#toast');
						$toast.fadeIn(100);
						setTimeout(function() {
							$toast.fadeOut(100);
						}, 2000);
					} else {
						alert('操作失败！' + ret.errstr);
					}
					});
	});
</script>
	</body>

</html>
