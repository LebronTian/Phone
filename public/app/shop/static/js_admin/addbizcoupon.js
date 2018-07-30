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
	var publish_cnt = $('#id_publish_cnt').val();
	var content = text;
	var image = $('#id_img').attr('src');
	//var status = $('#id_status').val();
	var uid = g_uid;
	
	if($.trim(title)==""){
		showTip('err','名称不能为空',1000);
		return false;
	}

	var duration = $('.option_duration').val();
	var valuation = $('.option_parent').val();
	var discount = parseInt($('#id_discount').val()) * 100; //单位为分

	if($.trim(discount) <= 0){
		showTip('err','优惠金额必须大于0',1000);
		return false;
	}

	var rule = {discount: discount};
	var max_cnt = checkLimit($('#id_max_cnt'));
	if(max_cnt==-1) return;
	var max_cnt_day = checkLimit($('#id_max_cnt_day'));
	if(max_cnt_day==-1) return;
	var min_price = checkLimit($('#id_min_price'));
	if(min_price==-1) return;
	rule['max_cnt'] = max_cnt;
	rule['max_cnt_day'] = max_cnt_day;
	rule['min_price'] = parseInt(min_price*100);

	var data = {uid:uid,title:title,publish_cnt:publish_cnt,brief:content,image:image,duration: duration, valuation:valuation, rule:rule};

	$.post('?_a=shop&_u=admin.add_or_edit_bizcoupon', data, function(ret){
		ret = $.parseJSON(ret);
		if(ret.errno==0){
			showTip('ok','保存成功',1000);
			setTimeout(function(){
				window.location.href='?_a=shop&_u=admin.bizcoupon';
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