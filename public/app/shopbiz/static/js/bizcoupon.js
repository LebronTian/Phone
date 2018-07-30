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

	/*上下线按钮*********************/
	$('.cStatus').click(function(){
		var uid = $(this).parent().parent().attr('data-id');
		var status;
		if($(this).hasClass("am-btn-success")){
			status = 1
		}else{
			status = 0
		}
		var data = {uid:uid, status:status,biz_uid:biz_uid};
		$.post('?_a=shop&_u=api.add_or_edit_bizcoupon', data, function(ret){
			console.log(ret);
			window.location.reload();
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

