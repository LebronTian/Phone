$('.save').click(function(){
	var enabled= $('#id_status').prop('checked') ? 1 : 0;
	
	var data = { enabled: enabled};
	$.post('?_a=su&_u=api.wxlogin', data, function(ret){
		ret = $.parseJSON(ret);
		if(ret.errno==0) {
			showTip('ok','保存成功',1000);
		}
		else {
			showTip('err','保存失败',1000);
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

