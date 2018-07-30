<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">管理员充值&提现</strong> / <small></small></div>
</div>

<div class="am-cf am-padding">
<?php echo '<a href="?_a=su&_u=sp.sucashlist&su_uid='.$su['uid'].'"><strong>'.($su['name'] ? $su['name'] : $su['account'])
		.'</strong> <img src="'.$su['avatar'].'" style="max-width:100px;max-height:100px;"></a>';?>
</div>

<div class="ChangeBar">
    <div class="fans am-u-md-4" style="padding-left:20px;">
      <span class="word">账户余额</span>
      <span class="num" id="TodayFans" style=""><?php echo !empty($point['cash_remain']) ? ($point['cash_remain'] / 100) : 0;?></span>
    </div>
    <div class="attention am-u-md-4">
      <span class="word">已提现</span>
      <span class="num" id="TotalFans" style=""><?php echo !empty($point['cash_transfered']) ? ($point['cash_transfered'] / 100) : 0;?></span>
    </div>
    <div class="access am-u-md-4" style="padding-left:158px;padding-top:54px;">
    </div>
</div>

<div class="am-form">
			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	            金额(&yen;)
   		         </div>
       		     <div class="am-u-sm-4 am-u-end cset">
       		       <input type="text" id="id_cash">
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	            备注
   		         </div>
       		     <div class="am-u-sm-4 am-u-end cset">
       		       <input type="text" id="id_info" placeholder="<?php echo $type == 1 ? '如结算500元' : '如充100送20'; ?>">
       		     </div>
			</div>

			<!--
			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	           手机验证码
   		         </div>
       		     <div class="am-u-sm-4 am-u-end cset am-input-group">
       		       <input type="text" id="id_mobilecode" placeholder="验证码将发送至您注册时填写的手机号码">
					 <span class="am-input-group-btn">
        				<button class="am-btn am-btn-default" id="id_send_mobilecode" type="button">发送验证码</button>
				      </span>
       		     </div>
			</div>
			-->

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-md-2 ">
				&nbsp;
				</div>
           		 <div class="am-u-md-2 ">
					<button class="am-btn am-btn-lg am-btn-success cbalance" type=2><i class="am-icon-flash"></i> 充值</button>
				</div>
           		 <div class="am-u-md-2 am-u-end">
					<button class="am-btn am-btn-lg am-btn-danger cbalance" type=1><i class="am-icon-flash"></i> 提现</button>
				</div>
			</div>

</div>

<?php
        $extra_js =  array( 
          $static_path.'/js/balanceuser.js',
    );

echo '<script> var g_phone = "'.UctpayMod::get_current_phone().'";</script>';
echo '<script> var su_uid= "'.$su['uid'].'";</script>';

?>



