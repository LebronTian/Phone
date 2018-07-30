<div class="am-g am-margin">
<?php
//var_export($service);
echo '<script>var sku_table = '.json_encode($service['sku_table']).';</script>';
if(in_array($service['is_virtual'], array(SpServiceMod::VIRTUAL_RENEW))) {
	$expire = SpLimitMod::get_current_sp_limit('expire_time');
	$type = WeixinPlugMod::get_sp_service_type();
	echo '<p><span class="am-icon-info"></span> 您的账号服务到期时间: <span class="am-text-primary">'.($expire ? date('Y-m-d H:i:s', $expire) : '永久').'</span></p>';
	echo '<p><span class="am-icon-info"></span> 您的服务类型: <span class="am-text-primary">'.$type.'</span></p>';
	echo '<script>var g_sku_type = '.json_encode($type).'; </script>';
}
else if(in_array($service['is_virtual'], array(SpServiceMod::VIRTUAL_SMS_1000))) {
	$remain = SpLimitMod::get_current_sp_limit('sms_remain');
	//$total = SpLimitMod::get_current_sp_limit('sms_total');
	echo '<p><span class="am-icon-info"></span> 您的剩余短信条数: <span class="am-text-primary">'.($remain).
		 '</span>&nbsp;&nbsp;&nbsp&nbsp;<a target="_blank" href="?_a=sms&_u=sp.index">(点击查看详细记录)</a></p>';
}
else if(in_array($service['is_virtual'], array(SpServiceMod::VIRTUAL_QUOTA_PUBLIC_1))) {
	$used = Dba::readOne('select count(*) from weixin_public where sp_uid = '.AccountMod::get_current_service_provider('uid'));
	$max = AccountMod::get_current_service_provider('max_public_cnt');
	//$total = SpLimitMod::get_current_sp_limit('sms_total');
	echo '<p><span class="am-icon-info"></span> 您还可添加公众号数目: <span class="am-text-primary">'.max($max-$used, 0).
		 '</span>&nbsp;&nbsp;&nbsp&nbsp;<a target="_blank" href="?_a=sp&_u=index.publiclist">(点击查看全部公众号)</a></p>';
}
else if(in_array($service['is_virtual'], array(SpServiceMod::VIRTUAL_QUOTA_SUBSP_1))) {
	$used = Dba::readOne('select count(*) from sub_sp where sp_uid = '.AccountMod::get_current_service_provider('uid'));
	$max = SpLimitMod::get_current_max_subsp_cnt();
	//$total = SpLimitMod::get_current_sp_limit('sms_total');
	echo '<p><span class="am-icon-info"></span> 您还可添加子账号数目: <span class="am-text-primary">'.max($max-$used, 0).
		 '</span>&nbsp;&nbsp;&nbsp&nbsp;<a target="_blank" href="?_a=subsp&_u=sp.index">(点击查看全部子账号)</a></p>';
}

?>
	<div class="am-u-sm-2">
		<img class="am-thumbnail" src='<?php echo $service['thumb'];?>' style="width:140px;height:140px;">
	</div>

	<div class="am-u-sm-10 am-form">
			<div class="am-g "><strong><?php echo $service['name'];?></strong></div>
			<hr/>
			<div class="am-g am-margin-top-sm">
				<div class="am-u-sm-1 am-text-right">价格:</div>
				<div class="am-u-sm-10 am-u-end am-text-primary am-text-lg"><?php echo '&yen;<span id="id_price">'.($service['price']/100).'</span>';?></div>
			</div>

			<div class="am-g am-margin-top-sm" <?php if($service['ori_price'] <= $service['price']) echo 'style="display:none;"';?>>
				<div class="am-u-sm-1 am-text-right">原价:</div>
				<div class="am-u-sm-10 am-u-end"><s><?php echo '&yen;<span id="id_ori_price">'.($service['ori_price']/100).'</span>';?></s></div>
			</div>

			<div class="am-g am-margin-top-sm" <?php if($service['is_virtual']) echo 'style="display:none;"';?>>
				<div class="am-u-sm-1 am-text-right">库存:</div>
				<div class="am-u-sm-10 am-u-end "><?php echo ('<span id="id_quantity_limit">'.$service['quantity'].'</span> 件');?></div>
			</div>

			<hr/>
<?php
if($service['sku_table']) {
$html = '<div class="am-g am-margin-top-sm sku_table">';
foreach($service['sku_table']['table'] as $k => $t) {
	$html .= '<div class="am-g"><div class="am-u-sm-1 am-text-right am-pagination"><span class="sku_name">'.$k.'</span>:</div><div class="am-u-sm-10 am-u-end "><ul class="am-pagination">';			
	foreach($t as $tt) {
		$html .= '<li><a href="javascript:;">'.$tt.'</a></li>';
	}
	$html .= '</ul></div></div>';
}
$html .= '</div>';

echo $html;
}
?>

			<div class="am-g am-margin-top-sm">
				<div class="am-u-sm-1 am-text-right">购买<br/>件数: </div>
				<div class="am-u-sm-10 am-u-end" style="width:120px;"><input type="number" id="id_buy_quantity" min="1" max="100" value="1" class=""></div>
			</div>
		<?php
			if(!$service['is_virtual']) {
				$profile = SpMod::get_sp_profile();
				$html = '
				<div class="am-g am-margin-top-sm">
					<div class="am-u-sm-1 am-text-right">收货<br/>地址: </div>
					<div class="am-u-sm-10 am-u-end" style="width:350px;"><input type="text" id="id_address" value="'.($profile['address']).'" class=""></div>
				</div>
				<div class="am-g am-margin-top-sm">
					<div class="am-u-sm-1 am-text-right">姓名: </div>
					<div class="am-u-sm-10 am-u-end" style="width:350px;"><input type="text" id="id_name" value="'.AccountMod::get_current_service_provider('name').'" class=""></div>
				</div>
				<div class="am-g am-margin-top-sm">
					<div class="am-u-sm-1 am-text-right">电话: </div>
					<div class="am-u-sm-10 am-u-end" style="width:350px;"><input type="text" id="id_phone" value="'.AccountMod::get_current_service_provider('account').'" class=""></div>
				</div>
				<div class="am-g am-margin-top-sm">
					<div class="am-u-sm-1 am-text-right">备注: </div>
					<div class="am-u-sm-10 am-u-end" style="width:350px;"><input type="text" id="id_info"  class=""></div>
				</div>
				';

				echo $html;
			}
			echo '<p><button class="am-btn am-btn-primary am-btn-lg install" is_virtual="'.$service['is_virtual'].'" data-uid="'.$service['uid'].'">立即购买</button></p>';
		?>
	</div>

</div>

<hr/>

<div class="am-margin">
<?php echo $service['brief'];?>
</div>

<?php
	$extra_js = array($static_path.'/js/servicedetail.js');
?>

