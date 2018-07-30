$(document).ready(function(){
	
	var ue = UE.getEditor('product-content'),
		uid = $("#dataUid").attr('data-id'),
		title,
		type,
		content,
		video_link;

	$('#saveData').click(function(){

		title = $("#id_title").val();
		type = $("#id_type").val();
		sort = $("#problem_sort").val();

		ue.ready(function(){
			content = ue.getContent();
		});

		if(title == ""){
			$("#id_title").focus();
		}else if(content == ""){
			alert("内容不能为空！");
		}

		var data = {"title":title,"type":type,"sort":sort,"content":content,"uid":uid};

		// console.log(data.title + "\n" + data.content);
		if(title !== "" && content !== ""){
			$.post("?_a=sp&_u=api.add_problem",data,function(ret){
				console.log(ret);
				ret = $.parseJSON(ret);
				if(ret.errno == 0){
					showTip('ok', "保存成功", 1000);
					window.location.href="?_a=sp&_u=index.problemlist";
				}else{
					showTip('err', "保存失败", 1000);
				}
				
				
				
			});
		}
		
	});
});	
