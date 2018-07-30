<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title><?php echo $reward['title'];?></title>
	<link rel="stylesheet" href="app/reward/view/dial/static/css/reset.css">
	<link rel="stylesheet" href="app/reward/view/dial/static/css/dial_c.css">
	<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport">
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
	<meta name="renderer" content="webkit">
</head>
<body class="body">
<!-- <?php var_dump($reward);?> -->
<!-- <?php var_dump(RewardMod::get_user_reward_cnt_info($reward['uid']));?> -->

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
	<div class="container" data-ruid="<?php echo $reward['uid'];?>" data-title="<?php echo $reward['title'];?>" data-img="<?php echo $reward['img'];?>" data-share-title="<?php echo $reward['win_rule']['title'];?>">
		<div class="rotate_bg">
			<!-- 转动盘 -->
			<div class="rotate" id="rotate">
			    <ul id="rotate_item">
				    <?php 
				    $html = '';
			    	if(!empty($items["list"]))
			    	{
		    			$j = 1;
						$count  = count($items["list"]);
						
						for($i=0;$i<$count;$i++)
						{	
							if(	($count%2==0) && ($i==$count/2))
							{
								$html .= '<li><a><span id="prize_"'.$j.'>谢谢参与<img src="app/reward/view/dial/static/images/empty_c.png"></span></a></li>';
								$html .= '<li><a><span id="prize_'.(++$j).'" class="item_uid_'.$items["list"][$i]['uid'].'">'.$items["list"][$i]['title'].'<img src="'.$items["list"][$i]['img'].'"></span></a></li>';
							}
							else
							{
								$html .= '<li><a><span id="prize_'.($j).'" class="item_uid_'.$items["list"][$i]['uid'].'">'.$items["list"][$i]['title'].'<img src="'.$items["list"][$i]['img'].'"></span></a></li>';
							}
							
							$j++;
						}
						$html .= '<li><a><span id="prize_'.($j).'">谢谢参与<img src="app/reward/view/dial/static/images/empty_c.png"></span></a></li>';
			    	}	
			   		echo $html;
				    ?>
				<!-- <li><a><span id="prize_1">iphone6<img src="app/reward/view/dial/static/images/prize_pic.png"></span></a></li>
			        <li><a><span id="prize_2">很遗憾<img src="app/reward/view/dial/static/images/prize_pic.png"></span></a></li>
			        <li><a><span id="prize_3">抽纸<img src="app/reward/view/dial/static/images/prize_pic.png"></span></a></li>
			        <li><a><span id="prize_4">手机<img src="app/reward/view/dial/static/images/prize_pic.png"></span></a></li>
			        <li><a><span id="prize_5">很遗憾<img src="app/reward/view/dial/static/images/prize_pic.png"></span></a></li>
			        <li><a><span id="prize_6">很遗憾<img src="app/reward/view/dial/static/images/prize_pic.png"></span></a></li>
			        <li><a><span id="prize_7">笔记本<img src="app/reward/view/dial/static/images/prize_pic.png"></span></a></li>
			        <li><a><span id="prize_8">很遗憾<img src="app/reward/view/dial/static/images/prize_pic.png"></span></a></li> -->
			    </ul>
			</div>
			<!-- 转动触发按钮 -->
			<div class="img_box">
				<img src="app/reward/view/dial/static/images/pointer_c.png" class="pointer">
				<img src="app/reward/view/dial/static/images/flash.png" class="flash">
				<img src="app/reward/view/dial/static/images/hat.png" class="hat">
			</div>
			<!-- 中奖页面 -->
			<div class="else_show" id="showPage">
				<div class="prize_intro">
			    	<h3>恭喜您！</h3>
			    	<p>恭喜您抽中了<span id="prize">抽纸</span>!</p>
			    	<img src="app/reward/view/dial/static/images/cutter.png" class="cutter">
			    	<div class="prize_pic_box">
			    		<img src="app/reward/view/dial/static/images/prize_pic.png" class="prize_pic">
		    		</div>
			    	<img src="app/reward/view/dial/static/images/get_prize.png" class="get_prize" id="get_prize">
			    	<img src="app/reward/view/dial/static/images/off.png" class="else_off" id="prize_off">
			    	<img src="app/reward/view/dial/static/images/prize_up.png" class="prize_up">
			    	<img src="app/reward/view/dial/static/images/prize_down.png" class="prize_down">
			    </div>
			</div>
			<!-- 未中奖页面 -->
			<div class="else_show" id="showPage_false">
				<div class="prize_intro">
			    	<h3>很遗憾</h3>
			    	<p>很遗憾，差一点点就中大奖了</p>
			    	<img src="app/reward/view/dial/static/images/cutter.png" class="cutter">
			    	<img src="app/reward/view/dial/static/images/empty_c.png" class="prize_pic_1">
			    	<img src="app/reward/view/dial/static/images/again.png" class="get_prize ">		
			    	<img src="app/reward/view/dial/static/images/off.png" class="else_off">
			    	<img src="app/reward/view/dial/static/images/prize_up.png" class="prize_up">
			    	<img src="app/reward/view/dial/static/images/prize_down.png" class="prize_down">
			    </div>
			</div>
		</div>
	</div>

	<!-- 抽奖次数说明 -->
	<div class="dial_limit" data-cnt="<?php echo (empty($reward['access_rule']['max_cnt'])?0:$reward['access_rule']['max_cnt']);?>" data-cnt-day="<?php echo (empty($reward['access_rule']['max_cnt_day'])?0:$reward['access_rule']['max_cnt_day']);?>">
		<p style="color:white;">抽奖次数还剩<span class="limit_num">0</span>次</p>
		<p id="chance" style="color:white;">分享到朋友圈可增加一次机会</p>
	</div>

	<!-- 分享到朋友圈按钮 -->
	<div class="share_to">
		<img src="/app/reward/view/dial/static/images/share.png" id="share_to">
		<img src="/app/reward/view/dial/static/images/share_snow_up.png" class="share_snow_up">
		<img src="/app/reward/view/dial/static/images/share_snow_down_1.png" class="share_snow_down_1">
		<img src="/app/reward/view/dial/static/images/share_snow_down_2.png" class="share_snow_down_2">
		<img src="/app/reward/view/dial/static/images/share_snow_down_3.png" class="share_snow_down_3">
	</div>

	<!-- 分享到朋友圈图 -->
	<div class="share_to_off" id="share_to_off">
	</div>

	<!-- 底部信息按钮 -->
    <div class="else">
    	<span id="activity">活动介绍</span>
    	<span id="agency">商家介绍</span>
    	<span id="checkprize">我的奖品</span>
    </div>

    <!-- 活动规则 -->
    <div class="else_show" id="activity_show">
	    <div class="else_intro">
	    	<h3>活动规则</h3>
	    	<div><?php echo (empty($reward['brief'])?'':$reward['brief'])?></div>
	    	<img src="app/reward/view/dial/static/images/off.png" class="else_off" id="activity_off">
	    </div>
    </div>

    <!-- 商家介绍 -->
    <div class="else_show" id="agency_show">
	    <div class="else_intro">
	    	<h3>商家介绍</h3>
	    	<div><?php echo (empty($reward['win_rule']['info'])?'':$reward['win_rule']['info'])?></div>
	    	<img src="app/reward/view/dial/static/images/off.png" class="else_off" id="agency_off">
	    </div>
    </div>

    <!-- 查看我的奖品 -->
    <div class="else_show" id="checkprize_show">
	    <div class="else_intro" id="myprize_intro">
	    	<h3>我的奖品</h3>
	    	<div>
	    		<!-- <?php 
					$html='';
					$current_ip = $_SERVER["REMOTE_ADDR"];
					foreach ($records['list'] as $t) {
						$html.='<a class="getprize_intro" data-uid="'.$t['uid'].'" data-form="'.$t['data'].'"><h4>'.(isset($t['user']['name']) ? $t['user']['name']:$t['user_ip']).'</h4><img src="'.$t['item']['img'].'"></a>';
					}
					echo $html;
				?> -->
	    		<!-- <span class="getprize_intro">
	    			<h4>iphone6</h4>
	    			<img src="app/reward/view/dial/static/images/prize_pic.png">
	    		</span>
	    		<span class="getprize_intro">
	    			<h4>iphone6</h4>
	    			<img src="app/reward/view/dial/static/images/prize_pic.png">
	    		</span>
	    		<span class="getprize_intro">
	    			<h4>iphone6</h4>
	    			<img src="app/reward/view/dial/static/images/prize_pic.png">
	    		</span> -->
	    	</div>
	    	<img src="app/reward/view/dial/static/images/off.png" class="else_off" id="checkprize_off">
	    </div>
    </div>

    <!-- 填写表单 -->
	<div class="else_show" id="form_show">
	 	<div class="info_detail">
	 		<div class="info_info" data-type="<?php echo (empty($reward['win_rule']['type'])?:$reward['win_rule']['type']);?>" >
			    <?php
			        $html='';
			        $i=0;
			        if(!empty($reward['win_rule']['data']) )
			        {
			       		is_array($reward['win_rule']['data']) || $reward['win_rule']['data']=array($reward['win_rule']['data']);
				        foreach ($reward['win_rule']['data'] as $r) {
				          $html.='<div class="input_box'.$i.'"><div>'.$r.'</div><input type="text"/></div>';    
				        }
			        }
			        
			        echo $html;
			    ?>
		    
	   		 </div>
	    <button class="btn_submit">确认提交</button>
	    <button class="btn_submit_no">放弃领奖</button>
	 	</div>
    </div>
    
    <img src="/app/reward/view/dial/static/images/header_c.png" class="header_c">
    <img src="/app/reward/view/dial/static/images/tree.png" class="tree">
    <img src="/app/reward/view/dial/static/images/gift.png" class="gift">

<!--     <div class="giveup">
    	<p>客官，您真的要放弃领奖吗？</p>
    	<button class="giveup_no">返回领奖</button>
	    <button class="giveup_yes">确认放弃</button>
    </div> -->

	<!-- 旋转/中奖/未中奖音效 -->
	<audio style="display:none;opacity:0" hidden="hidden" id="musicBox" preload="metadata" controls src="/app/reward/view/dial/static/images/rotate.mp3">
	</audio>
	<audio style="display:none;opacity:0" hidden="hidden" id="getPrizeMusic" preload="metadata" controls src="/app/reward/view/dial/static/images/getprize.mp3">
	</audio>
	<audio style="display:none;opacity:0" hidden="hidden" id="getPrizeFalseMusic" preload="metadata" controls src="/app/reward/view/dial/static/images/getprize_false.mp3">
	</audio>

<script src="app/reward/view/dial/static/js/jquery2.1.min.js"></script>
<script src="app/reward/view/dial/static/js/awardRotate.js"></script>
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
</script>
</body>
</html>
