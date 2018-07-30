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
	var data = {uids: uids.join(';'), kf_uid: g_kf_uid}
	$.post('?_a=site&_u=api.delkefumsg', data, function(ret){
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
$('.beditall').click(function(){
	switch($(this).text())
	{
		case "编辑模式":
			$(this).toggleClass('am-btn-success');
			$(this).toggleClass('am-icon-eye');
			$(this).text('查看模式');
			$('#color_sign').text('根据标记查看');
		break;
		case "查看模式":
			$(this).toggleClass('am-btn-success');
			$(this).toggleClass('am-icon-eye');
			$(this).text('编辑模式');
			$('#color_sign').text('选中后进行标记');
		break;
		
	}
	//$(this).toggleClass('am-text-danger');
	
});
function do_remark(uids, sp_remark) {
	if(!(uids instanceof Array)) {
		uids = [uids];
	}
	var data = {uids: uids.join(';'), kf_uid: g_kf_uid, sp_remark: sp_remark}
	$.post('?_a=site&_u=api.markkefumsg', data, function(ret){
		console.log(ret);
		window.location.reload();
	});
}

$('.csp_remarks li').click(function(){
	var r = $(this).attr('sp');
	
	//todo 编辑模式
	if ($('.ceditall').hasClass('am-text-danger')||!$('.beditall').hasClass('am-btn-success')) {
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
		window.location.href='?_a=site&_u=sp.kefumsglist&kf_uid='+g_kf_uid+'&sp_remark=' + r;
	}
});

$('.csp_remark li').click(function(){
	var r = $(this).attr('sp');
	var uids = $(this).parent().parent().parent().parent().attr('data-id');
	do_remark(uids, r);
});

$('.option_key_btn').click(function(){
	var key = $('.option_key').val();
	//允许关键字为空，表示清空条件
	if(1 || key) {
		window.location.href='?_a=site&_u=sp.kefulist&kf_uid='+g_kf_uid+'&key='+key;
	}
});
$('.option_key').keydown(function(e){
	if(e.keyCode == 13) {
		$('.option_key_btn').click();
	}
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
	var key = $('.option_key').val();
	//允许关键字为空，表示清空条件
	if(1 || key) {
		var cat = $(this).val();
		window.location.href='?_a=site&_u=sp.kefumsglist&kf_uid=' + cat+'&key='+key;
	}
});


$('.show_rule_data').mouseover(function(){
	$(this).children(".win_rule_data").show();
	
});
$('.show_rule_data').mouseout(function(){
	$(this).children(".win_rule_data").hide();

});
