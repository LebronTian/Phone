<!DOCTYPE html>
<html>
<head lang="en">
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="renderer" content="ie-comp">
  <meta name="viewport"
        content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <meta name="format-detection" content="telephone=no">
  <meta name="renderer" content="webkit">
  <meta http-equiv="Cache-Control" content="no-siteapp">  
  <link rel="stylesheet" href="static/css/reset.css">
  <link rel="stylesheet" href="app/site/view/buffalo/static/css/header.css">
  <link rel="stylesheet" href="app/site/view/buffalo/static/css/index.css">
  <link rel="stylesheet" href="app/site/view/buffalo/static/css/hexagon.css">
  <link rel="stylesheet" href="app/site/view/buffalo/static/css/iconfont.css">
  <title><?php if(!empty($site['title'])) echo $site['title']; else $site['location']?></title>
</head>
<body>
<div class="animationheader head">  
     <div class="headerContainer">
            <div class="to-top"></div>
            <div class="to-bottom"></div>
            <div class="to-left">   </div>
            <div class="to-right" ></div>
    <!--         <div class="fullimgcontainer"> -->
            <img class="full-screen" src="app/site/view/buffalo/static/images/banner_1.png" alt="">
            <!-- </div> -->
     </div>
</div>
<article class="headerTop">
  <span class="headerLeft"><img style="height: 29px;" src="app/site/view/buffalo/static/images/logoIndex.png" alt=""></span>
  <section style="overflow: hidden;"  class="menueContainer">
      <div class="login">注册</div>
      <div class="login"> | </div>
      <div class="login">登录</div>
      <div id="pop" class="headerRight"  >
        <hr class="first"><hr class="section"><hr class="third">

      </div>
      <div class="menue">menu</div>
      
  </section>
</article>
<!-- <article class="headerTop">
  <span class="headerLeft">
    <img style="vertical-align: middle;height: 30px;" src="app/site/view/buffalo/static/images/logo_small.png" alt="">
  深圳优创智投有限公司</span>
  <section class="headerRight">
      <div class="login">登录</div>
      <div > | </div>
      <div class="login">注册</div>
      <div id="pop"class='menuMark'>
        <hr><hr><hr>
      </div>
      <div class="menue">menu</div>
  </section>
</article> -->
<article class="popup">
  <section class="popupRight">
    <div class="popMain">
      <h4 onclick="window.location.href='?_a=site&_u=index.index'" class="menupoint">首页<img style="vertical-align: middle;margin-left: 5px;" src="app/site/view/buffalo/static/images/point.png" alt=""></h4>
      <p onclick="window.location.href='?_a=site&_u=index.solution'">解决方案</p>
      <p onclick="window.location.href='?_a=site&_u=index.product'">产品中心</p>
      <p onclick="window.location.href='?_a=site&_u=index.cooperation'">服务对象</p>
      <p onclick="window.location.href='?_a=site&_u=index.news'">行业动态</p>
      <p onclick="window.location.href='?_a=site&_u=index.contactus'">关于我们</p>
    </div>
    <p class="language">
      <span>中</span><span>繁</span><span>EN</span>
    </p> 
  </section>
</article>
<article class="slogan">
  <h1>让动物有个安全的家</h1>
  <p>畜牧饲养周边设备专业进出口集成商</p>
</article>
<article class="comprehend">
  <h3>更直接了解我们</h3> 
  <p>更专业产品与最新资讯</p>
  <section style="margin-bottom: 20px;">
    <img onclick="window.location.href='?_a=site&_u=index.article'" src="app/site/view/buffalo/static/images/gallery4.png" alt="">
    <img onclick="window.location.href='?_a=site&_u=index.article'" src="app/site/view/buffalo/static/images/gallery5.png" alt="">
    <img onclick="window.location.href='?_a=site&_u=index.article'" src="app/site/view/buffalo/static/images/gallery6.png" alt="">
  </section>
  
  <div>
    查看所有产品
  </div>
</article>

<footer class="footinfo">
  <article>
    <div class="textContaint">
      <section class="infoLeft">
          <div class="languge">中文（简体）</div>
          <div class="languge langlast">CNY</div>
          <p>客服电话</p>
          <p>国内：400-890-0309</p>
          <p>海外：+86-1348-83492</p>
      </section>
      <section class="infoItemTotal">
        <div class="info-item">
          <h4 class="itemtitle">公司信息</h4>
          <ul class="itemlist">
            <li><a href="/about/about-us">关于</a></li>
            <li><a href="/careers" >工作机会</a></li>
            <li><a href="/press/news" >新闻</a></li>
            <li><a href="http://blog.airbnb.com" >博客</a></li>
            <li><a href="/help" class="link-contrast">帮助</a></li>
            <li><a href="/policies" class="link-contrast">政策</a></li>
            <li><a href="/disaster-response" class="link-contrast">灾难响应</a></li>
            <li><a href="/terms" class="link-contrast">条款与隐私</a></li>
          </ul>
        </div>
        <div class="info-item">
          <h4 class="itemtitle">公司信息</h4>
          <ul class="itemlist">
            <li><a href="/about/about-us">关于</a></li>
            <li><a href="/careers" >工作机会</a></li>
            <li><a href="/press/news" >新闻</a></li>
            <li><a href="http://blog.airbnb.com" >博客</a></li>
            <li><a href="/help" class="link-contrast">帮助</a></li>
            <li><a href="/policies" class="link-contrast">政策</a></li>
            <li><a href="/disaster-response" class="link-contrast">灾难响应</a></li>
            <li><a href="/terms" class="link-contrast">条款与隐私</a></li>
          </ul>
        </div>
        <div class="info-item">
          <h4 class="itemtitle">公司信息</h4>
          <ul class="itemlist">
            <li><a href="/about/about-us">关于</a></li>
            <li><a href="/careers" >工作机会</a></li>
            <li><a href="/press/news" >新闻</a></li>
            <li><a href="http://blog.airbnb.com" >博客</a></li>
            <li><a href="/help" class="link-contrast">帮助</a></li>
            <li><a href="/policies" class="link-contrast">政策</a></li>
            <li><a href="/disaster-response" class="link-contrast">灾难响应</a></li>
            <li><a href="/terms" class="link-contrast">条款与隐私</a></li>
          </ul>
        </div>
        
      </section>
    </div>
  </article>
  <div class="contactUs">
    <p>关注我们</p>
    <div class="sociation">
        <span> <img src="app/site/view/buffalo/static/images/tencentWeibo.png" alt=""></span>
        <span class="clipse">|</span>
        <span> <img src="app/site/view/buffalo/static/images/QQ.png" alt=""></span>
        <span class="clipse">|</span>
        <span> <img src="app/site/view/buffalo/static/images/sinnaweibo.png" alt=""></span>
        <span class="clipse">|</span>
        <span> <img src="app/site/view/buffalo/static/images/weixin.png" alt=""></span>
      </div>
  </div>
</footer>
<script type="text/javascript" src="static/js/jquery2.1.min.js"></script>
<script type="text/javascript" src="app/site/view/buffalo/static/js/cats.js"></script>
<script type="text/javascript" src="app/site/view/buffalo/static/js/index.js"></script>
 
</body>