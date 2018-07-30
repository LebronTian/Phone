$(function () {
    $(".statusBtn").click(function () {
        var status = ($(this).hasClass("am-btn-success"))?1:0;
        var uid = $(this).parents("tr").data("id");
        $.post("?_a=templatexcxmsg&_u=api.change_template_user_set_status",{uid:uid,status:status}, function (ret) {
            ret = $.parseJSON(ret);
            if(ret.errno==0){
                window.location.reload()
            }
        })
    });

    $(".cdelete").click(function () {
        $("#my-confirm").modal({
            relatedTarget: this,
            onConfirm: function(options) {
                var uid = $(this.relatedTarget).data("id");
                $.post("?_a=templatexcxmsg&_u=api.delete_user_template",{uids:uid}, function (ret) {
                    ret = $.parseJSON(ret);
                    if(ret.errno==0){
                        showTip("","删除成功","1000");
                        setTimeout(function () {
                            window.location.reload()
                        },1000);
                    }
                })
            }
        });
    })

});