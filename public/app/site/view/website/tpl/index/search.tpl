<!DOCTYPE html>
<html>
<head lang="en">
  <meta charset="UTF-8">
  <title>搜索结果_深圳爱视健康产业集团股份有限公司官方网站</title>
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
  <meta name="viewport"
        content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <meta name="format-detection" content="telephone=no">
  <meta name="renderer" content="webkit">
  <meta http-equiv="Cache-Control" content="no-siteapp"/>
  <link rel="stylesheet" href="/app/site/view/website/static/css/style.css"/>
</head>
<body>



<div class="back_top"><a href="#footer_nav"><img src="/app/site/view/website/static/images/top.png"></a></div>




<div class="footer_nav" id="footer_nav">
    <div class="nav_list">
      <ul class="first_ul">
      <?php 
      $i=1;
      $html='';
      if($parent_cats) 
        foreach ($parent_cats as $s) {  
        $html.='<li class="first_li btn_list'.$i.'" data-uid="'.$s['uid'].'">'.$s['title'].'</li>';
        $i++;
      }
      echo $html;
      ?>
      </ul>
      <div class="searchbrief"><input class="search_box" type="text"><div  class="search_pic"><img src="/app/site/view/website/static/images/search.png"></div></div>
      <div class="toggle_box box_hide">
          <div>文字版</div>
          <img src="/app/site/view/website/static/images/bottom.png">
      </div>
    </div>
</div>
<style>
    .result_box{width:1000px;margin:50px auto;}
    .search_list{width:500px;height:400px;}
    .search_list>li{cursor: pointer;}
    .am-pagination{width:500px;}
    .am-pagination>li{width:30px;text-align: center;float: left;}
    .am-active{background-color: #2CBAEA ;color:white;}
</style>
<div class="result_box">

  <div>搜索结果:</div>
  <br>
  <br>

  <?php 
    $html='';

  $html.='<ul class="search_list">';
    foreach ($articles['list'] as $s) {
    $article = SiteMod::get_site_article_by_uid($s['uid']);
    $html.='<li data-src="?_a=site&_u=index.article&cid='.$article['uid'].'" data-uid="'.$article['uid'].'"><div class="small_list"><span>'.date('Y-m-d',$article['create_time']).'</span>'.$article['title'].'</div><div class="large_list"><img src="'.$article['image'].'" style="float:left;"><div class="large_list_title" title="'.$article['title'].'">'.$article['title'].'</div><div class="large_list_brief">'.$article['digest'].'</div></div></li>';
    }
  $html.='</ul>';
  echo $html;

echo $pagination;
  ?>
</div>











</body>
<script src="/app/site/view/website/static/js/jquery2.1.min.js"></script>
<script src="/app/site/view/website/static/js/style.js"></script>
<script>
  $('.search_list li').mouseenter(function(){
  $(this).siblings('li').children('.large_list').hide();
  $(this).siblings('li').children('.small_list').show();
  $(this).children('.large_list').show();
  $(this).children('.small_list').hide();
});
</script>
</html>