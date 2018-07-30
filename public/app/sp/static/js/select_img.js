
$(function(){

	//从图片库选择上传文件js
	$("#file_upload_tk").uploadify({
	 	'swf': '/static/css/uploadify.swf',
                'uploader': '?_a=upload&_u=index.upload', 
                //'buttonImage' : '/app/sp/static/images/sigle.png', 
                'buttonText':'上传',            
                'auto': true,
                'multi': true,
                'method':'POST',
                'fileObjName' : 'file',
                'onUploadSuccess' : function(file,data,response){
		 data = $.parseJSON(data);
                 $('.img_list li').find('span').hide();
                 $('.img_list').find('li:eq(0)').before('<li><img data-src="'+data.data.url+'" src=""><span style="display:none;">&radic;</span></li>');
                 $('.img_list li:first').find('img').attr('src',data.data.url)
	       }
	 })

})
	



	