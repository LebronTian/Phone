<?php 
include $tpl_path.'/header.tpl';

#var_export($article);
?>

<style>
	.article_box{width:1000px;margin:0px auto; margin-top:30px;}
</style>

<div class="content">
  <div class="article_box">
  	<h1><?php echo $article['title'];?></h1>
  	<p><?php echo $article['content'];?></p>
  </div>
</div>

<footer class="footer">
  <div class="am-container">
    <p><?php if(!empty($site['location'])) echo $site['location']; else echo '深圳市南山区蛇口工业六路9号创新谷'  ?></p>
  </div>
</footer>

<script src="/app/site/view/innovalley/static/js/jquery.min.js"></script>
<script src="/app/site/view/innovalley/static/js/amazeui.min.js"></script>
<script type="text/javascript" src="/app/site/view/innovalley/static/js/style.js"></script>
</body>
</html>