$(document).ready(function(){

    $('#saveDocument').click(function(){

        //title = $("#id_title").val();

        var card_img = $('#id_card_img').attr('src');



        var data = {"card_img":card_img};

        //console.log(data);return

        if(card_img !== ""){
            $.post("?_a=bargain&_u=api.cdo_card_img",data,function(ret){
                console.log(ret);
                ret = $.parseJSON(ret);
                if(ret.errno == 0){
                    showTip('ok', "保存成功", 1000);
                    window.location.href="?_a=bargain&_u=sp.card_img";
                }else{
                    showTip('err', "保存失败", 1000);
                }
            });
        }

    });
});
