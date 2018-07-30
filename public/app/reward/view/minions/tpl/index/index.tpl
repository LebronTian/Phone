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
<link rel="stylesheet" type="text/css" href="/app/reward/view/minions/static/css/index.css">
</head>
<body>
<div class="content">
<!--<audio autoplay="autoplay" loop="loop" id="media" src="/app/reward/view/minions/static/images/drop.m4a"></audio> -->
<audio autoplay="autoplay" id="media" src="/app/reward/view/minions/static/images/drop.m4a"></audio>
<img class="bg_img" src="/app/reward/view/minions/static/images/index_bg.png">
<img class="minion1" src="/app/reward/view/minions/static/images/minion_icon1.png">
<img class="minion2" src="/app/reward/view/minions/static/images/minion_icon2.png">
<div class="open_box">
	<img class="open" data-ruid="<?php echo $reward['uid'];?>" src="/app/reward/view/minions/static/images/index_open.png">
	<img class="font" src="/app/reward/view/minions/static/images/index_font.png">
</div>
</div>
</body>
<script src="/static/js/jquery2.1.min.js"></script>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script src="/app/reward/view/minions/static/js/index.js"></script>
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
</script>

<!-- 百度统计js -->
<script>
var _hmt = _hmt || [];
(function() {
  var hm = document.createElement("script");
  hm.src = "//hm.baidu.com/hm.js?50beaa18f3a335fcc775b3284b5bd37b";
  var s = document.getElementsByTagName("script")[0]; 
  s.parentNode.insertBefore(hm, s);
})();
</script>

</html>
