
$(function(){
	var times= 60;
	var timer= null;
	var code=888888;
	var phone="";
	$('input').focus(function(){
		$(this).css('border-color','#2980CD');
		$(this).next().next().find('img').css('display','none');
	})

	$('.info img').css('display','none');


	//验证手机号
	$('#phone').blur(function(){
		var reg = /^1[3|5|7|8|][0-9]{9}$/gi;
		if(!reg.test($(this).val())){
			$(this).val('');
			$(this).attr('placeholder','请输入合法手机号');
			$(this).css('border-color','#C00');
			$(this).next().next().find('img').css('display','block');
			$(this).next().next().find('img').attr('src','/app/sp/static/images/err.png');
		}else{
			$(this).css('border-color','#2980CD');
			$(this).next().next().find('img').css('display','block');
			$(this).next().next().find('img').attr('src','/app/sp/static/images/ok.png');
		}
	})

		//点击发送验证码
	$('#mobilecode_btn').click(function(){
		phone = $('#phone').val();
		var data = {phone: phone};

		//检查是否为手机号码
		var reg = /^1[3|5|7|8|][0-9]{9}$/gi;
		if(!reg.test($('#phone').val())){
			$('#phone').val('');
			$('#phone').attr('placeholder','请输入合法手机号码');
			$('#phone').css('border-color','#C00');
			$('#phone').next().next().find('img').css('display','block');
			$('#phone').next().next().find('img').attr('src','/app/sp/static/images/err.png');
			return false;
		}else{
			$('#phone').css('border-color','#CCC');
			$('#phone').next().next().find('img').css('display','block');
			$('#phone').next().next().find('img').attr('src','/app/sp/static/images/ok.png');
		}

		if(timer){
			clearInterval(timer);
			timer= null;
		}
		timer= setInterval(function(){
			times--;
			if(times<=0){
				clearInterval(timer);
				$('#mobilecode_btn').val('点击发送验证码').attr('disabled',false).css({'background':'#CBCBCB','color':'#666'});
				times= 60;
				
			}else{
				$('#mobilecode_btn').val(times+'秒后重试').attr('disabled',true).css({'background':'#DDD','color':'#AAA'});
				
			}
		},1000);
		$.post('?_a=sp&_u=api.mobilecode',data,function(obj){
		});
	})





	//验证密码
	$('#password').focus(function(){
		$(this).attr('placeholder','密码长度大于6位');
	})

	$('#password').blur(function(){
		var reg=/^(.{6,32})$/gi;
		if(!reg.test($(this).val())){
			$(this).val('');
			$(this).attr('placeholder','请输入合法密码,长度在6-32位');
			$(this).css('border-color','#C00');
			$(this).next().next().find('img').css('display','block');
			$(this).next().next().find('img').attr('src','/app/sp/static/images/err.png');
		}else{
			$(this).css('border-color','#2980CD');
			$(this).next().next().find('img').css('display','block');
			$(this).next().next().find('img').attr('src','/app/sp/static/images/ok.png');
		}
	})

	//确认密码
	$('#password2').focus(function(){
		$(this).attr('placeholder','请再次输入密码');
	})

	$('#password2').blur(function(){
		if($(this).val() != $('#password').val()){
			$(this).val('');
			$(this).attr('placeholder','两次密码输入不一致');
			$(this).css('border-color','#C00');
			$(this).next().next().find('img').css('display','block');
			$(this).next().next().find('img').attr('src','/app/sp/static/images/err.png');
		}else{
			$(this).css('border-color','#2980CD');
			$(this).next().next().find('img').css('display','block');
			$(this).next().next().find('img').attr('src','/app/sp/static/images/ok.png');
		}
	})

	$('#step_02').click(function(){
		var psd1=$('#password').val();
		var psd2=$('#password2').val();
		var code=$('#verifycode').val();
		var phone=$('#phone').val();
		if(psd1==psd2){
			var data = {
				phone:phone,
				password:psd2,
				mobilecode:code
			}
			$.post('?_a=sp&_u=api.reset_password',data,function(obj){
				obj = $.parseJSON(obj);
				console.log(obj);
				if(obj.errno==0){
					$('.login_box').eq(0).css('display','none');
					$('.login_box').eq(1).css('display','block');
				}
				else{
					return false;
				}
			})
		}

	})

	$('#step_03').click(function(){
		window.location.href="?_a=sp";
	})



})