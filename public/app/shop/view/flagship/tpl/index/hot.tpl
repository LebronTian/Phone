<?php include $tpl_path.'/header.tpl';?>
<link rel="stylesheet" href="<?php echo $static_path?>/css/products.css">
<link rel="stylesheet" href="<?php echo $static_path?>/css/index_footer.css" />
<header class="color-main vertical-box">
    <span class="header-title">限时抢购</span>
    <div class="header-left vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/back.png" onclick="history.back()">
    </div>
    <div class="header-right vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/home.png" onclick="window.location.href='?_a=shop'">
    </div>
</header>
<style>
.container{padding: 0;}
.index-section-pic{width: 95%;text-align: center;margin: 0 auto;display: block;border-radius: 5px;}
</style>
<div class="loading">
	<i class="fa fa-spinner fa-pulse fa-2x"></i><br /><br />
	<p>正在加载...</p>
</div>
<div class="container hide">
	<div class="hot-title">
		<span style="font-size: 0.9em;">
			抢购中，先下单先得哦
		</span>
		<span class="flash-end-time"><kk style="color: #666;font-size: 0.9em;">距结束&nbsp;&nbsp;</kk><span id="t_h">00</span>：<span id="t_m">00</span>：<span id="t_s">00</span></span>
	</div>
	<article class="goodlist-article">
	</article>
	<p class="c-green noflash hide">活动结束，请期待下一场</p>
</div>
<script>
$.post('?_a=shop&_u=ajax.get_activity_by_type&type=1',function(ret){
		ret=JSON.parse(ret);
		if(ret.data['0'].product){
			var a=''
			$.each(ret.data['0'].product,function(ii,i){
				a+='<section class="index-section" data-uid="'+i['uid']+'"><div class="index-section-pic-box"><img class="index-section-pic echo-img" src="'+i['main_img']+'"><div class="section-pic-tips-group"></div><p class="index-section-title">'+i['title']+'</p></div><div class="index-section-footer" style="color: #fd9801;"><span class="secondary-font">¥'+i['price']/100+'</span><span class="white-tips-font small-text" style="text-decoration: line-through">¥'+i['ori_price']/100+'</span><span style="font-size:13px;float:right;margin-top:5px">库存:'+i['quantity']+'<span></div></section>';
			})
			$('.goodlist-article').html(a);
			$('.goodlist-article section').on('click',function(){
				location.href='?_a=shop&_u=index.product&uid='+$(this).data('uid');
			})
			           /* 倒计时*/
			           	function getRTime(){ 
			           var timestamp = ret.data['0'].start_time;
			           var timestamp2 = ret.data['0'].end_time;
			           if(timestamp <Date.parse(new Date())/1000){
			           	timestamp=Math.floor(Date.parse(new Date())/1000);
			           	$('.flash-start-or-end').text('距结束')
			           }
			           else{
						timestamp2=timestamp;
			           	timestamp=Math.floor(Date.parse(new Date())/1000);
			           	$('.flash-start-or-end').text('距开始')
			           }
			           	var d = new Date(timestamp * 1000);    //根据时间戳生成的时间对象
			           	var start_time = (d.getFullYear()) + "/" + 
			           	           (d.getMonth() + 1) + "/" +
			           	           (d.getDate()) + " " + 
			           	           (d.getHours()) + ":" + 
			           	           (d.getMinutes()) + ":" + 
			           	           (d.getSeconds());
			           	var d2 = new Date(timestamp2 * 1000);    //根据时间戳生成的时间对象
			           	var end_time = (d2.getFullYear()) + "/" + 
			           	           (d2.getMonth() + 1) + "/" +
			           	           (d2.getDate()) + " " + 
			           	           (d2.getHours()) + ":" + 
			           	           (d2.getMinutes()) + ":" + 
			           	           (d2.getSeconds());
			           		$('.flash-end-time span').css('background','#55a511')
			           	var EndTime= new Date(end_time);
			           	var StartTime = new Date(start_time); 
			           	var t =EndTime.getTime() - StartTime.getTime();
	
			           	var d=Math.floor(t/1000/60/60/24); 
			           	var h=Math.floor(t/1000/60/60%24)+d*24; 
			           	var m=Math.floor(t/1000/60%60); 
			           	var s=Math.floor(t/1000%60); 
			           	if(h<1&& m<1 && s<1){
			           		h='0';
			           		m='0';
			           		s='0';
			           		$('.flash-end-time span').css('background','#999')
			           		$('.goodlist-article').hide();
			           		$('.noflash').show();
			           	}
			           	if(h<10){
			           		h='0'+h;
			           	}
			           	if(m<10){
			           		m='0'+m;
			           	}
			           	if(s<10){
			           		s='0'+s;
			           	}
			           	document.getElementById("t_h").innerHTML = h; 
			           	document.getElementById("t_m").innerHTML = m; 
			           	document.getElementById("t_s").innerHTML = s;
			           	$('.loading').hide();
			           	$('.container').show();
						$('.goodlist-article .index-section-pic-box img').height($('.goodlist-article .index-section-pic-box img').width());
			           	} 
			           	setInterval(getRTime,1000); 
		}else{
			$('.loading').hide();
			$('.container').show();
		}
})
</script>
</body>
</html>
