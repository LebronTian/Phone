<div class="am-cf am-padding">
	<div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">编辑微信群</strong>/
	<small>编辑微信群</small> </div>
</div>

<div class="am-form">
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			名称
		</div>
		<div class="am-u-sm-8 am-u-end">
			<input type="text" id="id_title" <?php if(!empty($group['name'])) echo 'value="'.$group['name'].'"';?>>
		</div>
	</div>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			微信群编码
		</div>
		<div class="am-u-sm-8 am-u-end">
			<input type="text" id="id_wx_group_id" <?php if(!empty($group['wx_group_id'])) echo 'value="'.$group['wx_group_id'].'"';?>>
		</div>
	</div>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			&nbsp;
		</div>
		<div class="am-u-sm-8 am-u-end">
			<p><button class="am-btn am-btn-lg am-btn-primary save">保存</button></p>
		</div>
	</div>

</div>

<?php
echo '<script>var g_uid = '.(!empty($group['uid']) ? $group['uid'] : 0).';</script>';
$extra_js =  array(
		'/app/su/static/js/addwechatgroup.js',
);
?>


