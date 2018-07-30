
<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg"><?php echo(!empty($slide['uid']) ? '编辑幻灯片' : '添加幻灯片')?></strong> / <small></small></div>
</div>

<div class="am-form">
			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             说明
   		         </div>
       		     <div class="am-u-sm-6 am-u-end">
       		       <input type="text" id="id_title" <?php if(!empty($slide['title'])) echo 'value="'.$slide['title'].'"';?>>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             链接
   		         </div>
       		     <div class="am-u-sm-6 am-u-end">
       		       <input type="text" id="id_link" <?php if(!empty($slide['link'])) echo 'value="'.$slide['link'].'"';?>>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
				<div class="am-u-sm-2 am-text-right">
					链接类型
				</div>
				<div class="am-u-sm-6 am-u-end">
					<input type="text" id="id_link_type" <?php if(!empty($slide['link_type'])) echo 'value="'.$slide['link_type'].'"';?>>
					不填默认为url
				</div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	              位置
   		         </div>
       		     <div class="am-u-sm-6 am-u-end">
	              <select data-am-selected="{btnSize: 'lg' }" class="am-input" id="id_pos">
<?php
	if(empty($slide['pos'])) $slide['pos'] = requestString('pos');

					foreach(SlidesMod::get_pos() as  $k => $c) {
					$html .= '<option value="'.$k.'"';
					if($slide['pos'] == $k) $html .= ' selected';
					$html .= '>'.$c['name'].'</option>';
					}
					echo $html;
?>
				</select>
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
                  <img id="id_img" <?php if(!empty($slide['image'])) echo 'src="'.$slide['image'].'"';?> style="width:100px;height:100px;">
              </div>
				<span>图片参考大小： 轮播图 750*450,  分类图 64*64, 格式 jpg</span>
            </div>

       		     <div class="am-u-sm-8 am-u-end">
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             排序
   		         </div>
       		     <div class="am-u-sm-2 am-u-end">
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
					显示</label>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             上线时间
   		         </div>
       		     <div class="am-u-sm-4 am-u-end">
       		       <input type="datetime-local" id="id_on_time" <?php if(!empty($slide['on_time'])) echo 'value="'.date('Y-m-d\TH:i:s', $slide['on_time']).'"';?>>
					<small>如果设置，那么在这个时间之前不显示</small>
       		     </div>
			</div>
			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             下线时间
   		         </div>
       		     <div class="am-u-sm-4 am-u-end">
       		       <input type="datetime-local" id="id_off_time" <?php if(!empty($slide['off_time'])) echo 'value="'.date('Y-m-d\TH:i:s', $slide['off_time']).'"';?>>
					<small>如果设置，那么到这个时间之后不显示</small>
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
		'/static/js/ueditor/ueditor.config.js',
		'/static/js/ueditor/ueditor.all.js',

		$static_path.'/js/addslide.js',
	);
?>
<script>
	seajs.use(['selectPic']);
</script>

<script>
</script>
