
$(document).ready(function () {

    $('.save').click(function(){
        var user_id=[];

        $(".select2-selection__choice").each(function () {
            var uid = $(this).data("uid");
            user_id.push(uid)
        });
        user_id = user_id.join(';');

        var status = $('#id_status').val();
        var store_uids = $('#id_store_uids').val();
        var data = {
            uids:user_id,
            status: status,
			store_uids: store_uids
        };
        console.log(data);
        $.post('?_a=store&_u=api.addwriteoffer', data, function(ret){
            console.log(ret);
            ret = $.parseJSON(ret);
            if(ret.errno==0){
                showTip('ok','添加成功',1000);
                //setTimeout("history.back()",1000);
            }
            else {
                showTip('err','添加出错',1000);
                //setTimeout("history.back()",1000);
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
            $(".am-popup-bd").append(html || '没有数据了');
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

