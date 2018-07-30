$('.save').click(function(){
	var title = $('#id_title').val();
	var seo= $('#id_seo').val();
	var stat= $('#id_stat').val();
	var language= $('.option_parent').val();
	var logo = $('#id_img').attr('src');
	var status = $('#id_status').prop('checked') ? 0 : 1;
	var phone = $('#id_phone').val();
	
	if($.trim(title)==""){
		showTip('网站名称不能为空',1000);
		return false;
	}
	
	var data = {title:title,seo_words:seo,phone:phone,stat_code:stat,language:language,logo:logo,status:status};
	$.post('?_a=site&_u=api.set', data, function(ret){
		ret=$.parseJSON(ret);
		if(ret.errno==0){
			showTip('','保存成功','1000');
			setTimeout(function () {
				window.location.reload()
			},1000);
		}
		else{
			showTip('保存失败,错误:'+ret.errno,1000);
		}
	});
});

