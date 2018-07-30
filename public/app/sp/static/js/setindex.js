/*
	amazeui 会调用一次change事件,此时不刷新
*/
var by_amaze_init = 1;
$('.option_catt').change(function(){
	if(by_amaze_init) {
		by_amaze_init = 0;
		//return;
	}

	if('redirect' == $(this).val()) {
		$('.divurl').show();	
	}
	else {
		$('.divurl').hide();	
	}
});

$('.btn_save').click(function(){
	var index = {'type': $('.option_catt').val()};	
	if(index.type == 'redirect') {
		index['url'] = $('#id_url').val();
	}

	$.post('?_a=sp&_u=index.setindex', {index:index}, function(ret){
		console.log(ret);
	});
});

