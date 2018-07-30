$('#saveProduct').click(function(){
	var uid = parseInt($("#id_uid").val());
	if(!uid) return alert('请填写商品uid');
	var group_price = parseInt($("#groupPrice").val()*100);
	var group_cnt= parseInt($("#groupCnt").val());

	$.post('?_a=shop&_u=api.addproduct', {uid: uid, group_price: group_price, group_cnt: group_cnt}, function(ret){
            ret = $.parseJSON(ret);
            if(ret.errno==0){
				showTip("", '设置成功',"3000");
			} else {
				showTip("err", '操作失败！',"3000");
			}
	})

});


