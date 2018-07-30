$('.save').click(function(){
	var title = $('#id_title').val();
	var link= $('#id_link').val();
	var image = $('#id_img').attr('src');
	var sort = $('#id_sort').val();
	//var status = $('#id_status').val();
	var status = $('#id_status').prop('checked') ? 0 : 1;
    var uid = g_uid;
    var slides_in = $('input[name="deli-radio"]:checked').val();

    if($.trim(image)==""){
		showTip('err','请上传一张图片',2000);
		return false
	}
    if(title.trim()==""){
        showTip('err','请输入标题',2000);
        return false
    }
    if(slides_in==""){
        showTip('err','请选择幻灯片位置',2000);
        return false
    }

	var data = {uid:uid,title:title,link:link,image:image,sort:sort,status:status,slides_in:slides_in};

	$.post('?_a=shop&_u=api.addslide', data, function(ret){
		ret = $.parseJSON(ret);
		if (ret.errno==0) 
		{
			showTip('ok','保存成功',1000);
			setTimeout(function(){
                history.back()
			},1000);
		}
		else
			showTip('err','保存失败',1000);
	});
});


$('.saveSlide').click(function(){
    var title = $('#id_title').val();
    var link= $('#id_link').val();
    var image = $('#client-avatar').attr('src');
    var sort = $('#id_sort').val();
    //var status = $('#id_status').val();
    var status = $('#id_status').prop('checked') ? 0 : 1;
    var uid = g_uid;
    var slides_in = $('input[name="deli-radio"]:checked').val();

    if($.trim(image)==""){
        showTip('err','请上传一张图片',2000);
        return false
    }
    if(title.trim()==""){
        showTip('err','请输入标题',2000);
        return false
    }

    var data = {uid:uid,title:title,link:link,image:image,sort:sort,status:status,slides_in:slides_in};
    $.post('?_a=shop&_u=api.addslide', data, function(ret){
        ret = $.parseJSON(ret);
        if (ret.errno==0)
        {
            showTip('ok','保存成功',1000);
            setTimeout(function(){
                history.back()
            },1000);
        }
        else
            showTip('err','保存失败',1000);
    });
});

