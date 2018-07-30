<!DOCTYPE html>
<html>
<head lang="en">
  <meta charset="UTF-8">
  <title>联系我们</title>
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="format-detection" content="telephone=no">
  <meta name="renderer" content="webkit">
  <meta http-equiv="Cache-Control" content="no-siteapp"/>
  <script  src="http://api.map.baidu.com/api?v=2.0&ak=O2TlUoWwlRSpccEMM2Kr5fpZ"></script>
  <link rel="stylesheet" href="/app/site/view/innovalley/static/css/style.css"/>
  <link rel="stylesheet" href="/app/site/view/innovalley/static/css/contact.css"/>
  <link rel="stylesheet" href="/app/site/view/innovalley/static/css/amazeui.min.css"/>
  <style>
  .am-dropdown-content{top:96%;}
  </style>
</head>
<body>
  <div class="top-img">
  <?php 
      if(!empty($site['logo']))
        echo '<div class="logo"><a href="?_a=site&_u=index.index"><img src="'.$site['logo'].'"></a></div>';
      if(!empty($site['qr_code']))
        echo '<div class="erweima"><img src="'.$site['qr_code'].'"></div>';
      else
        echo'<div class="erweima"><img src="?_a=site&_u=index.qrcode&site_uid='.$site['uid'].'"></div>';    
  ?>
  </div>
<header class="am-topbar">
  <div class="am-container">
    <div class="am-topbar-collapse" id="collapse-head">
      <ul class="am-nav am-nav-pills am-topbar-nav">
          <?php 
          $html='';
          foreach ($parent_cats as $p) {
            $option['site_uid'] = $site['uid'];
            $option['cat_uid'] = $p['uid'];
            $option['page'] = requestInt('page');
            $option['limit'] = requestInt('limit', 10);
            $articles = SiteMod::get_site_articles($option);

          $html.='<li class="am-dropdown" data-am-dropdown><a class="am-dropdown-toggle" data-am-dropdown-toggle href="javascript:;">'.$p['title'].'</a><ul class="am-dropdown-content">';

          foreach ($articles['list'] as $a) {
                  $html.='<li><a href="?_a=site&sp_uid='.$site['sp_uid'].'&_u=index.article&cid='.$a['uid'].'">'.$a['title'].'</a></li>';
                }

            $html.='</ul></li>';
          };
          echo $html;
      ?>

        <li><a href="?_a=site&_u=index.contact">联系我们</a></li>
      </ul>
    </div>
  </div>
</header>