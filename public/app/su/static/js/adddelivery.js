$('.save').click(function(){
	var su_uid = $('#su_uid').val();
	var order_uid = $('#order_uid').val();

	if($.trim(su_uid)==""){
		showTip('err','配送员ID不能为空',1000);
		return false;
	}
	if($.trim(order_uid)==""){
		showTip('err','订单编号不能为空',1000);
		return false;
	}




	var uid = $("#edit-id").data("id");
	var link,text;
	if(uid){
		link = "/?_a=su&_u=api.adddelivery&uid="+uid;
		text = '保存成功'
	}else{
		link = "/?_a=su&_u=api.adddelivery";
		text = '添加成功'
	}
	var data = {su_uid:su_uid,order_uid:order_uid};

	$.post(link, data, function(ret){
		ret = $.parseJSON(ret);
		if(ret.errno==0){
			showTip('ok',text,1000);
			setTimeout(function(){window.location.href='?_a=su&_u=sp.delivery'
	} ,1000);
		}
		
});
});
   $('#search_pic').click(function(event){
      event.preventDefault();
   })