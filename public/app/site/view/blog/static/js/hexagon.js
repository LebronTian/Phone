$(function(){

	// 六边形hover动画
	function hoverMove(){
		$('.boxT').hover(function(){
			$(this).find('.overlay').stop().animate({opacity:0.5},300);
		},function(){
			$(this).find('.overlay').stop().animate({opacity:0},350);
		})
	}
	hoverMove();
		
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
