var img_list_html =
'<div class="mask"></div>'+
'<div class="dialog_box">'+
'<div class="dialog_wrp">'+
'<div><span>选择图片</span></div>'+
'<div class="upload_box" style="clear:both;margin-bottom:10px;width:100px;position:absolute;right:52px;top:52px;">'+
'<button type="button" class="am-btn am-btn-primary" id="file_upload_group">上传图片</button>'+
'</div>'+
'<button onclick="window.open(\'?_a=material&_u=sp&initType=2\')" class="weixinImage-btn am-btn am-btn-primary" style="position: absolute;top: 43px;right: 47px;display: none">上传图片</button>'+
'<div style="height:40px;"><div><select style="margin: 8px 0 0 30px;" id="file_group"><option value="0">所有</option></select></div><button class="systemBtn am-btn am-round am-btn-success">大师推荐图片</button></div><button class="InternetBtn am-btn am-round am-btn-success">网络图片</button><button type="button" class="am-btn am-btn-primary" style="position: absolute;top: 52px;right: 380px;" onclick="window.open(\'?_a=sp&_u=index.imgmanage\')">图片整理</button>'+
'<ul class="img_list"　style="clear:both;width:690px;margin-top:20px;\">'+
'<li><img src=""><span>&radic;</span></li>'+
'<li><img src=""><span>&radic;</span></li>'+
'<li><img src=""><span>&radic;</span></li>'+
'<li><img src=""><span>&radic;</span></li>'+
'<li><img src=""><span>&radic;</span></li>'+
'<li><img src=""><span>&radic;</span></li>'+
'<li><img src=""><span>&radic;</span></li>'+
'<li><img src=""><span>&radic;</span></li>'+
'<li><img src=""><span>&radic;</span></li>'+
'<li><img src=""><span>&radic;</span></li>'+
'</ul>'+
'<ul id="PageBar">'+
'</ul>'+
'<div class="select_box"><button class="am-btn am-btn-success selete_btn">确认</button><button class="am-btn selete_canel">取消</button></div>'+
'</div>'+
'<span class="dialog_close">&times</span>'+
'</div>';
$('body').append(img_list_html);
var imgListThatBtn;
var NoWeiXinImages=0;
var picNumPage = 0;
var Int;
var imgListOption = {};
$(document).ready(function () {
    //图片返回地方
    var addr = '';
    var func;
    /*
     * 点击触发box，通过类名——imgBoxBtn触发
     *
     * btn可带参数data-addr，里面放图片返回显示的地方
     * 例如id为images的就放data-addr="#images",与jq选择器规则相同
     * 如果返回多个地方用逗号隔开： data-addr="#codeImg,.jcrop-preview"
     * 提示：没有不确定返回地方又想得到图片的话可以选取 .pic-chose 里的图片
     *
     * btn可带参数data-func，里面放选择后执行的函数名字
     * 例如选择后想执行getImg()功能，则在btn加data-func="getImg"
     *
     * btn可带参数data-weixin，值：默认0：取所有的图片；1:代表只要微信的；-1代表不要微信的；
     *
     * imgListThatBtn,记录点击进来的按钮
     *
     * */

    $("body").on("click",".imgBoxBtn", function () {
        var data_id = $(this).attr('data-id');
        var html = '<input type="hidden" value="'+data_id+'" id="select-img-data-id">';
        $('#select-img-data-id').remove();
        $('body').append(html);
        $(".mask").show();
        $(".dialog_wrp").show();
        $(".dialog_close").show();
        $('.img_list li').find('span').hide();
        NoWeiXinImages = $(this).data("weixin");

        $(".upload_box").show();
        $(".weixinImage-btn").hide();

        get_old_pic();
        addr = $(this).attr("data-addr");
        func = $(this).attr("data-func");
        imgListOption ={
            addr:addr,
            func:func
        };
        imgListThatBtn = this;
    });

    //点击显示选中
    $('.dialog_wrp').on('click','.img_list li',function(){
        $(this).find('span').show();
        $(this).addClass("pic-chose");
        $(this).siblings().find('span').hide();
        $(this).siblings().removeClass("pic-chose");
    });
    $('.dialog_wrp').on('click','.img_list li a',function(){
        //console.log($(this).attr('data-uid'));return;
        var uids =$(this).attr('data-uid');
        uids = uids;
        if(confirm('确定要删除吗？')){

            $.post("?_a=upload&_u=ajax.delete_file_info",{uids:uids},function(result){
                console.log(result);
                result=$.parseJSON(result);
                if(result.errno == 0){
                    get_old_pic();
                }
            });

        }

    });


    //确定选择按钮
    $('.selete_btn').on('click', function(){
        var img = $(".pic-chose").children("img");
        if(addr){
            $(addr).attr("src",img.attr("data-src"));
            if(NoWeiXinImages==1){
                $(addr).data("mid",img.data("mid"));
            }
        }
        if(func){
            eval(func+"()");//回调函数
        }

        $('.dialog_wrp').hide();
        $('.dialog_close').hide();
        $('.mask').hide();
        $('.jc-demo-box').show();
    });
    //关闭按钮
    $('.dialog_close').click(function(){
        $('.dialog_wrp').hide();
        $('.dialog_close').hide();
        $('.mask').hide();
    });
    //取消按钮
    $('.selete_canel').click(function(){
        $('.dialog_wrp').hide();
        $('.dialog_close').hide();
        $('.mask').hide();
    });

    /*页码功能---点击按钮分页*/
    $(".dialog_box").on("click","#PageBar li", function () {
        var num = parseInt($(this).text());
        $(this).addClass('on').siblings().removeClass('on');
        picNumPage = num-1;
        get_old_pic();
    });

    /*页码功能---点击展开收缩按钮*/
	$('#PageBar').on('click','.Next',function(){
    	picNumPage = 5*(Int+1);
    	get_old_pic(picNumPage);
    });

    $('#PageBar').on('click','.Prev',function(){
    	picNumPage = 5*(Int-1);
    	get_old_pic(picNumPage);
    });



    function get_old_pic(page){
        var group = $("#file_group").find("option:selected").val();
        var page = picNumPage;
        var limit = 10;
        var data = {
            page:page,
            limit:limit,
            file_group:group
        };
        var link ='?_a=upload&_u=index.sp_img_list';
        switch (NoWeiXinImages){
            case -1:
                data['no_in_weixin']=1;
                //console.log("不要微信的图片");
                break;
            case 1:
                link='?_a=material&_u=api.get_material_list';
                data['material_type']='image';
                //console.log("要微信的图片");
                $(".upload_box").hide();//不给上传
                $(".weixinImage-btn").show();
                break;
            default :
            //console.log("默认");
        }
        $.post(link,data,function(obj){
            obj = $.parseJSON(obj);

            //console.log("old",obj);
            //console.log(obj.data.list);

            /*for(var i=0; i<obj.data.list.length; i++){
             var imgpath=obj.data.list[i].url;
             $('.img_list li:eq('+i+')').find('img').attr('src',imgpath);
             if(NoWeiXinImages==1){
             $('.img_list li:eq('+i+')').find('img').data('mid',obj.data.list[i].media_id);
             }
             }*/

            var html = '';
            var List = obj.data.list;
            $.each(List,function(){
                var src = this.url + '&w=100&h=100';
                html+=
                    '<li>' +
                    '<img data-src="'+this.url+'" src="'+src+'" '+((NoWeiXinImages==1)?"data-mid="+this.media_id:"")+'>' +
                    '<a data-uid="'+this.uid+'" class="am-icon-close"></a><span>&radic;</span>' +
                    '</li>';
            });
            $('.img_list').children().remove();
            $('.img_list').append(html);
            $('.img_list').find('span').hide();

            //分页 data.data.count为数组总数
            var PgeNum = Math.ceil(obj.data.count/10);
            var PageHtml ='';

            Int = parseInt((page+1)/5);
            var yu = (page+1)%5;
            var Int_all = parseInt((PgeNum+1)/5);   //最多多少页
            var yu_all = (PgeNum+1)%5;              //最多那页的余数

            if(yu==0){
                yu=5;
                Int--;
            }

            //创建分页按钮 PgeNum为可分为的页码数目
            if(PgeNum<5){
                for(var i=0;i<PgeNum;i++){

                    PageHtml+='<li ';
                    if(i==(yu-1)){
                        PageHtml+=' class="on" ';
                    }
                    PageHtml+='>';
                    PageHtml+=(i+1)+'</li>';

                };
                $('#PageBar').children('li,a').remove();
                $('#PageBar').append(PageHtml);
            }else{

                var count=5;
                if(Int>=Int_all){
                    count = yu_all-1;
                    Int = Int_all;
                }
                if(!(Int<=0)){
                    PageHtml+='<a class="Prev pic-page">&lt;</a>';
                }

                for(var i=0;i<count;i++){
                    PageHtml+='<li ';
                    if(i==(yu-1)){
                        PageHtml+=' class="on" ';
                    }
                    PageHtml+='>';
                    PageHtml+=(i+1+5*Int)+'</li>';

                };

                if(!(Int>=Int_all)){
                    PageHtml+='<a class="Next">&gt;</a>';
                }
                $('#PageBar').children('li,a').remove();
                $('#PageBar').append(PageHtml);
            }


            /*页码*/
            /*var allOld = obj.data.count;
             if(allOld==0) return;
             var pageNum = Math.ceil(allOld/10);
             var html ='<ul class="am-pagination">' +
             '<li class="am-disabled"><a>&laquo;</a></li>';
             for(var n=0;n<pageNum;n++){
             if(n==page){
             html+='<li class="pic-page am-active"><a>'+(n+1)+'</a></li>';
             }else{
             html+='<li class="pic-page"><a>'+(n+1)+'</a></li>';
             }
             }
             html+='<li><a>&raquo;</a></li>' +
             '</ul>';
             $(".page").html(html);*/

        });
    }

    $("#file_group").change(function(){
        get_old_pic();
    });

});



