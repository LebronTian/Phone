$(function () {



    $(".save-set").click(function () {

        var tpl = $('.tpl-container').data('dir');

        var status = ($("#id_status").prop("checked"))? 0:1 ;
        var point = $("#id_point").val();
        var rule_data = [];
        rule_data[0] = 0;
        rule_data[1] = point;
        var data= {
            uid:usign_set.uid,
            tpl:tpl,
            status:status,
            rule_data:rule_data,
        };
        console.log("data",data);
        $.post("?_a=usign&_u=api.edit_usign_set",data, function (ret) {
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

