<div class="header" id="header">
  <!-- <ul class="nav_left">
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
  </ul> -->
  <div class="header" id="header">
    <ul class="nav_left">
      <li><a href="/?_a=site&sp_uid=<?php echo $site['sp_uid'] ?>&_u=index" class="nav_a">首页</a></li>
      <li><a href="/?_a=site&sp_uid=<?php echo $site['sp_uid'] ?>&_u=index.solution" class="nav_a">解决方案</a></li>
      <li><a href="/?_a=site&sp_uid=<?php echo $site['sp_uid'] ?>&_u=index.product" class="nav_a">产品中心</a></li>  
    </ul>
    <div class="logo_box">  
      <a href="/?_a=site&sp_uid=<?php echo $site['sp_uid'] ?>&_u=index"><img src="?_a=upload&_u=index.out&uidm=1164c06e" class="header_logo"></a>
    </div>
    <ul class="nav_right">
      <li><a href="/?_a=site&sp_uid=<?php echo $site['sp_uid'] ?>&_u=index.cooperation" class="nav_a">我们的合作</a></li>
      <li><a href="/?_a=site&sp_uid=<?php echo $site['sp_uid'] ?>&_u=index.industry" class="nav_a">行业动态</a></li>
      <li><a href="/?_a=site&sp_uid=<?php echo $site['sp_uid'] ?>&_u=index.contactus" class="nav_a">关于我们</a></li>
    </ul>
</div>

</div>
<script type="text/javascript" src="static/js/jquery2.1.min.js"></script>
<!-- <script type="text/javascript" src="app/site/view/buffalo/static/js/header.js"></script> -->
