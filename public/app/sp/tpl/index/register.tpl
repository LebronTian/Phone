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
    <link rel="stylesheet" type="text/css" href="/app/sp/static/css/register.css">
    <style>
        .am-ucheck-icons{ color: #FFF;}
    </style>

</head>
<body style="overflow-x:hidden;">
<div class="err_info">注册失败！</div>
<!-- 头部 -->
<?php
include $tpl_path.'/header.tpl';
?>
<!-- 主体 -->
<div class="content" style="margin-top:50px;">
    <p class="logo_s"><img src="/app/sp/static/images/login-tit.png"></p>
    <p class="logo_text">商户后台管理系统</p>
    <div class="login_box">
        <div>
            <input type="text" id="invitecode" placeholder="请输入邀请码">
            <span class="confirm_icon"></span>
            <i class="info invitcode_info"><img src="/app/sp/static/images/ok.png"></i>

            <div class="get_code">获取邀请码</div>

            <div class="get_tip">
                <img class="company_code" src="?_a=wxcode&_u=index.uct_invite_code">
                <p>扫一扫<br>获取邀请码</p>
            </div>
        </div>
        <div>
            <input type="text" disabled="disabled" id="account" placeholder="请输入手机号">
            <span class="phone_icon"></span>
            <i class="info"><img src="/app/sp/static/images/ok.png"></i>
        </div>
        <div>
            <input type="text" disabled="disabled" id="mobilecode" placeholder="请输入验证码">
            <span class="confirm_icon"></span>
            <i class="info"><img src="/app/sp/static/images/ok.png"></i>
            <!-- <span class="code"><img src="?_a=sp&_u=index.verifycode"></span> -->
            <input type="button" disabled="disabled" value="点击发送验证码" id="mobilecode_btn">
        </div>
        <div>
            <div class="is_select" id="private_user" data-type="1">个人用户</div>
            <div class="un_select" id="company_user" data-type="2">企业用户</div>
        </div>
        <div>
            <input type="text" disabled="disabled" id="name" placeholder="请输入用户名或公司名">
            <span class="account_icon"></span>
            <i class="info"><img src="/app/sp/static/images/ok.png"></i>
        </div>

        <div>
            <input type="password" id="password" disabled="disabled" placeholder="请输入密码">
            <span class="password_icon"></span>
            <i class="info"><img src="/app/sp/static/images/ok.png"></i>
        </div>
        <div>
            <input type="password" id="password2" placeholder="请再次输入密码" disabled="disabled">
            <span class="password_icon"></span>
            <i class="info"><img src="/app/sp/static/images/ok.png"></i>
        </div>


        <div>
            <label class="am-checkbox">
                <input type="checkbox" id="checkbox_btn" value="" data-am-ucheck> 已阅读<a href="?_easy=web.index.statement&statement=1" target="_blank" style="color:#FFF;">免责声明</a>
            </label>
        </div>


        <div>
            <button class="am-btn register_btn" disabled="disabled">注 册</button>
            <a href="?_a=sp&_u=index.login" class="login_btn">返回登录</a>
        </div>

    </div>
</div>
<div style="clear:both;"></div>
<p class="foot_text">深圳市南山区蛇口工业6路 9 号创新谷</p>
<p class="foot_text">UCTphp 官方 QQ 交流群：555148900 Email：lhliu@uctphp.com</p>


<script src="/static/js/jquery2.1.min.js"></script>
<script type="text/javascript" src="/app/web/static/js/header.js"></script>

<?php
include $tpl_path.'/qq.tpl';
?>

<script src="/static/js/amazeui2.1.min.js"></script>
<script src="<?php echo $static_path;?>/js/register.js"></script>
</body>
</html>
