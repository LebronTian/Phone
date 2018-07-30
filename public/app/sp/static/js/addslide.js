$('.save').click(function(){
	var title = $('#id_title').val();
	var link= $('#id_link').val();
	var link_type= $('#id_link_type').val();

	var image = $('#id_img').attr('src');
	var sort = $('#id_sort').val();
	//var status = $('#id_status').val();
	var status = $('#id_status').prop('checked') ? 0 : 1;
    var uid = g_uid;
    var pos = $('#id_pos').val();
    var on_time = $('#id_on_time').val();
    var off_time = $('#id_off_time').val();

    if($.trim(image)==""){
		showTip('err','请上传一张图片',2000);
		return false
	}
    if(title.trim()==""){
        showTip('err','请输入说明',2000);
        return false
    }
    if(!pos){
        showTip('err','请选择幻灯片位置',2000);
        return false
    }

	var data = {uid:uid,title:title,link:link,link_type:link_type,image:image,sort:sort,status:status,pos:pos,on_time:on_time,off_time:off_time};

	$.post('?_a=sp&_u=api.addslide', data, function(ret){
		ret = $.parseJSON(ret);
		if (ret.errno==0) 
		{
			showTip('ok','保存成功',1000);
			setTimeout(function(){
               // history.back()
				window.location.href='?_a=sp&_u=index.slidelist&pos='+data.pos;
			},1000);
		}
		else
			showTip('err','保存失败',1000);
	});
});

