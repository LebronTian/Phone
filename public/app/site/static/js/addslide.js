$('.save').click(function(){
	var title = $('#id_title').val();
	var link= $('#id_link').val();
	var image = $('#id_img').attr('src');
	var sort = $('#id_sort').val();
	//var status = $('#id_status').val();
	var status = $('#id_status').prop('checked') ? 0 : 1;
	var uid = g_uid;
	
	if($.trim(image)==""){
		showTip('err','请上传一张图片',2000);
		return false
	}

	var data = {uid:uid,title:title,link:link,image:image,sort:sort,status:status};
	$.post('?_a=site&_u=api.addslide', data, function(ret){
		ret = $.parseJSON(ret);
		if (ret.errno==0) 
		{
			showTip('ok','保存成功',1000);
			setTimeout(function(){
				window.location.href='?_a=site&_u=sp.slidelist';
			},1000);
		}
		else
			showTip('err','保存失败',1000);
	});
});

