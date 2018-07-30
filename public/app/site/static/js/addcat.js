$('.save').click(function(){
	var title = $('#id_title').val();
	var title_en = $('#id_title_en').val();
	var parent_uid = $('.option_parent').val();
	var image = $('#id_img').attr('src');
	var image_icon = $('#id_img2').attr('src');
	var brief= $('#id_brief').val();
	var sort = $('#id_sort').val();
	//var status = $('#id_status').val();
	var status = $('#id_status').prop('checked') ? 0 : 1;
	var uid = g_uid;

	if($.trim(title)==""){
		showTip('err','分类名称不能为空',1000);
		return false;
	}

	var data = {uid:uid,title:title,title_en:title_en,parent_uid:parent_uid,image:image,sort:sort,status:status,image_icon:image_icon,brief:brief};
	$.post('?_a=site&_u=api.addcat', data, function(ret){
		ret = $.parseJSON(ret);
		if(ret.errno==0){
			showTip('ok','保存成功',1000);
			setTimeout(function(){window.location.href='?_a=site&_u=sp.catlist&parent_uid='+parent_uid;
	} ,1000);
		}
		else
			showTip('err','保存失败',1000);
		
});
});
   $('#search_pic').click(function(event){
      event.preventDefault();
   })
