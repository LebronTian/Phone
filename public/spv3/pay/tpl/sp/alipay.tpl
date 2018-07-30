
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
</style>
</head>

<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">支付宝设置</strong> / <small>支付宝即时到帐设置</small></div>
</div>

<?php
if(PayMod::is_sp_uctpay_available(AccountMod::get_current_service_provider('uid'))) {
echo '<div class="am-margin-left">
<a href="?_a=pay&_u=sp.uctpay" class="am-text-warning" style="text-align:center; border: 1px solid #f37b1d; margin-top: -1.6rem;
"><span class="am-icon-warning"></span> 您已开启UCT代收款，本页设置将会失效！</a></div>';
return;
}

echo '<div class="am-margin"><span class="am-icon-question-circle"></span> 微信小程序不支持使用支付宝支付</div>';
?>

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
	            卖家支付宝账号(手机或邮箱)
   		         </div>
       		     <div class="am-u-sm-8 am-u-end cset">
       		       <input type="text" id="id_seller_email" <?php if(!empty($cfg['seller_email'])) echo 'value="'.$cfg['seller_email'].'"';?>>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	            合作者身份(PID)
   		         </div>
       		     <div class="am-u-sm-8 am-u-end cset">
       		       <input type="text" id="id_partner" <?php if(!empty($cfg['partner'])) echo 'value="'.$cfg['partner'].'"';?>>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	           安全校验码(Key)
   		         </div>
       		     <div class="am-u-sm-8 am-u-end cset">
       		       <input type="text" id="id_key" <?php if(!empty($cfg['key'])) echo 'value="'.$cfg['key'].'"';?>>
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
          //'/static/js/jquery.uploadify-3.1.min.js',
          $static_path.'/js/alipay.js',
    );

?>


