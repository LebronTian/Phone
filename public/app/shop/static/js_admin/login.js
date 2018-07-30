//login
$(function(){
	$('input').focus(function(){
		$(this).css('border-color','#CCC');
		$('#info').hide();
	})
	$('input').blur(function(){
		$(this).css('border-color','#CCC');
	})
	$('#account').blur(function(){
		var reg = /^1[3|5|7|8|][0-9]{9}$/gi;
		if($(this).val()==""){
			$(this).attr('placeholder','手机号不能为空');
		}else if(!reg.test($(this).val())){
			//$(this).val('');
       		$(this).attr('placeholder','请输入合法手机号');
       	}else{
			$(this).attr('placeholder','');
			
		}
	})
	$('#password').blur(function(){
		var reg=/^(.{6,32})$/gi;
       if($(this).val()==""){
       		$(this).attr('placeholder','密码不能为空');
       }else if(!reg.test($(this).val())){
       		$(this).attr('placeholder','请输入合法密码');
       }else{
       		$(this).attr('placeholder','');
       		
       }
	})

	$('#verifycode').blur(function(){
		if($(this).val()==""){
			$(this).attr('placeholder','请输验证码');
		}

	})

	//更换验证码
	$('.code img').click(function(){
		$(this).attr('src','?_a=sp&_u=index.verifycode&'+Math.floor(Math.random()*1000));
	})

	//按回车键登陆
	$('body').keyup(function(event){
        var keycode = event.which;        
        if(keycode==13){
            $('.login_btn').click();
        }
    });

	//点击按钮登陆
	$('.login_btn').click(function(){
		var account=$('#account').val();
		var password=$('#password').val();
		var verifycode=$('#verifycode').val();
		
		var data={
			account:account,
			password:password,
			verifycode:verifycode
			}
		
		if(account==""){
			$('#account').attr('placeholder','手机号不能为空');
			$('#account').css('border-color','#C00');
		}
		if(password==""){
			$('#password').attr('placeholder','密码不能为空');
			$('#password').css('border-color','#C00');
		}
		if(verifycode==""){
			$('#verifycode').attr('placeholder','不能为空');
			$('#verifycode').css('border-color','#C00');
		}
		
		if(account!="" && password!="" && verifycode!=""){
			$.post('?_a=shop&_u=admin.login',data,function(obj){
				obj = $.parseJSON(obj);
				console.log(obj.data.sp_uid);
				if(obj.errno==0){
					//window.location.href = '?_a=sp';
					window.location.href = g_goto_uri || '?_a=shop&_u=admin&__sp_uid='+obj.data.sp_uid;
				}
				else if(obj.errno==428){
					$('#info').text('验证码错误');
					$('#info').show();
					$('#verifycode').val('');
					$('#verifycode').attr('placeholder','请输验证码');
					$('.code img').click();
				}
				else{
					$('#info').text('登录失败！用户名或密码错误！');
					$('#info').show();
					setTimeout(function(){
						$('#info').hide();
					},3000)
				}
			})
		}
	})

})
