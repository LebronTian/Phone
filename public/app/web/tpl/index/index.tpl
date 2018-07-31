<!doctype html>
<html class="no-js">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>深圳市快马加鞭科技有限公司</title>
  <meta name="description" content="微信公众号订阅号服务号精致设计极速开发">
  <meta name="keywords" content="三级分销 分销商城 微信公众号 定制开发 微信营销">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
  <meta name="renderer" content="webkit">
  <meta http-equiv="Cache-Control" content="no-siteapp" />

  <meta name="apple-mobile-web-app-title" content="Amaze UI" />
  <link rel="shortcut icon" href="/favicon.ico"/>
  <link rel="bookmark" href="/favicon.ico"/>
  <link rel="stylesheet" type="text/css" href="/static/css/amazeui2.1.min.css">
  <link rel="stylesheet" type="text/css" href="/static/css/reset.css">
  <!-- <link rel="stylesheet" type="text/css" href="/app/web/static/css/jquery.fullPage.css"> -->
  <link rel="stylesheet" type="text/css" href="/app/web/static/css/index.css">

</head>
<body style="min-width:1170px">
    <?php
      include $tpl_path.'/header_index.tpl';
    ?>

<!--     <div class="mouse"></div>
    <div class="mouse_t"></div> -->

    <ul id="menu">
        <li data-menuanchor="page1" class="active"><a href="#page1"></a></li>
        <li data-menuanchor="page2"><a href="#page2"></a></li>
        <li data-menuanchor="page3"><a href="#page3"></a></li>
        <li data-menuanchor="page4"><a href="#page4"></a></li>
        <li data-menuanchor="page5"><a href="#page5"></a></li>
        <li data-menuanchor="page6"><a href="#page6"></a></li>
        <!-- <li data-menuanchor="page7"><a href="#page7"></a></li> -->
        <!-- <li data-menuanchor="page8"><a href="#page8"></a></li> -->
    </ul>

    <div id="dowebok">
        <div class="section page1">
            <div class="white_box">分销商城</div>
            <div class="blue_box">
                <h3>自研框架</h3>
                <h3>岂止于强</h3>
                <p>经过大量实际客户</p>
                <p>开发积累出的微信商城系统</p>
            </div>
            <!-- <div class="page1_img">
               <img src="/app/web/static/images/index/page1_1.png">
            </div> -->
        </div>
        <div class="section page2">
            <div class="per_container">
                <div class="per_left">
                    <div class="per_detail detail_1">
                        <img src="/app/web/static/images/index/function.png">
                        <span>功能定制</span>
                    </div>
                    <div class="per_detail detail_2">
                        <img src="/app/web/static/images/index/setting.png">
                        <span>设定定制</span>
                    </div>
                    <div class="per_detail detail_3">
                        <img src="/app/web/static/images/index/port.png">
                        <span>接口定制</span>
                    </div>
                    <div class="per_detail detail_4">
                        <img src="/app/web/static/images/index/personality.png">
                        <span>个性定制</span>
                    </div>
                </div>
                <div class="per_right">
                    <h3>个性定制，极速开发</h3>
                    <p>2周完成一个定制商城</p>
                </div>
            </div>
        </div>
        <div class="section page3">
            <div class="sell_container">
                <div class="sell_left">
                    <img src="/app/web/static/images/index/selling_1.png">
                </div>
                <div class="sell_right">
                    <h3>互动营销，玩出花样</h3>
                    <p>优惠券，会员卡，抽奖深度整合</p>
                </div>
            </div>
        </div>
        <div class="section page4">
            <div class="retail_container">
                <h3>
                    <span class="title">分</span>
                    <span class="title_1">销</span>
                    <span class="title_2">模</span>
                    <span class="title_3">式，</span>
                    <span class="title_1">全</span>
                    <span class="title">网</span>
                    <span class="title_3">售</span>
                    <span class="title_1">货</span>
                <!-- 分销模式，全网售货 -->
                </h3>
                <p>未来商业新趋势，移动微店分销利器，助你打造立体分销网络<br/>把客户、好友和粉丝快速转化为分销商，引爆社交关系链，<br/>形成裂变式发展微店分销商，一店变多店，<br/>最快速度拥有最广泛的社交分销渠道。</p>
            </div>
        </div>
        <div class="section page5">
            <div class="analyze_container">
                <h3>数据分析，提升运营</h3>
                <p>pv uv热销走势一览无遗</p>
            </div>
            <img src="/app/web/static/images/index/page6_1.png" class="analyze_img">
        </div>
        <div class="section page6">
            <div class="protect_container">
                <div class="protect_box">
                    <h3>运维保障，售后无忧</h3>
                    <p>专业团队保障服务器安全稳定</p>
                </div>
            </div>
            <p id="beian">粤ICP备14048871号</p>
        </div>
		<!--
        <div class="section page7">
            <a href="?_a=sp&_u=index.register" class="try_btn">免费试用</a>
            <p id="beian">粤ICP备14048871号</p>
        </div>
		-->
    </div>





