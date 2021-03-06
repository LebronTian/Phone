$('.ccancel').on('click', function() {
	var uid = $(this).attr('data-id');
	console.log(uid);
	$('.am-modal-hd').text('取消任务');
	$('.am-modal-bd').text('确定要取消吗？');
	$('#my-confirm').modal({
		relatedTarget: this,
		onConfirm: function(options) {
			do_cancel(uid);
		},
		onCancel: function() {
		}
	});
});


function do_cancel(uids) {
	if(!(uids instanceof Array)) {
		uids = [uids];
	}
	var data = {uids: uids.join(';')}
	$.post('?_a=job&_u=api.cancel_job', data, function(ret){
		console.log(ret);
		//window.location.reload();
	});
}

$(function() {
	$('.cdelete').on('click', function() {
		var uid = $(this).attr('data-id');
		$('.am-modal-hd').text('删除任务');
		$('.am-modal-bd').text('确定要删除吗？');
		console.log(uid);
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
	$.post('?_a=job&_u=api.delete_job', data, function(ret){
		console.log(ret);
		//window.location.reload();
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

var by_amaze_init = 1;
$('.option_cat').change(function(){
	if(by_amaze_init) {
		by_amaze_init = 0;
		return;
	}
	var key = $('.option_key').val();
	//允许关键字为空，表示清空条件
	if(1 || key) {
		var cat = $(this).val();
		window.location.href='?_a=reward&_u=sp.itemlist&r_uid=' + cat+'&key='+key;
	}
});
