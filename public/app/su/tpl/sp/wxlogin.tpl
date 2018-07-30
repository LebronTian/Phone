
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
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">公众号代理授权设置</strong> / <small>代理oauth2网页授权设置</small></div>
</div>

<div class="am-cf am-padding">
<p><span class="am-icon-info"></span> 如果您没有服务号，但是想使用微信快捷登录, 可以开启本选项来实现.</p>
<?php 
	if(WeixinMod::get_current_weixin_public('public_type', false) == 2) {
		echo '<strong class="am-text-secondary"><span class="am-icon-lightbulb-o"></span> 您当前的公众号是服务号，无需开启此功能</strong>';
	}
	else {
		echo '<strong class="am-text-secondary"><span class="am-icon-lightbulb-o"></span> 您当前的公众号不是服务号，可以开启此功能</strong>';
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
       		       <input type="checkbox" id="id_status" data-am-ucheck <?php if(!empty($cfg['enabled'])) echo 'checked';?>>
					启用</label>
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
          $static_path.'/js/wxlogin.js',
    );

?>


