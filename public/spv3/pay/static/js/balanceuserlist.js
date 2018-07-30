$('.ccheckall').click(function(){
	var checked = $(this).prop('checked');
	$('.ccheck').prop('checked', checked);
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
		window.location.href='?_a=pay&_u=sp.balanceuserlist&key='+key;
	}
});
$('.option_key').keydown(function(e){
	if(e.keyCode == 13) {
		$('.option_key_btn').click();
	}
});

$('.ccharge').click(function(){
	var uid = $(this).attr('data-id');
	window.location.href = '?_a=pay&_u=sp.balanceuser&type=2&uid=' + uid;
});

$('.ctransfer').click(function(){
	var uid = $(this).attr('data-id');
	window.location.href = '?_a=pay&_u=sp.balanceuser&type=1&uid=' + uid;
});

