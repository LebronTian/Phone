var by_amaze_init = 1;
$(".option_cat").change(function () {
	if(by_amaze_init) {
		by_amaze_init = 0;
		return;
	}
	var status = $(this).val();
	if(status ==-1)
	{
		status='';
	}
	var key = $('.option_key').val();
	//允许关键字为空，表示清空条件
	if(1 || key) {
		var cat = $(this).val();
		window.location.href = "?_a=shop&_u=sp.agent&key=" + key + "&status=" + status;
	}
});

$(".option_check").change(function () {
	var init = $(this).data('init');
	if(!init){
		$(this).data('init',1);
		return
	}
	console.log('222')
	var status = $(this).val();
	var uid = $(this).parent().parent().data('uid');
	var data = {
		uid: uid,
		status:status
	};
	console.log(data);
	$.post('?_a=shop&_u=api.edit_shop_agent', data, function(ret){
		ret = $.parseJSON(ret);
		console.log(ret);
		if (ret.errno == 0) {
			showTip("", "保存成功", "1000");
			window.location.reload();
		}
	});
});

$('.option_key_btn').click(function(){
	var key = $('.option_key').val();
	//允许关键字为空，表示清空条件
	if(1 || key) {
		window.location.href='?_a=shop&_u=sp.agent&key='+key;
	}
});
$('.option_key').keydown(function(e){
	if(e.keyCode == 13) {
		$('.option_key_btn').click();
	}
});



$(function() {
	var uid;
	$(".edit_notice").on('click', function () {
		uid = $(this).parent().parent().data('uid');
		$('.Editnotice_tips').empty();
		var notice = $(this).parent().children('.agent_notice').val().trim();
		var title = $(this).parent().children('.agent_title').val().trim();

		$('#Editnotice #id_notice').val(notice);
		$('#Editnotice #id_title').val(title);
		var $promt = $('#Editnotice').modal({
			relatedTarget: this,
			width: 1000,

		});
		$promt.find('[data-am-modal-confirm]').off('click.close.modal.amui');
		return ;
	});

	var $confirm = $('#Editnotice');
	var $confirmBtn = $confirm.find('[data-am-modal-confirm]');
	$confirmBtn.off('click.confirm.modal.amui').on('click', function() {

		$('.Editnotice_tips').empty();
		var notice = $("#id_notice").val().trim();
		var title = $("#id_title").val().trim();
		if(notice.length>128)
		{
			$('.Editnotice_tips').append('<span class="am-btn am-btn-danger">"公告太长了，请删掉"+(notice.length-128)+"个字"</span>');
			return
		}
		if(title.length>64)
		{
			$('.Editnotice_tips').append('<span class="am-btn am-btn-danger">"公告太长了，请删掉"+(notice.length-64)+"个字"</span>');
			return
		}
		data = {
			uid:uid,
			notice:notice,
			title:title
		};
		$.post('?_a=shop&_u=api.edit_shop_agent', data, function (ret) {
			console.log(ret);
			ret = $.parseJSON(ret);
			if (ret.errno == 0) {
				showTip("", "保存成功", "1000");
				setTimeout(function () {
					$('#Editnotice').modal('close');
					window.location.reload();
				}, 1000);
			}
			else {
				$('.Editnotice_tips').append('<span class="am-btn am-btn-danger">保存失败</span>');
			}
		});
	});

});