
<div class="am-cf am-padding">
	<div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">
	<div class="am-fl am-cf" id="edit-id" <?php if(!empty($product)) echo 'data-id="'.$product['uid'].'"'; ?>>
			<strong class="am-text-primary am-text-lg">  <?php echo(!empty($product) ? '编辑' : '添加')?>配送员订单</strong> /
	</div>
		</strong> </div>
</div>

<div class="am-form">
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			配送员ID
		</div>
		<div class="am-u-sm-8 am-u-end">
			<input type="text" id="su_uid" <?php if(!empty($product['su_uid'])) echo 'value="'.$product['su_uid'].'"';?>>
		</div>
	</div>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			订单编号
		</div>
		<div class="am-u-sm-8 am-u-end">
			<input type="text" id="order_uid" <?php if(!empty($product['order_uid'])) echo 'value="'.$product['order_uid'].'"';?>>
		</div>
	</div>


	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			&nbsp;
		</div>
		<div class="am-u-sm-8 am-u-end">
			<p><button class="am-btn am-btn-lg am-btn-primary save">保存</button></p>
		</div>
	</div>

</div>

<?php

$extra_js =  array(
		'/app/su/static/js/adddelivery.js',
);
?>


