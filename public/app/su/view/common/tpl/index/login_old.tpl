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
    <title>登录/注册</title>
</head>

<?php
	uct_use_app('sp');
	$d = SpMod::get_document_by_title('用户登录', AccountMod::require_sp_uid());
	if($d)	{
		echo '<body><div>'.$d['content'].'</div></body>';
		return;
	}
	
?>

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
  width: 76%;
  display: inline-block;
  float: right;
}


#id_send_mobilecode{
	position: absolute;
	right: 0px;
	z-index: 10;
  font-size: 1em;
  line-height: 2rem;
  height: 100%;
   cursor: pointer;
}

</style>
<body>
<article class="form-article btn-footer-margin">

<?php
	$scan_login = '';
	if(!isMobileBrowser()) {
		$scan_login = 'web';
	}
	else {
		if(($uidm = requestString('uidm', PATTERN_UIDM))) {
			$scan_login = 'mobile';
		}

		if(requestString('_scan_login')) {
    		if(AccountMod::has_su_login() || SuMod::require_su_uid(false)) {
				$scan_login = 'mobile';
			}
			else {
				$scan_login = '';
			}
		}
	}

?>

<div class="cscan center" <?php if($scan_login != 'mobile') echo 'style="display: none;"';?>>
<section class="form-section">
	<p class="form-title clearfix">手机扫一扫网页登录</p>
	<section class="linear-section"> 
<?php
	//手机扫一扫
	if($scan_login == 'mobile') {
		if(!$uidm || !AccountMod::has_su_login()) {
			//没登录先登录一下
			if(!requestString('_scan_login')) {
				$_GET['goto_uri'] = (getUrlName().'/?'.http_build_query($_GET));
				//unset($_GET['uidm']);
				$_GET['_scan_login'] = 'mobile';
				$url = getUrlName().'/?'.http_build_query($_GET);
				redirectTo($url);
			}
		}
		else if($su_uid = AccountMod::has_su_login()) {
			$su = AccountMod::get_service_user_by_uid($su_uid); 
			echo ($su['name'] ? $su['name'] : $su['account']).
			'<img src="'.$su['avatar'].'" style="width: 64px; height:64px; margin:5px; border: 0;">';
			uct_use_app('wxcode');
			if(!WxScanloginMod::mobile_scanlogin($su_uid, $uidm)) {
				echo '<h3>二维码已过期, 请重试</h3>';
			}
			else {
				echo '<h3 id="id_scan_confirm" data-id="'.$uidm.'">即将登录网页版, 请点击确定</h3>';
			}
		}
	}
?>
		
	</section>

</section>
	
</div>

<div class="clogin" <?php if($scan_login == 'mobile') echo 'style="display: none;"';?>>
<section class="form-section">
	<p class="form-title clearfix">用户登录</p>
	 <a id="id_go_register">没有账号？点我注册</a>
</section>
    
<div id="id_after_scan_before">
<section class="linear-section"> 
	<span> 账号:</span>
	<input id="id_account" class="remark-input linear-input border-box" placeholder="请输入手机号码" type="text"/>
</section>

<section class="linear-section"> 
	<span> 密码:</span>
	<input id="id_passwd" class="remark-input linear-input border-box" type="password"/>
</section>

<section class="linear-section"> 
	<p style="position:relative;">
	<span> &nbsp;</span>
	<a id="id_forgot_passwd">忘记密码？</a>
	</p>
</section>
</div>

<section class="linear-section center" <?php if($scan_login != 'web') echo 'style="display: none;"';?>> 
<hr>
<p id="id_after_scan" style="display: inline-block; padding: 0 15px 0 15px; font-size:1.5em; line-height: 2em; background-color: #55b725; border-radius: 5px; color: white; cursor: pointer">微信扫一扫登录</p>
<div id="id_after_scan_after" style="display: none;">
<?php
	if($scan_login == 'web') {
		uct_use_app('wxcode');
		if(!($sl = WxScanloginMod::web_get_scanlogin_by_session()) && 
			(!$sl = WxScanloginMod::web_generate_scanlogin_by_session_id())) {
			echo '系统错误！请重试';
		}
		else {
			//var_export($sl);
			if($sl['param']['step'] == WxScanloginMod::SCANLOGIN_STATUS_WAIT_SCAN) {
				$url = getUrlName().'/?_easy=su.common.index.login&uidm='.$sl['uidm'].'&__sp_uid='.AccountMod::require_sp_uid();
				echo '<img src="?_u=index.qrcode&url='.urlencode($url).'" style="width: 300px; height:300px; margin:5px;">';
			}
			else {
				$su = AccountMod::get_service_user_by_uid($sl['param']['su_uid']); 
				echo '<script>var g_scan_step = '.$sl['param']['step'].'</script>';
				echo '<div>'.($su['name'] ? $su['name'] : $su['account']).
					'<img src="'.$su['avatar'].'" style="width: 64px; height:64px; margin:5px;"></div>';
				if($sl['param']['step'] == WxScanloginMod::SCANLOGIN_STATUS_WAIT_CONFIRM) {
					echo '<h3>请在手机上确定登录</h3>';	
				}
				else {
					echo '<h3>您已成功登录</h3>';	
				}
			}
		}
	}
?>
</div>
</section>

</div>

<div class="cregister" style="display:none">
<section class="form-section">
	<p class="form-title clearfix">用户注册</p>
	 <a id="id_go_login">已有账号？马上登录</a>
</section>
    
