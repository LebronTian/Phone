$('.save').click(function(){
	var spname = $('#id_spname').val();
	var seller_email = $('#id_seller_email').val();
	var partner = $('#id_partner').val();
	var key = $('#id_key').val();
	var disabled = $('#id_status').prop('checked') ? 0 : 1;
	
	var data = {spname:spname, seller_email:seller_email, partner:partner,key:key, disabled: disabled};
	$.post('?_a=pay&_u=api.alipay', data, function(ret){
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

