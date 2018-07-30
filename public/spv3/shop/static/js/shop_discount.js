$('.save').click(function(){
    var man = 100*$('#id_man').val();
    var jian = 100*$('#id_jian').val();
    var data = {man: man, jian: jian};
    $.post('?_a=shop&_u=sp.shop_discount', data, function(ret){
        console.log(ret);
        ret=$.parseJSON(ret);
        console.log('444');
        console.log(ret);
        if(ret.errno=="0"){
            showTip('ok', '保存成功', 1000);
            window.location.reload();
        }else{
            showTip('ok', '保存失败',1000);
        }
        console.log('555');
    });
});

$('.cdel').click(function() { 
if(!confirm('确定要删除吗?')) return;
    var key = $(this).attr('data-id');
    var data = {man: key, del: 'del'};
    $.post('?_a=shop&_u=sp.shop_discount', data, function(ret){
        ret=$.parseJSON(ret);
        console.log(ret);
        window.location.reload();
	});
});

