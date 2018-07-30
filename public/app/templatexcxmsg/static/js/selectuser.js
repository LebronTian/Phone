$(function () {
    /*取人函数*/
    var uPage = 0;
    var uStatus = false;
    var public_uid = templateData.public_uid;
    function getUser(){
        if(uStatus){
            return
        }
        uStatus = true;
        var key = $('#user-popup input').val();
        //var link = "?_a=su&_u=api.users&limit=20&page="+uPage;
        var link = "?_a=su&_u=api.weixin_fans&limit=20&page="+uPage+"&public_uid="+public_uid+"&key="+key;
        $.getJSON(link, function (ret) {
            uPage++;
            var html ='';
            $.each(ret.data.list, function () {
                html+='<p class="user-p" data-uid="'+this.uid+'"><img class="user-head" src="'+this.avatar+'">'+this.name+'</p>'
            });
            $(".am-popup-bd").append(html);
            uStatus =(ret.data.list==0)
        });
    }
    /*滚动条事件*/
    getUser();
    $(".am-popup-inner").scroll(function () {
        var boxHeight=$(this).height()-47;
        var scrollHeight=$(this).scrollTop();
        var inHeight=$(".am-popup-bd").height();
        //console.log(boxHeight,scrollHeight,inHeight);
        if((boxHeight+scrollHeight)>inHeight){
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
        $(this).addClass("active-p").siblings().removeClass("active-p");
        var uid = $(this).data("uid");
        var text = $(this).text();
        $("#id_su_uid").val(text).data("uid",uid);
        $('#user-popup').modal('close');
    });
    $('.clean_su_uid').click(function(){
        $("#id_su_uid").val('').data("uid",'');
    });
});