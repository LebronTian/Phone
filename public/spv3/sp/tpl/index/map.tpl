<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">欢迎 <?php if(!empty($subsp)) echo '<a href="?_easy=sp.index.password">'.$subsp['name'].
		' ('.$subsp['account'].')</a>!'?></strong> / 后台导航 <small></small></div>
</div>
<?php 
#var_export($cats);
#var_export($option);
?>

<style>
  .am-radio+.am-radio, .am-checkbox+.am-checkbox{margin:0;margin-left:10px}
  .am-form-group{}
  .am-checkbox{display: inline-block;margin:0;margin-left:10px}
  .limit_box{display:none}
  .detail_box{margin-left:20px;display:none}
</style>

<p><span class="am-icon-info"></span> 这里是后台地图，您可以快速进入功能页面</p>
	<div class="am-g am-margin-top-sm">
		<?php
			//var_export($subsp['access_rule']);
		?>
		<div class="am-form-group am-u-end am-u-sm-12">
			<div class="limit_box" style="display:block">
			<?php
//用svp3的菜单
$menus = array();
foreach($_g_menu as $m) {
$it = array('dir' => 'unknown', 'name' => $m['name'], 'url' => $m['link']);
if(!empty($m['menus'])) {
foreach($m['menus'] as $mm) {
$it['menus'][] = array('name' => $mm['name'], 'url' => $mm['link']);
}
}else {
$it['menus'] = false;
}
$menus[] = $it;
}
$_ps = WeixinplugMod::get_weixin_public_plugins_all();
if($_ps) 
foreach($_ps as $_p) {
	if(in_array($_p['dir'], $_plugs)) {
		$it = array('name' => '<b style="color:#F37B1D;">'.$_p['name'].'</b>', 'dir' => $_p['dir']);
		$_p = WeixinplugMod::get_plugin_by_dir($_p['dir']);
		$it['url'] = ''.$_p['dir'].'.sp';

		if(empty($_p['spv3_menu']))	 $it['menus'] = false;
		else {
			foreach($_p['spv3_menu'] as $mm) {
				$it['menus'][] = array('name' => $mm['name'], 'url' => $mm['link']);
			}
		}
		$menus[] = $it;
	}
}


$html = '';
foreach($menus as $m) {
if($m['url'] == '?_a=sp') {
	$m['url'] = 'sp.index.index';
	$m['menus'][] = array('name' => '后台导航', 'url' => 'sp.index.map');
}
$html .= '
<div class="boxes" style="float:left;width:30%;border-top:1px solid #fff;margin-right:12px;margin-bottom:20px;"  >
<div class="parent_box" style="border-left: 3px solid #0e90d2;">
<a class="am-btn am-btn-xl" '.($m['url'] ? ' href="?_easy='.$m['url'].'"' : '');
//xxxxxx 
if(!empty($subsp['access_rule'][$m['dir'].'.*'])){ $html .= ' checked '; }
if(!empty($m['url']) && !empty($subsp['access_rule'][$m['url']])){ $html .= ' checked '; }

$html .= '>'.$m['name'].'</a></div><div class="detail_box" style="display: block;">';
if($m['menus']) 
foreach($m['menus'] as $mm) {
	if(empty($subsp) || isset($subsp['access_rule'][$mm['url']]) && $subsp['access_rule'][$mm['url']] == 1) {
		$html .= '<a class="am-btn am-btn-lg" href="?_easy='.$mm['url'].'">'.$mm['name'].'</a>';
	}
}
$html .= '</div></div>';
}
echo $html;
?>
			</div>
		</div>
	</div>

</div>

<?php
	$extra_js = array(
		'/spv3/sp/static/js/map.js',
	);
?>

<script>
$(function(){
$('.boxes').each(function(){
	if(!$('.detail_box a', this).length) {
		$(this).hide();
	}	
});
});
</script>


