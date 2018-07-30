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
  <link rel="stylesheet" href="app/site/view/buffalo/static/css/industry.css">
  <title><?php if(!empty($site['title'])) echo $site['title']; else $site['location']  ?></title>
</head>
<body>
<!-- <?php var_dump($site) ?> -->
<!-- <?php var_dump($parent_cats) ?> -->
<div class="contain">
  <?php 
  include $tpl_path.'/header.tpl';
  ?>
  <div class="main_body">
    <div class="meeting">
      <h2>
        展会信息
        <span>Exhibition info</span>
      </h2>
      <a href="#" class="meeting_box" style="margin-left: 0;">
        <div class="meeting_title">深圳优创智投科技有限公司</div>
        <p class="meeting_info">公司致力于为微创新从创意萌芽、产品实现、成长发展提供全面的服务和支持。</p>
        <div class="meeting_icon">
           <img src="app/site/view/buffalo/static/images/product_1.png">
        </div>
        <div class="icon_bg"></div>
      </a>
      <a href="#" class="meeting_box">
        <div class="meeting_title">深圳优创智投科技有限公司</div>
        <p class="meeting_info">公司致力于为微创新从创意萌芽、产品实现、成长发展提供全面的服务和支持。</p>
        <div class="meeting_icon">
           <img src="app/site/view/buffalo/static/images/product_1.png">
        </div>
        <div class="icon_bg"></div>
      </a>
      <a href="#" class="meeting_box">
        <div class="meeting_title">深圳优创智投科技有限公司</div>
        <p class="meeting_info">公司致力于为微创新从创意萌芽、产品实现、成长发展提供全面的服务和支持。</p>
        <div class="meeting_icon">
           <img src="app/site/view/buffalo/static/images/product_1.png">
        </div>
        <div class="icon_bg"></div>
      </a>
      <a href="#" class="meeting_box">
        <div class="meeting_title">深圳优创智投科技有限公司</div>
        <p class="meeting_info">公司致力于为微创新从创意萌芽、产品实现、成长发展提供全面的服务和支持。</p>
        <div class="meeting_icon">
           <img src="app/site/view/buffalo/static/images/product_1.png">
        </div>
        <div class="icon_bg"></div>
      </a>
      <a href="/?_a=site&sp_uid=<?php echo $site['sp_uid'] ?>&_u=index.news" target="_blank" class="meeting_btn">
        MORE
        <i></i>
      </a>
    </div>
    <div class="field_news">
      <h2>
        行业新闻/动态
        <span>Industry news</span>
      </h2>
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
  </div>
</div>

<!-- <script type="text/javascript" src="static/js/jquery2.1.min.js"></script> -->
<!-- <script type="text/javascript" src="app/site/view/buffalo/static/js/industry.js"></script> -->
</body>