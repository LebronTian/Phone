
<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg"><?php echo(!empty($slide['uid']) ? '编辑幻灯片' : '添加幻灯片')?></strong> / <small></small></div>
</div>

<div class="am-form">
			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             说明
   		         </div>
       		     <div class="am-u-sm-8 am-u-end">
       		       <input type="text" id="id_title" <?php if(!empty($slide['title'])) echo 'value="'.$slide['title'].'"';?>>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             链接
   		         </div>
       		     <div class="am-u-sm-8 am-u-end">
       		       <input type="text" id="id_link" <?php if(!empty($slide['link'])) echo 'value="'.$slide['link'].'"';?>>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             图片
   		         </div>
               <div class="am-u-sm-9">          
              <!-- <form action="?_a=upload&_u=index.upload" runat="server" enctype="multipart/form-data">
                  <input type="file" name="file" id="file_upload"/>
                  
              </form> -->  
              <button  class="imgBoxBtn am-btn am-btn-secondary" data-addr="#id_img" id="search_pic">从图片库选择</button>
              <div id="idImgBox">
                  <img id="id_img" <?php if(!empty($slide['image'])) echo 'src="'.$slide['image'].'"';?> style="max-height:100px;">
              </div>
					图片参考大小： 轮播图 750*450
            </div>

       		     <div class="am-u-sm-8 am-u-end">
       		     </div>
			</div>
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			位置
		</div>
		<div class="am-u-sm-8 am-u-end">
			<div class="am-radio" style="float: left">
				<label>
					<input type="radio" name="deli-radio" value="0" <?php if(!isset($slide['slides_in'])||$slide['slides_in']==0) echo 'checked'; ?>>首页
				</label>
			</div>
			<div class="am-radio" style="float: left;margin-top:10px;">
				<label>
					<input type="radio" name="deli-radio" value="1" <?php if(!empty($slide['slides_in'])&&$slide['slides_in']==1) echo 'checked'; ?>>留言墙
				</label>
			</div>
			<div class="am-radio" style="float: left;margin-top:10px;">
				<label>
					<input type="radio" name="deli-radio" value="2" <?php if(!empty($slide['slides_in'])&&$slide['slides_in']==2) echo 'checked'; ?>>PC首页
				</label>
			</div>
		</div>
	</div>


			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             排序
   		         </div>
       		     <div class="am-u-sm-8 am-u-end">
       		       <input type="text" id="id_sort" <?php if(isset($slide['sort'])) echo 'value="'.$slide['sort'].'"';?>>
					<small>从大到小排序</small>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             状态
   		         </div>
       		     <div class="am-u-sm-8 am-u-end">
					<label class="am-checkbox">
       		       <input type="checkbox" id="id_status" data-am-ucheck <?php if(empty($slide['status'])) echo 'checked';?>>
					显示到网站</label>
       		     </div>
			</div>


			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
                     &nbsp;
				</div>
                <div class="am-u-sm-8 am-u-end">
                    <p><button class="am-btn am-btn-lg am-btn-primary save">保存</button></p>

                </div>
			</div>

</div>

<?php
	echo '<script>var g_uid = '.(!empty($slide['uid']) ? $slide['uid'] : 0).';</script>';
            $extra_js =  array(
            $static_path.'/js/addslide.js',
    );
?>

<script>
	seajs.use(['selectPic']);
</script>
