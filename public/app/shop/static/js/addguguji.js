

$(document).ready(function () {

     /**保存按钮******************************************************************************/
    $("#saveBiz").click(function () {

        if(!checkTrim($("#id_name"),"请填写打印机名称")) return;
        if(!checkTrim($("#id_ak"),"请填写软件签名ak")) return;
        if(!checkTrim($("#memobirdid"),"请填写打印机设备编号")) return;
        if(!checkTrim($("#useridentifying"),"请填写打印机APPID")) return;
        var name = $("#id_name").val();
        var ak = $("#id_ak").val();
        var memobirdid = $("#memobirdid").val();
        var useridentifying = $("#useridentifying").val();
        var count = $("#count").val();

        var status = $("input[name='rad-status']:checked").val();
        if(!status){
            showTip("err","请选择审核状态","1000");
            return
        }
        /*上传！！！！！！！！！！！！！！！！！！*/
        var bigData = {
            "name":name,
            "ak":ak,
            "memobirdid":memobirdid,
            "useridentifying":useridentifying,
            "count":count,
            "status":status
        };
        var uid = $("#edit-id").data("id");
        var link,text;
        if(uid){
            link = "/?_a=shop&_u=api.addguguji&uid="+uid;
            text = '保存成功'
        }else{
            link = "/?_a=shop&_u=api.addguguji";
            text = '添加成功'
        }
        console.log(bigData);
        $.post(link,bigData, function(data){
            data = $.parseJSON(data);
            console.log(data);
            if(data.errno==0){
                showTip("",text,"1000");
                setTimeout(function () {
                    window.location.href="/?_a=shop&_u=sp.gugujilist";
                },1000)
            }else{
                showTip("err","失败！","1000");
            }
        });
    });

    /******************************************************************************************
    * 编辑预加载功能
    * */
    if(!(data=="")){
        /***********************************/

        var status = data["status"];
        $("input[name='rad-status'][value='"+status+"']").prop("checked",true);
    }
});
/*****************************
* 检验功能
* */
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

    $("#id_test").click(function () {

        if(!checkTrim($("#id_name"),"请填写打印机名称")) return;
        if(!checkTrim($("#id_ak"),"请填写软件签名ak")) return;
        if(!checkTrim($("#memobirdid"),"请填写打印机设备编号")) return;
        if(!checkTrim($("#useridentifying"),"请填写打印机APPID")) return;
        var name = $("#id_name").val();
        var ak = $("#id_ak").val();
        var memobirdid = $("#memobirdid").val();
        var useridentifying = $("#useridentifying").val();

        /*上传！！！！！！！！！！！！！！！！！！*/
        var bigData = {
            "name":name,
            "ak":ak,
            "memobirdid":memobirdid,
            "useridentifying":useridentifying,
        };
        var uid = $("#edit-id").data("id");
        var link,text;
        link = "/?_a=shop&_u=api.testprint";
        text = '已发送打印指令';
        console.log(bigData);
        $.post(link,bigData, function(data){
            data = $.parseJSON(data);
            console.log(data);
            if(data.errno==0){
                showTip("",text,"3000");
            }else{
                showTip("err","测试失败！","3000");
            }
        });
    });

