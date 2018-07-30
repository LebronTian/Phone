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
	    $.post('?_a=sp&_u=api.delete_problem', data, function(ret){
			//console.log(ret);
	        window.location.reload()
	    });
	}

});

/*
 amazeui 会调用一次change事件,此时不刷新
 */
var by_amaze_init = 1;
$('.option_type').change(function(){
	if(by_amaze_init) {
		by_amaze_init = 0;
		return;
	}

	var type = $(this).val();
	window.location.href='?_a=sp&_u=index.problemlist&type=' + type;
});