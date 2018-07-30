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
  <link rel="stylesheet" href="app/site/view/buffalo/static/css/product.css">
  <link rel="stylesheet" href="app/site/view/buffalo/static/css/index.css">  
  <title><?php if(!empty($site['title'])) echo $site['title']; else $site['location']  ?></title>
</head>
<body>
<!-- <?php var_dump($site) ?> -->
<!-- <?php var_dump($parent_cats) ?> -->
<div class="contain">
  <!-- <header>
    <span>logo</span>导航
  </header> -->
  <article class="navheader" style="color: #333 !important;">
    <div class="fixwidth">
      <span class="Leftlogo"> <img style="" src="app/site/view/buffalo/static/images/navlogo.png" class="img_active"></span>
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
    <ul class="product_left">
      <li class="  first-level"><span>智能环控体系</span>
        <ul>
            <li class=" "><b></b>环境直控设备 </li>
            <li ><b></b>通风设备</li>
            <li ><b></b>制冷热设备</li>
            <li ><b></b>灯具类</li>
        </ul>
      </li>
      <li class="notactive first-level"><span>高压清洗体系</span>
          <ul>
            <li class=" "><b></b>制冷热设备</li>
          </ul>
      </li>
      <li class="notactive first-level"><span>自动喂养体系</span></li>
      <li class="notactive first-level"><span>通风照明体系</span></li>
      <li class="notactive first-level"><span>保温加热体系</span></li>
      <li class="notactive first-level"><span>粪便清理体系</span></li>
    </ul>
    <div class="galleryproduct">
       <ul class="gallery_cats">
            <li class="gallery_active"><span>All</span></li>
            <li><span>风机</span></li>
            <li><span>湿帘</span></li>
            <li><span>风窗</span></li>
            <li><span>帘布</span></li>
            <li><span>喷雾设备</span></li>
            <li><span>环控料线</span></li>
            <li class="gallery_last_cat"><span>控制机箱</span></li>
       </ul>
    </div>    
    <div class="product_right">
      <div class="product_box" style="display: block;">
        <div class="product_info">
          <img src="app/site/view/buffalo/static/images/product_1.png">
          <span>产品1</span>
          <div class="product_show">
            <span style="background: url(app/site/view/buffalo/static/images/product_1.png) no-repeat;background-size: cover;"></span>
            <h3>产品1</h3>
            <p>这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。</p>
            <a href="#">现场应用</a>
            <a href="#">工厂情况</a>
            <a href="#">询价</a>
          </div>
        </div>
        <div class="product_info">
          <img src="app/site/view/buffalo/static/images/product_2.png">
          <span>产品2</span>
           <div class="product_show">
            <span style="background: url(app/site/view/buffalo/static/images/product_2.png) no-repeat;background-size: cover;"></span>
            <h3>产品2</h3>
            <p>这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。</p>
            <a href="#">现场应用</a>
            <a href="#">工厂情况</a>
            <a href="#">询价</a>
          </div>
        </div>
        <div class="product_info">
          <img src="app/site/view/buffalo/static/images/product_3.png">
          <span>产品3</span>
           <div class="product_show">
            <span style="background: url(app/site/view/buffalo/static/images/product_3.png) no-repeat;background-size: cover;"></span>
            <h3>产品3</h3>
            <p>这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。</p>
            <a href="#">现场应用</a>
            <a href="#">工厂情况</a>
            <a href="#">询价</a>
          </div>
        </div>
        <div class="product_info">
          <img src="app/site/view/buffalo/static/images/product_4.png">
          <span>2011第九届北京国际半导体展览会暨高峰论坛</span>
           <div class="product_show">
            <span style="background: url(app/site/view/buffalo/static/images/product_4.png) no-repeat;background-size: cover;"></span>
            <h3>产品4</h3>
            <p>这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。</p>
            <a href="#">现场应用</a>
            <a href="#">工厂情况</a>
            <a href="#">询价</a>
          </div>
        </div>
        <div class="product_info">
          <img src="app/site/view/buffalo/static/images/product_1.png">
          <span>产品5</span>
           <div class="product_show">
            <span style="background: url(app/site/view/buffalo/static/images/product_1.png) no-repeat;background-size: cover;"></span>
            <h3>产品5</h3>
            <p>这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。</p>
            <a href="#">现场应用</a>
            <a href="#">工厂情况</a>
            <a href="#">询价</a>
          </div>
        </div>
        <div class="product_info">
          <img src="app/site/view/buffalo/static/images/product_2.png">
          <span>产品6</span>
           <div class="product_show">
            <span style="background: url(app/site/view/buffalo/static/images/product_2.png) no-repeat;background-size: cover;"></span>
            <h3>产品6</h3>
            <p>这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。</p>
            <a href="#">现场应用</a>
            <a href="#">工厂情况</a>
            <a href="#">询价</a>
          </div>
        </div>
        <div class="product_info">
          <img src="app/site/view/buffalo/static/images/product_3.png">
          <span>产品7</span>
           <div class="product_show">
            <span style="background: url(app/site/view/buffalo/static/images/product_3.png) no-repeat;background-size: cover;"></span>
            <h3>产品7</h3>
            <p>这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。</p>
            <a href="#">现场应用</a>
            <a href="#">工厂情况</a>
            <a href="#">询价</a>
          </div>
        </div>
        <div class="product_info">
          <img src="app/site/view/buffalo/static/images/product_4.png">
          <span>2011第九届北京国际半导体展览会暨高峰论坛</span>
           <div class="product_show">
            <span style="background: url(app/site/view/buffalo/static/images/product_4.png) no-repeat;background-size: cover;"></span>
            <h3>产品8</h3>
            <p>这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。这里是一段产品介绍。</p>
            <a href="#">现场应用</a>
            <a href="#">工厂情况</a>
            <a href="#">询价</a>
          </div>
        </div>
        <div style="clear: both;"></div>

        <div class="try" name="hotwind">
          
        </div>
        <div style="clear: both;"></div>
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
<script type="text/javascript" src="app/site/view/buffalo/static/js/product.js"></script>
<script type="text/javascript" src="app/site/view/buffalo/static/js/index.js"></script>
</body>