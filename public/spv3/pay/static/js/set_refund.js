$('.save').click(function(){
	//var disabled = $('#id_status').prop('checked') ? 1 : 0;
	var type = $('#id_type').val();

	var data = {type: type};
	$.post('?_a=pay&_u=api.set_refund', data, function(ret){
		ret = $.parseJSON(ret);
		if(ret.errno==0) {
			showTip('ok','保存成功',1000);
		}
		else {
			showTip('err','保存失败',1000);
		}
		window.location.reload();
	});
});

