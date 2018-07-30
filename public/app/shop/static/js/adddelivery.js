$('.save').click(function(){
	var id_user = $('#id_user').data("uid");
	var order_uid = $('#order_uid').val();

	if($.trim(id_user)==""){
		showTip('err','配送员不能为空',1000);
		return false;
	}
	if($.trim(order_uid)==""){
		showTip('err','订单编号不能为空',1000);
		return false;
	}

	var uid = $("#edit-id").data("id");
	var link,text;
	if(uid){
		link = "/?_a=shop&_u=api.adddeliveries&uid="+uid;
		text = '保存成功'
	}else{
		link = "/?_a=shop&_u=api.adddeliveries";
		text = '添加成功'
	}
	var data = {su_uid:id_user,order_uid:order_uid};

	$.post(link, data, function(ret){
		ret = $.parseJSON(ret);
		if(ret.errno==0){
			if(ret.data[0]){
				showTip('ok',text,1000);
				setTimeout(function(){window.location.href='?_a=shop&_u=sp.deliveries'
				} ,1000);
			}else{
				showTip('err','此订单已有配送员',1000);
			}

		}
		
});
});


select_user({ele: '#id_user', single: true,g_uid:g_uid, onok: function(su) {
	console.log('selected', su);
	$('#id_user').attr('data-uid', su.uid);
	$('#id_user img').attr('src', su.avatar || '/static/images/null_avatar.png');
	$('#id_user span').text(su.name);
}});
