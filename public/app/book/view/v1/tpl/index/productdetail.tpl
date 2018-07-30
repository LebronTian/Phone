<?php
	$url = trim(strip_tags($product['content']));
	if(preg_match(PATTERN_FULLURL, $url)) {
		//wx articles url
		$url = str_replace(array('&amp;'), array('&'), $url);
		redirectTo($url);
	}
?>
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
<title><?php echo $product['title'];?></title>
<link rel="stylesheet" href="/static/css/weui0.42.css" />
<!-- <link href="/static/css/font-awesome-4.6.3/css/font-awesome.min.css" rel="stylesheet">-->
<body style="max-width:640px;margin:0 auto; text-align:center;">
<?php echo $product['content'];?>
</body>
</html>
