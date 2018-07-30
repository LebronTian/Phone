$(function(){
	//从图片库选择上传文件js
        var uploader = new plupload.Uploader({
            runtimes : 'html5,flash,silverlight,html4',
            browse_button : 'file_upload_tk',
            url : '?_a=upload&_u=index.upload',
            file_data_name : 'file',
            filters : {
                max_file_size : '10mb',
                mime_types: [
                    {title : "Image files", extensions : "jpg,gif,png,bmp"}
                ]
            },
            init: {
                PostInit: function() {
                    //console.log("a")
                },
                FilesAdded: function(up, files) {
                    //console.log("b");

                    uploader.start();
                    plupload.each(files, function(file) {
                    });
                },
                FileUploaded: function(up, files ,res) {
                    //console.log("UPloadasdasdas",up,files,res);
                    res = JSON.parse(res.response); //PHP上传成功后返回的参数
                    console.log("upaaaaaaaaa",res);

                    if(res.data.url){
                        $('.img_list li').find('span').hide();
                         $('.img_list').find('li:eq(0)').before('<li><img data-src="'+res.data.url+'" src=""><span style="display:none;">&radic;</span></li>');
                         var src = res.data.url + '&w=100&h=100';
                         $('.img_list li:first').find('img').attr('src',src);
                    }else{
                        showTip(1000,"图片太大或太小，请选择其他图片")
                    }

                    plupload.each(files, function(file) {
                    });
                },
                UploadProgress: function(up, file) {
                    //console.log("倒数",up,file);
                    //$(".file_info").text(file.percent+'%')
                },

                UploadComplete: function(up, file) {
                },

                Error: function(up, err) {
                }
            }
        });
        uploader.init();

});
	



	