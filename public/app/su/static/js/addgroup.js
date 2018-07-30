$('.save').click(function(){
	var title = $('#id_title').val();
	var uid = g_uid;

	if($.trim(title)==""){
		showTip('err','分类名称不能为空',1000);
		return false;
	}


	var data = {uid:uid,name:title};
	$.post('?_a=su&_u=api.addgroup', data, function(ret){
		ret = $.parseJSON(ret);
		if(ret.errno==0){
			showTip('ok','保存成功',1000);
			setTimeout(function(){window.location.href='?_a=su&_u=sp.fansgroups'
	} ,1000);
		}
		else
			showTip('err','保存失败',1000);
		
});
});
   $('#search_pic').click(function(event){
      event.preventDefault();
   })