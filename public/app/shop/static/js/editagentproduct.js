
var tableSave = {};//保存用的table

$(document).ready(function () {
    var ue = UE.getEditor('product-content');
    /*初始化sku填写框**********/

    /*删除小图*/
    $("#more-img-box").on("click",".del-img", function () {
       if(confirm("确定删除吗？")){
          $(this).parent().remove()
       }
    });
    /**保存按钮******************************************************************************/
    $("#saveProduct").click(function () {
        var title = $("#product_title").val();
        if(!checkTrim($("#product_title"),"请填写商品名称")) return;
        var product_code = $("#product_code").val();
        if(!checkErr($("#product_code"),"请正确填写商品编码")) return;

        if(!checkTrim($("#oriPrice"),"请填写商品原价")) return;
        if(!checkErr($("#oriPrice"),"请正确填写商品原价")) return;
        var ori_price = parseInt($("#oriPrice").val()*100);
        if(!checkTrim($("#proPrice"),"请填写商品售价")) return;
        if(!checkErr($("#proPrice"),"请正确填写商品售价")) return;
        var product_price = parseInt($("#proPrice").val()*100);
        if(!checkprice(product_price))
        {
            return;
        }

        if(!$("#main-img").attr("src")){
            showTip("err","请选择商品主图",1000);
            $(".buttonImg1").focus();
            return
        }
        var main_img = $("#main-img").attr("src");
        var images = [];
        $(".more-img").each(function () {
            var image = $(this).attr("src");
            images.push(image)
        });
        var realImg = images.join(";");

        var content ;
        ue.ready(function(){
            content = ue.getContent();
        });
        var content ;
        ue.ready(function(){
            content = ue.getContent();
        });
        if(content.trim()==""){
            showTip("err","请填写商品详情","1000");
            return
        }
        var statusUp = $("input[name='rad-status']:checked").val();
        if(!statusUp){
            showTip("err","请选择商品状态","1000");
            return
        }
        /*上传！！！！！！！！！！！！！！！！！！*/
        var bigData = {
            "uid":edit_uid,//tpl打印
            "a_uid":edit_a_uid,//tpl打印
            "title":title,
            "content":content,
            "main_img":main_img,
            "images":realImg,
            "price":product_price,
            "ori_price":ori_price,
            "status":statusUp,
        };
        var uid = $("#edit-id").data("id");
        var link;
        link = "/?_a=shop&_u=api.edit_shop_agent_to_user_product";
        console.log(bigData);
        $.post(link,bigData, function(data){
            data = $.parseJSON(data);
            console.log(data);
            if(data.errno==0){
                var uid = data.data;
                console.log(123);
                window.location.reload();
            }
        });
    });
    /******************************************************************************************
    * 编辑预加载功能
    * */
    if(!(edit_product=="")){

        ue.ready(function() {
            ue.setContent(edit_product['product']["content"]);
        });
        var status = edit_product["status"];
        $("input[name='rad-status'][value='"+status+"']").prop("checked",true)
    }
});
/*****************************
* 检验功能
* */
function checkAddr(ele,type){
    var addrText = ele.children("option:selected").text();
    if(addrText==type){
        showTip("err","请选择货物所在"+type,"1000");
        ele.focus();
        return false
    }else return true
}
function checkTrim(ele,text){
    if(ele.val().trim()==""){
        showTip("err",text,"1000");
        ele.focus();
        return false
    }else return true
}
function checkErr(ele,text){
    if(ele.hasClass("am-field-error")){
        showTip("err",text,"1000");
        ele.focus();
        return false
    }else return true
}
function checkprice(price)
{
    console.log(price);
    if(price>=(edit_price_l) && price<=(edit_price_h))
    {
        return true
    }
    else
    {
        showTip("err","销售价格设置有误","1000");
        return false
    }

}
/***********************
* 小图标回调函数
* */
function iconImg(){
    var PicSrc = $(".pic-chose").children("img").attr("src");
    $(imgListThatBtn).attr("src",PicSrc)
}
/*********************
* 主图回调函数
* */
function mainImg(){
    var picSrc = $("#main-img-src").attr("src");
    var img = '<img id="main-img" src="'+picSrc+'"/>';
    $("#main-img-box").html(img)
}
/*********************
 * 更多图片回调函数
 * */
function moreImg(){
    var picSrc = $("#more-img-src").attr("src");
    var img =
        '<div class="more-img-content">' +
        '<img class="more-img" src="'+picSrc+'"/>' +
        '<span class="am-icon-trash del-img"></span>' +
        '</div>';
    $("#more-img-box").append(img)
}
/*******************
* 加载模板列表
* */
function loadTemplate(id){
    var tempSet = $("#template-select");
    tempSet.button("loading");
    var link = "?_a=shop&_u=api.getdelivery";
    $.getJSON(link, function (data) {
        data=data.data;
        var template = '<option value="no">未选择</option>';
        $.each(data, function () {
            template+=
                '<option value="'+this.uid+'">'+this.title+'</option>';
        });
        tempSet.button("reset");
        tempSet.html(template);
        if(id){
            if(!(id==0)){
                console.log(id);
                tempSet.val(parseInt(id))
            }
        }
    });
}

