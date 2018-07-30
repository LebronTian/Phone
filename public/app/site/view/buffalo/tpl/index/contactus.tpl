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
  <link rel="stylesheet" href="app/site/view/buffalo/static/css/contactus.css">
  <link rel="stylesheet" href="app/site/view/buffalo/static/css/index.css">  
  <title><?php if(!empty($site['title'])) echo $site['title']; else $site['location']  ?></title>
</head>
<body>
<!-- <header class="headerTop">
  <div class="logo-search">
    <img style="width: 35px;" src="app/site/view/buffalo/static/images/logo.png" alt="">
    <span class="corporationName">百韧威斯</span>
    <img src="" alt="">
    <span class="searchtarget">想去哪里？</span>
  </div>
  <div class="headerRight">
    <span class=""><a href="">成为房东</a></span>
    <span><a href="">帮助</a></span>
    <span><a href="">注册</a></span>
    <span><a href="">登陆</a></span>
  </div>
</header>
<nav>
  <ul>
    <li class="active"><a href="">关于</a></li>
    <li><a href="">新闻</a></li>
    <li><a href="">工作机会</a></li>
    <li><a href="">博客</a></li>
  </ul>
</nav> -->
<article class="navheader" style="color: #333 !important;">
  <div class="fixwidth">
        <span class="Leftlogo"><img src="app/site/view/buffalo/static/images/navlogo.png" class="img_active"> </span>
        <section class="iconContainer">
            <div >注册</div>
            <div class=" "> | </div>
            <div class=" ">登录</div>
            <div id="pop" class="menuIcon"  >
              <hr class="first"><hr class="section"><hr class="third">
            </div>
            <div class="menue">menu</div>
        </section>
    </div>
</article>
<article class="popup">
  <section class="popupRight" style="top: 80px;">
    <div class="popMain">
      <h4 onclick="window.location.href='?_a=site&_u=index.index'">首页</h4>
      <p onclick="window.location.href='?_a=site&_u=index.solution'">解决方案</p>
      <p onclick="window.location.href='?_a=site&_u=index.product'">产品中心</p>
      <p onclick="window.location.href='?_a=site&_u=index.cooperation'">我们的合作</p>
      <p onclick="window.location.href='?_a=site&_u=index.news'">行业动态</p>
      <p onclick="window.location.href='?_a=site&_u=index.contactus'">关于我们</p>
    </div>
    <p class="language">
      <span>中</span><span>繁</span><span>EN</span>
    </p> 
  </section>
</article>
<article class="infoMain">
<div class="fixwidth">
  <section class="infoNav">
    <ul>
      <li class="current">关于我们</li>
      <li>创始人</li>
    </ul>
  </section>
  <section class="aboutus">
    <h1>关于我们</h1>
    <p>
      Airbnb成立于2008年8月，总部位于加利福尼亚州旧金山市。Airbnb是一个值得信赖的社区型市场，在这里人们可以通过网站、手机或平板电脑发布、发掘和预订世界各地的独特房源。
    </p>
    <p>
      无论您想在公寓里住一个晚上，或在城堡里呆一个星期，又或在别墅住上一个月，您都能以任何价位享受到Airbnb在全球190个国家的34,000多个城市为您带来的独一无二的住宿体验。Airbnb拥有世界一流的客户服务和日益增长的用户社区，为人们提供了一个最简单有效的途径，让他们可以利用闲置空间赚钱，并将它们展示给成百上千万受众。
    </p>
    <article class="panel">
      <section class="panelr1">
        <div class="rc11">
          <p>房客总数</p>
          <p>6000,00,000多个</p>
        </div>
        <div class="rc12">
          <p>城市</p>
          <p>1325213个</p>
        </div>
      </section>
      <section class="panelr1">
        <div class="rc11">
          <p>房客总数</p>
          <p>60000多个</p>
        </div>
        <div class="rc12">
          <p>城市</p>
          <p>1325213个</p>
        </div>
      </section>
    </article>
  </section>
</div>
</article>
<footer class="footinfo">
  <article>
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
<script type="text/javascript" src="app/site/view/buffalo/static/js/index.js"></script>
</body>