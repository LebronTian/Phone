<?php include $tpl_path.'/header.tpl';?>

<link rel="stylesheet" href="<?php echo $static_path;?>/css/swiper/swiper.min.css">
<script src="<?php echo $static_path;?>/css/swiper/swiper.min.js"></script>
<link rel="stylesheet" href="<?php echo $static_path?>/css/index_footer.css" />

<header class="color-main vertical-box">
    <span class="header-title">留言墙</span>
    <div class="header-left vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/back.png" onclick="history.back()">
    </div>
    <div class="header-right vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/home.png" onclick="window.location.href='?_a=shop'">
    </div>
</header>
<div class="banner">
	<div class="swiper-container"><!--swiper容器[可以随意更改该容器的样式-->  
	    <div class="swiper-wrapper">
			<?php
			uct_use_app('shop');
			if($slides) {
			$html = '';
			foreach($slides as $s) {
				$html .= '<div class="swiper-slide"><img src="'.$s['image'].'"></div>';
			}
			echo $html;
			}
			?>
	    </div>
	    <div class="swiper-pagination" style="float: right"></div>
	</div>
</div>
<div class="message-input">
	<input type="text" placeholder="留个言吧..."/>
	<i class="fa fa-check c-green message-submit"></i>
</div>
<div class="message-list">
	<?php
	foreach($messages as $mes){
	?>
	<ul>
		<li data-uid="<?php echo $mes['uid']; ?>" data-good="<?php echo $mes['good']; ?>">
			<div class="message-list-good">
				<i class="fa fa-thumbs-o-up <?php if(!empty($user_good))foreach($user_good as $ug){
				if($ug == $mes['uid']){ echo 'c-green'; }
				} ?>"></i>
				<span class="message-list-good-num"><?php echo $mes['good']; ?></span>
			</div>
			<div class="user">
				<p class="user-name"><?php echo ($mes['user']['name'])? $mes['user']['name']:$mes['user']['account']; ?></p>
				<p class="user-time c-gray"><?php echo date("Y-m-d H:i:s",$mes['create_time']); ?></p>
			</div>
			<div class="message-list-content">
				<a><?php echo $mes['brief']; ?></a>
			</div>
		</li>
	</ul>
	<?php } ?>
</div>



<script>
var su=<?php echo AccountMod::has_su_login()?>;
$('.message-input input,.message-input i').height($('body').width()*0.1);

$('.message-list').on('click','.message-list-good',function(){
	if(su == 0){
		alert('请先登录，才可点赞');
		location.href='?_a=shop&_u=user.index'
	}else{
		var message_uid=$(this).parent().data('uid');
		var message_good=$(this).parent().data('good')+1;
        var that = this;
//		console.log(message_good);
		var data = {me_uid:message_uid,me_good:message_good};
		$.post("?_a=shop&_u=ajax.add_message_good",data,function(ret){
			console.log(ret);
			ret = $.parseJSON(ret);
			if(ret.data == 0){
			}else{
				$(that).addClass('c-green');
				$(that).find('.message-list-good-num').text(parseInt($(that).find('.message-list-good-num').text())+1);
			}

		});
	}
});

	$('.swiper-container').height($('body').width()/2)
    var mySwiper = new Swiper(".swiper-container",{  
        direction:"horizontal",/*横向滑动*/  
        loop:true,/*形成环路（即：可以从最后一张图跳转到第一张图*/
        pagination:".swiper-pagination",/*分页器*/ 
        autoplay:3000/*每隔3秒自动播放*/
    }) 
$('.message-submit').click(function(){
	if(su == 0){
		alert('请先登录，才可留言');
		location.href='?_a=shop&_u=user.index'
	}else{
		var message=$(this).prev().val();
		var data = {brief:message};
	//		console.log(data);
		if(!message){
			alert('请输入内容');
		}
		else if(!(/^.{0,50}$/.test(message))){
			alert('字数不多于五十字')
		}
		else{
			if(confirm('确定提交吗?')){
				$.post('?_a=shop&_u=ajax.add_message', data, function(ret){
					alert('发表成功，等待审核');
					$(this).prev().val('');
				});
			}
		}
	}
})
$('.message-list li').each(function(ii,i){
	var name_length=$(i).find('.user-name').text().length;
	var name_first=$(i).find('.user-name').text().charAt(0);
	if(name_length <4){
		$(i).find('.user-name').text(name_first+'***')
	}else{
		var name_last=$(i).find('.user-name').text().charAt($(i).find('.user-name').text().length-1);
		$(i).find('.user-name').text(name_first+'***'+name_last)
	}
})
</script>
</body>
</html>
