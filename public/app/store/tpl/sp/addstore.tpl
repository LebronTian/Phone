
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/css.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/style.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/jquery.Jcrop.css">

<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg"><?php echo(!empty($store['uid']) ? '修改门店' : '添加门店')?></strong> / <small></small></div>
</div>

<div class="am-form">
			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             名称
   		         </div>
       		     <div class="am-u-sm-8 am-u-end">
       		       <input type="text" id="id_name" <?php if(!empty($store['name'])) echo 'value="'.$store['name'].'"';?>>
       		     </div>
			</div>

      <div class="am-g am-margin-top-sm">
               <div class="am-u-sm-2 am-text-right">
               介绍
               </div>
               <div class="am-u-sm-8 am-u-end">
                 <input type="text" id="id_brief" <?php if(!empty($store['brief'])) echo 'value="'.$store['brief'].'"';?>>
               </div>
      </div>

      <div class="am-g am-margin-top-sm">
               <div class="am-u-sm-2 am-text-right">
               地址
               </div>
               <div class="am-u-sm-8 am-u-end">
                 <input type="text" id="id_address" <?php if(!empty($store['address'])) echo 'value="'.$store['address'].'"';?>>
               </div>
      </div>
      <div class="am-g am-margin-top-sm">
               <div class="am-u-sm-2 am-text-right">
              	经纬度
               </div>
               <div class="am-u-sm-2">
                 <input placeholder="经度(lng)" type="text" id="id_lng" <?php if(!empty($store['lng'])) echo 'value="'.$store['lng'].'"';?>>
               </div>
               <div class="am-u-sm-2 am-u-end">
                 <input placeholder="纬度(lat)" type="text" id="id_lat" <?php if(!empty($store['lat'])) echo 'value="'.$store['lat'].'"';?>>
               </div>
			<a target="_blank" href="http://api.map.baidu.com/lbsapi/getpoint/">点击进行经纬度查询</a>
      </div>


			<div class="am-g am-margin-top-sm">
               <div class="am-u-sm-2 am-text-right">
               图片
               </div>
               <div class="am-u-sm-9">          
              <!-- <form action="?_a=upload&_u=index.upload" runat="server" enctype="multipart/form-data">
                  <input type="file" name="file" id="file_upload"/>
                  
              </form> -->  
              <button  class="imgBoxBtn am-btn am-btn-secondary" data-addr="#id_img" style="border: 1px solid #CCC;width: 130px;height: 32px;background-color: #0E90D2;color: #FFF;font-size: 14px;">从图片库选择</button>    
              <div id="codeImgBox">
                  <img id="id_img" <?php if(!empty($store['main_image'])) echo 'src="'.$store['main_image'].'"';?> style="width:100px;height:100px;">
              </div>
            </div>
               <div class="am-u-sm-8 am-u-end">
               </div>
      </div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             联系电话
   		         </div>
       		     <div class="am-u-sm-2 am-u-end">
       		       <input type="text" id="id_telephone" <?php if(isset($store['telephone'])) echo 'value="'.$store['telephone'].'"';?>>
					<small>从大到小排序</small>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             排序
   		         </div>
       		     <div class="am-u-sm-2 am-u-end">
       		       <input type="text" id="id_sort" <?php if(isset($store['sort'])) echo 'value="'.$store['sort'].'"';?>>
					<small>从大到小排序</small>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             状态
   		         </div>
       		     <div class="am-u-sm-8 am-u-end">
					<label class="am-checkbox">
       		       <input type="checkbox" id="id_status" data-am-ucheck <?php if(empty($store['status'])) echo 'checked';?>>
					显示</label>
       		     </div>
			</div>

			
			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
					<p><button class="am-btn am-btn-lg am-btn-primary save">保存</button></p>
				</div>
			</div>

</div>

<?php
	echo '<script>var g_uid = '.(!empty($store['uid']) ? $store['uid'] : 0).';</script>';
        $extra_js =  array(
            $static_path.'/js/addstore.js',
    );

?>
<script>
	seajs.use(['selectPic']);
</script>

