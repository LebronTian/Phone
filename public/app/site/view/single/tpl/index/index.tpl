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
  <meta name="keywords" content="<?php echo $site['seo_words']?>">
  <!-- <link rel="stylesheet" href="static/css/reset.css"> -->
  <title><?php echo $site['title']; ?></title>
</head>
<body>

<?php
$a = SiteMod::get_article_by_title('首页', $site['uid']);
	//var_export($site);
if(!$a) {
	echo '请在后台添加首页文章';
}
else {
	echo $a['content'];
}
?>

<script type="text/javascript" src="static/js/jquery2.1.min.js"></script>
</body>


