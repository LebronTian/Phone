$(function(){
	$('.bigLogo').find('img').animate({opacity:'1'},500);
	setTimeout(function(){
		$('.conBox1 .tit_01').animate({opacity:'1'},500);
	},200);
	setTimeout(function(){
		$('.conBox1 .tit_02').animate({opacity:'1'},500);
	},400);
	$('.mouse_t').hide();

	$('#content6 .bottom .imgbox span').hide();
	$('#content7 .right .hidden').width('0');
	$('#dowebok').fullpage({
		'verticalCentered':false,
		'navigation': true,
		'navigationPosition': 'right',
		'slidesColor': ['#F0F2F4', '#fff', '#fff', '#fff'],
		afterLoad: function(anchorLink, index){
			if(index == 1){
				$('.mouse').show();
				$('.bigLogo').find('img').animate({opacity:'1'},500);
				setTimeout(function(){
					$('.conBox1 .tit_01').animate({opacity:'1'},500);
				},200);
				setTimeout(function(){
					$('.conBox1 .tit_02').animate({opacity:'1'},500);
				},400);
			}
			if(index == 2){
				$('#content8 .right_area .img1').fadeIn(400);
				setTimeout(function(){
					$('#content8 .right_area .img2').fadeIn(400);
				},300);
				setTimeout(function(){
					$('#content8 .right_area .img3').fadeIn(400);
				},600);
				setTimeout(function(){
					$('#content8 .right_area .img4').fadeIn(400);
				},900);
				setTimeout(function(){
					$('#content8 .right_area .img5').fadeIn(400);
				},1200);
				setTimeout(function(){
					$('#content8 .right_area .img7').fadeIn(400);
				},1500);
				setTimeout(function(){
					$('#content8 .right_area .img6').fadeIn(400);
				},1800);
			}
			if(index == 3){
				$('.mouse').hide();
				setTimeout(function(){
					$('#content2 .left .phone-t').animate({left:'76px',opacity:'1'},1000);
				},200);
				setTimeout(function(){
					$('#content2 .left .phone-b').animate({right:'76px',opacity:'1'},1000);
				},400);
			}
			if(index == 4){
				$('.mouse').hide();
				var time2;
				var time3;
				var time4;
				var time5;
				var time6;
				var time1 = setInterval(function(){
					var w1 = $('#content3 .right_area .qiubai').find('img');
					w1.width(parseInt(w1.width()) +2+'px');
					w1.height(parseInt(w1.height()) +2+'px');
					if(w1.width()>=102){
						clearInterval(time1);
					}
				},5);
				
				setTimeout(function(){
					time2 = setInterval(function(){
						var w2 = $('#content3 .right_area .qinggan').find('img');
						w2.width(parseInt(w2.width()) +2+'px');
						w2.height(parseInt(w2.height()) +2+'px');
						if(w2.width()>=88){
							clearInterval(time2);
						}
					},5);
					
				},200);
			
				setTimeout(function(){
					time3 = setInterval(function(){
						var w3 = $('#content3 .right_area .toutiao').find('img');
						w3.width(parseInt(w3.width()) +2+'px');
						w3.height(parseInt(w3.height()) +2+'px');
						if(w3.width()>=128){
							clearInterval(time3);
						}
					},5);
				},400);

				setTimeout(function(){
					time4 = setInterval(function(){
						var w4 = $('#content3 .right_area .qiche').find('img');
						w4.width(parseInt(w4.width()) +2+'px');
						w4.height(parseInt(w4.height()) +2+'px');
						if(w4.width()>=88){
							clearInterval(time4);
						}
					},5);
				},600);

				setTimeout(function(){
					time5 = setInterval(function(){
						var w5 = $('#content3 .right_area .jiankang').find('img');
						w5.width(parseInt(w5.width()) +2+'px');
						w5.height(parseInt(w5.height()) +2+'px');
						if(w5.width()>=102){
							clearInterval(time5);
						}
					},5);
				},800);

				setTimeout(function(){
					time6 = setInterval(function(){
						var w6 = $('#content3 .right_area .meishi').find('img');
						w6.width(parseInt(w6.width()) +2+'px');
						w6.height(parseInt(w6.height()) +2+'px');
						if(w6.width()>=68){
							clearInterval(time6);
						}
					},5);
				},1000);
				
			}
			if(index == 5){
				$('.mouse').hide();
				$('#content4 .left .imgbox span:eq(0)').fadeIn(400);
				setTimeout(function(){
					$('#content4 .left .imgbox span:eq(1)').fadeIn(400);
				},800);
				setTimeout(function(){
					$('#content4 .left .imgbox span:eq(2)').fadeIn(400);
				},1600);
			}
			if(index == 6){
				$('.mouse').hide();
				$('#content5 .right_area .imgbox .a').animate({right:'230px',opacity:'1'},500);
				setTimeout(function(){
					$('#content5 .right_area .imgbox .b').animate({right:'160px',opacity:'1'},500);
				},200);
				setTimeout(function(){
					$('#content5 .right_area .imgbox .c').animate({right:'80px',opacity:'1'},500);
				},400);
				setTimeout(function(){
					$('#content5 .right_area .imgbox .key').animate({left:'0px',opacity:'1'},500);
				},800);
			}
			if(index == 7){
				$('.mouse').hide();
				$('#content6 .bottom .imgbox span:eq(0)').fadeIn(500);
				setTimeout(function(){
					$('#content6 .bottom .imgbox span:eq(1)').fadeIn(500);
				},200);
				setTimeout(function(){
					$('#content6 .bottom .imgbox span:eq(2)').fadeIn(500);
				},400);
				setTimeout(function(){
					$('#content6 .bottom .imgbox span:eq(3)').fadeIn(500);
				},600);
			}
			if(index == 8){
				var w7 = $('#content7 .right .hidden');
				var timer = setInterval(function(){
					w7.width(parseInt(w7.width())+3+'px');
					if(w7.width()>=256){
						clearInterval(timer);
					}
				},5);
				$('.mouse_t').show();
				$('.mouse').hide();
				$('#beian').show();
			}
		},
		onLeave: function(index, direction){
			if(index == '1'){
				
				$('.bigLogo').find('img').css('opacity','0');
				$('.conBox1 .tit_01').css('opacity','0');
				$('.conBox1 .tit_02').css('opacity','0');
			}
			if(index == '2'){
				$('#content8 .right_area .position').hide();
			}
			if(index == '3'){
				
				setTimeout(function(){
					$('#content2 .left .phone-t').animate({left:'-300px',opacity:'0'},600);
				},200);
				setTimeout(function(){
					$('#content2 .left .phone-b').animate({right:'-300px',opacity:'0'},600);
				},400);
			}
			if(index == '4'){

				$('#content3 .right_area .qiubai').find('img').css({'width':'0px','height':'0px'});
				$('#content3 .right_area .qinggan').find('img').css({'width':'0px','height':'0px'});
				$('#content3 .right_area .toutiao').find('img').css({'width':'0px','height':'0px'});
				$('#content3 .right_area .qiche').find('img').css({'width':'0px','height':'0px'});
				$('#content3 .right_area .jiankang').find('img').css({'width':'0px','height':'0px'});
				$('#content3 .right_area .meishi').find('img').css({'width':'0px','height':'0px'});
			}
			if(index == '5'){
				$('#content4 .left .imgbox span').hide();
			}
			if(index == '6'){
				$('#content5 .right_area .imgbox .a,#content5 .right_area .imgbox .b,#content5 .right_area .imgbox .c').css({right:'-200px',opacity:'0'});
				$('#content5 .right_area .imgbox .key').css({left:'-300px',opacity:'0'});
			}
			if(index == '7'){
				$('#content6 .bottom .imgbox span').hide();
			}
			if(index == '8'){
				$('#content7 .right .hidden').width('0');
				$('.mouse_t').hide();
				$('#beian').hide();
			}
		}
	});

	

})