/*
 动态生成表单
 */
function form_make_text2(e) {
    var html = '<p> ';
    if(e.required) {
        html += '<span style="color:red;">*</span> ';
    }
    html += e.name+' <input id="'+e.id+'" ';
    if(e.required) {
        html += ' required="true"';
    }
    html += '/></p>';
    return html;
}

function form_make_text(e) {
    var html =
        '<section class="linear-section"> ' +
        '<span class="linear-title vertical-box"><span> '+((e.required)?'<span style="color:red;">*</span> ':'')+ e.name+'</span></span>' +
        '<input ';

    html +=
        ' id="'+e.id+'" class="remark-input linear-input border-box" '+((e.required)?'required="true"':'')+' type="text" value="" placeholder="'+ e.desc+'">' +
        '</section>';

    return html
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

function form_make_text_multi(e) {
    var html = '<p> ';
    if(e.required) {
        html += '<span style="color:red;">*</span> ';
    }
    html += e.name+' <textarea id="'+e.id+'" '
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
    /*yhc:11:20*/
    var max_length = 0;
    $('.linear-input ').each(function () {
        var length = $(this).siblings('.linear-title').width()+20;
        console.log(length);
        max_length = (max_length>length)? max_length:length;
    }).css('padding-left',max_length);
    $('.form-article .linear-title').width(max_length-20);
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
$('#id_commit').click(function(){
    var record = {};
    for(var i=0; i < g_form.data.length; i++) {
        var f = 'form_get_' + g_form.data[i]['type'];
        try {
            if(false === (record[g_form.data[i].id] = eval(f)(g_form.data[i]))) {
                return false;
            }
        }
        catch(e) {
            console.log('error! ' + f, e);
        }
    };

    console.log('get record ...', record);
    var post = {
        data: JSON.stringify(record),
        f_uid: g_form['uid']
    }
    if(g_record && g_record.uid) {
        post['uid'] = g_record.uid;
    }
    console.log('going to post ...', post);
    $.post('?_a=form&_u=ajax.addformrecord', post, function(ret){
        ret = JSON.parse(ret);
        if(ret.errno==0){
            alert('恭喜您提交成功。');
            return;
            /*if(
                g_form.access_rule.after_action&&
                g_form.access_rule.after_action.type=="url"&&
                g_form.access_rule.after_action.data
            ){
                window.location.href=g_form.access_rule.after_action.data
            }
            else {
                history.back();
            }*/
        }
        else{
            alert('提交失败，未知错误'+ret.errno)
        }
    });
});
//-------------------------
init_form();
init_record();

