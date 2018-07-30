
$(document).ready(function () {

    $("#saveBiz").click(function () {

        //var su_uid = $('#dis_user').attr('data-uid');

        var user_id=[];

        $(".select2-selection__choice").each(function () {
            var uid = $(this).data("uid");
            user_id.push(uid)
        });
        user_id = user_id.join(';');

        if(!user_id){
            showTip("err","请选择用户",1000);
            return
        }

    	var rule = [];
		var data_sum =0;
		var error_no =0;
		var error_str = '';
		$('.distribution').each(function (index) {
       		 //console.log($(this).val());
			var a = [];
			var weight = $(this).find('#id_weight').val();
			if (weight == '') {
				weight = 0;
			}
			var fix = $(this).find('#id_fix').val();
			if (fix == '') {
				fix = 0;
			}
			if (fix < 0) {
				error_no =1;
				error_str = '佣金不能设置为一个负数';
			}
			a = [parseInt(weight*100),parseInt(fix*100)];
			rule.push(a);
			data_sum+=parseInt(weight);
		});
		if(error_no>0)
		{
			return showTip('err',error_str,1000);
		}
		if(data_sum>=100)
		{
			console.log(data_sum);
			return showTip('err','各级比例总和不能超过100',1000);
		}

        var status = $("input[name='rad-status']:checked").val();
        if(!status){
            showTip("err","请选择审核状态","1000");
            return
        }
        /*上传！！！！！！！！！！！！！！！！！！*/
        var bigData = {
            "user_ids":user_id,
            "status":status,
			'rule': rule
        };

        console.log(bigData);
        $.post('/?_a=shop&_u=api.distribution_apply',bigData, function(data){
            data = $.parseJSON(data);
            console.log(data);
            if(data.errno==0){
                showTip("",'添加成功',"1000");
                setTimeout(function () {
                    window.location.href="/?_a=shopdist&_u=sp.distribution_user_list";
                },1000)
            }else{
                showTip("err","错误！","1000");
            }
        });
    });


    /*yhc*/
    $('.more-user').select2({
        tags: true,
        placeholder: "用回车键隔开",
        minimumInputLength: 1      //限制名字最短长度
    });
    /*取人函数*/
    var uPage = 0;
    var uStatus = false;
    function getUser(){
        if(uStatus){
            return
        }
        uStatus = true;
        var key = $('#user-popup input').val();
        $.getJSON("?_a=su&_u=api.users&limit=20&page="+uPage+"&key="+key, function (ret) {
            uPage++;
            var html ='';
            $.each(ret.data.list, function () {
                html+='<p class="user-p" data-uid="'+this.uid+'"><img class="user-head" src="'+this.avatar+'">'+this.name+'</p>'
            });
            $(".am-popup-bd").append(html);
            uStatus =(ret.data.list==0) ? true : false;
        });
    }
    /*滚动条事件*/
    getUser();
    $(".am-popup-inner").scroll(function () {
        var boxHeight=$(this).height()-47;
        var scrollHeight=$(this).scrollTop();
        var inHeight=$(".am-popup-bd").height();
        if((boxHeight+scrollHeight)>inHeight){
            //console.log("bottom");
            getUser()
        }
    });
    $("#user-popup input").keyup(function(){
        $("#user-popup .am-popup-bd").empty();
        uPage = 0;
        uStatus = false;
        getUser();
    });


    /**/
    $(".select-user").click(function () {
        $('#user-popup').modal();
    });
    $(".am-popup-bd").on("click",".user-p", function () {
        console.log("a");
        if($(this).hasClass("active-p")){
            $(this).removeClass("active-p")
        }else{
            $(this).addClass("active-p")
        }
    });
    /*底部两个按钮*/
    $(".user-list-foot span").click(function () {
        $('#user-popup').modal('close');
    });
    /*返回数据*/
    $(".user-list-foot span").eq(1).click(function () {
        var user_html = '';
        $(".active-p").each(function () {
            user_html+=
                '<li data-uid="'+$(this).data("uid")+'" class="select2-selection__choice">' +
                '<span class="select2-selection__choice__remove" role="presentation">×</span>' +$(this).text();
            '</li>';
        });
        $(".select2-selection__rendered").html(user_html)
    });
    /*删除选项*/
    $(".select-user-box").on("click",".select2-selection__choice__remove",function () {
        $(this).parent().remove()
    })



});
/*****************************
* 检验功能
* */
function checkTrim(ele,text){
    if(ele.val().trim()==""){
        showTip("err",text,"1000");
        ele.focus();
        return false
    }else return true
}
function checkErr(ele,text){
    if(ele.hasClass("am-field-error")){
        showTip("err",text,"1000");
        ele.focus();
        return false
    }else return true
}


//select_user({ele: '#dis_user', single: true, onok: function(su) {
//    console.log('selected', su);
//    $('#dis_user').attr('data-uid', su.uid);
//    $('#dis_user img').attr('src', su.avatar || '/static/images/null_avatar.png');
//    $('#dis_user span').text(su.name);
//}});
