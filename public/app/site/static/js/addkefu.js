//百度富编辑器初始化
var ue = UE.getEditor('container');

    $("input:checkbox").change(function () {
        var bool = $(this).is(":checked");
        if(bool){
            $(this).siblings("input[type='number']").show()
        }else{
            $(this).siblings("input[type='number']").hide()
        }
    });

var text;
$('.save').click(function(){
	ue.ready(function(){
      text = ue.getContent();
    });
	var title = $('#id_title').val();
	var type = $('#id_type').val();
	var content = text;
	var image = $('#id_img').attr('src');
	var tags = $('#id_tags').val();
	var phone = $('#id_phone').val();
	var serve_point = $('#id_serve_point').val();
	var serve_count= $('#id_serve_count').val();
	var serve_level= $('#id_serve_level').val();
	var status = $('#id_status').prop('checked') ? 0:1;
	var uid = g_uid;
	
	if($.trim(title)==""){
		showTip('err','名称不能为空',1000);
		return false;
	}

	var sort = $('#id_sort').val();

	var data = {uid:uid,title:title,type:type,brief:content,image:image, 
				status:status,tags:tags,phone:phone,
				serve_point:serve_point,serve_count:serve_count,serve_level:serve_level};
	$.post('?_a=site&_u=api.addkefu', data, function(ret){
		ret = $.parseJSON(ret);
		if(ret.errno==0){
			showTip('ok','保存成功',1000);
			setTimeout(function(){
				window.location.href='?_a=site&_u=sp.kefulist';
			},1000);
				
		}
		else
			showTip('err','保存失败',1000);
	});
});

/*检查限制*/
function checkLimit(ele){
    var bool = ele.siblings("input:checkbox").is(":checked");
    if(bool){
        if(ele.val().trim()==""||ele.val().trim()<0){
            showTip("err","请正确填写数据",1000);
            ele.focus();
            return -1;
        }else{
            return ele.val();
        }
    }else{
        return 0;
    }
}

