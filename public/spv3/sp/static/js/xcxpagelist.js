$(document).ready(function(){

	$(".delBtn").click(function(){
		var uids = $(this).attr('data-id');
		if(window.confirm("您确定要删除么，删除数据不能恢复")){
			do_delete(uids);
		}	
	});

	// 全选按钮；
	$('.dcheckall').click(function(){
		var checked = $(this).prop('checked');
		$('.delCheck').prop('checked', checked);
	});

	/*
		全部删除
	*/
	$('.delAll').click(function(){
		// alert("I miss you much!");
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


	function do_delete(uids) {
	    if(!(uids instanceof Array)) {
	        uids = [uids];
	    }
	    var data = {uids: uids.join(';')};
	    $.post('?_a=sp&_u=api.delete_xcxpage', data, function(ret){
	        window.location.reload()
	    });
	}

    /*上下架按钮*********************/
    $('.pStatus').click(function(){
        var uid = $(this).parent().parent().attr('data-id');
        var status;
        if($(this).hasClass("am-btn-success")){
            status = 1
        }else{
            status = 0
        }
        var data = {uid:uid, status:status};
        $.post('?_a=sp&_u=api.add_xcxpage', data, function(ret){
            console.log(ret);
            window.location.reload();
        });
    });
    /*$(".copyBtn").click(function(){
		var uids = $(this).attr('data-id');
		if(window.confirm("您确定要复制吗？")){
			console.log(uids);
			
		};	
	});*/
});

$('.showerweima').mouseover(function(){
	var $qr = $(this).find(".wap_erweima img");
	console.log($qr, $qr.attr('src2'));
	$qr.attr('src', $qr.attr('src2'));
	$qr.parent().show();
	
});
$('.showerweima').mouseout(function(){
	$(this).children(".wap_erweima").hide();

});




