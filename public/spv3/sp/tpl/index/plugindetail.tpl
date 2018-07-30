<?php
//部分商家隐藏价格
if(in_array(AccountMod::get_current_service_provider('parent_uid'), array(1064, 1072))) {
$plugin['price'] = 0;
if(!empty($plugin['sku_table']['info'])) {
foreach($plugin['sku_table']['info'] as $k => $v) {
	$plugin['sku_table']['info'][$k]['price'] = 0;
}
}
} 

#var_export($plugin);
if($p = WeixinPlugMod::is_plugin_installed($plugin)) {
$plugin = array_merge($plugin, $p);
}

echo '<script>var sku_table = '.json_encode(!empty($plugin['sku_table']) ? $plugin['sku_table'] : array()).';</script>';
?>
<div class="plugindetail">
	<div class="am-g am-cf plugindetail-header">
		<div class="am-fl am-margin plugindetail-header-img">
			<img class="am-thumbnail mb0" src='<?php echo $plugin['thumb'];?>'>
		</div>
		<div class="am-fl am-margin">
			<ul class="sku_table">
				<li class="plugin-title"><?php echo $plugin['name'];?></li>
				<li  class="plugin-detail"><?php if(!empty($plugin['brief_short'])) echo $plugin['brief_short'];?></li>
				<li  class="plugin-price">服务价格： <span>￥</span> <span id="id_price">
<?php
if(!empty($plugin['sku_table']['info'])) {
$min = min(array_column(array_values($plugin['sku_table']['info']), 'price'));
$max = max(array_column(array_values($plugin['sku_table']['info']), 'price'));
echo ($min/100).' - &yen; '.($max/100);
} else {
echo $plugin['price']/100;
}
//488.00 - ￥688.00
?></span></li>
				<li  class="plugin-time sku_name">应用版本：
					<div class="am-btn-group doc-js-btn-1" data-am-button>
					  <label class="am-btn">
					    <input type="radio" name="options" value="6个月" id="option1"> 6个月
					  </label>
					  <label class="am-btn">
					    <input type="radio" name="options" value="1年" id="option2"> 12个月
					  </label>
					</div>
				</li>
				<!-- <li>作者: <?php echo $plugin['author'];?></li>
				<li>版本: <?php echo $plugin['version'];?></li>
				<li>价格: <?php echo $plugin['price'] ? '&yen;'.($plugin['price']/100) : '免费'?></li> -->
			</ul>
<?php
if($plugin['has_installed']) {
	if($plugin['expire_time'] > 0) {
		echo '<p><a class="am-btn am-btn-warning am-btn-lg cgopay" data-name="'.$plugin['dir'].'" >续费</a></p>';
	} 

	echo '<p>插件到期时间：'.($plugin['expire_time'] ? date('Y-m-d H:i:s', $plugin['expire_time']) : '长期').'</p>';

	echo '<p><a class="am-btn am-btn-default am-btn-lg" href="?_a='.$plugin['dir'].'&_u=sp">进入</a></p>';
			}
			else {
				if(SpInviteMod::can_sp_install_plugin($plugin['dir'])) {
					echo '<p><button class="am-btn am-btn-primary am-btn-lg install" data-name="'.$plugin['dir'].'">立即使用</button></p>';
					//直接点一下立即安装
					if(1) {
						WeixinPlugMod::install_a_plugin($plugin);	
						echo '<script>window.location.reload();</script>';
						exit();
					}
				}
				else {
					if($plugin['price']) {
					echo '<p><a class="cgopay am-btn am-btn-warning am-btn-lg install2" data-name="'.$plugin['dir'].'" href2="?_a=sp&_u=index.servicedetail&uid=8&dir='.$plugin['dir'].'">付费开通</a></p>';
					} else {
					echo '<p class="am-text-warning am-text-lg" style="text-align:center; border: 1px solid #f37b1d; padding: 0 1.6rem 0 1.6em;">
							<span class="am-icon-warning"></span> 如需开通请联系客服!</p>';
					}
				}
			}
		?>
	</div>

</div>

	<div class="am-tabs" data-am-tabs>
	  <ul class="am-tabs-nav am-nav am-nav-tabs">
	    <li class="am-active"><a href="#tab1">应用详情</a></li>
	    <!-- <li><a href="#tab2">等候</a></li> -->
	  </ul>

	  <div class="am-tabs-bd">
	    <div class="am-tab-panel am-fade am-in am-active" id="tab1">
	      <?php echo $plugin['brief'];?>
	    </div>
	    <!-- <div class="am-tab-panel am-fade" id="tab2">
	      走在忠孝东路<br>徘徊在茫然中<br>在我的人生旅途<br>选择了多少错误<br>我在睡梦中惊醒<br>感叹悔言无尽<br>恨我不能说服自己<br>接受一切教训<br>让生命去等候<br>等候下一个漂流<br>让生命去等候<br>等候下一个伤口
	    </div> -->
	  </div>
	</div>
</div>

<?php
	$extra_js = array($static_path.'/js/plugindetail.js');
?>

