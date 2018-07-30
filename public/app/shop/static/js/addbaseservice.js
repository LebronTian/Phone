$(document).ready(function(){

    var uid = $("#documentUid").attr('data-id');

    $('#saveDocument').click(function(){

        var title = $("#document_title").val();
        var content = $("#content").val();
        //ue.ready(function(){
        //    content = ue.getContent();
        //});

        if(title == ""){
            $("#document_title").focus();
        }else if(content == ""){
            alert("内容不能为空！");
        }

        var data = {"title":title,"content":content,"uid":uid,'type_in':5};

        // console.log(data.title + "\n" + data.content);
        if(title !== "" && content !== ""){
            $.post("?_a=shop&_u=api.addradio",data,function(ret){
                console.log(ret);
                ret = $.parseJSON(ret);
                if(ret.errno == 0){
                    showTip('ok', "保存成功", 1000);
                    setTimeout(function(){
                        window.location.href="?_a=shop&_u=sp.baseservices";
                    } ,1000);

                }else{
                    showTip('err', "保存失败", 1000);
                }



            });
        }

    });
});
