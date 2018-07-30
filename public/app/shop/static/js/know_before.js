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

        var data = {"title":title,"content":content,"uid":uid};


        if(title !== "" && content !== ""){
            $.post("?_a=shop&_u=api.addradio&&type_in=1",data,function(ret){
                console.log(ret);
                ret = $.parseJSON(ret);
                if(ret.errno == 0){
                    showTip('ok', "保存成功", 1000);
                    window.location.href="?_a=shop&_u=sp.know_before";
                }else{
                    showTip('err', "保存失败", 1000);
                }



            });
        }

    });
});
