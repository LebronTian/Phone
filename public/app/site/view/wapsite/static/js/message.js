$('.msg_save').click(function(){
	var name = $('#name').val();
	var brief = $('#message').val();
	var contact = $('#contact').val();
	var uid = $(this).attr('data-uid');
	var data = {sp_uid:uid,name:name,contact:contact,brief:brief};

	if($.trim(name)==""){
			$('#name').attr('placeholder','称呼不能为空');
			$('#name').css('border-color','#C00');
		}
	if($.trim(contact)==""){
			$('#contact').attr('placeholder','联系方式不能为空');
			$('#contact').css('border-color','#C00');
	}
	if($.trim(brief)==""){
			$('#message').attr('placeholder','联系方式不能为空');
			$('#message').css('border-color','#C00');
	}
	if($.trim(name) !="" && $.trim(contact) !="" && $.trim(brief) !=""){
			$.post('?_a=site&_u=ajax.add_message',data,function(obj){
				obj = $.parseJSON(obj);
				console.log(obj);
				if(obj.errno==0){
					alert('提交成功');
					window.location.href="?_a=site&_u=index.index";
				}
			})
		}




});