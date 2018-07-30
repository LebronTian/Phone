$(function(){
	// 工程现场图片切换
	$('.gallery_cats').find('li').click(function(){
		var num = $(this).index();
		$('.gallery_cats').find('li').removeClass('gallery_active');
		$(this).addClass('gallery_active');
		$('.gallery_pic_box').removeClass('gallery_pic_box_active');
		$('.gallery_pic_box').eq(num).addClass('gallery_pic_box_active')
		$('.gallery_pic_box').find('img').removeClass('img_active');
		$('.gallery_pic_box').eq(num).find('img').addClass('img_active');
	});

	$('.gallery_pic_box').find('img').click(function(){
		$('.pic_gallery').fadeIn(300);
	});

	function picGallery(){
		$('.off_icon').click(function(){
			$('.pic_gallery').fadeOut(300);
		});
	};
	picGallery();

	// 六边形hover动画
	function hoverMove(){
		$('.boxT').hover(function(){
			$(this).find('.overlay').stop().animate({opacity:0.85},200);
		},function(){
			$(this).find('.overlay').stop().animate({opacity:0},200);
		})
	}
	hoverMove();

	// 随机函数
	function getRandom(n){
	    return Math.floor(Math.random()*n+1)
	}

	function overlayColor(){
		var $overlay = $('.overlay');
		var overlay_num = $overlay.length;
		for(var i= 0; i<overlay_num; i++){
			var case_i = getRandom(3);
			if(case_i == 1){
				$overlay.eq(i).css({"background":"#ee6557"});
				// console.log("红");
			}
			else if(case_i == 2){
				$overlay.eq(i).css({"background":"#16a6b6"});
				// console.log("蓝");
			}
			else{
				$overlay.eq(i).css({"background":"#b3b3b3"});
				// console.log("灰");
			}
		}
	}
	overlayColor();
});

// 随机函数
function getRandom(n){
    return Math.floor(Math.random()*n+1)
}

// 六边形图片随机淡出
function hexagonBoxShow(){
	var $hexagon_box = $('.hexagon_box');
	var box_num = $hexagon_box.length;
	for(i=0;i<box_num;i++){
		$hexagon_box.eq(i).find('.boxT').delay(getRandom(2000)).fadeIn(getRandom(3000));
	}
};

// 页面滚动时判断是否加载动画
window.onscroll = function getScrollTop(){
	var top = $(document).scrollTop();
	if(top > 555 && top<1555){
		hexagonBoxShow();
	}
}