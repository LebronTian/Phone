
var tableSave = {};//保存用的table

$(document).ready(function () {
    var ue = UE.getEditor('product-content');
    /*初始化sku填写框**********/
    $('.basic-services').select2({
        tags: true,
        placeholder: "用回车键隔开",
        minimumInputLength: 1      //限制名字最短长度
    });
    $('.basic-services').trigger('change');

    $('.new-sku').select2({
        tags: true,
        placeholder: "用回车键隔开",
        minimumInputLength: 1      //限制名字最短长度
    });
    $("#miaosha").change(function () {
        var bool = $(this).is(":checked");
        if(bool){
            $('#ms_set').css('display','');
        }else{
            $('#ms_set').css('display','none');
        }
    });
    /*选择规格方式****************************************/
    $('input[name="standard-radio"]').change(function () {
        var type = $('input[name="standard-radio"]:checked').val();
        $(".select-standard").slideUp();
        $("#standard"+type).slideDown()
    });
    /*选择运费方式****************************************/
    $('input[name="deli-radio"]').change(function () {
        var type = $('input[name="deli-radio"]:checked').val();
        if(type=="2"){
            $("#delivery-select").slideDown()
        }else{
            $("#delivery-select").slideUp()
        }
    });
    /*重置表格**************/
    $(".refresh-sku").click(function () {
        if(confirm("重新添加将会删除现有的规格")){
            var newTable = '<thead><tr><th id="thead-mark">售价（元）</th><th>原价（元）</th><th>库存（件）</th><th>小图标</th></tr></thead><tbody></tbody>';
            $(".sku-table").html(newTable);
            tableSave = {}
        }
    });
    /*规格弹出框*********************************************/
    $('.add-sku').on('click', function() {
        $('#sku-prompt').modal({
            relatedTarget: this,
            onConfirm: function(e) {
                buildTable(e.data);
                /*初始化********************/
                $(".prompt-type").val("");
                $(".select2-selection__choice").remove();
                $(".new-sku").children("option").remove();
            },
            onCancel: function(e) {
            }
        });
    });
    /*判断有没有输入*/
    $(".select2-selection__rendered").on("keyup",".select2-search__field", function () {
        if((!!$(".select2-selection__choice").length)&&(!$(".prompt-type").val().trim()=="")){
            $(".sku-btn-up").removeClass("disable-btn").removeAttr("disabled");
        }else{
            $(".sku-btn-up").addClass("disable-btn").attr("disabled","disabled")
        }
    });
    $(".prompt-type").keyup(function () {
        if((!!$(".select2-selection__choice").length)&&(!$(".prompt-type").val().trim()=="")){
            $(".sku-btn-up").removeClass("disable-btn").removeAttr("disabled");
        }else{
            $(".sku-btn-up").addClass("disable-btn").attr("disabled","disabled")
        }
    });
    /*加载运费模板内容****************************/
    loadTemplate(edit_product["delivery_uid"]);
    /*刷新*/
    $(".refresh-template").click(function () {
        loadTemplate();
    });
    /*加载省级所在地地址********************************************************/
    var provAddr = '';
    $.each(districtData, function (index) {
        provAddr +='<option data-sort="'+index+'">'+this.name+'</option>'
    });
    $(".sel-prov").append(provAddr);
    /*货物所在地选择*/
    var addBox = $(".sel-addr");
    $(".sel-country").change(function () {
        if($(this).val()=="中国"){
            $(".sel-addr").eq(1).fadeIn("fast");
            $(".sel-prov").children().eq(0).prop("selected",true)
        }else{
            addBox.eq(1).fadeOut();
            addBox.eq(2).fadeOut();
            addBox.eq(3).fadeOut();
            addBox.eq(4).fadeOut()
        }
    });
    $(".sel-prov").change(function () {
        var prov = $(this).children("option:selected").data("sort");
        var cityAddr = '<option>城市</option>';
        //通过cellcode判断是否直辖市特区等
        //修改地址不全报错
        if(prov) {
            if (districtData[prov].callcode) {
                //直辖市特区
                cityAddr += '<option data-prov="' + prov + '">' + $(this).children("option:selected").text() + '</option>';
            } else {
                var cityData = districtData[prov].cell;
                $.each(cityData, function (index) {
                    cityAddr += '<option data-prov="' + prov + '" data-city="' + index + '">' + this.name + '</option>';
                });
            }
            $(".sel-city").html(cityAddr);
            addBox.eq(2).fadeIn("fast");
        }
        addBox.eq(3).fadeOut();
        addBox.eq(4).fadeOut();
        $(this).children("option").eq(0).hide()
    });
    $(".sel-city").change(function () {
        var prov = $(this).children("option:selected").data("prov");
        var city = $(this).children("option:selected").data("city");
        var cityAddr = '<option>地区</option>';
        //通过有没有city数据判断是否直辖市特区等
        if(prov) {
            if (!city) {
                //直辖市特区
                var dataTown = districtData[prov].cell;
                if (dataTown) {
                    $.each(dataTown, function () {
                        cityAddr += '<option>' + this.name + '</option>';
                    });
                } else {
                    cityAddr += '<option>' + $(".sel-city").val() + '</option>'
                }
            } else {
                var townData = districtData[prov].cell[city].cell;
                $.each(townData, function () {
                    cityAddr += '<option>' + this.name + '</option>';
                });
            }
            $(".sel-town").html(cityAddr);
            addBox.eq(3).fadeIn("fast");
        }
        addBox.eq(4).fadeOut();
        $(this).children("option").eq(0).hide()
    });
    $(".sel-town").change(function () {
        addBox.eq(4).fadeIn("fast");
        $(this).children("option").eq(0).hide()
    });
    /*删除小图*/
    $("#more-img-box").on("click",".del-img", function () {
       if(confirm("确定删除吗？")){
          $(this).parent().remove()
       }
    });
    /**保存按钮******************************************************************************/
    $("#saveProduct").click(function () {
        var title = $("#product_title").val();
        var title_second = $("#title_second").val();
        //var title_third = $("#title_third").val();
        if(!checkTrim($("#product_title"),"请填写商品名称")) return;
        var product_code = $("#product_code").val();
        if(!checkErr($("#product_code"),"请正确填写商品编码")) return;
        var sort = $("#product_sort").val();
        if(!checkErr($("#product_sort"),"请正确填写商品序号")) return;

        var cat_uid = $(".choose-cats").data("uid");
        var bas_services = $('.basic-services').val();

        var searchInfo = $("input[name='searchInfo']:checked");
        //商品info分类
        var Info=0;
        $.each(searchInfo, function () {
            var bit = $(this).val();
            Info = Info+Math.pow(2,bit)
        });

        if((Info|32)==Info){

            if($('#ms_start_time').val()==""){
                $("#ms_start_time").focus();
                showTip('err',"请正确填写开始时间",1000);
                return
            }
            var kill_start_time =transdate($('#ms_start_time').val());

            if($('#ms_end_time').val()==""){
                $("#ms_end_time").focus();
                showTip('err',"请正确填写截至时间",1000);
                return
            }
            var kill_end_time =transdate($('#ms_end_time').val());

            if(kill_start_time >= kill_end_time){
                showTip('err',"截止时间必须大于开始时间",1000);
                return
            }

        }else{
            var kill_start_time = 0;
            var kill_end_time = 0;
        }

        //var package = $("#package").val();
        //var send_start_time = $("#send_start_time").val();
        //var send_end_time = $("#send_end_time").val();

        //if(!checkTrim($("#package"),"请填写套餐时间")) return;
        //if(!checkTrim($("#send_start_time"),"请填写配送开始时间")) return;
//      if(!checkTrim($("#send_end_time"),"请填写配送截止时间")) return;

        if(!checkTrim($("#oriPrice"),"请填写商品原价")) return;
        if(!checkErr($("#oriPrice"),"请正确填写商品原价")) return;
        var ori_price = parseInt($("#oriPrice").val()*100);
        if(!checkTrim($("#proPrice"),"请填写商品售价")) return;
        if(!checkErr($("#proPrice"),"请正确填写商品售价")) return;
        var product_price = parseInt($("#proPrice").val()*100);
        /*返回积分*/
        var back_point = parseInt($("#back_point").val());
//      var else_info = $("#else_info").val();
        var group_price = parseInt($("#groupPrice").val()*100);
        var group_cnt= parseInt($("#groupCnt").val());

        var product_quantity = 1;
        var sku_table = null;
        if($("input[name='standard-radio']:checked").val()==1){
            //统一规格
            product_quantity= $("#proQuantity").val();
            if(!checkTrim($("#proQuantity"),"请填写商品库存")) return;
            if(!checkErr($("#proQuantity"),"请正确填写商品库存")) return;
        }else{
            //特殊规格
            if($(".sku-table").find(".head-type").length==0){
                showTip("err","请选择规格","1000");
                $('.add-sku').focus();
                return
            }
            var status = false;
            $(".price-in-table").each(function () {
                if(!checkTrim($(this),"请填写规格详细信息")){
                    status=true;
                    return false
                }
            });
            if(status) return;
            /*数据处理**************/
            var table = tableSave;
            var info = {};

            var infoTit = $(".head-type");
            var infoTitLength = infoTit.length;

            $(".oldTr").each(function () {
                var brief = $(this).children(".firstTd");
                var title='';
                for(var a=0;a<infoTitLength;a++){
                    title+=';'+infoTit.eq(a).text().substr(4)+':'+brief.eq(a).text()
                }
                var readTit = title.substr(1);

                var info_price = parseInt($(this).find(".price-in-table").eq(0).val()*100);
                var info_ori_price = parseInt($(this).find(".price-in-table").eq(1).val()*100);
                var info_quantity = parseInt($(this).find(".price-in-table").eq(2).val());
                var info_icon_img = $(this).find(".sku-icon").attr("src");
                info[readTit]={
                    "price":info_price,
                    "ori_price":info_ori_price,
                    "quantity":info_quantity,
                    "icon_img":info_icon_img
                }
            });
            sku_table={
                "table":table,
                "info":info
            };
            sku_table = JSON.stringify(sku_table);
            //console.log(sku_table);
        }

        var location;
        if(!checkAddr($(".sel-country"),"国家")) {
            return;
        }else if($(".sel-country").children("option:selected").text()=="中国"){
            if(!checkAddr($(".sel-prov"),"省份")) return;
            if(!checkAddr($(".sel-city"),"城市")) return;
            if(!checkAddr($(".sel-town"),"地区")) return;
            location={
                "country": $(".sel-country").children("option:selected").text(),
                "province":$(".sel-prov").children("option:selected").text(),
                "city":$(".sel-city").children("option:selected").text(),
                "town":$(".sel-town").children("option:selected").text(),
                "address":$(".sel-street").val()
            };
        }else{
            location={
                "country": $(".sel-country").children("option:selected").text()
            }
        }
        location = JSON.stringify(location);

        var delivery_uid = null;
        if($("input[name='deli-radio']:checked").val()==2){
            delivery_uid = $("#template-select").children("option:selected").val();
            if(delivery_uid=="no"){
                $("#template-select").focus();
                showTip("err","请选择运费模板","1000")
            }
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
        if(content.trim()==""){
            showTip("err","请填写商品详情","1000");
            return
        }
        var statusUp = $("input[name='rad-status']:checked").val();
        if(!statusUp){
            //showTip("err","请选择商品状态","1000");
            //return
        }
        /*上传！！！！！！！！！！！！！！！！！！*/
        var bigData = {
            "title":title,
            "title_second":title_second,
            //"title_third":title_third,
            "content":content,
            "main_img":main_img,
            "images":realImg,
            "bas_services":bas_services,
            "price":product_price,
            "biz_uid":edit_biz.uid,
            //"package":package,
            //'send_time':{
            //    send_start_time:send_start_time,
            //    send_end_time:send_end_time
            //},
            'kill_time':{
                start_time:kill_start_time,
                end_time:kill_end_time
            },
            "ori_price":ori_price,
            "group_price":group_price,
            "group_cnt":group_cnt,
            "back_point":back_point,
            "quantity":product_quantity,
            "product_code":product_code,
            "info":Info,
//          "else_info":else_info,
            "sku_table":sku_table,
            "location":location,
            "delivery_uid":delivery_uid,
            "sort":sort,
            //"status":statusUp,
            "cat_uid":cat_uid
            ,"virtual_info": JSON.stringify(g_virtual_info) //support for empty
        };
        var uid = $("#edit-id").data("id");
        var link,text;
        if(uid){
            link = "/?_a=shop&_u=admin.add_product&uid="+uid;
            text = '保存成功'
        }else{
            link = "/?_a=shop&_u=admin.add_product";
            text = '添加成功'
			bigData['status'] = 1;
        }
        //console.log(bigData);
        $.post(link,bigData, function(data){
            data = $.parseJSON(data);
            console.log(data);
            if(data.errno==0){
                var uid = data.data;
                /*自定义额外属性*/
                var extra_length = $(".extra-box").length;
                if(extra_length==0){
                    window.location.href="/?_a=shop&_u=admin.productlist"
                }
                else{
                    $(".extra-box").each(function (index) {
                        var ukey = $(this).children(".extra-name");
                        var eData = $(this).children(".extra-value");
                        if(!checkTrim(ukey,"属性名称不能为空")) return;
                        if(!checkTrim(eData,"属性内容不能为空")) return;
                        var data = {
                            uid:uid,
                            ukey:ukey.val(),
                            data:eData.val()
                        };
                        console.log(data);
                        $.post("?_a=shop&_u=admin.add_product_extra_info",data, function (ret) {
                            console.log(ret);
                            /*判断是否结束************************/
                            var length = $(".extra-box").length-1;
                            console.log(length,index);
                            if(length==index){
                                showTip("",text,"1000");
                                window.location.href="/?_a=shop&_u=admin.productlist"
                            }
                        })
                    })
                }
            }
        });
    });
    /******************************************************************************************
    * 编辑预加载功能
    * */
    if(!(edit_product=="")){
        /*Info*/
        var edit_info = parseInt(edit_product['info']);
        if(edit_info){
            if((edit_info|32)==edit_info){
                $("[name='searchInfo'][value='5']").prop("checked",true)
                $('#ms_set').css('display','');
            }
            if((edit_info|64)==edit_info){
                $("[name='searchInfo'][value='6']").prop("checked",true)
            }
            if((edit_info|128)==edit_info){
                $("[name='searchInfo'][value='7']").prop("checked",true)
            }
        }
        /***********************************/
        if(edit_product["sku_table"]==""){
            //统一规格
            $("#proQuantity").val(edit_product['quantity'])
        }else{
            //特殊规格
            $("input[value='2'][name='standard-radio']").click();
            for(var type in edit_product["sku_table"]["table"]){
                var sku_arr = [];
                var sku_sel = [];
                sku_arr.push(type);
                $.each(edit_product["sku_table"]["table"][type], function (index) {
                    sku_sel.push(edit_product["sku_table"]["table"][type][index])
                });
                sku_arr.push(sku_sel);
                console.log(sku_arr);
                buildTable(sku_arr)
            }
            /*构造key！！*返回价格***********/
            var infoTit = $(".head-type");
            var infoTitLength = infoTit.length;
            $(".oldTr").each(function () {
                var brief = $(this).children(".firstTd");
                var title='';
                for(var a=0;a<infoTitLength;a++){
                    title+=';'+infoTit.eq(a).text().substr(4)+':'+brief.eq(a).text()
                }
                var readTit = title.substr(1);
                var table_cell = edit_product["sku_table"]["info"][readTit];
                if(table_cell){
                    $(this).find(".price-in-table ").eq(0).val(table_cell["price"]/100);
                    $(this).find(".price-in-table ").eq(1).val(table_cell["ori_price"]/100);
                    $(this).find(".price-in-table ").eq(2).val(table_cell["quantity"]);
                    $(this).find(".sku-icon").attr("src",table_cell["icon_img"])
                }
            })
        }

        var country = edit_product["location"]["country"];
        $(".sel-country").children("option:contains("+country+")").prop("selected",true);
        if(country=="中国"){
            $(".sel-prov").val(edit_product["location"]["province"]).change();
            $(".sel-city").val(edit_product["location"]["city"]).change();
            $(".sel-town").val(edit_product["location"]["town"]).change();
            $(".sel-street").val(edit_product["location"]["address"]);
            $(".sel-addr").show();
            //修改地址不全报错
            if(edit_product["location"]["province"]==""){
                $(".sel-addr").eq(1).fadeOut();
            }
            if(edit_product["location"]["city"]==""){
                $(".sel-addr").eq(2).fadeOut();
            }
            if(edit_product["location"]["town"]==""){
                $(".sel-addr").eq(3).fadeOut();
            }
            if(edit_product["location"]["address"]==""){
                $(".sel-addr").eq(4).fadeOut()
            }
        }
        if(!(edit_product["delivery_uid"]=="0")){
            $("input[name='deli-radio'][value='2']").click();//选择直接写在取列表上了
        }
        ue.ready(function() {
            ue.setContent(edit_product["content"]);
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
    if(0 && addrText==type){
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
/*************************
 * 制作表格功能
 * */
function buildTable(data,callback){
    console.log(data);
    var type = $(".sku-table thead tr th").length-3;
    /*头部插入***************************************/
    var head = '<th class="head-type" data-length="'+data[1].length+'">分类'+type+':'+data[0]+'</th>';
    $("#thead-mark").before(head);
    /*
    * 制造盒子
    * */
    var length = data[1].length;
    /**TABLE FOR SAVE*********************************************/
    var arrData=[];
    for(var a=0;a<length;a++){
        arrData.push(data[1][a])
    }
    tableSave[data[0]]=arrData;
    /*************************************************************/
    if(type==1){
        var table='';
        for(var i=0;i<length;i++){
            table+=
                '<tr class="oldTr">' +
                '<td class="firstTd" rowspan="1">'+ data[1][i]+'</td> ' +
                '<td class="table-price">' +
                    '<input style="display: inline;width: 120px" class="price-in-table" minlength="1" type="number" pattern="^[0-9]+(.[0-9]{1,100})?$" placeholder="售价"/>' +
                    '<span style="margin-left: 7px">元</span>' +
                '</td> ' +
                '<td>' +
                    '<input style="display: inline;width: 120px" class="price-in-table" minlength="1" type="number" pattern="^[0-9]+(.[0-9]{1,100})?$" placeholder="原价"/>' +
                    '<span style="margin-left: 7px">元</span>' +
                '</td>' +
                '<td>' +
                    '<input style="display: inline;width: 95px" class="price-in-table" minlength="1" type="number" pattern="^[1-9]\\d*$" placeholder="库存"/>' +
                    '<span style="margin-left: 7px">件</span>' +
                '</td> ' +
                '<td>' +
                    '<img class="imgBoxBtn sku-icon" data-func="iconImg"/>' +
                '</td> ' +
                '</tr>' ;
        }
        $(".sku-table").children("tbody").html(table);
    }
    /****************************************************/
    if(!(type==1)){
        var oldTr=$(".oldTr");
        oldTr.each(function () {
            /*补全前面不显示*用于保存*/
            var oldTdHtml;
            $(this).children(".firstTd").each(function () {
                oldTdHtml+='<td class="firstTd" rowspan="0" style="display: none">'+$(this).text()+'</td>'
            });

            var newTr='';
            for(var n=1;n<length;n++){
                newTr+=
                    '<tr>' ;
                newTr+=oldTdHtml;
                newTr+=
                    '<td class="firstTd" rowspan="1">'+ data[1][n]+'</td> ' +
                    '<td class="table-price">' +
                    '<input style="display: inline;width: 120px" class="price-in-table js-pattern-number" minlength="1" type="number" pattern="^[0-9]+(.[0-9]{1,100})?$" placeholder="售价"/>' +
                    '<span style="margin-left: 7px">元</span>' +
                    '</td> ' +
                    '<td>' +
                    '<input style="display: inline;width: 120px" class="price-in-table js-pattern-number" minlength="1" type="number" pattern="^[0-9]+(.[0-9]{1,100})?$" placeholder="原价"/>' +
                    '<span style="margin-left: 7px">元</span>' +
                    '</td>' +
                    '<td>' +
                    '<input style="display: inline;width: 95px" class="price-in-table js-pattern-number" minlength="1" type="number" pattern="^[1-9]\\d*$" placeholder="库存"/>' +
                    '<span style="margin-left: 7px">件</span>' +
                    '</td> ' +
                    '<td>' +
                    '<img class="imgBoxBtn sku-icon" data-func="iconImg"/>' +
                    '</td> ' +
                    '</tr>' ;
            }
           $(this).after(newTr);
        });
        /**********************************/
        var td='<td class="firstTd" rowspan="1">'+ data[1][0]+'</td>';
        /***********************************/
        oldTr.each(function () {
            /*更新rowspan*/
            $(this).children(".firstTd").each(function () {
               var  rowSpan = $(this).attr("rowspan");
                $(this).attr("rowspan",rowSpan*length)
            });
            /*添加新的一行**********************************/
            $(this).children(".table-price").before(td)
        });
        $(".sku-table").children("tbody").children("tr").attr("class","oldTr")
    }

    /*回调*******/
    if(callback){
        callback()
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
    var link = "?_a=shop&_u=admin.getdelivery";
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

/*
 将php的时间用js转换为时间戳
 */
function transdate(endTime){
    var date=new Date();
    date.setFullYear(endTime.substring(0,4));
    date.setMonth(endTime.substring(5,7)-1);
    date.setDate(endTime.substring(8,10));
    date.setHours(endTime.substring(11,13));
    date.setMinutes(endTime.substring(14,16));
    date.setSeconds(endTime.substring(17,19));
    console.log(date);
    return Date.parse(date)/1000;
}

/*
 *  简单修改js 38.8 * 100 != 3880 的问题
 */
var _parseInt = parseInt;
parseInt = function(str) {
    if(typeof str == 'number') return Number(str.toFixed(0));
    return  _parseInt.apply(_parseInt, arguments);
}
