var img_width;
	$(document).ready(function(){
	img_width= parseInt($('.list_box a img').css('width'));
	$('.list_box').css('height',img_width+30);
	$('.list_box a img').css('height',img_width);
	var num=parseInt($('.list_box').length);
	var c_height = (parseInt(img_width)+55)*Math.ceil(num/2);
	$('.cat_list').css('height',c_height+'px');
	$('.cat_content').css('height',c_height+'px');
	console.log(img_width);
});

var sp_uid = $('.cat_list').attr('data-uid');
var page = 1;
var stop = true;

var cid = $('.cat_list').attr('data-cid');
	$(window).scroll(function(){
	if($('.cat_list').attr('data-astutas')==1){
	if($(this).scrollTop()+$(window).height()+100>=$(document).height()
		&& $(this).scrollTop()>100){
		if(stop==true){
			stop=false;
			var link = '/?_a=site&_u=ajax.article_list&sp_uid='+sp_uid+'&page='+page+'&cat_uid='+cid;
			var box_height = img_width+30;
			console.log(box_height);
			$.getJSON(link,function(data){
				var data = data.data.list;
				console.log(data);
			var html = '';
			$.each(data,function(){
					html+='<div class="list_box" style="height:'+box_height+'px"><a href="/?_a=site&sp_uid='
						+this.cat_uid+'&cid='+this.uid
						+'&_u=index.article"><img src="'
						+this.image
						+'" style="height:'+img_width+'px"></a><div style=""><a href="/?_a=site&sp_uid='
						+this.cat_uid
						+'&cid='
						+this.uid
						+'&_u=index.article">'
						+this.title
						+'</a></div></div>';
				});
			$('.cat_list').append(html);
			var total_height = parseInt($('.cat_content').css('height'));
			total_height = total_height+(box_height+20)*data.length;
			console.log(total_height);
			$('.cat_list').css('height',total_height+'px');
			$('.cat_content').css('height',total_height+'px');
			if (data.length < 10) {
				stop = false;
            }
			else {
				stop = true;
			}
			});
		}
	}
}
});
