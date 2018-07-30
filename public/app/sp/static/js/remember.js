$(function(){
	$('.find_nav li').click(function(){
		var index=$(this).index();
		$(this).addClass('active').siblings().removeClass('active');
		$('.find_cont > .find_pwd_box').eq(index).show().siblings().hide();
	})

	
})