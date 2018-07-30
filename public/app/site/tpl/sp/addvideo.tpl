
<input id="video_uid" style="display:none;" value="<?php echo requestInt('uid'); ?>">
<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">添加视频</strong> / <small></small></div>
</div>
<div class="am-form">
      <div class="am-g am-margin-top-sm">
               <div class="am-u-sm-2 am-text-right">
               视频地址
               </div>
               <div class="am-u-sm-8 am-u-end">
                 <input type="text" id="video_address" placeholder="输入视频的地址信息" <?php if(!empty($video['address'])) echo 'value="'.$video['address'].'"';?>>
               </div>
      </div>

      <div class="am-g am-margin-top-sm">
               <div class="am-u-sm-2 am-text-right">
               视频描述 
               </div>
               <div class="am-u-sm-8 am-u-end">
                 <input type="text" id="video_describe" placeholder="输入视频内容的相关描述信息" <?php if(!empty($video['describle'])) echo 'value="'.$video['describle'].'"'; ?>>
               </div>
      </div>
      <div class="am-g am-margin-top-sm">
              <div class="am-u-sm-2 am-text-right">视频图片</div>
              <div class="am-u-sm-9">
              <button class="imgBoxBtn am-btn am-btn-primary" data-addr="#video_img">从图片库选择</button>
              <div id="idImgBox">
                  <img id="video_img" style="width:100px;height:100px;" <?php if(!empty($video['image'])) echo 'src="'.$video['image'].'"'; ?>>
              </div>

              </div>
              <div class="am-u-sm-8 am-u-end">
              </div>
      </div>
    
    
      <div class="am-g am-margin-top-sm">
               <div class="am-u-sm-2 am-text-right">
               排序
               </div>
               <div class="am-u-sm-8 am-u-end">
                 <input type="text" id="id_sort" <?php if(isset($video['sort'])) echo 'value="'.$video['sort'].'"';?>>
          <small>从大到小排序</small>
               </div>
      </div>


      <div class="am-g am-margin-top-sm">
               <div class="am-u-sm-2 am-text-right">
               状态
               </div>
               <div class="am-u-sm-8 am-u-end">
          <label class="am-checkbox">
                 <input type="checkbox" id="id_status" data-am-ucheck <?php if(empty($article['status'])) echo 'checked';?>>
          显示到网站</label>
               </div>
      </div>


      <div class="am-g am-margin-top-sm">
           <div class="am-u-sm-2 am-text-right">
             <p><button class="am-btn am-btn-lg am-btn-primary save">保存</button></p>
           </div>
      </div>


</div>


<?php
        $extra_js =  array(
          '/app/site/static/js/video.js',
    );
?>

<script>
    seajs.use(['selectPic'])
</script>