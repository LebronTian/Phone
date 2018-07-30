$(function () {
    $(".saveBtn").click(function () {
        var ui_set = {};
        /*背景*/
        var bg = $("#bg-img").attr("src");
        if(bg.trim()==""){
            showTip("err","请选择背景图",1000);
            return
        }
        ui_set['back_ground'] = {
            path:bg
        };
        /*图片*/
        var image = {};
        $(".image-section").each(function () {
            var img = $(this).find(".vipcard-img").attr("src");
            var title = $(this).find(".vipcard-img").data("title");
            console.log(img,title);
            image[title] = {
                path:img
            }
        });
        ui_set['image'] = image;
        /*会员等级图片*/
        var rank_image_list = [];
        $(".rank_image-section").each(function () {
            var img = $(this).find(".rank_image-img").attr("src");
            rank_image_list.push(img);
        });
        ui_set['rank_image_list'] = rank_image_list;
        /*文本*/
        var string = [];
        $(".string-section").each(function () {
            var str = $(this).find(".vipcard-input").val();
            string.push({content:str})
        });
        ui_set['string'] = string;
        console.log(ui_set);
        $.post("?_a=vipcard&_u=api.add_or_edit_vip_card_sp_set",{ui_set:ui_set,uid:setData.uid}, function (ret) {
            ret = $.parseJSON(ret);
            console.log(ret)
            //showTip("", "保存成功", "1000");
            if (ret.errno == 0) {
                showTip("", "保存成功", "1000");
                setTimeout(function () {
                    window.location.href = document.URL;
                }, 1000);
            }
        })
    });

});
