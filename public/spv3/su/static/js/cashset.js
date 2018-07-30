$('.saveBtn').click(function(){

    var rule = [];
    var ret;
    var pay_cash = 0;
    $('.data-rule .rules').each(function (index) {
        //console.log($(this).val());
        var a = [];
        if(parseInt(pay_cash*100) >= parseInt(($(this).find('#pay_cash').val())*100)){
            showTip('err','请修改充值金额，且保持递增且大于0',1500);
            ret = 1;
            return;
        }
        pay_cash = $(this).find('#pay_cash').val();
        if (pay_cash == ''||pay_cash == 0) {
            showTip('err','充值金额不能为空/0',1000);
            ret = 1;
            return;
        }
        var get_cash = $(this).find('#get_cash').val();
        //if (get_cash == '') {
        //    showTip('err','赠送金额不能为空',1000);
        //    ret = 1;
        //    return;
        //}
        if (pay_cash < 0) {
            showTip('err','充值金额不能为负数',1000);
            ret = 1;
            return;
        }
        if (get_cash < 0) {
            showTip('err','赠送金额不能为负数',1000);
            ret = 1;
            return;
        }
        var group = $(this).find('.sel-group').children("option:selected").val();
        a = [parseInt(pay_cash*100),parseInt(get_cash*100),group];
        rule.push(a);
        //rule[parseInt(pay_cash*100)] = parseInt(get_cash*100);
    });
    if(ret){
        return;
    }
    if(!$('#id_check').is(':checked')){
        rule = [];
    }

    var status = $('#id_check').prop('checked') ? 1 : 0;
    var cgroup = $('#id_yes').prop('checked') ? 1 : 0;

	var data = {uid:uid,rule:rule,status:status,cgroup:cgroup};
    console.log(data);
	$.post('?_a=su&_u=api.setcashrule', data, function(ret){
        data = $.parseJSON(ret);
		console.log(data);
        if(data.errno==0){
            showTip('ok','保存成功',1000);
            setTimeout(function(){
                window.location.href='?_a=su&_u=sp.cashset';
            },1000);

        }
	});
});

$('.data-rule').on('click','.delete_rule_rank', function () {
	if(!confirm('确定要删除吗?')) return;
    $(this).parent().parent().remove();
})

$(".add_rule_rank").click(
    function()
    {
        var explame_html = $(".hide-explame").html();
        //console.log(explame_html);
        $(".data-rule").append(explame_html);
    }
);

$("#id_check").change(function() {
    if($(this).is(':checked')){
        $('.form_status').show();
    }else{
        $('.form_status').hide();
    }
});
if(!$('#id_check').is(':checked')){
    $('.form_status').hide();
}
