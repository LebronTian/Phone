$(document).ready(function(){
	
	/*
		已安装和未安装数目
	*/
	$.post('?_a=sp&_u=api.plugin_use_status',function(ret){
		var ret = JSON.parse(ret);
		var installed_count = ret.data.has_installed_count;
		$('.has_installed').text(installed_count);
		$('.none_installed').text(ret.data.count - installed_count);
	});
	
	/*
		根据是否设置公众号隐藏公众号设置和发文章
		status = 1 已设置
		status = 0 未设置	
	*/
	var status = 1;
	if(status==0){
		$('.show_or_hide').hide();
	}else{
		$('.show_or_hide').show();
	}

});