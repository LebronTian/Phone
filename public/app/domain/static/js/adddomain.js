$('#id_commit').click(function(){
	var domain = $('#id_domain').val();
	if($('#id_domain').val()=='')
	{	
		showTip('err','请填写要绑定域名',1000);
		return;
	}
	if($('#id_binds').val()==undefined)
	var bind = $('#id_bind').val();
	else
	var bind = $('#id_binds').val();
	
	var uid = $(this).attr('data-id');
	var data = {domain: domain, bind: bind};
	if(uid) data['uid'] = uid;
	$.post('?_a=domain&_u=api.adddomain', data, function(ret){
		console.log(ret.errno);
		ret = $.parseJSON(ret);
		if(ret.errno==0){
			showTip('ok','保存成功',1000);
			setTimeout(function(){
				window.location.href='?_a=domain&_u=sp';}
				,1000)
		}
		else
			showTip('err','保存失败',1000);
	
	});
});



