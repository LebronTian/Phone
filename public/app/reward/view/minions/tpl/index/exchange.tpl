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
  *{margin:0;padding: 0}
  html{width: 100%;min-height: 100%}
  body{width:100%;height:100%;background-color:#FFDF01}
  .content{position:relative;}
  .bg_img{width:100%;height:auto;position:absolute;left:0;top:0;z-index:-10}
  .gift{width:40%;position: absolute;left: 30%;top:38%;}
  .shuoming{width:40%;position: absolute;left: 30%;top:65.5%;}
  .btn_submit{width:40%;position: absolute;left: 30%;top:69.5%;}
  .detail_box{width:100%;position: absolute;;display:none}
  .sm_detail{width: 100%}
  .brief_box{position:absolute;left:11%;top:35%;width:78%;height:51%;overflow:auto;}
  .theme{position:absolute;left:30%;width:40%;top:89.5%;}
  .sm_close{position:absolute;right:5%;top:18%;width: 40px}
  </style>
</head>
<body>
<div class="content">
    <img class="bg_img" src="/app/reward/view/minions/static/images/exchange_bg1.png">
    <img class="gift" src="<?php echo $record['item']['img'];?>">
    <img class="shuoming" src="/app/reward/view/minions/static/images/shuoming.png">
    <img class="btn_submit" data-uid="<?php echo $record['uid'] ?>" src="/app/reward/view/minions/static/images/submit.png">
    <div class="detail_box">
    <img class="sm_detail" src="/app/reward/view/minions/static/images/sm_bg.png">
    <img class="sm_close" src="/app/reward/view/minions/static/images/close_rule.png">
    <div class="brief_box"><?php echo $record['item']['brief'];?></div>
    </div>
    <img class="theme" data-ruid="<?php echo $reward['uid'];?>" src="/app/reward/view/minions/static/images/theme.png">
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
wx.onMenuShareAppMessage({
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
    var b_width=$(window).width();
    var b_height=$('.bg_img').height();
    $('.content').css({'height':b_height+'px'});
    $('.detail_box').css({'height':b_height+'px'});
    $('.detail_box').css({'top':0+'px'});
  }


  $('.shuoming').click(function(){
    $('.detail_box').show();
  });
  $('.sm_close').click(function(){
     $('.detail_box').hide();
  });
  $('.theme').click(function(){
  var r_uid=$(this).attr('data-ruid');
  window.location.href="?_easy=reward.minions.index.theme&r_uid="+r_uid;  
});


  $('.btn_submit').click(function(){
      var uid=$(this).attr('data-uid');
      var link='?_a=reward&_u=ajax.do_remark&uid='+uid;
      $.post(link,function(data){
        data=$.parseJSON(data);
        console.log(data);
        if(data.data==1){
          $('.btn_submit').attr('src','/app/reward/view/minions/static/images/exchange_success.png')
        }
      });
  });
</script>
</html>
