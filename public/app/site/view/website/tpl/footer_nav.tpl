
<?php 
  $pageid=requestInt('cid');
  $status=requestInt('status');
  $hides=requestInt('hides');
?>


<div class="back_top"><a href="#footer_nav"><img src="/app/site/view/website/static/images/top.png"></a></div>

<div class="message_bg">
    <div class="message_box">
        <div class="message_title">留言板</div>
        <div style="margin:0 auto;width:300px;">
        <textarea class="message_brief" style=""></textarea>
        </div>
        <div style="text-align:center">
        <button class="save_msg">提交</button>
        </div>
    </div>
</div>



<div class="footer_nav" id="footer_nav" data-hides="<?php echo $hides;?>" data-status="<?php echo $status;?>" data-IE = "<?php if(isIEBrowser()) echo '1'; else echo '2';?>">
    <div class="nav_list">
      <ul class="first_ul">
      <?php 
      $i=1;
      $html='';
      if($parent_cats) 
      	foreach ($parent_cats as $s) {  
        if($s['uid']==$pageid)
        $html.='<li class="first_li btn_list'.$i.'"  id="list_isclick"  data-uid="'.$s['uid'].'">'.$s['title'].'</li>';
        else
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