function do_delete(uids) {
	if(!(uids instanceof Array)) {
		uids = [uids];
	}
	var data = {uids: uids.join(';')}
	$.post('?_a=form&_u=api.del_form_reply', data, function(ret){
		console.log(ret);
		//window.location.reload();
	});
}

$('.cdelete').click(function(){
	var uid = $(this).attr('data-id');
	if(!confirm('确定要删除吗?')) {
		return;
	}
	do_delete(uid);
});

$('.status-sel li').click(function(){
	var uid = $(this).parent().attr('data-uid');
	var status = $(this).attr('data-pass');
	var data = {uid:uid, status:status};
	console.log(data);
	$.post('?_a=form&_u=api.add_form_reply', data, function(ret){
		console.log(ret);
		window.location.reload();
	});

});

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


$('.option_key_btn').click(function(){
	var key = $('.option_key').val();
	//允许关键字为空，表示清空条件
	if(1 || key) {
		window.location.href='?_a=form&_u=sp.form_reply&key='+key;
	}
});
$('.option_key').keydown(function(e){
	if(e.keyCode == 13) {
		$('.option_key_btn').click();
	}
});




