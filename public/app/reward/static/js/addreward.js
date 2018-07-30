$(document).ready(function () {
    //百度富编辑器初始化
    var ue = UE.getEditor('container');
    var text;
    /*起止时间*/
    $(".time-label input:checkbox").change(function () {
        var bool = $(this).is(":checked");
        if(bool){
            $(this).siblings("input[type='datetime-local']").show()
        }else{
            $(this).siblings("input[type='datetime-local']").hide()
        }
    });
    /*投票限制*/
    $(".reward-limit-box input:checkbox").change(function () {
        var bool = $(this).is(":checked");
        if(bool){
            $(this).siblings("input[type='number']").show()
        }else{
            $(this).siblings("input[type='number']").hide()
        }
    });
    /*保存按钮*/
    $('.save').click(function(){
        ue.ready(function(){
            text = ue.getContent();
        });
        var title = $('#id_title').val();
        //var brief = $('#id_brief').val();
        if($.trim(title)==""){
            showTip('err','标题不能为空',1000);
            return false;
        }
        var brief = text;
        var img = $('#id_img').attr('src');
        var status = $('#id_status').prop('checked') ? 0 : 1;
        var must_login = $('#id_must_login').prop('checked') ? 1 : 0;
      

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


        var max_item = checkLimit($('#id_max_item'));
        if(max_item==-1) return;
		
        var max_cnt = checkLimit($('#id_max_cnt'));
        if(max_cnt==-1) return;
		
        var max_cnt_day = checkLimit($('#id_max_cnt_day'));
        if(max_cnt_day==-1) return;
		
		var win_rule_type=$('#id_win_rule_type').val();
		
		switch (win_rule_type)
		{
			case "none":
				win_rule_data='';
				win_rule_type='';
			break;
			case "form":
				win_rule_data=$('#id_win_rule_form').val();
			break;
			case "url":
			var win_rule_data=$('#id_win_rule_url').val();
			break;
			
		}
        var uid = g_uid;
        var data = {
            uid:uid,
            title:title,
            brief:brief,
            img:img,
            status:status,
            'access_rule' : {
                'must_login': must_login,
                'start_time': start_time,
                'end_time': end_time,
                'max_item': max_item,
                'max_cnt': max_cnt,
                'max_cnt_day': max_cnt_day
            },
			'win_rule':{
				'type':win_rule_type,
				'data':win_rule_data
			}
        };
        $.post('?_a=reward&_u=api.addreward', data, function(ret){
            ret = $.parseJSON(ret);
            if(ret.errno==0){
                showTip('ok','保存成功',1000);
                setTimeout(function(){
                        window.location.href='?_a=reward&_u=sp';}
                    ,1000)
            }
            else
                showTip('err','保存失败',1000);
        });
    });

	win_rule_change();


    /*
        设置默认活动开始与结束时间
    */
    $('#start_time').val('2015-10-28');
	
	
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
   // console.log(date);
    return Date.parse(date)/1000;
}
$('.text-chosen').select2({tags: true, placeholder: "请输入选项名,空格,回车隔开", maximumInputLength: 5, tokenSeparators: [',',' ',';']});

$('#id_win_rule_type').on('change',function(){
	win_rule_change()
});

function win_rule_change()
{	

	var type=$('#id_win_rule_type').val();
	switch (type)
	{
		case "none":
			$('.win_rule_url').hide();
			$('.win_rule_form').hide();
			$('.id_win_rule_name').hide();
		break;
		case "form":
			$('.win_rule_url').hide();
			$('.win_rule_form').show();
			$('.id_win_rule_name').show();
			$('.id_win_rule_name').text('选项名');
		break;
		case "url":
			$('.win_rule_url').show();
			$('.win_rule_form').hide();
			$('.id_win_rule_name').show();
			$('.id_win_rule_name').text('链接地址');
		break;
		
	}

}

/*********************
 * 主图回调函数
 * */
function mainImg(){
    var picSrc = $("#main-img-src").attr("src");
    var img = '<img id="id_img" src="'+picSrc+'" style="width:100px;height:100px;" />';
    $("#main-img-box").html(img)
}