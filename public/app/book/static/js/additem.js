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
	var price = $('#id_price').val() * 100;
	var status = $('#id_status').prop('checked') ? 0:1;
	var uid = g_uid;
	
	if($.trim(title)==""){
		showTip('err','名称不能为空',1000);
		return false;
	}

	var store_uid = $('.option_store_uids').val();
	var sort = $('#id_sort').val();
	//var discount = parseInt($('#id_discount').val()) * 100; //单位为分
	//var rule = {discount: discount};

	var data = {uid:uid,title:title,type:type,brief:content,main_img:image, 
				price: price, status:status, store_uid:store_uid};
	$.post('?_a=book&_u=api.additem', data, function(ret){
		ret = $.parseJSON(ret);
		if(ret.errno==0){
			showTip('ok','保存成功',1000);
			setTimeout(function(){
				window.location.href='?_a=book&_u=sp.itemlist';
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

/*
	 支持自己输入时间
*/
$('.option_duration').change(function(){
	//amaze ui bug, 直接取val会出错！ 
	//var val = $(this).val();
	var val = $('.option_duration').next().find('li.am-checked').attr('data-value');
	$(this).val(val);

	var self_val = $('.option_duration option').last().attr('value');
	console.log('changed to ', val , ', self_val is', self_val);
	if(self_val == val) {
		$('#doc-datepicker').show();
		setTimeout("$('#doc-datepicker').click();", 300);
	}
	else {
		$('#doc-datepicker').hide();
	}
});

$('#doc-datepicker').on('changeDate.datepicker.amui', function(e){
	//var val = $(this).val();
	var val = e.date.getTime()/1000;
	console.log('date changed to ', val);
	$('.option_duration').next().find('li').last().attr('data-value', val);
	$('.option_duration option').last().attr('value', val);
	$('.option_duration').val(val);
});


