//选择图片
	$('body').on('.selete_btn').click(function(){
		var imgSrc = $('.img_list').find('li.pic-chose').find('img').attr('data-src');
		$('#id_img').attr('src',imgSrc);
	});