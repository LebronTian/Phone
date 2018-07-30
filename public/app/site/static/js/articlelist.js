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
	$.post('?_a=site&_u=api.delarticle', data, function(ret){
		console.log(ret);
		window.location.reload();
	});
}


$('.cstatus').click(function(){
	var uid = $(this).parent().parent().attr('data-id');
	var status = $(this).attr('data-status');
	console.log(uid, status);
	var data = {uid:uid, status:1-status};
	$.post('?_a=site&_u=api.addarticle', data, function(ret){
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
var by_amaze_init = 1;
$('.option_cat').change(function(){
	if(by_amaze_init) {
		by_amaze_init = 0;
		return;
	}

	var cat = $(this).val();
	window.location.href='?_a=site&_u=sp.articlelist&cat_uid=' + cat;
});

$('.option_key_btn').click(function(){
	var key = $('.option_key').val();
	//允许关键字为空，表示清空条件
	if(1 || key) {
		var cat = $(this).val();
		window.location.href='?_a=site&_u=sp.articlelist&cat_uid=' + cat+'&key='+key;
	}
});
$('.option_key').keydown(function(e){
	if(e.keyCode == 13) {
		$('.option_key_btn').click();
	}
});

