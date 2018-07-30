$(document).ready(function () {

   $(".save-brief").click(function () {

       var content = $("#id_reply").val().trim();
       var p_uid = reply.uid;
       var uid;
       if(reply.reply_son){
           uid = reply.reply_son.uid;
       }


       if(content==""){
           showTip("err","回复不能为空","1000");
           return
       }

       $.post("?_a=form&_u=api.add_form_reply",{uid:uid,p_uid:p_uid,content:content}, function (ret) {
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