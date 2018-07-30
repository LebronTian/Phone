$('.save').click(function(){
	var enabled = $('#id_status').prop('checked') ? 1 : 0;
	var wd_type = $('#id_wd_type').val();
	var withdraw_rule = {
						min_price: 100 * $('#id_min_price').val(),
						max_price: 100 * $('#id_max_price').val(),
						check_price: 100 * $('#id_check_price').val(),
						max_cnt_day: $('#id_max_cnt_day').val(),
						max_price_day: 100 * $('#id_max_price_day').val()
						,need_check: $('#id_need_check').prop('checked') ? 1 : 0
					};
	
	var data = {enabled: enabled, wd_type: wd_type, withdraw_rule: withdraw_rule};
	$.post('?_a=pay&_u=api.withdraw', data, function(ret){
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
		$('.cset .am-selected').attr('disabled', 'disabled');
	}
	else {
		$('.cset input').removeAttr('disabled');
		$('.cset .am-selected').removeAttr('disabled');
	}
};
update_cset();

