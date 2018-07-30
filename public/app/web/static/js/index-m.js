
//$('.onloadNow').show();
$(window).load(function(){
	$('.onloadNow').hide();
	$('.mouse_t').hide();
	
	$('.logo').find('img').animate({opacity:'1'},500);
	$('#content6 .imgbox span').hide();
	$('#content7 .hidden').width('0');
	//$('#content3').find('img').css('opacity','0');
	setTimeout(function(){
		$('.word_01').animate({opacity:'1'},500);
	},200);
	setTimeout(function(){
		$('.word_02').animate({opacity:'1'},500);
	},400);
	$('#dowebok').fullpage({
		'verticalCentered':false,
		'navigation':false,
		afterLoad: function(anchorLink, index){
			if(index == 1){
				$('.mouse').show();
				$('.logo').find('img').animate({opacity:'1'},500);
				setTimeout(function(){
					$('.word_01').animate({opacity:'1'},500);
				},200);
				setTimeout(function(){
					$('.word_02').animate({opacity:'1'},500);
				},400);
			}
			if(index == 2){
				$('.mouse').hide();
				setTimeout(function(){
					$('#content2 .phone_t').animate({opacity:'1',left:'0px'},600);
				},200);
				setTimeout(function(){
					$('#content2 .phone_b').animate({opacity:'1',right:'0px'},600);
				},400);
				
			}
			if(index == 3){
				
				$('.mouse').hide();
				setTimeout(function(){
					$('#content3 .qiubai').find('img').animate({opacity:'1'},1000);
				},200);
				setTimeout(function(){
					$('#content3 .qinggan').find('img').animate({opacity:'1'},1000);
				},400);
				setTimeout(function(){
					$('#content3 .toutiao').find('img').animate({opacity:'1'},1000);
				},600);
				setTimeout(function(){
					$('#content3 .qiche').find('img').animate({opacity:'1'},1000);
				},800);
				setTimeout(function(){
					$('#content3 .jiankang').find('img').animate({opacity:'1'},1000);
				},1000);
				setTimeout(function(){
					$('#content3 .meishi').find('img').animate({opacity:'1'},1000);
				},1200);
			}
			if(index == 4){
				$('.mouse').hide();
				$('#content4 .imgbox span:eq(0)').fadeIn(400);
				setTimeout(function(){
					$('#content4 .imgbox span:eq(1)').fadeIn(400);
				},800);
				setTimeout(function(){
					$('#content4 .imgbox span:eq(2)').fadeIn(400);
				},1600);
			}
			if(index == 5){
				$('.mouse').hide();
				$('#content5 .imgbox .a').animate({right:'116px',opacity:'1'},500);
				setTimeout(function(){
					$('#content5 .imgbox .b').animate({right:'83px',opacity:'1'},500);
				},200);
				setTimeout(function(){
					$('#content5 .imgbox .c').animate({right:'56px',opacity:'1'},500);
				},400);
				setTimeout(function(){
					$('#content5 .imgbox .key').animate({left:'0px',opacity:'1'},500);
				},800);
			}
			if(index == 6){
				$('.mouse').hide();
				$('#content6 .imgbox span:eq(0)').fadeIn(500);
				setTimeout(function(){
					$('#content6 .imgbox span:eq(1)').fadeIn(500);
				},200);
				setTimeout(function(){
					$('#content6 .imgbox span:eq(2)').fadeIn(500);
				},400);
				setTimeout(function(){
					$('#content6 .imgbox span:eq(3)').fadeIn(500);
				},600);
			}
			if(index == 7){
				// $('.mouse_t').show();
				var w7 = $('#content7 .hidden');
				var timer = setInterval(function(){
					w7.width(parseInt(w7.width())+3+'px');
					if(w7.width()>=128){
						clearInterval(timer);
					}
				},5);
			}
			if(index == 8){
				$('.mouse_t').show();
				
			}
		},
		onLeave: function(index, direction){
			if(index == '1'){
				$('.logo').find('img').css('opacity','0');
				$('.word_01').css('opacity','0');
				$('.word_02').css('opacity','0');
			}
			if(index == 2){
				$('#content2 .phone_t').css({opacity:'0',left:'-200px'});
				$('#content2 .phone_b').animate({opacity:'0',right:'-200px'});
			}
			if(index == '3'){
				$('#content3 .qiubai').find('img').css({'opacity':'0'});
				$('#content3 .qinggan').find('img').css({'opacity':'0'});
				$('#content3 .toutiao').find('img').css({'opacity':'0'});
				$('#content3 .qiche').find('img').css({'opacity':'0'});
				$('#content3 .jiankang').find('img').css({'opacity':'0'});
				$('#content3 .meishi').find('img').css({'opacity':'0'});
			}
			if(index == '4'){
				$('#content4 .imgbox span').hide();
			}
			if(index == '5'){
				$('#content5 .imgbox .a,#content5 .imgbox .b,#content5 .imgbox .c').css({right:'-200px',opacity:'0'});
				$('#content5 .imgbox .key').css({left:'-300px',opacity:'0'});
			}
			if(index == '6'){
				$('#content6 .imgbox span').hide();
			}
			if(index == '7'){
				$('.mouse_t').hide();
				$('#content7 .hidden').width('0');
			}
		}
	});

});

$(document).ready(function(){
	$(".page8_btn1").click(function(){
		$("#shareTo").attr("style","display:block");
	});
	$("#shareTo").click(function(){
		$("#shareTo").attr("style","display:none");
	});

	
});