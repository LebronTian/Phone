
$(document).ready(function () {
    //百度富编辑器初始化
    var ue = UE.getEditor('container');
    var text;

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
        var info = text;
        var img = $('#id_img').attr('src');
        var status = $('#id_status').prop('checked') ? 0 : 1;

        var all_quantity = $('#id_all_quantity').val();
        var p_uid = $('#id_p_uid').val();
        var quantity = $('#id_quantity').val();
        var ori_price = parseInt($("#id_ori_price").val()*100);
        var lowest_price = parseInt($("#id_lowest_price").val()*100);
        var times = $('#id_times').val();

        if($.trim(p_uid)==""){
            showTip('err','关联商品编号不能为空',1000);
            return false;
        }

        if(times < 0){
            $("#id_times").focus();
            showTip('err',"请正确填写次数",1000);
            return
        }

        if(ori_price<=lowest_price){
            showTip('err','最低价必须低于原价',1000);
            return false;
        }

        //var start_time;
        //if($("#id_start_time").siblings("input[name='cbx_start_time']").is(":checked")){
        //    if($('#id_start_time').val()==""){
        //        $("#id_start_time").focus();
        //        showTip('err',"请正确填写开始时间",1000);
        //        return
        //    }
        //    start_time =transdate($('#id_start_time').val());
        //}else{
        //    start_time = 0
        //}

        var end_time;

        //if($('#id_end_time').val()==""){
        //    $("#id_end_time").focus();
        //    showTip('err',"请正确填写截至时间",1000);
        //    return
        //}
        end_time =transdate($('#id_end_time').val());

        var uid = g_uid;


        var data = {
            "uid":uid,
            "title":title,
            "all_quantity":all_quantity,
            "quantity":quantity,
            "ori_price":ori_price,
            "lowest_price":lowest_price,
            "status":status,
            "product_info" : {
                "img": img,
                "p_uid":p_uid
            },
            "rule" : {
                "end_time": end_time,
                "times":times
            },
            "info":info
        };
        //console.log(data);return;
        $.post('?_a=bargain&_u=api.add_bargain', data, function(ret){
            ret = $.parseJSON(ret);
            console.log(ret);
            if(ret.errno==0){
                showTip('ok','保存成功',1000);
                setTimeout(function(){
                        window.location.href='?_a=bargain&_u=sp';}
                    ,1000)
            }else if(ret.errno==404){
                showTip('err','商品不存在',1000);
            }
            else
                showTip('err','保存失败',1000);
        });
    });


    $('.am-u-sm-2.am-text-right').eq(2).click(function () {
        $('.tpl-cover-img').autoPosition()
    })

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
