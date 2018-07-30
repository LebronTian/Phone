$('.save').click(function(){
	var cash = $('#id_cash').val() * 100;
	var max = $('#TodayFans').text() * 100;
	console.log('hehe', cash, max);
	if(cash <= 0 || cash > max) {
		showTip('err', '金额错误！', 3000);
		return;
	}

	if(!$('#id_open_id').length) {
		showTip('err', '收款微信号未设置！', 3000);
		return;
	}
 
	var mobilecode = $('#id_mobilecode').val();
	if(!mobilecode) {
		showTip('err', '请填写手机验证码！', 3000);
		return;
	}

	var data = {cash: cash, mobilecode: mobilecode};
	$.post('?_a=pay&_u=api.do_transfer', data, function(ret){
		console.log(ret);
		ret = $.parseJSON(ret);
		if(ret && !ret.errno && ret.data) {
			showTip('ok','提现成功',1000);
		}
		else {
			showTip('err','提现失败',1000);
		}
	});
});

$('#id_change').click(function(){
	$.get('?_a=wxcode&_u=index.uct_uctpay_transfer', function(ret){
		console.log(ret);
		ret = $.parseJSON(ret);
		if(!ret || !ret.data || !ret.data.img_url) {
			showTip('err', '系统错误，请刷新页面重试！', 3000);
			return;
		}

		$('#id_change').parent().html('<img src="'+ ret.data.img_url +'" width=140 height=140><small>微信扫一扫设置提现微信号, 完成后请刷新页面</small>');
	});
});

var g_seconds = 60;
function run_countdown() {
	g_seconds--;
	if(g_seconds <= 0) {
		$('#id_send_mobilecode').text('发送验证码').removeAttr('disabled');
	}
	else {
		$('#id_send_mobilecode').text('请稍候 ' + g_seconds);
		setTimeout('run_countdown()', 1000);
	}
}

$('#id_send_mobilecode').click(function(){
	$(this).attr('disabled', 'disabled');
	g_seconds = 60;
	run_countdown();
	$.get('?_a=sp&_u=api.mobilecode&phone=' + g_phone, function(ret){
		console.log(ret);
	});
});


if(!$('#id_open_id').length) {
	$('#id_change').click();
}
	
