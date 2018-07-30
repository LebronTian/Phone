$(function(){

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
	overlayColor()
		
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
	if(top > 0 && top<1000){
		hexagonBoxShow();
	}
}
