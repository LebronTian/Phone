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
<title>欢迎关注公众号</title>
<link rel="stylesheet" href="/static/css/weui0.42.css" />
<!-- <link href="/static/css/font-awesome-4.6.3/css/font-awesome.min.css" rel="stylesheet">-->
<body style="max-width:640px;margin:0 auto; text-align:center;">
<script>
	var qrcode_url = '<?php echo $qrcode_url = $public['qrcode_url'] ? $public['qrcode_url'] : 
						'http://open.weixin.qq.com/qr/code/?username='.$public['origin_id'];?>';
</script>
<h2 style=""><?php echo $public['public_name']; ?></h2>
<h2 style=""><?php echo $public['weixin_name']; ?></h2>
<p style="color:#888;margin-bottom:25px;"><?php echo $public['weixin_brief'];?></p>
<a class="weui_btn weui_btn_primary" id="id_confirm">请长按二维码或者搜索微信号关注</a>
</body>
<script>
function showImg(url) {  
var frameid = 'frameimg' + Math.random();  
window.img = '<img id="img" style="width:100%;height:100%;" src=\'' + url + '?' + Math.random() +
 '\' /><script>window.onload = function() { parent.document.getElementById(\'' +
 frameid + '\').height = document.getElementById(\'img\').height+\'px\'; }<' + 
'/script>';  
document.write('<iframe id="' + frameid + 
'" src="javascript:parent.img;" frameBorder="0" scrolling="no" style="width:240px;height:240px;"></iframe>');  
} 
  
<?php
	//if(1 || (isset($_REQUEST['from_su_uid']) && ($_REQUEST['from_su_uid'] == 112136))) {
	//微信地址不能直接显示，会提示 该图片来自微信，无法引用
	if(stripos($qrcode_url, 'mmbiz') == false) {
		//echo 'qrcode_url = "http://mmbiz.qpic.cn/mmbiz_jpg/hM6hPdpabHiaN7hic0icdNVjn2rbbaBrU9j4MnGSZgWLynm1e7LQU9k57k97SjQJ07Ja4IGyo5vQnxoVakylSEctg/0?0.4513119252826572";';
		echo 'document.write(\'<img src="\'+qrcode_url+\'" style="width:240px;height:240px">\');';
	}
	else {
		echo 'showImg(qrcode_url);  ';
	}
?>
//showImg(qrcode_url);  
</script>
</html>
