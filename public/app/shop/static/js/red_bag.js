$(document).ready(function(){

    var ue = UE.getEditor('product-content'),
        uid = $("#documentUid").attr('data-id'),
        title,
        content;

    $('#saveDocument').click(function(){

        title = $("#document_title").text();

        ue.ready(function(){
            content = ue.getContent();
        });

        if(content == ""){
            alert("内容不能为空！");
        }

        var send_times = $('#id_times').val();

        var data = {"title":title,"content":content,"uid":uid,"send_times":send_times};


        if(title !== "" && content !== ""){
            $.post("?_a=shop&_u=api.addradio&&type_in=2",data,function(ret){
                console.log(ret);
                ret = $.parseJSON(ret);
                if(ret.errno == 0){
                    showTip('ok', "保存成功", 1000);
                    window.location.href="?_a=shop&_u=sp.red_bag";
                }else{
                    showTip('err', "保存失败", 1000);
                }



            });
        }

    });
});
