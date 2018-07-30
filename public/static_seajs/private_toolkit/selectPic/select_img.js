$(function(){
    $("#file_group").change(function(){
        var group = $("#file_group").find("option:selected").val();
        //console.log('>>>>>>>>>>>'+group);
        if(selectPicUploader){
            selectPicUploader.destroy();
        }
        upload_func(group);
    })
    var selectPicUploader;
    function upload_func(uid){
        selectPicUploader = new plupload.Uploader({
            runtimes : 'html5',
            browse_button : 'file_upload_group',
            url: '?_a=upload&_u=index.upload&file_group='+uid,
            filters : {
                max_file_size : '10mb',
                mime_types: [
                    {title : "Image files", extensions : "jpg,jpeg,gif,png,bmp"}
                ]
            },
            init: {
                PostInit: function() {

                },
                FilesAdded: function(up, files) {
                    selectPicUploader.start();
                },
                FileUploaded: function(up, files ,res) {
                    data = $.parseJSON(res.response);
                    $('.img_list li').find('span').hide();
                    $('.img_list').prepend('<li><img data-src="'+data.data.url+'" src=""><a data-uid="'+data.data.uid+'" class="am-icon-close"></a><span style="display:none;">&radic;</span></li>');
                    $('.img_list li:first').find('img').attr('src',data.data.url)
                },
                UploadProgress: function(up, file) {},
                UploadComplete: function(up, files) {},
                Error: function(up, err) {}
            }
        });
        selectPicUploader.init();
    }
    upload_func();

});




