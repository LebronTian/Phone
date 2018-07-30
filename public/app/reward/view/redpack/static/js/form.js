$(document).ready(function(){
	
	// 每个用户只能提交一次，判断是否已支付
	function checkPay(){
		var f_uid = $('#teleplone-val').attr('data-f-uid');
		var order_status = g_record_order_time;
		var order_uid = g_record_order_uid;
		var order_href = "?_a=pay&oid=d" + order_uid;
		if (order_status == null && order_uid == null) {
			console.log('未提交');
		}
		else if (order_status == null && order_uid != null) {
			window.location.href = order_href;
			window.localStorage.pay_return_url = window.location.href;
		}
		else{
			var success_href = "?_a=form&_u=index.success&f_uid=" + f_uid;
			window.location.href = success_href;
		}
	}
	checkPay();

	//提交
	$('#form-submit-btn').on('click', function(){
		var realname = $('#username-val').val();
		var phone = $('#teleplone-val').val();
		var mobilecode = $('#mobile-code-val').val();
		if($.trim(realname) && $.trim(phone) && $.trim(mobilecode)) {
			var data = {
				realname : realname,
				phone : phone,
				mobilecode : mobilecode
			}
			console.log(data);
			$.post('?_easy=su.ajax.update_su_profile', data, function(ret){
				ret = $.parseJSON(ret);
				console.log(ret);
				if(ret.errno == 0){
					//收起当前表单，显示支付页面
					$('#form-content').stop(true,true).animate({'height' : '0rem'}, 500, function(){
						$('#form-bar-1').hide();
						$('#form-bar-2').show(600);
					});
				}
				else{
					alert('提交失败，请重试');
				}
			});
		}
		else{
			alert('请先填写完整内容');
		}
		
	});

	//手机号
	$('#teleplone-val').on('blur', function(){
		var reg = /^1[3|4|5|6|7|8|9]+\d{9}$/g;
		if (!reg.test(this.value)) {
			$(this).val('');
			$(this).attr('placeholder','手机号格式错误');
		}
	});

	$('#teleplone-val').on('keyup', function(){
		var reg = /^1/g;
		if (!reg.test(this.value)) {
			$(this).val('');
		}
		else if(this.value.length>11){
			alert('手机号码长度已超出');
		}
		else if(this.value.length==11){
			$('#teleplone-val').blur();
		}
	});

	//获取验证码
	$(document).on('click', '#get-mobile-code-btn', function(){
		var code = $('#teleplone-val').val();
		if($.trim(code)){
			var data = {phone : code};
			console.log(data);
			$.post('?_easy=su.ajax.mobilecode', data, function(ret){
				ret = $.parseJSON(ret);
				//console.log(ret);
				console.log(ret);
				if(ret.errno == 0){
					console.log(ret);
					setTime();
				}
				if(ret.errno == 604){
					alert('您的操作过快，请稍后重试。');
				}
			});
		}
		else{
			alert('请先输入手机号码');
		}
	});

	//提交支付信息
	$('#submit_order_btn').on('click', function(){
		var realname = $('#username-val').val();
		var phone = $('#teleplone-val').val();
		var from_su_uid = cookie;
		var f_uid = $('#teleplone-val').attr('data-f-uid');
		
		if($.trim(realname) && $.trim(phone) && $.trim(from_su_uid)) {
			var data = [realname,phone,from_su_uid];
			var data = {
				data : data,
				f_uid : f_uid
			};
			console.log(data);

			$.post('?_easy=form.ajax.addformrecord', data, function(ret){
				ret = $.parseJSON(ret);
				console.log(ret);
				console.log(ret.errno);
				console.log("提交");
				if (ret.errno == 0) {
					// alert('成功');
					var order_uid = ret.data;
					// var order_uid = $.cookie('__form_order_uid');
					// alert(order_uid);
					// window.location.reload();
					var order_href = "?_a=pay&oid=d" + order_uid;
					var order_status = g_record_order_time;
					window.location.href = order_href;
					window.localStorage.pay_return_url = window.location.href;
					// var order_uid = g_record_order_uid;
					// console.log(order_status);
					// console.log(order_uid);
					// 
					// alert(order_href);
					// var success_href = "?_a=form&_u=index.success&f_uid=" + f_uid;
					// if (order_status == null && order_uid == null) {
					// 	window.location.href = order_href;
					// 	window.localStorage.pay_return_url = window.location.href;
					// }
					// else{	
					// 	window.location.href = success_href;
					// }
				}else{
					alert('提交失败，请重试');
				}
			});

		}		
	});

});

function setTime(){
	var timer = null;
	var times = 60;
	if(timer){
		clearInterval(timer);
		timer= null;
	}
	timer= setInterval(function(){
		times--;
		if(times<=0){
			clearInterval(timer);
			$('#wait-to-send').replaceWith('<button id="get-mobile-code-btn">获取</button>');
			times= 60;
			
		}else{
			$('#get-mobile-code-btn').replaceWith('<button id="wait-to-send"></button>');
			$('#wait-to-send').text(times+'秒后重试').addClass('on');	
		}
	},1000);
}