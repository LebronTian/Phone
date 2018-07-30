$('.save').click(function(){
	var color1 = $('#id_color1').val();
	var color2 = $('#id_color2').val();
	if(!color1) {
		showTip('err', '颜色不能为空',1000);
		return false;
	}
	if(!color2) {
		//showTip('err', '颜色不能为空2',1000);
		//return false;
	}
	
	var theme = $('.cselected').attr('theme');

	var data = {color1:color1,color2:color2, theme:theme};
	//console.log(data);
	$.post('?_a=shop&_u=api.setcolors', data, function(ret){
		ret=$.parseJSON(ret);
		console.log(ret);
		if(ret.errno=="0")
			showTip('ok', '保存成功', 1000);
		else
			showTip('ok', '保存失败',1000);
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
$(document).on('click','.close_show',function(){
	$('.moveBar').remove();
});
$(document).on('click','#back',function(){
	window.history.back(-1);
});

$('.ccolor').click(function(){
	$('.ccolor').removeClass('cselected');
	$(this).addClass('cselected');
	$('#id_color1').val($(this).attr('color'));
	$('#id_color1').css({'background': '#'+$(this).attr('color')});
});

