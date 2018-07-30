$(document).ready(function () {
   $(".save-brief").click(function () {
       var text = $("#id_reply").val().trim();
       var uid = message.uid;
       if(text==""){
           showTip("err","评论不能为空","1000");
           return
       }
       $.post("?_a=shop&_u=admin.reply_comment",{uid:uid,brief:text}, function (ret) {
           ret = $.parseJSON(ret);
           console.log(ret);
           if(ret.errno==0){
               showTip("","回复成功","1000");
               setTimeout(function () {
                   history.back()
               },1000)
           }
       })
   })
});