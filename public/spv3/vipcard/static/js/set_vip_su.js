
$(document).ready(function () {

    $('.save').click(function(){

        var point_max = $(".sel-level").children("option:selected").val();

        var user_id = $('#id_user').attr('data-uid') || null;
        var data = {
            su_uid:user_id,
            point_max:point_max
        };
        console.log(data);
        $.post('?_a=vipcard&_u=api.add_vip_card', data, function(ret){
            console.log(ret);
            ret = $.parseJSON(ret);
            if(ret.errno==0){
                if(ret.data == 0){
                    showTip('err','已是会员',1000);
                }else{
                    showTip('ok','设置成功',1000);
                }
            }
            else {
                showTip('err','设置出错',1000);

            }
        });
    });


});

select_user({ele: '#id_user', single: true, onok: function(su) {
    console.log('selected', su);
    $('#id_user').attr('data-uid', su.uid);
    $('#id_user img').attr('src', su.avatar || '/static/images/null_avatar.png');
    $('#id_user span').text(su.name);
}});
