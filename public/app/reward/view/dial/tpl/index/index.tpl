<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title><?php echo $reward['title'];?></title>
	<link rel="stylesheet" href="app/reward/view/dial/static/css/reset.css">
	<link rel="stylesheet" href="app/reward/view/dial/static/css/dial.css">
	<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport">
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
	<meta name="renderer" content="webkit">
</head>
<body class="body">
<!-- <?php var_dump($reward);?> -->
	<!-- 加载页面 -->
	<div id="loading_box">
		<img src="app/reward/view/dial/static/images/loading_gif_2.gif">
	</div>

	<!-- 背景层 -->
	<div class="body_bg"></div>

	<!-- 获奖用户滚动列表 -->
	<div class="reward_box">
		<div class="reward_box_i">
		<img src="<?php echo $reward['img'];?>" class="first_img">
			<ul>
			<?php 
			$html='';
			foreach ($records['list'] as $c) {
				$html.='<li>幸运用户<span class="'.(isset($c['user']['name']) ? :'user_ip').'">'.(isset($c['user']['name']) ? $c['user']['name']:$c['user_ip']).'</span> 获得 <span> '.$c['item']['title'].'</span></li>';
			}
			echo $html;
			?>
			<!-- <li>
				幸运用户<span>微信66123</span>抽中<span>iphone6s</span>
			</li>
			<li>
				幸运用户<span>微信456</span>抽中<span>ipho</span>
			</li> -->
			</ul>
		</div>
	</div>

	<!-- 主体部分 -->
	<div class="container" data-ruid="<?php echo $reward['uid'];?>" data-title="<?php echo $reward['title'];?>" data-img="<?php echo $reward['img'];?>">
		<h2 class="index_title"><?php echo (empty($reward['title'])?'':$reward['title'])?></h2>
		<div class="desc_box">
			<div class="index_desc"><?php echo (empty($reward['brief'])?'':$reward['brief'])?></div>
		</div>
		<div class="time_note">
			<p class="start_p">活动开始时间：<span class="start_time"><?php echo (empty($reward['access_rule']['start_time'])?'':$reward['access_rule']['start_time'])?></span></p>
			<p class="end_p">活动结束时间：<span class="end_time"><?php echo (empty($reward['access_rule']['end_time'])?'':$reward['access_rule']['end_time'])?></span></p>
		</div>
	</div>
	

	<!-- 开始抽奖按钮 -->
	<div class="share_play">
		<a href="?_a=reward&_u=index.play&r_uid=<?php echo (empty($reward['uid'])?'':$reward['uid'])?>"> 
			<img src="app/reward/view/dial/static/images/start_play.png" id="stare_play">
		</a>
	</div>


<script src="app/reward/view/dial/static/js/jquery2.1.min.js"></script>
<script src="app/reward/view/dial/static/js/dial.js"></script>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>

<?php
	echo '<script>var item_count = '.(empty($items['count'])?'':$items['count']).';</script>';
	echo '<script>var cnt_info = '.json_encode(RewardMod::get_user_reward_cnt_info($reward['uid'])).';</script>';	
?>


<script>
	<?php
		echo 'var wx_cfg = '.json_encode(WeixinMod::get_jsapi_params()).';'; 
	?>
	if(wx_cfg) {
	  	wx_cfg['debug'] = false;
	  	wx_cfg['jsApiList'] = ['onMenuShareTimeline','onMenuShareAppMessage'];
		wx.config(wx_cfg);

		wx.ready(function(){
			wx.onMenuShareTimeline({
			    title: "<?php echo (empty($reward['win_rule']['title'])?$reward['title']:$reward['win_rule']['title'])?>", // 分享标题
			    desc: "<?php echo $reward['title'];?>", // 分享描述
			    link: "<?php echo getUrlName().'?_a=reward&r_uid='.$reward['uid']?>", // 分享链接
			    imgUrl: "<?php echo getUrlName().'/'.$reward['img']?>", // 分享图标
			    success: function () {
			    		alert("分享成功！");
			    	    var r_uid=$('.container').attr('data-ruid');
					 	var link='?_a=reward&_u=ajax.on_share_wx&r_uid='+r_uid;
					  	var datas = [];
						  
					  	$.post(link,datas,function(data){
						  	var reg=$.parseJSON(data);
						  	console.log(reg);
						  	// var reg_data = true;
				     		console.log(reg.data);
				     		if(reg.data != false){
				     			location.reload();
				     		}
						});
			   //  	var $limit_num = $('.limit_num');
			   //  	var left_cnt = ($limit_num.text())*1+1;
			   //  	$limit_num.text(left_cnt);
			   //  	$pointer.click(function (){
						// if ($pointer.attr("clicking") !== "yes"){
						// 	if( left_cnt > 0){
						// 		$pointer.attr("clicking","yes");
						// 		left_cnt = left_cnt - 1;
						// 		$limit_num.text(left_cnt);	
						// 		click_rotate();	
						// 		setTimeout(function(){
						// 		$pointer.removeAttr("clicking");
						// 	},8000);
						// 	}else{
						// 		alert("您的抽奖次数已用完!");
						// 	}
						// }
					
			        // 用户确认分享后执行的回调函数
			    },
			    cancel: function () { 
			        // 用户取消分享后执行的回调函数
			    }
			});

			wx.onMenuShareAppMessage({
			    title: "<?php echo (empty($reward['win_rule']['title'])?$reward['title']:$reward['win_rule']['title'])?>", // 分享标题
			    desc: "<?php echo $reward['title'];?>", // 分享描述
			    link: "<?php echo getUrlName().'?_a=reward&r_uid='.$reward['uid']?>", // 分享链接
			    imgUrl: "<?php echo getUrlName().'/'.$reward['img']?>", // 分享图标
			    success: function () {
			        // 用户确认分享后执行的回调函数
			    },
			    cancel: function () { 
			        // 用户取消分享后执行的回调函数
			    }
			});
		});
	}

</script>


</body>
</html>
