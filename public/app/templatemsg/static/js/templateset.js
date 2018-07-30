$(function () {
    /*生成*/
    $('.create').click(function(){
        var id_template_details = $('#id_template_details').val();
        //console.log(id_template_details);
        if(!id_template_details) {
            showTip('err', '模板详情不能为空',1000);
            return false;
        }
        var data = {
            template_details:id_template_details,
            even:even_data
        };
        $.post('?_a=templatemsg&_u=api.get_template_array', data, function(ret){
            ret=$.parseJSON(ret);
            if(ret.errno==0)
            {
                //console.log(ret.data);
                $('.template_arr').children().remove();
                $('.template_arr').append(ret.data);
                jscolor.init();
                inputDiv();
                //previewBox()

            }
        });
    });

    /*保存*/
    $('.save').click(function(){
        var template_date = {};
        $(".template_arr").children().each(function (index) {
            //if(index!=3) return;

            var key = $(this).find("textarea").data("key");
            //var template_arr_value = $(this).find("#template_arr_value").val();
            //console.log("目标",template_arr_value);
            var template_change_value = $(this).find(".new-input").html();
            template_change_value = replace_html(template_change_value);
            //console.log("现在",template_change_value);
            var template_arr_value = template_change_value;

            var template_arr_color = $(this).find(".template_arr_color").val();
            template_date[key] = {};
            template_date[key]['value'] = template_arr_value;
            template_date[key]['color'] = '#'+template_arr_color;
        });
        //return;
        //console.log(template_date);
        var status = ($('#id_status').prop("checked"))?0:1;
        var url = $('#id_url').val();
        var su_uid = $('#id_su_uid').data("uid");
        var template_id = $('#id_template_id').val();

        if(!template_id) {
            showTip('err', '模板编号不能为空',1000);
            return false;
        }
        var id_template_details = $('#id_template_details').val();
        //console.log(id_template_details);
        if(!id_template_details) {
            showTip('err', '模板详情不能为空',1000);
            return false;
        }
        var data = {
            uid :uid,
            even :even_data,
            public_uid :public_uid,
            status:status,
            url:url,
            su_uid:su_uid,
            template_id :template_id,
            template_date :template_date,
            template_details:id_template_details
        };
        $.post('?_a=templatemsg&_u=api.set_user_template_by_tpl_id', data, function(ret){
            ret=$.parseJSON(ret);
            if(ret.errno==0){
                showTip("","保存成功","1000");
                setTimeout(function () {
                    history.back()
                },1000);
            }else
            {
                switch (ret.errstr)
                {
                    case 'ERROR_OBJ_NOT_EXIST':
                        showTip("err","保存失败</br>错误原因：</br>1、未配置公众号</br>2、公众号不是认证服务号","4000");
                        setTimeout(function () {
                        },4000);
                        break;
                    case 'ERROR_INVALID_REQUEST_PARAM' :
                        showTip("err","保存失败</br>错误原因：</br>提交参数错误","4000");
                        setTimeout(function () {
                        },4000);

                        break;
                    default:
                        break;
                }
            }
        });
    });
    /*变量数据保存*/
    $(".option_even ").eq(0).children("option").each(function () {
        var val = $(this).val();
        if(val!="选择添加参数"){
            val = val.substr(5);
            var index = val.indexOf(".");
            val = val.substr(0,index);
            variableData[val] = $(this).text();
        }
    });
    /*11月3
    *
    * 试图在显示上加一层效果
    * */
    //previewBox();
    /*
        div转换
    */
    inputDiv();
    /*添加参数*/
    $("body").on("change",".option_even", function () {
        var val = $(this).val();
        var title = $(this).children(":selected").text();
        $(this).children().eq(0).prop("selected",true);
        var textarea = $(this).parent().siblings(".am-u-sm-6").find("#template_arr_value");
        textarea.val(textarea.val()+val);

        /*更换后的textarea   todo:注意数据要再处理一下放回去*/
        val = val.substr(5);
        var index = val.indexOf(".");
        val = val.substr(0,index);
        var div = $(this).parent().siblings(".am-u-sm-6").find(".new-input");
        div.append("&nbsp;<span class='variable-span' data-index='"+val+"'>"+title+"</span>&nbsp;")
        $('.new-input').focusout()
    });



});
/*用来返回数据*/
var variableData = {};

