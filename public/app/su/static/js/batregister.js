$('.save').click(function(){
	var data = {
		account: $('#id_account').val(),
		passwd: $('#id_passwd').val(),
		count: $('#id_count').val()
		,from_su_uid: $('#id_user').attr('data-uid')
	};	

	$.post('?_a=su&_u=api.batregister', data, function(ret){
		console.log(ret);
		ret = $.parseJSON(ret);
		if(ret && ret.errno == 0) {	
			window.location.href='?_a=su&_u=sp.fanslist';	
		}
		else {
			alert('操作失败！');
		}
	});

});

select_user({ele: '#id_user', single: true, onok: function(su) {
	console.log('selected', su);
	$('#id_user').attr('data-uid', su.uid);	
	$('#id_user img').attr('src', su.avatar || '/static/images/null_avatar.png');
	$('#id_user span').text(su.name);
}}); 
