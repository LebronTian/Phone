$(".saveBtn").click(function () {
    var connent=connent_Data;
    var error =0;
    var show_index=1;
    $.each(connent,function(i,item){

        connent[i]['show'] = 0 ;
    });
    console.log(connent);
    //return;
    $('.image-section .option_cat').each(function()
    {
        var temp_key = $(this).val();
        if(temp_key!=0)
        {
            if( connent[temp_key]==undefined)
            {
                connent[temp_key]={};
                connent[temp_key]['group'] =  $(this).find('option:selected').data('group');
                connent[temp_key]['protect'] =1;
            }
            connent[temp_key]['show']=show_index;
            connent[temp_key]['show_title'] =$(this).parent().parent().find(".show_title").prop("checked")? 1 : 0;
            connent[temp_key]['title'] =$(this).parent().parent().find(".title-value").val();
            console.log($(this).parent().parent().find(".title-value").val());
            if( connent[temp_key]['show_title']==1 && connent[temp_key]['title']=="")
            {
                error =1;
                return false;
            }
            ++show_index;
            //console.log($(this).parent().parent().find(".show_title").prop("checked"));
        }

    });
    var show_index=1;
    $('.string-section .option_cat').each(function()
    {
        var temp_key = $(this).val();
        if(temp_key!=0)
        {
            if( connent[temp_key]==undefined)
            {
                connent[temp_key]={};
                connent[temp_key]['group'] =  $(this).find('option:selected').data('group');
                connent[temp_key]['protect'] =1;
            }
            connent[temp_key]['show']=show_index;
            connent[temp_key]['show_title'] =$(this).parent().parent().find(".show_title").prop("checked")? 1 : 0;
            connent[temp_key]['title'] =$(this).parent().parent().find(".title-value").val();
            console.log($(this).parent().parent().find(".title-value").val());
            if( connent[temp_key]['show_title']==1 && connent[temp_key]['title']=="")
            {
                error =1;
                return false;
            }
            ++show_index;
            //console.log($(this).parent().parent().find(".show_title").prop("checked"));
        }

    });
    console.log(connent);
    if(error==1)
    {
        showTip("err", "请填写名称", "1000");
        return;
    }
    $.each(connent,function(i,item){

        if(connent[i]['protect'] &&　!connent[i]['show'])
        {
            delete connent[i];
        }

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
});

//var by_amaze_init = 1;
$('.option_cat').change(function(){
    //if(by_amaze_init) {
    //    by_amaze_init = 0;
    //    return;
    //}
    var temp_key = $(this).val();
    //console.log($(this).val());
    if(temp_key!=0) {

        if(connent_Data[temp_key]==undefined ||connent_Data[temp_key]["title"]==undefined )
        {
            $(this).parent().parent().find(".title-value").val("");

        }
        else{
            $(this).parent().parent().find(".title-value").val(connent_Data[temp_key]['title']);

        }
    }
});