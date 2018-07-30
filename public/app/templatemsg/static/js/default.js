$(document).ready(function(){
    //第一次选中
	$('.am-radio[value='+g_msg_mode+']').click();
	$('a[href="#tab_'+g_type+'"]').click();
    /*回复信息预加载内容判断类型*/

        var type =parseInt(defaulfMedia["media_type"]);
        var data;
        switch (type){
            case 1:
                data=defaulfMedia["content"];
                break;
            case 2:
                data= defaulfMedia["content"][0];
                break;
            case 3:
                data=defaulfMedia["content"];
                break
        }
        previewBox(type,data);
    $("#dom").val(dftMediaId);
    /*无操作 机器人*/
    $(".newBtn").click(function () {
        var type = $(this).data("type");
        $.post('?_a=default&_u=sp.index',{type:type,content:" "},function(ret){
            showTip("","设置成功",1000);
            setTimeout(function () {
                window.location.reload()
            },1000)
        })
    });

});
/*生成浏览盒子功能
 * type为Int数字  1-文字；2-单图；3-多图
 * data为
 * */
function previewBox(type,data){
    var box="";
    switch (type){
        case 1:
            var content=replace_mo(data);
            box+=
                '<div class="text-box for-phonePre">'+content+'</div>';
            break;
        case 2:
            box+=
                '<div class="s_preview_area for-phonePre">'+
                '<h4 class="s_appmsg_title">'+
                '<a class="s_title" >'+data.Title+'</a>'+
                '</h4>'+
                '<div class="s_appmsg_thumb_wrp">'+
                '<img class="s_appmsg_thumb" src="'+data.PicUrl+'">'+
                '</div>'+
                '<p class="s_appmsg_desc">'+data.Description+'</p>'+
                '</div>';
            break;
        case 3:
            var json=data;
            console.log(data);
            box+=
                '<div style="overflow: hidden">' +

                '<div class="msg_navLeft for-phonePre">'+

                '<div id="appmsgItem1" data-fileid="" data-id="1">'+

                '<a class="title" >'+json[0].Title+'</a>'+

                '<div class="appmsg_thumb_wrp">'+

                '<img class="appmsg_thumb" src="'+json[0].PicUrl+'">'+
                '</div>'+

                '</div>';

            for(var i=1;json.length>i;i++){
                box+=
                    '<div class="small-msg" id="appmsgItem2" data-fileid="" data-id="2">'+

                    '<a class="title_s">'+json[i].Title+'</a>'+

                    '<img src="'+json[i].PicUrl+'" class="msg_img">'+

                    '</div>';
            }

            box+=
                '</div>' +


                '</div>';

            break;
    }
    $(".preview_box").html(box)
}
/********************************************
 * *保存按钮*/
$('.save').click(function(){
    var type = $('.am-tab-panel.am-active').attr('data-type');
    var msg_content = $('#id_msg').val();
    var media_uid = $('#dom').val();                                 //主要这id
    if(type=="msg"&&media_uid==""){
        return
    }
    var keyword = $('#id_keyword').val();
    var url = $('#id_url').val();
    var token = $('#id_token').val();
    var msg_mode = g_msg_mode;
    var aes_key= $('#id_aes').val();
    var data = {type: type, media_uid: media_uid, keyword: keyword, url: url, token: token, msg_mode: msg_mode, aes_key: aes_key};
    console.log(data);

    $.post(' ?_a=default&_u=sp.index', data, function(ret){
        showTip("","保存成功","1000");
        setTimeout(function () {
            window.location.reload()
        },1000);
    });

});
$('input[name="radio1"]').uCheck();
$('.am-radio').click(function(){
    g_msg_mode = $(this).attr('value');
    $('#id_aes').attr('disabled', g_msg_mode == 1);
});
/****************************
* 选择素材按钮点击事件
**/
$(".selectBtn").click(function () {
    var type = $(this).data("type");
    if(type==1) getPage(type,10);
    else getPage(type,3);
    var page = 0;
    getContent(type,page,showBox);
    $(".select-body").data("type",type)
});
/*
 * 回调show**************
 * */
