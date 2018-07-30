function do_delete(uid) {
	var data = {uid: uid};
	$.post('?_a=subsp&_u=api.del_subsp', data, function(ret){
		console.log(ret);
		//window.location.reload();
	});
}

$('.cdelete').click(function(){
	var uid = $(this).attr('data-id');
	if(!confirm('确定要删除吗?')) {
		return;
	}
	do_delete(uid);
});

