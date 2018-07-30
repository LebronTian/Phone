$(document).ready(function () {
    /*数据初始化！！！！*/
    $(".new-keyword-box").each(function () {
        var text = $(this).children("textarea").val();
        var type = $(this).children("textarea").data("type");
        var uid = $(this).children("textarea").data("uid");
        if(text){
            text = $.parseJSON(text);
            if(type==2){
                text = text["0"]
            }

            var box = '<div class="reply-section" data-type="'+type+'" data-uid="'+uid+'">';
            box+=previewBox(type,text)+'</div>';

            $(this).find(".reply-brief").html(box)

        }
    });
    /************************************************/
    /*添加按钮*/
    $(".create-btn").click(function () {
       $("#create-new").slideDown()
    });
    /*删除*/
    $(".del-keyword").click(function () {
        var uid = $(this).data("uid");
        var data = {
            uids:uid
        };
        $('#del-confirm').modal({
            relatedTarget: this,
            onConfirm: function(options) {
                $(this.relatedTarget).parents(".new-keyword-box").fadeOut();
                $.post("?_a=keywords&_u=api.delkeyword",data, function (ret) {
                    console.log(ret);
                })
            },
            onCancel: function() {
            }
        });
    });

    /*
    $('.add-keywords').select2({
        tags: true,
        placeholder: "请输入关键字，用回车键隔开",
        minimumInputLength: 1      //限制名字最短长度
    });*/
    /*
    * 模式转换
    * */
    $(".brief-mode").click(function () {
        if($(this).hasClass("am-icon-chevron-up")){
            $(this).removeClass("am-icon-chevron-up").addClass("am-icon-chevron-down");
            $(this).parents(".new-keyword-box").children(".edit-section").slideUp();
            $(this).parents(".new-keyword-box").children(".show-section").slideDown();
            $(".select2-container").slideUp();
            /*浏览模式*/
            $(this).parents(".new-keyword-box").find(".up_keyword").attr("readonly",true).addClass("read-only")
        }else{
            $(this).removeClass("am-icon-chevron-down").addClass("am-icon-chevron-up");
            $(this).parents(".new-keyword-box").children(".edit-section").slideDown();
            $(this).parents(".new-keyword-box").children(".show-section").slideUp();
            $(".select2-container").slideDown();
            /*编辑模式*/
            $(this).parents(".new-keyword-box").find(".up_keyword").attr("readonly",false).removeClass("read-only")
        }
    });


    /*
    * 删除功能：已取消
    *
    $(".reply-brief").on("click",".del-brief", function () {
        $(this).parent().fadeOut(function () {
            $(this).remove()
        })
    });*/

    /*
    * 保存按钮
    * */
    $(".save-btn").click(function () {
        var keyword = $(this).parents(".new-keyword-box").find(".up_keyword").val().trim();
        var media_uid = $(this).parents(".new-keyword-box").find(".reply-section").data("uid");
        if(!keyword){
            showTip("err","请输入关键词","1000");
            return
        }
        if(!media_uid){
            showTip("err","请选择回复素材","1000");
            return
        }
        var data = {
            keyword:keyword,
            media_uid:media_uid
        };
        var uid =  $(this).parents(".new-keyword-box").data("uid");
        if(uid){
            data['uid'] = uid
        }
        console.log(data);
        $.post("?_a=keywords&_u=api.addkeyword",data, function (ret) {
            ret = $.parseJSON(ret);
            console.log(ret);
            if(ret.errno==0){
                showTip("","保存成功",1000);
                window.location.reload()
            }else{
                showTip("","保存失败",1000)
            }

        })
    })

});
/*
* <span style="float: right" class="del-brief am-icon-trash am-icon-sm"></span>
* */
function source_back(data){
    console.log(data);
    var html = '<div class="reply-section" data-type="'+data.media_type+'" data-uid="'+data.id+'">';
    html+=data.html+'</div>';
    data.btn.parents(".new-keyword-box").find(".reply-brief").html(html);
}










