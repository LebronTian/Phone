/*
	动态生成表单 
*/

//单行文本框
function form_make_text(e) {
    //console.log("text",e);
	var html='<div class="am-g section">'
			+'<div class="am-u-sm-2 form-left">'
			+e.name
			+'</div><div class="am-u-sm-10"><input class="am-form-field" id="'
			+e.id
			+'" placeholder="'
			+e.desc
			+'" type="text"';
		if(e.required) {
			html+=' required="true"';
		}
		html+=' value=""></div></div>';

	return html;
}

function form_make_file_img(e) {
	var html = '<p> ';
	if(e.required) {
		html += '<span style="color:red;">*</span> ';
	}
	html += e.name+' <span class="file_info"></span><input type="file" upload_type="1" id="'+e.id+'"';
	if(e.required) {
		html += ' required="true"';
	}
	html += '/>';
	html += e.desc;
	html += '</p>';
	return html;
}

//多行输入框 文本域
function form_make_text_multi(e) {
	var html='<div class="am-g section">'
			+'<div class="am-u-sm-2 form-left">'
			+e.name
			+'</div><div class="am-u-sm-10"><textarea rows="5" class="am-form-field" id="'
			+e.id
			+'" placeholder="'
			+e.desc
			+'" ';
		if(e.required) {
			html+=' required="true"';
		}
		html+=' value=""></textarea></div></div>';
	return html;
}

//类型 type
function form_make_select_type(e) {
	//console.log('type',e);
	var str = e.desc;
	str = str.split(',');
	var html='<div class="am-g section">'
			+'<div class="am-u-sm-2 form-left">'
			+e.name
			+'</div><div class="am-u-sm-10 type-box" id="'
			+e.id
			+'">';
		if(str.length>0){
			html+='<label><input type="radio" name="type-radio" checked="checked"><span>'
				+str[0]
				+'</span></label>';
			for(var i=1;i<str.length;i++){
				html+='<label><input type="radio" name="type-radio"><span>'
				+str[i]
				+'</span></label>';
			}
		}
		html+='</div></div>';
	return html;
}

//区域选择
function form_make_select_city(e) {
	//console.log('city',e);
	var html='<div class="am-g section">'
			+'<div class="am-u-sm-2 form-left">所在区域</div>'
			+'<div class="am-u-sm-10">'
			+'<form id="'
			+e.id
			+'">'
			+'<select class="select" name="province" id="s1">'
			+'<option></option>'
			+'</select>'
			+'<select class="select" name="city" id="s2">'
			+'<option></option>'
			+'</select>'
			+'<select class="select"';
		if(e.required) {
			html+=' required="true"';
		}
		html+=' name="town" id="s3">'
			+'<option></option>'
			+'</select>'
			+'</form>'
			+'</div></div>';
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

function form_get_select_type(e, val) {
	if(val) {
		//return $('#'+e.id).val(val);
	}

	val = $('#'+e.id).find('label>input[type="radio"]:checked').next('span').text();
	/*if(e.required && !val) {
		alert('缺少必填字段 ' + e.name);
		$('#'+e.id).focus();
		return false;
	}*/
	return val;	
}

function form_get_select_city(e,val) {
	if(val) {
		//return $('#'+e.id).val(val);
	}
	var val_1 = $('#'+e.id).find('#s1').val();
	var val_2 = $('#'+e.id).find('#s2').val();
	var val_3 = $('#'+e.id).find('#s3').val();
	var val = val_1+','+val_2+','+val_3;
	if(e.required && (val_2=='地级市'||val_3=='市、县级市、县')) {
		alert('缺少必选字段 ' + e.name);
		if(val_2=='地级市'){
			$('#'+e.id).find('#s2').focus();
		}
		if(val_3=='市、县级市、县'){
			$('#'+e.id).find('#s3').focus();
		}
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

	$('.form-content').find('.cont').find('.section:last').prepend(html);

	//如果有文件上传字段,初始化一下文件上传
	$('#id_form_content input[type="file"]').each(function(i, e) {
		$(e).uploadify({
		'swf': '/static/css/uploadify.swf',
        'uploader': '?_a=upload&_u=index.upload&type=' + $(e).attr("upload_type"),
        //'buttonImage' : '/app/sp/static/images/sigle.png', 
        'buttonText':'上传',
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
			$('#'+$(e).attr('id')).parent().find('span.file_info').text(val.file_name);
			console.log('set data...', e, d);
			}
		}
		});
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
$(document).on('click','#submit-form-btn',function(){
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
        ret =JSON.parse(ret);
		console.log(ret);
		//todo
        if(ret.errno==0){
			if(
					g_form.access_rule.after_action&&
					g_form.access_rule.after_action.type=="url"&&
					g_form.access_rule.after_action.data
			)
			{
				window.location.href=g_form.access_rule.after_action.data
			}
			else {
				window.location.href='?_a=form&_u=sp';
			}
        }

	});
});
//-------------------------
init_form();
init_record();

