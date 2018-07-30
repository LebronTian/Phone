
$(function(){

    /***yhc*******判断是否编辑，加上编辑数据***********/
    if(!(g_media=="")){
        var json = g_media.content;
        console.log("jsonjson",json);
        /*大msg加载数据*/
        $(".frm_input.frm_input_tit").eq(0).val(json[0].Title);
        $("#appmsgItem1 .title").text(json[0].Title);
        $("#codeImgBox").show().children("img").attr("src",json[0].PicUrl);
        $(".appmsg_thumb").attr("src",json[0].PicUrl);
        $(".frm_input.frm_input_link").eq(0).val(json[0].Url);
        /*第二个小msg加载数据*/
        var kengdie =$("#appmsgItem2");
        kengdie.children(".title_s").text(json[1].Title);
        kengdie.children(".msg_img").attr("src",json[1].PicUrl);
        kengdie.children(".msg-url").val(json[1].Url);
        /****生成小msg,加载数据*******/
        var length = json.length-2;
        var smallMsg='';
        for(var cls = 0;cls<length;cls++){
            smallMsg+=
                '<div class="small-msg" id="appmsgItem'+(cls+3)+'" data-fileid="" data-id="'+(cls+3)+'">' +
                '<a href="#" class="title_s">'+json[cls+2].Title+'</a>' +
                '<img src="'+json[cls+2].PicUrl+'" class="msg_img" style="display: inline-block; float: right; background: url(http://localhost/app/sp/static/images/default2.png)  no-repeat;">' +
                '<input class="msg-url" type="hidden" value="'+json[cls+2].Url+'"><!--url记录-->' +
                '<a href="javascript:;" class="msg_edit_s">' +
                '<img class="edit_img" src="/app/sp/static/images/edit.png">' +
                '<img class="trash_img" src="/app/sp/static/images/trash.png">' +
                '</a>' +
                '</div>'
        }
        kengdie.after(smallMsg);
    }


    /*yhc*/
	var i=2;
	var appmsgItem;
			//点击创建元素
			$('#addItems').click(function(){
                var id = parseInt($(".small-msg").length)+1;
                if(id>7){
                    $(this).attr("data-am-popover","{content: '最多加入8条图文信息', trigger: 'click'}");
                    $(this).popover('open');
                    setTimeout('$("#addItems").popover("close")',1000);
                    return
                }
				$(this).before('<div class="small-msg" id="appmsgItem'+(id+1)+'" data-fileid data-id="'+(id+1)+'"><a href="#" class="title_s">标题</a><img src="" class="msg_img"><input class="msg-url" type="hidden"/><!--url记录--><a href="javascript:;" class="msg_edit_s"><img class="edit_img" src="/app/sp/static/images/edit.png"><img  class="trash_img" src="/app/sp/static/images/trash.png"></a></div>');

				$('#appmsgItem'+(id+1)+' .msg_img').css({'display':'inline-block',
												'float':'right','background':'url(/app/sp/static/images/default2.png) no-repeat','background-size':'100%'
										});
				//console.log($('#appmsgItem'+i+'').length);
			});

	
			//编辑
			$('#appmsgItem1').click(function(){
				$('.edit_area_b').show();
				$('.edit_area_s').hide();
			});
            //yhc  第二编辑框高度设定
            $('.msg_navLeft').on("click",".small-msg",function () {
                $('.edit_area_b').hide();
                var edit = $('.edit_area_s');
                edit.show();
                var id = $(this).attr("data-id");
                var height = (parseInt(id)-2)*53+107;
                edit.animate({marginTop:height});
                edit.attr("data-id",id);
                //初始化
                var brief =$(this).children(".title_s").text();
                if(brief=="标题"){
                    brief='';
                }
                var img = $(this).children(".msg_img").attr("src");
                var url = $(this).children(".msg-url").val();

                $(".edit_area_s .frm_input_tit").val(brief);
                if(img==""){
                    $(".appmsg_edit_item.fm_h_s").children("#codeImgBox").hide()
                }else{
                    $(".appmsg_edit_item.fm_h_s").children("#codeImgBox").children("#codeImg2").attr("src",img);
                    $(".appmsg_edit_item.fm_h_s").children("#codeImgBox").show()
                }
                $(".frm_input.frm_input_link").eq(1).val(url);
                $(".frm_input.frm_input_author").eq(1).val("")
            });
            //小标题栏输入
            $('.edit_area_s .frm_input_tit').keyup(function(){
                var id = $(".edit_area_s").attr("data-id");
                var text = $(this).val();
                if(text==""){
                    text="标题"
                }
                $('#appmsgItem'+id).children(".title_s").text(text);
            });

            $('.'+appmsgItem).find('.frm_input_author').keyup(function(){
                //作者栏输入
            });

            $('.appmsgItem').find('.frm_input_link').keyup(function(){
                //原文链接栏输入
                var id = $(".edit_area_s").attr("data-id");
                var text = $(this).val();
                $('#appmsgItem'+id).children(".msg-url").val(text);
            });
            //删除小栏目
            $('.msg_navLeft').on('click','.trash_img',function(){
                appmsgItem=$(this).parent().parent().attr('id');
                $('#'+appmsgItem).remove();
                $('.'+appmsgItem).remove();
            });
            //大标题栏输入
			$('.edit_area_b .frm_input_tit').keyup(function(){
				$('.title').text($(this).val());
				if($(this).val()==""){
					$('.title').text('标题');
				}
			})
			$('.edit_area_b .frm_input_author').keyup(function(){
				//作者栏输入
				
			})
			$('.edit_area_b .frm_input_link').keyup(function(){
				//原文链接输入
				
			})




	//点击删除移除图片
	$('#codeImgBox .delete_img').click(function(){
		$('#codeImgBox').find('img').attr('src','');
		$('#codeImgBox').hide();
		$('.fm_h').css('height','95px');
        $('.appmsg_thumb_wrp').find('img').attr('src','');
	})

	

})