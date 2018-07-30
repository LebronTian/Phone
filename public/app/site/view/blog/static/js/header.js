$(function(){
	function navNum(){
		var nav_left_num = $('.nav_left').find('li').length;
		var nav_right_num = $('.nav_right').find('li').length;
		var left_li_width = 440/nav_left_num*0.75 + "px";
		var left_li_padding = 440/nav_left_num*0.25 + "px";
		var right_li_width = 440/nav_right_num*0.75 + "px";
		var right_li_padding = 440/nav_right_num*0.25 + "px";
		$('.nav_left').find('li').css({
			width:left_li_width,
			"padding-right":left_li_padding
		});
		$('.nav_right').find('li').css({
			width:right_li_width,
			"padding-left":right_li_padding
		});
	}
	navNum();

	$(".nav_a").each(function(){  
        $this = $(this);  
        if($this[0].href==String(window.location)){  
            $this.removeClass('nav_a').addClass('a_active');  
        }  
    }); 
})