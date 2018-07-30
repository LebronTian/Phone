
document.writeln("<div class=\"mask\"></div>");
document.writeln("              <div class=\"dialog_box\">");
document.writeln("                <div class=\"dialog_wrp\">");
document.writeln("                  <div><span>选择图片</span></div>");
document.writeln("                  ");
document.writeln("                  <div class=\"upload_box\" style=\"clear:both;margin-bottom:10px;width:100px;position:absolute;right:52px;top:58px;\">");
document.writeln("                    ");
document.writeln("                    <form action=\"?_a=upload&_u=index.upload\" runat=\"server\" enctype=\"multipart/form-data\">");
document.writeln("                          <input type=\"file\" name=\"file\" id=\"file_upload_tk\"/>                        ");
document.writeln("                    </form> ");
document.writeln("");
document.writeln("                  </div>");
document.writeln("                  <div style=\"height:40px;\"></div>");
document.writeln("                  <ul class=\"img_list\"　style=\"clear:both;width:690px;margin-top:20px;\">");
document.writeln("                    <li><img src=\"\"><span>&radic;</span></li>");
document.writeln("                    <li><img src=\"\"><span>&radic;</span></li>");
document.writeln("                    <li><img src=\"\"><span>&radic;</span></li>");
document.writeln("                    <li><img src=\"\"><span>&radic;</span></li>");
document.writeln("                    <li><img src=\"\"><span>&radic;</span></li>");
document.writeln("                    <li><img src=\"\"><span>&radic;</span></li>");
document.writeln("                    <li><img src=\"\"><span>&radic;</span></li>");
document.writeln("                    <li><img src=\"\"><span>&radic;</span></li>");
document.writeln("                    <li><img src=\"\"><span>&radic;</span></li>");
document.writeln("                    <li><img src=\"\"><span>&radic;</span></li>");
document.writeln("                   ");
document.writeln("                  </ul>");
document.writeln("");
document.writeln("                  <div class=\"page\">");
document.writeln("                  </div>");
document.writeln("");
document.writeln("                   <div class=\"select_box\"><button class=\"am-btn am-btn-success selete_btn\">确认</button><button class=\"am-btn selete_canel\">取消</button></div>");
document.writeln("                </div>");
document.writeln("                <span class=\"dialog_close\">&times</span>");
document.writeln("");
document.writeln("              </div>");


