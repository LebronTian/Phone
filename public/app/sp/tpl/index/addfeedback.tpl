
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/css.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/style.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/jquery.Jcrop.css">

<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg"><?php echo(!empty($fb['uid']) ? '编辑工单' : '添加工单')?></strong> / <small></small></div>
</div>

<div class="am-form">
			<div class="am-g am-margin-top-sm" style="margin-top:20px;">
           		 <div class="am-u-sm-2 am-text-right">
	            内容 
   		         </div>              
                <!--文本编辑/-->
                
       		     <div class="am-u-sm-8 am-u-end">
       		      <script id="container" name="content" type="text/plain" style="height:250px;"><?php if(!empty($fb['content'])) echo ''.$fb['content'].'';?></script>  
       		     </div>
			</div>


			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
					<p><button class="am-btn am-btn-lg am-btn-primary save">保存</button></p>
				</div>
			</div>

</div>

<?php
	echo '<script>var g_uid = '.(!empty($fb['uid']) ? $fb['uid'] : 0).';</script>';
        $extra_js =  array(
            '/static/js/ueditor/ueditor.config.js',
            '/static/js/ueditor/ueditor.all.js', 

            $static_path.'/js/addfeedback.js',
    );

?>

<script>
	seajs.use(['selectPic']);
</script>
