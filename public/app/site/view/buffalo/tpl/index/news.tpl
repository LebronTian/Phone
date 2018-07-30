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
  <link rel="stylesheet" href="app/site/view/buffalo/static/css/news.css">
  <link rel="stylesheet" href="app/site/view/buffalo/static/css/index.css">
  <title><?php if(!empty($site['title'])) echo $site['title']; else $site['location']  ?></title>
</head>
<body>
<!-- <?php var_dump($site) ?> -->
<!-- <?php var_dump($parent_cats) ?> -->
<div class="contain">
  <article class="navheader" style="color: #333 !important;">
    <div class="fixwidth">
    <span class="Leftlogo"> <img  src="app/site/view/buffalo/static/images/navlogo.png" class="img_active"></span>
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
  <div class="main_body">
    <div class="lastest_news">
      <h2>
        最新消息
        <span>Lastest news</span>
      </h2>
      <ul class="news_cats">
        <li class="active">Balance新闻</li>
        <li class="notactive">行业新闻</li>
        <li class="notactive">展会信息</li>
      </ul>
      <div class="news_cont" style="display: block;">
        <a href="#" class="news_box">
          <img src="app/site/view/buffalo/static/images/index_3.png">
          <div>
            <h3>深圳优创智投科技有限公司</h3>
            <p>公司核心产品UCToo“互联网+”开源开发平台，以开源、分享、快捷的理念，聚集微信增值应用开发的最佳实践，帮助用户快速实现粉丝管理、移动微电商、微客服、微营销等标准模块化功能...</p>
          </div>
        </a>
        <a href="#" class="news_box">
          <img src="app/site/view/buffalo/static/images/index_4.png">
          <div>
            <h3>深圳优创智投科技有限公司</h3>
            <p>公司核心产品UCToo“互联网+”开源开发平台，以开源、分享、快捷的理念，聚集微信增值应用开发的最佳实践，帮助用户快速实现粉丝管理、移动微电商、微客服、微营销等标准模块化功能...</p>
          </div>
        </a>
        <a href="#" class="news_box">
          <img src="app/site/view/buffalo/static/images/index_3.png">
          <div>
            <h3>深圳优创智投科技有限公司</h3>
            <p>公司核心产品UCToo“互联网+”开源开发平台，以开源、分享、快捷的理念，聚集微信增值应用开发的最佳实践，帮助用户快速实现粉丝管理、移动微电商、微客服、微营销等标准模块化功能...</p>
          </div>
        </a>
      </div>
      <div class="news_cont">
        <a href="#" class="news_box">
          <img src="app/site/view/buffalo/static/images/index_4.png">
          <div>
            <h3>深圳优创智投科技有限公司</h3>
            <p>公司核心产品UCToo“互联网+”开源开发平台，以开源、分享、快捷的理念，聚集微信增值应用开发的最佳实践，帮助用户快速实现粉丝管理、移动微电商、微客服、微营销等标准模块化功能...</p>
          </div>
        </a>
        <a href="#" class="news_box">
          <img src="app/site/view/buffalo/static/images/index_4.png">
          <div>
            <h3>深圳优创智投科技有限公司</h3>
            <p>公司核心产品UCToo“互联网+”开源开发平台，以开源、分享、快捷的理念，聚集微信增值应用开发的最佳实践，帮助用户快速实现粉丝管理、移动微电商、微客服、微营销等标准模块化功能...</p>
          </div>
        </a>
        <a href="#" class="news_box">
          <img src="app/site/view/buffalo/static/images/index_4.png">
          <div>
            <h3>深圳优创智投科技有限公司</h3>
            <p>公司核心产品UCToo“互联网+”开源开发平台，以开源、分享、快捷的理念，聚集微信增值应用开发的最佳实践，帮助用户快速实现粉丝管理、移动微电商、微客服、微营销等标准模块化功能...</p>
          </div>
        </a>
        <a href="#" class="news_box">
          <img src="app/site/view/buffalo/static/images/index_4.png">
          <div>
            <h3>深圳优创智投科技有限公司</h3>
            <p>公司核心产品UCToo“互联网+”开源开发平台，以开源、分享、快捷的理念，聚集微信增值应用开发的最佳实践，帮助用户快速实现粉丝管理、移动微电商、微客服、微营销等标准模块化功能...</p>
          </div>
        </a>
        <a href="#" class="news_box">
          <img src="app/site/view/buffalo/static/images/index_4.png">
          <div>
            <h3>深圳优创智投科技有限公司</h3>
            <p>公司核心产品UCToo“互联网+”开源开发平台，以开源、分享、快捷的理念，聚集微信增值应用开发的最佳实践，帮助用户快速实现粉丝管理、移动微电商、微客服、微营销等标准模块化功能...</p>
          </div>
        </a>
      </div>
      <div class="news_cont">
        <a href="#" class="news_box">
          <img src="app/site/view/buffalo/static/images/index_3.png">
          <div>
            <h3>深圳优创智投科技有限公司</h3>
            <p>公司核心产品UCToo“互联网+”开源开发平台，以开源、分享、快捷的理念，聚集微信增值应用开发的最佳实践，帮助用户快速实现粉丝管理、移动微电商、微客服、微营销等标准模块化功能...</p>
          </div>
        </a>
        <a href="#" class="news_box">
          <img src="app/site/view/buffalo/static/images/index_3.png">
          <div>
            <h3>深圳优创智投科技有限公司</h3>
            <p>公司核心产品UCToo“互联网+”开源开发平台，以开源、分享、快捷的理念，聚集微信增值应用开发的最佳实践，帮助用户快速实现粉丝管理、移动微电商、微客服、微营销等标准模块化功能...</p>
          </div>
        </a>
        <a href="#" class="news_box">
          <img src="app/site/view/buffalo/static/images/index_3.png">
          <div>
            <h3>深圳优创智投科技有限公司</h3>
            <p>公司核心产品UCToo“互联网+”开源开发平台，以开源、分享、快捷的理念，聚集微信增值应用开发的最佳实践，帮助用户快速实现粉丝管理、移动微电商、微客服、微营销等标准模块化功能...</p>
          </div>
        </a>
      </div>
      
    </div>
  </div>
</div>
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
<script type="text/javascript" src="app/site/view/buffalo/static/js/news.js"></script>
<script type="text/javascript" src="app/site/view/buffalo/static/js/index.js"></script>
</body>