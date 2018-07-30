$(document).ready(function(){
	
	var uid = $("#dataUid").attr('data-id'),
		title,
		link;

	$('#saveData').click(function(){

		title = $("#id_title").val();
		link = $("#id_link").val();


		if(title == ""){
			$("#id_title").focus();
		}else if(link == ""){
			alert("链接不能为空！");
		}

		var data = {"title":title,"link":link,"uid":uid};

		 console.log(data);
		if(title !== ""){
			$.post("?_a=sp&_u=api.add_link",data,function(ret){
				console.log(ret);
				ret = $.parseJSON(ret);
				if(ret.errno == 0){
					showTip('ok', "保存成功", 1000);
					window.location = document.referrer;
				}else{
					showTip('err', "保存失败", 1000);
				}
				
				
				
			});
		}
		
	});
});	
