<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8">
		<meta charset="UTF-8">
		<meta name="renderer" content="webkit">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta content="微信小程序, 小程序开发,微信小程序,微信小程序,微信小程序开发,小程序" name="keywords">
		<link rel="shortcut icon" href="/favicon.ico">
		<title>后台管理系统</title>
		<link rel="stylesheet" href="/spv3/sp/static/css/login.css">
		<script src="/static/js/jquery2.1.min.js"></script>
		<script type="text/javascript">
			if(window.parent != window) {
				//window.parent.location.href = window.location.href;
			}
		</script>
	</head>

	<body>
		<div class="mtable">
			<div class="mtd">
				<!--login start-->
				<div class="login">
					<div class="adPic"><img src="/spv3/sp/static/images/xcxbg.png" width="100%" height="100%"></div>
					<div class="lBox">
						<a href="?_a=sp&_u=index.register&_spv3=1" class="fr lRegBtn" style="color: #ff4646;">立即免费注册 <i class="iconfont icon-enterinto_fill"></i></a>
						<h2>登 录 </h2>
						<form id="form_login" class="" action="" method="post">
							<ul>

								<li>
									<i class="iconfont linghtColor icon-people_fill"></i>
									<p class="lTips linghtColor">请输入用户名或手机号</p>
									<input class="lInput" name="account" id="username" type="text" value="">
								</li>
								<li>
									<i class="iconfont linghtColor icon-lock_fill"></i>
									<p class="lTips linghtColor">请输入密码</p>
									<input class="lInput" name="password" id="password" value="" type="password" >								
								</li>
								<li id="yanzhengma">
									<i class="iconfont linghtColor icon-yanzhengma"></i>
									<p class="lTips linghtColor">请输入验证码</p>
									<input class="lInput" name="verifycode" id="verify" type="text">
									<img class="verifyimg reloadverify" title="点击切换" alt="点击切换" src="/?_a=sp&_u=index.verifycode">
								</li>
								<li>
									<button class="sumbitBtn">登 录</button>
								</li>
							</ul>
						</form>
						<ul class="links">
							<li>
<!--
								<a href="/?_a=web" class="fr"><i class="iconfont icon-computer"></i> 返回网站首页</a>
-->
								<a href="http://www.szwlhd.com/" class="fr"><i class="iconfont icon-computer"></i> 返回网站首页</a>
								<a href="?_a=sp&_u=index.forget&_spv3=1"><i class="iconfont icon-feedback"></i> 忘记密码？</a>
							</li>
						</ul>
					</div>
				</div>
				<!--login end-->
			</div>
		</div>
		<script>
<?php
	if(empty($goto_uri)) $goto_uri = requestString('goto_uri', PATTERN_URL);
	#if(!empty(requestString('goto_uri', PATTERN_URL) || empty($goto_uri))) $goto_uri = requestString('goto_uri', PATTERN_URL);
	echo 'var g_goto_uri = '.json_encode($goto_uri).';';
?>
			$(function() {
				var loginForm = $(".lInput");
				loginForm.each(function() {
					$(this).parents("li").addClass("active");
					$(this).prev("p").click(function() {
						$(this).next("input").focus();
					})
					$(this).focus(function() {
						$(this).parents("li").addClass("active");
					})
					$(this).blur(function() {
						if($(this).val() == "") {
							$(this).parents("li").removeClass("active");
						}
					})
				})

			});

			$("#form_login").submit(function() {
				var self = $(this);
				if($("#username").val() == "") {
					$("#Validform_checktip2").html('<i class="iconfont icon-prompt_fill"></i>请输入用户名或手机号');
					$("#Validform_checktip2").attr('style', '');
					setTimeout(function() {
						$("#Validform_checktip2").slideUp();
					}, 2000);
					return false;
				}
				if($("#password").val() == "") {
					$("#Validform_checktip2").html('<i class="iconfont icon-prompt_fill"></i>请输入登录密码');
					$("#Validform_checktip2").attr('style', '');
					setTimeout(function() {
						$("#Validform_checktip2").slideUp();
					}, 2000);
					return false;
				}

				$.post(self.attr("action"), self.serialize(), success, "json");
				return false;

				function success(data) {
					console.log('login return ', data);
					var obj = data;//$.parseJSON(data);
					if(obj.errno==0) {
						//window.location.href = data.url;
						window.location.href = g_goto_uri || '?_a=sp';
					} else {
						//todo 弹出错误提示
						$("#Validform_checktip2").html('<i class="iconfont icon-prompt_fill"></i>' + data.errstr);
						$("#Validform_checktip2").attr('style', '');
						setTimeout(function() {
							$("#Validform_checktip2").slideUp();
						}, 2000);
						//刷新验证码
						$(".reloadverify").click();
					}
				}

			});

			$(function() {
				var verifyimg = $(".verifyimg").attr("src");
				$(".reloadverify").click(function() {
					if(verifyimg.indexOf('?') > 0) {
						$(".verifyimg").attr("src", verifyimg + '&random=' + Math.random());
					} else {
						$(".verifyimg").attr("src", verifyimg.replace(/\?.*$/, '') + '?' + Math.random());
					}
				});
			});

			var i = 1;
			$('.sumbitBtn').click(function() {
				i++;
				if(i > 3) {
					$('#yanzhengma').show();
					if($("#verify").val() == "") {
						$("#Validform_checktip2").html('<i class="iconfont icon-prompt_fill"></i>请输入验证码');
						$("#Validform_checktip2").attr('style', '');
						setTimeout(function() {
							$("#Validform_checktip2").slideUp();
						}, 2000);
						return false;
					}
				}
			})
		</script>

	</body>

</html>
