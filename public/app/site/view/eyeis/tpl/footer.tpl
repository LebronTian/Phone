<?php
$parents = SiteMod::get_site_cats(array('site_uid' => $site['uid'], 'parent_uid' => 0));
$k = 'cfg_site_eyeis_setcolor_'.AccountMod::require_sp_uid();
$color = SpExtMod::get_sp_ext_cfg($k);
?>

	<div class="footer" <?php if(!empty($color)) echo 'style="background-color:#'.$color.'"';?> >
			<div><a href="/?_a=site&sp_uid=<?php echo $site['sp_uid']?>"><img src="/app/site/view/eyeis/static/images/home.png"></a></div>
			<div><a href="tel:<?php echo $site['phone']?>"><img src="/app/site/view/eyeis/static/images/phone.png"></a></div>
			<div><a href="/?_a=site&sp_uid=<?php echo $site['sp_uid']?>&_u=index.map"><img src="/app/site/view/eyeis/static/images/map.png"></a></div>
			<div><a class="all_share add_box" data-img="<?php echo $site['logo']?>" data-title="<?php echo $site['title']?>" data-url="/?_a=site&sp_uid=<?php echo $site['sp_uid']?>"><img src="/app/site/view/eyeis/static/images/share.png"></a></div>
			<div><a href="/?_a=site&sp_uid=<?php echo $site['sp_uid']?>&_u=index.message"><img src="/app/site/view/eyeis/static/images/message.png"></a></div>
	</div>
</body>
<script src="/static/js/jquery2.1.min.js"></script>
<script src="/app/site/view/eyeis/static/js/style.js"></script>
<script type="text/javascript">
	console.log("<?php echo $site['stat_code']?>")
</script>
</html>