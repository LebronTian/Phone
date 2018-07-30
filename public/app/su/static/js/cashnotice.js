$('.save').click(function () {
    var cfg = {
			enabled: $('#id_status').prop('checked') ? 1 : 0,
            tid: ($('#id_tid').val()),
            kw2: (($('#id_kw2').val()))
	};

    $.post('?_a=su&_u=api.set_cashnotice', {cfg: cfg}, function (obj) {
        obj = $.parseJSON(obj);
        if (obj.errno == 0) {
            showTip("", "提交成功", 1000);
        } else {
            showTip("err", obj.errstr, 1000);
            return false;
        }
    });

});

$('#id_status').click(function(){
	update_cset();
});
function update_cset(){
	var disabled = !$('#id_status').prop('checked');
	if(disabled) {
		$('.cset input').attr('disabled', 'disabled');
	}
	else {
		$('.cset input').removeAttr('disabled');
	}
};
update_cset();

