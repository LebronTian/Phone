$(document).ready(function(){
	
	/*最近常用 按钮显示隐藏*/
	$('.RegularlyCont').find('li').find('a').hide();
	$('.RegularlyCont').find('span').mouseover(function(){
		$(this).find('a').show();
	});
	$('.RegularlyCont').find('span').mouseout(function(){
		$(this).find('a').hide();
	});

	/*文库 游戏 活动 探索发现*/
	$('.ApplyCont').mouseover(function(){
		$(this).find('.Mask').show();
		$(this).find('.MaskBar').stop().animate({top:'0px'},200);
	});
	$('.ApplyCont').mouseout(function(){
		$(this).find('.Mask').hide();
		$(this).find('.MaskBar').stop().animate({top:'-168px'},200);
	});


	/*数字随机快速变化*/
	var timer1;
	var timer2;
	var v1;
	var v2;
	var t1 = parseInt($('#TodayFans').text());
	var t2 = parseInt($('#TotalFans').text());
	if(t1<10){
		v1 = 10;
	}else if(t1<100){
		v1 = 100;
	}else if(t1<1000){
		v1 = 1000;
	}else if(t1<10000){
		v1 = 10000;
	}else if(t1<100000){
		v1= 100000;
	}else if(t1<1000000){
		v1= 1000000;
	}

	if(t2<10){
		v2 = 10;
	}else if(t2<100){
		v2 = 100;
	}else if(t2<1000){
		v2 = 1000;
	}else if(t2<10000){
		v2 = 10000;
	}else if(t2<100000){
		v2 = 100000;
	}else if(t2<1000000){
		v2 = 1000000;
	}
	if($('#TodayFans').text() !='0'){
		timer1 = setInterval(function(){
			$('#TodayFans').text('');
			$('#TodayFans').show();
			$('#TodayFans').text(parseInt(Math.random()*v1));
		},5);
	}else{
		$('#TodayFans').show();
	}
	
	if($('#TotalFans').text() !='0'){
		timer2 = setInterval(function(){
			$('#TotalFans').text('');
			$('#TotalFans').show();
			$('#TotalFans').text(parseInt(Math.random()*v2));
		},5);
	}else{
		$('#TotalFans').show();
	}
	

	setTimeout(function(){
		clearInterval(timer1);
		clearInterval(timer2);
		$('#TodayFans').text(t1);
		$('#TotalFans').text(t2);
	},1500);
	

	/*新闻滚动*/
	var $this = $('.NewsBar');
	var scrollTimer;
	$this.hover(function(){
		clearInterval(scrollTimer);
	},function(){
		scrollTimer = setInterval(function(){
			Scroll($this);
		},2000);
	}).trigger('mouseleave');
	
});

/*滚动函数*/
function Scroll(obj){
	var $self = obj.find('ul:first');
	var lineHeigth = $self.find('li:first').height();
	$self.animate({ 'marginTop' : -lineHeigth + 'px' },600,function(){
		$self.css({marginTop:0}).find('li:first').appendTo($self);
	})
}