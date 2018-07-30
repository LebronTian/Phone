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

    <!-- 头部 -->
    <?php 
   /*   include $tpl_path.'/header.tpl'; */
    ?>



    <!-- 主体 -->
    <div class="content" style="margin-top:100px;">
      <p class="logo_s">
      	<!--<img style="width:260px;height:64px;" src="/app/sp/static/images/login-tit.png">-->
      </p>
      <p class="logo_text">商户后台管理系统</p>
      <div class="login_box">
          <div style="position: relative;">
            <input type="text" id="account" placeholder="手机号">
            <span class="phone_icon"></span>
          </div>
          <div style="position: relative;">
            <input type="password" id="password" placeholder="密码">
            <span class="password_icon"></span>
          </div>
          <div style="position: relative;">
            <input type="text" id="verifycode" placeholder="验证码">
            <span class="confirm_icon"></span>
            <span class="code"><img src="?_a=sp&_u=index.verifycode"></span>
          </div>
          <div class="select_area">
            <input type="checkbox" style="width:16px;height:16px;" id="ck_rmbUser"/><label for="">记住密码</label>
            <a href="?_a=sp&_u=index.forget" style="display:none;float:right;margin-right:15px;color:#FFF;">忘记密码？</a>
          </div>
          <div>
              <button class="am-btn login_btn" onclick="Save()">登 录</button>
              <!--<a href="?_a=sp&_u=index.register" class="register_btn">注册</a>-->
          </div>
      </div>
      <p class="img_box"><img src="/app/sp/static/images/login-bj.png"></p>





    </div>
    
    <?php 
    /*  include $tpl_path.'/footer.tpl'; */ 
    ?>

    <div id="info" style="display:none;width:288px;height:30px;background:orange;line-height:30px;text-align:center;color:#FFF;position:fixed;top:0;left:50%;margin-left:-170px;z-index:999;">登录失败！用户名或密码错误！</div>

    


<script src="/static/js/jquery2.1.min.js"></script>
<?php 
include $tpl_path.'/qq.tpl';
?>
<script src="/static/js/amazeui2.1.min.js"></script>
<script src="/static/js/jquery.cookie.js"></script>
<!--
<script type="text/javascript" src="/static/js/login.js"></script>

//-->
<script src="/app/sp/static/js/login.js?1"></script>
<script type="text/javascript" src="/app/web/static/js/header.js"></script>
<script>
<?php
	if(empty($goto_uri)) $goto_uri = requestString('goto_uri', PATTERN_URL);
	#if(!empty(requestString('goto_uri', PATTERN_URL) || empty($goto_uri))) $goto_uri = requestString('goto_uri', PATTERN_URL);
	echo 'var g_goto_uri = '.json_encode($goto_uri).';';
?>

  //记住密码
  function Save() {
        if ($("#ck_rmbUser").is(":checked")) {
            var str_account = $("#account").val();
            var str_password = $("#password").val();
            $.cookie("rmbUser", "true", { expires: 7 }); //存储一个带7天期限的cookie
            $.cookie("account", str_account, { expires: 7 });
            $.cookie("password", str_password, { expires: 7 });
        }
        else {
            $.cookie("rmbUser", "false", { expire: -1 });
            $.cookie("username", "", { expires: -1 });
            $.cookie("password", "", { expires: -1 });
        }
    };
  //判断是否记住密码
    $(document).ready(function(){
    if ($.cookie("rmbUser") == "true") {
        $("#ck_rmbUser").attr("checked", true);
        $("#account").val($.cookie("account"));
        $("#password").val($.cookie("password"));
        }
});

</script>
</body>
</html>
