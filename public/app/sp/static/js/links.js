
$(document).ready(function () {
    /*删除模板***********************/
    $(".delBtn").click(function () {
        var r = confirm("继续删除将无法恢复。");
        if(r==true){
            var Did = $(this).attr( "data-id");
            do_delete(Did)
        }
    });


});
/*删除接口*****************/
function do_delete(uids) {
    if(!(uids instanceof Array)) {
        uids = [uids];
    }
    var data = {uids: uids.join(';')};
    $.post('?_a=sp&_u=api.del_link', data, function(ret){
        window.location.reload()
    });
}

$('.option_key_btn').click(function(){
	var key = $('.option_key').val();
	//允许关键字为空，表示清空条件
	if(1 || key) {
		window.location.href='?_a=sp&_u=index.links'+'&key='+key;
	}
});
$('.option_key').keydown(function(e){
	if(e.keyCode == 13) {
		$('.option_key_btn').click();
	}
});

