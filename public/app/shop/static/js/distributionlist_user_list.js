
/*
	amazeui 会调用一次change事件,此时不刷新
*/


$('.option_key_btn').click(function(){
	var key = $('.option_key').val();
	//允许关键字为空，表示清空条件
	if(1 || key) {
		var cat = $(this).val();
		window.location.href='?_a=shop&_u=sp.distribution_user_list'+'&key='+key;
	}
});
$('.option_key').keydown(function(e){
	if(e.keyCode == 13) {
		$('.option_key_btn').click();
	}
});


/*yhc*/
$(document).ready(function () {

    $(".cdelete").click(function(){
        var uids = $(this).attr('data-id');
        if(window.confirm("您确定要删除么，删除数据不能恢复")){
            do_delete(uids);
        }

    });

    function do_delete(uids) {
        if(!(uids instanceof Array)) {
            uids = [uids];
        }
        var data = {su_uids: uids.join(';')};
        $.post('?_a=shop&_u=api.delete_distribution_user', data, function(ret){
            console.log(ret);
            //window.location.reload()
        });
    }

    $(".status-sel li").click(function () {
        var uid = $(this).parent().data('uid');
        var status = $(this).data("pass");
        var data = {
            su_uid:uid,
            status:status
        };
        console.log(data);
        $.post('?_a=shop&_u=api.review_user_dtb', data, function(ret){
            window.location.reload();
        });
    })
});


