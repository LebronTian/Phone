

$(function() {
    $('.option_key_btn').click(function(){
        var key = $('.option_key').val();
        var card_id = $('.option_card_id').val();
        //允许关键字为空，表示清空条件
        if(1 || key ||card_id) {
            window.location.href='?_a=vipcard&_u=sp.vip_card_list&key='+key+'&card_id='+card_id;
        }
    });
    $('.option_key').keydown(function(e){
        if(e.keyCode == 13) {
            $('.option_key_btn').click();
        }
    });

    $('.card_url').mouseenter(function(){
        var html_data ='<div class="card_img" style="z-index:9999;position:absolute;top:0;right:105% ">'+
            '<img style="width:400px;max-height:none; max-width:none; " src="'+$(this).data('card_url')+'" alt="重新生成中，可刷新页面查看" >';
        $(this).append(html_data);
        $(this).css('position','relative');
    });
    $('.card_url').mouseleave(function(){

        $(this).text('查看');

    });
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
    $('.refresh').on('click', function() {
        var su_uid = $(this).attr('data-su_uid');
        $('#my-refresh').modal({
            relatedTarget: this,
            onConfirm: function(options) {
                do_refresh(su_uid);
            },
            onCancel: function() {
            }
        });
    });
});

$('.ccheckall').click(function(){
    var checked = $(this).prop('checked');
    $('.ccheck').prop('checked', checked);
});
$('.cdeleteall').click(function(){
    var uids = [];
    $('.ccheck').each(function(){
        if ($(this).prop('checked')) {
            uids.push($(this).parent().parent().find('.cdelete').attr('data-id'));
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
$('.crerefreshall').click(function(){
    var uids = [];
    $('.ccheck').each(function(){
        if ($(this).prop('checked')) {
            uids.push($(this).parent().parent().find('.refresh').attr('data-su_uid'));
        }
    });
    console.log(uids);
    if(!uids.length) {
        alert('请选择项目!');return;
    }
    if(!confirm('确定要刷新吗?')) {
        return;
    }
    do_refresh(uids);
});
function do_delete(uids) {
    if(!(uids instanceof Array)) {
        uids = [uids];
    }
    var data = {uids: uids.join(';')}
    $.post('?_a=vipcard&_u=api.delete_vip_card', data, function(ret){
        ret = $.parseJSON(ret);
        if (ret.errno == 0) {
            console.log(ret);
            showTip("", "删除成功，请稍后", "1500");
            window.location.reload();
        }
        else
        {
            showTip("err", "删除成功，请稍后", "1500");
        }
    });
}

function do_refresh(uids)
{
    if(!(uids instanceof Array)) {
        uids = [uids];
    }
    var data = {uids: uids.join(';')}
    $.post('?_a=vipcard&_u=api.refresh_vip_card_image', data, function(ret){
        console.log(ret);
        ret = $.parseJSON(ret);
        if (ret.errno == 0) {
            showTip("", "刷新任务已经开启，请稍后", "1500");
            window.location.reload();
        }

    });
}
var by_amaze_init = 1;
$(".option_cat").change(function () {
    if(by_amaze_init) {
        by_amaze_init = 0;
        return;
    }
    var status = $(this).val();
    if(status ==-1)
    {
        status='';
    }
    var key = $('.option_key').val();
    //允许关键字为空，表示清空条件
    if(1 || key) {
        var cat = $(this).val();
        window.location.href = "?_a=vipcard&_u=sp.vip_card_list&key=" + key + "&status=" + status;
    }
});

$(".option_check").change(function () {
    var init = $(this).data('init');
    console.log(init);
    if(!init){
        $(this).data('init',1);
        return
    }
    var status = $(this).val();
    var uid = $(this).parent().parent().data('uid');
    var data = {
        uid: uid,
        status:status
    };
    console.log(data);
    $.post('?_a=vipcard&_u=api.add_or_edit_vip_card_su', data, function(ret){
    //$.post('?_a=vipcard&_u=api.do_check_vip_card', data, function(ret){
        ret = $.parseJSON(ret);
        console.log(ret);
        if (ret.errno == 0) {
            showTip("", "保存成功", "1000");
            window.location.reload();
        }
        //else
        //{
        //    showTip("err", "修改失败，只有未通过的可以修改", "1500");
        //    window.location.reload();
        //}
    });
});

