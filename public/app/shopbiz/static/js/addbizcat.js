$('.save').click(function(){
	var title = $('#id_title').val();
	var title_en = $('#id_title_en').val();
	var image = $('#id_img').attr('src');
	var sort = $('#id_sort').val();
	//var status = $('#id_status').val();
	var status = $('#id_status').prop('checked') ? 0 : 1;
	var uid = g_uid;
	
	var data = {uid:uid,title:title,title_en:title_en,image:image,sort:sort,status:status};
	$.post('?_a=shop&_u=api.addbizcat', data, function(ret){
		console.log(ret);
		window.location.href='?_a=shopbiz&_u=sp.bizcatlist';
	});
});

   $('#search_pic').click(function(event){
      event.preventDefault();
   });
