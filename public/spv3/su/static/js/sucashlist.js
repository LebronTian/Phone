$('#id_sucharge').on('click', function() {
   $('#my-confirm').modal({
     relatedTarget: this,
     onConfirm: function(options) {
		var su_uid = $('#id_charge_price').attr('data-id');
		var charge_price = $('#id_charge_price').val() * 100;
 		do_sucharge(su_uid, charge_price);
     },
     onCancel: function() { 		
     }
   });
});

//充值
function do_sucharge(su_uid, charge_price) {
	var data = {
		su_uid: su_uid,
		charge_price: charge_price
	};
	$.post('?_a=su&_u=api.make_sucharge_order', data, function(ret){
		console.log(ret);
		ret = $.parseJSON(ret);
		if(ret.data) {
			window.location.href = '?_a=pay&oid=g' + ret.data;
		}
		else {
			showTip('err', '充值下单失败！', 3000);
		}
	});
}

$('#id_sucharge2').on('click', function() {
   $('#my-confirm2').modal({
     relatedTarget: this,
     onConfirm: function(options) {
		var su_uid = $('#id_charge_price2').attr('data-id');
		var charge_price = $('#id_charge_price2').val() * 100;
 		do_sucharge2(su_uid, charge_price);
     },
     onCancel: function() { 		
     }
   });
});
//充值
function do_sucharge2(su_uid, charge_price) {
	var data = {
		su_uid: su_uid,
		cash: charge_price
	};
	$.post('?_a=su&_u=api.send_cash', data, function(ret){
		console.log(ret);
		ret = $.parseJSON(ret);
		if(ret.data) {
			window.location.reload();
		}
		else {
			showTip('err', '赠送失败！', 3000);
		}
	});
}


/*
	amazeui 会调用一次change事件,此时不刷新
*/
var by_amaze_init = 1;
$('.option_cat').change(function(){
	if(by_amaze_init) {
		by_amaze_init = 0;
		return;
	}

	var cat = $(this).val();
	window.location.href='?_a=su&_u=sp.sucashlist&su_uid='+g_su_uid+'&type=' + cat;
});

$('.cuser').click(function(){
	var uid = $(this).attr('data-id');
	window.location.href= '?_a=su&_u=sp.sucashlist&su_uid='+uid;
});

