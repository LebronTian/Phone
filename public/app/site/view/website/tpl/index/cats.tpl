<?php 
include $tpl_path.'/header.tpl';
?>
  <link rel="stylesheet" href="/app/site/view/website/static/css/cat.css"/>
  <link rel="stylesheet" href="/app/site/view/website/static/css/cube.css"/>
<div class="main_content">


<div class="content_box">
  
<?php 
    if($children_cats){
      $n=0;
      foreach ($children_cats as $c) {
        $n++;
      }
      $i=1;
      if($n<=6)
      $html = '<div class="cats_box cat'.$n.'_box" data-type="list">';
      else
      $html = '<div class="cats_box cat6_box" data-type="list">';
      foreach ($children_cats as $c) {
        if($i<=6){
      if(isIEBrowser()){
      $html.='<div class="cat'.$i.'" data-uid="'.$c['uid'].'">';
        if($n<=6)
          $html.='<img class="cat_img'.$n.'" src="'.$c['image'].'">';
        else
          $html.='<img class="cat_img6" src="'.$c['image'].'">';
      $html.='<div class="list_box_style">
            <div class="list_box_header"><span class="list_box_title">'.$c['title'].'</span><span class="list_box_title_en">'.$c['title_en'].'</span></div>
            <div class="list_box_list"><ul></ul></div><div class="list_page_nav" data-id="'.$c['uid'].'" data-pagenum=""><div class="page_first"><<</div><div class="page_last">>></div><div class="page_box"><ul></ul></div></div></div></div>';
      }
      else{
      $html.='<div class="cat'.$i.'" data-uid="'.$c['uid'].'">
          <select id="type" style="display:none">
            <option value="te-cube1">Cube 1</option>
          </select>
    <div id="te-wrapper" class="te-wrapper te-cube1">
          <div class="te-images">
            <div>';
         if($n<=6)
          $html.='<img class="cat_img'.$n.'" src="'.$c['image'].'">';
        else
          $html.='<img class="cat_img6" src="'.$c['image'].'">';
      $html.='</div>
            <div>    <div class="list_box_style">
            <div class="list_box_header"><span class="list_box_title">'.$c['title'].'</span><span class="list_box_title_en">'.$c['title_en'].'</span></div>
            <div class="list_box_list">
              <ul>
              </ul>
        </div>
    <div class="list_page_nav" data-id="'.$c['uid'].'" data-pagenum="">
            <div class="page_first"><<</div>
      <div class="page_last">>></div>
      <div class="page_box">
        <ul>
        </ul>
      </div>
    </div>
    </div></div>
          </div>
          <div class="te-cover">
            <div>';
        if($n<=6)
          $html.='<img class="cat_img'.$n.'" src="'.$c['image'].'">';
        else
          $html.='<img class="cat_img6" src="'.$c['image'].'">';
          $html.='</div>
          </div>
          <div class="te-transition">
            <div class="te-cube-front te-cube-face te-front"></div>
            <div class="te-cube-top te-cube-face te-back"></div>
            <div class="te-cube-bottom te-cube-face te-back"></div>
            <div class="te-cube-right te-cube-face te-back"></div>
            <div class="te-cube-left te-cube-face te-back"></div>
          </div>
    </div>      
    </div>'; 
  }
  $i++;
}
}
      echo $html;
}


else{
      $n=0;
      foreach ($articles['list'] as $a) {
        $n++;
      }
      if($n<=6)
      $html = '<div class="cats_box article'.$n.'_box" data-type="article">';
      else
      $html = '<div class="cats_box article6_box" data-type="article">';
      $i=1;
      if($n<=6){
      foreach ($articles['list'] as $a) {
          $html.='<div class="article'.$i.'" data-id="'.$a['uid'].'"><div><img src="'.$a['image'].'" class="article_img"></div></div>';
          $i++;
        }
      }
      if($n>6){
      foreach ($articles['list'] as $a) {
          if($i<=6){
          $html.='<div class="article'.$i.'"><div><img src="'.$a['image'].'" class="article_img"></div></div>';
          }
          $i++;
        }        
      }
      echo $html;
    }
  ?>
    <button class="close_cat"><img src="/app/site/view/website/static/images/close.png"></button>
  </div>



<div class="brief_bg_box">
   <div class="brief_box">
    <div class="brief_header">
      <div class="brief_title" ><span class="box_title">企业概况</span> <span class="brief_title_en">COMPANY PROFILE</span></div>
      <img class="brief_close" src="/app/site/view/website/static/images/brief_close.png">
      <img class="brief_open" src="/app/site/view/website/static/images/brief_open.png">
    </div>

    <div class="brief_content_box">
      <div class="content_brief">
          
      </div>
    </div>
  </div>
