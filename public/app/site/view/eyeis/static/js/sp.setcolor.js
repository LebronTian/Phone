$('.save').click(function(){
	var color = $('#id_color').val();
	if(!color) {
		showTip('err', '颜色不能为空',1000);
		return false;
	}
	
	var data = {color:color};
	$.post('?_a=site&_u=sp.setcolor', data, function(ret){
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

