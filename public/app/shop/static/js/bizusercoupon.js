/**
 * Created by Administrator on 2017/4/20 0020.
 */
function do_delete(uids) {
    if(!(uids instanceof Array)) {
        uids = [uids];
    }
    var data = {biz_uid:biz_uid,uids: uids.join(';')};

    $.post('?_a=shop&_u=api.delbizusercoupon', data, function(ret){
        console.log(ret);
        window.location.reload();
    });
}

$('.cdelete').click(function(){
    var uid = $(this).attr('data-id');
    if(!confirm('确定要删除吗?')) {
        return;
    }
    do_delete(uid);
});

$('.ccheckall').click(function(){
    var checked = $(this).prop('checked');
    $('.ccheck').prop('checked', checked);
});

$('.cdeleteall').click(function(){
    var uids = [];
    $('.ccheck').each(function(){
        if ($(this).prop('checked')) {
            uids.push($(this).parent().parent().attr('data-id'));
        }
    });
    console.log(uids);
    if(!uids.length) {
        alert('请选择项目!');return;
    }
    if(!confirm('确定要删除吗?')) {
        return;
    }
    do_delete(uids);
});