</div>





  <img src="<?php echo $cat['image'];?>" class="cat_bg_img" style="width:1146px;height:570px">
  <div class="bg_index_box">
  <div class="index_large_title">
  <div class="index_brief"><?php echo $cat['brief'];?></div>
  <button class="know_more">了解更多</button>
  </div>
</div>
<div class="erweima_pic">
<img src="/app/site/view/website/static/images/erweima.png" style="margin-top:5px;">
<div>爱视微信公众号</div>
</div>
</div>

<a><img class="btn_pre" src="/app/site/view/website/static/images/l_arrow.png"></a>
<a><img class="btn_next" src="/app/site/view/website/static/images/r_arrow.png"></a>
<a><img class="btn_phone" src="/app/site/view/website/static/images/pink_phone.png"></a>
<a><img class="btn_weixin" src="/app/site/view/website/static/images/pink_weixin.png"></a>
<a><img class="btn_qq" src="/app/site/view/website/static/images/pink_qq.png"></a>
<a><img class="btn_erweima" src="/app/site/view/website/static/images/pink_erweima.png"></a>


<?php 
include $tpl_path.'/footer_nav.tpl';
?>


<div class="slide_box">
  <div class="slide_content_btn">
    <div class="slide_btn_box">

<?php
    $i=1; 
    $html='';
    if($children_cats){
      foreach ($children_cats as $c) {
        if($i==1){
            $html.='<a href="#list'.$i.'" class="btn_isclick">'.$c['title'].'</a>';
        }
        else{
            $html.='<a href="#list'.$i.'">'.$c['title'].'</a>';
        }
        $i++;
      }
    }
    else{
      foreach ($articles['list'] as $a) {
        if($i==1){
            $html.='<a href="#article'.$i.'" class="btn_isclick">'.$a['title'].'</a>';
        }
        else{
            $html.='<a href="#article'.$i.'">'.$a['title'].'</a>';
        }
        $i++;
      }
    }
    echo $html;
  ?>
    </div>
  </div>
  <div class="detail_box">
    <ul class="brief_list">
 <?php 
  $html="";
  $i=1;
  if($children_cats){
foreach ($children_cats as $c) {
    $option['site_uid'] = $site['uid'];
    $option['cat_uid'] = $c['uid'];
    $option['page'] = requestInt('page');
    $option['limit'] = requestInt('limit', 10);
    $sc_articles = SiteMod::get_site_articles($option);

    $html.='<li id="list'.$i.'" class="list"  data-uid="'.$c['uid'].'">';

    $html.='<img class="classify_small_pic" src="'.$c['image_icon'].'"><div class="detail_brief_box"><div class="detail_title">'.$c['title'].'</div><div class="detail_title_en">COMPANY PROFILE</div><div class="detail_list"><ul>';
    foreach ($sc_articles['list'] as $s){
    $sc_article = SiteMod::get_site_article_by_uid($s['uid']);
    $html.='<li data-src="?_a=site&_u=index.article&cid='.$sc_article['uid'].'" data-uid="'.$sc_article['uid'].'"><div class="small_list"><span>['.date('Y-m-d',$sc_article['create_time']).']</span>'.$sc_article['title'].'</div><div class="large_list"><img src="'.$sc_article['image'].'" style="float:left;"><div class="large_list_title" title="'.$sc_article['title'].'">'.$sc_article['title'].'</div><div class="large_list_brief">'.$sc_article['digest'].'</div></div></li>';
    }
  $html.='</ul></div></div></li>';
  $i++;
}
}
else{
  foreach ($articles['list'] as $a) {
  $article = SiteMod::get_site_article_by_uid($a['uid']);
    $html.='<li id="article'.$i.'" class="article" data-uid="'.$a['uid'].'"><img class="classify_small_pic" src="'.$article['image'].'"><div class="detail_brief_box"><div class="detail_title">'.$article['title'].'</div><div class="detail_title_en">COMPANY PROFILE</div><div class="detail_brief">'.$article['content'].'</div></div></li>';
  $i++;
}
}
    echo $html;
?>



    </ul>
  </div>
</div>







<?php 
include $tpl_path.'/footer.tpl';
?>


<script src="/app/site/view/website/static/js/jquery.transitions.js"></script>
<script src="/app/site/view/website/static/js/modernizr.js"></script>
<script src="/app/site/view/website/static/js/cats.js"></script>