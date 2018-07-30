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
    <link rel="stylesheet" href="app/site/view/buffalo/static/css/cooperation.css">
  <link rel="stylesheet" href="app/site/view/buffalo/static/css/hexagon.css">
  <link rel="stylesheet" href="app/site/view/buffalo/static/css/iconfont.css">
  <title><?php if(!empty($site['title'])) echo $site['title']; else $site['location']  ?></title>
</head>
<body>
<!-- <?php var_dump($site) ?> -->
<!-- <?php var_dump($parent_cats) ?> -->
<div class="contain">
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
  <div class="main_body">
     <div class="main_news">
      <h2>
        工程现场
        <span>Gallery</span>
        <i></i>
      </h2>
      <div class="gallery">
        <ul class="gallery_cats">
          <li class="gallery_active"><span>All</span></li>
          <li><span>环境控制</span></li>
          <li><span>高压清洗</span></li>
          <li><span>自动喂养</span></li>
          <li><span>通风照明</span></li>
          <li><span>保温加热</span></li>
          <li class="gallery_last_cat"><span>粪便清理</span></li>
        </ul>
        <div class="gallery_pic_box gallery_pic_box_active">
          <img src="app/site/view/buffalo/static/images/gallery_1.png" class="img_active">
          <img src="app/site/view/buffalo/static/images/gallery_2.png" class="img_active">
          <img src="app/site/view/buffalo/static/images/gallery_3.png" class="img_active">
          <img src="app/site/view/buffalo/static/images/gallery_1.png" class="img_active">
          <img src="app/site/view/buffalo/static/images/gallery_2.png" class="img_active">
          <img src="app/site/view/buffalo/static/images/gallery_3.png" class="img_active">
        </div>
        <div class="gallery_pic_box">
          <img src="app/site/view/buffalo/static/images/gallery_2.png">
          <img src="app/site/view/buffalo/static/images/gallery_3.png">
          <img src="app/site/view/buffalo/static/images/gallery_1.png">
          <img src="app/site/view/buffalo/static/images/gallery_2.png">
          <img src="app/site/view/buffalo/static/images/gallery_3.png">
          <img src="app/site/view/buffalo/static/images/gallery_1.png">
        </div>
        <div class="gallery_pic_box">
          <img src="app/site/view/buffalo/static/images/gallery_3.png">
          <img src="app/site/view/buffalo/static/images/gallery_2.png">
          <img src="app/site/view/buffalo/static/images/gallery_2.png">
          <img src="app/site/view/buffalo/static/images/gallery_3.png">
          <img src="app/site/view/buffalo/static/images/gallery_2.png">
          <img src="app/site/view/buffalo/static/images/gallery_2.png">
        </div>
        <div class="gallery_pic_box">
          <img src="app/site/view/buffalo/static/images/gallery_3.png">
          <img src="app/site/view/buffalo/static/images/gallery_1.png">
          <img src="app/site/view/buffalo/static/images/gallery_2.png">
          <img src="app/site/view/buffalo/static/images/gallery_2.png">
          <img src="app/site/view/buffalo/static/images/gallery_2.png">
          <img src="app/site/view/buffalo/static/images/gallery_2.png">
        </div>
        <div class="gallery_pic_box">
          <img src="app/site/view/buffalo/static/images/gallery_3.png">
          <img src="app/site/view/buffalo/static/images/gallery_2.png">
          <img src="app/site/view/buffalo/static/images/gallery_1.png">
          <img src="app/site/view/buffalo/static/images/gallery_3.png">
          <img src="app/site/view/buffalo/static/images/gallery_2.png">
          <img src="app/site/view/buffalo/static/images/gallery_3.png">
        </div>
        <div class="gallery_pic_box">
          <img src="app/site/view/buffalo/static/images/gallery_1.png">
          <img src="app/site/view/buffalo/static/images/gallery_2.png">
          <img src="app/site/view/buffalo/static/images/gallery_3.png">
          <img src="app/site/view/buffalo/static/images/gallery_3.png">
          <img src="app/site/view/buffalo/static/images/gallery_3.png">
          <img src="app/site/view/buffalo/static/images/gallery_3.png">
        </div>
        <div class="gallery_pic_box">
          <img src="app/site/view/buffalo/static/images/gallery_2.png">
          <img src="app/site/view/buffalo/static/images/gallery_2.png">
          <img src="app/site/view/buffalo/static/images/gallery_2.png">
          <img src="app/site/view/buffalo/static/images/gallery_1.png">
          <img src="app/site/view/buffalo/static/images/gallery_1.png">
          <img src="app/site/view/buffalo/static/images/gallery_1.png">
        </div>
      </div>
      
    </div> 
    <div class="main_news">
      <h2>
        服务对象
        <span>Clients</span>
        <i></i>
      </h2>
      <div class="hexagon">
        <div class="hexagon_box" style="margin-left: 120px;">
          <div class="boxF">
            <div class="boxS">
              <div class="boxT" style="background-image: url(app/site/view/buffalo/static/images/pic_1.jpg);">
                <div class="overlay">
                    <a href="/?_a=site&sp_uid=19&_u=index.article&cid=431" title="点击查看详情" target="_blank">
                      <i class="overlay_icon iconfont">&#xe607;</i>
                      <span class="overlay_title">养猪场</span>
                    </a>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="hexagon_box">
          <div class="boxF">
            <div class="boxS">
              <div class="boxT" style="background-image: url(app/site/view/buffalo/static/images/pic_2.jpg);">
                <div class="overlay">
                    <a href="/?_a=site&sp_uid=19&_u=index.article&cid=431" title="点击查看详情" target="_blank">
                      <i class="overlay_icon iconfont">&#xe607;</i>
                      <span class="overlay_title">养鸡场</span>
                    </a>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="hexagon_box">
          <div class="boxF">
            <div class="boxS">
              <div class="boxT" style="background-image: url(app/site/view/buffalo/static/images/pic_3.jpg);">
                <div class="overlay">
                    <a href="/?_a=site&sp_uid=19&_u=index.article&cid=431" title="点击查看详情" target="_blank">
                      <i class="overlay_icon iconfont">&#xe607;</i>
                      <span class="overlay_title">养牛场</span>
                    </a>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="hexagon_box">
          <div class="boxF">
            <div class="boxS">
              <div class="boxT" style="background-image: url(app/site/view/buffalo/static/images/pic_4.jpg);">
                <div class="overlay">
                    <a href="/?_a=site&sp_uid=19&_u=index.article&cid=431" title="点击查看详情" target="_blank">
                      <i class="overlay_icon iconfont">&#xe607;</i>
                      <span class="overlay_title">养羊场</span>
                    </a>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="hexagon_box">
          <div class="boxF">
            <div class="boxS">
              <div class="boxT" style="background-image: url(app/site/view/buffalo/static/images/pic_5.jpg);">
                <div class="overlay">
                    <a href="/?_a=site&sp_uid=19&_u=index.article&cid=431" title="点击查看详情" target="_blank">
                      <i class="overlay_icon iconfont">&#xe607;</i>
                      <span class="overlay_title">养兔场</span>
                    </a>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="hexagon_box">
          <div class="boxF">
            <div class="boxS">
              <div class="boxT" style="background-image: url(app/site/view/buffalo/static/images/pic_1.jpg);">
                <div class="overlay">
                    <a href="/?_a=site&sp_uid=19&_u=index.article&cid=431" title="点击查看详情" target="_blank">
                      <i class="overlay_icon iconfont">&#xe607;</i>
                      <span class="overlay_title">养鱼场</span>
                    </a>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="hexagon_box">
          <div class="boxF">
            <div class="boxS">
              <div class="boxT" style="background-image: url(app/site/view/buffalo/static/images/pic_2.jpg);">
                <div class="overlay">
                    <a href="/?_a=site&sp_uid=19&_u=index.article&cid=431" title="点击查看详情" target="_blank">
                      <i class="overlay_icon iconfont">&#xe607;</i>
                      <span class="overlay_title">养兔场</span>
                    </a>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="hexagon_box">
          <div class="boxF">
            <div class="boxS">
              <div class="boxT" style="background-image: url(app/site/view/buffalo/static/images/pic_3.jpg);">
                <div class="overlay">
                    <a href="/?_a=site&sp_uid=19&_u=index.article&cid=431" title="点击查看详情" target="_blank">
                      <i class="overlay_icon iconfont">&#xe607;</i>
                      <span class="overlay_title">养猪场</span>
                    </a>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="hexagon_box">
          <div class="boxF">
            <div class="boxS">
              <div class="boxT" style="background-image: url(app/site/view/buffalo/static/images/pic_4.jpg);">
                <div class="overlay">
                    <a href="/?_a=site&sp_uid=19&_u=index.article&cid=431" title="点击查看详情" target="_blank">
                      <i class="overlay_icon iconfont">&#xe607;</i>
                      <span class="overlay_title">养兔场</span>
                    </a>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="hexagon_box" style="margin-left: 120px;">
          <div class="boxF">
            <div class="boxS">
              <div class="boxT" style="background-image: url(app/site/view/buffalo/static/images/pic_5.jpg);">
                <div class="overlay">
                    <a href="/?_a=site&sp_uid=19&_u=index.article&cid=431" title="点击查看详情" target="_blank">
                      <i class="overlay_icon iconfont">&#xe607;</i>
                      <span class="overlay_title">养兔场</span>
                    </a>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="hexagon_box">
          <div class="boxF">
            <div class="boxS">
              <div class="boxT" style="background-image: url(app/site/view/buffalo/static/images/pic_4.jpg);">
                <div class="overlay">
                    <a href="/?_a=site&sp_uid=19&_u=index.article&cid=431" title="点击查看详情" target="_blank">
                      <i class="overlay_icon iconfont">&#xe607;</i>
                      <span class="overlay_title">养兔场</span>
                    </a>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="hexagon_box" >
          <div class="boxF">
            <div class="boxS">
              <div class="boxT" style="background-image: url(app/site/view/buffalo/static/images/pic_5.jpg);">
                <div class="overlay">
                    <a href="/?_a=site&sp_uid=19&_u=index.article&cid=431" title="点击查看详情" target="_blank">
                      <i class="overlay_icon iconfont">&#xe607;</i>
                      <span class="overlay_title">养兔场</span>
                    </a>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="hexagon_box" >
          <div class="boxF">
            <div class="boxS">
              <div class="boxT" style="background-image: url(app/site/view/buffalo/static/images/pic_3.jpg);">
                <div class="overlay">
                    <a href="/?_a=site&sp_uid=19&_u=index.article&cid=431" title="点击查看详情" target="_blank">
                      <i class="overlay_icon iconfont">&#xe607;</i>
                      <span class="overlay_title">养兔场</span>
                    </a>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="hexagon_box" style="margin-left: 220px;" >
          <div class="boxF">
            <div class="boxS">
              <div class="boxT" style="background-image: url(app/site/view/buffalo/static/images/pic_4.jpg);">
                <div class="overlay">
                    <a href="/?_a=site&sp_uid=19&_u=index.article&cid=431" title="点击查看详情" target="_blank">
                      <i class="overlay_icon iconfont">&#xe607;</i>
                      <span class="overlay_title">养兔场</span>
                    </a>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="hexagon_box" >
          <div class="boxF">
            <div class="boxS">
              <div class="boxT" style="background-image: url(app/site/view/buffalo/static/images/pic_2.jpg);">
                <div class="overlay">
                    <a href="/?_a=site&sp_uid=19&_u=index.article&cid=431" title="点击查看详情" target="_blank">
                      <i class="overlay_icon iconfont">&#xe607;</i>
                      <span class="overlay_title">养兔场</span>
                    </a>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="hexagon_box" >
          <div class="boxF">
            <div class="boxS">
              <div class="boxT" style="background-image: url(app/site/view/buffalo/static/images/pic_1.jpg);">
                <div class="overlay">
                    <a href="/?_a=site&sp_uid=19&_u=index.article&cid=431" title="点击查看详情" target="_blank">
                      <i class="overlay_icon iconfont">&#xe607;</i>
                      <span class="overlay_title">养兔场</span>
                    </a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div> 
  </div>
</div>

<div class="pic_gallery">
  <div class="pic_box_wrapper">
    <div class="pic_box">
      <div class="pic_len">
        <img src="app/site/view/buffalo/static/images/gallery_1.png">
      </div>
    </div>
    <div class="pre_icon"></div>
    <div class="next_icon"></div>
    <div class="off_icon"></div>
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
<script type="text/javascript" src="app/site/view/buffalo/static/js/cooperation.js"></script>
<script type="text/javascript" src="app/site/view/buffalo/static/js/index.js"></script>
</body>