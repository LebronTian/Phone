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
  <link rel="stylesheet" href="app/site/view/buffalo/static/css/header.css">
  <title><?php if(!empty($site['title'])) echo $site['title']; else $site['brief']  ?></title>
</head>
<body>
<div class="contain">
<?php 
include $tpl_path.'/header.tpl';
?>

<div class="article">
  <h3 class="article_title"><?php echo $article['title'];?></h3>
  <p class="article_chief"><?php echo $article['digest'];?></p>
  <div class="article_img"><img src="<?php echo $article['image'];?>"></div>
  <div class="article_body"><?php echo $article['content'];?></div>
</div>


<?php 
include $tpl_path.'/footer.tpl';
?>

</div>

<script type="text/javascript" src="../../static/js/jquery2.1.min.js"></script>
<!-- <script type="text/javascript" src="../../static/js/index.js"></script> -->
<script type="text/javascript" src="../../static/js/cats.js"></script>
</body>