
<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg"><?php echo(!empty($cat['uid']) ? '编辑分类' : '添加分类')?></strong> / <small></small></div>
</div>

<div class="am-form">
			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             名称
   		         </div>
       		     <div class="am-u-sm-8 am-u-end">
       		       <input type="text" id="id_title" <?php if(!empty($cat['title'])) echo 'value="'.$cat['title'].'"';?>>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             英文名称
   		         </div>
       		     <div class="am-u-sm-8 am-u-end">
       		       <input type="text" id="id_title_en" <?php if(!empty($cat['title_en'])) echo 'value="'.$cat['title_en'].'"';?>>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             父级分类
   		         </div>
       		     <div class="am-u-sm-8 am-u-end">
   <select data-am-selected="{btnWidth: 150, btnSize: 'lg' }" class="option_parent">
     <?php
         $html = '<option value="0"';
         if(empty($cat['parent_uid'])) $html .= ' selected ';
         $html .= '>顶级</option>';
         
		if(!empty($parents))
         foreach($parents as $p) {
		if(!empty($cat) && ($p['uid'] == $cat['uid'])) continue;
         $html .= '<option value="'.$p['uid'].'"';
         if(!empty($cat['parent_uid']) && $cat['parent_uid'] == $p['uid']) $html .= ' selected';
         $html .= '>'.$p['title'].'</option>';
         }
         echo $html;
     ?>
   </select>
				</div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             大图
   		         </div>
               <div class="am-u-sm-9">          
              <!-- <form action="?_a=upload&_u=index.upload" runat="server" enctype="multipart/form-data">
                  <input type="file" name="file" id="file_upload"/>
                  
              </form> -->  
              <button  class="imgBoxBtn am-btn am-btn-secondary" data-addr="#id_img" >从图片库选择</button>
              <div id="codeImgBox">
                  <img id="id_img" <?php if(!empty($cat['image'])) echo 'src="'.$cat['image'].'"';?> style="width:100px;height:100px;">
              </div>
            </div>
       		     <div class="am-u-sm-8 am-u-end">
       		     </div>
			</div>

      <div class="am-g am-margin-top-sm">
               <div class="am-u-sm-2 am-text-right">
               缩略小图
               </div>
               <div class="am-u-sm-9">          
              <!-- <form action="?_a=upload&_u=index.upload" runat="server" enctype="multipart/form-data">
                  <input type="file" name="file" id="file_upload"/>
                  
              </form> -->  
              <button  class="imgBoxBtn am-btn am-btn-secondary" data-addr="#id_img2">从图片库选择</button>
              <div id="codeImgBox2">
                  <img id="id_img2" <?php if(!empty($cat['image_icon'])) echo 'src="'.$cat['image_icon'].'"';?> style="width:100px;height:100px;">
              </div>
            </div>
               <div class="am-u-sm-8 am-u-end">
               </div>
      </div>


			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             文字说明
   		         </div>
       		     <div class="am-u-sm-8 am-u-end">
       		       <input type="text" id="id_brief" <?php if(!empty($cat['brief'])) echo 'value="'.$cat['brief'].'"';?>>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             排序
   		         </div>
       		     <div class="am-u-sm-8 am-u-end">
       		       <input type="text" id="id_sort" <?php if(isset($cat['sort'])) echo 'value="'.$cat['sort'].'"';?>>
					<small>从大到小排序</small>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             状态
   		         </div>
       		     <div class="am-u-sm-8 am-u-end">
					<label class="am-checkbox">
       		       <input type="checkbox" id="id_status" data-am-ucheck <?php if(empty($cat['status'])) echo 'checked';?>>
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
	echo '<script>var g_uid = '.(!empty($cat['uid']) ? $cat['uid'] : 0).';</script>';
    $extra_js =  array(
          '/app/site/static/js/addcat.js',
    );
?>

<script>
	seajs.use(['selectPic']);
</script>
