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
		<style type="text/css">
			div{
				box-sizing: border-box;
			}
		</style>
	</head>

	<body>
		<div class="mtable">
			<div class="mtd">
				<!--reg start-->
				<div class="main reg">
					<div class="regTit">
						<div>
							<i class="iconfont icon-people_fill"></i>
							<h2>注册小程序生成平台帐号</h2>
							<p></p>
							<a href="?_a=sp&_u=index.login&_spv3=1" class="fr rLoginBtn">已注册？立即登录 <i class="iconfont icon-enterinto_fill"></i></a>
						</div>
					</div>
					<form id="form_register" action="" method="post">
					<div class="regBox">
						<ul>
							<li style="display:none;">
								<p class="rName linghtColor">用户名</p>
								<input name="r_username" class="rinput" type="text">
								<p class="tips" style="">6~16位的数字、字母等字符</p>
							</li>
							<li>
								<p class="rName linghtColor">手机号码</p>
								<input maxlength="11" id="inputMobile" name="mobile" class="rinput mobile" type="tel">
								<button class="getCode" id="btn_sms">获取验证码</button>
							</li>
							<li>
								<p class="rName linghtColor">请输入短信验证码</p>
								<input id="id_mobilecode" name="sms_verify" class="rinput" type="text">
								<p class="tips" style="">6位数字</p>
							</li>
							<li style="display:none1;">
								<p class="rName linghtColor">密码</p>
								<input id="id_passwd" name="r_password" class="rinput" type="password">
								<p class="tips" style="">6~30位的数字、字母等字符</p>
							</li>
							<li style="display:none1;">
								<p class="rName linghtColor">确认密码</p>
								<input id="id_repasswd" name="repassword" class="rinput" type="password">
								<p class="tips" style="">再次输入密码</p>
							</li>
							<li style="display:none;">
								<p class="rName linghtColor">联系人</p>
								<input class="rinput" name="truename" type="text">
								<p class="tips" style="">请输入真实姓名</p>
							</li>
							<li style="display:none;">
								<p class="rName linghtColor">邮箱</p>
								<input class="rinput" name="email" type="email">
								<p class="tips" style="">请输入有效邮箱</p>
							</li>
							<li>
								<p class="rName linghtColor">输入图形验证码</p>
								<input maxlength="6" class="rinput verify" name="verify" id="verify" type="text">
								<img class="verifyimg reloadverify" title="点击切换" alt="点击切换" src="/?_a=sp&_u=index.verifycode">
							</li>
							<input class="input" placeholder="代理商ID" name="agent_id" value="800100" type="hidden">							<li>
								<button class="sumbitBtn">注 册</button>
							</li>
						</ul>
						
						<div class="errorMess" id="tip" style="display:none;">
							<i class="iconfont icon-prompt_fill"></i> 
						</div>
					</div>
					</form>
				</div>
				<!--reg end-->
				
			</div>
		</div>
		
		<script>
			$(function(){
				
				var regForm = $(".rinput");
				regForm.val('');
				regForm.each(function(){
					$(this).prev("p").click(function(){
						$(this).next("input").focus();
					})
					$(this).focus(function(){
						$(this).parents("li").addClass("active");
						$(this).addClass("active");	
					})
					$(this).blur(function(){
						if($(this).val() == ""){
							$(this).parents("li").removeClass("active");
							$(this).removeClass("active");	
						}
					})
					
					if($(this).next("p").val() == ""){
						$(this).next("p").css("display","0");
					}
				})


				
			});
			
			  
			$(function(){

				   var time_clock = {
			       node:null,
			       count:60,
			       start:function(){
			          if(this.count > 0){
			             this.node.innerText = this.count--;
			             var _this = this;
			             setTimeout(function(){
			                 _this.start();
			             },1000);
			          }else{
			             this.node.removeAttribute("disabled");
			             this.node.innerText = "再次发送";
			             this.count = 60;
			          }
			       },
			       //初始化
			       init:function(node){
			          this.node = node;
			          this.node.setAttribute("disabled",true);
			          this.start();
			       }
			 };

			 $("#btn_sms").click(function(){
			   	var mobile=$("#inputMobile").val();
			   	var verify=$("#verify").val();
			   	if(mobile==""){
			   		$("#tip").html('<i class="iconfont icon-prompt_fill"></i>请输入手机号码！');
			   		$("#tip").attr('style','');
			   		setTimeout(function(){
			   		$("#tip").slideUp();
                    },2000);
			   		return false;
			   	}
			   	var self = $('#form_register');
				$.post('?_a=sp&_u=api.mobilecode', {phone:mobile, verify:verify}, success, "json");
				return false;
				
				function success(data){
						console.dir(data);
		    			if(data.data){
		    				time_clock.init(document.getElementById("btn_sms"));
		    			} else {
		    				$("#tip").html('<i class="iconfont icon-prompt_fill"></i>'+data.info);
					   		$("#tip").attr('style','');
					   		setTimeout(function(){
					   		$("#tip").slideUp();
		                    },2000);
		                    //$(".reloadverify").click();
		    			}
		    	}

			});

			$("#form_register").submit(function(){
			//console.log('a');
			
			var phone=$("#inputMobile").val();
			var verify=$("#verify").val();
			var mobilecode=$("#id_mobilecode").val();
			var passwd=$("#id_passwd").val();
			if(!phone || !verify || !mobilecode || !passwd) {
				return alert('请填写完整内容！');
			}
			if(passwd != $('#id_repasswd').val()) {
				return alert('密码输入不一致！');
			}

			var data = {account: phone, password: passwd, verifycode: verify, mobilecode: mobilecode};
			var self = $(this);
			$.post('?_a=sp&_u=api.register_test', data, success, "json");
			return false;
			function success(data){
				console.log('success ');
				if(data.data && data.data.uid){
					window.location.href = data.data.url || '?_a=sp';							
				} else {
					$("#tip").html('<i class="iconfont icon-prompt_fill"></i>'+data.data.errstr);
			   		$("#tip").attr('style','');
			   		setTimeout(function(){
			   		$("#tip").slideUp();
                    },2000);
					//刷新验证码
					//$(".reloadverify").click();
				}
			}

			});
		});


		$(function(){
			var verifyimg = $(".verifyimg").attr("src");
		    $(".reloadverify").click(function(){
		        if( verifyimg.indexOf('?')>0){
		            $(".verifyimg").attr("src", verifyimg+'&random='+Math.random());
		        }else{
		            $(".verifyimg").attr("src", verifyimg.replace(/\?.*$/,'')+'?'+Math.random());
		        }
		    });
		});
		</script>
	
</body></html>
