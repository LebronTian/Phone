function agoto(url) {
console.log('a goto ...', url, 'i am ' ,window.location.href);
if(top!=self) top.location.href=url;
else window.location.href=url;
}

$('.agoto').click(function(){
var url = $(this).attr('href2');
agoto(url);
});

$(document).ready(function(){

    $('#copy_url').zclip({
        path: '/static/js/ZeroClipboard.swf',
        copy: function(){//复制内容
            return $('#id_url').val();
        },
        afterCopy:function(){
            showTip('ok','复制完成',1000);
        }
    });

    $('#copy_url2').zclip({
        path: '/static/js/ZeroClipboard.swf',
        copy: function(){//复制内容 
            return $('#id_url2').val();
        },
        afterCopy:function(){
            showTip('ok','复制完成',1000);
        }
    });

    $('#copy_token').zclip({ 
        path: '/static/js/ZeroClipboard.swf', 
        copy: function(){//复制内容 
            return $('#id_token').val(); 
        },
        afterCopy: function(){
        	showTip('ok','复制完成',1000);
        }
    });

    /*yhc*/
    //手动第一步
    $(".head-add").click(function () {
        //$(".addpublic-content").slideToggle();
        //$("#head-form1").slideToggle()
		console.log('gggg');
        $(".addpublic-content").hide();
        $("#head-form1").show()
    });

var g_click = 0;
    /*伪公众号*/
    $(".fake-public2").click(function () {
if(g_click == 1) return;
g_click = 1;
setTimeout(function() {
	g_click=0; 
	$("#fake-confirm").addClass('am-modal-active').removeClass('am-modal-out').show();
}, 1000);
        $("#fake-confirm").modal({
            relatedTarget: this,
            onConfirm: function() {
                $.post("?_a=sp&_u=api.add_fake_public", function (ret) {
                    ret = $.parseJSON(ret);
                    console.log(ret);
                    if(ret.errno==0){
                        agoto('?_a=sp&_u=index');
                    }
                    else{
                        showTip("err","添加失败","1000");
                        setTimeout(function () {
                            //window.location.reload()
                        })
                    }
                })
            },
            closeOnConfirm: false,
            onCancel: function() {
				$("#fake-confirm").hide();
            }
        });
		//$("#fake-confirm").addClass('am-modal-active').removeClass('am-modal-out').show();
		//console.log('show ...', $('#fake-confirm'));
    });

});

function nextBtn(){
    $("#head-form1").slideToggle();
    $("#head-form2").slideToggle()
}


$('.saveFirst').click(function(){
    var that = this;
	var public_name = $('#id_public_name').val();
	var origin_id = $.trim($('#id_origin_id').val());
	var public_type = parseInt($('input[name="radio2"]:checked').attr('value')) + ($('#id_has_verified').prop('checked') ? 16 : 0);
	var weixin_name = $('#id_weixin_name').val();
	var weixin_brief = $('#id_weixin_brief').val();
	var app_id = $.trim($('#id_app_id').val());
	var app_secret = $.trim($('#id_app_secret').val());
	var msg_mode = $('input[name="radio1"]:checked').attr('value');
	var aes_key= $('#id_aes_key').val();
	var biz = $('#id_biz').val();	
    console.log("guid",g_uid);
	var data = {uid:g_uid, public_name: public_name, origin_id: origin_id, public_type: public_type, msg_mode: msg_mode, aes_key: aes_key,
				weixin_name: weixin_name, weixin_brief:weixin_brief, app_id:app_id, app_secret:app_secret, biz:biz};

    if($.trim(public_name)==""){
		showTip('err','请输入公众号名称',100000);
		return false;
	}
	if($.trim(origin_id)==""){
		showTip('err','请输入原始ID',1000);
		return false;
	}

    if($(that).hasClass("over-btn")){
        if($.trim(app_id)==""){
            showTip('err','请输入AppID（应用ID）',1000);
            return false;
        }
        if($.trim(app_secret)==""){
            showTip('err','请输入AppSecret（应用密钥）',1000);
            //return false;
        }
    }

    $.post('?_a=sp&_u=api.add_public', data, function(ret){
        ret=$.parseJSON(ret);
        console.log(ret);
        if(ret.errno==0){
            if($(that).hasClass("over-btn")){
                /*完成按钮*/
                var text;
                if(g_uid) text = '保存成功';
                else text = '绑定成功';
                showTip('',text,1000);
                setTimeout('agoto("?_a=sp&_u=index")',1000);
            }else{
                /*下一步按钮*/
                showTip('err','提交信息成功',1000);
                nextBtn();
                //获取appid
                g_uid = ret.data;
                console.log("guid",g_uid);
                $.post('?_a=sp&_u=api.get_weixin_public_info',{uid:ret.data}, function (ret) {
                    ret = $.parseJSON(ret);
                    if(ret.errno==0){
                        $("#id_url").val(ret.data.url);
                        $("#id_token").val(ret.data.token)
                    }
                })
            }
        }
        else showTip('err','提交信息失败',1000);
    });
});

$('.save_test').click(function(){
	var data = {};
	$.post('?_a=sp&_u=api.add_fake_public', data, function(ret){
		console.log(ret);
		//window.location.reload();	
		agoto("/?_a=sp");
	});
});

$('input[name="radio1"]').uCheck();
$('input[name="radio2"]').uCheck();
//$('.am-radio').click(function(){
	//g_msg_mode = $(this).attr('value');
	//$('#id_aes').attr('disabled', g_msg_mode == 1);
//});
$('input[name="radio1"]').click(function(){
	$('#id_aes_key').attr('disabled', $(this).attr('value') == 1);
});

$(document).ready(function(){
//第一次选中
	$('input[name="radio1"][value='+g_msg_mode+']').click();
	$('input[name="radio2"][value='+g_public_type+']').click();
});

$(".component_btn").click(function ()
{
    var data = {_ap_uid: ap_uid};
    $.get('?_a=sp&_u=api.get_component_url', data, function(ret){
        console.log(ret);
        ret = $.parseJSON(ret);
		//这个不一样
        window.location.href=ret.data;
    });
});

$('#id_set_biz').click(function(){
	var biz = $('#id_biz').val();	
	var uid = $(this).attr('data-uid');	
	$.post('?_a=sp&_u=api.set_biz', {uid:uid, biz:biz}, function(ret){
		console.log(ret);
       	showTip('ok','设置成功！',1000);
	});
});

$('#id_set_qrcode_url').click(function(){
	var qrcode_url = $('#id_img').attr('src');	
	var uid = $(this).attr('data-uid');	
	$.post('?_a=sp&_u=api.add_public', {uid:uid, qrcode_url:qrcode_url}, function(ret){
		console.log(ret);
       	showTip('ok','设置成功！',1000);
	});
});

