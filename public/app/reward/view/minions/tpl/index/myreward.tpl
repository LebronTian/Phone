
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
  <title><?php echo $reward['title'];?></title>
  <style>
  *{margin:0;padding: 0}
  ul,li{list-style:none}
  html{width: 100%;min-height: 100%}
  body{width:100%;height:100%;background-color:#FFDF01}
  .content{position:relative;}
  .bg_img{width:100%;height:auto;position:absolute;left:0;top:0;z-index:-10}
  .reward_box{width:50%;top:-500px;position: absolute;left: 25%;overflow:hidden;}
  .reward_box>ul{width:5000px;position:absolute;left:0px}
  .reward_box>ul>li{float:left;}
  .pre{position: absolute;left:17%;width: 30px}
  .next{position: absolute;right:17%;width: 30px}
  .num_box{position: absolute;right:0;width: 100%;text-align:center;}
  .btn_exchange{position:absolute;width: 40%;left: 30%;display:none}
  .minion_exchange{position:absolute;width: 40%;left: 30%;display:none}
  .tip_box{position:absolute;width: 50%;left: 25%;display:none}
  .looking{position:absolute;width: 40%;left: 30%;}
  </style>
</head>
<body>
<div class="content">
<?php 
    if($records['count']==0){
    echo '<img class="bg_img" src="/app/reward/view/minions/static/images/empty_bg.png">
    <img class="looking" data-ruid="'.$r_uid.'" src="/app/reward/view/minions/static/images/looking.png">';
    }
    else{
      echo '<img class="bg_img" src="/app/reward/view/minions/static/images/myreward_bg.png">
    <img class="pre" src="/app/reward/view/minions/static/images/left_arrow.png">
    <img class="next" src="/app/reward/view/minions/static/images/right_arrow.png">
    <div class="num_box"><span class="now_page">1</span><span>/</span><span class="total_page">'.$records['count'].'</span></div><div class="reward_box">
      <ul>';
      $html='';
          $i=1;
          foreach ($records['list'] as $r) {
            $html.='<li width="100%"><img data-title="'.$r['item']['title'].'" class="img'.$i.'" data-uid="'.$r['uid'].'" src="'.$r['item']['img'].'"></li>';
            $i++;
          }
      echo $html;
      echo '</ul></div><img class="btn_exchange" data-ruid="'.$r_uid.'" src="/app/reward/view/minions/static/images/btn_exchange.png"><img class="minion_exchange" data-ruid="'.$r_uid.'" src="/app/reward/view/minions/static/images/dengji.png"><img class="tip_box" id="limit1" src="/app/reward/view/minions/static/images/timelimit.png"></img><img class="tip_box" id="limit2" src="/app/reward/view/minions/static/images/timelimit2.png"></img>';
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

$(document).ready(function(){
    var title=$('.img1').attr('data-title');
    if(title.indexOf("玩具")>=0){
        $('.minion_exchange').show();
    }
    else if(title.indexOf("冰激凌")>=0){
        $('#limit1').show();
        $('.btn_exchange').show();
    }
    else{
        $('#limit2').show();
        $('.btn_exchange').show();
    }
});



  window.onload=function(){
    var b_height=$('.bg_img').height();
    $('.content').css({'height':b_height+'px'});
    var bili=342/1008;
    var bili2=480/1008;
    var bili3=840/1008;
    var bili4=310/1008;
    var bili5=690/1008;
    var box_height=parseInt(b_height*bili);
    var btn_top=parseInt(b_height*bili2);
    var exchange_top=parseInt(b_height*bili3);
    var num_top=parseInt(b_height*bili4);
    var minion_top=parseInt(b_height*bili5);
    $('.reward_box').css({'top':box_height+'px'});
    $('.pre').css({'top':btn_top+'px'});
    $('.next').css({'top':btn_top+'px'});
    $('.btn_exchange').css({'top':exchange_top+'px'});
    $('.num_box').css({'top':num_top+'px'});
    $('.looking').css({'top':exchange_top+'px'});
    $('.minion_exchange').css({'top':minion_top+'px'});
    $('.tip_box').css({'top':minion_top+'px'});
    $('.reward_box').css({'height':$('.reward_box').width()+'px'});
    $('.reward_box>ul>li').css({'width':$('.reward_box').width()+'px'});
    $('.reward_box>ul>li>img').css({'width':$('.reward_box').width()+'px'});
  }

$('.pre').click(function(){
    if($('.total_page').text()=="1"){
      return false;
    }
    else if($('.now_page').text()=="1")
      return false;
    else{
      var now_num=parseInt($('.now_page').text())-1;
      $('.now_page').text(now_num);
      var left=parseInt($('.reward_box>ul').css('left'))+$('.reward_box').width();;
      $('.reward_box>ul').css({'left':left+'px'});
      var title=$('.img'+now_num).attr('data-title');
      if(title.indexOf("玩具")>=0){
        $('#limit1').hide();
        $('#limit2').hide();
        $('.btn_exchange').hide();
        $('.minion_exchange').show();
      }
      else if(title.indexOf("冰激凌")>=0){
        $('.minion_exchange').hide();
        $('#limit2').hide();
        $('.btn_exchange').show();
        $('#limit1').show();
      }
      else{
        $('#limit1').hide();
        $('.minion_exchange').hide();
        $('#limit2').show();
        $('.btn_exchange').show();
      }
    }
});

$('.next').click(function(){
  if($('.total_page').text()=="1")
    return false;
  else if($('.total_page').text()==$('.now_page').text())
    return false;
  else{
      var now_num=parseInt($('.now_page').text())+1;
      $('.now_page').text(now_num);
    var left=parseInt($('.reward_box>ul').css('left'))-$('.reward_box').width();
  var title=$('.img'+now_num).attr('data-title');    
   $('.reward_box>ul').css({'left':left+'px'});
      if(title.indexOf("玩具")>=0){
        $('#limit1').hide();
        $('#limit2').hide();
        $('.btn_exchange').hide();
        $('.minion_exchange').show();
      }
      else if(title.indexOf("冰激凌")>=0){
        $('.minion_exchange').hide();
        $('#limit2').hide();
        $('.btn_exchange').show();
        $('#limit1').show();
      }
      else{
        $('#limit1').hide();
        $('.minion_exchange').hide();
        $('#limit2').show();
        $('.btn_exchange').show();
      }
  }
});

$('.minion_exchange').click(function(){
  var img_num=$('.now_page').text();
  var title=$('.img'+img_num).attr('data-title');
  var uid=$('.img'+img_num).attr('data-uid');
  var r_uid=$(this).attr('data-ruid');

    window.location.href="?_a=reward&_u=index.minion&uid="+uid+"&r_uid="+r_uid;
});

$('.btn_exchange').click(function(){
  var img_num=$('.now_page').text();
  var title=$('.img'+img_num).attr('data-title');
  var uid=$('.img'+img_num).attr('data-uid');
  var r_uid=$(this).attr('data-ruid');
  window.location.href="?_a=reward&_u=index.exchange&uid="+uid+"&r_uid="+r_uid;
});

$('.looking').click(function(){
  var r_uid=$(this).attr('data-ruid');
  window.location.href="?_a=reward&_u=index.reward&r_uid="+r_uid;
});


</script>
</html>
