$(function() {
	//头部
	$(".header-right li > a").each(function() {
		//操作以及导航菜单
		$(this).click(function() {
			if($(this).siblings().hasClass("erjilsm")) {
				$(".header-right li .erjilsm").removeClass("vtar");
				$(this).siblings(".erjilsm").addClass("vtar");
				if($(this).parent().hasClass("civer")) {
					$(this).find(".iconfont").removeClass("xuanzlse");
					$(this).siblings(".erjilsm").slideUp(150, function() {
						$(this).parent().removeClass("civer");
					});
				}
				else {
					$(".header-right li .iconfont").removeClass("xuanzlse");
					$(".header-right li .erjilsm").slideUp(150, function() {
						$(this).parent().removeClass("civer");
					});
					$(this).parent().addClass("civer");
					$(this).find(".iconfont").addClass("xuanzlse");
					$(this).siblings(".erjilsm").slideDown(150);
				}
				return false;
			}
			else {
				$(".header-right li > a span.iconfont").removeClass("xuanzlse");
				$(".header-right li .erjilsm").slideUp(150, function() {
					$(this).parent().removeClass("civer");
				});
			};
		});
		//操作二级导航菜单
		$(this).siblings(".erjilsm").click(function() {
			$(this).siblings("a").find("span.iconfont").removeClass("xuanzlse");
			$(this).slideToggle(150, function() {
				$(this).parent().toggleClass("civer");
			});
		});
	});
	//展开和隐藏下拉菜单1
	$(".conter-left-div ul h3").each(function() {
		$(this).click(function() {
			$(this).find("span").toggleClass("xuanzlse")
			$(this).toggleClass("wonslt").siblings(".tckslp").slideToggle(200);
		})
	});
	//展开和收缩导航菜单1
	$(".conter-left h2").click(function() {
		$(this).find("span").toggleClass("icon-zhankaisanjidaohang16");
		$(this).parent().toggleClass("czksm");
	});
	//展开和隐藏下拉菜单2
	$(".conter-left2-div ul h3").each(function() {
		$(this).click(function() {
			if($(this).siblings().hasClass("tckslp")) {
				$(this).find("span").toggleClass("xuanzlse")
				$(this).siblings(".tckslp").slideToggle(200);
				return false;
			}
		})
	});
	//展开和隐藏导航菜单2
	$(".kzlst").click(function() {
		if($(this).hasClass("zy-sq")) {
			$(".conter-left2").css("z-index", "4").addClass("qckslt");
			$(this).removeClass("zy-sq").addClass("zy-zk");
			$(this).find("span").removeClass("icon-shouqisanjidaohang16").addClass("icon-zhankaisanjidaohang16");
		}
		else {
			$(".conter-left2").css("z-index", "1").removeClass("qckslt");
			$(this).removeClass("zy-zk").addClass("zy-sq");
			$(this).find("span").removeClass("icon-zhankaisanjidaohang16").addClass("icon-shouqisanjidaohang16");
		};
	});
	//展开和隐藏导航菜单3
	$(".kzlst2").click(function() {
		if($(this).hasClass("zy-zk2")) {
			$(".conter-rigfyos").css("z-index", "4").addClass("qckslt2");
			$(this).removeClass("zy-zk2").addClass("zy-sq2");
			$(this).find("span").removeClass("icon-zhankaisanjidaohang16").addClass("icon-shouqisanjidaohang16");
		}
		else {
			
			$(".conter-rigfyos").css("z-index", "1").removeClass("qckslt2");
			$(this).removeClass("zy-sq2").addClass("zy-zk2");
			$(this).find("span").removeClass("icon-shouqisanjidaohang16").addClass("icon-zhankaisanjidaohang16");
		};
	});	
	if(!$('.kzlst').hasClass('zy-sq')) {
		$('.kzlst').click();
	};
	$("input[type='number']").attr("min","0");
})

