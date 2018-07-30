<?php 
  $r_uid=requestInt('r_uid');
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
  <link rel="stylesheet" type="text/css" href="/app/reward/view/minions/static/css/active.css">
  <link rel="prefetch" href="?_a=reward&_u=index.reward&r_uid=<?php echo $r_uid;?>" />
  <link rel="prefetch" href="?_a=reward&_u=index.index&r_uid=<?php echo $r_uid;?>" />
  <title><?php echo $reward['title'];?></title>
</head>
<body>
<div class="content">
<img class="bg_img" src="/app/reward/view/minions/static/images/active_bg.png">
<div class="rule_box">
<img class="rule_img" src="/app/reward/view/minions/static/images/rule_detail.jpg">
<img class="close_rule" src="/app/reward/view/minions/static/images/close_rule.png">
</div>
<div class="btn_box">
<img class="reward_active" data-ruid="<?php echo $r_uid;?>" src="/app/reward/view/minions/static/images/reward_active.png">
<img class="my_reward" data-ruid="<?php echo $r_uid;?>" src="/app/reward/view/minions/static/images/my_reward.png">
<img class="reward_rule" src="/app/reward/view/minions/static/images/reward_rule.png">
<img class="theme" data-ruid="<?php echo $r_uid;?>" src="/app/reward/view/minions/static/images/theme.png">
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
    title: "<?php echo $su['name']?>抢到<?php echo @$record['item']['title']?>！每天有2次机会～萌萌哒～珍藏版小黄人全套玩具等你来抢", // 分享标题
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





  $('.close_rule').click(function(){
    $('.rule_box').hide();
  });
  $('.reward_rule').click(function(){
    $('.rule_box').show();
  });
  console.log('1122222');

  window.onload=function(){
    var w_height=$(window).height();
    var b_height=$('.bg_img').height();
    var bili=550/1008;
    var btn_top=parseInt(b_height*bili);
    $('.content').css({'height':b_height+'px'});
    $('.btn_box').css({'top':btn_top+'px'});
    if(w_height>b_height){
      $('.content').css({'height':w_height+'px'});
    }
  }

$('.my_reward').click(function(){
  var r_uid=$(this).attr('data-ruid');
  window.location.href="?_a=reward&_u=index.myreward&r_uid="+r_uid;
});
$('.reward_active').click(function(){
  var r_uid=$(this).attr('data-ruid');
  window.location.href="?_a=reward&_u=index.reward&r_uid="+r_uid;
});
$('.theme').click(function(){
  var r_uid=$(this).attr('data-ruid');
  window.location.href="?_easy=reward.minions.index.theme&r_uid="+r_uid;  

});


</script>
</html>
