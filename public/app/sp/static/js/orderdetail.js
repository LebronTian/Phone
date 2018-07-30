$('#id_weixin_pay').click(function(){
	console.log('clicked');
	$('#id_weixin_pay_qrcode').attr('src', '?_a=pay&_u=weixin.native2qrcode&oid=a'+g_uid);
});

//取消订单按钮, 直接删除订单
$('#id_cancel').click(function(){
	if(!confirm('确定要取消订单吗?')) {
		return;
	}

	var data = {uid: g_uid};
	$.post('?_a=sp&_u=api.delete_service_order', data, function(ret){
		//console.log(ret);
		window.location.href="?_a=sp&_u=index.orderlist";
	});
});

$('#id_weixin_pay_over').click(function(){
	window.location.reload();
});

$('.cls_weixin_pay_error').click(function(){
	var data = {oid: 'a' + g_uid};
	$.post('?_a=pay&_u=weixin.update_order', data, function(ret){
		console.log(ret);
		ret = $.parseJSON(ret);
		if(ret.data) {
			window.location.reload();
		}
		else {
			alert('微信订单查询失败! 请联系客服!');
		}
	});
});

/*
	收货
*/
function do_recepit(uid) {
	var data = {uid: uid};
	$.post('?_a=sp&_u=api.receipt_service_order', data, function(ret){
		console.log(ret);
		//window.location.reload();
	});
}

//待收货
$('.cdoreceipt').click(function(){
	var uid = $(this).attr('data-id');
      $('#my-confirm-receipt').modal({
        relatedTarget: this,
        onConfirm: function(options) {
			do_recepit(uid);
        },
        onCancel: function() { 		
        }
      });
});

