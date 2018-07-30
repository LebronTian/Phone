/*
$('#id_test').click(function(){
	var data = {
		'title' : '大创意!',
		'access_rule' : {
					'must_login': true,
					'can_edit': true,
					'start_time': 0,
					'end_time': 0,
					'total_cnt': 0,
					'max_cnt': 1,
					'max_cnt_day': 1,
					'unique_field': ''
					},
		'data': [
                {
					'id' : 'file_img2',
					'type' : 'file_img',
					'name' : '上传作品',
					'desc' : '仅限1张图片,2M以内',
					'required' : true
				},
				{
					'id' : 'text3',
					'type' : 'text',
					'name' : '作品名称',
					'required' : true
				},
				{
					'id' : 'text_multi4',
					'type' : 'text_multi',
					'name' : '创意描述',
					'required' : true
				}
				]
	};

	$.post('?_a=form&_u=api.addform', data, function(ret){
		console.log(ret);
	});
});

*/



$(document).ready(function () {
    //百度富编辑器初始化

    var ue1 = UE.getEditor('brief');

    var text1;

    $(".time-label input:checkbox").change(function () {
        var bool = $(this).is(":checked");
        if(bool){
            $(this).siblings("input[type='datetime-local']").show()
        }else{
            $(this).siblings("input[type='datetime-local']").hide()
        }
    });

    /*投票限制*/
    $(".form-limit-box input:checkbox").change(function () {
        var bool = $(this).is(":checked");
        if(bool){
            $(this).siblings("input[type='number']").show()

        }else{
            $(this).siblings("input[type='number']").hide()

        }
    });

    /*保存按钮*/
    $('.save').click(function(){


        ue1.ready(function(){
            text1 = ue1.getContent();
        });
        var title = $('#id_title').val();
        var address = $('#address').val();
        //var brief = $('#id_brief').val();
        if($.trim(title)==""){
            showTip('err','标题不能为空',1000);
            return false;
        }


        //var content = $('#content').val();
        var brief = text1;
        var img = $('#id_img').attr('src');
        var su_uid = $('#id_user').attr('data-uid');

        var admin_uids = [];
        $(".class_user").each(function(){
            var uid = $(this).attr('data-uid');
            admin_uids.push(uid);
        });


        var status = $('#id_status').prop('checked') ? 0 : 1;
        var price = parseInt($('#id_price').val()*100);

        var astart_time;
        if($("#id_astart_time").siblings("input[name='cbx_astart_time']")){
            if($('#id_astart_time').val()==""){
                $("#id_astart_time").focus();
                showTip('err',"请正确填写开始时间",1000);
                return
            }
            astart_time =transdate($('#id_astart_time').val());
        }else{
            astart_time = 0
        }

        var start_time;
        if($("#id_start_time").siblings("input[name='cbx_start_time']").is(":checked")){
            if($('#id_start_time').val()==""){
                $("#id_start_time").focus();
                showTip('err',"请正确填写开始时间",1000);
                return
            }
            start_time =transdate($('#id_start_time').val());
        }else{
            start_time = 0
        }

        var end_time;
        if($("#id_end_time").siblings("input[name='cbx_end_time']").is(":checked")){
            if($('#id_end_time').val()==""){
                $("#id_end_time").focus();
                showTip('err',"请正确填写截至时间",1000);
                return
            }
            end_time =transdate($('#id_end_time').val());
        }else{
            end_time = 0
        }

        var total_cnt = checkLimit($('#id_total_cnt'));
        if(total_cnt==-1) return;

        var max_cnt = checkLimit($('#id_max_cnt'));
        if(max_cnt==-1) return;

        var max_cnt_day = checkLimit($('#id_max_cnt_day'));
        if(max_cnt_day==-1) return;
        var tpl = $('.tpl-container').data('dir');


        var uid = g_uid;

        var data = {
            uid:uid,
            title:title,
            su_uid:su_uid,
            admin_uids:admin_uids,
            type:'activity',
            //speech:content,
            brief:brief,
            img:img,
            'access_rule' : {
                'must_login': true,
                'can_edit':true,
                'address':address,
                'astart_time': astart_time,
                'start_time': start_time,
                'end_time': end_time,
                'total_cnt': total_cnt,
                'max_cnt': max_cnt,
                'max_cnt_day': max_cnt_day,
                'order':{
                    'price':price,
                }
            },
            status:status
        };
        $.post('?_a=form&_u=api.addform', data, function(ret){
            ret = $.parseJSON(ret);
            console.log(ret);
            if(ret.errno==0){
                showTip('ok','保存成功',1000);
                setTimeout(function(){
                        window.location.href='?_a=form&_u=sp&type=activity';}
                    ,1000)
            }
            else
                showTip('err','保存失败',1000);
        });
    });


});


/*检查限制*/
function checkLimit(ele){
    var bool = ele.siblings("input:checkbox").is(":checked");
    if(bool){
        if(ele.val().trim()==""||ele.val().trim()<0){
            showTip("err","请正确填写数据",1000);
            ele.focus();
            return -1
        }else{
            return ele.val()
        }
    }else{
        return 0
    }
}


/*
将php的时间用js转换为时间戳
*/
function transdate(endTime){
    var date=new Date();
    date.setFullYear(endTime.substring(0,4));
    date.setMonth(endTime.substring(5,7)-1);
    date.setDate(endTime.substring(8,10));
    date.setHours(endTime.substring(11,13));
    date.setMinutes(endTime.substring(14,16));
    date.setSeconds(endTime.substring(17,19));
	console.log(date);
    return Date.parse(date)/1000;
}


var theclick;
var theclickimg;
var theclickspan;
select_user({ele: '#id_user', single: true, onok: function(su) {
    console.log('selected', su);
    theclick.attr('data-uid', su.uid);
    theclickimg.attr('src', su.avatar || '/static/images/null_avatar.png');
    theclickspan.text(su.name);

}});
$('#id_user').click(function () {
    theclick =  $('#id_user');
    theclickimg = $('#id_user img');
    theclickspan =  $('#id_user span');
});

$(document).on('click','.class_user',function(){
    theclick =  $(this);
    theclickimg = $(this).children('img');
    theclickspan =  $(this).children('span');
    $('#user-popup').modal();
});

$('.type-add-li').click(function(){
    var user = '<div class="class_user" data-uid=""><img style="width:64px;height:64px;" src="/static/images/null_avatar.png"> <span></span></div>';
    $(".userlist").prepend(user);
})
$(".type-red-li").click(function () {
    $(".class_user").eq(0).remove();
})


/******************************************************************************************
 * 编辑预加载功能
 * */




