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
  <link rel="stylesheet" href="app/site/view/buffalo/static/css/cats.css">
  <link rel="stylesheet" href="app/site/view/buffalo/static/css/iconfont.css">
  <title><?php if(!empty($site['title'])) echo $site['title']; else $site['brief']?></title>
</head>
<body>
<!-- <?php var_dump($parent_cats)?>
<?php var_dump($articles)?> -->
<div class="contain">
<?php 
include $tpl_path.'/header.tpl';
?>

<h2 class="main_title"><?php if(!empty($articles['list'][0]['cat']['title'])) echo $articles['list'][0]['cat']['title']; else echo''?></h2>
<div class="hexagon">
  <?php 
    $html = '';
    $count  = $articles['count']; 
    if($count != 0){       
      for($i=0;$i<$count;$i++){ 
        if( $i%7 == 0){
          $html .='<div class="hexagon_box" style="margin-left: 150px;">
                    <div class="boxF">
                      <div class="boxS">
                        <div class="boxT" style="background-image: url('.$articles['list'][$i]['image'].');background-size: cover;">
                          <div class="overlay">
                              <a href="/?_a=site&sp_uid='.$site['sp_uid'].'&_u=index.article&cid='.$articles['list'][$i]['uid'].'" target="_blank">
                                <i class="overlay_icon iconfont">&#xe607;</i>
                                <span class="overlay_title">'.$articles['list'][$i]['title'].'</span>
                              </a>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>'; 
        }else{
          $html .='<div class="hexagon_box">
                    <div class="boxF">
                      <div class="boxS">
                        <div class="boxT" style="background-image: url('.$articles['list'][$i]['image'].');background-size: cover;">
                          <div class="overlay">
                              <a href="/?_a=site&sp_uid='.$site['sp_uid'].'&_u=index.article&cid='.$articles['list'][$i]['uid'].'" target="_blank">
                                <i class="overlay_icon iconfont">&#xe607;</i>
                                <span class="overlay_title">'.$articles['list'][$i]['title'].'</span>
                              </a>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>'; 
        }
      }
    }else{
      $html .='<div style="width: 1000px;margin: 0 auto;font-size: 16px;color:#333;text-align: center;">内容待补充...</div>';
    }
    echo $html;
  ?>

</div>
<?php 
include $tpl_path.'/contact.tpl';
?>
<?php 
include $tpl_path.'/footer.tpl';
?>
</div>


<script type="text/javascript" src="static/js/jquery2.1.min.js"></script>
<script type="text/javascript" src="app/site/view/buffalo/static/js/cats.js"></script>
</body>