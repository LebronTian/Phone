$('.cadd').click(function(){
	alert('请联系专属客服开通店铺!');
	if($('.kzlst2').hasClass('zy-sq2')) {
		$('.kzlst2').click();
	}
});

$('.cfriend').click(function(){
	if (!confirm('确定要切换店铺吗?')) return;
	window.location.href='?_easy=sp.index.gotofriend&uid=' + $(this).attr('data-id');
});
