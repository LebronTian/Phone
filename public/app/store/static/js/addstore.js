var text;
$('.save').click(function(){
	var name = $('#id_name').val();
	var brief = $('#id_brief').val();
	var main_img = $('#id_img').attr('src');
	var sort = $('#id_sort').val();
	var address = $('#id_address').val();
	var lng= $('#id_lng').val();
	var lat= $('#id_lat').val();
	var telephone= $('#id_telephone').val();
	//var status = $('#id_status').val();
	var status = $('#id_status').prop('checked') ? 0 : 1;
	var uid = g_uid;
	
	if($.trim(name)==""){
		showTip('err','店铺名称不能为空',1000);
		return false;
	}

	var data = {uid:uid,name:name,brief:brief,main_img:main_img,sort:sort,status:status,address:address,lng:lng,lat:lat,telephone:telephone};
	$.post('?_a=store&_u=api.addstore', data, function(ret){
		ret = $.parseJSON(ret);
		if(ret.errno==0){
			showTip('ok','保存成功',1000);
			setTimeout(function(){
				window.location.href='?_a=store&_u=sp'}
				,1000);
		}
		else
			showTip('err','保存失败',1000);
	});
});



