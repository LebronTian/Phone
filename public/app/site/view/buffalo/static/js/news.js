$(function(){
	// 新闻列表切换
	$('.news_cats').find('li').click(function(){
		var num = $(this).index();
		$('.news_cats').find('li').removeClass('active').addClass('notactive');
		$(this).removeClass('notactive').addClass('active');
		$('.news_cont').hide();
		$('.news_cont').eq(num).fadeIn(300);
	});
});