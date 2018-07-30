
function do_update(level,address) {

    var data = {level: level,address:address};
    console.log(data);
    $.post('?_a=shop&_u=api.upaddress',data, function(ret){
        var ret=JSON.parse(ret);
        console.log(ret);
        if (ret.errno == 0) {
            showTip("ok","修改地址级名称成功",1000);
        } else {
            showTip("err", '修改地址级名称失败', 1000);
            return false;
        }

        //window.location.reload();
    });
}

$('.cupdate').click(function(){
    var level = $(this).attr('data-id');
    var vid='#address'+level;
    var address = $(vid).val();//

    if(!confirm('确定要修改吗?')) {
        return;
    }
    do_update(level,address);
});

