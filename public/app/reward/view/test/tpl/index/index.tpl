<?php
  $r_uid=requestInt('r_uid');
?>
<!DOCTYPE html>
<html class="no-js">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no"/>
  <meta name="renderer" content="webkit">
  <meta http-equiv="Cache-Control" content="no-siteapp" />
  <title>活动抽奖</title>
  <link rel="stylesheet" type="text/css" href="/app/reward/view/test/static/css/index.css">
  <?php
    #var_export($records['list']);
  ?>
</head>
<body>
<div class="content" data-ruid="<?php echo $r_uid;?>">
<img class="bg_img" src="/app/reward/view/test/static/images/bg.png">
<div class="logo_box">
	<img src="<?php echo ($reward['img'] ? $reward['img']:'/app/reward/view/test/static/images/logo_small.png');?>">
</div>
<img class="go_img" onclick="getReward()" src="/app/reward/view/test/static/images/go.png">
<img class="rule_img" src="/app/reward/view/test/static/images/rule.png">

<div class="reward_box">
  <?php
    $i=0;
    foreach ($records['list'] as $c) {
      $i++;
    }
    if($i==0)
      echo '<ul class="reward_list">';
    else
      echo '<ul class="reward_list'.$i.'">';
  ?>
	
  <?php 
      $html='';
      foreach ($records['list'] as $c) {
        $html.='<li><span class="'.(isset($c['user']['name']) ? :'user_ip').'">'.(isset($c['user']['name']) ? $c['user']['name']:$c['user_ip']).'</span> 用户获得 '.$c['item']['title'].'</li>';
      }
      echo $html;
  ?>
	</ul>
</div>

</div>

<div class="rule_box">
	<div class="rule_bg"></div>
	<div class="rule_detail">
		<img src="/app/reward/view/test/static/images/rule_bg.png">
		<div class="rule_info">
      <?php echo $reward['brief'];?>
    </div>
	</div>
</div>
<div class="empty_box">
	<div class="empty_bg"></div>
	<div class="empty_detail">
		<img src="/app/reward/view/test/static/images/empty_bg.png">
		<div class="empty_info">
			<img src="/app/reward/view/test/static/images/empty.png">
		</div>
		<button>再摇一次</button>
	</div>
</div>
<div class="share_box">
    <div class="share_bg"></div>
    <div class="share_detail">
    <img src="/app/reward/view/test/static/images/share_bg.png">
  </div>
</div>
<div class="win_box">
	<div class="win_bg"></div>
	<div class="win_detail">
		<img src="/app/reward/view/test/static/images/reward_bg.png">
		<div class="win_info">
			<img src="/app/reward/view/test/static/images/empty.png">
		</div>
		<button>领取福利</button>
		<div class="win_title"></div>
	</div>
</div>

<div class="info_box">
  <div class="info_bg"></div>
  <div class="info_detail">
    <img src="/app/reward/view/test/static/images/info_bg.png">
    <div class="info_info">
    <?php
        $html='';
        $i=0;
        foreach ($reward['win_rule']['data'] as $r) {
          $i++;
        }

        foreach ($reward['win_rule']['data'] as $r) {
          $html.='<div class="input_box'.$i.'"><div>'.$r.'</div><input type="text"/></div>';    
        }
        echo $html;
    ?>
    </div>
    
    <button class="btn_submit">确认提交</button>
    </div>
</div>
<style>
.info_info{
  position: absolute;
  top: 18.7%;
  left: 9%;
  width: 82%;
  height: 56.66%;
  overflow: hidden;
}
</style>

<div class="noreward_box">
  <div class="noreward_bg"></div>
  <div class="noreward_detail">
    <img src="/app/reward/view/test/static/images/noreward.png">
  </div>
</div>



<div class="loading">
	<img src="/app/reward/view/test/static/images/logo.png">
	<div>页面正在加载中</div>
</div>
<audio style="display:none;opacity:0" hidden="hidden" id="musicBox" preload="metadata" controls src="/app/reward/view/test/static/images/1.mp3">
</audio>  

</body>
<script src="/static/js/jquery2.1.min.js"></script>
<script>
var times= 0;
var timer= null;
var timer1= null
var t_img; // 定时器
var isLoad = true; // 控制变量
timer= setInterval(function(){
      times++;
      var point_num=times%3;
      console.log(times);
      if(point_num==0){
      	$('.loading>div').text('页面正在加载中.')
      }
      if(point_num==1){
      	$('.loading>div').text('页面正在加载中..')
      }
      if(point_num==2){
      	$('.loading>div').text('页面正在加载中...')
      }
    },1000);
var i=1;

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