function showBox(){
    //alert("2222222222222");
    var option={
        width:1016
    };
    $('#select-box').modal(option)
}
/*
* **生成选择*************************************************************************
* */
function getContent(type,page,callback){
    var link ='/?_a=sp&_u=api.sp_media_list&page='+page+'&media_type='+type;
    if(!(type==1)){
        link='/?_a=sp&_u=api.sp_media_list&page='+page+'&media_type='+type+'&limit=3';
    }
    $.getJSON(link, function (data) {
        data=data.data.list;
        console.log("text",data);
        //处理服务器返回数据,在此拼接html字符串
        var html ='';
        var title='';
        switch (type){
            case 1:
                $.each(data, function () {
                    //todo
                    var content=replace_mo(this.content);
                    html+=
                        '<div class="sel-box chooseBox" data-id="'+this.uid+'">' +
                        '<textarea style="display: none">'+this.content+'</textarea>' +
                        '<span>'+content+'</span>' +
                        '</div>';
                });
                title ='纯文本信息';
                break;
            case 2:
                html+='<div class="pic-min-box">';
                $.each(data, function () {
                    //todo
                    var json =this.content[0];
                    html+=
                        '<div class="select-pic-box chooseBox" data-id="'+this.uid+'">'+
                        '<textarea style="display: none">'+ JSON.stringify(json)+'</textarea>' +
                        '<h4 class="s_appmsg_title">'+
                        '<a onclick="return false;" href="javascript:void(0);" class="s_title" target="_blank">'+json.Title+'</a>'+
                        '</h4>'+
                        '<div class="s_appmsg_thumb_wrp">'+
                        '<img class="s_appmsg_thumb" src="'+json.PicUrl+'">'+
                        '</div>'+
                        '<p style="word-break: break-all" class="s_appmsg_desc">'+json.Description+'</p>'+
                        '</div>';

                });
                html+='</div>';
                title ='单图文信息';
                break;
            case 3:
                html+='<div class="pic-min-box">';
                $.each(data, function () {
                    //todo
                    var json =this.content;
                    //console.log("pics",json);
                    html+=
                        '<div class="pics-box chooseBox" data-id="'+this.uid+'">' +

                        '<textarea style="display: none">'+ JSON.stringify(json)+'</textarea>' +

                        '<div class="msg_navLeft" style="float: left">'+

                        '<div id="appmsgItem1" data-fileid="" data-id="1">'+

                        '<a class="title" >'+json[0].Title+'</a>'+

                        '<div class="appmsg_thumb_wrp">'+
                        '<img class="appmsg_thumb" src="'+json[0].PicUrl+'">'+
                        '</div>'+

                        '</div>';

                    for(var i=1;json.length>i;i++){
                        html+=
                            '<div class="small-msg" id="appmsgItem2" data-fileid="" data-id="2">'+

                            '<a class="title_s">'+json[i].Title+'</a>'+

                            '<img src="'+json[i].PicUrl+'" class="msg_img">'+

                            '</div>';
                    }

                    html+=
                        '</div>' +


                        '</div>';
                });
                html+='</div>';
                title ='多图文信息';
                break;
        }
        $(".select-title").text(title);
        $(".select-body").html(html);
        //alert("11111111111");
        if(!!(callback)){
            callback()
        }
    });
}

/***生成页码*******************/
function getPage(type,limit){
    var link ='/?_a=sp&_u=api.sp_media_list&media_type='+type;
    $.getJSON(link, function (data) {
        var count =parseInt(data.data.count);
        var page;
        /*页数计算*/
        var test = count/limit;
        var ex = /^\d+$/;
        if (ex.test(test)) {
            page=test
        }else{
            page=parseInt(test)+1
        }
        //console.log(data,count,page);
        //处理服务器返回数据,在此拼接html字符串**********************************
        var html = '<li class="media-prev" data-type="'+type+'"><a href="#">&laquo;</a></li>';
        for(var i= 0;i<page;i++){
            if(i==0){
                html+='<li class="am-active page-li"><a href="javascript:getContent('+type+','+0+')">1</a></li>'
            }else{
                html+= '<li class="page-li"><a href="javascript:getContent('+type+','+i+');">'+parseInt(i+1)+'</a></li>';
            }
        }
        html+='<li class="media-next" data-type="'+type+'"><a href="#">&raquo;</a></li>';
        $(".select-page").html(html);
    });
}
/*
 * 页码点击事件********************
 * */
$(".select-page").on("click",".page-li", function () {        //页码的
    $(this).siblings().removeClass("am-active");
    $(this).addClass("am-active");
}).on("click",".media-prev", function () {                       //上一页
    var actBtn = $(".am-pagination.select-page").children(".am-active");
    var page = parseInt(actBtn.text())-2;
    if(page==-1) return;
    var type= $(this).data("type");
    getContent(type,page);
    actBtn.removeClass("am-active");
    actBtn.prev().addClass("am-active")
}).on("click",".media-next",function () {                     //下一页
    var actBtn = $(this).siblings(".am-active");
    var page = parseInt(actBtn.text());
    if(page==$(this).siblings(".page-li").length) return;
    var type= $(this).data("type");
    getContent(type,page);
    actBtn.removeClass("am-active");
    actBtn.next().addClass("am-active")
});
/*
* 素材选择，素材点击事件----------
* */
$(".select-body").on("click",".chooseBox", function () {
    var id = $(this).data("id");
    var text=$(this).children("textarea").text();
    var data ;
    $('#dom').val(id);
    $('#select-box').modal("close");
    var type = parseInt($(".select-body").data("type"));
    switch (type){
        case 1:
            data=text;
            break;
        case 2:
            data=JSON.parse(text);
            break;
        case 3:
            data=JSON.parse(text);
            break
    }
    console.log(data);
    previewBox(type,data)
});


