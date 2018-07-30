
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
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">平台代收</strong> / <small>没有微信支付账号、支付宝账号? 您也可以使用官方平台代收款服务实现收款。</small></div>
</div>

<div class="am-form">
	<div class="am-g am-margin">
		
	</div>
			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             状态:
   		         </div>
       		     <div class="am-u-sm-8 am-u-end">
					<label class="am-checkbox">
       		       <input type="checkbox" id="id_status" data-am-ucheck <?php if(!empty($cfg) && empty($cfg['disabled'])) echo 'checked';?>>
					启用</label>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right"> &nbsp;
   		         </div>
       		     <div class="am-u-sm-8 am-u-end cset">
					<label class="am-checkbox">
       		       <input type="checkbox" id="id_wxpay" data-am-ucheck <?php if(!empty($cfg['wxpay'])) echo 'checked';?>>
					<span class="am-icon-weixin"></span> 微信支付</label>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right"> &nbsp;
   		         </div>
       		     <div class="am-u-sm-8 am-u-end cset">
					<label class="am-checkbox">
       		       <input type="checkbox" id="id_alipay" data-am-ucheck <?php if(!empty($cfg['alipay'])) echo 'checked';?>>
					<span class="am-icon-shield"></span> 支付宝 </label>
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
          $static_path.'/js/uctpay.js',
    );

?>


