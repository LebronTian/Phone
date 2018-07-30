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
  <link rel="stylesheet" href="<?php echo $static_path;?>/css/cats.css">
  <link rel="stylesheet" href="<?php echo $static_path;?>/css/iconfont.css">
  <title><?php if(!empty($site['title'])) echo $site['title']; else $site['brief']?></title>
</head>
<body>
<!-- <?php var_dump($children_cats)?> -->



<?php 
include $tpl_path.'/header_index.tpl';
?>
<h2 class="main_title">更多分类</h2>
<div class="cat_content">
  <div class="cat_list" data-uid="<?php echo $site['sp_uid']?>" data-cid="<?php echo $cat['uid']?>" data-astutas="<?php if($children_cats) echo 0; else echo 1;   ?>" >
  <?php 
    if($children_cats){
      $html = '';
      foreach ($children_cats as $c) {
        $html.='<div class="list_box"><div style=""><a href="/?_a=site&sp_uid='.$site['sp_uid'].'&cid='.$c['uid'].'&_u=index.articlelist">'.$c['title'].'</a></div></div>';
      }
      echo $html;
    }
  ?>
  </div>
</div>
<div class="hexagon">
  <?php 
    $html = '';
    $count  = $articles['count']; 
    if($count != 0){       
      for($i=0;$i<$count;$i++){
        $img_url = $articles['list'][$i]['image'];
        if(empty($img_url)){
          //$img_url = "app/site/view/blog/static/images/article_bg.png";
          $img_url = '';
        }
        if( $i%7 == 0){  
          $html .='<h2 class="main_title" style="margin-bottom: 150px;margin-top: -50px;">精彩文章</h2><div class="hexagon_box" style="margin-left: 150px;">
                    <div class="boxF">
                      <div class="boxS">
                        <div class="boxT" style="background-image: url('.$img_url.');">
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
                        <div class="boxT" style="background-image: url('.$img_url.');">
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
      $html .='';
    }
    echo $html;
  ?>

</div>

<?php 
include $tpl_path.'/footer.tpl';
?>

<script type="text/javascript" src="static/js/jquery2.1.min.js"></script>
<script type="text/javascript" src="<?php echo $static_path;?>/js/cats.js"></script>
</body>
