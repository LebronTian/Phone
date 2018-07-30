$('.save').click(function(){
	var title = $('#id_title').val();
	var groupid = $('#id_wx_group_id').val();
	var uid = g_uid;

	if($.trim(title)==""){
		showTip('err','名称不能为空',1000);
		return false;
	}

	if($.trim(groupid)==""){
		showTip('err','群编码不能为空',1000);
		return false;
	}


	var data = {name:title, uid:g_uid, wx_group_id: groupid};
	$.post('?_a=su&_u=api.addwechatgroup', data, function(ret){
		ret = $.parseJSON(ret);
		if(ret.errno==0){
			showTip('ok','保存成功',1000);
			setTimeout(function(){window.location.href='?_a=su&_u=sp.wechatgroups'
	} ,1000);
		}
		else
			showTip('err','保存失败',1000);
		
});
});
