
var tableSave = {};//保存用的table

$(document).ready(function () {
    var ue = UE.getEditor('biz-content');

    $('.biz_info').select2({
        tags: true,
        placeholder: "用回车键隔开",
        minimumInputLength: 1      //限制名字最短长度
    });
    $('.biz_info').trigger('change');
    /*删除小图*/
    $("#more-img-box").on("click",".del-img", function () {
        if(confirm("确定删除吗？")){
            $(this).parent().remove()
        }
    });
    /*重置表格**************/
     /**保存按钮******************************************************************************/
    $("#saveBiz").click(function () {
        var title = $("#biz_title").val();
        var account = $("#biz_account").val();
        var passwd = $("#biz_passwd").val();
        if(!checkTrim($("#biz_title"),"请填写商家名称")) return;
        var type = $("#biz_type").text();

        var per_cost = parseInt($("#biz_percost").val()*100);
        var read_cnt = $("#read_cnt").val();
        var score_total = $("#biz_score_total").val();
        if(score_total>100||score_total<0){
            showTip("err","请填写正确的评分",1000);
            $(".biz_score_total").focus();
            return
        }
        //var title_third = $("#title_third").val();
        var location = $("#address").val();
        var contact = $("#biz_contact").val();
        var phone = $("#biz_phone").val();
        var lng = $("#p_lng").val();
        var lat = $("#p_lat").val();
        var main_img = $("#main-img").attr("src");
        var images = [];
        $(".more-img").each(function () {
            var image = $(this).attr("src");
            images.push(image)
        });
        var realImg = images.join(";");

        var su_uid = $('#biz_user').attr('data-uid');

        if(!main_img){
            showTip("err","请选择店铺主图",1000);
            $(".buttonImg1").focus();
            return
        }
        if(!su_uid){
            showTip("err","请选择联系用户",1000);
            return
        }

        var admin_uids = [];
        $(".class_user").each(function(){
            var uid = $(this).attr('data-uid');
            admin_uids.push(uid);
        });

        //店内设施
        var bar_installation = $('.biz_info').val();
        var business_time = $('#business_time').val();
        var sort = $('#biz_sort').val();

        var content ;
        ue.ready(function(){
            content = ue.getContent();
        });
        if(content.trim()==""){
            showTip("err","请填写商家详情","1000");
            return
        }

        var hadv = ($("#biz-addv").is(":checked"))? 1:0 ;
        var hadrecommend = ($("#biz-addrecommend").is(":checked"))? 1:0 ;

        var status = $("input[name='rad-status']:checked").val();
        if(!status){
            showTip("err","请选择审核状态","1000");
            return
        }
        /*上传！！！！！！！！！！！！！！！！！！*/
        var bigData = {
            "title":title,
            "account":account,
            "passwd":passwd,
            "type":type,
            "per_cost":per_cost,
            "read_cnt":read_cnt,
            "score_total":score_total,
            "location":location,
            "su_uid":su_uid,
            "admin_uids":admin_uids,
            "contact":contact,
            "phone":phone,
            "lng":lng,
            "lat":lat,
            "main_img":main_img,
            "extra_info":{
                bar_installation:bar_installation,
                business_time:business_time
            },
            "sort":sort,
            "images":realImg,
            "brief":content,
            "hadv":hadv,
            "hadrecommend":hadrecommend,
            "status":status
        };
        var uid = $("#edit-id").data("id");
        var link,text;
        if(uid){
            link = "/?_a=shop&_u=api.addbiz&uid="+uid;
            text = '保存成功'
        }else{
            link = "/?_a=shop&_u=api.addbiz";
            text = '添加成功'
        }
        console.log(bigData);
        $.post(link,bigData, function(data){
            data = $.parseJSON(data);
            console.log(data);
            if(data.errno==0){
                showTip("",text,"1000");
                setTimeout(function () {
                    //window.location = document.referrer;
                    window.location.href="?_a=shopbiz&_u=sp.bizlist";
                },1000)
            }else if(data.errno==605){
                showTip("err","商家账号已存在！","1000");
            }else if(data.errno==425){
                showTip("err","联系用户已被商家绑定！","1000");
            }
        });
    });

    /******************************************************************************************
    * 编辑预加载功能
    * */
    if(!(edit_biz=="")){
        /***********************************/
        ue.ready(function() {
            ue.setContent(edit_biz["brief"]);
        });
        var status = edit_biz["status"];
        $("input[name='rad-status'][value='"+status+"']").prop("checked",true)
    }
});
/*****************************
* 检验功能
* */
function checkTrim(ele,text){
    if(ele.val().trim()==""){
        showTip("err",text,"1000");
        ele.focus();
        return false
    }else return true
}
function checkErr(ele,text){
    if(ele.hasClass("am-field-error")){
        showTip("err",text,"1000");
        ele.focus();
        return false
    }else return true
}
/***********************
* 小图标回调函数
* */
function iconImg(){
    var PicSrc = $(".pic-chose").children("img").attr("src");
    $(imgListThatBtn).attr("src",PicSrc)
}
/*********************
* 主图回调函数
* */
function mainImg(){
    var picSrc = $("#main-img-src").attr("src");
    var img = '<img id="main-img" src="'+picSrc+'"/>';
    $("#main-img-box").html(img)
}
/*********************
 * 更多图片回调函数
 * */
function moreImg(){
    var picSrc = $("#more-img-src").attr("src");
    var img =
        '<div class="more-img-content">' +
        '<img class="more-img" src="'+picSrc+'"/>' +
        '<span class="am-icon-trash del-img"></span>' +
        '</div>';
    $("#more-img-box").append(img)
}

var theclick;
var theclickimg;
var theclickspan;
select_user({ele: '#biz_user', single: true, onok: function(su) {
    console.log('selected', su);
    theclick.attr('data-uid', su.uid);
    theclickimg.attr('src', su.avatar || '/static/images/null_avatar.png');
    theclickspan.text(su.name);

}});
$('#biz_user').click(function () {
    theclick =  $('#biz_user');
    theclickimg = $('#biz_user img');
    theclickspan =  $('#biz_user span');
});

$(document).on('click','.class_user',function(){
    theclick =  $(this);
    theclickimg = $(this).children('img');
    theclickspan =  $(this).children('span');
    $('#user-popup').modal();
});

$('.type-add-li').click(function(){
    var user = '<div class="class_user" data-uid=""><img style="width:64px;height:64px;" src=""> <span></span></div>';
    $(".userlist").prepend(user);
})
$(".type-red-li").click(function () {
    $(".class_user").eq(0).remove();
})

/*
 *  简单修改js 38.8 * 100 != 3880 的问题
 */
var _parseInt = parseInt;
parseInt = function(str) {
    if(typeof str == 'number') return Number(str.toFixed(0));
    return  _parseInt.apply(_parseInt, arguments);
}
