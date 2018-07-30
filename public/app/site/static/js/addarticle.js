//百度富编辑器初始化
var ue = UE.getEditor('container');

var text;
$('.save').click(function(){
	ue.ready(function(){
      text = ue.getContent();
    });
	var title = $('#id_title').val();
	var digest = $('#id_digest').val();
	var seo = $('#id_seo').val();
	var content = text;
	var cat_uid = $('.option_parent').val();
	var image = $('#id_img').attr('src');
	var image_icon = $('#id_img2').attr('src');
	var sort = $('#id_sort').val();
	//var status = $('#id_status').val();
	var status = $('#id_status').prop('checked') ? 0 : 1;
	var create_time = $('#id_create_time').val();
	var author = $('#id_author').val();
	var uid = g_uid;
	
	if($.trim(title)==""){
		showTip('err','标题不能为空',1000);
		return false;
	}
	if($.trim(content)==""){
		showTip('err','正文不能为空',1000);
		return false;
	}


	var data = {uid:uid,title:title,digest:digest,seo_words:seo,content:content,
		cat_uid:cat_uid,image:image,image_icon:image_icon,sort:sort,status:status,
		create_time: create_time,author:author};


	$.post('?_a=site&_u=api.addarticle', data, function(ret){
		ret = $.parseJSON(ret);
		console.log(ret);
		if(ret.errno==0){
			showTip('ok','保存成功',1000);
			setTimeout(function(){
				window.location.href='?_a=site&_u=sp.articlelist&cat_uid='+cat_uid;}
				,1000)
		}
		else
            showTip('err','保存失败',1000);
	});
});




var editersave=$.parseJSON(localStorage.getItem('ueditor_preference'));
console.log(editersave);
for(var name in editersave){
	console.log(editersave[name]);
	ue.ready(function(){
		text = ue.getContent();
		if($.trim(text)=="")
			ue.setContent(editersave[name]);
    });
	      
}

ue.ready(function(){
	$('#tabBodys #upload').remove();
$('#videoTab').children('#tabHeads').children().remove();
    });


