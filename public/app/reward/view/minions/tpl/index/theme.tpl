<?php 

  if(!($r_uid = requestInt('r_uid')) ||
      !($reward = RewardMod::get_reward_by_uid($r_uid))) {
        //试着取默认商户抽奖
        if(!($reward = RewardMod::get_default_reward_by_sp_uid(AccountMod::require_sp_uid()))) {
          echo '参数错误! r_uid ';
          exit();
        }
    }
?>
<!DOCTYPE html>
<html class="no-js">
<head>
  <meta charset="utf-8">
    <div style="display:none">
    <img src="<?php echo getUrlName();?>/app/reward/view/minions/static/images/share_img.png">
  </div>
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
  <meta name="renderer" content="webkit">
  <meta http-equiv="Cache-Control" content="no-siteapp" />
  <title><?php echo $reward['title'];?></title>
  <style>
      *{margin:0;padding:0}
      .content{position:relative;}
      .bg_img{width:100%}
      .looking{position:absolute;top:90%;width:40%;left:30%}
  </style>
</head>
<body>
<div class="content">
<img class="bg_img" src="/app/reward/view/minions/static/images/theme_bg.png">
<img class="looking" data-urid="<?php echo $r_uid;?>" src="/app/reward/view/minions/static/images/looking.png">
</div>
</div>
</body>
<script src="/static/js/jquery2.1.min.js"></script>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script>


<?php
  echo 'var wx_cfg = '.json_encode(WeixinMod::get_jsapi_params()).';'; 
?>
if(wx_cfg) {
  wx_cfg['debug'] = false;
  wx_cfg['jsApiList'] = ['onMenuShareTimeline'];
wx.config(wx_cfg);

wx.ready(function(){
wx.onMenuShareTimeline({
    title: "寻找小黄人，萌萌哒～珍藏版小黄人全套玩具等你来抢", // 分享标题
    link: "<?php echo getUrlName().'?_a=reward&r_uid='.$reward['uid']?>", // 分享链接
    imgUrl: "<?php echo getUrlName();?>/app/reward/view/minions/static/images/share_img.png", // 分享图标
    success: function () { 
        // 用户确认分享后执行的回调函数
    },
    cancel: function () { 
        // 用户取消分享后执行的回调函数
    }
});
});

}



  window.onload=function(){
    var b_height=$('.bg_img').height();
    $('.content').css({'height':b_height+'px'});
  }

$('.looking').click(function(){
  var r_uid=$(this).attr('data-urid');
    window.location.href="?_a=reward&_u=index.reward&r_uid="+r_uid;
});




</script>
</html>
