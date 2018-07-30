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

function do_delete(uids) {
	if(!(uids instanceof Array)) {
		uids = [uids];
	}
	var data = {uids: uids.join(';')}
	$.post('?_a=store&_u=api.delusercoupon', data, function(ret){
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

var g_uids = '';
  $('.cwriteoff').on('click', function() {
  		g_uids = $(this).attr('data-id');
      $('#my-confirm2').modal({
        relatedTarget: this,
        onConfirm: function(options) {
			do_writeoff(g_uids);
        },
        onCancel: function() { 		
        }
      });
    });

function do_writeoff(uids) {
	if(!(uids instanceof Array)) {
		uids = [uids];
	}
	var store_uid = $('#id_writeoff_store_uid').val();
	var data = {uids: uids.join(';'), store_uid: store_uid};
	$.post('?_a=store&_u=api.writeoffcoupon', data, function(ret){
		console.log(ret);
		ret = $.parseJSON(ret);
		if(ret && ret.data) {
			window.location.reload();
		}
		else {
			showTip('err', '核销失败! ', 3000);
		}
	});
}

$('.cwriteoffall').click(function(){
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
	if(!confirm('确定要核销吗?')) {
		return;
	}
	g_uids = uids;
	//do_writeoff(uids);
      $('#my-confirm2').modal({
        relatedTarget: this,
        onConfirm: function(options) {
			do_writeoff(g_uids);
        },
        onCancel: function() { 		
        }
      });
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
	var cat2 = $('.option_cat2').val();
	var cat3 = $('.option_cat3').val();
	window.location.href='?_a=store&_u=sp.usercoupon&store_uid=' + cat +'&coupon_uid='+ cat2 + '&writeoff=' + cat3;
});

/*
	amazeui 会调用一次change事件,此时不刷新
*/
var by_amaze_init2 = 1;
$('.option_cat2').change(function(){
	if(by_amaze_init2) {
		by_amaze_init2 = 0;
		return;
	}

	var cat = $('.option_cat').val();
	var cat2 = $(this).val();
	var cat3 = $('.option_cat3').val();
	window.location.href='?_a=store&_u=sp.usercoupon&store_uid=' + cat +'&coupon_uid='+ cat2 + '&writeoff=' + cat3;
});

/*
	amazeui 会调用一次change事件,此时不刷新
*/
var by_amaze_init3 = 1;
$('.option_cat3').change(function(){
	if(by_amaze_init3) {
		by_amaze_init3 = 0;
		return;
	}

	var cat = $('.option_cat').val();
	var cat2 = $('.option_cat2').val();
	var cat3 = $(this).val();
	window.location.href='?_a=store&_u=sp.usercoupon&store_uid=' + cat +'&coupon_uid='+ cat2 + '&writeoff=' + cat3;
});

$('#id_download').click(function(){
	var cat = $('.option_cat').val();
	var cat2 = $('.option_cat2').val();
	var cat3 = $(this).val();
	
	window.location.href='?_a=store&_u=sp.excel_usercoupon&store_uid=' + cat +'&coupon_uid='+ cat2 + '&writeoff=' + cat3;
});

