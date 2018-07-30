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
  <link rel="stylesheet" href="static/css/reset.css">
  <link rel="stylesheet" href="<?php echo $static_path;?>/css/header.css">
  <link rel="stylesheet" href="<?php echo $static_path;?>/css/index.css">
  <title><?php if(!empty($site['title'])) echo $site['title']; else $site['location']  ?></title>
</head>
<body>

<?php 
include $tpl_path.'/header_index.tpl';
?>
<h2 class="main_title">最新文章</h2>
<div class="new_articles">
   <ul>
      <?php
        $html = '';
        $count  = $articles['count'];
        if($count>7){
          $count = 7;
        };
        for($i=0;$i<$count;$i++){
          $html .= '<li><a href="/?_a=site&sp_uid='.$site['sp_uid'].'&_u=index.article&cid='.$articles['list'][$i]['uid'].'" target="_blank">'.$articles['list'][$i]['title'].'</a><span class="create_time">'.$articles['list'][$i]['create_time'].'<span></li>';
        }
        echo $html;
      ?>
   </ul>
</div>
 
</div>

<?php 
include $tpl_path.'/footer.tpl';
?>
<script type="text/javascript" src="static/js/jquery2.1.min.js"></script>
<script>
 $(function(){
  function getLocalTime(nS) {
    var test = new Date(parseInt(nS)*1000);  
      var $_year = test.getFullYear();  
      var $_month = parseInt(test.getMonth())+1;  
      var $_day = test.getDate();
      var $_f_date =  "["+$_year +"-"+$_month+"-"+$_day+"]";
      return $_f_date;
  }
  var time_num = $('.create_time').length;
  for (var i=0; i<time_num ; i++){
    var pre_time = $('.create_time').eq(i).text();
    console.log(pre_time);
    var new_time = getLocalTime(pre_time);
    $('.create_time').eq(i).text(new_time);
  };
  });
  
  

  
</script>
</body>