<section class="linear-section"> 
	<span> 手机:</span>
	<input id="id_r_account" class="remark-input linear-input border-box" type="text"/>
</section>

<section class="linear-section"> 
	<span> 验证码:</span>
	<input id="id_r_mobilecode" class="remark-input linear-input border-box" type="text"/>
	<button id="id_send_mobilecode">发送验证码</button>
</section>

<section class="linear-section"> 
	<span> 密码:</span>
	<input id="id_r_passwd" class="remark-input linear-input border-box" type="password"/>
</section>

<section class="linear-section"> 
	<span> 确认密码:</span>
	<input id="id_r_passwd2" class="remark-input linear-input border-box" type="password"/>
</section>

</div>

</article>


<footer class="btn-footer footer-one-btn">
    <button class="new-color" id="id_commit">立即登录</button>
</footer>


<script src="static/js/jquery2.1.min.js"></script>
<script>
var g_int = 0;
function poll_check_login(time) {
	time = time || 3000;
	if(g_int) return;
	g_int = setTimeout(function(){
		$.post('?_a=wxcode&_u=index.poll_has_su_login', function(ret){
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

<?php
	if(empty($goto_uri)) $goto_uri = requestString('goto_uri', PATTERN_URL);
	#if(!empty(requestString('goto_uri', PATTERN_URL) || empty($goto_uri))) $goto_uri = requestString('goto_uri', PATTERN_URL);
	echo 'var g_goto_uri = '.json_encode($goto_uri).';';
?>
	function do_login() {
		if($('#id_scan_confirm').length) {
			return $('#id_scan_confirm').click();
		}

		var account = $('#id_account').val().trim();
		if(!account) return alert('请填写账号');
		var passwd = $('#id_passwd').val();
		if(!passwd) return alert('请填写密码');

		var data = {account: account, password: passwd};
		$.post('?_a=su&_u=ajax.login', data, function(ret){
			console.log(ret);
			ret = $.parseJSON(ret);
			if(ret.errno > 0) {
				return alert('登录失败！' + ret.errno);
			}
			if(g_goto_uri) {
				(window.location.href = g_goto_uri);
			}
			else {
				alert('登录成功！');
			}
		});
	}

	function do_register() {
		var account = $('#id_r_account').val().trim();
		if(!account) return alert('请填写手机号码');
		var mobilecode = $('#id_r_mobilecode').val().trim();
		if(!mobilecode) return alert('请填写验证码');
		var passwd = $('#id_r_passwd').val();
		if(!passwd) return alert('请填写密码');
		if(passwd != $('#id_r_passwd2').val()) return alert('密码输入不一致');

		var data = {account: account, password: passwd, mobilecode: mobilecode};
		var url, txt;
		if($('#id_commit').text() == '立即注册' ) {
			url = '?_a=su&_u=ajax.register';
			txt = '注册';
		}
		else {
			url = '?_a=su&_u=ajax.resetpasswd';
			txt = '重置密码';
		}

		$.post(url, data, function(ret){
			console.log(ret);
			ret = $.parseJSON(ret);
			if(ret.errno > 0) {
				return alert(txt + '失败！' + ret.errno);
			}

			alert('恭喜'+txt+'成功，请登录！');
			$('#id_go_login').click();
		});
	}

	$('#id_go_register').click(function(){
		$('.clogin').hide();
		$('.cregister').show();
		$('#id_commit').text('立即注册');
		$('.cregister .form-title').text('用户注册');
	});
	$('#id_go_login').click(function(){
		$('.cregister').hide();
		$('.clogin').show();
		$('#id_commit').text('立即登录');
	});
	$('#id_forgot_passwd').click(function(){
		$('.clogin').hide();
		$('.cregister').show();
		$('#id_commit').text('重置密码');
		$('.cregister .form-title').text('重置密码');
	});

	$('#id_commit').click(function(){
		$(this).text() == '立即登录' ? do_login() : do_register();
	});

	$('#id_passwd').keydown(function(e){
		if(e.which == 13) {
			$('#id_commit').click();
		}
	});

	$('#id_scan_confirm').click(function(){
		var uidm = $(this).attr('data-id');
		$.post('?_a=wxcode&_u=index.mobile_scanlogin_confirm&uidm='+uidm, function(ret){
			console.log(ret);
			ret = $.parseJSON(ret);
			if(ret.errno > 0) {
				$('#id_scan_confirm').text('登录失败, 请重试!');
				return alert('登录失败！' + ret.errno);
			}
			$('#id_scan_confirm').text('您已成功登录网页版，请刷新网页');
		});
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
	$.get('?_a=sp&_u=api.mobilecode&phone=' + account, function(ret){
		console.log(ret);
	});
});

$('#id_after_scan').click(function(){
	if(!$('#id_after_scan_after').is(':visible')) {
		$('#id_after_scan_after').show();	
		poll_check_login();
		$('#id_after_scan_before').slideUp();
		if(typeof g_scan_step == 'undefined') {
			return;	
		}
		else if(g_scan_step == 1) {
			$('#id_after_scan').text('扫描成功');
		}
		else {
			$('#id_after_scan').text('登录成功');
		}
	}

	{
		console.log('visible');
		if(typeof g_scan_step == 'undefined') {
			window.location.reload();
			return;
		}
		if(g_scan_step == 2) {
			if(g_goto_uri) {
				(window.location.href = g_goto_uri);
			}
		}
	}
});

if(typeof g_scan_step != 'undefined') {
	$('#id_after_scan').click();
}
</script>

</body>
</html>
