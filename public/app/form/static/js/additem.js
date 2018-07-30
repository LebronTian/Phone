//百度富编辑器初始化
var ue = UE.getEditor('container');

var text;
$('.save').click(function(){
	ue.ready(function(){
      text = ue.getContent();
    });
	var title = $('#id_title').val();
	var brief = text;
	var img = $('#id_img').attr('src');
	var total_cnt = $('#id_total_cnt').val();
	var weight = $('#id_weight').val();
	var win_cnt = $('#id_win_cnt').val();
	var sort = $('#id_sort').val();
	//var v_uid = v_uid;
	if($.trim(title)==""){
		showTip('err','标题不能为空',1000);
		return false;
	}
	var data = {r_uid:r_uid,
				uid:uid,
				title:title,
				brief:brief,
				img:img,
				total_cnt:total_cnt,
				weight:weight,
				win_cnt:win_cnt,
				sort:sort,
					};
	$.post('?_a=reward&_u=api.addrewarditem', data, function(ret){
		ret = $.parseJSON(ret);
		if(ret.errno==0){
			showTip('ok','保存成功',1000);
			setTimeout(function(){
				window.location.href='?_a=reward&_u=sp.itemlist&r_uid='+r_uid;}
				,1000)
		}
		else
			showTip('err','保存失败',1000);
	});
});

$('.cdeleteall').click(function(){
	var uids = [];
	$('.ccheck').each(function(){
		if ($(this).prop('checked')) {
			uids.push($(this).parent().parent().attr('data-id'));
		}
	});
	console.log(uids);
	if(!uids.length) {
		alert('请选择项目!');return;
	}
	if(!confirm('确定要删除吗?')) {
		return;
	}
	//do_delete(uids);
});

