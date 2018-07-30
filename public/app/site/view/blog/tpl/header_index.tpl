<div class="top">
      <div class="name">
        <a href="/?_a=site&sp_uid=<?php echo $site['sp_uid'] ?>&_u=index"><?php if(!empty($site['title'])) echo $site['title']; else $site['location']  ?></a>
      </div>
      <input type="text" class="search_box key" placeholder="请输入您要搜索的关键词" >
      <button class="search_btn key_btn" id="search_btn">搜索</button>
</div>

<div class="header" id="header">


<!-- <?php var_dump($children_cats)?>
<?php var_dump($parent_cats)?>
<?php var_dump($articles)?> -->
  
  <ul class="nav_left">
    <?php 
      $html = '';
      if(!empty($parent_cats)){
        $count  = count($parent_cats);  
        for($i=0;$i<($count-1)/2;$i++){ 
            $html .= '<li><a href="/?_a=site&sp_uid='.$site['sp_uid'].'&_u=index.cats&cid='.$parent_cats[$i]['uid'].'" class="nav_a">'.$parent_cats[$i]['title'].'</a></li>';
        }
      }
      echo $html;
    ?>
  </ul>
  <div class="logo_box">  
    <a href="/?_a=site&sp_uid=<?php echo $site['sp_uid'] ?>&_u=index"><img src="<?php if(!empty($site['logo'])) echo $site['logo']; else echo'公司logo'?>" class="header_logo"></a>
  </div>
  <ul class="nav_right">
    <?php 
      $html_right = '';
      if(!empty($parent_cats)){
        $count  = count($parent_cats); 
        for($i=floor($count/2);$i<$count;$i++){ 
          $html_right .= '<li><a href="/?_a=site&sp_uid='.$site['sp_uid'].'&_u=index.cats&cid='.$parent_cats[$i]['uid'].'" class="nav_a">'.$parent_cats[$i]['title'].'</a></li>';
        }
      }
      echo $html_right;
    ?>
  </ul>


  
</div>

<script type="text/javascript" src="static/js/jquery2.1.min.js"></script>
<script type="text/javascript" src="app/site/view/blog/static/js/header.js"></script>



<script language="javascript">
 $('.key_btn').click(function(){
   search();
 })
  function search () {  
    var key = $('.key').val(); 
    var link="/?_a=site&sp_uid=<?php echo $site['sp_uid'] ?>&_u=index&key="+key;
   //下面以百度网内搜索为例 
   window.open(link); } 
 </script>
