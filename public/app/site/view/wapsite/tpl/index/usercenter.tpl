<?php 
include $tpl_path.'/header.tpl';
?>
<style>
	.user_box{position:relative;width:100%;height:200px;}
	.user_bg_img{width:100%;height:200px;z-index:-1;}
	.user_avatar_box{position:absolute;width:100%;top:65px;text-align:center}
	.username{position:absolute;width:100%;top:155px;text-align:center;color:#333333}
	.operate_box{width:90%;margin:50px 5% 0 5%;padding-bottom:50px;}
	.operate_box>div{width:33.3%;float:left;}
	.operate_img_box{text-align:center;height:40px;margin-bottom:5px;}
	.operate_img_box>img{width:40px}
</style>
<div class="user_box">
	<img class="user_bg_img" src="/app/site/view/wapsite/static/images/user_bg.png">
	<div class="user_avatar_box">
		<img src="/app/site/view/wapsite/static/images/user_avatar.png" style="width:80px;">
	</div>
	<div class="username">
		风尚设计
	</div>
</div>

<div class="operate_box">
	<div>
		<a class="setting">
			<div class="operate_img_box"><img src="/app/site/view/wapsite/static/images/setting.png"></div>
			<div style="text-align:center">会员设置</div>
		</a>
	</div>
	<div>
		<a class="netmsg">
			<div class="operate_img_box"><img src="/app/site/view/wapsite/static/images/netmsg.png"></div>
			<div style="text-align:center">站内信息</div>
		</a>
	</div>
	<div>
		<a class="recent">
			<div class="operate_img_box"><img src="/app/site/view/wapsite/static/images/recent.png"></div>
			<div style="text-align:center">最近浏览</div>
		</a>
	</div>


</div>





<?php 
include $tpl_path.'/footer.tpl';
?>