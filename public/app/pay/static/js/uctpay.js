$('.save').click(function(){
	var disabled = $('#id_status').prop('checked') ? 0 : 1;
	var wxpay = $('#id_wxpay').prop('checked') ? 1 : 0;
	var alipay = $('#id_alipay').prop('checked') ? 1 : 0;
	
	if(!disabled && !wxpay && !alipay) {
		showTip('err','请选择至少一种支付方式!',3000);
		return;
	}
	var data = {disabled: disabled, wxpay: wxpay, alipay: alipay};
	$.post('?_a=pay&_u=api.uctpay', data, function(ret){
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

