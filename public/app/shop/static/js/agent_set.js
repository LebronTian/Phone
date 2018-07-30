$('.save').click(function () {

    var status = $('#id_status').prop('checked') ? 0 : 1;
    var need_check = $('#id_need_check').prop('checked') ? 1 : 0;
    var weight = $('.agent_paid_fee input').last().val();
    var value = $('.agent_bonus input').last().val();
    var cost ={
        status:$('.agent_cost input').first().prop('checked') ? 1 : 0,
    };
    var paid_fee ={
        status:$('.agent_paid_fee input').first().prop('checked') ? 1 : 0,
        weight:(isNaN(weight)?0:weight)*100
    };
    var bonus = {
        status:$('.agent_bonus input').first().prop('checked') ? 1 : 0,
        value:(isNaN(value)?0:value)*100
    };
    //console.log(paid_fee.weight);
    if(paid_fee.status ==1 && (paid_fee.weight>10000 || paid_fee.weight<=0))
    {
        showTip("err","分红比例设置有误，请重新设置。</br>0-100","1000");
        return ;
    }
    //return;
    var rule_data = {
        cost:cost,
        paid_fee:paid_fee,
        bonus:bonus
    }

    var data = {
        status: status,
        rule_data: rule_data,
        need_check:need_check
    };
    console.log(data);
    $.post('?_a=shop&_u=api.add_or_edit_shop_agent_set', data, function (ret) {
        console.log(ret);
        ret=$.parseJSON(ret);
        if(ret.errno==0){
            showTip("","保存成功","1000");
            setTimeout(function () {
                window.location.reload();
            },1000);
        }
        else
        {
            showTip("err","保存失败","1000");
        }
    });
});

