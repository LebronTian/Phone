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
  <link rel="stylesheet" href="app/site/view/buffalo/static/css/solution.css">
  <link rel="stylesheet" href="app/site/view/buffalo/static/css/hexagon.css">
  <link rel="stylesheet" href="app/site/view/buffalo/static/css/iconfont.css">
  <title><?php if(!empty($site['title'])) echo $site['title']; else $site['location']  ?></title>
</head>
<body>
<article class="navheader" style="color: #333 !important;">
  <div class="fixwidth">
    <span class="Leftlogo"> <img src="app/site/view/buffalo/static/images/navlogo.png" class="img_active"></span>
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
      <p onclick="window.location.href='?_a=site&_u=index.solution&type=solution'">解决方案</p>
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
<!-- <header class="headerTop" style="color: #333 !important;">
  <span class="headerLeft">
    <img style="vertical-align: middle;height: 30px;" src="app/site/view/buffalo/static/images/logomenue.png" alt="">
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
</header> -->
<article class="productShow">
  <section>
     <div class="imgContainer">
       <img src="app/site/view/buffalo/static/images/product1.png" alt="">
       <div class="textcontent">
        <h1>智能环控体系
        <span onclick="window.location.href='?_a=site&_u=index.solution1'">
          详情请点击
        </span>
        </h1> 
       </div>
     </div>
     <div class="imgContainer">
        <img src="app/site/view/buffalo/static/images/product2.png" alt="">
        <div class="textcontent">
        <h1>高压冲洗体系</h1> 
       </div>
     </div>
    <div class="imgContainer">
        <img src="app/site/view/buffalo/static/images/product3.png" alt="">
        <div class="textcontent">
        <h1>智能环控体系</h1> 
       </div>
    </div>
    <div class="imgContainer">
      <img src="app/site/view/buffalo/static/images/product4.png" alt="">
      <div class="textcontent">
        <h1>自动喂养体系</h1> 
       </div>
    </div>
    <div class="imgContainer">
      <img src="app/site/view/buffalo/static/images/product5.png" alt="">
      <div class="textcontent">
        <h1>通风照明体系</h1> 
       </div>
    </div>
    <div class="imgContainer">
      <img src="app/site/view/buffalo/static/images/product6.png" alt="">
      <div class="textcontent">
        <h1>保温加热体系</h1> 
       </div>
    </div>
    <div class="imgContainer">
      <img src="app/site/view/buffalo/static/images/product7.png" alt="">
      <div class="textcontent">
        <h1>粪便清理体系</h1> 
       </div>
    </div>
  </section>
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
<script type="text/javascript" src="app/site/view/buffalo/static/js/cats.js"></script>
<script type="text/javascript" src="app/site/view/buffalo/static/js/index.js"></script>
<script type="text/javascript">
  $(document).ready(function() {
    var type = getUrlParam('type');
    if(type == 'solution') {
      alert('hahah')
    }
  })
  //获取url中的参数  
  function getUrlParam(name) {  
     var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象  
     var r = window.location.search.substr(1).match(reg);  //匹配目标参数  
     if (r != null) return unescape(r[2]); return null; //返回参数值  
  }

</script>
</body>