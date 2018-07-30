$(document).ready(function(){
	var img_width= $('.content_box a img').css('width');
	$('.content_box').css('height',img_width);
	$('.content_box a img').css('height',img_width);
	var num=parseInt($('.content_box').length);
	var c_height = (parseInt(img_width)+15)*Math.ceil(num/2);
	$('.detail_box').css('height',c_height+'px');
});
