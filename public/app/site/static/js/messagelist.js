function do_delete(uids) {
	if(!(uids instanceof Array)) {
		uids = [uids];
	}
	var data = {uids: uids.join(';')}
	$.post('?_a=site&_u=api.delmessage', data, function(ret){
		console.log(ret);
		window.location.reload();
	});
}
function do_pass(uids) {
	if(!(uids instanceof Array)) {
		uids = [uids];
	}
	var mid = $('.table-name').attr('data-uid');
	var data = {uids: uids.join(';'),status:1,sp_uid:mid};
	$.post('?_a=site&_u=api.reviewmessage', data, function(ret){
		console.log(ret);
		window.location.reload();
	});
}
function do_unpass(uids) {
	if(!(uids instanceof Array)) {
		uids = [uids];
	}
	var mid = $('.table-name').attr('data-uid');
	var data = {uids: uids.join(';'),status:2,sp_uid:mid};
	$.post('?_a=site&_u=api.reviewmessage', data, function(ret){
		console.log(ret);
		window.location.reload();
	});
}

$('.msg_pass').click(function(){
	var uid = $(this).attr('data-id');
	do_pass(uid);
});
$('.msg_unpass').click(function(){
	var uid = $(this).attr('data-id');
	do_unpass(uid);
});



$('.cdelete').click(function(){
	var uid = $(this).attr('data-id');
	if(!confirm('确定要删除吗?')) {
		return;
	}
	do_delete(uid);
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
	if(!uids.length) {
		alert('请选择项目!');return;
	}
	if(!confirm('确定要删除吗?')) {
		return;
	}
	do_delete(uids);
});

$('.passall').click(function(){
	var uids = [];
	$('.ccheck').each(function(){
		if ($(this).prop('checked')) {
			uids.push($(this).parent().parent().attr('data-id'));
		}
	});
	do_pass(uids);
});

$('.unpassall').click(function(){
	var uids = [];
	$('.ccheck').each(function(){
		if ($(this).prop('checked')) {
			uids.push($(this).parent().parent().attr('data-id'));
		}
	});
	do_unpass(uids);
});
/*
	amazeui 会调用一次change事件,此时不刷新
*/


$('.option_key_btn').click(function(){
	var key = $('.option_key').val();
	//允许关键字为空，表示清空条件
	if(1 || key) {
		var cat = $(this).val();
		window.location.href='?_a=site&_u=sp.messagelist&cat_uid=' + cat+'&key='+key;
	}
});
$('.option_key').keydown(function(e){
	if(e.keyCode == 13) {
		$('.option_key_btn').click();
	}
});

function do_reply(uid) {
	var brief = $('#id_reply').val();
	if(!brief) {
		return alert('请输入内容');
	}

	$.post('?_a=site&_u=api.replymessage', {uid:uid, brief: brief}, function(ret){
		console.log(ret);
		ret = $.parseJSON(ret);
		if(ret.errno == 0) {
			window.location.reload();
		}
	});
}

  $('.creply').on('click', function() {
  		var uid = $(this).attr('data-id');
      $('#my-confirm').modal({
        relatedTarget: this,
        onConfirm: function(options) {
			do_reply(uid);
        },
        onCancel: function() { 		
        }
      });
    });

	

