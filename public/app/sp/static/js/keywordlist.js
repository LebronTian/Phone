$('.text-chosen').select2({tags: true, placeholder: "请输入关键词,支持最多3个", maximumInputLength: 5, tokenSeparators: [',', ' ',';']});

$('.text-chosen').on('change', function(){
	var keywords = $(this).val() || [];
	var uid = $(this).attr('data-id');
	console.log('changed', keywords, uid);
	var data = {uid: uid, keywords: keywords.join(';')};
	$.post('?_a=sp&_u=api.set_plugin_keywords', data, function(ret){
		console.log(ret);
	});
});

$('.cpattern').blur(function(){
	var old = $(this).attr('data-value');
	var keywords = $(this).val();
	if(old != keywords) {
		console.log('changedd');
		var uid = $(this).attr('data-id');
		var data = {uid: uid, keywords: keywords, is_string: 1};
		var that = this;
		$.post('?_a=sp&_u=api.set_plugin_keywords', data, function(ret){
			console.log(ret);
			$(that).attr('data-value', keywords);
		});
	}
	else {
		console.log('not change');
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
  							

