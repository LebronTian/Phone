
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
		if(!(uids instanceof Array)) {
		uids = [uids];
	}
	var data = {uids: uids.join(';'),gid:g_uid}

	if(g_uid!=0){
	$.post('?_a=su&_u=api.move_user_to_group', data, function(ret){
		var ret  =  $.parseJSON(ret);
		if(ret.errno==0){
		$('.ccheck').each(function(){
		if ($(this).prop('checked')) {
			$(this).parent().siblings().children('.am-dropdown').children('button').text(name);
		}
	});
			$('.am-dropdown').removeClass('am-active');
		}
	});
	}
	else{
		
		$('.ccheck').each(function(){
		if ($(this).prop('checked')) {
			var uid = $(this).parent().parent().attr('data-id');
			var old_guid = $(this).parent().siblings().children('.am-dropdown').children('button').attr('data-guid')
			
			var data = {uids:uid,gid:old_guid}
			$.post('?_a=su&_u=api.delete_user_from_group', data, function(ret){
			var ret  =  $.parseJSON(ret);
			if(ret.errno==0){
				$('.am-dropdown').removeClass('am-active');
				$(this).parent().siblings().children('.am-dropdown').children('button').text(name);
			}
		});
		}
	});

	}



});




/*
	amazeui 会调用一次change事件,此时不刷新
*/
var by_amaze_init = 1;
$('.option_key_btn').click(function(){
	var key = $('.option_key').val();
	//允许关键字为空，表示清空条件
	if(1 || key) {
		var cat = $(this).val();
		window.location.href='?_a=su&_u=sp.fanslist&cat_uid=' + cat+'&key='+key;
	}
});
$('.option_key').keydown(function(e){
	if(e.keyCode == 13) {
		$('.option_key_btn').click();
	}
});

$('.private_move').children('li').on('click',function(){
	var uid = $(this).children('a').attr('data-id');
	var g_uid = $(this).children('a').attr('g_uid');
	var name = $(this).children('a').text();
	$(this).parent().parent().click();
	var that=$(this).parent().siblings('.am-dropdown-toggle');
	var old_guid = that.attr('data-guid');
	console.log(uid);
	console.log(g_uid);

	if(g_uid!=0){
	var data = {uids: uid,gid:g_uid}
	$.post('?_a=su&_u=api.move_user_to_group', data, function(ret){
		var ret  =  $.parseJSON(ret);
		if(ret.errno==0){
			that.text(name);
			that.attr('data-guid',g_uid);
			$('.am-dropdown').removeClass('am-active');
		}
	});
	}
	else{
	var data = {uids:uid,gid:old_guid}
		$.post('?_a=su&_u=api.delete_user_from_group', data, function(ret){
		var ret  =  $.parseJSON(ret);
		if(ret.errno==0){
			that.text(name);
			that.attr('data-guid',g_uid);
			$('.am-dropdown').removeClass('am-active');
		}
	});
	}
});


$('.private_verify .am-btn-success').click(function(){
	var uid=$(this).attr('data-id');
	do_pass(uid);
});
$('.private_verify .am-btn-danger').click(function(){
	var uid=$(this).attr('data-id');
	do_refuse(uid);
});

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




$(function() {/*
    $('.am-selected-list').addClass('fanstype');

    $('.fanstype').children('li').click(function(){
        var guid=$(this).attr('data-value');
        $(this).siblings().removeClass();
        $(this).addClass('am-checked');
        window.location.href="?_a=su&_u=sp.fanslist&g_uid="+guid;
    });*/

    $(".option_cat").change(function () {
        var cat = $(this).val();
        var public_uid = optionData.public_uid;
        window.location.href="?_a=su&_u=sp.fanslist&g_uid="+cat+"&public_uid="+public_uid;
    });
    $(".option_public").change(function () {
        var cat = optionData.g_uid;
        var public_uid = $(this).val();
        window.location.href="?_a=su&_u=sp.fanslist&g_uid="+cat+"&public_uid="+public_uid;
    })


});



