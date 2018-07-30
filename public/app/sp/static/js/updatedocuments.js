$(document).ready(function(){
	
	var ue = UE.getEditor('product-content'),
		uid = $("#documentUid").attr('data-id'),
		title,
		content,
		video_link;

	$('#saveDocument').click(function(){

		title = $("#document_title").val();
		video_link = $("#video_link").val();
		ue.ready(function(){
			content = ue.getContent();
		});

		if(title == ""){
			$("#document_title").focus();
		}else if(content == ""){
			alert("内容不能为空！");
		}

		var data = {"title":title,"content":content,"video_link":video_link,"uid":uid};

		// console.log(data.title + "\n" + data.content);
		if(title !== "" && content !== ""){
			$.post("?_a=sp&_u=api.add_document",data,function(ret){
				console.log(ret);
				ret = $.parseJSON(ret);
				if(ret.errno == 0){
					showTip('ok', "保存成功", 1000);
					window.location.href="?_a=sp&_u=index.documentlist";
				}else{
					showTip('err', "保存失败", 1000);
				}
				
				
				
			});
		}
		
	});
});	
