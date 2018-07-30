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
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">余额支付</strong> / <small></small></div>
</div>

<?php
if(PayMod::is_sp_uctpay_available(AccountMod::get_current_service_provider('uid'))) {
echo '<div class="am-margin-left">
<a href="?_a=pay&_u=sp.uctpay" class="am-text-warning" style="text-align:center; border: 1px solid #f37b1d; margin-top: -1.6rem;
"><span class="am-icon-warning"></span> 您已开启UCT代收款，本页设置将会失效！</a></div>';
return;
}
?>

<div class="am-form">
			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             状态
   		         </div>
       		     <div class="am-u-sm-8 am-u-end">
					<label class="am-checkbox">
       		       <input type="checkbox" id="id_status" data-am-ucheck <?php if(!empty($cfg) && empty($cfg['disabled'])) echo 'checked';?>>
					启用</label>
					<!-- <small><span class="am-icon-info"></span> 使用余额支付</small> -->
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
          $static_path.'/js/balancepay.js',
    );

?>


