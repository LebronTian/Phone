<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">提现</strong> / <small></small></div>
</div>

<div class="ChangeBar">
    <div class="fans am-u-md-4" style="padding-left:20px;">
      <span class="word">账户余额</span>
      <span class="num" id="TodayFans" style=""><?php echo !empty($cfg['cash_remain']) ? ($cfg['cash_remain'] / 100) : 0;?></span>
    </div>
    <div class="attention am-u-md-4">
      <span class="word">已提现</span>
      <span class="num" id="TotalFans" style=""><?php echo !empty($cfg['cash_transfered']) ? ($cfg['cash_transfered'] / 100) : 0;?></span>
    </div>
    <div class="access am-u-md-4" style="padding-left:158px;padding-top:54px;">
    </div>
</div>

<div class="am-form">
			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	            提现金额(&yen;)
   		         </div>
       		     <div class="am-u-sm-4 am-u-end cset">
       		       <input type="text" id="id_cash">
       		     </div>
			</div>

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
	            提现微信号
   		         </div>
       		     <div class="am-u-sm-4 am-u-end cset">
					<?php
					//var_export($cfg);	
					if(!empty($cfg['transfer_info']['open_id'])) {
		$su_uid = Dba::readOne('select su_uid from weixin_fans where open_id = "'.addslashes($cfg['transfer_info']['open_id']).'"');
		$user = Dba::readRowAssoc('select uid, name, avatar from service_user where uid = '.$su_uid);
						echo '<img src="'.$user['avatar'].'" width=64 height=64><span id="id_open_id">'.$user['name']
								.'</span> <a id="id_change" href="javascript:;">修改</a>';
					} 
					else {
						echo '<a id="id_change" href="javascript:;">修改</a>';
					}
       		       //<input type="text" id="id_open_id">
					?>
       		     </div>
			</div>

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

			<div class="am-g am-margin-top-sm">
           		 <div class="am-u-sm-2 am-text-right">
					<p><button class="am-btn am-btn-lg am-btn-primary save">确定</button></p>
				</div>
			</div>

</div>

<?php
        $extra_js =  array( 
          $static_path.'/js/transfer.js',
    );

echo '<script> var g_phone = "'.UctpayMod::get_current_phone().'";</script>';

?>



