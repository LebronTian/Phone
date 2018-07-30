//选择图片
	$('body').on('.selete_btn').click(function(){
		var imgSrc = $('.img_list').find('li.pic-chose').find('img').attr('data-src');
		/*console.log(imgSrc);return;
		$('.reward-img').find('img').attr('src',imgSrc);
		$('#detail-info-img').attr('src',imgSrc);*/
		var a = parseInt($('#select-img-data-id').val());
		//var i = parseInt($('.reward-setting .select-img-bar').find('a').attr('data-id'));
		//console.log('iii',i);
		//alert(i);
		//if()
		$('.reward-setting:eq('+a+')').find('.select-img-bar').find('img').attr('src',imgSrc);
	});