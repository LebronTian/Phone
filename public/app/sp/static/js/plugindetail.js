$('.install').click(function(){
	var dir = $(this).attr('data-name');
	var data = {dir: dir};
	$.post('?_a=sp&_u=index.plugindetail', data, function(ret){
		console.log(ret);
		if(!(ret = $.parseJSON(ret)) || !ret.data) {
			showTip('err', '错误! 您无权操作! 请联系客服!', 5000)
		}
		else {
			window.location.reload();
		}
	});
});

