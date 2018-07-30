
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
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">用户提现</strong> / <small>用户提现设置</small></div>
</div>

<?php
if(PayMod::is_sp_uctpay_available(AccountMod::get_current_service_provider('uid'))) {
echo '<div class="am-margin-left">
<a href="?_a=pay&_u=sp.uctpay" class="am-text-warning" style="text-align:center; border: 1px solid #f37b1d; margin-top: -1.6rem;
"><span class="am-icon-warning"></span> 您已开启平台代收款，本页设置将会失效！</a></div>';
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
       		       <input type="checkbox" id="id_status" data-am-ucheck <?php if(!empty($wd['enabled'])) echo 'checked';?>>
					启用</label>
					<a href="?_easy=pay.sp.withdrawlist">查看提现记录</a>
       		     </div>
			</div>

<div class="am-form">
			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	             放款审核
   		         </div>
       		     <div class="am-u-sm-8 am-u-end">
					<label class="am-checkbox">
       		       <input type="checkbox" id="id_need_check" data-am-ucheck <?php if(!empty($wd['withdraw_rule']['need_check'])) echo 'checked';?>>
					需要人工审核</label>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
				打款方式
   		         </div>
       		     <div class="am-u-sm-8 am-u-end cset">
					<select id="id_wd_type" data-am-selected="{btnSize: 'lg' }">
						<option value="1" <?php if(!empty($wd['wd_type']) && $wd['wd_type'] == 1) echo ' selected="selected"'; ?>>微信红包</option>
						<option value="2" <?php if(!empty($wd['wd_type']) && $wd['wd_type'] == 2) echo ' selected="selected"'; ?>>微信企业付款</option>
					<?php
						if(!empty($_REQUEST['_d']) || ($wd['wd_type'] == 3) || !empty($wd['withdraw_rule']['need_check'])) {
					?>
						<option value="3" <?php if(!empty($wd['wd_type']) && $wd['wd_type'] == 3) echo ' selected="selected"'; ?>>线下打款</option>
					<?php } ?>

					<?php
						if(!empty($_REQUEST['_d']) || ($wd['wd_type'] == 5)) {
					?>
						<option value="5" <?php if(!empty($wd['wd_type']) && $wd['wd_type'] == 5) echo ' selected="selected"'; ?>>微信付款到银行卡</option>
					<?php } ?>
					</select>
					</br>
					<span class="am-icon-info"></span> 请确保已经正确设置了<a href="?_a=pay&_u=sp.weixinpay">微信支付</a>参数并且上传了证书文件
					</br>
					<span class="am-icon-info"></span> 微信红包单个不能超过200元，同一用户每分钟只能发1个
					</br>
					<span class="am-icon-info"></span> 微信小程序提现仅支持企业付款
					</br>
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
				 单笔最低额度(&yen;)
   		         </div>
       		     <div class="am-u-sm-8 am-u-end cset">
       		       <input type="text" id="id_min_price" <?php echo (!empty($wd['withdraw_rule']['min_price'])) ? 'value="'
						.($wd['withdraw_rule']['min_price']/100).'"' : 'value="1"';?>>
					0表示不限制
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
				 单笔最高额度(&yen;)
   		         </div>
       		     <div class="am-u-sm-8 am-u-end cset">
       		       <input type="text" id="id_max_price" <?php echo (!empty($wd['withdraw_rule']['max_price'])) ? 'value="'
						.($wd['withdraw_rule']['max_price']/100).'"' : 'value="0"';?>>
					0表示不限制
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
				 每日最高额度(&yen;)
   		         </div>
       		     <div class="am-u-sm-8 am-u-end cset">
       		       <input type="text" id="id_max_price_day" <?php echo (!empty($wd['withdraw_rule']['max_price_day'])) ? 'value="'
						.($wd['withdraw_rule']['max_price_day']/100).'"' : 'value="0"';?>>
					0表示不限制
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
				 每日提现笔数
   		         </div>
       		     <div class="am-u-sm-8 am-u-end cset">
       		       <input type="text" id="id_max_cnt_day" <?php echo (!empty($wd['withdraw_rule']['max_cnt_day'])) ? 'value="'
						.($wd['withdraw_rule']['max_cnt_day']).'"' : 'value="0"';?>>
					0表示不限制,每日最高提现次数
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
				 大额提现转人工(&yen;)
   		         </div>
       		     <div class="am-u-sm-8 am-u-end cset">
       		       <input type="text" id="id_check_price" <?php echo (!empty($wd['withdraw_rule']['check_price'])) ? 'value="'
						.($wd['withdraw_rule']['check_price']/100).'"' : 'value="0"';?>>
					0表示不限制, 当设置为自动提现时, 超过一定金额需要人工介入
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
          '/spv3/pay/static/js/withdraw.js',
    );

?>


