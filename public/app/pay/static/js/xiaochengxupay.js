$('.save').click(function(){
	var spname = $('#id_spname').val();
	var appid = $('#id_appid').val();
	var appsecret = $('#id_appsecret').val();
	var mchid= $('#id_mchid').val();
	var key = $('#id_key').val();
	var disabled = $('#id_status').prop('checked') ? 0 : 1;
	var public_uid = $(this).attr('data-uid');
	
	var data = {public_uid:public_uid, spname:spname, appid:appid, appsecret:appsecret, mchid:mchid, key:key, disabled: disabled};
	$.post('?_a=pay&_u=api.xiaochengxupay', data, function(ret){
		ret = $.parseJSON(ret);
		if(ret.errno==0) {
			showTip('ok','保存成功',1000);
		}
		else {
			showTip('err','保存失败',1000);
		}
	});
});

$('#id_cert_file').uploadify({
	 	'swf': '/static/css/uploadify.swf',
        'uploader': '?_a=upload&_u=index.uploadprivate&type=1', 
        //'buttonImage' : '/app/sp/static/images/sigle.png', 
        'buttonText':'上传证书',            
        'auto': true,
		'fileTypeExts' : '*.pem;*.*',
        'method':'POST',
        'fileObjName' : 'file',
        'onUploadSuccess' : function(file,data,response){
		 	console.log(data);
		 	data = $.parseJSON(data);		 
			if(data.data) {
				$('#id_cert_file').parent().parent().find('.fstatus').text('上传成功!');	
			}
         }
});

$('#id_key_file').uploadify({
	 	'swf': '/static/css/uploadify.swf',
        'uploader': '?_a=upload&_u=index.uploadprivate&type=2', 
        //'buttonImage' : '/app/sp/static/images/sigle.png', 
        'buttonText':'上传证书',            
        'auto': true,
		'fileTypeExts' : '*.pem;*.*',
        'method':'POST',
        'fileObjName' : 'file',
        'onUploadSuccess' : function(file,data,response){
		 	console.log(data);
		 	data = $.parseJSON(data);		 
			if(data.data) {
				$('#id_key_file').parent().parent().find('.fstatus').text('上传成功!');	
			}
         }
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

