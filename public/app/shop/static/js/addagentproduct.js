$('.ccheckall').click(function(){
    var checked = $(this).prop('checked');
    $('.ccheck').prop('checked', checked);
});
$('#savebtn').click(function(){
    var uids = [];
    $('.ccheck').each(function(){
        if ($(this).prop('checked')) {
            uids.push($(this).parent().parent().attr('data-uid'));
        }
    });
    console.log(uids);
    if(!uids.length) {
        alert('请选择项目!');return;
    }
    if(!confirm('确定要添加吗?')) {
        return;
    }
    data = {
        p_uids:uids,
        a_uid:a_uid,
    }
    $.post('?_a=shop&_u=api.add_shop_agent_to_user_product', data, function(ret){
        console.log(ret);
        ret = $.parseJSON(ret);
        if(ret.errno==0){
            showTip('ok','添加成功',1000);
            setTimeout(function(){
                window.location.reload();
            },1000);

        }
        else
            showTip('err','保存失败',1000);

    });
});