$(function(){
	
	var imgSrc;
	/*
		选择图片
		$btn 选择按钮，jquery对象
		option = {
			callback : //选中确认回调函数 function(param) {imgSrc: 图片地址， data: option.data}
			data: 回调参数
			multiple: //todo 支持多选
		}
	*/
	function select_img($btn, option) {
		$btn.click(function(event){
		var page = 0;
		var limit = 10;
		var data = {
			page:page,
			limit:limit
		} 
		
		$('.dialog_wrp').show();
		$('.dialog_close').show();
		$('.mask').show();

		$.post('?_a=upload&_u=index.sp_img_list',data,function(obj){
			obj = $.parseJSON(obj);
			//console.log(obj);		
			//console.log(obj.data.pagination)
			var page=obj.data.pagination;
			$('.page').html(page);
			for(var i=0; i<obj.data.list.length; i++){
				var imgpath=obj.data.list[i].url;
				$('.img_list li:eq('+i+')').find('img').attr('src',imgpath);
			}
			
		})

		//先隐藏显示层
		$('.img_list li').find('span').hide();
		//点击图片显示选中层
		$('.dialog_wrp').on('click','.img_list li',function(){
			$(this).find('span').show();
		 	$(this).siblings().find('span').hide();
		 	imgSrc=$(this).find('img').attr('src');
		});

		 

		//确定选择，执行回调
		$('.selete_btn').on('click', function(){
			$('.dialog_wrp').hide();
		 	$('.dialog_close').hide();
		 	$('.mask').hide();
		 	$('#default_img').hide();
		 	$('.jc-demo-box').show();

            /*????????yhc
    		var imguidm=$('.jc-demo-box').children('img').attr('src');
    		console.log(imguidm);
    		var reg=new RegExp("(^|&)"+"uidm"+"=([^&]*)(&|$)");
    		var r=imguidm.match(reg);
    		if(r!=null)
    		$('#fcrop_btn').attr('data-uidm',unescape(r[2]));
    		console.log(unescape(r[2]));*/

			var param = {imgSrc: imgSrc};

		 	
		 	$("<img/>").attr("src",param.imgSrc).load(function(){
		 		if(this.height>559){
		 		$('.jc-demo-box').css({'display':'block','width':'600px','height':'559px'});
  				$('#headImgBox').css({'height':'559px'});
  				}
  				else if(this.height>200){
		 		$('.jc-demo-box').css({'display':'block','width':'600px','height':this.height+'px'});
  				$('#headImgBox').css({'height':this.height+'px'});
  				}
  				else {
  					$('.jc-demo-box').css({'display':'block','width':'600px','height':'200px'});
  				$('#headImgBox').css({'height':'200px'});
  				}
		 		if(this.width>600){
		 			if(this.height>559){
						$('#headImgBox ').children().find('img').css({'width':'600px','height':'559px'});
						
						$('.jcrop-holder ').css({'width':'600px','height':'559px','background-color':'white'});
		 			}
		 			else if(this.height>200){
		 				$('#headImgBox').children().find('img').css({'width':'600px','height':this.width+'px'});
		 				
		 				$('.jcrop-holder').css({'width':'600px','height':this.width+'px','background-color':'white'});
		 			}
		 			else{
		 				$('#headImgBox').children().find('img').css({'width':'600px','height':'200px'});
		 				
		 				$('.jcrop-holder').css({'width':'600px','height':'200px','background-color':'white'});
		 			}
		 		}		
		 		else if (this.width>200)
		 		{
		 			if(this.height>559){
						$('#headImgBox').children().find('img').css({'width':this.width+'px','height':'559px'});
						
						$('.jcrop-holder').css({'width':this.width+'px','height':'559px','background-color':'white'});
		 			}
		 			else if(this.height>200){
		 				$('#headImgBox').children().find('img').css({'width':this.width+'px','height':this.width+'px'});
		 				
		 				$('.jcrop-holder').css({'width':this.width+'px','height':this.width+'px','background-color':'white'});
		 			}
		 			else{
		 				$('#headImgBox').children().find('img').css({'width':this.width+'px','height':'200px'});
		 				
		 				$('.jcrop-holder').css({'width':this.width+'px','height':'200px','background-color':'white'});
		 			}
		 		}
		 		else
		 		{
		 			if(this.height>559){
						$('#headImgBox').children().find('img').css({'width':'200px','height':'559px'});
						
						$('.jcrop-holder').css({'width':'200px','height':'559px','background-color':'white'});
		 			}
		 			else if(this.height>200){
		 				$('#headImgBox').children().find('img').css({'width':'200px','height':this.width+'px'});
		 				
		 				$('.jcrop-holder').css({'width':'200px','height':this.width+'px','background-color':'white'});
		 			}
		 			else{
		 				$('#headImgBox').children().find('img').css({'width':'200px','height':'200px'});
		 				
		 				$('.jcrop-holder').css({'width':'200px','height':'200px','background-color':'white'});
		 			}
		 		}	
		 	});





			if(option.data) param = $.extend(param, option.data);
			option.callback && option.callback(param);	

		});
	});

	//分页
	$('.page').on('click','.am-pagination li:eq(0) a',function(event){
		event.preventDefault(); 
	});
	$('.page').on('click','.am-pagination li:last a',function(event){
		event.preventDefault(); 
	});
	//第一页
	$('.page').on('click','.am-pagination li:eq(1) a',function(event){
		var page = 0;
		var limit = 10;
		var data = {
			page:page,
			limit:limit
		} 
		$.post('?_a=upload&_u=index.sp_img_list',data,function(obj){
			obj = $.parseJSON(obj);
			//console.log(obj);		
			//console.log(obj.data.pagination)
			var page=obj.data.pagination;
			$('.page').html(page);
			for(var i=0; i<obj.data.list.length; i++){
				var imgpath=obj.data.list[i].url;
				$('.img_list li:eq('+i+')').find('img').attr('src',imgpath);
			}
			
		})
		event.preventDefault(); 
	})
	
	//第二页
	$('.page').on('click','.am-pagination li:eq(2) a',function(event){
		var page = 1;
		var limit = 10;
		var data = {
			page:page,
			limit:limit
		} 
		$.post('?_a=upload&_u=index.sp_img_list',data,function(obj){
			obj = $.parseJSON(obj);
			//console.log(obj);		
			//console.log(obj.data.pagination)
			var page=obj.data.pagination;
			$('.page').html(page);
			for(var i=0; i<obj.data.list.length; i++){
				var imgpath=obj.data.list[i].url;
				$('.img_list li:eq('+i+')').find('img').attr('src',imgpath);
			}
			
		})
		event.preventDefault(); 
	})
	//第三页
	$('.page').on('click','.am-pagination li:eq(3) a',function(event){
		var page = 2;
		var limit = 10;
		var data = {
			page:page,
			limit:limit
		} 
		$.post('?_a=upload&_u=index.sp_img_list',data,function(obj){
			obj = $.parseJSON(obj);
			//console.log(obj);		
			//console.log(obj.data.pagination)
			var page=obj.data.pagination;
			$('.page').html(page);
			for(var i=0; i<obj.data.list.length; i++){
				var imgpath=obj.data.list[i].url;
				$('.img_list li:eq('+i+')').find('img').attr('src',imgpath);
			}
			
		})
		event.preventDefault(); 
	})
	//第四页
	$('.page').on('click','.am-pagination li:eq(4) a',function(event){
		var page = 3;
		var limit = 10;
		var data = {
			page:page,
			limit:limit
		} 
		$.post('?_a=upload&_u=index.sp_img_list',data,function(obj){
			obj = $.parseJSON(obj);
			//console.log(obj);		
			//console.log(obj.data.pagination)
			var page=obj.data.pagination;
			$('.page').html(page);
			for(var i=0; i<obj.data.list.length; i++){
				var imgpath=obj.data.list[i].url;
				$('.img_list li:eq('+i+')').find('img').attr('src',imgpath);
			}
			
		})
		event.preventDefault(); 
	})
	//第五页
	$('.page').on('click','.am-pagination li:eq(5) a',function(event){
		var page = 4;
		var limit = 10;
		var data = {
			page:page,
			limit:limit
		} 
		$.post('?_a=upload&_u=index.sp_img_list',data,function(obj){
			obj = $.parseJSON(obj);
			//console.log(obj);		
			//console.log(obj.data.pagination)
			var page=obj.data.pagination;
			$('.page').html(page);
			for(var i=0; i<obj.data.list.length; i++){
				var imgpath=obj.data.list[i].url;
				$('.img_list li:eq('+i+')').find('img').attr('src',imgpath);
			}
			
		})
		event.preventDefault(); 
	})
	//第六页
	$('.page').on('click','.am-pagination li:eq(6) a',function(event){
		var page = 5;
		var limit = 10;
		var data = {
			page:page,
			limit:limit
		} 
		$.post('?_a=upload&_u=index.sp_img_list',data,function(obj){
			obj = $.parseJSON(obj);
			//console.log(obj);		
			//console.log(obj.data.pagination)
			var page=obj.data.pagination;
			$('.page').html(page);
			for(var i=0; i<obj.data.list.length; i++){
				var imgpath=obj.data.list[i].url;
				$('.img_list li:eq('+i+')').find('img').attr('src',imgpath);
			}
			
		})
		event.preventDefault(); 
	})

};

	//单图文选择
	select_img($('#btn'), {callback: function(param){
		//console.log('callback....', param);
		$('.s_appmsg_thumb_wrp').find('img').attr('src',param.imgSrc);
		$('#s_codeImgBox').show();
	 	$('#s_codeImgBox').find('img').attr('src', param.imgSrc);
	},
	//data: {test: 1}
	});

	//多图文选择
	select_img($('#btn1'), {callback: function(param){
	 	$('#appmsgItem1 .appmsg_thumb_wrp').find('img').attr('src',param.imgSrc);
		$('#codeImgBox').show();
	 	$('#codeImgBox').find('img').attr('src', param.imgSrc);
	}
	});

	select_img($('#btn11'), {callback: function(param){
        var box = $(".edit_area_s");
        var id = box.attr("data-id");
	 	$('#appmsgItem'+id).children(".msg_img").attr('src',param.imgSrc);
        box.find('#codeImgBox').show();
        box.find('#codeImgBox').find('img').attr('src', param.imgSrc);
    }
    });



	//商户资料二维码上传
	select_img($('#btn21'), {callback: function(param){
	 	$('#codeImgBox').find('img').attr('src', param.imgSrc);
	},
	});



	//商户资料头像上传
	select_img($('#btn22'), {callback: function(param){
	 	

         
                  $('#fcrop_btn').show();
                  $('.def_img').hide();

                
                  $('#headImgBox').find('img').attr('src',param.imgSrc);
               
                 function request(paras){ 
         
                     var url=str;
                     var paraString = url.substring(url.indexOf("?")+1,url.length).split("&"); 
                     var paraObj = {} 
                      for (i=0; j=paraString[i]; i++){ 
                      paraObj[j.substring(0,j.indexOf("=")).toLowerCase()] = j.substring(j.indexOf("=")+1,j.length); 
                      } 
                      var returnValue = paraObj[paras.toLowerCase()]; 
                     if(typeof(returnValue)=="undefined"){ 
                     return ""; 
                     }else{ 
                     return returnValue; 
                     } 
                 }
                 tmp=request("uidm");
	},
	});

	/*for(i=2; i<20; i++) {

		select_img($('#btn'+i+''), {callback: function(param){
			console.log('callback....', param);
		 	$('#appmsgItem'+i+' img').eq(0).attr('src',param.imgSrc);
		 	//console.log($('#appmsgItem'+i+' img'))
		 	$('.appmsgItem'+i+' .fm_h_s').css('height','172px');
			$('.appmsgItem'+i+' #codeImgBox').show().css({'margin-top':'32px'});
		 	$('.appmsgItem'+i+' #codeImgBox').find('img').attr('src', param.imgSrc);
			},
		});

	}*/


	//关闭按钮
	$('.dialog_close').click(function(){
		$('.dialog_wrp').hide();
	 	$('.dialog_close').hide();
	 	$('.mask').hide();
	})	
	//取消按钮
	$('.selete_canel').click(function(){
		$('.dialog_wrp').hide();
	 	$('.dialog_close').hide();
	 	$('.mask').hide();
	})

})




