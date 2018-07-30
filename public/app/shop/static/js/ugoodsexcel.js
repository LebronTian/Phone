$('#id_key_file').uploadify({
	 	'swf': '/static/css/uploadify.swf',
        'uploader': '?_easy=shop.ugoods.index.apiexcel', 
        //'buttonImage' : '/app/sp/static/images/sigle.png', 
        'buttonText':'点击上传文件',            
        'auto': true,
		'fileTypeExts' : '*.xls;*.*',
        'method':'POST',
        'fileObjName' : 'file',
        'onUploadSuccess' : function(file,data,response){
		 	console.log(data);
		 	data = $.parseJSON(data);		 
			if(data.data) {
				alert(data.data);
			}
         }
});


