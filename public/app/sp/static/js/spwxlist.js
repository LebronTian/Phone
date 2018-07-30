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
	    $.post('?_a=sp&_u=api.delete_spwx', data, function(ret){
			ret = $.parseJSON(ret);
			if(ret && ret.errno == 0) {
	        	window.location.reload()
			}
	    });
	}

});