// 判断图片加载状况，加载完成后回调
isImgLoad(function(){
	if(times>=3){
	$('.loading').hide();
    init();
    var b_height=$('.bg_img').height();
    $('.content').css({'height':b_height+'px'});
    clearInterval(timer);
    timer= null;
	}
	else{
		var b_height=$('.bg_img').height();
    		$('.content').css({'height':b_height+'px'});
		timer1= setInterval(function(){
     		if(times==3){
			$('.loading').hide();
    		init();
    		clearInterval(timer);
      		timer= null;
      		clearInterval(timer1);
      		timer1= null;
      		}
    },1000);
			
	}
});
 
// 判断图片加载的函数
function isImgLoad(callback){
    // 注意我的图片类名都是cover，因为我只需要处理cover。其它图片可以不管。
    // 查找所有封面图，迭代处理
    $('img').each(function(){
        // 找到为0就将isLoad设为false，并退出each
        if(this.height === 0){
            isLoad = false;
            return false;
        }
    });
    // 为true，没有发现为0的。加载完毕
    if(isLoad){
        clearTimeout(t_img); // 清除定时器
        // 回调函数
        callback();
    // 为false，因为找到了没有加载完成的图，将调用定时器递归
    }else{
        isLoad = true;
        t_img = setTimeout(function(){
            isImgLoad(callback); // 递归扫描
        },500); // 我这里设置的是500毫秒就扫描一次，可以自己调整
    }
}

$.each($('.user_ip'),function(){
  var str = $(this).text();
  var str1 = str.split (".");
  var str2 = str1[0]+'.***.***.'+str1[3];
  $(this).text(str2);
})






function getReward(){
$('.empty_box').hide();
$('.win_box').hide();
$('.info_box').hide();
$('.rule_box').hide();
$('.noreward_box').hide();
document.getElementById('musicBox').play();
	  $('.loading_box').show();
  $('.open_img').attr('id','open_rotate');
  $('.progress-bar').attr('id','change');
    setTimeout("$('.progress-bar').css({'width':'100%','background-color':'#86e01e'});",2000);    
  var r_uid=$('.content').attr('data-ruid');
  var link='?_a=reward&_u=ajax.doreward&r_uid='+r_uid;
  $.post(link,function(data){
      var reg=$.parseJSON(data);
      console.log(reg.data);
      if(reg.errno==403)
        {
        setTimeout(function(){func()},1000);
        function func(){
        	$('.noreward_box').show();
        }
      }
      else if(reg.errno==0){
        setTimeout(function(){func1()},1000);
        function func1(){
         	if(reg.data=="")
         		$('.empty_box').show();
         	else{
         		$('.win_info>img').attr('src',reg.data.item.img);
         		$('.win_title').text(reg.data.item.title);
         		$('.share_box').show();
            $('.btn_submit').attr('data-id',reg.data.uid);
         	}
        }
      }
      else{
        setTimeout(function(){func2()},1000);
        function func2(){
          alert('抽奖失败');
        }
      }
  });

}

 $('.rule_bg').click(function(){
 	$('.rule_box').hide();
 });
 $('.empty_bg').click(function(){
 	$('.empty_box').hide();
 });
 $('.empty_detail>button').click(function(){
 	$('.empty_box').hide();
 });
 $('.win_bg').click(function(){
 	$('.win_box').hide();
 });
 $('.info_bg').click(function(){
  $('.info_box').hide();
 });
 $('.share_bg').click(function(){
  $('.share_box').hide();
 });
 $('.rule_img').click(function(){
 	$('.rule_box').show();
 });
 $('.win_detail>button').click(function(){
  $('.win_box').hide();
  $('.info_box').show();
 });
 $('.noreward_bg').click(function(){
  $('.noreward_box').hide();
 });
 $('.btn_submit').click(function(){
    var uid=$(this).attr('data-id');
    var info=[];
    $.each($('.info_info input'),function(event){
      if($.trim($(this).val())=='')
      {
        alert('请填写完整的个人资料');
        return false;
        event.stopPropagation();
      }
      info.push($(this).val());
    });
    for(var i in info)
    var reg={uid:uid,data:info}
    $.post('?_a=reward&_u=ajax.set_win_info',reg,function(obj){
      obj=$.parseJSON(obj);
      if(obj.errno==0){
        alert('提交成功，请耐心等待奖品...')
        $('.info_box').hide();
      }
    })
 });
</script>

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
    title: "活动抽奖", // 分享标题
    link: "", // 分享链接
    imgUrl: "", // 分享图标
    success: function () { 
        if($('.win_title').text()!=""){
        $('.share_box').hide();
        $('.win_box').show();
        }
    },
    cancel: function () { 
        // 用户取消分享后执行的回调函数
    }
});
});
}
</script>

</html>
