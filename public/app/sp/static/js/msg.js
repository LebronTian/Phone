$('.btn_title').click(function(){

	var data_id=$(this).attr('data-id');

	//do_read(data_id);

	$(this).parent().parent().attr('class','am-link-muted');
	$('#doc-modal-1').children().children('.am-modal-hd').children('span').text($(this).text());
	$('#doc-modal-1').children().children('.am-modal-bd').html($(this).attr('data-code'));
});




function do_read(uids){
	var time='1';
	if(!(uids instanceof Array)) {
		uids = [uids];
	}
	var data = {time:time,uids: uids.join(';')}
	$.post('?_a=sp&_u=api.read_sp_msg', data, function(ret){
		console.log(ret);
		window.location.reload();	
	});
}

function do_unread(uids){
	var time='0';
	if(!(uids instanceof Array)) {
		uids = [uids];
	}
	var data = {time:time,uids: uids.join(';')}
	$.post('?_a=sp&_u=api.read_sp_msg', data, function(ret){
		console.log(ret);
		window.location.reload();
	});
}

$('.is_read').click(function(){
	var uid=$(this).attr('data-id');
	do_unread(uid);
});

$('.un_read').click(function(){
	var uid=$(this).attr('data-id');
	do_read(uid);
});










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
	$.post('?_a=sp&_u=api.del_sp_msg', data, function(ret){
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

$('.readall').click(function(){
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

	do_read(uids);
	window.location.reload();
})

$('.unreadall').click(function(){
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

	do_unread(uids);
	window.location.reload();
})