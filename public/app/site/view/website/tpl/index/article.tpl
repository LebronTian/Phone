

<!DOCTYPE html>
<html style="height:100%;width:100%">
<head lang="en">
  <meta charset="UTF-8">
  <title><?php echo $article['title']?>_<?php echo $article['cat']['title']?>_<?php echo $site['title'];?></title>
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
  <meta name="viewport"
        content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <meta name="format-detection" content="telephone=no">
  <meta name="renderer" content="webkit">
  <meta http-equiv="Cache-Control" content="no-siteapp"/>
</head>

<body style="margin:0;padding:0;width:100%;height:100%;min-width:1200px;">

<div class="title_box" style="border-bottom:thin solid #DDE2E5;width:100%;height:40px;padding-top:10px;">
<div class="article_header" style="width:1200px;margin:0 auto;height:40px;line-height:40px;">
	<div class="article_title" style="float:left;color:#6C6C6C"><?php echo $article['title']?></div><div class="article_title_en" style="float:left;color:#C5C6C8;margin-left:10px;">COMPANY PROFILE</div>
	<div class="right_header" style="float:right;color:#A5A9AA"><span>您目前的位置：</span><span><?php echo $site['title'];?> > </span><span><?php echo $article['cat']['title']?></span></div>
</div>	
</div>
<div style="position:relative;width:1200px;margin:20px auto;height:auto;min-height:700px;">
	<img src="/app/site/view/eyeispc/static/images/article_bg.png" style="position:absolute;right:0;bottom:0;z-index:-1">
	<div><?php echo $article['content'];?></div>
</div>


</body>
</html>

