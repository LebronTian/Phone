<div class="am-cf am-padding">
  <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">绑定微信号</strong> / <small></small></div>
</div>

<div class="am-form">
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
	            微信号:
		</div>
		<div class="am-u-sm-4 am-u-end cset">
<?php
if(!$open_id = @$sw['open_id']) {
	$key = 'scan_open_id_'.AccountMod::get_current_service_provider('uid');
	$open_id = $GLOBALS['arraydb_sys'][$key];
	#$open_id = 'oF71Mwa21giGJ-S3cGCucawFHxsc';
}

if(!empty($open_id)) { 
	$su_uid = Dba::readOne('select su_uid from weixin_fans where open_id = "'.addslashes($open_id).'"');
	$user = Dba::readRowAssoc('select uid, name, avatar from service_user where uid = '.$su_uid);
	echo '<img src="'.$user['avatar'].'" width=64 height=64><span id="id_open_id" data-id="'.$open_id
					.'">'.$user['name'].'</span> <a id="id_change" href="javascript:;">修改</a>';

?>
		</div>
	</div>

	<hr/>
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
		权限:
		</div>
		<div class="am-u-sm-4 am-u-end">
			<label class="am-checkbox"> 扫一扫登陆
			<input id="id_allow_login" class="am-checkbox" data-am-ucheck
			<?php if(empty($sw['cfg']['disable_login'])) echo 'checked="checked"'; ?> type="checkbox"  />
			</label>
			<label class="am-checkbox"> 接收通知消息 
			<input id="id_allow_msg" class="am-checkbox" data-am-ucheck
			<?php if(empty($sw['cfg']['disable_msg'])) echo 'checked="checked"'; ?> type="checkbox"  />
			</label>
		</div>
	</div>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
		<p><button class="am-btn am-btn-lg am-btn-primary save">确定</button></p>
		</div>
	</div>
<?php
} 
else {
	echo '<a id="id_change" href="javascript:;">修改</a></div></div>';
}
?>

</div>

<?php
$extra_js =  array( 
	$static_path.'/js/addspwx.js',
);
?>




