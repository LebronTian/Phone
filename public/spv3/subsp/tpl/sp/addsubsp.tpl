<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg"><?php echo(!empty($subsp['uid']) ? '编辑子账号' : '新建子账号')?></strong> / <small></small></div>
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
<div class="am-form" data-uid="<?php echo !empty($subsp['uid']) ? $subsp['uid'] : 0; ?>">
	<div class="am-g am-margin-top-sm">
   		 <div class="am-u-sm-2 am-text-right">
		        分配小程序
		</div>
		<?php
			//var_export($title_all_public);
			$html = '<div class="uct_tokens">';
			if(!empty($title_all_public))
			foreach($title_all_public as $p) {
				$html .= '	
<label class="am-checkbox"><input type="checkbox" value="'.$p['uct_token'].'"';
					if(empty($subsp['uct_tokens']) || in_array($p['uct_token'], $subsp['uct_tokens'])) $html .= ' checked ';
				$html .= ' data-am-ucheck="" class="am-ucheck-checkbox"><span class="am-ucheck-icons"><i class="am-icon-unchecked"></i><i class="am-icon-checked"></i></span>'.$p['public_name'].'</label>';
			}
			$html .= '</div>';
			echo $html;
		?>
	</div>

<hr/>

<?php
if($stores) {
	$html = '
	<div class="am-g am-margin-top-sm">
   		 <div class="am-u-sm-2 am-text-right">
		        分配管理门店
		</div>
		<div class="am-form-group am-u-end am-u-sm-8" style="margin-left:-10px">
            <select data-am-selected="{btnWidth: 150, btnSize: \'lg\' }" class="option_store_uids">';
	//todo现在只支持1个门店 
	array_unshift($stores, array('uid' => 0, 'name' => ' -全部-'));
	$this_store = !empty($subsp['store_uids'][0]) ? $subsp['store_uids'][0] : 0;
	foreach($stores as $s) {
         $html .= '<option value="'.$s['uid'].'"';
         if($this_store == $s['uid']) $html .= ' selected';
         $html .= '>'.$s['name'].'</option>';
	}
	$html .= '</select>
		</div>
	</div>';

	echo $html;
}
?>

<hr/>

	<div class="am-g am-margin-top-sm">
   		 <div class="am-u-sm-2 am-text-right">
		        权限控制
		</div>
		<?php
			$not_limit = empty($subsp['access_rule']) || (!empty($subsp['access_rule']['*']) && $subsp['access_rule']['*'] == 1);
			//var_export($subsp['access_rule']);
		?>
		<div class="am-form-group am-u-end am-u-sm-8" style="margin-left:-10px">
			<div class="am-radio" style="margin-top:0;padding-left:10px">
				<label class="am-radio am-secondary select_unlimit">
					<input type="radio" name="radio3" value="" data-am-ucheck <?php if($not_limit) echo 'checked';?>> 超级管理员 </label>
				<label class="am-radio am-secondary select_limit">
					<input type="radio" name="radio3" value="" data-am-ucheck <?php if(!$not_limit) echo 'checked';?>> 限制权限 </label>

				<label style="margin-left:50px;color:#F37B1D;">预设权限：<select style="display:inline-block;min-width:120px;" id="id_tpl">
<?php
$tpls = SubsptplMod::get_system_tpl();
$html = '';
if($tpls)
foreach($tpls as $k=> $v) {
$html .= '<option ';
if($k == $tpl_uid) $html .= ' selected="selected"';
$html .= ' value="'.$k.'">'.$v['name'].'</option>';
}
echo $html;
?>
				</select></label>
			</div> 
		
			<div class="limit_box" style="display:<?php echo $not_limit ? 'none' : 'block';?>">
			<?php
			#var_export($_g_menu);	die;
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
		$it['url'] = '_easy='.$_p['dir'].'.sp';

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
#if(!isset($m['url'])){echo'ffffffffffffffff';var_export($m);}
					$html .= '
<div class="parent_box"><label class="am-checkbox"><input type="checkbox" value="'.$m['dir'].'" link="'.$m['url'].'" ';
//xxxxxx 
if($m['url'] == '?_a=sp') {
	$m['url'] = 'sp.index.index';
}
					if(!empty($subsp['access_rule'][$m['dir'].'.*'])){ $html .= ' checked '; }
					if(!empty($m['url']) && !empty($subsp['access_rule'][$m['url']])){ $html .= ' checked '; }
					$html .= 'data-am-ucheck="" class="am-ucheck-checkbox"><span class="am-ucheck-icons"><i class="am-icon-unchecked"></i><i class="am-icon-checked"></i></span>'.$m['name'].'</label></div><div class="detail_box" style="display: block;">';
					if($m['menus']) 
					foreach($m['menus'] as $mm) {
						$html .= '	
<label class="am-checkbox"><input type="checkbox" value="'.$mm['url'].'"';
/*
						if(!empty($subsp['access_rule'][$m['dir'].'.*']) && 
							!(isset($subsp['access_rule'][$mm['url']]) && $subsp['access_rule'][$mm['url']] == 0)) $html .= ' checked ';
*/
						if( 
							(isset($subsp['access_rule'][$mm['url']]) && $subsp['access_rule'][$mm['url']] == 1)) $html .= ' checked ';
						$html .= ' data-am-ucheck="" class="am-ucheck-checkbox"><span class="am-ucheck-icons"><i class="am-icon-unchecked"></i><i class="am-icon-checked"></i></span>'.$mm['name'].'</label>';
					}
					$html .= '</div>';
				}
				echo $html;
			?>
			</div>
		</div>
	</div>

<hr/>
		<div class="am-u-sm-2 am-text-right">
				账号信息
		</div>
		<hr>
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-8  am-u-end" style="height:200px;">
			<div style="margin-bottom:5px">
				<div style="float:left;width:150px;line-height:43px;">角色名称：</div>
				<input type="text" value="<?php echo(!empty($subsp['name']) ? $subsp['name'] : '')?>" id="id_name" style="width:200px" />
			</div>
			<div style="margin-bottom:5px;clear:both;">
				<div style="float:left;width:150px;line-height:43px;">登录账号：</div>
				<input type="text" value="<?php echo(!empty($subsp['account']) ? $subsp['account'].'" readonly ' : '"')?> id="id_account" style="width:200px" />
			</div>
			<?php if(1 || empty($subsp['uid'])) {?>
			<div style="margin-bottom:5px;clear:both;">
				<div style="float:left;width:150px;line-height:43px;">登录密码：</div>
				<input type="password" value="" id="id_passwd" style="width:200px" />
			</div>
			<div style="margin-bottom:5px;clear:both;">
				<div style="float:left;width:150px;line-height:43px;">确认密码：</div>
				<input type="password" value="" id="id_passwd2" style="width:200px" />
			</div>
			<?php }?>
		</div>
	</div>
		
	<div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
			<p><button class="am-btn am-btn-lg am-btn-primary save"><?php echo(!empty($subsp['uid']) ? '修改' : '添加')?></button></p>
		</div>
	</div>
</div>

<?php
	$extra_js = array(
		$static_path.'/js/addsubsp.js',
	);
?>

<script>
$('#id_tpl').change(function(){
	var tpl_uid = $(this).val();
	var uid = $('.am-form').attr('data-uid');
	if(uid && (uid != 0) && !confirm('确定使用预设权限吗？')) return; 
	window.location.href="?_easy=subsp.sp.addsubsp&tpl_uid="+tpl_uid+'&uid='+uid;
});
</script>


