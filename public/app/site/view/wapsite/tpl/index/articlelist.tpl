<?php 
include $tpl_path.'/header.tpl';
?>

<style>

	.list_box{height:60px;width:100%}
	.article_list{padding-bottom:70px;height:auto;}
	.article_list>li{height:70px;border-bottom:thin solid #ECECEC}
	.article_box{width:92%;margin-left:5%}
	.article_box>img{float:left;width:20%;height:64px;margin-top:3px;}
	.article_title{float:left;margin-left:3%;width:77%;overflow:hidden;height:40px;color:#666666;margin-top:15px;line-height:20px;text-overflow:ellipsis;}
</style>
<div style="width:100%;">
<div class="title_box">
	<div class="red_box">
		<div class="list_title"><?php if(isset($cat['title'])) echo $cat['title']; else echo '搜索结果';?></div>
	</div>
	<div class="blue_box">
		<img class="back" style="" src="/app/site/view/wapsite/static/images/back.png">
	</div>
</div>
	<div class="list_box">
		<ul class="article_list" data-id="<?php echo $catid; ?>">
		</ul>
	</div>

</div>





<?php 
include $tpl_path.'/footer.tpl';
?>
<script>
var apage=0;
var uid=$('.article_list').attr('data-id');

$(document).ready(function(){
	uid=$('.article_list').attr('data-id');
	ajaxList();
	setTimeout(function(){
           	var liheight=90*$('.article_list').find('li').length;
  			$('.article_list').css('height',liheight+'px');
  		},1000);
});


function ajaxList(){
  var html='';
  var link='?_a=site&_u=ajax.article_list&cat_uid='+uid+'&limit=6&page='+apage;
  $.getJSON(link,function(data){
  	var data=data.data.list;
    console.log(data);
    apage++;
    $.each(data, function () {
      html+='<li data-uid="'+this.uid+'"><a href="?_a=site&_u=index.article&cid='+this.uid+'"><div class="article_box"><img src="'+this.image+'"><div class="article_title">'+this.title+'</div></div></a></li>';
    });
    $('.article_list').append(html);
  });
}

var stop=true; 
$(window).scroll(function(){ 
    totalheight = parseFloat($(window).height()) + parseFloat($(window).scrollTop()); 
    if($(document).height() <= totalheight){ 
        if(stop==true){ 
            stop=false; 
           ajaxList();
           setTimeout(function(){
           	var liheight=70*$('.article_list').find('li').length;
  			$('.article_list').css('height',liheight+'px');
  		},2000);
            
        } 
    } 
});



</script>