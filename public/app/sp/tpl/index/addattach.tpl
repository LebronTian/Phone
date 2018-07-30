
<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg"><?php echo(!empty($attach['uid']) ? '编辑' : '添加')?>附件</strong> / <small></small></div>
</div>

<div class="am-form">
			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             附件名称
   		         </div>
       		     <div class="am-u-sm-6">
       		       <input type="text" id="id_title" <?php if(!empty($attach['title'])) echo 'value="'.$attach['title'].'"';?>>
				<button class="am-btn am-btn-secondary" id="id_attach">上传附件</button>
       		     </div>
       		     <div class="am-u-sm-2 am-u-end">
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             url链接
   		         </div>
       		     <div class="am-u-sm-6 am-u-end">
       		       <input type="text" id="id_link" <?php if(!empty($attach['link'])) echo 'value="'.$attach['link'].'"';?>>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
				<div class="am-u-sm-2 am-text-right">
					类型
				</div>
				<div class="am-u-sm-6 am-u-end">
					<input type="text" id="id_link_type" <?php if(!empty($attach['link_type'])) echo 'value="'.$attach['link_type'].'"';?>>
					如 doc, pdf ,xls 等	
				</div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	              位置
   		         </div>
       		     <div class="am-u-sm-6 am-u-end">
	              <select data-am-selected="{btnSize: 'lg' }" class="am-input" id="id_pos">
<?php
	if(empty($attach['pos'])) $attach['pos'] = requestString('pos');

					foreach(AttachesMod::get_pos() as  $k => $c) {
					$html .= '<option value="'.$k.'"';
					if($attach['pos'] == $k) $html .= ' selected';
					$html .= '>'.$c['name'].'</option>';
					}
					echo $html;
?>
				</select>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             logo图片
   		         </div>
               <div class="am-u-sm-9">          
              <!-- <form action="?_a=upload&_u=index.upload" runat="server" enctype="multipart/form-data">
                  <input type="file" name="file" id="file_upload"/>
                  
              </form> -->  
              <button  class="imgBoxBtn am-btn am-btn-secondary" data-addr="#id_img" id="search_pic">从图片库选择</button>
              <div id="idImgBox">
                  <img id="id_img" <?php if(!empty($attach['image'])) echo 'src="'.$attach['image'].'"';?> style="width:64px;height:64px;">
              </div>
				<span>选填， 64*64, 格式 jpg</span>
            </div>

       		     <div class="am-u-sm-8 am-u-end">
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             排序
   		         </div>
       		     <div class="am-u-sm-2 am-u-end">
       		       <input type="text" id="id_sort" <?php if(isset($attach['sort'])) echo 'value="'.$attach['sort'].'"';?>>
					<small>从大到小排序</small>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             状态
   		         </div>
       		     <div class="am-u-sm-8 am-u-end">
					<label class="am-checkbox">
       		       <input type="checkbox" id="id_status" data-am-ucheck <?php if(empty($attach['status'])) echo 'checked';?>>
					显示</label>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             上线时间
   		         </div>
       		     <div class="am-u-sm-4 am-u-end">
       		       <input type="datetime-local" id="id_on_time" <?php if(!empty($attach['on_time'])) echo 'value="'.date('Y-m-d\TH:i:s', $attach['on_time']).'"';?>>
					<small>如果设置，那么在这个时间之前不显示</small>
       		     </div>
			</div>
			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             下线时间
   		         </div>
       		     <div class="am-u-sm-4 am-u-end">
       		       <input type="datetime-local" id="id_off_time" <?php if(!empty($attach['off_time'])) echo 'value="'.date('Y-m-d\TH:i:s', $attach['off_time']).'"';?>>
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
	echo '<script>var g_uid = '.(!empty($attach['uid']) ? $attach['uid'] : 0).';</script>';
	$extra_js =  array(
		'/static/js/ueditor/ueditor.config.js',
		'/static/js/ueditor/ueditor.all.js',
		'/static/js/plupload.full.min.js',
		'/static/js/uploadattach.js',
		$static_path.'/js/addattach.js',
	);
?>
<script>
seajs.use(['selectPic']);
</script>
<script>
$(function(){
do_upload_attach({ele_uid: '#id_attach', cb:function(ret){
console.log('upload ..', ret);
$('#id_title').val(ret.file_name);
$('#id_link').val(ret.url);
$('#id_link_type').val(ret.file_name.substring(ret.file_name.lastIndexOf('.') + 1));
}});
});
</script>

