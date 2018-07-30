
/*
* 选择微信素材功能
* amazeui2.1，jq2.1环境下使用，还有source_select.css，qq表情需要用到qqFaceData.js
* 可以选择3种素材：纯文本，单图文，多图文；
*
* 使用方法：
* 通过点击触发，统一加上————selectBtn类名
* 然后加上data-type属性，1代表纯文本，2代表单图文，3代表多图文。
*
* 定义回调函数：
* 点击section时会触发回调函数，回调函数名为source_back（data）请写在本js声明前的js代码里
*
* data参数中自带section的id，html代码,素材类型
*
* */

$(document).ready(function () {
    /****************************
     * 选择素材按钮点击事件
     **/
    var type_back;
    var $btn;
    $(".selectBtn").click(function () {
        $btn = $(this);     //记录这个按钮！！！！
        var type = $(this).data("type");
        type_back = type;
        if(type==1) getPage(type, 5);
        else getPage(type,3);
        var page = 0;
        getContent(type,page,showBox);
    });
    /***********
     * 回调show，显示弹窗//弹窗需要高度build，所以要在数据加载完后
     * */
    function showBox(){
        var option={
            width:1016
	    ,height: 600
        };
        $('#select-box').modal(option)
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
    $(".select-page").on("click",".page-li", function () {          //页码的
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
    }).on("click",".media-next",function () {                        //下一页
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

        var ele =$(this);
        var data = {};
        data['id'] = ele.data("id");
        data['html'] = ele['0']['outerHTML'];
        data['media_type'] = type_back;
        data['btn'] = $btn;
        if(typeof (source_back)=="function"){
            source_back(data)
        }
        $("#select-box").modal("close")
    });



});

/*
 * **生成选择*************************************************************************
 * */
function getContent(type,page,callback){
    var link ='/?_a=sp&_u=api.sp_media_list&page='+page+'&media_type='+type+'&limit=5';
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
                    var content=replace_XDD(this.content);
                    content = replace_mo(content);
                    html+=
                        '<div class="sel-box chooseBox" data-id="'+this.uid+'">' +
                        '<textarea style="display: none">'+this.content+'</textarea>' +
                        '<php>'+content+'</php>' +
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
        if(!!(callback)){
            callback()
        }
    });
}




//替换[mo_**]
function replace_mo(str){
    str = str.replace(/\</g,'&lt;');
    str = str.replace(/\>/g,'&gt;');
    //str = str.replace(/\n/g,'<br/>');
    str = str.replace(/\[mo_([0-9]*)\]/g,'<img src="/app/sp/static/images/arclist/$1.gif" border="0" />');
    return str;
}


/*qq表情*/
function replace_XDD(str){
    //str = str.replace(/\</g,'&lt;');
    //str = str.replace(/\>/g,'&gt;');
    /**/
    str = str.replace(/\/:([^\s]*)?/g, function (XDD) {
        XDD = XDD.trim();
        return transData[XDD].code
    });
    return str;
}


/*赠送功能：数据生成html*/
/*两个参数，类型与数据
* 数据是对象数组类型数据：
* 大概意思就是传下面这个：
*
* $.parseJSON({"Title":"hahaha标题党触摸","Description":"订单的","PicUrl":"http://localhost?_a=upload&_u=index.out&uidm=473886","Url":"http://localhostvvv"})
*
* 但。。。。。。。。。。。。。年久失修以前做的功能，样式非常爆炸
* */
function previewBox(type,data){
    var box="";
    switch (type){
        case 1:
            var content=replace_XDD(data);
            content = replace_mo(content);
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

    return box

}




