/*
	动态生成表单 
*/
function form_make_text(e) {
	var html = '<p> ';
	if(e.required) {
		html += ' ';
	}
	html +='<span class="font-left">'+e.name+'：</span><input class="input-right" type="text" id="'+e.id+'" ';
	if(e.required) {
		html += ' required="true"';
	}
	html += '/></p>';
	return html;
}

function form_make_file_img(e) {

    var html = '<p> ';
	if(e.required) {
		html += ' ';
	}
	html += '<span class="font-left">'+e.name+'：</span><button type="file" class="upload-btn" id="'+ e.id+'"';
	if(e.required) {
		html += ' required="true"';
	}
	html += '>请选择作品</button>';
	html += '<span class="desc-font">'+e.desc+'</span><br/><span class="file_info"></span>';
	html += '</p>';

	return html;
}

function form_make_text_multi(e) {
	var html = '<p> ';
	if(e.required) {
		html += '';
	}
	html += '<span class="font-left">'+e.name+'：</span><textarea class="textarea-right" id="'+e.id+'" ';
	if(e.required) {
		html += ' required="true"';
	}
	html += '/></textarea></p>';
	return html;
}

function form_get_text(e, val) {
	if(val) {
		return $('#'+e.id).val(val);
	}

	val = $('#'+e.id).val();
	if(e.required && !val) {
		alert('缺少必填字段 ' + e.name);
		$('#'+e.id).focus();
		return false;
	}

	return val;	
}

function form_get_file_img(e, val) {
	if(val) {
		$('#'+e.id).parent().find('span.file_info').text(val.file_name);
		return $('#'+e.id).data('val', val);
	}

	val = $('#'+e.id).data('val');
	if(e.required && !val) {
		alert('缺少上传文件 ' + e.name);
		$('#'+e.id).focus();
		return false;
	}

	return val;	
}

function form_get_text_multi(e, val) {
	if(val) {
		return $('#'+e.id).val(val);
	}

	val = $('#'+e.id).val();
	if(e.required && !val) {
		alert('缺少必填字段 ' + e.name);
		$('#'+e.id).focus();
		return false;
	}


	return val;	
}

/*
	根据 g_form 自动生成表单html
*/
function init_form() {
	var html = '';
	for(var i=0; i < g_form.data.length; i++) {
		var f = 'form_make_' + g_form.data[i]['type'];
		try {
			html += eval(f)(g_form.data[i]);
		} catch(e) {
			console.log('error! ' + f, e);
		}	
	}

	$('#id_form_content').prepend(html);
	//如果有文件上传字段,初始化一下文件上传
	$('.upload-btn').each(function(i, e) {
        console.log("初始化",e,i);

        /*
         */

        var uploader = new plupload.Uploader({
            runtimes : 'html5,flash,silverlight,html4',
            browse_button : $(e).attr("id"), // you can pass an id...
            //container: document.getElementById('container'), // ... or DOM Element itself
            url : '?_a=upload&_u=index.upload&type=1',
            //flash_swf_url : '../js/Moxie.swf',
            //silverlight_xap_url : '../js/Moxie.xap',
            file_data_name : 'file',
            filters : {
                max_file_size : '10mb',
                mime_types: [
                    {title : "Image files", extensions : "jpg,gif,png,bmp"}
                ]
            },
            init: {
                PostInit: function() {
                },
                FilesAdded: function(up, files) {
                    uploader.start();

                    plupload.each(files, function(file) {

                    });
                },
                FileUploaded: function(up, files ,res) {
                    console.log("UPloadasdasdas",up,files,res);
                    res = JSON.parse(res.response); //PHP上传成功后返回的参数
                    console.log("aaaaaaaaaaaaaaaaaaaaa",res);
                    $(".file_info").text(res.data.file_name);
                    $("#showPicPic").attr("src",res.data.url);
                    console.log("herherhehrehr",e, res);

                    if(res && res.data) {
                        var d = {
                            'url' : res.data.url,
                            'file_name': res.data.file_name,
                            'file_size': res.data.file_size
                        };
                        //必须要用id?
                        $('#' + $(e).attr('id')).data('val', d);
                    }

                    plupload.each(files, function(file) {
                    });
                },
                UploadProgress: function(up, file) {
                    console.log("11111111",up,file);
                    $(".file_info").text(file.percent+'%')
                },

                UploadComplete: function(up, file) {
                },

                Error: function(up, err) {
                }
            }
        });


        uploader.init();



        /*



        $(e).uploadify({
		'swf': '/static/css/uploadify.swf',
        'uploader': '?_a=upload&_u=index.upload&type=' + $(e).attr("upload_type"),
        //'buttonImage' : '/app/sp/static/images/sigle.png', 
        'buttonText':'请选择作品',
        'width':'20%',
        'auto': true,
        'multi': false,
        'method':'POST',
        'fileObjName' : 'file',
        'onUploadSuccess' : function(file,data,response){
			console.log(e, data);
			data = $.parseJSON(data);
			if(data && data.data) {
			var d = {
				'url' : data.data.url,
				'file_name': data.data.file_name,
				'file_size': data.data.file_size
			};
			//必须要用id?
			$('#' + $(e).attr('id')).data('val', d);
			$('#'+$(e).attr('id')).parent().find('span.file_info').text(d.file_name).data("url", d.url);
			console.log('set data...', e, d);
			}
		}
		});

        */

	});
}

/*
	根据g_record初始化表单
*/
function init_record() {
	if(g_record && g_record.data) 
	for(var i=0; i < g_form.data.length; i++) {
		var f = 'form_get_' + g_form.data[i]['type'];
		try {
			eval(f)(g_form.data[i], g_record.data[g_form.data[i].id]);
		} catch(e) {
			console.log('error! record ' + f, e);
		}	
	};
}

/*
	根据 g_form 提交表单
*/
$('.id_commit').click(function(){
    console.log("aaa");
	var record = {};
	for(var i=0; i < g_form.data.length; i++) {
		var f = 'form_get_' + g_form.data[i]['type'];
		try {
			if(false === (record[g_form.data[i].id] = eval(f)(g_form.data[i]))) {
				return false;
			}
		} catch(e) {
			console.log('error! ' + f, e);
		}	
	}

	console.log('get record ...', record);
	var post = {
		data: JSON.stringify(record),
		f_uid: g_form['uid']
	};
	if(g_record && g_record.uid) {
		post['uid'] = g_record.uid;
	}
	console.log('going to post ...', post);
	$.post('?_a=form&_u=ajax.addformrecord', post, function(ret){
        showTip(0,"您已成功提交作品！");
    });
});
//-------------------------
init_form();
init_record();

