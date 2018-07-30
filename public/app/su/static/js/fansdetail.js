$('.private_move').children('li').on('click',function(){
	var uid = $(this).children('a').attr('data-id');
	var g_uid = $(this).children('a').attr('g_uid');
	var name = $(this).children('a').text();
	$(this).parent().parent().click();
	var that=$(this).parent().siblings('.am-dropdown-toggle');
	var old_guid = that.attr('data-guid');
	console.log(uid);
	console.log(g_uid);

	if(g_uid!=0){
	var data = {uids: uid,gid:g_uid}
	$.post('?_a=su&_u=api.move_user_to_group', data, function(ret){
		var ret  =  $.parseJSON(ret);
		if(ret.errno==0){
			that.text(name);
			that.attr('data-guid',g_uid);
			$('.am-dropdown').removeClass('am-active');
		}
	});
	}
	else{
	var data = {uids:uid,gid:old_guid}
		$.post('?_a=su&_u=api.delete_user_from_group', data, function(ret){
		var ret  =  $.parseJSON(ret);
		if(ret.errno==0){
			that.text(name);
			that.attr('data-guid',g_uid);
			$('.am-dropdown').removeClass('am-active');
		}
	});
	}
});

$('.creview li').click(function(){
	var uid=$(this).attr('data-id');
	var status=$(this).attr('sp');
	var data={uids:[uid], status:status}
	$.post('?_a=su&_u=api.review_user' , data , function(ret){
		var ret = $.parseJSON(ret);
		if(ret.errno==0)
			window.location.reload();
	});
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
    /*主图回调函数*/
function mainImg(){
    var picSrc = $("#main-img-src").attr("src");
    var img = '<img id="main-img" src="'+picSrc+'"/>';
    $("#main-img-box").html(img)
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
		var uid = $('.select-user').attr('data-id');
		var from_uid = $('.active-p').data('uid');
		console.log('choose ' + from_uid + ' as parent of ' + uid);
		$.post('?_a=su&_u=api.set_from_su_uid', {uid: uid, from_uid: from_uid}, function(ret){
			console.log(ret);
			var ret  =  $.parseJSON(ret);
			if(ret.errno==0){
				window.location.reload();
			}
		});
    });
    /*删除选项*/
    $(".select-user-box").on("click",".select2-selection__choice__remove",function () {
        $(this).parent().remove()
    });

$('.update_su').click(function(){
	var uid = $(this).attr('data-uid');
	$.post('?_a=su&_u=api.update_su_info',{uid: uid, force: 1}, function(ret){
		ret = $.parseJSON(ret);
		if(ret && (ret.errno == 0)) {
			var $toast = $('#toast');
			$toast.fadeIn(100);
			setTimeout(function() {
				$toast.fadeOut(100);
				window.location.reload();
			}, 2000);
		} else {
			alert('操作失败！' + ret.errstr);
		}
	});
});

$('.rm_su').click(function(){
	if(!confirm('删除用户无法恢复，确定继续吗？')) return;
	var uid = $(this).attr('data-uid');
	$.post('?_a=su&_u=api.delete_user',{uid: uid}, function(ret){
		console.log(ret);
		ret = $.parseJSON(ret);
		if(ret && ret.errno == 0) {
			window.location.reload();
		}
	});
});


