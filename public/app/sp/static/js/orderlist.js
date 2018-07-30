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
	$.post('?_a=sp&_u=api.delete_service_order', data, function(ret){
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
	$.post('?_a=sp&_u=api.delete_service_order', data, function(ret){
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
	do_delete(uids);
});

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
	window.location.href='?_a=sp&_u=index.orderlist&status=' + cat;
});

$('.option_key_btn').click(function(){
	var key = $('.option_key').val();
	//允许关键字为空，表示清空条件
	if(1 || key) {
		var cat = $(this).val();
		window.location.href='?_a=sp&_u=index.orderlist&status=' + cat+'&key='+key;
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
	window.location.href="?_a=pay&oid=a"+uid;
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

