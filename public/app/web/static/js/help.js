/*
	amazeui 会调用一次change事件,此时不刷新
*/
var by_amaze_init = 1;
$('.option_cat').change(function(){
	if(by_amaze_init) {
		by_amaze_init = 0;
		return;
	}

	var cat = $(this).val();
	//alert(cat);
	window.location.href='?_a=web&_u=index.help&cat=' + cat;
});

$('.option_key_btn').click(function(){
	var key = $('.option_key').val();
	//允许关键字为空，表示清空条件
	if(1 || key) {
		var cat = $(this).val();
		window.location.href='?_a=web&_u=index.help&cat=' + cat+'&key='+key;
	}
});
$('.option_key').keydown(function(e){
	if(e.keyCode == 13) {
		$('.option_key_btn').click();
	}
});

// var by_amazes_init = 1;
// $('.install_btn').change(function(){
// 	if(by_amazes_init) {
// 		by_amazes_init = 0;
// 		return;
// 	}
// 	var t = $(this).val();
// 	if(t == 'totle'){
// 		window.location.href= '?_a=web&_u=index.help&cat=&key=&limit=8&installed=0&page=0';
// 	}
// 	if(t == 'select'){
// 		window.location.href= '?_a=web&_u=index.help&cat=&key=&limit=8&installed=1&page=0';
// 	}
// 	if(t == 'none'){
// 		window.location.href= '?_a=web&_u=index.help&cat=&key=&limit=8&installed=2&page=0';
// 	}

// });




