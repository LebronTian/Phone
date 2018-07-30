$('.save').click(function(){
	var disabled = $('#id_status').prop('checked') ? 0 : 1;
	
	var data = {disabled: disabled};
	$.post('?_a=pay&_u=api.balancepay', data, function(ret){
		ret = $.parseJSON(ret);
		if(ret.errno==0) {
			showTip('ok','保存成功',1000);
		}
		else {
			showTip('err','保存失败',1000);
		}
	});
});

