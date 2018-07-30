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
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="renderer" content="webkit">
  <meta http-equiv="Cache-Control" content="no-siteapp" />
  <link rel="stylesheet" type="text/css" href="/app/reward/view/minions/static/css/reward.css">
  <title><?php echo $reward['title'];?></title>
</head>
<body>
<div class="content">
<img class="bg_img" src="/app/reward/view/minions/static/images/reward_bg.png">
<img class="minion3" src="/app/reward/view/minions/static/images/minion_icon3.png">
<img data-ruid="<?php echo $r_uid ;?>" onclick="getReward()" class="reward_go" src="/app/reward/view/minions/static/images/roll.png">
<div class="loading_box">
  <img src="/app/reward/view/minions/static/images/loading_bg.png">
  <img class="open_img" src="/app/reward/view/minions/static/images/index_open.png">
  <div class="progress">
      <div class="progress-bar"></div>
    </div>
</div>

<audio style="display:none" id="musicBox" preload="metadata" controls src="/app/reward/view/minions/static/images/1.mp3">
</audio>  
</div>
</body>
<script src="/static/js/jquery2.1.min.js"></script>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script>









  window.onload=function(){
  	init();
    var b_height=$('.bg_img').height();
    $('.content').css({'height':b_height+'px'});
    $('.minion3').attr('id','minion_drop');
 //   $('body').append('<audio autoplay="autoplay" id="media" src="/app/reward/view/minions/static/images/drop.mp3"></audio>');
    setInterval("$('.reward_go').css({'opacity':'1'})",1000);
  }


/*摇一摇*/
  		var SHAKE_THRESHOLD = 3000;  
        var last_update = 0;  
        var x = y = z = last_x = last_y = last_z = 0;  
        function init() {  
            if (window.DeviceMotionEvent) {  
                window.addEventListener('devicemotion', deviceMotionHandler, false);  
            } else {  
                alert('not support mobile event');  
            }  
        }  
        function deviceMotionHandler(eventData) {  
            var acceleration = eventData.accelerationIncludingGravity;  
            var curTime = new Date().getTime();  
            if ((curTime - last_update) > 100) {  
                var diffTime = curTime - last_update;  
                last_update = curTime;  
                x = acceleration.x;  
                y = acceleration.y;  
                z = acceleration.z;  
                var speed = Math.abs(x + y + z - last_x - last_y - last_z) / diffTime * 10000;  
  
                if (speed > SHAKE_THRESHOLD) {  
                    getReward();
                    
                }  
                last_x = x;  
                last_y = y;  
                last_z = z;  
            }  
        }  


function getReward(){
document.getElementById('musicBox').play();
	  $('.loading_box').show();
  $('.open_img').attr('id','open_rotate');
  $('.progress-bar').attr('id','change');
    setTimeout("$('.progress-bar').css({'width':'100%','background-color':'#86e01e'});",2000);    
  var r_uid=$('.reward_go').attr('data-ruid');
  var link='?_a=reward&_u=ajax.doreward&r_uid='+r_uid;
  $.post(link,function(data){
      var reg=$.parseJSON(data);
      console.log(reg.errno);
      if(reg.errno=='403')
        {
          console.log('1');
        setTimeout(function(){func()},3000);
        function func(){
          window.location.href='?_a=reward&_u=index.isreward&r_uid='+r_uid;
        }
      }
      if(reg.errno=="0"){
        console.log(reg.data);
        if(reg.data=="")
        {
        setTimeout(function(){func1()},3000);
        function func1(){
          window.location.href='?_a=reward&_u=index.gift&r_uid='+r_uid+'&record_uid=';
        }
        }
        else{
          setTimeout(function(){func2()},3000);
          function func2(){
          window.location.href='?_a=reward&_u=index.gift&r_uid='+r_uid+'&record_uid='+reg.data.uid;
          }
        }
      }
  });

}

  

</script>
</html>
