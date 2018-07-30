function do_delete(uid) {
	var data = {uid: uid};
	$.post('?_a=sp&_u=api.del_public', data, function(ret){
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

$(document).ready(function () {
    //$(".table-main").children("tbody").children("tr").mouseenter(function () {
    //    $(this).find(".default-btn").show()
    //}).mouseleave(function () {
    //    $(this).find(".default-btn").hide()
    //});
    $(".default-btn").click(function () {
        var uid = $(this).data("uid");
        $.post('?_a=sp&_u=api.change_default_weixin',{uid:uid}, function (ret) {
            window.location.reload()
        })
    })
});