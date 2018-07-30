$('#id_sucharge').on('click', function() {
   $('#my-confirm').modal({
     relatedTarget: this,
     onConfirm: function(options) {
		var su_uid = $('#id_charge_price').attr('data-id');
		var point = $('#id_charge_price').val();
		var brief = $('#id_brief').val()
 		do_sucharge(su_uid, point, brief);
     },
     onCancel: function() { 		
     }
   });
});
$('.score_sucharge').on('click', function() {
	var target_id= $(this).attr('data-id');
   $('#score-confirm').modal({
     relatedTarget: this,
     onConfirm: function(options) {
		var su_uid = target_id;
		var point = $('#id_charge_price').val();
		var brief = $('#id_brief').val()
 		do_sucharge(su_uid, point, brief);
     },
     onCancel: function() { 		
     }
   });
});

//赠送积分 
function do_sucharge(su_uid, point, brief) {
	var data = {
		su_uid: su_uid,
		point: point, 
		brief: brief
	};
	$.post('?_a=su&_u=api.send_point', data, function(ret){
		console.log(ret);
		ret = $.parseJSON(ret);
		if(ret.data) {
			showTip('suc', '赠送成功！', 3000);
		}
		else {
			showTip('err', '赠送失败！', 3000);
		}
	});
}

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
	window.location.href='?_a=su&_u=sp.supointlist&su_uid='+g_su_uid+'&type=' + cat;
});

$('.cuser').click(function(){
	var uid = $(this).attr('data-id');
	window.location.href= '?_a=su&_u=sp.supointlist&su_uid='+uid;
});

