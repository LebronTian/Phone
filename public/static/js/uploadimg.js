/*
基于pupload 的上传图片
默认最大限制20m大小

cfg = {
	ele_uid: 容器选择器, 默认 .up_imgs_container
	init_imgs: [] 如果有初始化图片列表
}


先包含
static/js/pupload.full.min.js

参考 css 样式
.up_imgs_container .upload_btn{float:left;display:inline-block;width:128px;height:128px;font-size:48px;line-height:128px;text-align:center;border:1px dotted gray;margin:5px;}
.up_imgs_container img{margin:5px;width:128px;height:128px;display:inline-block;}

<div class="up_imgs_container">
</div>

*/
function do_upload_img(cfg) {
	cfg.ele_uid = cfg.ele_uid || '.up_imgs_container';	
	cfg.ele_uid_btn = cfg.ele_uid_btn || 'id_up_imgs_btn'+(new Date()).getTime();//上传按钮id	
	
	var init_html = '';
	if(cfg.init_imgs) {
		for(var i=0; i<cfg.init_imgs.length; i++) {
			init_html += '<img src="' + cfg.init_imgs[i] + '">'; 
		}
	}
	init_html += '<div class="upload_btn" id="'+cfg.ele_uid_btn+'">+</div><div style="clear:both"></div>';

	$(cfg.ele_uid).html(init_html);

	$(cfg.ele_uid).on('click', 'img', function(){
		if(confirm('您想取消此图片吗？')){
			$(this).remove();
		}
	});

    var uploader_img = new plupload.Uploader({
        browse_button: cfg.ele_uid_btn, //'.upload_btn',
        url: '?_a=upload&_u=index.upload&type=1',
        filters: {
            max_file_size: '20mb',
            mime_types: [
                {title: "Image files", extensions: "jpg,gif,png,bmp,jpeg"}
            ]
        },
        init: {
            FilesAdded: function (up, files) {
                uploader_img.start();
				$(cfg.ele_uid + ' #' + cfg.ele_uid_btn).text('0%');
            },
            FileUploaded: function (up, files, res) {
                res = JSON.parse(res.response); //PHP上传成功后返回的参数
                console.log(cfg.ele_uid + ' #' + cfg.ele_uid_btn);
				$(cfg.ele_uid + ' #' + cfg.ele_uid_btn).text('+');

                if(res.data.url){
					var html_img = '<img src="'+res.data.url+'">';
                    $('#'+cfg.ele_uid_btn).after(html_img);
                }
				else {
					alert('上传失败！'+res.errstr);
				}
            },
			UploadProgress: function(up, file) {
				console.log(file, file.percent);
				var txt =  parseInt(file.percent);
				if(txt >= 100) txt = '+'; else txt += '%';
				$(cfg.ele_uid + ' #' + cfg.ele_uid_btn).text(txt);
			},
            Error: function (up,error) {
				$(cfg.ele_uid + ' #' + cfg.ele_uid_btn).text('+');
                if(error.code==(-600)){
                    alert('图片大小为0-20mb范围内')
                }
                else{
                    alert('上传失败，未知错误:'+error.code)
					//alert(JSON.stringify(error));
					//alert(JSON.stringify(upload));
                }
            }
        }
    });

    uploader_img.init();
}

