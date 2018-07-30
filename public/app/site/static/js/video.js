$(".save").click(function(){

	var describle = $("#video_describe").val(),
		image = $("#video_img").attr("src"),
		address = $("#video_address").val(),
		uid = $("#video_uid").val(),
		sort = $('#id_sort').val(),
		address_val = address.substring(0,11);

		// console.log(address_val);
		if(address_val !== "http://v.qq" && address_val !== "http://v.yo"){
			alert("视频地址不能为空,本网站只支持腾讯优酷视频哦。");
			$("#video_address").focus();
		}else if(describle == ""){
			alert("视频描述不能为空");
			$("#video_describe").focus();
		}else if(image == undefined){
			alert("还没有选择图片哦");
		}
		// alert(image);

		var data = {uid:uid,address:address,describle:describle,image:image,sort:sort}
		console.log(data);
		if((describle !== "" && image !== undefined)&&(address_val == "http://v.qq" || address_val == "http://v.yo")){
			$.post("?_a=site&_u=api.add_video" , data , function(ret){
				ret = $.parseJSON(ret);
				console.log(ret);
				if(ret.errno == "0"){
					showTip('ok','保存成功',1000);
					setTimeout(function(){
						window.location.href = '?_a=site&_u=sp.videolist';
					},1000);
					
				}else{
					showTip('false','保存失败')
				}
			});
		}
});

(function(){
	var delete_videos = $(".delete_video"),
		check_videos = $(".check_video"),
		wrap_videos = $(".wrap_video");

	$(".vcheckall").click(function(){
		if($(this).is(':checked')){
			$.each(check_videos,function(n,value){
				check_videos[n].checked = true;
			});
		}else{
			$.each(check_videos,function(n,value){
				check_videos[n].checked = false;
			});
		}
	});
	

	$('.vstatus').click(function(){
		var uid = $(this).parent().parent().attr('data-id');
		var status = $(this).attr('data-status');
		console.log(uid, status);
		// console.log($(this).parent().parent().attr('class'));
		var data = {uid:uid, status:1-status};
		$.post('?_a=site&_u=api.add_video', data, function(ret){
			console.log(ret);
			window.location.reload();
		});
		
	});


	$.each(delete_videos,function(n,value){
		// console.log(value.name + "\n");
		delete_videos[n].onclick = function(){
			if(window.confirm("确定要删除么?")){
				delete_post(value.name,n);
			}
		}
		$(".vdeleteall").click(function(){
			if(check_videos[n].checked == true){
				delete_post(value.name,n);
			}
		});
	});

	function delete_post(uids,n){
		if(!(uids instanceof Array)) {
			uids = [uids];
		}

		var data = {uids: uids.join(';')}
		$.post("?_a=site&_u=api.delete_video" , data , function(ret){
			ret = $.parseJSON(ret);
			console.log(ret);

			if(ret.errno == "0"){
				wrap_videos[n].style.display = "none";
			}else{
				alert("删除失败");
			}
		});
	}

})()
















