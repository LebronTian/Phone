var disabled = 0;
$('#id_upload').click(function() {
if(disabled) return;
disabled = 1;
var template_id = $('#id_code').val();
$.post('?_a=sp&_u=api.upload_xiaochengxu', {public_uid: g_public_uid, template_id: template_id}, function(ret){
	disabled = 0;
	ret = $.parseJSON(ret);
	if(ret.errno == 0 && ret.data) {
		showTip('ok', '上传成功！', 3000);
	} else {
		showTip('err', '上传失败！', 3000);
	}
});
});

$('#id_qrcode').click(function(){
	var url = '?_a=sp&_u=api.get_xiaochengxu_qrcode&public_uid='+g_public_uid+'&rand='+(new Date());
	$('#id_qrcode_img').attr('src', url).show();
});

$('#id_audit').click(function() {
var data = {public_uid: g_public_uid};
if(!(data['title'] = $('#id_title').val())) return alert('请填写小程序页面标题！');
if(!(data['tag'] = $('#id_tag').val())) return alert('请填写小程序标签！');
if(!(data['first_class'] = $('#id_first_class').val())) return alert('请选择小程序分类！');
if(!(data['second_class'] = $('#id_second_class').val())) return alert('请选择小程序分类！');
if(!(data['third_class'] = $('#id_third_class').val())); 

$.post('?_a=sp&_u=api.audit_xiaochengxu', data, function(ret){
	console.log('retttt ', ret);
	ret = $.parseJSON(ret);
	if(ret.errno == 0 && ret.errno.data) {
		showTip('ok', '提交审核成功！', 3000);
	} else {
		showTip('err', '小程序正在审核中！', 3000);
	}
});
});

$('#id_first_class').change(function(){
	var first_class= $('#id_first_class').val();
	
	var html = '';
	try {
	for(var i in g_cats[first_class]['nodes']) {
		html += '<option value="'+i+'">'+i+'</option>';
	}
	}catch(e) {}
	$('#id_second_class').html(html).change();
});

$('#id_release').click(function() {
$.post('?_a=sp&_u=api.release_xiaochengxu', {public_uid: g_public_uid}, function(ret){
	ret = $.parseJSON(ret);
	if(ret.errno == 0 && ret.data) {
		showTip('ok', '发布成功！', 3000);
	} else {
		showTip('err', '已经发布了！', 3000);
	}
});
});


$('#id_bind_tester').click(function() {
$('#id_wechatid').show();
});

$('#id_wechatid').keydown(function(e) {
if(e.keyCode != 13) return;
var wechatid = $('#id_wechatid').val();
if(!wechatid) return;
$.post('?_a=sp&_u=api.bindtester_xiaochengxu', {public_uid: g_public_uid, wechatid: wechatid}, function(ret){
	ret = $.parseJSON(ret);
	if(ret.errno == 0 && ret.data) {
		showTip('ok', '添加成功！', 3000);
	} else {
		//showTip('err', '添加失败！', 3000);
		showTip('err', '该用户已经添加过了！', 3000);
	}
});
});

$('#id_second_class').change(function(){
	var first_class= $('#id_first_class').val();
	var second_class= $('#id_second_class').val();
	
	var html = '';
	try {
	for(var i in g_cats[first_class]['nodes'][second_class]['nodes']) {
		html += '<option value="'+i+'">'+i+'</option>';
	}
	}catch(e) {}
	$('#id_third_class').html(html);

	if(html) $('#id_third_class').show();
	else $('#id_third_class').hide();
});
$('#id_first_class').change();

