$(function(){
// 	// 产品列表切换
// 	$('.product_left').find('.product_left>li').click(function(){
// 		console.log("hello!")
// 		var num = $(this).index();
// 		$('.product_left').find('.product_left>li').removeClass('active').addClass('notactive');
// 		$(this).removeClass('notactive').addClass('active');
// 		$('.product_box').hide();
// 		$('.product_box').eq(num).fadeIn(300);
// 	});

	$('.product_show').hover(function(){
		$(this).addClass('product_show_hover');
	},function(){
		$(this).removeClass('product_show_hover');
	});
});
// 一级联动	
$(".product_left>li>span").each(function() {
    $(this).bind("click", function() {
    	console.log("hello!")
        // 加上或者去掉active
        if(!$(this).parent().hasClass("active")){
           $(this).parent().addClass("active").removeClass("notactive").siblings().removeClass("active");
        }else{
          $(this).parent().removeClass("active").addClass("notactive");
        }
    });
  });
// 二级联动----------->阻止冒泡
$(".product_left>li>ul>li").each(function() {
    $(this).bind("click", function() {
    	 event.stopPropagation();
        // 加上或者去掉current
        if(!$(this).hasClass("current")){
           $(this).addClass("current").siblings().removeClass("current");;
        }else{
          $(this).removeClass("current");
        }
    });
  });
//三级联动
// $(".product_left>li>ul>li>ul>li").each(function() {
//     $(this).bind("click", function() {
//     	 event.stopPropagation();
//         // 跳转到指定页面
       
//     });
//   });