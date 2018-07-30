<link rel="stylesheet" href="/static/css/select_user.css"/>
<div class="am-cf am-padding">
	<div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">
	<div class="am-fl am-cf" id="edit-id" <?php if(!empty($d_order)) echo 'data-id="'.$d_order['uid'].'"'; ?>>
			<strong class="am-text-primary am-text-lg">  <?php echo(!empty($d_order) ? '编辑' : '添加')?>配送员订单</strong> /
	</div>
		</strong> </div>
</div>

<div class="am-form">
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			配送员ID
		</div>
		<div class="am-u-sm-4 am-u-end">
			<div id="id_user" <?php if(!empty($d_order['su_uid'])) echo 'data-uid="'.$d_order['su_uid'].'"';?>>
				<img style="width:64px;height:64px;" src="<?php if(!empty($d_order['name'])) echo $d_order['avatar'];else echo '/static/images/null_avatar.png' ?>"> <span><?php if(!empty($d_order['name'])) echo $d_order['name'];?></span>
			</div>
		</div>
	</div>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			订单编号
		</div>
		<div class="am-u-sm-8 am-u-end">
			<input type="text" id="order_uid" <?php if(!empty($d_order['order_uid'])) echo 'value="'.$d_order['order_uid'].'"';?>>
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
		  '/static/js/select_group_user.js',
		'/app/shop/static/js/adddelivery.js',
);
?>
<script>
	var g_uid = <?php echo $g_uid; ?>;
</script>

