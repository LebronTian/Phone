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
	var data = {uids: uids.join(';'), f_uid: g_f_uid}
	$.post('?_a=form&_u=api.delformrecord', data, function(ret){
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

$('.ceditall').click(function(){
	$(this).toggleClass('am-text-danger');
});

function do_remark(uids, sp_remark) {
	if(!(uids instanceof Array)) {
		uids = [uids];
	}
	var data = {uids: uids.join(';'), f_uid: g_f_uid, sp_remark: sp_remark}
	$.post('?_a=form&_u=api.markformrecord', data, function(ret){
		console.log(ret);
		window.location.reload();
	});
}

$('.csp_remarks li').click(function(){
	var r = $(this).attr('sp');
	
	//todo 编辑模式
	if ($('.ceditall').hasClass('am-text-danger')) {
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
		if(!confirm('确定要标记吗?')) {
			return;
		}
		do_remark(uids, r);
	}
	else {
		window.location.href='?_a=form&_u=sp.srecordlist&f_uid='+g_f_uid+'&sp_remark=' + r;
	}
});

$('.csp_remark li').click(function(){
	var r = $(this).attr('sp');
	var uid = $(this).parent().attr('data-uid');
	
	do_remark(uid, r);
});

$('.option_key_btn').click(function(){
	var key = $('.option_key').val();
	//允许关键字为空，表示清空条件
	if(1 || key) {
		window.location.href='?_a=form&_u=sp.srecordlist&f_uid='+g_f_uid+'&key='+key;
	}
});
$('.option_key').keydown(function(e){
	if(e.keyCode == 13) {
		$('.option_key_btn').click();
	}
});


$('#id_download').click(function(){
	window.location.href = '?_a=form&_u=sp.sexcel&_is_ajax=1&uid=' + g_f_uid;
});

