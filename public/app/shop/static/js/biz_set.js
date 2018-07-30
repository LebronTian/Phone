$(document).ready(function () {

    $(".save-set").click(function () {

        var default_status = ($("#default-status").is(":checked"))? 0:1 ;

        //console.log(notice.length);
        //return
        var data= {
            default_status:default_status
        };
        //console.log("data",data);return
        $.post("?_a=shop&_u=api.edit_biz_set",data, function (ret) {
            window.location.reload()
        })


    });
});