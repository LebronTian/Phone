

$(function(){
	var face_code;
	var uid;
	
	//素材uid
	function media_uid(option){
		
		var param = {uid: uid};
		if(option.data) param = $.extend(param, option.data);
		option.callback && option.callback(param);	
	} 

	//弹出按钮
	$('.wx_btn').click(function(){
			$('.wx_edit_box').show();
			$('.wx_mask').show();
			$('.wx_edit_close').show();
	})

	//关闭按钮
	$('.wx_edit_close').click(function(){
		$('.wx_edit_box').hide();
		$('.wx_mask').hide();
		$(this).hide();
	})

	//选项切换
	var $myli=$(".wx_edit_nav li");
		$myli.click(function(){
		var index=$myli.index($(this));
		$(".wx_edit_cont>div").eq(index).show().siblings().hide();
		$(this).addClass('select').siblings().removeClass('select');
					
	});

	//表情消息
	$('.emotion').qqFace({
		id : 'facebox', 
		assign:'saytext', 
		path:'/app/sp/static/images/arclist/'	//表情存放的路径
	});

	

	$('.com_form').on('click','td',function(){
		var reg = /\[(.*?)\]/gi; 
		var str = $("#saytext").val();
		var tmp = str.match(reg);
		$("#show").append(replace_mo(str));
		$("#saytext").val('');//每添加一次后清空

		 if (tmp) {
                 for (var i = 0; i < tmp.length; i++) {
                     //console.log(tmp[i]); // 保留中括号
                     //alert(tmp[i].replace(reg, "$1")); // 不保留中括号
                     face_code = data[tmp[i]]['code'];
                     //console.log(face_code)

                    $('#showtext').append(face_code);
                     alert("face_code="+face_code)
                 }
         }
   		
	})

	$('#show').blur(function(){
		$('#showtext').text($(this).text());
	})

	//表情文字
	$('.wx_edit_face').click(function(){
		var text = $('#showtext').text();
        console.log("这里提交的text",text);
		var data = {
			media_type: 1,
			content: text
		}

		//如果为空则提示
		if(text ==""){
			$('#info').show().text('请填写内容再保存！');
			setTimeout(function(){
				$('#info').hide();
			},2000);
		}else{ //不为空时
			$.post('?_a=sp&_u=api.add_media',data,function(obj){
			obj = $.parseJSON(obj);
			uid = obj.data;
			media_uid({callback:function(param){
			//console.log(param.uid);	
			$('#dom').val(param.uid);
			if(param.uid>0){
                $('.prev_sigle .title').text(text);
                $('.prev_sigle .img_box').hide();
                $(".wx_edit_close").click();
                $("#AMalert").click();
				/*$('#info').show().text('保存成功！').css('background-color','green');
				setTimeout(function(){
					$('#info').hide();
				},2000);*/
			}
		  }
		})
	 })
		}
		

	})
	
	//单图文消息
	$('.wx_edit_sigle').click(function(){
		var title = $('.s_appmsg_title a').text();
		var description = $('.s_appmsg_desc').text();
		var picUrl = $('.s_appmsg_thumb_wrp').find('img').attr('src');
		var url = $('.s_frm_input_link').val();
		var data = [{
			Title : title,
			Description : description,
			PicUrl : picUrl,
			Url : url
		}];
		var Data = {media_type: 2, content: JSON.stringify(data)};
		
		//标题和图片为必填项不能为空
		if(data[0].Title !='' && data[0].PicUrl !=''){

			$.post('?_a=sp&_u=api.add_media',Data,function(obj){
			obj = $.parseJSON(obj);
			console.log(obj);
			uid = obj.data;
			media_uid({callback:function(param){
				console.log(param.uid);
				$('#dom').val(param.uid);
				if(param.uid >0){
                    $('.prev_sigle .title').text(title);
					$('.prev_sigle').find('img').attr('src',picUrl);
                    $('.prev_sigle .img_box').show();
                    $('.prev_sigle .foot').text(description);

                    $(".wx_edit_close").click();
                    $("#AMalert").click();

				}
			}})	
		})
		}else{
			$('#info').show().text('请填写完整标题栏和图片栏！');
			setTimeout(function(){
				$('#info').hide();
			},2000);
		}
		
	})

	//多图文消息
	$('.wx_edit_dabble').click(function(){

		var title_1 = $('#appmsgItem1 .title').text();
		var picUrl_1 = $('.appmsg_thumb_wrp').find('img').attr('src');
		var url_1 = $('.frm_input_link:eq(0)').val();
		var title_2 = $('#appmsgItem2 .title_s').text();
		var picUrl_2 = $('#appmsgItem2').find('img:eq(0)').attr('src');
		var url_2 = $('.frm_input_link:eq(1)').val();

		var title_3 = $('.main_bd #content').nextAll('div').eq(0).find('.title_s').text();
		var picUrl_3 = $('.main_bd #content').nextAll('div').eq(0).find('img:eq(0)').attr('src');
		var url_3 = $('.'+$('.main_bd #content').nextAll('div').eq(0).attr('id')).find('.frm_input_link').val();

		var data = {
			media_type: 3,
		    content: [
		    {Title: title_1, Description: title_1,PicUrl: picUrl_1,Url: url_1},
		    {Title: title_2, Description: title_2,PicUrl: picUrl_2,Url: url_2},
		    {Title: title_3, Description: title_3,PicUrl: picUrl_3,Url: url_3}
		   ]
		};
		
		//最多只能添加10条图文消息
		if($('.main_bd #content').nextAll('div').length > 9){
			$('.wx_err_info').show(400);
			setTimeout(function(){
				$('.wx_err_info').hide(400);
			},3000);

		//图文1和图文2为必填项，即最少应填写2条消息
		}else if(data.content[0].Title != ""&&data.content[0].PicUrl != ""&&data.content[1].Title != ""&&data.content[1].PicUrl != ""){
			$.post('?_a=sp&_u=api.add_media',data,function(obj){
				obj = $.parseJSON(obj);
				console.log(obj);
				uid = obj.data;
				media_uid({callback:function(param){
					console.log(param.uid);
				}})
			})
		}else{
			$('#info').show();
			setTimeout(function(){
				$('#info').hide();
			},3000);
			return false;
		}

		
	})
})


//查看结果
function replace_mo(str){
	str = str.replace(/\</g,'&lt;');
	str = str.replace(/\>/g,'&gt;');
	//str = str.replace(/\n/g,'<br/>');
	str = str.replace(/\[mo_([0-9]*)\]/g,'<img src="/app/sp/static/images/arclist/$1.gif" border="0" />');
	return str;
}



















