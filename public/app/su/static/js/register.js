$('.save').click(function(){
	var disable = $('#id_status').prop('checked') ? 0 : 1;
	
	var data = {disable: disable};
	$.post('?_a=su&_u=api.disable_register', data, function(ret){
		ret = $.parseJSON(ret);
		if(ret.errno==0) {
			showTip('ok','设置成功',1000);
		}
		else {
			showTip('err','设置失败',1000);
		}
	});
});

$('#id_status').click(function(){
	update_cset();
});
function update_cset(){
	var disabled = !$('#id_status').prop('checked');
	if(disabled) {
		$('.cset input').attr('disabled', 'disabled');
	}
	else {
		$('.cset input').removeAttr('disabled');
	}
};
update_cset();

