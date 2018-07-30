<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8">
		<meta charset="UTF-8">
		<meta name="renderer" content="webkit">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta content="微信小程序,小程序开发,微信小程序,微信小程序,微信小程序开发,小程序" name="keywords">
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
							<i class="iconfont icon-zhongzhimima"></i>
							<h2>找回密码</h2>
							<p></p>
							<a href="?_a=sp&_u=index.login&_spv3=1" class="fr rLoginBtn">登录 <i class="iconfont icon-enterinto_fill"></i></a>
						</div>
					</div>
					<div class="regBox">
					  <form id="form_login" class="login-form" action="" method="post">
						<ul>
							<li>
								<p class="rName linghtColor">输入图形验证码</p>
								<input maxlength="6" name="verify" id="verify" class="rinput verify" type="text">
								<img class="verifyimg reloadverify" title="点击切换" alt="点击切换" src="/?_a=sp&_u=index.verifycode">
							</li>
							<li>
								<p class="rName linghtColor">手机号码</p>
								<input maxlength="11" id="inputMobile" name="mobile" class="rinput mobile" type="tel">
								<button class="getCode" id="btn_sms">获取验证码</button>
							</li>
							<li>
								<p class="rName linghtColor">请输入短信验证码</p>
								<input name="sms_verify" class="rinput" type="text">
								<p class="tips" style="">5位数字</p>
							</li>
							<li>
								<button class="sumbitBtn">下一步</button>
							</li>
						</ul>
					</form>
						
						<div class="errorMess" id="Validform_checktip2" style="display:none;">
							<i class="iconfont icon-prompt_fill"></i> 
						</div>
					</div>
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
				
			})

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
			   		$("#Validform_checktip2").html('<i class="iconfont icon-prompt_fill"></i>请输入手机号码！');
			   		$("#Validform_checktip2").attr('style','');
			   		setTimeout(function(){
			   		$("#Validform_checktip2").slideUp();
                    },2000);
			   		return false;
			   	}
			   	var self = $('#form_login');
				$.post(self.attr("action"), {sms:"send",mobile:mobile,verify:verify}, success, "json");
				return false;
				
				function success(data){
						console.dir(data);
		    			if(data.status){
		    				time_clock.init(document.getElementById("btn_sms"));
		    			} else {
		    				$("#Validform_checktip2").html('<i class="iconfont icon-prompt_fill"></i>'+data.info);
					   		$("#Validform_checktip2").attr('style','');
					   		setTimeout(function(){
					   		$("#Validform_checktip2").slideUp();
		                    },2000);
		                    $(".reloadverify").click();
		    			}
		    	}

			});
			$("#form_login").submit(function(){
			//console.log('a');
			var self = $(this);
			$.post(self.attr("action"), self.serialize(), success, "json");
			return false;
			function success(data){
				if(data.status){
					window.location.href = data.url;							
				} else {
					$("#Validform_checktip2").html('<i class="iconfont icon-prompt_fill"></i>'+data.info);
			   		$("#Validform_checktip2").attr('style','');
			   		setTimeout(function(){
			   		$("#Validform_checktip2").slideUp();
                    },2000);
					//刷新验证码
					$(".reloadverify").click();
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
	
