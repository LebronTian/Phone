
var tableSave = {};//保存用的table

$(document).ready(function () {
    var ue = UE.getEditor('product-content');

    /*初始化sku填写框**********/
    $('.new-sku').select2({
        tags: true,
        placeholder: "用回车键隔开",
        minimumInputLength: 1      //限制名字最短长度
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
    if(!(edit_product=="")){
        ue.ready(function() {
            ue.setContent(edit_product["content"]);
        });
        if(!(edit_product["type"]=="0")){
            $("input[name='deli-radio'][value='1']").click();//选择直接写在取列表上了
        }
    }

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
        if(districtData[prov].callcode){
            //直辖市特区
            cityAddr +='<option data-prov="'+prov+'">'+$(this).children("option:selected").text()+'</option>';
        }else{
            var cityData = districtData[prov].cell;
            $.each(cityData, function (index) {
                cityAddr +='<option data-prov="'+prov+'" data-city="'+index+'">'+this.name+'</option>';
            });
        }
        $(".sel-city").html(cityAddr);
        addBox.eq(2).fadeIn("fast");
        addBox.eq(3).fadeOut();
        addBox.eq(4).fadeOut();
        $(this).children("option").eq(0).hide()
    });
    $(".sel-city").change(function () {
        var prov = $(this).children("option:selected").data("prov");
        var city = $(this).children("option:selected").data("city");
        var cityAddr = '<option>地区</option>';
        //通过有没有city数据判断是否直辖市特区等
        if(!city){
            //直辖市特区
            var dataTown = districtData[prov].cell;
            if(dataTown){
                $.each(dataTown, function () {
                    cityAddr +='<option>'+this.name+'</option>';
                });
            }else{
                cityAddr+='<option>'+ $(".sel-city").val()+'</option>'
            }
        }else{
            var townData = districtData[prov].cell[city].cell;
            $.each(townData, function () {
                cityAddr +='<option>'+this.name+'</option>';
            });
        }
        $(".sel-town").html(cityAddr);
        addBox.eq(3).fadeIn("fast");
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
        if(!checkTrim($("#product_title"),"请填写活动名称")) return;
        var start_time;
        if($('#start_time').val()==""){
            $("#start_time").focus();
            showTip('err',"请正确填写开始时间",1000);
            return
        }
        start_time =transdate($('#start_time').val());

        var end_time;
        if($('#end_time').val()==""){
            $("#end_time").focus();
            showTip('err',"请正确填写截至时间",1000);
            return
        }

        end_time =transdate($('#end_time').val());

        if(start_time >= end_time){
            $("#start_time").focus();
            $("#end_time").focus();
            showTip('err',"截至时间必须大于开始时间",1000);
            return
        }

        var p_uid = $("#p_uid").val();
        if(!checkTrim($("#p_uid"),"请填写活动商品id")) return;

        if(!$("#act_img").attr("src")){
            showTip("err","请选择活动图",1000);
            $(".buttonImg1").focus();
            return
        }
        var act_img = $("#act_img").attr("src");

        var content ;
        ue.ready(function(){
            content = ue.getContent();
        });
        if(content.trim()==""){
            showTip("err","请填写活动详情","1000");
            return
        }
        var type = $('input[name="deli-radio"]:checked').val();

        /*上传！！！！！！！！！！！！！！！！！！*/
        var bigData = {
            "title":title,
            "content":content,
            "p_uid":p_uid,
            "act_img":act_img,
            "start_time":start_time,
            "end_time":end_time,
            "type":type,
        };
        console.log(bigData);
        var uid = $("#edit-id").data("id");
        var link,text;
        if(uid){
            link = "/?_a=shop&_u=api.addactivity&uid="+uid;
            text = '保存成功'
        }else{
            link = "/?_a=shop&_u=api.addactivity";
            text = '添加成功'
        }

        $.post(link,bigData, function(data){
            data = $.parseJSON(data);
            console.log(data);
            if(data.errno==0){
                //showTip("",text,"1000");
                window.location = document.referrer;
                //window.location.href="/?_a=shop&_u=sp.activitylist"
            }
        });
    });

});

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

/*********************
* 主图回调函数
* */
function mainImg(){
    var picSrc = $("#act-img-src").attr("src");
    var img = '<img id="act_img" src="'+picSrc+'"/>';
    $("#act-img-box").html(img)
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
    //console.log(date);
    return Date.parse(date)/1000;
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






