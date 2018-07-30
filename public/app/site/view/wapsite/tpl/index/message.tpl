<?php 
include $tpl_path.'/header.tpl';
$k = 'cfg_site_wapsite_setcolor_'.AccountMod::require_sp_uid();
$color = SpExtMod::get_sp_ext_cfg($k);
?>
<link rel="stylesheet" type="text/css" href="/app/site/view/wapsite/static/css/message.css"> 
<div class="message_box" >
	<input placeholder="您的称呼"  id="name">
	<input placeholder="您的手机或邮箱" id="contact">
	<textarea placeholder="您的留言" id="message"></textarea>
	<button class="msg_save"  <?php if(!empty($color)) echo 'style="background-color:#'.$color.'"';?> data-uid="<?php echo $site['sp_uid']?>">确&nbsp;&nbsp;&nbsp;认</button>
</div>


<?php 
include $tpl_path.'/footer.tpl';
?>
<script type="text/javascript" src="/app/site/view/wapsite/static/js/message.js"></script>