/*
    更换textarea
*/
function inputDiv(){
    console.log("?");
    $(".makeup-div").each(function (i) {
        console.log("@");
        var textarea = $(this).find("textarea");
        var text = textarea.val();
        text = replace_textarea(text);
        textarea.after('<div class="new-input " contenteditable="true">'+text+'</div>').hide();//todo******************hide()
    })
    $('.new-input').on('focusout', function() {
        var key = $(this).parent().find("textarea").data("key")
        var text = $(this).html()
        console.log(text)
        text = text.replace(/<div>(.+)?<\/div>/g, "<br>$1");//
        console.log(text)
        $('.'+key+'_DATA').html(text)
    });
    $('.template_arr_color').on('change', function() {
        var color = $(this).val()
        var key = $(this).parent().parent().find('div').eq(1).find("textarea").data("key")
        console.log('.'+key+'_DATA',"color",'"#'+color+'"')
        $('.'+key+'_DATA').css("color",'#'+color+'');
    });

}
/*
    中间处理,textarea=>html
*/
function replace_textarea(text){
    /*换行*/
    text = text.replace(/\n/g,"<br/>");
    /*even*/
    text = text.replace(/EVEN.(\w+).EVEN/g, function (ret) {
        /*检索出来，去掉even，加上span*/
        var nature = ret;//原本的
        ret = ret.substr(5);
        var index = ret.indexOf(".");
        ret = ret.substr(0,index);
        if(variableData[ret]){
            return "&nbsp;<span class='variable-span' data-index='"+ret+"'>"+variableData[ret]+"</span>&nbsp;";
        }
        else{
            return nature
        }

    });
    return text;
}
/*
    提交的时候的处理，html=》textarea

function replace_html2(text){
    text = text.replace(/<br>/g,"\n");
    text = text.replace(/&nbsp;/g,"");
    text = text.replace(/<span([^>]*)?>/g,"EVEN.");
    text = text.replace(/<\/span([^>]*)?>/g,".EVEN");

    text = text.replace(/EVEN.(\+).EVEN/g, function (ret) {
        console.log(ret,"??????????");
        return ret
    });
    return text
}*/
function replace_html(text){
    text = text.replace(/<br>/g,"");
    text = text.replace(/&nbsp;/g,"");
    text = text.replace(/<span class="variable-span" data-index="(\w+)".+?<\/span>/g, "EVEN.$1.EVEN");
    text = text.replace(/<div>([^<]+)?<\/div>/g, "\n$1");//
    /* 中间的</div>而且匹配用贪心又会过多，不行不可行
    text = text.replace(/<div>([^<]+)?<\/div>/g, function (ret) {
        ret = ret.substr(5);
        var index = ret.indexOf("</div>");
        ret = ret.substr(0,index);
        console.log(index);
        return "\n"+ret
    });*/
    return text
}

/*搁浅项目*/
function previewBox(){
    var textarea = $("#id_template_details");
    var html = "<div contenteditable='true' id='preview_template'>"+textarea.text()+"</div>";
    textarea.after(html)
}

/*
模板列表
 */
var get_template_list_all;

get_teplate_list_all();

function get_teplate_list_all(a)
{
    $('.template_refresh i').attr('class','am-icon-refresh am-icon-spin')
    $.getJSON('?_a=templatemsg&_u=api.get_template_list_all',{'refresh':a},function(ret)
    {
        console.log(ret)
        if(ret.errno==0)
        {
            get_template_list_all = ret.data
            for(var i=0;i<ret.data.length;i++){
                $('#id_template_id').append('<option value="'+ret.data[i].template_id+'" >'+ret.data[i].title+'</option>');
            }
        }

        if (!$.AMUI.support.mutationobserver) {
            $('#id_template_id').trigger('changed.selected.amui');

        }
        if(templateData.template_id!=undefined)
        {
            $('#id_template_id').val(templateData.template_id)
        }
        else{
            // $('#id_template_id').children('option').eq(1).select()
        }
        $('#id_template_id').change()
        $('.template_arr_color').change()

        setTimeout(function(){
           $('.template_refresh i').attr('class','am-icon-refresh')
       },1000);

    });

}
var init =1;
$('#id_template_id').on('change', function() {
    if(this.selectedIndex<0) this.selectedIndex =1
    $('#id_template_details').html(get_template_list_all[this.selectedIndex].content);
    var text = get_template_list_all[this.selectedIndex].content
    text = text.replace(/\n/g,"<br>");
    text = text.replace(/\{\{(\w+)\.(\w+)\}\}/g,'<span class="$1_$2">$1.$2</span>');
    $('#id_template_preview_content').html(text);
    $('#id_template_preview_title').html(get_template_list_all[this.selectedIndex].title);
    if(init ==0 || $('.template_arr').html().trim().length==0)
    {
        $('.create').click();
    }
    if(init ==1)  init =0;
});
$('.template_refresh').on('click',function(){
    $('#id_template_id').html('')
    get_teplate_list_all(true)
});





