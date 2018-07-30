<!doctype html>
<html class="no-js" style="font-size: 62.5%">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>公众号大师- 商户后台管理系统</title>
  <meta name="description" content="UCT微信公众号大师">
  <meta name="keywords" content="UCT 微信 O2O 公众号 营销 自媒体 大师 商城 电商 分销商城 微店">
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
    <a href="?_a=sp"><strong>快马加鞭
</strong> <small></small></a>
</div>

<div class="am-collapse am-topbar-collapse am-topbar-left">
	<ul class="am-nav am-nav-pills am-topbar-nav">
		<li <?php if($GLOBALS['_UCT']['APP'] == 'sp') { echo 'class="am-active"';} ?>><a href="?_a=sp">首页</a></li>

<?php
	if(SpMod::has_weixin_public_set()) {
	$hm = SpMod::get_sp_header_menu();
	$html = '';
	foreach($hm as $h) {
		if(empty($h['menu'])) {
			continue;
		}
		if(empty($_REQUEST['_d']) && ($h['name'] == '公众号') &&
			!strncmp('fk_', WeixinMod::get_current_weixin_public('origin_id'), 3)) {
			continue;
		}

		$html .= '<li class="am-dropdown" data-am-dropdown><a class="am-dropdown-toggle';
		if(!empty($h['active'])) {
			$html .= ' am-active';
		}
		$html .= '" data-am-dropdown-toggle href="javascript:;"><span class="'.$h['icon'].'"></span> '. $h['name']
				.' <span class="am-icon-caret-down"></span></a>';
		if(!empty($h['menu'])) {
			$html .= '<ul class="am-dropdown-content">';
			foreach($h['menu'] as $hh) {
				if(!SpInviteMod::check_current_sp_access(array('app' => $hh['dir'], 'ctl' => 'sp', 'act' => 'index'))) {
					continue;
				}
				$html .= '<li ><a ';
				if($hh['dir'] == $GLOBALS['_UCT']['APP']) {
					$html .= ' class="am-active" ';
				}
				$html .= ' href="?_a='.$hh['dir'].'&_u=sp">'.$hh['name'].'</a></li>';
			}
			$html .= '</ul>';
		}
		$html .= '</li>';
	}
	echo $html;
	}
?>


	</ul>
</div>
<div class="am-collapse am-topbar-collapse" id="topbar-collapse">
	<ul class="am-nav am-nav-pills am-topbar-nav am-topbar-right admin-header-list" sp_uid="<?php echo $GLOBALS['service_provider']['uid']?>">
      <li class="am-dropdown" data-am-dropdown>
        <a class="am-dropdown-toggle" data-am-dropdown-toggle href="javascript:;">
          <span class="am-icon-user"></span> <?php 
			$name = $GLOBALS['service_provider']['name'] ? $GLOBALS['service_provider']['name'] 
			: $GLOBALS['service_provider']['account'];
			if($subsp_uid = AccountMod::has_subsp_login()) {
				$name = Dba::readOne('select name from sub_sp where uid = '.$subsp_uid) . '('.$name.')';
			}
			echo $name;

			$unread_cnt = SpMsgMod::get_unread_sp_msg_cnt();
			if($unread_cnt > 99) {
				$unread_cnt = '99+';
			}
			if($unread_cnt)
				echo ' <span class="am-badge am-badge-danger am-round">'.$unread_cnt.'</span>';?> <span class="am-icon-caret-down"></span>
        </a>
        <ul class="am-dropdown-content">
          <li><a href="?_a=sp&_u=index.msg"><span class="am-icon-envelope-o"></span> 消息通知
			<?php
			if($unread_cnt) 
				echo ' <span class="am-badge am-badge-danger am-round">'.$unread_cnt.'</span>';
			?></a>
		  </li>
          <li><a href="?_a=sp&_u=index.orderlist"><span class="am-icon-yen"></span> 服务订单</a></li>
          <li><a href="?_a=sp&_u=index.profile"><span class="am-icon-user"></span> 基本资料</a></li>
          <!--<li><a href="?_a=sp&_u=index.syssetting"><span class="am-icon-cog"></span> 设置</a></li>-->
          <li><a href="?_a=sp&_u=index.logout"><span class="am-icon-power-off"></span> 退出</a></li>
        </ul>
      </li>
	</ul>
