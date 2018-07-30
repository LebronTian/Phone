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
    <title>填写手机</title>
</head>

<!--todo*************************************************************************************************************-->
<style>
body{
background-color: #e8fcfc;
/*兼容大屏幕，考虑要不要用响应式，去掉中间白边的过程*/
max-width: 600px;
margin: 0 auto;
}
p {
margin: 0;
padding: 0;
}

.form-title {
	background: #10b2ac;
	color: white;
	padding: 1rem;
	line-height: 1.6;
	text-align: center;
}
.new-color{  background: #10b2ac;  color: white; }

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
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  z-index: 100;
  width: 100%;
  border-top: thin solid #e1e1e1;
  background: white;
  text-align: center;
  max-width: 600px;
  margin: 0 auto;
}

.btn-footer.footer-one-btn button {
  width: 94%;
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
  line-height: 2rem;
  height: 2rem;
  width: 72%;
  display: inline-block;
  float: right;
}


#id_send_mobilecode{
	position: absolute;
	right: 0px;
	z-index: 10;
  font-size: 1em;
/*
  line-height: 2rem;
  height: 100%;
*/
   cursor: pointer;
}

</style>
<body>
<article class="form-article btn-footer-margin">

<div class="cregister" style="">
<section class="form-section">
	<p class="form-title clearfix">设置手机号码</p>
</section>
    
<section class="linear-section"> 
	<span> 手机:</span>
	<input id="id_r_account" class="remark-input linear-input border-box" type="text"/>
</section>

<section class="linear-section" style="margin-top:15px;"> 
	<span> 验证码:</span>
	<input id="id_r_mobilecode" class="remark-input linear-input border-box" type="text"/>
	<button id="id_send_mobilecode">发送验证码</button>
</section>

</div>



</div>

</article>


<footer class="btn-footer footer-one-btn">
    <button class="new-color" id="id_commit">设置</button>
</footer>


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
