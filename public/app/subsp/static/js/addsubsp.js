//如果是编辑，"显示"密码
if($('.am-form').attr('data-uid') > 0) {
	$('#id_passwd').val('********');
	$('#id_passwd2').val('********');
}

$('.save').click(function(){
	var uct_tokens = []; //多个公众号;分开
	$.each($('.uct_tokens input:checked'), function(){
		var k = $(this).val();
		uct_tokens.push(k);
	});
	uct_tokens = uct_tokens.join(';');
	console.log('uct_tokens', uct_tokens);
	var access_rule = {};
	if(!$('.limit_box').is(':visible')) {
		access_rule = {'*': 1}; //不限
	}
	else {
		access_rule = {'*': 0}; //限制
		$.each($('.parent_box input:checked'), function(){
			var k = $(this).val();
			access_rule[k + '.*'] = 1;
			console.log(this, $(this).parent().parent().next('.detail_box'));
			$.each($(this).parent().parent().next().find('input:not(:checked)'), function(){
				var kk = $(this).val();
				access_rule[kk] = 0;
			});
		});
	}

	//access_rule['sp.*'] = 1;
	//console.log(access_rule);return;

	var store_uids = $('.option_store_uids').val(); //门店，现在只支持了1个

	var uid = $('.am-form').attr('data-uid');
	var name = $('#id_name').val();
	var account = $('#id_account').val();
	var passwd = $('#id_passwd').val();
	if(passwd && (passwd != $('#id_passwd2').val())) {
		alert('密码不一致');
		return;
	}
	if(!uid && !passwd) {
		alert('请设置一个密码');
		return;
	}

	var data={uid:uid, name:name, account:account, passwd:passwd, uct_tokens:uct_tokens, access_rule:access_rule, store_uids: store_uids};
	if(passwd == '********') delete data['passwd'];
	$.post("?_a=subsp&_u=api.add_subsp",data,function(obj){
		console.log(obj);
		obj=$.parseJSON(obj)
		if(obj.errno==0){
			window.location.href='?_a=subsp&_u=sp.index';
		}
		else {
			showTip('err', '错误！账号已存在！', 3000);
		}
	});
});

$('.select_limit').click(function(){
	$('.limit_box').show();
});
$('.select_unlimit').click(function(){
	$('.limit_box').hide();
	//$('.limit_box').find('input').removeAttr('checked');
	//$('.detail_box').hide();
});
$('.parent_box .am-checkbox').click(function(){
	if($(this).find('input:checked').length>0)
	{
		$(this).parent().next('div').show();
		$(this).parent().next('div').children().click();
	}
	else{
		$(this).parent().next('div').hide();
		$(this).parent().next('div').children().children('input').removeAttr('checked');
	}
})

//点击菜单项同时选中模块
$('.detail_box .am-checkbox').click(function(){
	if($(this).find('input:checked').length>0)
	{
		//console.log('here', $(this).parent().prev('.parent_box').find('input'));
		$(this).parent().prev('.parent_box').find('input').prop('checked', true);
	}
})

