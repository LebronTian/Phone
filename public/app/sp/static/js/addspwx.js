$('.save').click(function(){
	if(!$('#id_open_id').length) {
		showTip('err', '微信号未设置！', 3000);
		return;
	}
 
	var data = {
		'open_id': $('#id_open_id').attr('data-id'),
		'cfg': {
			'disable_login': $('#id_allow_login').prop('checked') ? 0 : 1,
			'disable_msg': $('#id_allow_msg').prop('checked') ? 0 : 1
		}
	};
	$.post('?_a=sp&_u=api.add_sp_wx', data, function(ret){
		console.log(ret);
		ret = $.parseJSON(ret);
		if(ret && !ret.errno && ret.data) {
			showTip('ok','设置成功',1000);
		}
		else {
			showTip('err','设置失败',1000);
		}
	});
});

$('#id_change').click(function(){
	$.get('?_a=wxcode&_u=index.uct_sp_wx', function(ret){
		console.log(ret);
		ret = $.parseJSON(ret);
		if(!ret || !ret.data || !ret.data.img_url) {
			showTip('err', '系统错误，请刷新页面重试！', 3000);
			return;
		}

		$('#id_change').parent().html('<img src="'+ ret.data.img_url +'" width=140 height=140><small>微信扫一扫绑定商户账号, 完成后请刷新页面</small>');
	});
});

if(!$('#id_open_id').length) {
	$('#id_change').click();
}
	