<!---->
<?php
//	if(SpMod::has_weixin_public_set() &&
//		(!empty($_REQUEST['_d']) || strncmp('fk_', WeixinMod::get_current_weixin_public('origin_id'), 3))) {
//		echo '<a href="?_a=sp&_u=index.addpublic&uid='.WeixinMod::get_current_weixin_public('uid').
//			'" class="am-topbar-right am-topbar-brand"><span class="am-icon-weixin"></span> '.
//			WeixinMod::get_current_weixin_public('public_name').'</a>';
//	}
//?>

    <?php
    if($uct_token = SpMod::has_weixin_public_set() /*&&
        (
            !empty($_REQUEST['_d'])||
            strncmp('fk_', WeixinMod::get_current_weixin_public('origin_id'), 3)
        ) */
    )
    {
		$wx = Dba::readRowAssoc('select * from weixin_public where uct_token = "'.$uct_token.'"', 'WeixinMod::func_get_weixin');
        ?>
        <ul style="margin-top:0;" class="am-nav am-nav-pills am-topbar-nav am-topbar-right">
            <li class="am-dropdown" data-am-dropdown>
                <a class="am-dropdown-toggle" data-am-dropdown-toggle href="javascript:;">
                    <span <?php
                        if($wx['access_mod'] ==-1){
                            echo 'style="color: #f37b1d" data-am-popover="{content: \'此公众号已取消授权\', trigger: \'hover focus\'}"';
                        }
                      ?>class="am-icon-weixin" ></span>
<!--                    <span style="color: red;font-size: 122%;position: absolute;top: -2px;left: 11px" class="am-icon-close"></span>-->
<!--                    <span style="opacity: 0.6;color: red;font-size: 122%;position: absolute;top: -2px;left: 9px" class="am-icon-exclamation-triangle"></span>-->
                    <?php echo $wx['public_name']; ?>
                    <span class="am-icon-caret-down"></span>
                </a>
                <ul class="am-dropdown-content">
                <?php
                $title_all_public = WeixinMod::get_all_weixin_public_by_sp_uid();
				$now_public = $wx['public_name'];
				$whether_empower = $wx['access_mod'];
                foreach($title_all_public as $p){
                    ?>
                    <li>
                        <?php
                        if($p['public_name']==$now_public) echo ($whether_empower==-1) ? '<a href="?_a=sp&_u=index.publiclist"><span class="am-icon-close"></span> ' : '<a href="javascript:"><span class="am-icon-check"></span> ';
                        else echo '<a href="javascript:">';
                        ?>
                        	<span class="change-public"  <?php if($p['public_name']!=$now_public) echo 'data-uid="'.$p['uid'].'"';?>><?php echo $p['public_name'];?></span> 
							<amazeb onclick="window.location.href='?_a=sp&_u=index.addpublic&uid=<?php echo $p['uid'];?>';"
						 		style="margin-left:5px;text-align:right;font-size:12px;color:#3bb4f2;text-decoration:underline;">编辑
							</amazeb> 
<?php
if(($p['public_type'] & 8) == 8) {
echo '<amazeb onclick="window.location.href=\'?_a=sp&_u=index.xiaochengxu&uid='.$p['uid'].
'\'" style="margin-left:20px;text-align:right;font-size:12px;color:#f37b1d;text-decoration:underline;">
小程序</amazeb> ';
}
?>
			
						</a>
                    </li>
                    <?php

                }
                ?>
                </ul>
            </li>
        </ul>
    <?php
    }
    ?>

<ul style="margin-top:0;" class="am-nav am-nav-pills am-topbar-nav am-topbar-right">
<li class="am-dropdown" data-am-dropdown="">
	<a class="am-dropdown-toggle " data-am-dropdown-toggle="" href="javascript:;">
		<span class="am-text-warning"><span class="am-icon-history"></span> 最近访问<span class="am-icon-caret-down"></span></span>
	</a>
<ul class="am-dropdown-content">
<?php
	foreach(SpMod::getRecentUsedApp() as $r) {
        $p = WeixinPlugMod::get_plugin_by_dir($r);
		echo '<li><a href="?_a='.$p['dir'].'&_u=sp">'.$p['name'].'</a></li>';
	}
?>
</ul>
</li>
</ul>

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
	<script src="/static_seajs/public_toolkit/seajs/sea.js"></script>
	<script src="/static_seajs/public_toolkit/seajs/seajs-css.js"></script>
	<script src="/static_seajs/public_toolkit/seajs/seajs-preload.js"></script>
	<script src="/static_seajs/js/seajs-option.js"></script>

<?php
$e = SpLimitMod::get_current_sp_limit('expire_time');
if($e && $e < $_SERVER['REQUEST_TIME']) {
echo '
<a href="?_a=sp&_u=index.servicedetail&uid=1" class="am-text-warning" style="text-align:center; border: 1px solid #f37b1d; margin-top: -1.6rem;
	display:block;">
	<span class="am-icon-warning"></span> 
	您的账号已过期, 服务已停用, 请联系客服续费!
</a>';
}
else if($e && $e < $_SERVER['REQUEST_TIME'] + 86400 * 7) {
echo '
<a href="?_a=sp&_u=index.servicedetail&uid=1" class="am-text-warning" style="text-align:center; border: 1px solid #f37b1d; margin-top: -1.6rem;
	display:block;">
	<span class="am-icon-warning"></span> 
	您的账号即将于 '.date('Y-m-d H:i', $e).' 过期, 请联系客服续费!
</a>';
}



if(SpInviteMod::is_current_sp_readonly()) {
echo '
<a href="javascript:;" class="am-text-warning" style="text-align:center; border: 1px solid #f37b1d; margin-top: -1.6rem;
	display:block;">
	<span class="am-icon-warning"></span> 
	您的账号为只读演示账号, 操作功能将受到限制!
</a>';
}


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
<footer style="padding-top: 50px;text-align:center">
  <hr>
  <p class="am-u-lg-8 am-u-md-12 am-u-sm-centered" style="position: relative;z-index: -1">© 深圳市快马加鞭科技有限公司
 | ☏ </p>
</footer>
</body>
</html>