/*系统图片-start*/
$(function() {

    if(1){
        /*获取类别*/
        $.getJSON("?_a=upload&_u=index.get_file_group",function (ret) {
            /*初始化盒子*/
            var html =
                "<div class='systemPicBox' style='display: none'>" +
                "<div class='btn-content'>" +
                "<button class='returnBtn corner-btn am-btn am-btn-primary'><i class='am-icon-reply'></i> 返回</button>" +
                "<button class='closeBtn corner-btn am-btn am-btn-success'><i class='am-icon-close'></i> 关闭</button>" +
                "</div>" +
                "<aside class='system-left-box blue-slide'>" +
                "<ul class='system-pic-type'>" +
                "<li class='type-title-li'>图片类别</li>" ;

			if(ret.data && ret.data.list)
            $.each(ret.data.list, function (index,key) {
                //console.log(this,index,key);
                html+= "<li class='system-type-li"+((index==1)?" active-type-li":"")+"' data-uid='"+index+"'>"+this+"</li>" ;
            });
            html+=
                "</ul>" +
                "</aside>" +
                "<article class='system-right-box'>" +
                "<ul class='system-pic-ul clearfix blue-slide'>" +

                "</ul>" +

                "<div class='system-bottom-btn'>" +

                "</ul>" +
                "</div>" +
                "</article>" +
                "</div>";
            $("body").append(html);
            var html = '';
            $.each(ret.data.list, function (index,key) {
                //console.log(this,index,key);
                html+= "<option value='"+index+"'>"+this+"</option>" ;
            });
            $("#file_group").append(html);

        });

        /*获取图片*/
        function get_system_pic(page){
            if(!page) page=0;
            var group = $(".system-type-li.active-type-li").data("uid");
            var data = {
                page:page,
                limit:10,
                public_image:1,
                file_group:group
            };
            $.getJSON("?_a=upload&_u=index.sp_img_list", data,function (ret) {
                console.log(ret);
                var pic = '';
                $.each(ret.data.list, function () {
                    pic += "<li style='display: none' class='system-pic-li'><img class='system-pic-img' src='"+this.url+"' data-uid="+this.uid+" /><div class='chose-pic-shadow'><i class='pic-chose-icon am-icon-check'></i></div></li>"
                });
                $(".system-pic-ul").html(pic);
                $(".system-pic-li").fadeIn("fast");
                var pagination = ret.data.pagination;
                pagination +="<button class='systemChose system-pic-chose-btn am-btn am-btn-success'><i class='am-icon-check'></i> 确定</button>";
                $(".system-bottom-btn").html(pagination);
            })
        }
        /*
            事件****************
        */
        /*显示*/
        $(".systemBtn").click(function () {
            /*取数据*/
            get_system_pic();
            /*动画*/
            $(".dialog_wrp").fadeOut("slow");
            $(".systemPicBox").show().addClass("am-animation-slide-right").one($.AMUI.support.animation.end, function() {
                $(".systemPicBox").removeClass("am-animation-slide-right");
            });
        });

        var html =
            "<div class='InternetPicBox' style='display: none;'>" +
            "<div class='btn-content'>" +
            "<button class='ireturnBtn corner-btn am-btn am-btn-primary'><i class='am-icon-reply'></i> 返回</button>" +
            "<button class='icloseBtn corner-btn am-btn am-btn-success'><i class='am-icon-close'></i> 关闭</button>" +
            "</div>" +
            "<article class='internet-right-box'>" +
            "<ul class='internet-pic-ul clearfix blue-slide'>" +
            "地 址：<input type='text' id='pic_url' style='width: 80%'>"+
            "</ul>" +
            "<ul class='internet-pic'>" +
            "<div><div>"+
            "</ul>" +
            "<div class='internet-bottom-btn'>" +
            "<button class='InternetChose system-pic-chose-btn am-btn am-btn-success'><i class='am-icon-check'></i> 确定</button>"+
            "</ul>" +
            "</div>" +
            "</article>" +
            "</div>";
        $("body").append(html);

        $('#pic_url').bind('input propertychange', function() {
            var url = $('#pic_url').val();
            $('.internet-pic').html("<img class='int_img' src='"+url+"'>");
        });
        $(".InternetChose").click(function(){
            var addr = imgListOption['addr'];
            var func = imgListOption['func'];
            var img = $('#pic_url').val();
            if(addr){
                $(addr).attr("src",img);
                if(NoWeiXinImages==1){
                    $(addr).data("mid",img);
                }
            }
            if(func){
                eval(func+"()");//回调函数
            }

            $('.dialog_wrp').hide();
            $('.dialog_close').hide();
            $('.mask').hide();
            $('.jc-demo-box').show();
            $('.InternetPicBox').hide();
        })

        /*显示*/
        $(".InternetBtn").click(function () {
            /*动画*/
            $(".dialog_wrp").fadeOut("slow");
            $(".InternetPicBox").show().addClass("am-animation-slide-right").one($.AMUI.support.animation.end, function() {
                $(".InternetPicBox").removeClass("am-animation-slide-right");
            });
        });

        /*选择类别*/
        $("body").on("click",".system-type-li", function () {
            $(this).addClass("active-type-li").siblings().removeClass("active-type-li");
            /*根据类名取！*/
            get_system_pic();
        });
        /*选择图片*/
        $("body").on("click",".system-pic-li", function () {
            $(this).addClass("chosePic").siblings().removeClass("chosePic")
        });
        /*页码选择*/
        $("body").on("click",".system-bottom-btn li", function () {
            if(!$(this).hasClass("am-disabled")){
                var page = $(this).text();
                console.log(page);
                get_system_pic(page-1)
            }
        });
        /*确定按钮*/
        $("body").on("click",".systemChose", function () {
            var img = $(".system-pic-ul .chosePic").find(".system-pic-img").attr("src");
            if(!img){
                showTip("err","请选择图片","1000");
                return
            }
            console.log(imgListOption,img);
            var addr = imgListOption['addr'];
            var func = imgListOption['func'];

            if(addr){
                $(addr).attr("src",img);
            }
            if(func){
                eval(func+"()");//回调函数
            }

            /*同关闭按钮*/
            $(".systemPicBox").addClass("am-animation-slide-right am-animation-reverse").one($.AMUI.support.animation.end, function() {
                $(".systemPicBox").hide().removeClass("am-animation-slide-right am-animation-reverse");
            });
            $(".mask").fadeOut();
            $(".dialog_close").hide()
        });
        /*返回按钮*/
        $("body").on("click",".returnBtn",function () {
            $(".systemPicBox").addClass("am-animation-slide-right am-animation-reverse").one($.AMUI.support.animation.end, function() {
                $(".systemPicBox").hide().removeClass("am-animation-slide-right am-animation-reverse")
            });
            $(".dialog_wrp").fadeIn("slow");
        });
        $("body").on("click",".ireturnBtn",function () {
            $(".InternetPicBox").addClass("am-animation-slide-right am-animation-reverse").one($.AMUI.support.animation.end, function() {
                $(".InternetPicBox").hide().removeClass("am-animation-slide-right am-animation-reverse")
            });
            $(".dialog_wrp").fadeIn("slow");
        });
        /*关闭按钮*/
        $("body").on("click",".closeBtn",function () {
            $(".systemPicBox").addClass("am-animation-slide-right am-animation-reverse").one($.AMUI.support.animation.end, function() {
                $(".systemPicBox").hide().removeClass("am-animation-slide-right am-animation-reverse");
            });
            $(".mask").fadeOut();
            $(".dialog_close").hide()
        });
        $("body").on("click",".icloseBtn",function () {
            $(".InternetPicBox").addClass("am-animation-slide-right am-animation-reverse").one($.AMUI.support.animation.end, function() {
                $(".InternetPicBox").hide().removeClass("am-animation-slide-right am-animation-reverse");
            });
            $(".mask").fadeOut();
            $(".dialog_close").hide()
        });
    }
    else{
        $(".systemBtn").hide();
        $(".InternetBtn").hide();

    }

});
/*系统图片-end*/
