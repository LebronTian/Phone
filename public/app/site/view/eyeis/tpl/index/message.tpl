<?php 
include $tpl_path.'/header.tpl';
?>
<link rel="stylesheet" type="text/css" href="/app/site/view/eyeis/static/css/message.css"> 
<div class="message_box" >
	<input placeholder="您的称呼"  id="name">
	<input placeholder="您的手机或邮箱" id="contact">
	<textarea placeholder="您的留言" id="message"></textarea>
	<button class="msg_save" data-uid="<?php echo $site['sp_uid']?>">确&nbsp;&nbsp;&nbsp;认</button>
</div>


<?php 
include $tpl_path.'/footer.tpl';
?>
<script type="text/javascript" src="/app/site/view/eyeis/static/js/message.js"></script>