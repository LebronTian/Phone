
$(document).ready(function () {
    /**/

    /*删除模板***********************/
    $(".delBtn").click(function () {
        var r = confirm("继续删除将无法恢复。");
        if(r==true){
            var Did = $(this).attr( "data-id");
            do_delete(Did)
        }
    });
    /*全部删除**********************/
    $('.delAll').click(function(){
        var uids = [];
        $('.delCheck:checked').each(function(){
            uids.push($(this).parent().parent().attr('data-id'));
        });
        if(!uids.length) {
            alert('请选择项目!');return;
        }
        if(!confirm('确定要删除吗?')) {
            return;
        }
        do_delete(uids);
    });
    /*全选******************************/
    $('.ccheckall').click(function(){
        var checked = $(this).prop('checked');
        $('.delCheck').prop('checked', checked);
    });
    /*上下架按钮*********************/
    $('.pStatus').click(function(){
        var uid = $(this).parent().parent().attr('data-id');
        var status;
        if($(this).hasClass("am-btn-success")){
            status = 2
        }else{
            status = 1
        }
        var data = {uid:uid, status:status};
        $.post('?_a=shop&_u=api.addbiz', data, function(ret){
            console.log(ret);
            window.location.reload();
        });
    });
    /*加不加V*********************/
    $('.paddv').click(function(){
        var uid = $(this).parent().parent().attr('data-id');
        var hadv;
        if($(this).hasClass("am-btn-warning")){
            hadv = 0
        }else{
            hadv = 1
        }
        var data = {uid:uid, hadv:hadv};
        $.post('?_a=shop&_u=api.addbiz', data, function(ret){
            console.log(ret);
            window.location.reload();
        });
    });
    /*是否推荐*********************/
    $('.paddrecommend').click(function(){
        var uid = $(this).parent().parent().attr('data-id');
        var hadrecommend;
        if($(this).hasClass("am-btn-secondary")){
            hadrecommend = 0
        }else{
            hadrecommend = 1
        }
        var data = {uid:uid, hadrecommend:hadrecommend};
        $.post('?_a=shop&_u=api.addbiz', data, function(ret){
            console.log(ret);
            window.location.reload();
        });
    });
});
/*删除接口*****************/
function do_delete(uids) {
    if(!(uids instanceof Array)) {
        uids = [uids];
    }
    var data = {uids: uids.join(';')};
    $.post('?_a=shop&_u=api.delbiz', data, function(ret){
        window.location.reload()
    });
}


$('.option_key_btn').click(function(){
    var key = $('.option_key').val();
    //允许关键字为空，表示清空条件
    if(1 || key) {
        //var cat = $(this).val();
        window.location.href='?_a=shop&_u=sp.bizlist&key='+key;
    }
});
$('.option_key').keydown(function(e){
    if(e.keyCode == 13) {
        $('.option_key_btn').click();
    }
});