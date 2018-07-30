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
  html{width: 100%;min-height: 100%}
  body{width:100%;height:100%;background-color:#FFDF01}
  .content{position:relative;}
  .bg_img{width:100%;height:auto;position:absolute;left:0;top:0;z-index:-10}
  .input_box{position:absolute;width: 56%;left: 22%;top:-500px;}
  .input_box>div{position:relative;}
  .input_box>div>div{position:absolute;top:9px;left:10px;font-weight:700;color:white;}
  .input_box>div>input{background-color: #507E98;width: 75%;border-radius:5px;outline:none;font-size: 18px;padding-left: 25%;border: 0}
  .btn_sbm{width:40%;position: absolute;left: 30%;top:-500px;}
  .success{position: absolute;left: 0;top:0;display:none;}
  .success>div{height:50px;background-color:white;opacity:0.9;margin-top:-3px}
  .close{width:30px;position: absolute;right: 20%;top:-500px;}
  .sc_sbm{width: 40%;position:absolute;left: 30%;top:-500px;}
  .success_tip{width: 100%}
  </style>
</head>
<body>
<div class="content">
    <img class="bg_img" src="/app/reward/view/minions/static/images/minion_bg.png">
    <div class="input_box">
      <div><div>姓名</div><input id="name" type="text" /></div>
      <div><div>手机</div><input id="phone" type="text" /></div>
      <div><div>地址</div><input id="address" type="text" /></div>
      <div><div>邮箱</div><input id="email" type="email" /></div>
    </div>
    <img class="btn_sbm" data-uid="<?php echo $record['uid'];?>" data-ruid="<?php echo $r_uid;?>" src="/app/reward/view/minions/static/images/minion_submit.png">
    <div class="success">
      <img class="success_tip" src="/app/reward/view/minions/static/images/minion_success.png">
      <img class="close" src="/app/reward/view/minions/static/images/close_rule.png">
      <img class="sc_sbm"  data-ruid="<?php echo $r_uid;?>" src="/app/reward/view/minions/static/images/minion_submit.png">
      <div></div>
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
    var w_height=$(window).height();
    if(w_height>b_height){
      $('.success>div').css({'height':parseInt(w_height-b_height)+'px'})
    }
    var bili=840/1008;
    var bili2=440/1008;
    var bili3=210/1008;
    var bili4=650/1008;
    var height_bili=57/1008;
    var bottom_bili=30/1008;
    var btn_top=parseInt(b_height*bili);
    var input_height=parseInt(b_height*height_bili);
    var div_top=(input_height-18)/2;
    var marginbt=parseInt(b_height*bottom_bili);
    var box_top=parseInt(b_height*bili2);
    var close_top=parseInt(b_height*bili3);
    var sc_top=parseInt(b_height*bili4);
    $('.btn_sbm').css({'top':btn_top+'px'});
    $('input').css({'height':input_height+'px','line-height':input_height+'px','margin-bottom':marginbt+'px'});
    $('.input_box>div>div').css({'top':div_top+'px'});
    $('.input_box').css({'top':box_top+'px'});
    $('.close').css({'top':close_top+'px'});
    $('.sc_sbm').css({'top':sc_top+'px'});
  }


  $('.shuoming').click(function(){
    $('.detail_box').show();
  });
  $('.sm_close').click(function(){
     $('.detail_box').hide();
  });
  $('.close').click(function(){
    $('.sc_sbm').click();
  });
  $('.sc_sbm').click(function(){
    window.location.href="?_a=reward&_u=index.myreward&r_uid="+$(this).attr('data-ruid');
  });

  $('.btn_sbm').click(function(){
      var name=$('#name').val();
      var phone=$('#phone').val();
      var address=$('#address').val();
      var email=$('#email').val();
      var uid=$(this).attr('data-uid');
      var r_uid=$(this).attr('data-ruid');
      if($.trim(name)==''){
        alert('请输入姓名');
        return;
      }
      if($.trim(phone)==''){
        alert('请输入手机号');return;
      }
      if($.trim(address)==''){
        alert('请输入地址');return;
      }
      if($.trim(email)==''){
        alert('请输入邮箱');return;
      }
      var link="?_a=reward&_u=ajax.set_win_info&uid="+uid;
      var data=[name,phone,address,email];
      data = {data:JSON.stringify(data)};
      $.post(link,data,function(data){
          
          var data=$.parseJSON(data);
          console.log(data);
          if(data.data!=1){
            alert('兑换失败');
            return false;
          }
          else
            $('.success').show();
      });

  });




</script>
</html>
