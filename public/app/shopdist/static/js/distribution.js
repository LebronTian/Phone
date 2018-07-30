$('.save').click(function () {

    var status = $('#id_status').prop('checked') ? 0 : 1;
    var need_vip = $('#id_vip').prop('checked') ? 0 : 1;
    var need_check = $('#id_check').prop('checked') ? 1 : 0;

    //var group_name = $('#group_name').val();
    var model = $('input[name="model-radio"]:checked').val();
    var fullPrice = parseInt($("#fullPrice").val()*100);


    var rule = [];
    var data_sum =0;
    var error_no =0;
    var error_str = '';
    $('.distribution').each(function (index) {
            //console.log($(this).val());
            var a = [];
            var weight = $(this).find('#id_weight').val();
            if (weight == '') {
                weight = 0;
            }
            var fix = $(this).find('#id_fix').val();
            if (fix == '') {
                fix = 0;
            }
            if (fix < 0) {
                error_no =1;
                error_str = '佣金不能设置为一个负数';
            }
            a = [parseInt(weight*100),parseInt(fix*100)];
            rule.push(a);
            data_sum+=parseInt(weight);
        }
    );
    if(error_no>0)
    {
        showTip('err',error_str,1000);
        return;
    }
    if(data_sum>=100)
    {
        console.log(data_sum);
        showTip('err','各级比例总和不能超过100',1000);
        return;
    }
    var data = {
        uid: uid,
        rule: rule,
        status: status,
        need_vip:need_vip,
        need_check: need_check,
        model: model,
        fullprice: fullPrice,
        //group_name:group_name,
    };
    console.log(data);
    $.post('?_a=shop&_u=api.edit_distribution_rule', data, function (ret) {
        console.log(ret);
        ret=$.parseJSON(ret);
        if(ret.errno==0){
            showTip("","保存成功","1000");
            setTimeout(function () {
                window.location.href = '?_a=shop&_u=sp.distribution';
            },1000);
        }
        else
        {
            showTip("err","保存失败","1000");
        }
        //console.log(ret);

    });
});

