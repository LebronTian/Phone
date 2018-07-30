$(document).ready(function(){


    $('#saveDocument').click(function(){

        var product_uid = $("#product_uid").attr('data-uid');
        var user_id = $("#id_user").attr("data-uid");

        var brief = $("#id_brief").val().trim();

        if(user_id == ""){
            alert("请选择用户！");
        }else if(brief == ""){
            alert("请填写评论！");
        }

        var images = [];
        $(".more-img").each(function () {
            var image = $(this).attr("src");
            images.push(image)
        });
        var realImg = images.join(";");

        var data = {"product_uid":product_uid,"user_id":user_id,"brief":brief,images:realImg};

        // console.log(data.title + "\n" + data.content);

        $.post("?_a=shop&_u=admin.addcomment",data,function(ret){
            console.log(ret);
            ret = $.parseJSON(ret);
            if(ret.errno == 0){
                showTip('ok', "保存成功", 1000);
                window.location.href="?_a=shop&_u=admin.productcomment";
            }else{
                showTip('err', "保存失败", 1000);
            }

        });


    });
});

/*删除小图*/
$("#more-img-box").on("click",".del-img", function () {
    if(confirm("确定删除吗？")){
        $(this).parent().remove()
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


select_user({ele: '#id_user', single: true, onok: function(su) {
    console.log('selected', su);
    $('#id_user').attr('data-uid', su.uid);
    $('#id_user img').attr('src', su.avatar || '/static/images/null_avatar.png');
    $('#id_user span').text(su.name);
}});