
$('.ccheckall').click(function(){
	var checked = $(this).prop('checked');
	$('.ccheck').prop('checked', checked);
});

$('.all_move').children('li').on('click',function(){
	var g_uid = $(this).children('a').attr('g_uid');
	var name = $(this).children('a').text();
	$(this).parent().parent().click();

	var uids = [];
	$('.ccheck').each(function(){
		if ($(this).prop('checked')) {
			uids.push($(this).parent().parent().attr('data-id'));
		}
	});
	console.log(uids);
	console.log(g_uid);

	if(!(uids instanceof Array)) {
		uids = [uids];
	}
	
	if (g_uid != "0"){		
		var data = {uids: uids.join(';'),gid:g_uid}

		moveUserGroup(data, function(ret) {
			console.log(ret);
			if(ret.errno == 0){
				window.location.reload();
			}
		});
	} else {
		// 批量删除分组
		var data = {uids: uids};
		$.post('?_a=su&_u=api.delete_user_from_group', data, function(ret){
			var ret = $.parseJSON(ret);
			if(ret.errno == 0){
				$('.am-dropdown').removeClass('am-active');
				$(this).parent().siblings().children('.am-dropdown').children('button').text(name);
			}
			console.log(ret);
		});
	}
});

// 修改用户的分组
$(".group-select").on("change",function() {
	var g_uid = $("option:selected", this).val();
	var uid = $(this).attr('data-id');
	var old_guid = $(this).attr('data-guid');

	console.log(uid);
	console.log(g_uid);
	var that = $(this);

	if(g_uid != "-"){
		var data = {uids: uid,gid:g_uid};
		moveUserGroup(data, function(ret) {
			if(ret.errno == 0){
				that.attr('data-guid',g_uid);
			}
		});
	} else{
		var data = {uids:uid, gid:old_guid};
		$.post('?_a=su&_u=api.delete_user_from_group', data, function(ret){
			var ret  =  $.parseJSON(ret);
			if(ret.errno==0){
				that.attr('data-guid',g_uid);
			}
		});
	}
});
// 修改用户分组的接口
function moveUserGroup(data, cb) {
	$.post('?_a=su&_u=api.move_user_to_group', data, function(ret){
		var ret = $.parseJSON(ret);
		if (typeof cb == "function") {
			cb(ret);
		} else {
			window.location.reload();
		}
	});
}





/*
	amazeui 会调用一次change事件,此时不刷新
*/
// 搜索功能
var by_amaze_init = 1;
$('.option_key_btn').click(function(){
	var key = $('.option_key').val();
	//允许关键字为空，表示清空条件
	if(1 || key) {
		var cat = $(this).val();
		window.location.href='?_easy=su.sp.fanslist&cat_uid=' + cat+'&key='+key;
	}
});
$('.option_key').keydown(function(e){
	if(e.keyCode == 13) {
		var key = $('.option_key').val();
		//允许关键字为空，表示清空条件
		if(1 || key) {
			var cat = $(this).val();
			window.location.href='?_easy=su.sp.fanslist&cat_uid=' + cat+'&key='+key;
		}
	}
});


// 用户审核操作
$(".private_verify").on("change", function() {
	var type = $("option:selected", this).val();
	var uid = $(this).attr('data-id');

	console.log(uid);
	console.log(type);

	if (type === "pass") {
		do_pass(uid);
	} else if (type === "refuse") {
		do_refuse(uid);
	}
});

// 批量通过
$('.all_pass').click(function(){
	var uids = [];
	$('.ccheck').each(function(){
		if ($(this).prop('checked')) {
			uids.push($(this).parent().parent().attr('data-id'));
		}
	});
	console.log(uids);
		if(!(uids instanceof Array)) {
		uids = [uids];
	}
	do_pass(uids.join(';'));
});
// 批量拒绝
$('.all_refuse').click(function(){
	var uids = [];
	$('.ccheck').each(function(){
		if ($(this).prop('checked')) {
			uids.push($(this).parent().parent().attr('data-id'));
		}
	});
	console.log(uids);
		if(!(uids instanceof Array)) {
		uids = [uids];
	}
	do_refuse(uids.join(';'));
})


$('.template_refresh').click(function()
{
		$.post('?_a=su&_u=api.synwxfans' , {} , function(ret){
			var ret = $.parseJSON(ret);
			if(ret.errno==0)
				window.location.reload();
			else
				alert('同步中，请耐心等待');
		});
});
$('.template_refresh_quick').click(function()
{
	$.post('?_a=su&_u=api.synwxfans' , {'quick':1} , function(ret){
		var ret = $.parseJSON(ret);
		if(ret.errno==0)
			window.location.reload();
		else
			alert('同步中，请耐心等待');
	});
});

function do_pass(uids){
	var data={uids:uids,status:1}
	$.post('?_a=su&_u=api.review_user' , data , function(ret){
		var ret = $.parseJSON(ret);
		if(ret.errno==0)
			window.location.reload();
	});
}
function do_refuse(uids){
	var data={uids:uids,status:2}
	$.post('?_a=su&_u=api.review_user' , data , function(ret){
		var ret = $.parseJSON(ret);
		if(ret.errno==0)
			window.location.reload();
	});
}




$(function() {
    $(".option_cat").change(function () {
        var cat = $(this).val();
        var public_uid = optionData.public_uid;
        window.location.href="?_a=su&_u=sp.fanslist&g_uid="+cat+"&public_uid="+public_uid;
    });
    $(".option_public").change(function () {
        var cat = optionData.g_uid;
        var public_uid = $(this).val();
        window.location.href="?_a=su&_u=sp.fanslist&g_uid="+cat+"&public_uid="+public_uid;
    });
});

$('.csucharge').click(function(){
	var uid = $(this).attr('data-id');
	window.location.href='?_a=su&_u=sp.supointlist&su_uid='+uid+'&autocharge=1';
});


