function do_delete(uids) {
	if(!(uids instanceof Array)) {
		uids = [uids];
	}
	var data = {uids: uids.join(';')}
	$.post('?_a=shop&_u=api.delcomment', data, function(ret){
		console.log(ret);
		window.location.reload();
	});
}

function do_allow(uids) {
	if(!(uids instanceof Array)) {
		uids = [uids];
	}
	var data = {uids: uids.join(';'),status:1}
	$.post('?_a=shop&_u=api.reviewcomment', data, function(ret){
		console.log(ret);
		window.location.reload();
	});
}

function do_refuse(uids) {
	if(!(uids instanceof Array)) {
		uids = [uids];
	}
	var data = {uids: uids.join(';'),status:20}
	$.post('?_a=shop&_u=api.reviewcomment', data, function(ret){
		console.log(ret);
		window.location.reload();
	});
}

$('.cdelete').click(function(){
	var uid = $(this).attr('data-id');
	if(!confirm('确定要删除吗?')) {
		return;
	}
	do_delete(uid);
});

$('.cstatus').click(function(){
	var uid = $(this).parent().parent().attr('data-id');
	var status = $(this).attr('data-status');
	var mid = $('.table-name').attr('data-uid');
	console.log(uid, status);
	var data = {uids:uid, status:1-status,sp_uid:mid};
	$.post('?_a=shop&_u=api.reviewcomment', data, function(ret){
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

$('.allowall').click(function(){
	var uids = [];
	$('.ccheck').each(function(){
		if ($(this).prop('checked')) {
			uids.push($(this).parent().parent().attr('data-id'));
		}
	});
	if(!uids.length) {
		alert('请选择项目!');return;
	}
	if(!confirm('确认批量通过?')) {
		return;
	}
	do_allow(uids);
});

$('.refuseall').click(function(){
	var uids = [];
	$('.ccheck').each(function(){
		if ($(this).prop('checked')) {
			uids.push($(this).parent().parent().attr('data-id'));
		}
	});
	if(!uids.length) {
		alert('请选择项目!');return;
	}
	if(!confirm('确认批量拒绝?')) {
		return;
	}
	do_refuse(uids);
});


/*
	amazeui 会调用一次change事件,此时不刷新
*/

// 搜索功能
$('.option_key_btn').click(function(){
	var key = $('.option_key').val();
	//允许关键字为空，表示清空条件
	if(1 || key) {
		var cat = $(this).val();
		window.location.href='?_a=shop&_u=sp.commentslist&cat_uid=' + cat+'&key='+key;
	}
});
$('.option_key').keydown(function(e){
	if(e.keyCode == 13) {
		$('.option_key_btn').click();
	}
});
// 重置
$(".reset-btn").click(function() {
	$('.option_key').val("");
});

/*yhc*/
$(document).ready(function () {
    $(".status-sel li").click(function () {
        var uid = $(this).parent().data('uid');
        var status = $(this).data("pass");
        var userid = $(this).attr("data-userid");
       	// alert(userid);
        var data = {
            uids:uid,
            status:status,
            user_id:userid
        };
        // console.log(data);
        $.post('?_a=shop&_u=api.reviewcomment', data, function(ret){
           	window.location.reload();
        });
    })
});


