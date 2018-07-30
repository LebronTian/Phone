var picsLimit=2;
$(document).ready(function () {
    var textPage = 0;
    getPics(textPage);
    getText(textPage);
    getPic(textPage);
    getPage(1,20);
    getPage(2,10);
    setTimeout("getPage(3,picsLimit)",1000);
    /*页码操作*/
    $(".page-list").on("click",".page-li", function () {    //点击页码
        var btn = $(this);
        var textPage = parseInt(btn.children().text());
        getData(textPage-1);
        btn.siblings(".page-li").removeClass("am-active");
        btn.addClass("am-active")
    }).on("click",".media-prev",function () {   //上一页
        var actBtn = $(this).siblings(".am-active");
        var textPage = parseInt(actBtn.text());
        if(textPage==1){
            return
        }
        getData(textPage-2);
        actBtn.removeClass("am-active");
        actBtn.prev().addClass("am-active")
    }).on("click",".media-next",function () {   //下一页
        var actBtn = $(this).siblings(".am-active");
        var textPage = parseInt(actBtn.text());
        if(textPage==$(this).siblings(".page-li").length){
            return
        }
        getData(textPage);
        actBtn.removeClass("am-active");
        actBtn.next().addClass("am-active")
    });
    /*同步浏览***************/
    //小标题栏输入
    $('.s_frm_input_tit').keyup(function(){
        var text = $(this).val();
        if(text==""){
            text="标题"
        }
        $(".s_title").text(text);
    });
    $('.s_frm_textarea').keyup(function(){
        var text = $(this).val();
        $(".s_appmsg_desc").text(text);
    });
    /**多图文新增跳转***/
    $(".content-3").on("click",".add-box", function () {
        window.location.href="/?_a=sp&_u=index.picsmedia"
    });
    /**富文本编辑器**********
    var ue = UE.getEditor('container');*/


    /*删除功能------包括text pic pics  */
    $(".am-tab-panel").on("click",".delete-btn", function () {
        $('#my-confirm').modal({
            relatedTarget: this,
            onConfirm: function(options) {
                var taget = $(this.relatedTarget);
                var uid =taget.parent().data("id");
                var link = "/?_a=sp&_u=api.del_media&uids="+uid;
                console.log(uid,link);
                $.post(link, function(data,status){
                    //alert("Data: " + data + "\nStatus: " + status);
                    //$("[class$=-box]")

                    taget.parents("[class$=-box]").remove();

                });
            },
            onCancel: function() {
            }
        });
    });
    /*
    文本：
    添加按钮点击增加状态，清空*/
    $(".content-1").on("click",".change-box", function () {
        $("#show").attr("type","add").html("");
    });
    /*编辑按钮出现*/
    $(".media-content").on("mouseenter",".text-box", function () {
        $(this).children(".text-edit").show()
    });
    $(".media-content").on("mouseleave",".text-box", function () {
        $(this).children(".text-edit").hide()
    });
    /*text编辑按钮点击，增加状态，id*/
    $(".media-content").on("click",".text-btn-edit", function () {
        var html = $(this).parent().siblings("span").html();
        var id = $(this).parent().parent().data("id");
        console.log(html,id);
        $("#show").html(html).attr("type","edit").attr("data-id",id);
    });
    /*
    * pic
    * 添加按钮增加状态id*/
    $(".content-2").on("click","#add-box-pic",function () {
        $(".wx_edit_sigle").attr("type","add");
        /**清空数据******************************************/
        $(".s_frm_input.s_frm_input_tit").val("");
        $(".s_title").text("标题");
        $("#s_codeImgBox").hide().children("img").attr("src","");
        $(".s_appmsg_thumb").attr("src","");
        $(".s_frm_textarea").text("");
        $(".s_appmsg_desc").text("");
        $(".s_frm_input.s_frm_input_author").val("");
        $(".s_frm_input.s_frm_input_link").val("")
    });
    $(".content-2").on("click",".edit-pic-btn", function () {
        var id = $(this).parent().data("id");
        var information =$(this).siblings(".pic-information").val();
        $(".s_main_bd").attr("data-id",id);
        $(".wx_edit_sigle").attr("type","edit");
        /***添加数据**************************************************/
        var json =JSON.parse(information)[0];
        console.log(json);
        $(".s_frm_input.s_frm_input_tit").val(json.Title);
        $(".s_title").text(json.Title);
        $("#s_codeImgBox").show().children("img").attr("src",json.PicUrl);
        $(".s_appmsg_thumb").attr("src",json.PicUrl);
        $(".s_frm_textarea").text(json.Description);
        $(".s_appmsg_desc").text(json.Description);
        $(".s_frm_input.s_frm_input_author").val(json.Author);
        $(".s_frm_input.s_frm_input_link").val(json.Url)
    })
    /*
    * pics
    * 编辑 按钮*/
    $("#tab_pics").on("click",".edit-pics-btn", function () {
        var id = $(this).parent().data("id");
        window.location.href="/?_a=sp&_u=index.picsmedia&uid="+id
    })

    //选择图片
    $('body').on('click', '.selete_btn', function(){
        var imgSrc = $('.img_list').find('li.pic-chose').find('img').attr('data-src');
        $('#s_codeImgBox').find('img').attr('src',imgSrc);
        $('.s_appmsg_thumb_wrp').find('img').attr('src',imgSrc);
		console.log('select img...', imgSrc);
    });

});
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
        //处理服务器返回数据,在此拼接html字符串*******************************************************
        var html = '<li class="media-prev"><a href="#">&laquo;</a></li>';
        for(var i= 0;i<page;i++){
            if(i==0){
                html+='<li class="am-active page-li"><a href="#">'+1+'</a></li>'
            }else{
                html+= '<li class="page-li"><a href="#">'+parseInt(i+1)+'</a></li>';
            }
        }
        html+='<li class="media-next"><a href="#">&raquo;</a></li>';
        $(".list-"+type).html(html);
    });
}
/**选择取哪个数据*****/
function getData(page){
    var str = $(".media-nav").children(".am-active").children("a").attr("href");
    if(str=='#tab_text'){
        getText(page)
    }else if(str=='#tab_pic'){
        getPic(page)
    } else{
        getPics(page)
    }
}
function getText(page){
    var link ='/?_a=sp&_u=api.sp_media_list&page='+page+'&media_type=1&limit=20';
    $.getJSON(link, function (data) {
        data=data.data.list;
        //console.log("text",data);
        //处理服务器返回数据,在此拼接html字符串*******************************************************
        var html =
            '<div class="add-box change-box" data-am-modal="{target: \'#text-modal\', closeViaDimmer: 0,width:930}">'+
            '<img src="/app/sp/static/images/add.png"/>'+
            '</div>';
        $.each(data, function () {
            /*将表情变成img*/
            //console.log("content",this.content);
            var content=replace_XDD(this.content);
            content = replace_mo(content);
            //console.log("S",content);
            //todo
            html+=
                '<div class="text-box" data-id="'+this.uid+'">' +
                '<span>'+content+'</span>' +
                '<div class="text-edit"><img class="text-btn-edit" data-am-modal="{target: \'#text-modal\', closeViaDimmer: 0,width:930}" src="/app/sp/static/images/edit.png" /></div>' +
                '<div class="text-delete delete-btn" ><i class="am-icon-close"></i></div>' +
                '</div>';
        });

        $(".content-1").html(html);
    });
}
function getPic(page){
    var link ='/?_a=sp&_u=api.sp_media_list&page='+page+'&media_type=2';
    $.getJSON(link, function (data) {
        data=data.data.list;
        //console.log("pic",data);
        //处理服务器返回数据,在此拼接html字符串*******************************************************
        var html =
            '<div class="add-box" id="add-box-pic" data-am-modal="{target: \'#pic-modal\', closeViaDimmer: 0,width:930}" >'+
            '<img src="/app/sp/static/images/add.png"/>'+
            '</div>';
        $.each(data, function () {
            //todo
            var json =this.content[0];
            //console.log(json);
            html+=
                '<div class="pic-box">' +
                '<div class="pic-box-body">' +
                '<p><nobr>'+json.Title+'</nobr></p>' +
                '<div style="height: 180px;overflow: hidden"><img src="'+json.PicUrl+'"/></div>' +
                '<p><nobr>'+json.Description+'</nobr></p><br/>' +
                '</div>' +
                '<div class="pic-box-bottom" data-id="'+this.uid+'">' +
                '<button type="button" class="am-btn am-btn-primary edit-button edit-pic-btn" data-am-modal="{target: \'#pic-modal\', closeViaDimmer: 0,width:930}">编辑</button>' +
                '<input type="text" class="pic-information" style="display: none" value=\''+JSON.stringify(this.content)+'\'/>' +
                '<button type="button" class="am-btn am-btn-default delete-button delete-btn">删除</button>' +
                '</div>' +
                '</div>';
        });
        $(".content-2").html(html);
    });
}
function getPics(page){
    var boxWidth = $("#tab_pics").width();
    picsLimit = parseInt(boxWidth/330);
    var link ='/?_a=sp&_u=api.sp_media_list&page='+page+'&media_type=3&limit='+picsLimit;
    $.getJSON(link, function (data) {
        data=data.data.list;
        //console.log("pics",data);
        //处理服务器返回数据,在此拼接html字符串*******************************************************
        var html ='';
        $.each(data, function () {
            //todo
            var json =this.content;
            //console.log("pics",json);
            html+=
                '<div class="pics-box">' +

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

                '<div class="pics-box-bottom"  data-id="'+this.uid+'">' +
                '<button type="button" class="am-btn am-btn-primary edit-button edit-pics-btn">编辑</button>' +
                '<button type="button" class="am-btn am-btn-default delete-button delete-btn">删除</button>'+
                '</div>'+

                '</div>';
        });
        $(".pics-body-boxs").html(html);
    });
}



