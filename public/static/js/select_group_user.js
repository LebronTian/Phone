/*
   管理后台	选择用户
	1. 引入jquery
	2. 引入样式
		<link rel="stylesheet" href="/static/css/select_user.css"/>

	2. 参数说明
	option = {
		'ele' : '#id_select_user', //
		'single': true, //单选
		'onok': function(su_uid, avatar) //确定选择
	}
*/

function select_user(option) {
if(!$('#user-popup').length) {
var html = 
'<div class="am-popup" id="user-popup">' +
'    <div class="am-popup-inner">' +
'        <div class="am-popup-hd">' +
'            <h4 class="am-popup-title">用户列表</h4>' +
'            <span data-am-modal-close class="am-close">&times;</span>' +
'        </div>' +
'		<div class="am-form">' +
'			<input class="" type="text" placeholder="搜索">' +
'		</div>' +
'        <div style="padding-bottom: 3em" class="am-popup-bd">' +
'' +
'        </div>' +
'        <div class="user-list-foot">' +
'            <span>取消</span><span>确定</span>' +
'        </div>' +
'    </div>' +
'</div>'; 
	$('body').append(html);
}


    var uPage = 0;
    var uStatus = false;
    function getUser(){
        if(uStatus){
            return;
        }
        uStatus = true;
		var key = $('#user-popup input').val();
        $.getJSON("?_a=su&_u=api.users&limit=20&page="+uPage+"&key="+key+"&g_uid="+option.g_uid, function (ret) {
            uPage++;
            var html ='';
            $.each(ret.data.list, function () {
                html+='<p class="user-p" data-uid="'+this.uid+'"><img class="user-head" src="'+this.avatar+'">'+(this.name||this.account)+'</p>'
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
            getUser();
        }
    });
	$("#user-popup input").keyup(function(){
            $("#user-popup .am-popup-bd").empty();
			uPage = 0;
			uStatus = false;
            getUser();
	});



    /**/
    $(option.ele).click(function () {
        $('#user-popup').modal();
    });

    $("#user-popup .am-popup-bd").on("click",".user-p", function () {
		if(option.single) {
			$('#user-popup .active-p').removeClass('active-p');
		}
		else {
        	if($(this).hasClass("active-p")){
        		$(this).removeClass("active-p")
        	}
		}

        $(this).addClass("active-p")
    });

    /*底部两个按钮*/
    $("#user-popup .user-list-foot span").click(function () {
        $('#user-popup').modal('close');
    });

    /*返回数据*/
    $("#user-popup .user-list-foot span").eq(1).click(function () {
		var su_uid = $('.active-p').data('uid');
		var avatar = $('.active-p img').attr('src');
		var name = $('.active-p').text();
		option.onok && option.onok({uid: su_uid, avatar: avatar, name: name});
    });

    /*删除选项*/
    $("#user-popup .select-user-box").on("click",".select2-selection__choice__remove",function () {
        $(this).parent().remove();
    });

}


