$('.set_tpl').click(function(){
    var vip_card_tpl_uid = $(this).data('tpl_uid');
    var data = {
        uid:uid,
        vip_card_tpl_uid:vip_card_tpl_uid
    }

    $.post('?_a=vipcard&_u=api.add_or_edit_vip_card_sp_set', data, function (ret) {
        console.log(ret);
        ret=$.parseJSON(ret);
        if(ret.errno==0){
            showTip("","保存成功","1000");
            setTimeout(function () {
                window.location.href=document.URL;
            },1000);
        }
        else
        {
            showTip("err","保存失败","1000");
        }
        //console.log(ret);

    });
});

$(function() {
    $('.cdelete').on('click', function() {
        var uid = $(this).attr('data-id');
        $('#my-confirm').modal({
            relatedTarget: this,
            onConfirm: function(options) {
                do_delete(uid);
            },
            onCancel: function() {
            }
        });
    });
});


function do_delete(uids) {
    var data = {uid: uids }
    $.post('?_a=vipcard&_u=api.delete_vipcard_tpl', data, function(ret){
        console.log(ret);
        ret=$.parseJSON(ret);
        if(ret.errno==0){
            showTip("","删除成功","1000");
            setTimeout(function () {
                window.location.reload();
            },1000);
        }
        else
        {
            showTip("err","删除失败","1000");
        }
    });
}