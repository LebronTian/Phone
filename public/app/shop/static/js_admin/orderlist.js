$(function() {
  $('.cdelete').on('click', function() {
  		var uid = $(this).attr('data-id');
      $('#my-confirm').modal({
        relatedTarget: this,
        onConfirm: function(options) {
			do_delete(uid);
        },
        onCancel: function() { 		
        }
      });
    });
});

function do_delete_order(uids) {
	//不支持批量删除
	if((uids instanceof Array)) {
		uids = uids[0];
	}
	var data = {uid:uids};
	$.post('?_a=shop&_u=admin.delete_order', data, function(ret){
		console.log(ret);
		window.location.reload();
	});
}

function do_delete(uids) {
	return do_delete_order(uids);

	if(!(uids instanceof Array)) {
		uids = [uids];
	}
	var data = {uids: uids.join(';')}
	$.post('?_a=shop&_u=admin.delete_order', data, function(ret){
		console.log(ret);
		window.location.reload();
	});
}


$('.ccheckall').click(function(){
	var checked = $(this).prop('checked');
	$('.ccheck').prop('checked', checked);
});

$('.cdeleteall').click(function(){
	var uids = [];
	$('.ccheck').each(function(){
		if ($(this).prop('checked')) {
			uids.push($(this).parent().parent().attr('data-id'));
		}
	});
	console.log(uids);
	if(!uids.length) {
		alert('请选择项目!');return;
	}
	if(!confirm('确定要删除吗?')) {
		return;
	}
	console.log(1);
	return;
	do_delete(uids);
});

//批量选择配送员
$('.choosedall').click(function(){

	var uids = [];
	$('.ccheck').each(function(){
		if ($(this).prop('checked')) {
			uids.push($(this).parent().parent().attr('data-id'));
		}
	});
	if(!uids.length) {
		alert('请选择项目!');return;
	}else{
		$('#my-confirm-delivery').modal({
			relatedTarget: this,
			onConfirm: function(options) {
				do_delivery(uids);
			},
			onCancel: function() {
			}
		});
	}

	// window.location.reload();
})

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
	window.location.href='?_a=shop&_u=admin.orderlist&status=' + cat;
});

$('.option_key_btn').click(function(){
	var key = $('.option_key').val();
	//允许关键字为空，表示清空条件
	if(1 || key) {
		var cat = $(this).val();
		window.location.href='?_a=shop&_u=admin.orderlist&status=' + cat+'&key='+key;
	}
});
$('.option_key').keydown(function(e){
	if(e.keyCode == 13) {
		$('.option_key_btn').click();
	}
});

//待支付
$('.cdopay').click(function(){
	var uid = $(this).parent().parent().attr('data-id');
	window.location.href="?_a=pay&oid=b"+uid;
});

/*
	发货
*/
function do_delivery(uid) {
	var delivery_info = {
		'快递单号':   $('#id_courier_no').val(),
		'快递公司': $('#id_courier_name').val(),
		//'快递员姓名': $('#id_courier_name').val(),
		//'快递员电话': $('#id_courier_phone').val()
	};
	//var su_uid = $('#id_courier_no').val();
	//var id_user = $('#id_user').attr('data-uid');
	//if($.trim(id_user)==""){
	//	showTip('err','请选择配送员',1000);
	//	return false;
	//}

	var data = {uid: uid, delivery_info:delivery_info};
	//var data2 = {order_uid: uid, su_uid:id_user};
	// console.log(data2);return
	$.post('?_a=shop&_u=admin.do_delivery', data, function(ret){
		ret = $.parseJSON(ret);
		console.log(ret);
		 if(ret.errno == 0){
		//	$.post('?_a=shop&_u=admin.adddeliveries', data2, function(ret2){
				window.location.reload();
			//});
		 }



		//window.location.reload();
	});
}

//待发货
$('.cdodelivery').click(function(){
	var uid = $(this).parent().parent().attr('data-id');
	//do_delivery(uid);
      $('#my-confirm-delivery').modal({
        relatedTarget: this,
        onConfirm: function(options) {
			do_delivery(uid);
        },
        onCancel: function() {
        }
      });
});

/*
	收货
*/
function do_recepit(uid) {
	var data = {uid: uid};
	$.post('?_a=shop&_u=admin.do_receipt', data, function(ret){
		console.log(ret);
		window.location.reload();
	});
}

//待收货
$('.cdoreceipt').click(function(){
	var uid = $(this).parent().parent().attr('data-id');
      $('#my-confirm-receipt').modal({
        relatedTarget: this,
        onConfirm: function(options) {
			do_recepit(uid);
        },
        onCancel: function() { 		
        }
      });
});

/*
	申请退款
*/
function do_refund(uid, refund_fee, refund_info) {
	var data = {uid: uid, refund_fee: refund_fee, refund_info: refund_info};
	$.post('?_a=shop&_u=admin.addrefund', data, function(ret){
		console.log(ret);
		window.location.reload();
	});
}

//申请退款
$('.cdorefund').click(function(){
	//var uid = $(this).parent().parent().attr('data-id');
	  var uid = $(this).attr('data-id');
	  $('#id_refund_fee').val($(this).attr('data-fee')/100);
      $('#my-confirm-refund').modal({
        relatedTarget: this,
        onConfirm: function(options) {
			refund_fee = 100 * $('#id_refund_fee').val();
			refund_info = {
				'reason': $('#id_refund_reason').val()
			};
			do_refund(uid, refund_fee, refund_info);
        },
        onCancel: function() { 		
        }
      });
});

/*
	同意退款
*/
function do_accept_refund(uid, accept, refund_info) {
	var data = {uid: uid, accept: accept, refund_info: refund_info};
	$.post('?_a=shop&_u=admin.acceptrefund', data, function(ret){
		console.log(ret);
		ret = $.parseJSON(ret);
		if(ret && ret.errno == 302) {
			$('body').append(ret.data);
		}
		else {
			window.location.reload();
		}
	});
}

//同意退款
$('.cacceptrefund').click(function(){
	  var uid = $(this).parent().parent().attr('data-id');
      $('#my-confirm-acceptrefund').modal({
        relatedTarget: this,
        onConfirm: function(options) {
			refund_info = {
				'sp_reason': $('#id_acceptrefund_reason').val()
			};
			do_accept_refund(uid, 1, refund_info);
        },
        onCancel: function() { 		
			refund_info = {
				'sp_reason': $('#id_acceptrefund_reason').val()
			};
			do_accept_refund(uid, 0, refund_info);
        }
      });
});

//退团
$('.cdorefundgroup').click(function(){
	if(!confirm('确定要退团吗？ 订单支付金额将自动退回!')) return;
	//var uid = $(this).parent().parent().attr('data-id');
	  var uid = $(this).attr('data-id');
	  //var go_uid = $(this).attr('go-id');
	  var data = {uid: uid};
	$.post('?_a=shop&_u=admin.dorefundgroup', data, function(ret){
		console.log(ret);
		//window.location.reload();
	});
	  
});

//console.log(g_uid);
//select_user({ele: '#id_user', single: true,g_uid:g_uid, onok: function(su) {
//	console.log('selected', su);
//	$('#id_user').attr('data-uid', su.uid);
//	$('#id_user img').attr('src', su.avatar || '/static/images/null_avatar.png');
//	$('#id_user span').text(su.name);
//}});


