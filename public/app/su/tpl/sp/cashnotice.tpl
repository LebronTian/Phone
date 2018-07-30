
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/css.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/style.css">
<link rel="stylesheet" type="text/css" href="/app/sp/static/css/jquery.Jcrop.css">

<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">通知设置</strong> / 
		<small>余额变动时给用户发送微信模板消息通知</small></div>
</div>

<div class="am-form">
			<div class="am-margin">
		<span class="am-icon-info"></span> 微信模板消息通知需要去微信公众号后台 <strong>申请审核</strong> 通过后才能使用，否则微信模板通知无法发送
		<a href="https://mp.weixin.qq.com" target="_blank">点击去添加微信模板消息</a>
		<p>申请微信模板消息的内容请填写 (业务处理通知):
			<strong class="am-text-danger">
{{first.DATA}}
业务类型：{{keyword1.DATA}}
业务状态：{{keyword2.DATA}}
业务内容：{{keyword3.DATA}}
{{remark.DATA}}

			</strong>
		</p>
	</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             状态
   		         </div>
       		     <div class="am-u-sm-8 am-u-end">
					<label class="am-checkbox">
       		       <input type="checkbox" id="id_status" data-am-ucheck <?php if(!empty($cfg['enabled'])) echo 'checked';?>>
					开启微信通知</label>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             微信模板ID
   		         </div>
       		     <div class="am-u-sm-8 am-u-end cset">
       		       <input type="text" id="id_tid" <?php echo !empty($cfg['tid']) ? 'value="'.$cfg['tid'].'"' : 'value=""';?>>
       		     </div>
			</div>
			
			<div class="am-g am-margin-top-sm" style="display:none;">
           		 <div class="am-u-sm-2 am-text-right">
	             内容
   		         </div>
       		     <div class="am-u-sm-8 am-u-end cset">
       		       <input type="text" id="id_kw2" <?php echo !empty($cfg['kw2']) ? 'value="'.$cfg['kw2'].'"' : 'value=""';?>>
       		     </div>
			</div>
			
			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
					<p><button class="am-btn am-btn-lg am-btn-primary save">保存</button></p>
				</div>
			</div>

</div>

<?php
	//echo '<script>var g_uid = '.(!empty($qp['uid']) ? $qp['uid'] : 0).';</script>';
        $extra_js =  array(
            $static_path.'/js/cashnotice.js',
    );

?>
