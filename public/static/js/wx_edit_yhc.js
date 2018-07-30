

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
		//var tmp = str.match(reg);
		$("#show").append(replace_mo(str));
        $("#saytext").val("")
	});

    /*
	$('#show').blur(function(){
		$('#showtext').text($(this).text());
	})*/

	/*表情文字
    这里保存的数据是[mo_？]的格式
    在使用前用if（tmp）转换成 XDD 的格式
    在显示的时候用replace_mo来转换成 <img> 的格式

    ！！！7-16实测修改
    直接保存的是XDD格式，直接使用保存的数据
    */
	$('.wx_edit_face').click(function(){

		var text = $('#show').html();

        /*将里面的<img>变成XDD符号*/
        console.log('text...',text);
        var newText3 =text.replace(/<img([^>]*)?>/g,function(img){
            var mo1 = img.replace(/<img src=.............................../, function () {
                return "[mo_"
            });
            var mo2 = mo1.replace(/.gif" border="0">/, function () {
                return "]"
            });//得到[mo_?]
            /*7.16*/
            mo2 = data[mo2].code+" ";//得到XDD

            return mo2;
        });

        newText3 = newText3.replace(/\n/g,"");
        newText3 = newText3.replace(/<br>/g,"\\n");
        newText3 = newText3.replace(/<div>/g,"\\n");
        newText3 = newText3.replace(/<\/div>/g,"");
        newText3 = newText3.replace(/(<(?!\/?(a)(\s|\>))[^>]*>)/g,'');
        newText3 = newText3.trim();

        // newText3 = newText3.replace(/&lt;/g,"<");
        // newText3 = newText3.replace(/&gt;/g,">");
        // newText3 = newText3.replace(/&nbsp;/g," ");
        console.log('newText3...',newText3);
        var dataUp = {
			media_type: 1,
			content: newText3
		};

		//如果为空则提示
		if(newText3.trim()==""){
            $("#show").attr("data-am-popover","{content: '文本不能为空', trigger: 'click'}").popover('open')
		}else{ //不为空时
            var link;
            var type = $("#show").attr("type");
            if(type=="add"){
                link = "?_a=sp&_u=api.add_media"
            }else{
                var id =$("#show").data("id");
                link = "?_a=sp&_u=api.add_media&uid="+id
            }
            $.post(link,dataUp,function(obj){
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
                        $(".text-close").click();
                        $(".page-list.list-1").children(".page-li").eq(0).click();
                        /*$('#info').show().text('保存成功！').css('background-color','green');
                         setTimeout(function(){
                         $('#info').hide();
                         },2000);*/
                    }
                }
                })
            })}
		

	});
	
	//单图文消息
	$('.wx_edit_sigle').click(function(){
		var title = $('.s_appmsg_title a').text();
		var description = $('.s_appmsg_desc').text();
		var picUrl = $('.s_appmsg_thumb_wrp').find('img').attr('src');
		var url = $('.s_frm_input_link').val();
        var author =$(".s_frm_input.s_frm_input_author").val();
        /*标题*/
        if((title.trim()=="")||(title.trim().length>64)||(title=="标题")){
            $(".s_frm_input.s_frm_input_tit").focus().popover('open');
            return
        }
        /*图片*/
        if(picUrl==""){
            $("#btn").focus().popover('open');
            return
        }
        if(author.trim().length>8){
            $(".s_frm_input.s_frm_input_author").focus().popover('open');
            return
        }else if(author.trim()==""){
            author="匿名"
        }
        /*摘要*/
        if(description.trim().length>120){
            $(".s_frm_textarea").focus().popover('open');
            return
        }
        /*地址选填注释*/
        //if(url.trim()==""){
        //    $(".s_frm_input.s_frm_input_link").focus().popover('open');
        //    return false
        //}
        /*正文*/
        //var text = "";
		var data = [{
			Title : title,
            //Author:author,
            //MainText:text,
			Description : description,
			PicUrl : picUrl,
			Url : url
		}];
        console.log(data);

		var Data = {media_type: 2, content: JSON.stringify(data)};
		
		//标题和图片为必填项不能为空
		if(data[0].Title !='' && data[0].PicUrl !=''){
            var link;
            var type = $(".wx_edit_sigle").attr("type");
            if(type=="add"){
                link ='?_a=sp&_u=api.add_media'
            }else{
                var id=$(".s_main_bd").attr("data-id");
                link='?_a=sp&_u=api.add_media&uid='+id
            }
			$.post(link,Data,function(obj){
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

                    $(".am-modal-hd").children(".am-close").click();
                    $(".page-list.list-2").children(".page-li").eq(0).click();

				}
			}})	
		})
		}else{
			$('#info').show().text('请填写完整标题栏和图片栏！');
			setTimeout(function(){
				$('#info').hide();
			},2000);
		}
		
	});

	//多图文消息
	$('.wx_edit_dabble').click(function(){
		var title_1 = $('#appmsgItem1 .title').text();
		var picUrl_1 = $('.appmsg_thumb_wrp').find('img').attr('src');
		var url_1 = $('.frm_input_link:eq(0)').val();
        /*验证***************/
        /*标题*/
        if((title_1.trim()=="")||(title_1.trim().length>64)||(title_1=="标题")){
            $("#appmsgItem1").click();
            $(".frm_input.frm_input_tit").eq(0).focus().popover('open');
            return false
        }
        /*图片*/
        if(picUrl_1==""){
            $("#appmsgItem1").click();
            $("#btn1").popover('open');
            return false
        }
        /*地址*/
        if(url_1.trim()==""){
            $("#appmsgItem1").click();
            $('.frm_input_link:eq(0)').focus().popover('open');
            return false
        }

        var more_pic =[{Title: title_1, Description: title_1,PicUrl: picUrl_1,Url: url_1}];
        var biaoji=false;
        $(".small-msg").each(function(){
            var title = $(this).children(".title_s").text();
            var pic = $(this).children(".msg_img").attr("src");
            var url = $(this).children(".msg-url").val();
            /*验证********************/
            if((title.trim()=="")||(title.trim().length>64)||(title=="标题")){
                $(this).click();
                $("#title_txt").focus().popover('open');
                biaoji=true;
                return false
            }
            if(pic==""){
                $(this).click();
                $("#btn11").popover('open');
                biaoji=true;
                return false
            }
            if(url.trim()==""){
                $(this).click();
                $(".frm_input.frm_input_link").eq(1).focus().popover('open');
                biaoji=true;
                return false
            }
            var msg={Title:title,PicUrl:pic,Url:url};
            more_pic.push(msg)
        });

        if(biaoji){
            return false
        }
        more_pic=JSON.stringify(more_pic);
		var data = {
			media_type: 3,
		    content: more_pic
		};
        console.log(data);
        //提交
        var link='?_a=sp&_u=api.add_media';
        if(!(g_media=="")){
            link='?_a=sp&_u=api.add_media&uid='+g_media.uid
        }
        $.post(link,data,function(obj){
            obj = $.parseJSON(obj);
            console.log(obj);
            uid = obj.data;
            window.location.href="/?_a=sp&_u=index.medialist";
            media_uid({callback:function(param){
                console.log(param.uid);
            }})
        })
	})
});


//查看结果
function replace_mo(str){
	str = str.replace(/\</g,'&lt;');
	str = str.replace(/\>/g,'&gt;');
	str = str.replace(/\n/g,'<br/>');
	str = str.replace(/\[mo_([0-9]*)\]/g,'<img src="/app/sp/static/images/arclist/$1.gif" border="0" />');
	return str;
}

function replace_XDD(str){
    //str = str.replace(/\</g,'&lt;');
    //str = str.replace(/\>/g,'&gt;');
    /**/
    str = str.replace(/\/:([^\s]*)?/g, function (XDD) {
        XDD = XDD.trim();
        //console.log("XDDD",str,XDD,!typeof transData[XDD]);
        if(typeof transData[XDD]=="undefined"){
            return XDD
        }
        return transData[XDD].code
    });
    return str;
}
