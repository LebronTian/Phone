<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit"><!--360优先使用极速核-->
    <meta http-equiv="X-UA-COMPATIBLE" content="chrome=1,IE=Edge"><!--优先谷歌内核，最新ie-->
    <meta http-equiv="Cache-Control" content="no-siteapp"><!--不转码-->
    <!-- Mobile Devices Support @begin 针对移动端设置-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <!-- apple devices -->
    <meta name="apple-mobile-web-app-capable" content="yes"/> <!--启用WebApp全屏模式 -->
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent"/><!-- 顶端状态条 -->
    <meta name="apple-touch-fullscreen" content="yes"><!--全屏显示 -->
    <!-- Mobile Devices Support @end -->
    <title>易贷诚金融</title>
</head>

<!--todo*************************************************************************************************************-->
<style>
body{
/*background-color: #e8fcfc;*/
/*兼容大屏幕，考虑要不要用响应式，去掉中间白边的过程*/
max-width: 600px;
margin: 0 auto;
}
p {
margin: 0;
padding: 0;
}

.form-title {
	background: #b22229;
	color: white;
	padding: 1rem;
	line-height: 1.6;
	text-align: center;
}
.new-color{  background: #b22229;  color: white; }

.form-section {
	position: relative;
}

.form-section a, #id_forgot_passwd {
	font-size: 0.6em;
	text-decoration: underline;
	position: absolute;
	bottom: 16px;
	right: 16px;
	cursor: pointer;
}
    body>header{
        overflow: hidden;
    }
    .form-article .linear-title{
        text-align: right;
    }

.form-article {
	margin-bottom: 60px;
}

body>footer.btn-footer {
/*
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  border-top: thin solid #e1e1e1;
*/
  z-index: 100;
  width: 80%;
  background: white;
  text-align: center;
  max-width: 600px;
  margin: 0 auto;
  margin-top:260px;
}

.btn-footer.footer-one-btn button {
  width: 54%;
  align-items: flex-start;
  text-align: center;
  font-size: 1em;
  line-height: 2rem;
}

.linear-section {
	margin: 10px;
	position: relative;
}

.center {
	text-align: center;
}

.linear-section span {
  font-size: 1em;
  line-height: 2rem;
  width: 20%;
  display: inline-block;
  text-align: right;
  font-weight: bold;
}

.linear-section input{
  font-size: 1em;
  line-height: 1rem;
  height: 1.5rem;
  float: right;
  /*
	width: 72%;*/
  width: 94%;
  display: inline-block;
  margin-top:35px;
  border:0px;
  border-bottom:1px solid gray;
}


#id_send_mobilecode{
	position: absolute;
	right: 0px;
	top:28px;
	z-index: 10;
  font-size: 0.8em;
  line-height: 1.6em;
  height: 2.8em;
/*
  height: 100%;
*/
  padding: 0.5em;
   cursor: pointer;
	background-color:#b22229;
	color:white;
 border:none;
}

</style>
<body>


<article class="form-article btn-footer-margin">
<div class="fix-props2">
	<img src="/app/form/view/daikuan/static/images/logo.jpg" style="height:44px;">	
</div>

<div class="cregister" style="">
<section class="form-section" style="width:100%;margin:0 auto;">
	<p class="form-title clearfix" style="line-height:0.2em;height:0.2em;">快 速 登 录</p>
</section>
    
<section class="linear-section"> 
	<!--<span> 手机:</span> -->
	<input id="id_r_account" placeholder="请输入手机号码" class="remark-input linear-input border-box" type="tel"/>
</section>

<section class="linear-section"> 
	<!--<span> 验证码:</span>-->
	<input id="id_r_mobilecode" style="margin-top:30px;"  placeholder="请输入验证码" class="remark-input linear-input border-box" type="tel"/>
	<button id="id_send_mobilecode">&nbsp; 发送验证码 &nbsp;</button>
</section>

</div>



</div>

</article>


<footer class="btn-footer footer-one-btn">
    <button class="new-color" id="id_commit">登&nbsp;&nbsp;&nbsp;录</button>
</footer>
<div style="bottom:5px;margin:0 auto;margin-top:100px;">
	<p style="text-align:center;color:gray;margin:0 auto;">© 易贷诚金融</p>
</div>

<div style="position:fixed;left:0;top:0;width:100%;height:100%;z-index:99;background:rgba(0,0,0,0.5);display:none;" id="id_qrr">
<img style="width:260px;height:260px;margin:0 auto;display:block;margin-top:100px;" 
src="https://mp.weixin.qq.com/mp/qrcode?scene=10000003&size=102&__biz=MjM5MjM1Mzc3Mg==&mid=2650167322&idx=1&sn=e76178f5cfcfb8bfedf5d5c308ba6b0a&send_time=">
<p style="color:white;text-align:center;margin-top:20px;">恭喜登录成功！ 请长按图片关注我们微信公众号方便下次进入 易贷诚金融 </p>
</div>

<script src="static/js/jquery2.1.min.js"></script>
<script>
<?php
	if(empty($goto_uri)) $goto_uri = requestString('goto_uri', PATTERN_URL);
	#if(!empty(requestString('goto_uri', PATTERN_URL) || empty($goto_uri))) $goto_uri = requestString('goto_uri', PATTERN_URL);
	echo 'var g_goto_uri = '.json_encode($goto_uri).';';
?>
	function do_register() {
		var account = $('#id_r_account').val().trim();
		if(!account) return alert('请填写手机号码');
		var mobilecode = $('#id_r_mobilecode').val().trim();
		if(!mobilecode) return alert('请填写验证码');

		var data = {phone: account,  mobilecode: mobilecode};
		var url, txt;
		url = '?_a=su&_u=ajax.setphone';
		txt = '设置';

		$.post(url, data, function(ret){
			console.log(ret);
			ret = $.parseJSON(ret);
			if(ret.errno > 0) {
				if(ret.errstr=='ERROR_OBJECT_ALREADY_EXIST') {
					return alert('该手机号码已经被使用!');
				}
				return alert(txt + '失败！' + ret.errno);
			}

			$('#id_qrr').show();
			return;

			if(g_goto_uri) {
				(window.location.href = g_goto_uri);
			}
			else {
				alert('恭喜设置成功！');
			}
		});
	}

	$('#id_commit').click(function(){
		do_register();
	});


var g_seconds = 60;
function run_countdown() {
	g_seconds--;
	if(g_seconds <= 0) {
		$('#id_send_mobilecode').text('发送验证码').removeAttr('disabled');
	}
	else {
		$('#id_send_mobilecode').text('请稍候 ' + g_seconds);
		setTimeout('run_countdown()', 1000);
	}
}

$('#id_send_mobilecode').click(function(){
	var account = $('#id_r_account').val().trim();
	if(!account) return alert('请填写手机号码');
	$(this).attr('disabled', 'disabled');
	g_seconds = 60;
	run_countdown();
<?php
if(AccountMod::require_sp_uid() == 578) {
echo '$.get("?_a=express&_u=ajax.mobilecode&phone=" + account, function(ret)';
} else {
echo '$.get("?_a=sp&_u=api.mobilecode&phone=" + account, function(ret)';
}
?>
	{
		console.log(ret);
	});
});

</script>

</body>
</html>
