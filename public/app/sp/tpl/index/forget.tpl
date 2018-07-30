<!doctype html>
<html class="no-js">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>UCT微信O2O营销平台- 商户后台管理系统</title>
  <meta name="description" content="UCT微信O2O公众号营销平台 ">
  <meta name="keywords" content="UCT 微信 O2O 公众号 营销 ">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
  <meta name="renderer" content="webkit">
  <meta http-equiv="Cache-Control" content="no-siteapp" />
  <link rel="icon" type="image/png" href="/i/favicon.png">
  <link rel="apple-touch-icon-precomposed" href="/i/app-icon72x72@2x.png">
  <meta name="apple-mobile-web-app-title" content="Amaze UI" />
  
  <link rel="stylesheet" type="text/css" href="/static/css/amazeui2.1.min.css">
  <link rel="stylesheet" type="text/css" href="/app/sp/static/css/forget.css">
 
</head>
<body>

    <!-- 头部 -->
      <div id="headBox">
        <a href="/" class="logo"><img src="/app/web/static/images/blue/logo.png" alt="logo"></a>
            <ul class="headNav">
                
<!--
                <li><a href="#">UCToo产品</a></li>
                <li><a href="#">帮助中心</a></li>
                <li><a href="#">产品体验</a></li>
                <li><a href="#">应用中心</a></li>
-->
                <li><a href="?_a=sp&amp;_u=index.login">登录</a></li>
                <li><a href="#">开发者社区</a></li>
                <li><a href="?_a=web&amp;_u=index.customer">客户案例</a></li>
                <li><a href="?_easy=web.index.service">服务与授权</a></li>
                <li><a href="/">首页</a></li>
            </ul>
    </div>
    <!-- 主体 -->
     <div class="content">
      <p class="logo_s"><img src="/app/sp/static/images/login-tit.png"></p>
      <p class="logo_text">手机验证找回密码</p>

      <div class="login_box">
          <div style="position: relative;">
            <input type="text" id="phone" placeholder="请输入注册手机号">
            <span class="phone_icon"></span>
            <i class="info"><img src="/app/sp/static/images/ok.png"></i>
          </div>
          <div style="position: relative;">
            <input type="text" id="verifycode" placeholder="请输入验证码">
            <span class="confirm_icon"></span>
            <i class="info"><img src="/app/sp/static/images/ok.png"></i>
            <!-- <span class="code"><img src="?_a=sp&_u=index.verifycode"></span> -->
            <input type="button" value="点击发送验证码" id="mobilecode_btn">
          </div>
          <div style="position: relative;">
            <input type="password" id="password" placeholder="请输入新密码">
            <span class="password_icon"></span>
            <i class="info"><img src="/app/sp/static/images/ok.png"></i>
          </div>
          <div style="position: relative;">
            <input type="password" id="password2" placeholder="请再次输入新密码">
            <span class="password_icon"></span>
            <i class="info"><img src="/app/sp/static/images/ok.png"></i>
          </div>
          <div>
              <button class="am-btn register_btn" id="step_02">确认修改</button>
          </div>
      </div>

      <div class="login_box" style="display:none;">
          <div class="success_info">
             恭喜！修改成功！
          </div>
          <div class="success_btn">
              <button class="am-btn register_btn" id="step_03">返回登录</button>
          </div>
      </div>

    </div>
    <!-- 脚部 -->
    <div class="footer">
      <div class="address">
        <div class="address_box">
          <p>深圳市南山区蛇口工业6路9号创新谷</p>
          <p><span>UCToo官方QQ交流群：</span>102324323</p>
          <p><span>Email:</span>contact@uctoo.com</p>
        </div>
        <div class="qrcode_box">
          <img src="/app/sp/static/images/qrcode-b.png">
        </div>
      </div>
    </div>


<script src="/static/js/jquery2.1.min.js"></script>
<script src="/static/js/amazeui2.1.min.js"></script>
<script src="<?php echo $static_path;?>/js/forget.js"></script>
</body>
</html>
