$('.choose_tpl').click(function(){

	var dir = $(this).attr('data-name');
	var data = {tpl:dir};
	console.log(data);
	$.post('?_a=site&_u=api.set', data, function(ret){
		ret=$.parseJSON(ret);
		if(ret.errno=="0"){
			showTip('保存成功',1000);
					window.location.reload();
		}
		else
			showTip('保存失败',1000);
	});
});

$('.show_tpl').click(function(){
	$('.moveBar').remove();
	var websrc=$(this).attr('data-src');
$('body').append('<div class="moveBar"><div id="back"></div><div id="banner">按住此处移动当前div</div><iframe src="'+websrc+'" class="content">这里是其它内容</iframe><img src="app/site/static/images/weixin.png" class="phone_png"><img src="app/site/static/images/close.png" class="close_show"></div> ');
		$('#banner').mousedown(function(event){ 
			var isMove = true; 
			var abs_x = event.pageX - $('div.moveBar').offset().left; 
			var abs_y = event.pageY - $('div.moveBar').offset().top; 
		$(document).mousemove(function (event) { 
			if (isMove) { 
			var obj = $('div.moveBar'); 
			obj.css({'left':event.pageX - abs_x, 'top':event.pageY - abs_y}); 
			} 
		});
		$(document).mouseup(function () { 
			isMove = false; 
			}); 
		}); 
});


var by_amaze_init = 1;
$('.option_type').change(function(){
	if(by_amaze_init) {
		by_amaze_init = 0;
		return;
	}

	var type = $(this).val();
	window.location.href='?_a=site&_u=sp.tpls&type=' + type;
});


$(document).on('click','.close_show',function(){
	$('.moveBar').remove();
});
$(document).on('click','#back',function(){
	window.history.back(-1);
});
$('.real_url').click(function(){
	$(this).parent().parent().children('.url_erweima').slideToggle();
})


$('#id_clear_site_data').click(function() {
	if(confirm('确定要继续吗？')) {
		$.get('?_a=site&_u=api.clear_site_data', function(ret) {
			console.log(ret);	
		});	
	}
});

