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
	var data = {uids: parseInt(uids.join(';'))};
	//console.log(data);return;
	$.post('?_a=reward&_u=api.delreward', data, function(ret){
		ret = $.parseJSON(ret);
		console.log(ret);
		if(ret.errno==0){
			showTip('','删除成功',1000);
			setTimeout(function(){
				window.location.reload();
			},500);
		}
	});
}


$('.cstatus').click(function(){
	var uid = $(this).parent().attr('data-uid');
	var status = $(this).attr('data-status');
	console.log(uid, status);
	var data = {uid:uid, status:1-status};
	$.post('?_a=reward&_u=api.addreward', data, function(ret){
		ret = $.parseJSON(ret);
		if(ret.errno==0){
			showTip('','操作成功',1000);
			setTimeout(function(){
				window.location.reload();
			},500);
		}
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


$('.showerweima').mouseover(function(){
	$(this).children(".wap_erweima").show();
	
});
$('.showerweima').mouseout(function(){
	$(this).children(".wap_erweima").hide();

});

$(document).ready(function(){
	$('#tab2').find('.delete-btn').on('click',function(){
		var uid = parseInt($(this).attr('data-uid'));
		console.log(uid);
		$('#my-confirm-1').modal({
	        relatedTarget: this,
	        onConfirm: function(options) {
	          	do_delete(uid);
	        },
	        onCancel: function() {
	         
	        }
		});
	});
});

