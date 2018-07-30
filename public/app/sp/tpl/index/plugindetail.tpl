<?php
#var_export($plugin);
?>
<div class="am-g am-cf">
	<div class="am-fl am-margin">
		<img class="am-thumbnail" src='<?php echo $plugin['thumb'];?>' style="width:400px;height:400px;">
	</div>

	<div class="am-fl am-margin">
		<ul class="am-list am-list-static">
			<li><strong><?php echo $plugin['name'];?></strong></li>
			<li>作者: <?php echo $plugin['author'];?></li>
			<li>版本: <?php echo $plugin['version'];?></li>
			<li>价格: <?php echo $plugin['price'] ? '&yen;'.($plugin['price']/100) : '免费'?></li>
		</ul>
		<?php
			if($plugin['has_installed']) {
				echo '<p><a class="am-btn am-btn-default am-btn-lg" href="?_a='.$plugin['dir'].'&_u=sp">已安装</a></p>';
			}
			else {
				if(SpInviteMod::can_sp_install_plugin($plugin['dir'])) {
					echo '<p><button class="am-btn am-btn-primary am-btn-lg install" data-name="'.$plugin['dir'].'">安装</button></p>';
				}
				else {
					echo '<p class="am-text-warning am-text-lg" style="text-align:center; border: 1px solid #f37b1d; padding: 0 1.6rem 0 1.6em;">
							<span class="am-icon-warning"></span> 您无权安装此插件, 如有需要请联系客服开通安装权限!</p>';
				}
			}
		?>
	</div>

</div>

<div class="am-margin">
<?php echo $plugin['brief'];?>
</div>

<?php
	$extra_js = array('/app/sp/static/js/plugindetail.js');
?>

