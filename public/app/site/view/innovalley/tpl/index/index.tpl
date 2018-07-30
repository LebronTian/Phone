<?php 
include $tpl_path.'/header.tpl';

#var_export($article);
?>
<link rel="stylesheet" href="/app/site/view/innovalley/static/css/islider.css"/>
<div class="content">
<div class="main_visual">
  <div class="flicking_con">
      <?php 
      $html='';
      if($slides) foreach ($slides as $s) { 
        $html.='<a href="#"></a>';
      }
      echo $html;
      ?>
  </div>
  <div class="main_image">
    <ul>
      <?php 
      $html='';
      if($slides) foreach ($slides as $s) { 
        $html.='<li><a href="javascript:;"><img style="width:100%;height:578px" src="'.$s['image'].'"></a></li>';
      }
      echo $html;
      ?>
    </ul>
    <?php 
      $html='';

        $html.='<a href="javascript:;" id="btn_prev"></a><a href="javascript:;" id="btn_next"></a>';
      echo $html;
    ?>
    
  </div>
</div>
</div>

<footer class="footer">
  <div class="am-container">
    <p><?php if(!empty($site['location'])) echo $site['location']; else echo '深圳市南山区蛇口工业六路9号创新谷'  ?></p>
  </div>
</footer>

<script src="/app/site/view/innovalley/static/js/jquery.min.js"></script>
<script src="/app/site/view/innovalley/static/js/amazeui.min.js"></script>
<script type="text/javascript" src="/app/site/view/innovalley/static/js/jquery.event.drag-1.5.min.js"></script>
<script type="text/javascript" src="/app/site/view/innovalley/static/js/jquery.touchSlider.js"></script>
<script type="text/javascript" src="/app/site/view/innovalley/static/js/islider.js"></script>
<script type="text/javascript" src="/app/site/view/innovalley/static/js/style.js"></script>
<script>
  $(".main_visual").hover(function(){
    $("#btn_prev,#btn_next").fadeIn()
  },function(){
    $("#btn_prev,#btn_next").fadeOut()
  });

</script>
</body>
</html>