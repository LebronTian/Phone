$(function(){
	function contactWay(){
		var contact_num = $(".contact_box").length;
		var box_width = 1000/contact_num;
		console.log(box_width);
		$('.contact_box').width(box_width);
	}

	contactWay();

	$(".contact_box").hover(function(){
		$(this).find('.contact_icon').find('.contact_icon_after').css({
			"opacity":1,
			"transform":"scale(1.17)"
		});
	},function(){
		$(this).find('.contact_icon').find('.contact_icon_after').css({
			"opacity":0,
			"transform":"scale(1)",
			"transition":"all 0.5s"
		});
	});

	$('.wechat').find('.contact_to').find('a').hover(function(){
		$('.wechat').find('.wechat_code').animate({"opacity":"1"},300);
	},function(){
		$('.wechat').find('.wechat_code').animate({"opacity":"0"},300);
	});
})
