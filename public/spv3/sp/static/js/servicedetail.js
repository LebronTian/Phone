$('.install').click(function(){
	if(typeof g_sku_type != 'undefined') {
		$('.sku_table a:contains("'+g_sku_type+'")').click();
	}

	var uid= $(this).attr('data-uid');
	var dir= $(this).attr('data-dir');
	var quantity = $('#id_buy_quantity').val();
	var ql = parseInt($('#id_quantity_limit').text());
	if(ql && ql < quantity) {
		showTip('err', '库存不足！', 3000);
		return;
	}
	var sku = get_select_sku_id();
	if(sku === false) {
		showTip('err', '请选择规格！', 3000);
		return;
	}
	if(sku) uid += ';'+sku;
	
	var is_virtual = parseInt($(this).attr('is_virtual'));
	if(!is_virtual) {
		var address = $('#id_address').val();
		if(!address) {
			showTip('err', '请填写收货地址！', 3000);
			return;
		}
		var name = $('#id_name').val();
		if(!name) {
			showTip('err', '请填写收货人姓名！', 3000);
			return;
		}
		var phone = $('#id_phone').val();
		if(!phone) {
			showTip('err', '请填写收货人电话！', 3000);
			return;
		}
		var info = $('#id_info').val();
	}

	var data = {uid: uid, quantity: quantity, dir: dir};
	if(!is_virtual) {
		data['address'] = {address: address, name: name, phone: phone, info: info};
	}
	$.post('?_a=sp&_u=index.servicedetail', data, function(ret){
		console.log(ret);
		if((ret = $.parseJSON(ret)) && ret.data) {
			window.location.href = '?_a=sp&_u=index.orderdetail&gopay=1&uid=' + ret.data;
		}
		else {
			console.log('??', ret, ret.data);
		}
	});
});

$('.sku_table a').click(function(){
	console.log('clicked');
	$(this).parent().parent().find('.am-active').removeClass('am-active');
	$(this).parent().addClass('am-active');

	update_sku_info();
});

function get_select_sku_id() {
	var all = $('.sku_table .sku_name');	
	if(!all.length) {
		return '';
	}

	var sku = [];	
	for(var i=0; i<all.length; i++) {
		var s = $(all[i]).parent().parent().find('.am-active');
		if(!s.length) {
			return false;
		}

		sku.push($(all[i]).text() + ':' + s.text());
	}

	return sku.join(';');
}

function update_sku_info() {
	var sku = get_select_sku_id();	
	console.log('update ... ', sku);
	if(sku && sku_table && sku_table['info'] && sku_table['info'][sku]) {
		var i = sku_table['info'][sku];
		console.log('i..', i);
		$('#id_price').text(i['price']/100);
		$('#id_ori_price').text(i['ori_price']/100);
		$('#id_quantity_limit').text(i['quantity']);
	}
}

if(typeof g_sku_type != 'undefined') {
	$('.sku_table a:contains("'+g_sku_type+'")').click();
}

