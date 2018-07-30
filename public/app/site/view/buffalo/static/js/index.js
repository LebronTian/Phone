$(function(){

	// 最新消息切换
	$('.news_cats').find('li').click(function(){
		var num = $(this).index();
		$('.news_cats').find('li').removeClass('cats_active');
		$(this).addClass('cats_active');
		$('.news_cont').removeClass('cont_active');
		$('.news_cont').eq(num).addClass('cont_active');
	});

});

// 首页menu
        // 左右菜单版本
    // $(document).ready(function(){
    //   $('#pop').on('click', function(){
    //         $(".popupLeft").show().removeClass('popoutLeft'); 
    //         $(".popupRight").show().removeClass('popoutRight'); 
    //   });
    //    $('#popclose').on('click', function(){
        
    //         // $(".popup").addClass('popup_out'); 
    //         $(".popupLeft").addClass('popoutLeft').fadeOut(); 
    //         $(".popupRight").addClass('popoutRight').fadeOut(); 
    //   });
    // });
    $(document).ready(function(){
       $("#pop").mouseover(function(){
          console.log('hover');
          $(".popupRight").show().removeClass('popoutRight'); 
        });
       $(".popup").mouseleave(function(){
          console.log("blur");
         $(".popupRight").addClass('popoutRight').fadeOut();
       });
    });

    $(document).ready(function(){
      // $('#pop').on('click', function(){
      //   if ($(".popupRight").is(":hidden")) {
      //     $(".popupRight").show().removeClass('popoutRight'); 
      //   }else{
      //     $(".popupRight").addClass('popoutRight').fadeOut();
      //   } 
      // });
     
    });