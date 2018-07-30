$(document).ready(function () {

    $(".save-set").click(function () {
        var title = $("#id_title").val().trim();
        if(title==""){
            showTip("err","请输入店铺名称",1000);
            $("#id_title").focus();
            return
        }
        var tpl = $('.tpl-container').data('dir');
        var point_limit = $('#point_limit').val();
        var discount_limit = $('#discount_limit').val();
        var discount = $('#discount').val();
        var logo = $(".logo-img").attr("src");
        var status = ($("#shop-status").is(":checked"))? 0:1 ;
        var notice = $("#id_notice").val().trim();

        if(point_limit>100)
        {
            showTip("err","积分额度不能超过100",1000);
            return
        }
        if(notice.length>128)
        {
            showTip("err","公告太长了，请删掉"+(notice.length-128)+"个字",1000);
            $("#id_notice").focus();
            return
        }
        //console.log(notice.length);
        //return
        var data= {
            title:title,
            tpl:tpl,
            point:{
                point_limit :point_limit,
                discount_limit:discount_limit,
                discount:discount
            },
            logo:logo,
            status:status,
            notice:notice
        };
        //console.log("data",data);return
        $.post("?_a=shop&_u=api.set",data, function (ret) {
            //showTip("ok","保存成功",1000);
            window.location.reload()
        })


    });
});