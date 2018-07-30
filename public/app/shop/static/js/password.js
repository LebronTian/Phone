	//验证密码
	$('#newpsd').focus(function(){
		$(this).attr('placeholder','密码长度大于6位');
	})

	$('#newpsd').blur(function(){
		var reg=/^(.{6,32})$/gi;
		if(!reg.test($(this).val())){
			$(this).val('');
			$(this).attr('placeholder','请输入合法密码,长度在6-32位');
			$(this).css('border-color','#C00');
		}else{
			$(this).css('border-color','#2980CD');
		}
	})

	//确认密码
	$('#re_newpsd').focus(function(){
		$(this).attr('placeholder','请再次输入密码');
	})

	$('#re_newpsd').blur(function(){
		if($(this).val() != $('#newpsd').val()){
			$(this).val('');
			$(this).attr('placeholder','两次密码输入不一致');
			$(this).css('border-color','#C00');
		}else{
			$(this).css('border-color','#2980CD');
		}
	})

	$('.btn_save').click(function(event){
		var old_password = $('#oldpsd').val();
		var new_password = $('#newpsd').val();
		var re_new_password = $('#re_newpsd').val();
		var data = {"old":old_password,"new":re_new_password}
		if(old_password!=""&&new_password!=""&&re_new_password!=""){
			if(new_password==re_new_password){
				$.post('?_a=shop&_u=admin.password',data,function(obj){
				obj = $.parseJSON(obj);
					if(obj.errno==0){
					}
					else{
						$('#oldpsd').val('');
						$('#oldpsd').attr('placeholder','原始密码错误,请重新输入');
					}
				});
			}
		}
		event.preventDefault();
	})

	$('.save_name').click(function(){
		var name = $('#sp_name').val();
		var data = {"account":name}

		$.post('?_a=shop&_u=api.change_name',data,function(obj){
			obj = $.parseJSON(obj);
			if(obj.errno==0){
				showTip("","修改成功",1000);
			}
		});
	})
