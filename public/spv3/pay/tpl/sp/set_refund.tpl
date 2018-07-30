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
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">退款设置</strong> / <small></small></div>
</div>

<div class="am-form">
			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
				退款方式
   		         </div>
       		     <div class="am-u-sm-8 am-u-end cset">
					<select id="id_type" data-am-selected="{btnSize: 'lg' }">
						<option value="1" <?php if(!empty($cfg['type']) && $cfg['type'] == 1) echo ' selected="selected"'; ?>>原路退回</option>
						<option value="2" <?php if(!empty($cfg['type']) && $cfg['type'] == 2) echo ' selected="selected"'; ?>>退到余额</option>
						<option value="3" <?php if(!empty($cfg['type']) && $cfg['type'] == 3) echo ' selected="selected"'; ?>>线下转账</option>
					</select>
					</br>
					</br>
					<span class="am-icon-info"></span> 原路退回: 自动退到用户微信零钱, 本功能需要  <a href="?_a=pay&_u=sp.xiaochengxupay">设置微信支付证书</a>
					</br>
					<span class="am-icon-info"></span> 退到余额: 将把退款增加到用户余额账号
					</br>
					<span class="am-icon-info"></span> 线下转账: 线下沟通处理，系统不进行任何操作
       		     </div>
			</div>

			<div class="am-g am-margin">
				<p><span class="am-icon-info-circle"></span> 如果您直接在微信支付商户后台退款，
				而不在本平台操作，您可以设置为 <b>线下转账</b> 模式，
				否则可能导致本平台订单状态不正确
				</p>
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
          $static_path.'/js/set_refund.js?1',
    );

?>


