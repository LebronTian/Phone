//百度富编辑器初始化
var ue = UE.getEditor('container');

var text;
$('.save').click(function(){
	ue.ready(function(){
      text = ue.getContent();
    });
	var content = text;
	var uid = g_uid;
	
	if($.trim(content)==""){
		showTip('err','内容不能为空',1000);
		return false;
	}


	var data = {uid:uid,content:content};
	$.post('?_a=sp&_u=api.add_feedback', data, function(ret){
		ret = $.parseJSON(ret);
		if(ret.errno==0){
			showTip('ok','保存成功',1000);
			setTimeout(function(){
				window.location.href='?_a=sp&_u=index.feedbacklist';}
				,1000)
		}
		else
			showTip('err','保存失败',1000);
	});
});




/*
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
*/


