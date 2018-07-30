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
	window.location.href='?_a=sp&_u=index.pluginlist&cat=' + cat;
});

$('.option_key_btn').click(function(){
	var key = $('.option_key').val();
	//允许关键字为空，表示清空条件
	if(1 || key) {
		var cat = $(this).val();
		window.location.href='?_a=sp&_u=index.pluginlist&cat=' + cat+'&key='+key;
	}
});
$('.option_key').keydown(function(e){
	if(e.keyCode == 13) {
		$('.option_key_btn').click();
	}
});

$('.btn_enable').click(function(){
	var uid = $(this).attr('data-id');
	var enable=  $(this).hasClass('am-text-danger');
	console.log('enable', uid, enable);
	var data = {uid: uid};
	$.post('?_a=sp&_u=api.enable_plugin', data, function(ret){
		console.log(ret);
		window.location.reload();
	});
});

$('.btn_delete').click(function(){
	var uid = $(this).attr('data-id');
	var data = {uid: uid};
	console.log(data);
	$.post('?_a=sp&_u=api.del_plugin', data, function(ret){
		console.log(ret);
		window.location.reload();
	});
});
  							
