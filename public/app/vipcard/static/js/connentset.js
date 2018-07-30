$(".saveBtn").click(function () {
    var connent = {};
    var temp_var = {};
    var temp_i = 0;
    var temp_arr = [];
    var error = 0;
    $(".table-tbody").find(".sort-value").each(function () {
        if (temp_arr.indexOf($(this).val()) > -1) {
            error = 1;
            return false;
        }

        temp_arr.push($(this).val());
    });
    if (error == 1) {
        showTip("err", "请保持序号不重复", "1000");
    }

    $(".table-tbody").children().each(
        function () {
            var sort_value;
            var sort_key;
            sort_value = $(this).find(".sort-value").val();
            sort_key = $(this).find(".group-value").data("key");

            if (sort_key == "other") {
                sort_key = "other_" + temp_i;
                temp_i++;
            }
            temp_var[sort_value] = {
                sort_key: sort_key,
                group: $(this).find(".group-value").data("group"),
                title: $(this).find(".title-value").val(),
                placeholder: $(this).find(".placeholder-value").val(),
                need: $(this).find(".need-value").prop("checked")
                    ? 1 : 0,

            }

        }
    );
    console.log(temp_var);
    //return;
    //temp_var.sort(function (a, b) {
    //    return a - b;
    //});
    $.each(temp_var,function(i,item){
        //console.log(item);
        connent[item['sort_key']] = item;
    });
    console.log(connent);
    //return;
    var data = {
        uid: uid,
        connent: connent
    }
    $.post("?_a=vipcard&_u=api.add_or_edit_vip_card_sp_set", data, function (ret) {
        //console.log(ret);
        ret = $.parseJSON(ret);
        if (ret.errno == 0) {
            showTip("", "保存成功", "1000");
            setTimeout(function () {
                window.location.href = document.URL;
            }, 1000);
        }
        else {
            showTip("err", "保存失败", "1000");
        }
        //console.log(ret);

    });
})
;
$("body").on("click",".add_connent_item",function () {
    var temp_arr = [0];
    $(".table-tbody").find(".sort-value").each(function () {
        temp_arr.push($(this).val());
    });
    //console.log(temp_arr);
    //if(temp_arr==[]) temp_arr=[1];
    var temp_sort = Math.max.apply(1, temp_arr);
    temp_sort++;
    var group = $(this).data("group");
    var key = $(this).data("key");

    var title = $(this).text();
    console.log(title);
    if (key != "other" && $('.group-value[data-key="' + key + '"]').length != 0) {
        showTip("err", "这个字段已经被添加啦", "1000");
        return;
    }

    var explame_html = $(".hide-explame table tbody").html();
    console.log(explame_html);
    explame_html = explame_html.replace(/\$sort-value\$/, temp_sort);
    explame_html = explame_html.replace(/\$title\$/g, title);
    explame_html = explame_html.replace(/\$group\$/, group);
    explame_html = explame_html.replace(/\$key\$/, key);
    $(".table-tbody").append(explame_html);

});

$("body").on("click", ".delete_connent_item", function () {
    //var connent_item =$(this);
    $("#my-confirm").modal({
        relatedTarget: this,
        onConfirm: function (options) {
            $(this.relatedTarget).parent().parent().remove();
        },
        onCancel: function () {
        }
    });
})