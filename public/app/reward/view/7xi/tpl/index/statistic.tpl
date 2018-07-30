<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title></title>
	<link rel="stylesheet" type="text/css" href="<?php echo $static_path; ?>/js/game_base.css">
	<script type="text/javascript" src="<?php echo $static_path; ?>/js/jquery-2.1.0.min.js"></script>
	<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
</head>
<body>

	
	<div class="share_bar">
		<p></p>
	</div>

	<script>
		<?php
	        if($score = requestString('score')) {
	          echo 'var Scores ='.$score.';';
	        }else{
	          echo 'var Scores =0';
	        }
		?>
		var array = ['不哭！今夜我们都是单身汪。我得了'+Scores+'分','秀恩爱死得快，小情侣看我不灭你，我得了'+Scores+'分','练好一阳指，情侣挨个灭，灭情侣我得了'+Scores+'分'];
		var n = Math.ceil((Math.random()*10)%3-1);
		
		if(Scores < 15){   
		        $('.share_bar').find('p').text(array[n]);
		        document.title = array[n];
		    }else if(Scores>=15 && Scores<=20){
		        $('.share_bar').find('p').text(array[n]);
		        document.title = array[n];
		    }else if(Scores > 20){
		        $('.share_bar').find('p').text(array[n]);
		        document.title = array[n];
		    }

		<?php
		  echo 'var wx_cfg = '.json_encode(WeixinMod::get_jsapi_params()).';'; 
		  echo 'var user_name= "'.(AccountMod::get_current_service_user('name') ? '我是 '.AccountMod::get_current_service_user('name') : '').'";';
		if(requestInt('r_uid') == 15) {
			echo 'alert(wx_cfg?"hehe":"haha");';
		} 
		?>
		if(wx_cfg) {
		  //wx_cfg['debug'] = false;
		  wx_cfg['debug'] = <?php echo (requestInt('r_uid') == 15) ? 'true;' : 'false;'; ?>;
		  wx_cfg['jsApiList'] = ['onMenuShareTimeline', 'onMenuShareAppMessage'];
		wx.config(wx_cfg);

		wx.ready(function(){
		    /*var Scores = $('#scores').val();
		    var array = ['不哭！今夜我们都是单身汪。我得了'+Scores+'分','秀恩爱死得快，小情侣看我不灭你，我得了'+Scores+'分','练好一阳指，情侣挨个灭，灭情侣我的了'+Scores+'分'];
		    var n = Math.ceil((Math.random()*10)%3-1);*/
		wx.onMenuShareTimeline({
		    title: '', // 分享标题
		    link: "<?php echo getUrlName().'?_a=reward&r_uid='.$reward['uid']?>", // 分享链接
		    imgUrl: "<?php echo getUrlName();?>/app/reward/view/7xi/static/img/zc.png", // 分享图标
		    success: function () { 
		        // 用户确认分享后执行的回调函数
		    },
		    cancel: function () { 
		        // 用户取消分享后执行的回调函数
		    }
		});
    wx.onMenuShareAppMessage({
        title: '', // 分享标题
        link: "<?php echo getUrlName().'?_a=reward&r_uid='.$reward['uid']?>", // 分享链接
        imgUrl: "<?php echo getUrlName();?>/app/reward/view/7xi/static/img/zc.png", // 分享图标
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
