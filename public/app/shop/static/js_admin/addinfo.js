/**
 * Created by Near on 2015/7/24.
 */
$(document).ready(function () {
    /*
    * info初始化
    * */
    if(!(edit_product=="")){
        console.log("?");
        $.getJSON("?_a=shop&_u=admin.get_product_extra_info",{product_uid:edit_product.uid}, function (ret) {
            console.log("a",ret);
            if(ret.errno==0){
                var infoHtml = '';
                $.each(ret.data, function () {
                    infoHtml+=
                    '<div class="extra-box" data-uid="'+this.product_uid+'"> ' +
                    '<input id="extra-input" class="extra-name" value="'+this.ukey+'" style="width: 10em" minlength="1" type="text" placeholder="请输入属性名称"/>' +
                    ' : ' +
                    '<input id="extra-input" class="extra-value" value="'+this.data+'" style="width: 20em" minlength="1" type="text" placeholder="请输入属性内容"/> ' +
                    '<span style="margin-left: 1em;cursor: pointer" class="am-icon-trash del-extra"></span> ' +
                    '</div>';
                });
                $(".extra-content").append(infoHtml)
            }
        })
    }

    //添加按钮
    var infoBox =
        '<div class="extra-box"> ' +
        '<input id="extra-input" class="extra-name" style="width: 10em" minlength="1" type="text" placeholder="请输入属性名称"/>' +
        ' : ' +
        '<input id="extra-input" class="extra-value" style="width: 20em" minlength="1" type="text" placeholder="请输入属性内容"/> ' +
        '<span style="margin-left: 1em;cursor: pointer" class="am-icon-trash del-extra"></span> ' +
        '</div>';
    $(".add-extra-info").click(function () {
        $(this).parent().append(infoBox);
        $(".extra-name:last").focus()
    });

    /*删除按钮*/
    $(".extra-content").on("click",".del-extra", function () {
        if(confirm("确定要删除吗？")){
            $(this).parent().fadeOut("fast", function () {
                $(this).remove()
            });
            /*已有数据删除*/
            var uid = $(this).parent().data("uid");
            if(uid){
                var name = $(this).siblings(".extra-name").val();
                $.post("?_a=shop&_u=admin.delete_product_extra_info",{uid:uid,ukey:name}, function (ret) {
                    console.log(ret)
                })
            }

        }
    })
});