<script src="/static/js/jquery2.1.min.js"></script>
<script src="/static/js/amazeui2.1.min.js"></script>
<script type="text/javascript" src="/app/web/static/js/jquery.fullPage.min.js"></script>
<script type="text/javascript" src="/app/web/static/js/header.js"></script>
<!-- <script type="text/javascript" src="/app/web/static/js/index.js"></script> -->
<script>
  $(function(){
    $('#dowebok').fullpage({
      anchors: ['page1', 'page2', 'page3', 'page4','page5', 'page6', 'page7'],
      menu: '#menu',
      afterLoad: function(anchorLink, index){
      if(index == 2){
        $('.detail_1').fadeIn(800);
        $('.detail_2').delay(500).fadeIn(800);
        $('.detail_3').delay(1000).fadeIn(800);
        $('.detail_4').delay(1500).fadeIn(800);
      }
      // if(index == 3){
      //   $('.page3').find('p').delay(500).animate({
      //     bottom: '0'
      //   }, 1500, 'easeOutExpo');
      // }
      if(index == 4){
        $('.title').attr('style','animation: myFlash_1 2s linear;-webkit-animation: myFlash_1 2s linear;');
        $('.title_1').attr('style','animation: myFlash 3s linear -0.5s;-webkit-animation: myFlash 3s linear -0.5s;');
        $('.title_2').attr('style','animation: myFlash 1.5s linear 0.5s;-webkit-animation: myFlash 1.5s linear 0.5s;');
        $('.title_3').attr('style','animation: myFlash_1 1s linear 0.5s;-webkit-animation: myFlash_1 1s linear 0.5s;');
        $('.page4').find('p').fadeIn(3000);
      }
      if(index == 5){
        $('.analyze_img').attr('style','animation: myImg 0.4s linear;-webkit-animation: myImg 0.4s linear; opacity:1;');
      }
    },
    onLeave: function(index, direction){
      if(index == '2'){
        $('.detail_1').fadeOut(1000);
        $('.detail_2').fadeOut(1000);
        $('.detail_3').fadeOut(1000);
        $('.detail_4').fadeOut(1000);
      }
      // if(index == '3'){
      //   $('.page3').find('p').delay(500).animate({
      //     bottom: '-120%'
      //   }, 1500, 'easeOutExpo');
      // }
      if(index == '4'){
        $('.title').attr('style','');
        $('.title_1').attr('style','');
        $('.title_2').attr('style','');
        $('.title_3').attr('style','');
        $('.page4').find('p').fadeOut(1000);
      }
      if(index == 5){
        $('.analyze_img').delay(500).attr('style','opacity:0;');
      }
    }


    });
});
</script>
<script>
var _hmt = _hmt || []; (function() { var hm = document.createElement("script"); hm.src = "https://hm.baidu.com/hm.js?0a71c1ded60c38f42604df66543ff764"; var s = document.getElementsByTagName("script")[0]; s.parentNode.insertBefore(hm, s); })(); </script>

<!--
<script type="text/javascript" src="/static/js/login.js"></script>
<script src="<?php echo $static_path;?>/js/index.js"></script>
-->

</body>
</html>
