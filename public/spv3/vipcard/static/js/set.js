$(function () {



    $(".save-set").click(function () {

        var tpl = $('.tpl-container').data('dir');

        var status = ($("#id_status").prop("checked"))? 0:1 ;
        var title = $("#id_title").val() ;

        var data= {
            uid:vip_card.uid,
            title:title,
            tpl:tpl,
            status:status,
        };
        console.log("data",data);
        $.post("?_a=vipcard&_u=api.add_or_edit_vip_card_sp_set",data, function (ret) {
            ret=$.parseJSON(ret);
            if(ret.errno==0){
                showTip("","保存成功","1000");
                setTimeout(function () {
                    window.location.reload()
                },1000);
            }

        })

    });

    // var selected_tpl = '';
    // if(vip_card&&vip_card.tpl){
    //     selected_tpl = vip_card.tpl;
    // }
    // $('.tpl-container').selectTpl({
    //     //url:'?_a=shop&_u=api.get_tpls',
    //     url:tpl_url,
    //     selected:selected_tpl
    // })
});

