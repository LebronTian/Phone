<!DOCTYPE html>
<html>
<head>
<meta http-equiv=Content-Type content="text/html;charset=utf-8">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="format-detection" content="telephone=no">
<script>
window.scale=1;
if (window.devicePixelRatio === 2 && window.navigator.appVersion.match(/iphone/gi)) {
    //scale = 0.5;
}
var text = '<meta name="viewport" content="initial-scale=' + scale + ', maximum-scale=' + scale +', minimum-scale=' + scale + ', user-scalable=no" />';
document.write(text);
</script>
<title>确定好友</title>
<link rel="stylesheet" href="/static/css/weui0.42.css" />
<!-- <link href="/static/css/font-awesome-4.6.3/css/font-awesome.min.css" rel="stylesheet">-->
<body style="max-width:640px;margin:0 auto; text-align:center;">
<img style="width:104px;height:104px;border-radius:52px;margin-bottom:50px;margin-top:20px;" 
src="<?php echo $from_su['avatar'] ? $from_su['avatar'] : '/static/images/null_avatar.png'; ?>">
<h2 style=""><?php echo $from_su['name'] ? $from_su['name'] : $from_su['account']; ?></h2>
<p style="color:#888;margin-bottom:25px;">答谢好友邀请，也可以为TA增加积分奖励哦！</p>
<?php
	if($su['from_su_uid']) {
		//echo '<a class="weui_btn weui_btn_default">您已答谢好友'.$su['from_su_uid'].'</a>';
		echo '<a class="weui_btn weui_btn_default">您已答谢好友</a>';
	}
	else {
		echo '<a class="weui_btn weui_btn_primary" id="id_confirm" data-uid="'.$from_su['uid']
				.'">答谢好友邀请</a>';
	}
?>

</body>
<script src="static/js/jquery2.1.min.js"></script>
<script>
$('#id_confirm').click(function(){
	var uid = $(this).attr('data-uid');
	$.post('?_a=qrposter&_u=ajax.confirm_guide', {uid: uid}, function(ret){
		console.log(ret);
		ret = $.parseJSON(ret);
		if(ret && ret.errno ==0) {
			window.location.reload();
		}
		else {
			//alert(ret.errstr);
		}
	});
});
</script>
</html>
