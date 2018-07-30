$('.save').click(function(){

    var sendscope = $('#sendscope').val();
    if($.trim(sendscope)==""){
        showTip('err','配送距离不能为空',1000);
        return false;
    }
    if(parseFloat(sendscope)<=0){
        showTip('err','配送距离不能小于等于0',1000);
        return false;
    }

    var sendtime = $('#sendtime').val();

    if($.trim(sendscope)==""){
        showTip('err','配送时间不能为空',1000);
        return false;
    }
    if(parseFloat(sendscope)<=0){
        showTip('err','配送时间不能小于等于0',1000);
        return false;
    }

    var address = $('#address').val();
    var lat = $('#p_lat').val();
    var lng = $('#p_lng').val();

    if($.trim(address)==""){
        showTip('err','地址不能为空',1000);
        return false;
    }
    if($.trim(lat)==""){
        showTip('err','纬度不能为空',1000);
        return false;
    }
    if($.trim(lng)==""){
        showTip('err','经度不能为空',1000);
        return false;
    }

    var uid = $("#edit-id").data("id");
    var link,text;
    if(uid){
        link = "/?_a=shop&_u=api.addaddress&uid="+uid;
        text = '保存成功'
    }else{
        link = "/?_a=shop&_u=api.addaddress";
        text = '添加成功'
    }

    var data = {
        address_data:{
            sendscope:sendscope,
            sendtime:sendtime,
            address:address,
            lat:lat,
            lng:lng
        }
    };

    $.post(link, data, function(ret){
        ret = $.parseJSON(ret);
        console.log(ret);
        if(ret.errno==0){
            showTip('ok',text,1000);
            setTimeout(function(){
                window.location = document.referrer;
                //window.location.href='?_a=shop&_u=sp.address'
            } ,1000);
        }

    });
});
$('#search_pic').click(function(event){
    event.preventDefault();
})