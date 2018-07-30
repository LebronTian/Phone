
$(function(){
$('.back').click(function(){
	window.history.back(-1); 
});
$('.person_pic').click(function(){
	window.location.href="?_a=site&_u=index.usercenter";
});
$('.classify_pic').click(function(){
	$('.nav_list').animate({'left':'0'});
});
$('.right_nav_box').click(function(){
	$('.nav_list').animate({'left':'-100%'});
})
$('.btn_search').click(function(){
	var key=$('.search_brief').val();
	if($.trim(key)!="")
	window.location.href='?_a=site&_u=index.search&key='+key;
});

$('.btn_reset').click(function(){
	$('.search_brief').val('');
});
});




