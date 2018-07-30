$('.install').click(function(){
	var dir = $(this).attr('data-name');
	var sku = get_select_sku_id();
	if(sku === false) {
		showTip('err', '请选择规格！', 3000);
		return;
	}
	
	var data = {dir: dir, sku: sku};
	$.post('?_a=sp&_u=index.plugindetail', data, function(ret){
		console.log(ret);
		if(!(ret = $.parseJSON(ret)) || !ret.data) {
			showTip('err', '错误! 您无权操作! 请联系客服!', 5000)
		}
		else {
			window.location.reload();
		}
	});
});


$('.cgopay').click(function(){
	var dir = $(this).attr('data-name');
	var sku = get_select_sku_id();
	if(sku === false) {
		showTip('err', '请选择规格！', 3000);
		return;
	}
	
	var uid = 8;
	if(sku) uid += ';' + sku;
	var data = {uid: uid, quantity: 1, dir: dir};
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


$('.sku_name input').change(function(){
	console.log('click hehe');
	setTimeout('console.log("hahahaha");update_sku_info();', 50);
});

$('.sku_table a').click(function(){
	console.log('clicked');
	$(this).parent().parent().find('.am-active').removeClass('am-active');
	$(this).parent().addClass('am-active');

	update_sku_info();
});

function get_select_sku_id() {
	if( $('#option1').length) {
		var selected = $('.sku_name .am-active input').val();
		return selected ? '期限:' + selected : false;
	}

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
	}
}

if(typeof g_sku_type != 'undefined') {
	$('.sku_table a:contains("'+g_sku_type+'")').click();
}

