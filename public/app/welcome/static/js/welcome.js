$('#id_commit').click(function(){
	var msg = $('#id_reply').val();

	if(!msg) {
		if(!confirm('内容为空，继续吗？')) {
			return;
		}
	}

	var data = {msg: msg};
	$.post('?_a=welcome&_u=sp', data, function($ret){
		alert($ret);
	});
	
});

$(document).ready(function () {
    $(".welcome-save").click(function () {
        var data = {
            media_uid: $("#dom").val()
        };
        $.post('?_a=welcome&_u=sp', data, function($ret){
            showTip("","修改成功",1000);
            setTimeout("history.back()",800);

        });
    })
});