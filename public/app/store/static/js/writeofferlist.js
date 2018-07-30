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
    $('.ceditall').click(function(){
        $(this).toggleClass('am-text-danger');
    });

    $('.creviews li').click(function(){
        var r = $(this).attr('sp');

        //todo 编辑模式
        if ($('.ceditall').hasClass('am-text-danger')) {
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
            if(!confirm('确定要标记吗?')) {
                return;
            }
            do_remark(uids, r);
        }
        else {
            window.location.href='?_a=store&_u=sp.writeofferlist&status=' + r;
        }
    });
    $('.creview li').click(function(){
        var r = $(this).attr('sp');
        var uid = $(this).parent().attr('data-uid');

        do_remark(uid, r);
    });
    $('.option_key_btn').click(function(){
        var key = $('.option_key').val();
        //允许关键字为空，表示清空条件
        if(1 || key) {
            window.location.href='?_a=store&_u=sp.writeofferlist&key='+key;
        }
    });
    $('.option_key').keydown(function(e){
        if(e.keyCode == 13) {
            $('.option_key_btn').click();
        }
    });

});
function do_delete(uids) {
	if(!(uids instanceof Array)) {
		uids = [uids];
	}
	var data = {uids: uids.join(';')};
	$.post('?_a=store&_u=api.del_writeoffer', data, function(ret){
		console.log(ret);
		window.location.reload();
	});
}
function do_remark(uids, sp_remark) {
	if(!(uids instanceof Array)) {
		uids = [uids];
	}
	
	//审核通过需要设置返现金额
	var data = {uids: uids.join(';'), status: sp_remark}
	$.post('?_a=store&_u=api.review_writeoffer', data, function(ret){
		console.log(ret);
		window.location.reload();
	});
}
