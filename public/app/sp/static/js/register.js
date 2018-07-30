$(document).ready(function(){
	$.get('?_a=wxcode&_u=index.uct_invite_code',function(data){
		data=$.parseJSON(data);
		$('.company_code').attr('src',data.data.img_url)
	});
	$('#checkbox_btn').click(function(){
		if($(this).is(':checked')){
			$('.register_btn').attr('disabled',false);
			$('.register_btn').css('background-color','#F76A7A');
		}else{
			$('.register_btn').attr('disabled',true);
			$('.register_btn').css('background-color','#CCC');
		}
	});
})



$(function(){

	var times= 60;
	var timer= null;
	var code;

	//文本框得到焦点时
	$('input').focus(function(){
		$(this).css('border-color','#CCC');
		$(this).next().next().find('img').css('display','none');
	})

	//提示图标，默认状态隐藏
	$('.info img').css('display','none');

	//验证邀请码
	$('#invitecode').blur(function(){
		var invitecode=$('#invitecode').val();
		if($.trim(invitecode)=="")
		{
			$(this).attr('placeholder','请输入邀请码');
			$(this).css('border-color','#C00');
			$(this).next().next().find('img').css('display','block');
			$(this).next().next().find('img').attr('src','/app/sp/static/images/err.jpg');
			return false;
		}
		var data={invitecode:invitecode};
		$.post('?_a=sp&_u=api.check_invite_code',data,function(obj){
			obj=$.parseJSON(obj);
			console.log(obj);
			if(obj.errno==0){
			$('#invitecode').css('border-color','#CCC');
			$('#invitecode').next().next().find('img').css('display','block');
			$('#invitecode').next().next().find('img').attr('src','/app/sp/static/images/ok.png');
			$('#name').removeAttr('disabled');
			$('#password').removeAttr('disabled');
			$('#account').removeAttr('disabled');
			$('#mobilecode').removeAttr('disabled');
			$('#mobilecode_btn').removeAttr('disabled');
			}
			else{
			$('#invitecode').attr('placeholder','邀请码错误');
			$('#invitecode').css('border-color','#C00');
			$('#invitecode').next().next().find('img').css('display','block');
			$('#invitecode').next().next().find('img').attr('src','/app/sp/static/images/err.jpg');
			$('#name').attr('disabled','disabled');
			$('#password').attr('disabled','disabled');
			$('#account').attr('disabled','disabled');
			$('#mobilecode').attr('disabled','disabled');
			$('#mobilecode_btn').attr('disabled','disabled');
			}
		});
	});


	//验证用户名
	$('#name').focus(function(){
		$(this).attr('placeholder','请输入用户名');
	})
	$('#name').blur(function(){
		var name=$(this).val();
		if($.trim(name).length <1){
			$(this).val('');
			$(this).attr('placeholder','用户名必须大于1位');
			$(this).css('border-color','#C00');
			$(this).next().next().find('img').css('display','block');
			$(this).next().next().find('img').attr('src','/app/sp/static/images/err.jpg');
		}else{
			$(this).css('border-color','#CCC');
			$(this).next().next().find('img').css('display','block');
			$(this).next().next().find('img').attr('src','/app/sp/static/images/ok.png');
		}
	})

	//验证手机号
	$('#account').focus(function(){
		$(this).attr('placeholder','请输入手机号');

	})

	$('#account').blur(function(){
		var reg = /^1[3|5|7|8|][0-9]{9}$/gi;
		if(!reg.test($(this).val())){
			$(this).val('');
			$(this).attr('placeholder','请输入合法手机号码');
			$(this).css('border-color','#C00');
			$(this).next().next().find('img').css('display','block');
			$(this).next().next().find('img').attr('src','/app/sp/static/images/err.jpg');
		}else{
			$(this).css('border-color','#CCC');
			$(this).next().next().find('img').css('display','block');
			$(this).next().next().find('img').attr('src','/app/sp/static/images/ok.png');

			$('#mobilecode_btn').addClass('mobile-active-btn')
		}
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
			$(this).next().next().find('img').attr('src','/app/sp/static/images/err.jpg');
		}else{
			$(this).css('border-color','#CCC');
			$(this).next().next().find('img').css('display','block');
			$(this).next().next().find('img').attr('src','/app/sp/static/images/ok.png');
		}
	})

	$('#password').keyup(function(){
		if($('#password').val().length >5){
			$('#password2').removeAttr('disabled');
		}else{
			$('#password2').attr('disabled','disabled');
		}
		$('#password2').css('border-color','#CCC');
		$('#password2').next().next().find('img').css('display','none');
		$('#password2').attr('placeholder','请再次输入密码');
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
			$(this).next().next().find('img').attr('src','/app/sp/static/images/err.jpg');
		}else{
			$(this).css('border-color','#CCC');
			$(this).next().next().find('img').css('display','block');
			$(this).next().next().find('img').attr('src','/app/sp/static/images/ok.png');
		}
	});

	
	//点击更换验证码
	$('.code img').click(function(){
		$(this).attr('src','?_a=sp&_u=index.verifycode&'+Math.floor(Math.random()*1000));
	});

	//按回车键注册
	$('body').keyup(function(event){
        var keycode = event.which;        
        if(keycode==13){
            $('.register_btn').click();
        }
    });
	//点击发送验证码
	$('#mobilecode_btn').click(function(){

		console.log('?');

		var account = $('#account').val();
		var data = {phone: account};

		//检查是否为手机号码
		var reg = /^1[3|5|7|8|][0-9]{9}$/gi;
		if(!reg.test($('#account').val())){
			$('#account').val('');
			$('#account').attr('placeholder','请输入合法手机号码');
			$('#account').css('border-color','#C00');
			$('#account').next().next().find('img').css('display','block');
			$('#account').next().next().find('img').attr('src','/app/sp/static/images/err.jpg');
			return false;
		}else{
			$('#account').css('border-color','#CCC');
			$('#account').next().next().find('img').css('display','block');
			$('#account').next().next().find('img').attr('src','/app/sp/static/images/ok.png');
		}

		if(timer){
			clearInterval(timer);
			timer= null;
		}
		timer= setInterval(function(){
			times--;
			if(times<=0){
				clearInterval(timer);
				$('#mobilecode_btn').val('点击发送验证码').attr('disabled',false).addClass('mobile-active-btn');
				times= 60;
				
			}else{
				$('#mobilecode_btn').removeClass('mobile-active-btn');
				$('#mobilecode_btn').val(times+'秒后重试').attr('disabled',true).css({'background':'#DDD','color':'#AAA'});
				
			}
		},1000);
		$.post('?_a=sp&_u=api.mobilecode',data,function(obj){
		});
	});


	$('.register_btn').click(function(){
		var account=$('#account').val();
		var password=$('#password2').val();
		var mobilecode=$('#mobilecode').val();
		var name=$('#name').val();
		var invitecode=$('#invitecode').val();
		var type=$('.is_select').attr('data-type');

		var data={
			account:account,
			password:password,
			mobilecode:mobilecode,
			invitecode:invitecode,
			name:name,
			type:type
		}
		if($.trim(name)==""){
			$('#name').attr('placeholder','用户名不能为空');
			$('#name').css('border-color','#C00');
			$('#name').next().next().find('img').css('display','block');
			$('#name').next().next().find('img').attr('src','/app/sp/static/images/err.jpg');
			return false;
		}
		if(invitecode==""){
			$('#invitecode').attr('placeholder','请输入邀请码');
			$('#invitecode').css('border-color','#C00');
			$('#invitecode').next().next().find('img').css('display','block');
			$('#invitecode').next().next().find('img').attr('src','/app/sp/static/images/err.jpg');
			return false;
		}
		if(account==""){
			$('#account').attr('placeholder','手机号码不能为空');
			$('#account').css('border-color','#C00');
			$('#account').next().next().find('img').css('display','block');
			$('#account').next().next().find('img').attr('src','/app/sp/static/images/err.jpg');
			return false;
		}
		if(password==""){
			$('#password').attr('placeholder','密码不能为空');
			$('#password').css('border-color','#C00');
			$('#password').next().next().find('img').css('display','block');
			$('#password').next().next().find('img').attr('src','/app/sp/static/images/err.jpg');
			return false;
		}
		if(mobilecode==""){
			$('#mobilecode').attr('placeholder','请输入验证码');
			$('#mobilecode').css('border-color','#C00');
			$('#mobilecode').next().next().find('img').css('display','block');
			$('#mobilecode').next().next().find('img').attr('src','/app/sp/static/images/err.jpg');
			return false;
		}
		
		
			$.post('?_a=sp&_u=api.register_invite',data,function(obj){
				obj = $.parseJSON(obj);
				console.log(obj);
				if(obj.errno == 0){
					window.location.href="?_a=sp&_u=index.login";
				}else{
					if(obj.errno == 428)
						$('.err_info').html("验证码错误，请重新输入");
					if(obj.errno == 605)
						$('.err_info').html("手机号已注册");
					$('.err_info').show();
					setTimeout(function(){
						$('.err_info').hide();
					},3000)
					//window.location.reload();
				}
			});


	});


});


$('#private_user').click(function(){
	$(this).attr('class','is_select');
	$('#company_user').attr('class','un_select');
	$('#name').attr('placeholder','请输入个人用户名');
});
$('#company_user').click(function(){
	$(this).attr('class','is_select');
	$('#private_user').attr('class','un_select');
	$('#name').attr('placeholder','请输入企业用户名');
});

var get_code_btn = $('.get_code');
get_code_btn.mouseover(function(){
	$('.get_tip').show();
	get_code_btn.unbind('mouseout').mouseout(function(){
		get_code_btn.data('status','false');
		$('.get_tip').hide();
	});
});
get_code_btn.click(function () {
	get_code_btn.unbind('mouseout');
	var status = get_code_btn.data('status');
	if(status=='true'){
		get_code_btn.data('status','false');
		$('.get_tip').hide();
	}
	else{
		get_code_btn.data('status','true');
		$('.get_tip').show();
	}



});



