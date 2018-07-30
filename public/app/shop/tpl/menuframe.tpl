<style>
	.is_extra, .is_extra li {border-top: 1px solid #F37B1D !important;}
	.admin-sidebar{
		 margin: 0px;
		left: 0px;
	}
	.admin-content{
		left: 190px;
	}
</style>

<div class="admin-sidebar" id="slider_bar">
	<ul class="am-list admin-sidebar-list">
<?php


	$html = '';
	$activeurl = $GLOBALS['_UCT']['CTL'].'.'.$GLOBALS['_UCT']['ACT'];
	foreach($menu_array as $i => $m) {
		if(empty($m['menus'])) { 
			list($ctl, $act) = explode('.', $m['activeurl']);

			if(empty($_REQUEST['_d']) && !empty($m['hide']) && (SpInviteMod::check_current_sp_access(array('ctl' => $ctl, 'act' => $act)) != 10)) {
				continue;
			}
			//单行菜单
			$html .= '<li';
			if(!empty($m['is_extra'])) $html .= ' class="is_extra"';
			$html .= '><a ';
			if($m['activeurl'] == $activeurl) {
				$html .= ' class="am-active" ';
			}
			$html .= 'href="'.$m['link'].'"><span class="'.$m['icon'].'"></span> '.$m['name'].'</a></li>';
		}
		else {
			//多行菜单
			$html .= '<li class="admin-parent';
			if(!empty($m['is_extra'])) $html .= ' is_extra';
			$html .= '"><a class="am-cf " data-am-collapse="{target: \'#collapse-nav'.$i.'\'}"><span class="'
					.$m['icon'].'"></span> '.$m['name'].' <span class="am-icon-angle-right am-fr am-margin-right"></span></a>'.
					'<ul class="am-list am-collapse admin-sidebar-sub ';

			foreach($m['menus'] as $mm) {
				if($mm['activeurl'] == $activeurl) {
				$html .= ' am-in ';
				}
			}

			$html .= '" id="collapse-nav'.$i.'">';
			foreach($m['menus'] as $mm) {
				list($ctl, $act) = explode('.', $mm['activeurl']);

				if(empty($_REQUEST['_d']) && !empty($mm['hide']) && (SpInviteMod::check_current_sp_access(array('ctl' => $ctl, 'act' => $act)) != 10)) {
					continue;
				}
				$html .= '<li><a ';
				if($mm['activeurl'] == $activeurl) {
					$html .= ' class="am-active" ';
				}
				$html .= 'href="'.$mm['link'].'"><span class="'.$mm['icon'].'"></span> '.$mm['name'].' </a></li>';
			}
			$html .= '</ul></li>';

		}
	}
	echo $html;
?>
<!--
      <li><a href="#"><span class="am-icon-home"></span>欢迎页</a></li>

      <li class="admin-parent">
        <a class="am-cf" data-am-collapse="{target: '#collapse-nav'}"><span class="am-icon-file"></span> 微信账号 <span class="am-icon-angle-right am-fr am-margin-right"></span></a>
        <ul class="am-list am-collapse admin-sidebar-sub am-in" id="collapse-nav">
          <li><a href="#"><span class="am-icon-th"></span> 公众号列表<span class="am-badge am-badge-secondary am-margin-right am-fr">4</span></a></li>
          <li><a href="#"><span class="am-icon-bug"></span> 新增公众号</a></li>
          <li><a href="#" class="am-cf am-active"><span class="am-icon-check"></span> 插件列表<span class="am-icon-star am-fr am-margin-right admin-icon-yellow"></span></a></li>
          <li><a href="#"><span class="am-icon-calendar"></span> 关键词</a></li>
        </ul>
      </li>

      <li class="admin-parent">
        <a class="am-cf" data-am-collapse="{target: '#collapse-nav2'}"><span class="am-icon-file"></span> 商户信息 <span class="am-icon-angle-right am-fr am-margin-right"></span></a>
        <ul class="am-list am-collapse admin-sidebar-sub am-in" id="collapse-nav2">
          <li><a href="#"><span class="am-icon-bug"></span> 商户资料</a></li>
          <li><a href="#" class="am-cf"><span class="am-icon-check"></span> 账号设置</a></li>
          <li><a href="#"><span class="am-icon-th"></span> 消息通知<span class="am-badge am-badge-secondary am-margin-right am-fr">4</span></a></li>
          <li><a href="#"><span class="am-icon-calendar"></span> 修改密码</a></li>
        </ul>
      </li>

      <li><a href="#"><span class="am-icon-pencil-square-o"></span> 系统设置</a></li>
      <li><a href="#"><span class="am-icon-sign-out"></span> 插件商城</a></li>
-->

    </ul>
</div>

<div class="admin-content" style="min-height:600px;">

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
	<!--<footer style="padding-top: 50px;text-align:center">
		<hr>
		<p class="am-u-lg-8 am-u-md-12 am-u-sm-centered" style="position: relative;z-index: 0">© 深圳市快马加鞭科技有限公司
			| ☏ </p>
	</footer>-->
</div>

