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
	window.location.href='?_a=pay&_u=sp.withdrawlist&status=' + cat;
});

$('.cconfirm').click(function(){
	if(!confirm('确定要打款吗？')) return;
	var uid = $(this).attr('data-id');	
	$.post('?_a=pay&_u=api.confirm_pay_withdraw',{uid : uid}, function(ret){
		console.log(ret);
		ret = $.parseJSON(ret);
		if(ret && ret.data) {
			window.location.reload();
		}
		else {
			alert(ret.errstr);
		}
	});
});

$('.crefuse').click(function(){
	if(!confirm('确定要拒绝打款吗？')) return;
	var uid = $(this).attr('data-id');	
	$.post('?_a=pay&_u=api.refuse_pay_withdraw',{uid : uid}, function(ret){
		console.log(ret);
		ret = $.parseJSON(ret);
		if(ret && ret.data) {
			window.location.reload();
		}
		else {
			alert(ret.errstr);
		}
	});
});


