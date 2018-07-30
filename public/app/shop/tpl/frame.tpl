<!doctype html>
<html class="no-js" style="font-size: 62.5%">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>商户后台管理系统</title>
  <meta name="description" content="UCT微信公众号大师">
  <meta name="keywords" content="UCT 商城">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
  <meta name="renderer" content="webkit">
  <meta http-equiv="Cache-Control" content="no-siteapp" />
  <link rel="icon" type="image/png" href="/i/favicon.png">
  <!--<link rel="apple-touch-icon-precomposed" href="/i/app-icon72x72@2x.png">-->
  <meta name="apple-mobile-web-app-title" content="Amaze UI" />
  <link rel="stylesheet" href="/static/css/amazeui2.1.min.css"/>
<!--  <link rel="stylesheet" href="http://cdn.amazeui.org/amazeui/2.7.2/css/amazeui.css"/>-->
  <link rel="stylesheet" href="/app/sp/static/css/index.css"/>
  <link rel="stylesheet" type="text/css" href="/app/sp/static/css/jquery.pagewalkthrough.css">
</head>
<body>
<style>
	.am-btn{font-size: 0.6em;}

</style>
<div class="am-cf" style="min-height:600px;">
<header class="am-topbar admin-header" id="header_bar">

<div style="width:100%;height:100%"></div>

<div class="am-topbar-brand">
    <a href="?_a=shop&_u=admin"><strong style="color: #5b9bd1;">入驻商家后台
</strong> <small></small></a>
</div>

<div class="am-collapse am-topbar-collapse" id="topbar-collapse">
	<ul class="am-nav am-nav-pills am-topbar-nav am-topbar-right admin-header-list" sp_uid="<?php echo AccountMod::require_sp_uid();?>">
      <li class="am-dropdown" data-am-dropdown>
        <a class="am-dropdown-toggle" data-am-dropdown-toggle href="javascript:;">
          <span class="am-icon-user"></span> <?php

        if (!($biz_uid = $_SESSION['admin_login']) && !in_array($GLOBALS['_UCT']['ACT'], array('login')))
        {
            redirectTo('?_a=shop&_u=admin.login');
        }

        $biz = ShopBizMod::get_shop_biz_by_uid($biz_uid);
			echo @$biz['title'];
 
			?></a>
		  </li>

          <li><a href="?_a=shop&_u=admin.logout"><span class="am-icon-power-off"></span> 退出</a></li>
        </ul>
      </li>
	</ul>
<!---->


</div>
</header>
	<!--基础框架-->
	<script src="/static_seajs/public_toolkit/jquery/jquery2.1.min.js"></script>
	<script src="/static_seajs/public_toolkit/cookie/jquery.cookie.js"></script>
    <script src="/static_seajs/public_toolkit/amazeui/amazeui2.1.min.js"></script>
	<!--	<script src="//cdn.amazeui.org/amazeui/2.7.2/js/amazeui.min.js"></script>-->
	<script src="/static_seajs/js/tip.js"></script>
    <!--seajs-->
    <script>
        var path_option = {
            'static':<?php echo(!empty($static_path)? json_encode($static_path):"null")?>,
        'tpl':<?php echo(!empty($tpl_path)? json_encode($tpl_path):"null")?>
        };
    </script>
	<script>

	</script>
	<script src="/static_seajs/public_toolkit/seajs/sea.js"></script>
	<script src="/static_seajs/public_toolkit/seajs/seajs-css.js"></script>
	<script src="/static_seajs/public_toolkit/seajs/seajs-preload.js"></script>
	<script src="/static_seajs/js/seajs-option.js"></script>
    <?php
    if(!empty($view_path)) {
    $_file = (is_array($view_path) ? array_pop($view_path) : $view_path);
    if(file_exists($_file)) {
    include($_file);
    }
    else {
    echo 'warning! tpl file not found! '.substr($_file, strlen(UCT_PATH));
    }
    }
    ?>
    <?php
	if(!empty($extra_js)) {
		if(!is_array($extra_js)) {
			$extra_js = array($extra_js);
		}
		foreach($extra_js as $j) {
			if(!empty($GLOBALS['_UCT']['TPL']) && !file_exists(UCT_PATH.$j)) {
				$j = str_replace(DS . 'app' . DS . $GLOBALS['_UCT']['APP'] . DS . 'view' . DS . $GLOBALS['_UCT']['TPL'] . DS . 'static',
								DS . 'app' . DS . $GLOBALS['_UCT']['APP'] . DS . 'static', $j);
			}

			echo '<script src="'.$j.'"></script>';
    }
    }
    ?>
<script>
    $(document).ready(function () {
        $(".change-public").click(function () {
            var uid = $(this).data("uid");
            if(uid){
                $.post("?_a=sp&_u=api.change_weixin",{uid:uid}, function (ret) {
					//console.log(ret);
                    window.location.reload()
                })
            }
        });

		$('#header_bar .am-dropdown').mouseenter(function(){
						$(this).dropdown('open');
            $(this).siblings('li').dropdown('close');
		});
		$('#header_bar .am-dropdown').mouseleave(function(){
//			$(this).dropdown('toggle');
		});
    });
    //分页的
    $('.pagination_page').on('change',function(){
        url = $(this).data('url')+parseInt($(this).val()-1);
        window.location.href=url
    })

    $('.pagination_page').on('keypress',function(){
        var page = $(this).val()
        var width = (25+page.length*10) + 'px'
        $('.pagination_page').css('width',width.toString())
    })
    $(function () {
        $('.pagination_page').keypress()
    })

</script>


</div>


</body>
</html>
