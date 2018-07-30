$('.save-set').click(function(){

	var uid = $('.save-set').attr('data-uid');

	var mks = [];
	$('.board-item').each(function (i,ii){
		var trans=$(this).css('transform').replace(/[^0-9\-,]/g,'').split(',');
		var transY = trans[5];
		var val = $(this).children().children().children('.mks').attr('data-mk');
		//var title = $(this).children().children().children('.mks').html();
		//console.log(val);
		//console.log(transY);
		mks[transY] = val;
	});
	console.log(mks);

	var data = {uid:uid,mks:mks};

	$.post('?_a=shop&_u=api.setview', data, function(ret){
		ret = $.parseJSON(ret);
		if(ret.errno==0){
			showTip('ok','保存成功',1000);
			setTimeout(function(){window.location.href='?_a=shop&_u=sp.index_view'
			} ,1000);
		}
	});
});

