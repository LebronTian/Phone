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
  <meta name="keywords" content="<?php echo $site['seo_words']?>">
  <meta http-equiv="Cache-Control" content="no-siteapp">
  <link rel="stylesheet" href="<?php echo $static_path; ?>/css/header.css">
  <title><?php if(!empty($site['title'])) echo $site['title']; else $site['brief']  ?></title>
</head>
<!-- <?php var_dump($article) ?> -->
<body>
<?php 
include $tpl_path.'/header_index.tpl';
?>

<div class="article" data-cats="<?php echo $article['cat']['title'];?>">
  <h3 class="article_title"><?php echo $article['title'];?></h3>
  <p class="article_chief"><?php echo $article['digest'];?></p>
  <div class="article_img"><img src="<?php echo $article['image'];?>"></div>
  <div class="article_body"><?php echo $article['content'];?></div>
</div>


<?php 
include $tpl_path.'/footer.tpl';
?>

<script type="text/javascript" src="static/js/jquery2.1.min.js"></script>
<script type="text/javascript">
  $(function(){
    var cat_title = $('.article').attr('data-cats');
    var nav_num = $('.nav_a').length;
    for(var i = 0; i<nav_num; i++){
      var nav_text = $('.nav_a').eq(i).text();
      if (nav_text == cat_title) {
          $('.nav_a').eq(i).removeClass('nav_a').addClass('a_active'); 
      }
    }
    
  })
</script>
</body>
