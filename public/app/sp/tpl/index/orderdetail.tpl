<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">服务订单</strong> / <small></small></div>
</div>

<?php
	#var_export($order);
?>

<div class="am-padding am-g">

<div class="am-u-sm-3">
	<p><a target="_blank" href="?_a=sp&_u=index.servicedetail&uid=<?php echo $order['service_uid']?>">
	<strong><?php echo $order['service']['name'] .' X '.(!empty($order['service']['quantity']) ? $order['service']['quantity'] : 1)?></strong>
	<img style="max-width:400px;max-height:400px;" src="<?php echo $order['service']['main_img'];?>">
	</a></p>

	<p>下单时间: <strong><?php echo date('Y-m-d H:i:s', $order['create_time']);?></strong></p>
	<p>下单金额: <strong class="am-text-warning am-text-lg">&yen;<?php echo ($order['paid_fee']/100);?></strong></p>
	<?php
		if(!empty($order['service']['sku_uid'])) {
			echo '<p>'.str_replace(';', ' ', strchr($order['service']['sku_uid'], ';')).'</p>';
		}
	?>
</div>

<div class="am-u-sm-3">
	<?php 
		if($order['status'] == SpServiceMod::ORDER_WAIT_USER_PAY) {
			echo '<p><a class="am-btn am-btn-lg am-btn-primary" target="_blank" href="?_a=pay&oid=a'.$order['uid']
				.'"><i class="am-icon-shopping-cart"></i> 去支付</a>
			 	<button class="am-btn am-btn-lg" id="id_cancel">取消订单</button></p>';
		}
		else if(in_array($order['status'], array(SpServiceMod::ORDER_DELIVERY_OK, SpServiceMod::ORDER_WAIT_FOR_DELIVERY, 
				SpServiceMod::ORDER_WAIT_USER_RECEIPT))) {
			echo '<p><button class="am-btn am-btn-lg am-btn-success"><span class="am-icon-check"></span> 已付款</button></p>
				  <p>付款时间: <strong>'.date('Y-m-d H:i:s', $order['paid_time']).'</strong></p> 
			  	  <p>付款方式: ';
				if($order['pay_type'] == SpServiceMod::PAY_TYPE_WEIXINPAY) {
					echo '<button class="am-btn am-btn-primary am-btn-sm"><span class="am-icon-weixin"></span> 微信支付</button>';
				}
				if($order['pay_type'] == SpServiceMod::PAY_TYPE_ALIPAY) {
					echo '<button class="am-btn am-btn-primary am-btn-sm"><span class="am-icon-shield"></span> 支付宝</button>';
				}
				else if($order['pay_type'] == SpServiceMod::PAY_TYPE_TESTPAY) {
					echo '<button class="am-btn am-btn-primary am-btn-sm"><span class="am-icon-money"></span> 测试支付</button>';
				}
				else {
					echo '未知';
				}
			echo '</p>';
		}
	?>
</div>

<div class="am-u-sm-3">
<?php
	if(!empty($order['service']['address']['address'])) {
		echo '<p>收货地址： <strong>'.htmlspecialchars($order['service']['address']['address']).'</strong></p>';
	}
	if(!empty($order['service']['address']['name'])) {
		echo '<p>姓名： <strong>'.htmlspecialchars($order['service']['address']['name']).'</strong></p>';
	}
	if(!empty($order['service']['address']['phone'])) {
		echo '<p>电话： <strong>'.htmlspecialchars($order['service']['address']['phone']).'</strong></p>';
	}
	if(!empty($order['service']['address']['info'])) {
		echo '<p>备注： <strong>'.htmlspecialchars($order['service']['address']['info']).'</strong></p>';
	}
?>
</div>

<div class="am-u-sm-3">
	<?php 
	if($order['status'] == SpServiceMod::ORDER_WAIT_FOR_DELIVERY) {
		echo '<p><button class="am-btn am-btn-lg am-btn-danger">待发货</button></p>';
	}
	else if($order['status'] == SpServiceMod::ORDER_WAIT_USER_RECEIPT) {
		echo '<p><button class="am-btn am-btn-secondary am-btn-lg cdoreceipt" data-id="'.$order['uid'].'">确认收货</button></p>';
	}
	else if($order['status'] == SpServiceMod::ORDER_DELIVERY_OK) {
		echo '<p><button class="am-btn am-btn-lg" >已收货</button></p>';
	}

	if(!empty($order['service']['recv_time'])) {
		echo '<p>收货时间： <strong>'.date('Y-m-d H:i:s', $order['service']['recv_time']).'</strong></p>';
	}
	if(!empty($order['service']['send_time'])) {
		echo '<p>发货时间： <strong>'.date('Y-m-d H:i:s', $order['service']['send_time']).'</strong></p>';
	}
	if(!empty($order['service']['delivery_info'])) {
		foreach($order['service']['delivery_info'] as $k => $v) {
			echo '<p>'.htmlspecialchars($k).'： <strong>'.htmlspecialchars($v).'</strong></p>';
		}
	}
	?>
</div>

</div>


<div class="am-modal am-modal-confirm" tabindex="-1" id="my-confirm-receipt">
  <div class="am-modal-dialog">
    <div class="am-modal-hd">确认收货</div>
    <div class="am-modal-bd">
      要确认收货吗？
    </div>
    <div class="am-modal-footer">
      <span class="am-modal-btn" data-am-modal-confirm>确定</span>
      <span class="am-modal-btn" data-am-modal-cancel>取消</span>
    </div>
  </div>
</div>

<!--
<div class="am-modal am-modal-alert" tabindex="-1" id="id_modal_weixin_pay">
  <div class="am-modal-dialog">
    <div class="am-modal-hd">请使用微信扫描二维码进行支付
	<a href="javascript:;" class="am-close am-close-spin" data-am-modal-close>&times;</a></div>
    <div class="am-modal-bd">
		<img id="id_weixin_pay_qrcode" style="width:200px;height:200px;" />
    </div>
    <div class="am-modal-footer">
		<a class="am-btn am-btn-lg am-btn-success" id="id_weixin_pay_over">支付完成</a>
		<a class="am-btn am-btn-lg am-btn-danger cls_weixin_pay_error"><span class="am-icon-warning"></span> 支付遇到问题</a>
    </div>
  </div>
</div>
 -->

<?php
	echo '<script>var g_uid = '.$order['uid'].';</script>';
	$extra_js = array('/app/sp/static/js/orderdetail.js');
?>
