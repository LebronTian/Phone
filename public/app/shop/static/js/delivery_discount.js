$('.save').click(function(){
    var free = 100*$('#id_fee').val();
    var cnt = $('#id_cnt').val();
    var rule = {free_fee: free, free_cnt: cnt};
    $.post('?_a=shop&_u=sp.delivery_discount', {rule: rule}, function(ret){
        console.log(ret);
        ret=$.parseJSON(ret);
        console.log('444');
        console.log(ret);
        if(ret.errno=="0")
            showTip('ok', '保存成功', 1000);
        else
            showTip('ok', '保存失败',1000);
        console.log('555');
    });
});


