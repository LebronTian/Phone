$(".saveBtn").click(function () {
    var need_check = $('#id_check').prop('checked') ? 1 : 0;
    var rank_rule = {};
    var error = 0;
    var error_msg ='';
    var last_rule_point = -1;
    if($(".data-rule").children().length==0)
        last_rule_point = 1;
    $(".data-rule").children().each(function()
    {
        var rule_point =  parseInt($(this).find('#id_rule_point').val());
        console.log(rule_point,last_rule_point);
        if((rule_point<=last_rule_point) || rule_point <0)
        {
            last_rule_point =-1;
        }
        else
        {
            last_rule_point = rule_point;

        }
        console.log(rule_point,last_rule_point);

        var rule_name  =  $(this).find('#id_rule_name').val();
        var rule_discount  = parseFloat($(this).find('#id_rule_discount').val()).toFixed(1);
        if(isNaN(rule_discount) || rule_discount>10 || rule_discount<=0 || rule_discount==undefined || rule_discount==0 )
        {
            error =1;
            error_msg = '折扣设置有误,请设置一个0-10直接的数字，最多一位小数';
            return false ;
        }
        rank_rule[rule_point]={"rank_name":rule_name,"rank_discount":rule_discount*10};
    });
    console.log(rank_rule);
    if(last_rule_point<0||last_rule_point>9999999999)
    {
        showTip("err","请修改积分，请保持递增 且 大于0 且 不超过10位","1000");
        return;
    }
    if(error>0)
    {
        showTip("err",error_msg,"1200");
        return;
    }
    var data = {
        uid:uid,
        rank_rule:rank_rule,
        need_check:need_check
    };
    $.post("?_a=vipcard&_u=api.add_or_edit_vip_card_sp_set",data, function (ret) {
        ret=$.parseJSON(ret);
        if(ret.errno==0){
            showTip("","保存成功","1000");
            setTimeout(function () {
                window.location.reload()
            },1000);
        }
        else
        {
            showTip("err","保存失败","1000");
        }
    })
});

$('.data-rule').on('click','.delete_rule_rank', function () {
    $(this).parent().parent().remove();
})

$(".add_rule_rank").click(
    function()
    {
        var explame_html = $(".hide-explame").html();
        console.log(explame_html);
        $(".data-rule").append(explame_html);
    }
);

