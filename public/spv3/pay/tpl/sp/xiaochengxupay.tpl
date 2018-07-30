
<head>
    <link rel="stylesheet" type="text/css" href="/static/css/uploadify.css">
  <link rel="stylesheet" type="text/css" href="/static/css/imglist.css">
  <link rel="stylesheet" type="text/css" href="/static/css/uploadify.css">
  <link rel="stylesheet" type="text/css" href="/app/sp/static/css/css.css">
  <link rel="stylesheet" type="text/css" href="/app/sp/static/css/style.css"> 
  <link rel="stylesheet" type="text/css" href="/app/sp/static/css/jquery.Jcrop.css"> 
<style type="text/css">
  .uploadify-button {
    line-height: 25px !important;
  }
	.fstatus {
	}

.am-form input[type=text] {
width:340px;
}
</style>
</head>

<!-- <div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">小程序支付设置</strong> / <small>小程序支付设置</small></div>
</div> -->

<div class="am-margin-left am-text-lg">
正在设置小程序： <?php echo '<a href="?_a=sp&_u=index.addpublic&uid='.$public['uid'].'">'.$public['public_name'].'</a>';?>
<?php
if(!$cfg) {
$cfg = array('spname' => $public['public_name'], 'APPID' => $public['app_id'], 'APPSECRET' => $public['app_secret']);
}
?>
</div>


<div class="am-form">
			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             状态
   		         </div>
       		     <div class="am-u-sm-8 am-u-end">
					<label class="am-checkbox">
       		       <input type="checkbox" id="id_status" data-am-ucheck <?php if(empty($cfg['disabled'])) echo 'checked';?>>
					启用</label>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	            收款方名
   		         </div>
       		     <div class="am-u-sm-8 am-u-end cset">
       		       <input type="text" id="id_spname" <?php if(!empty($cfg['spname'])) echo 'value="'.$cfg['spname'].'"';?>>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	            APPID 
   		         </div>
       		     <div class="am-u-sm-8 am-u-end cset">
       		       <input  type="text" id="id_appid" placeholder="小程序的appid，位于 开发》基本配置"  <?php if(!empty($cfg['APPID'])) echo 'value="'.$cfg['APPID'].'"';?>>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	            APPSECRET
   		         </div>
       		     <div class="am-u-sm-8 am-u-end cset">
       		       <input type="text" id="id_appsecret" placeholder="小程序的appsecret，位于 开发》基本配置"<?php if(!empty($cfg['APPSECRET'])) echo 'value="'.$cfg['APPSECRET'].'"';?>>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	            MCHID
   		         </div>
       		     <div class="am-u-sm-8 am-u-end cset">
       		       <input type="text" id="id_mchid" placeholder="位于 微信支付商户平台》账户中心》个人信息》登陆账号"  <?php if(!empty($cfg['MCHID'])) echo 'value="'.$cfg['MCHID'].'"';?>>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	            KEY
   		         </div>
       		     <div class="am-u-sm-8 am-u-end cset">
       		       <input type="text" id="id_key"  placeholder="位于 微信支付商户平台》账户中心》API安全》修改API密钥" <?php if(!empty($cfg['KEY'])) echo 'value="'.$cfg['KEY'].'"';?>>
       		     </div>
			</div>

			<hr/>
			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
					&nbsp;
   		         </div>
       		     <div class="am-u-sm-8 am-u-end" style="display:none1;">
				<span class="am-icon-lightbulb-o"></span> 退款 原路退回 功能需要上传证书文件
   		         </div>
			</div>
			<hr/>

			<div class="am-g am-margin-top-sm" style="display:none1;">
           		 <div class="am-u-sm-2 am-text-right">
	             apiclient_cert.pem
   		         </div>
       		     <div class="am-u-sm-1">
					<div class="fstatus"><?php if(!empty($cfg['SSLCERT_PATH'])) echo '已上传'; else echo '未上传';?></div>
       		     </div>
       		     <div class="am-u-sm-7 am-u-end cset">
					<button id="id_cert_file"></button>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm" style="display:none1;">
           		 <div class="am-u-sm-2 am-text-right">
	             apiclient_key.pem
   		         </div>
       		     <div class="am-u-sm-1">
					<div class="fstatus"><?php if(!empty($cfg['SSLKEY_PATH'])) echo '已上传'; else echo '未上传';?></div>
       		     </div>
       		     <div class="am-u-sm-7 am-u-end cset">
					<button id="id_key_file"></button>
       		     </div>
			</div>


			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
					<p><button data-uid="<?php echo $public['uid'];?>" class="am-btn am-btn-lg am-btn-primary save">保存</button></p>
				</div>
			</div>

</div>

<?php
        $extra_js =  array( 
          '/static/js/jquery.uploadify-3.1.min.js',
          $static_path.'/js/xiaochengxupay.js',
    );

?>


