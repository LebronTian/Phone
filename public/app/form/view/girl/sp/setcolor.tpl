<?php
//为避免$k命名冲突, 请遵守k的命名规则规范 cfg_{$app}_{$tpl}_{$act}_{$sp_uid}
$k = 'cfg_form_girl_setcolor_'.AccountMod::get_current_service_provider('uid').'_'.$form['uid'];
$color = SpExtMod::get_sp_ext_cfg($k);

?>


<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg"> <span style="color:black;">girl</span> 颜色设置</strong> / <small></small></div>
</div>

<div class="am-form">
			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             网站颜色
   		         </div>
       		     <div class="am-u-sm-8 am-u-end">
       		       <input type="text" class="color" maxlength="6" size="6" id="id_color" <?php if(!empty($color)) echo 'value="'.$color.'"';?>>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
          <button class="am-btn am-btn-lg am-btn-primary save">保存
          </button>
        </div>
        <div class="am-u-sm-10 am-u-sm">
          <button class="am-btn am-btn-lg am-btn-primary show_tpl"  data-src="<?php echo DomainMod::get_app_url('form', 0, '__tpl=girl');?>
            ">预览
          </button>
        </div>

			</div>

</div>

<style type="text/css"> 
.moveBar {position: absolute;width:300px;height:529px;z-index:10;right:100px;
top:50px;
} 
.phone_png{width:300px;height:529px;position:absolute;z-index:-10;top:0}
#banner { cursor: move;height:75px;opacity:0;} 
.content{position:absolute;top:77px;left:23px;height:382px;width:258px;}
.close_show{position:absolute;right:15px;top:15px;cursor:pointer;border-radius:1000px}
#back{position:absolute;left:123px;bottom:13px;height:46px;width:56px;cursor:pointer;border-radius:30px;opacity:0}
.gallery-desc{min-width:222px}
.gallery-desc>button{font-size:1.3rem;}
.gallery-desc>a{font-size:1.3rem;}
.url_erweima{width:215px;height:215px;position:absolute;display:none}
</style>



<?php
        echo '<script>var uid = '.(!empty($form['uid']) ? $form['uid'] : 0).';</script>';
        $extra_js =  array( 
          $static_path.'/js/jscolor.js',
          $static_path.'/js/sp.setcolor.js',
    );
?>


