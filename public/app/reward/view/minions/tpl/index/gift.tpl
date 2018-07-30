<?php
  $r_uid=requestInt('r_uid');
  $record_uid=requestInt('record_uid');
?>
<!DOCTYPE html>
<html class="no-js">
<head>
  <div style="display:none">
    <img src="<?php echo getUrlName();?>/app/reward/view/minions/static/images/share_img.png">
  </div>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
  <meta name="renderer" content="webkit">
  <meta http-equiv="Cache-Control" content="no-siteapp" />

  <title><?php echo $reward['title'];?></title>
  <style>
  *{margin:0;padding: 0}
  html{width: 100%;min-height: 100%}
  body{width:100%;height:100%;background-color:#FFDF01}
  .content{position:relative;}
  .share_box{width: 100%;position:absolute;left:0;top:0;z-index:10;display: none}
  .share_box>div{background-color:black;margin-top:-3px;opacity:0.8;height:0;}
  .bg_img{width:100%;height:auto;position:absolute;left:0;top:0;z-index:-10}
  .img_box{width: 40%;position: absolute;left:30%;top:-500px;}
  .gift{width:69%;position: absolute;left: 16%;top:-500px;}
  .reward_go{width: 40%;position: absolute;left: 30%;top:-500px;}
  .share{width: 30%;position: absolute;left: 35%;top:-500px;}
  .looking{  position: absolute;
  width: 40%;
  left: 30%;}
  </style>
</head>
<body>
<div class="content">
<?php 

if($record_uid==""){
    echo '<img class="bg_img" src="/app/reward/view/minions/static/images/empty_bg.png">
    <img class="looking" data-ruid="'.$r_uid.'" src="/app/reward/view/minions/static/images/looking.png">';
    }
else{
  echo '<div class="share_box">
    <img width="100%" style="" src="/app/reward/view/minions/static/images/share_lime.png">
    <div></div>
</div>
    <img class="bg_img" src="/app/reward/view/minions/static/images/gift_bg.png">
    <img class="gift" src="'.$record['item']['img'].'">
    <img class="reward_go" data-ruid="'.$r_uid.'" src="/app/reward/view/minions/static/images/go_reward.png">
    <img class="share" src="/app/reward/view/minions/static/images/share.png">';
}
?>



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
  wx_cfg['jsApiList'] = ['onMenuShareTimeline', 'onMenuShareAppMessage'];

wx.config(wx_cfg);
wx.ready(function(){
wx.onMenuShareTimeline({
    title: "<?php echo $reward['title'];?>", // 分享标题
    link: "<?php echo getUrlName().'?_a=reward&r_uid='.$reward['uid']?>", // 分享链接
    imgUrl: "<?php echo getUrlName();?>/app/reward/view/minions/static/images/share_img.png", // 分享图标
    success: function () { 
        // 用户确认分享后执行的回调函数
    },
    cancel: function () { 
        // 用户取消分享后执行的回调函数
    }
});
wx.onMenuShareAppMessage({
    title: "<?php echo $reward['title'];?>", // 分享标题
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
    var w_height=$(window).height();
    var b_height=$('.bg_img').height();
    if(w_height>b_height){
      $('.share_box').css({'height':w_height+'px'});
      $('.share_box>div').css({'height':parseInt(w_height-b_height)+'px'});
    }
    var bili=840/1008;
    var bili2=320/1008;
    var bili3=758/1008;
    var bili4=900/1008;
    var img_top=parseInt(b_height*bili);
    var gift_top=parseInt(b_height*bili2);
    var reward_top=parseInt(b_height*bili3);
    var share_top=parseInt(b_height*bili4);
    $('.content').css({'height':b_height+'px'});
    $('.looking').css({'top':img_top+'px'});
    $('.gift').css({'top':gift_top+'px'});
    $('.reward_go').css({'top':reward_top+'px'});
    $('.share').css({'top':share_top+'px'});
  }

  $('.share').click(function(){
    $('.share_box').show();
  });
  $('.share_box').click(function(){
    $(this).hide();
  });
  $('.reward_go').click(function(){
    var r_uid=$(this).attr('data-ruid');
    window.location.href="?_a=reward&_u=index.myreward&r_uid="+r_uid;
  });
  $('.looking').click(function(){
    var r_uid=$(this).attr('data-ruid');
    window.location.href="?_a=reward&_u=index.reward&r_uid="+r_uid;
  })
</script>
</html>
