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
	var data = {uids: uids.join(';'),biz_uid:biz_uid}

	$.post('?_a=shop&_u=api.delbizcoupon', data, function(ret){
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

