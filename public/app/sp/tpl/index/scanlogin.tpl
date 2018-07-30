<!doctype html>
<html class="no-js">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>后台管理页面</title>
  <meta name="description" content="微信公众号订阅号服务号精致设计极速开发">
  <meta name="keywords" content="三级分销 分销商城 微信公众号 定制开发 微信营销">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
  <meta name="renderer" content="webkit">
  <meta http-equiv="Cache-Control" content="no-siteapp" />
  <link rel="shortcut icon" href="/favicon.ico"/>
  <link rel="bookmark" href="/favicon.ico"/>
  <meta name="apple-mobile-web-app-title" content="Amaze UI" />
  
  <link rel="stylesheet" type="text/css" href="/static/css/amazeui2.1.min.css">
  <link rel="stylesheet" type="text/css" href="/app/sp/static/css/login.css">
 
</head>
<body style="min-width:1170px;overflow-x:hidden;">

    <!-- 主体 -->
    <div class="content" style="margin-top:50px;height:auto;text-align:center;">
      <p class="logo_s"><img style="width:260px;height:64px;" src="/app/sp/static/images/login-tit.png"></p>
      <p class="logo_text">商户后台管理系统</p>
      <div class="login_box"  style="text-align:center;">
		<div><small style="color:white;">微信扫一扫快捷登陆</small></div>
		<img id="id_qrcode" src="" style="width:288px;height:288px;">
		<div><small style="color:white;">只有绑定过微信号的商户才可使用</small></div>
      </div>
      <p class="img_box" style="padding-top:165px;"><img src="/app/sp/static/images/login-bj.png"></p>
    </div>

    


<script src="/static/js/jquery2.1.min.js"></script>
<script src="/static/js/amazeui2.1.min.js"></script>
<script>
function get_qr_img() {
	$.post('?_a=wxcode&_u=index.uct_sp_scanlogin', function(ret){
		//console.log(ret);
		ret = $.parseJSON(ret);
		if(ret && ret.data && ret.data.img_url) {
			$('#id_qrcode').attr('src', ret.data.img_url);
		}
		else {
			alert('系统错误！请刷新页面！');
		}
	});
}

var g_int = 0;
function poll_check_login(time) {
	time = time || 3000;
	if(g_int) return;
	g_int = setTimeout(function(){
		$.post('?_a=wxcode&_u=index.poll_has_sp_login', function(ret){
			ret = $.parseJSON(ret);
			if(ret && ret.data) {
				window.location.reload();
			}
			else {
				g_int = 0;
				poll_check_login(time);
			}
		});
	}, time);
}

get_qr_img();
poll_check_login();


</script>
</body>
</html>
