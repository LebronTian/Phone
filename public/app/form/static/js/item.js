function do_delete(uids)
{
    if (!(uids instanceof Array))
    {
        uids = [uids];
    }
    var n;
    var valuie;
    $.each(uids, function (n, value)
    {
        value.remove();
        
    }
    );
    $('.ccheckall').prop('checked', false);
	var uid = f_uid;
    post(uid);
}
//批量选择按钮
$('.ccheckall').click(function ()
{
    var checked = $(this).prop('checked');
    $('.ccheck').prop('checked', checked);
}
);
//批量删除按钮
$('.cdeleteall').click(function ()
{
    var uids = [];
    $('.ccheck').each(function ()
    {
        if ($(this).prop('checked'))
        {

            uids.push($(this).parent().parent());
        }
    }
    );
    //console.log(uids);
    if (!uids.length)
    {
        alert('请选择项目!');
        return;
    }
    if (!confirm('确定要删除吗?'))
    {
        return;
    }
    do_delete(uids);
}
);
//行删除按钮，并自动保存
$('.table-main').on('click', '.cdelete', function ()
{
    var ele = $(this);
    if (!confirm('确定要删除吗?'))
    {
        return;
    }
    ele.parents("tr").remove();
    var uid = f_uid;
    post(uid);

}
);
//文字修改后自动保存
$(".table-main").on('click', '.table-id-title,.table-id-desc,.table-id-default', function ()
{
    var ele = $(this);
    var elechd = ele.children();
    var text = elechd.text();
    //console.log(text);
    var input = $('<input type="text" value=' + text + '>');
    elechd.html(input);

    input.click(function ()
    {
        return false;
    }
    );
    input.trigger("focus");
    //文本框失去焦点后提交内容，重新变为文本
    input.blur(function ()
    {
        var newtxt = $(this).val();
        //判断文本有没有修改
        if (newtxt != text)
        {
            elechd.html(newtxt);
            //保存设置
            var uid = f_uid;
            post(uid);
        }
        else
        {
            elechd.html(newtxt);
        }
    }
    );

}
);

//选择类型的下拉框修改后自动保存
$(".table-main").on('click', '.table-id-type', function ()
{
    var ele = $(this);
    var elechd = ele.children();
    var value = elechd.attr("value");
    var select = $('<select><option value="file_img">图片上传控件</option>' +
            '<option value="text">单行输入框</option>' +
            '<option value="text_multi">多行输入框</option></select>');
    //console.log(select);
    elechd.html(select);
    select.val(value);
    select.click(function ()
    {
        return false;
    }
    );
    select.trigger("focus");
    //文本框失去焦点后提交内容，重新变为文本
    select.blur(function ()
    {

        var newvalue = $(this).find("option:selected").val();
        var newtext = $(this).find("option:selected").text();

        //判断文本有没有修改
        if (newvalue != value)
        {

            elechd.html(newtext);
            elechd.attr("value", newvalue);
            //保存设置
            var uid = f_uid;
            post(uid);
        }
        else
        {
            elechd.html(newtext);
            elechd.attr("value", value);
        }

    }
    );

}
);

//选择类型的下拉框修改后自动保存
$(".table-main").on('click', '.requiredcheck', function ()
{	
    var uid = f_uid;
	post(uid);
}
);
//前段增加一个表单项
$('.add_form_item').click(function ()
{
    var tr = '<tr data-id="">' +
        '<td class="table-check">' +
        '<input type="checkbox" class="ccheck"></td>' +
        '<td class="table-id-type"><span value="" >点击选择类型</span></td>' +
        '<td class="table-id-title" ><span>点击修改标题</span></td><td><input type="checkbox" class="requiredcheck"></td>' +
        '<td class="table-id-desc" >' +
        '<span >点击修改注释</span></td>' +
        //'<td class="table-id-default " ><span></span></td>'+
        '<td  class="table-id-unique"><span></span></td>' +
        '<td><div class="am-btn-toolbar">' +
        '<div class="am-btn-group am-btn-group-xs">' +
        //'<button class="am-btn am-btn-success am-btn-xs am-text-dufault cedit" data-id="">'+
        //'<span class="am-icon-edit"></span>编辑</button>'+
        '<button class="am-btn am-btn-default am-btn-xs am-text-danger cdelete" data-id="">' +
        '<span class="am-icon-trash-o"></span> 删除</button>' +
        '</div></td>' +

        '</tr>';
    $('.table-main').append(tr);

}
);

//唯一按钮
$('.table-main').on('click', '.table-id-unique', function ()
{
    var ele = $(this);
    if (ele.children("span").text() == "")
    {
        $('.table-id-unique').html("<span></span>");
        ele.html('<span><button class="am-btn am-btn-danger am-btn-sm">唯一</button></span>');
    }
    else
    {
        ele.html("<span></span>");
    }
	var uid = f_uid;
	post(uid);
}
);

//保存数据
function post(uid)
{
    var size;
    size = $('.table-main tr').size() - 1;
    console.log(size);
    if (size == 0)
    {
        var datas =
        {
            'uid' : uid,
            data : [],
        };

    }
    else
    {
        var datas =
        {
            'uid' : uid,
            data : [],
			access_rule:{},
        };
        var data;
		var unique_field=-1;
        for (var i = 0; i < size; i++)
        {
			var	type = $('.table-id-type:eq(' + i + ')').children().attr("value");
            console.log(type)
            if(type == '')
            {
                showTip('err', '第'+(i+1)+'项，请选择一个控件类型', 1000);
                return
            }
            var title = $('.table-id-title:eq(' + i + ')').children().text();
            var required = $('.requiredcheck:eq(' + i + ')').prop('checked');
            var desc = $('.table-id-desc:eq(' + i + ')').children().text();
			if($('.table-id-unique:eq(' + i + ')').children("span").text()!="")
				unique_field=i;
			
            var data =
            {
                'id' : i,
                'type' : type,
                'name' : title,
                'required' : required,
                'desc' : desc
            };

            datas.data.push(data);
            console.log(data);
        }
		datas.access_rule={
			unique_field:unique_field,
		}


    }
	datas['data'] = JSON.stringify(datas['data']);
    $.post('?_a=form&_u=api.editformitem', datas, function (ret)
    {
        ret = $.parseJSON(ret);
        if (ret.errno == 0)
        {
            showTip('ok', '保存成功', 1000);
        }
        else
            showTip('err', '保存失败', 1000);
    }
    );

}

$('.table-desc').mouseover(function(){
	$(this).children().show();
	
});
$('.table-desc').mouseout(function(){
	$(this).children().hide();

});