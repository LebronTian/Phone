function hover(){
    var $sideBar = $("#sideBar");
    var sideBarOffsetTop = $sideBar.offset().top;
    var $sideBarLis = $sideBar.children();

    $sideBarLis.hover(function(){
        var $currentLi = $(this);
        var top = $currentLi.offset().top - sideBarOffsetTop;
        var tops = top + "px";
        $("div.floatr").animate({
            top:tops
        },10);
    },function(){
        var $activeLi = $sideBar.find("li.active");
        var top = $activeLi.offset().top - sideBarOffsetTop;
        var tops = top + "px";
        $("div.floatr").stop().animate({
            top:tops
        },10);
    });

    $sideBarLis.click(function(){
        $sideBarLis.removeClass("active");
        $(this).addClass("active");
    });
};
hover();

$(document).ready(function(){
    var $sideBar = $("#sideBar");
    var $sideBarLis = $sideBar.children();
    var $sideBarAs = $sideBarLis.children();
    var $main = $("#main_right").children();
    $sideBarAs.click(function(){
        $main.attr("style","display:none;");

        var main_id= $(this).attr("name");
        $(main_id).attr("style","display:block;");
        $sideBarAs.attr("style","color:#333;");
        $(this).attr("style","color:#0e90d2");
    });
});