<head>
    <link rel="stylesheet" type="text/css" href="/static/css/uploadify.css">
  <link rel="stylesheet" type="text/css" href="/static/css/imglist.css">
  <link rel="stylesheet" type="text/css" href="/static/css/uploadify.css">
  <link rel="stylesheet" type="text/css" href="/app/sp/static/css/css.css">
  <link rel="stylesheet" type="text/css" href="/app/sp/static/css/style.css"> 
  <link rel="stylesheet" type="text/css" href="/app/sp/static/css/jquery.Jcrop.css"> 
<style type="text/css">
  .uploadify-button {
    line-height: 25px !important;
  }
	.fstatus {
	}
#id_tag,#id_title {
width:90%;
font-size:16px;
}
#id_first_class,#id_second_class,#id_third_class {
padding-right:25px;
}

</style>
</head>

<!-- <div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">小程序极速上线</strong> / <small>小程序功能操作</small></div>
</div>
<hr> -->

<div class="am-margin-left am-text-lg">
当前小程序： <?php echo '<a href="?_a=sp&_u=index.addpublic&uid='.$public['uid'].'">'.($public['public_name'] ? $public['public_name'] : $public['app_id']).'</a>';?>
</div>


<div class="am-form am-padding">
<div class="am-g am-padding">
	<div class="am-u-sm-2 am-text-right">
		第一步：上传代码
	</div>
	
	<div class="am-u-sm-2">
	<select id="id_code" class="am-input input100">
	<?php
	$latest_version = 0;
	foreach(XiaochengxuMod::get_code_tpl() as $c) {
		$latest_version = max($latest_version, $c['template_id']);
		echo '<option value="'.$c['template_id'].'">'.$c['user_desc'].' '.$c['user_version'].'</option>';
	}
	?>
	</select>
	</div>
	<div class="am-u-sm-4 am-u-end">
<?php
	$audit = XiaochengxuMod::get_audit_id($public['uid']);
		if(!empty($_GET['_d'])) var_export($audit);
	if($audit && empty($audit['audit_id'])) {
		$audit_status = XiaochengxuMod::auditstatus_xiaochengxu($public);
	}

if(!empty($_GET['_d']) || empty($audit['upload_time']) || ($audit['template_id'] < $latest_version)) {
?>
	<a class="am-btn am-btn-danger" id="id_upload"><span class="am-icon-upload"></span> 一键上传模板代码</a>
<?php } else { ?>
	<span class="am-icon-check am-text-success"></span> <a id="id_upload"><?php echo date('Y-m-d H:i:s', $audit['upload_time']);?> 已上传</a>
<?php } ?>
	</div>
</div>

<div class="am-g am-padding">
	<div class="am-u-sm-2 am-text-right">
		第二步：预览效果
	</div>
	<div class="am-u-sm-2">
	<a class="am-btn am-btn-primary" id="id_qrcode"><span class="am-icon-qrcode"></span> 体验二维码</a>
	</div>
	<div class="am-u-sm-4 am-u-end">
		<a id="id_bind_tester" href="javascript:;" style="line-height:32px;">添加体验者</a><small>(管理员无需添加也可以访问)</small>
		<input id="id_wechatid" style="display:none" class="am-input am-input-lg" type="text" placeholder="请输入体验者微信号">
	</div>
</div>
<div class="am-g am-padding">
	<div class="am-u-sm-2">
		&nbsp;
	</div>
	<div class="am-u-sm-4 am-u-end">
	<img id="id_qrcode_img" style="display:none;width:220px;height:220px;">
	</div>
</div>

<?php 

	if(!empty($audit['audit_id'])) {
	$audit_status = XiaochengxuMod::auditstatus_xiaochengxu($public);
	//var_export($audit_status);
?>

<div class="am-g am-padding">
	<div class="am-u-sm-2 am-text-right">
		第三步：提交审核
	</div>
	<div class="am-u-sm-2">
<?php
	if($audit_status['status'] == 0) {
		echo '<a class="am-btn am-btn-success"><span class="am-icon-check"></span> 审核通过</a>';
	}
	else if($audit_status['status'] == 2) {
		echo '<a class="am-btn am-btn-default"><span class="am-icon-waiting"></span> 审核中</a>';
	}
	else if($audit_status['status'] == 1) {
		//重新上传一下
		XiaochengxuMod::set_audit_id(array('upload_time' => 0), $public['uid']);
		echo '<a class="am-btn am-btn-danger"><span class="am-icon-warning"></span> 审核失败</a>';
		echo '<span class="am-text-danger">'.$audit_status['reason'].'</span>';
	}
?>
	</div>
	<div class="am-u-sm-4 am-u-end">
	</div>
</div>

<div class="am-g am-form" style="margin-top:5px;margin-left:15px;">
	<div class="am-u-sm-2">
		&nbsp;
	</div>
	<div class="am-u-sm-4 am-u-end">
<?php 
echo '提交时间: '.date('Y-m-d H:i:s', $audit['create_time']);
if(!empty($audit['template_id']) && ($tpl = XiaochengxuMod::get_code_tpl($audit['template_id']))) {
	echo '<br>提交版本: '.$tpl['user_desc'].' ('.$tpl['user_version'].')';

}
?>
	</div>
</div>

<?php
} else {
?>
<div class="am-g am-padding">
	<div class="am-u-sm-2  am-text-right">
		第三步：提交审核
	</div>
<script>
var g_cats = 
<?php
$cats = XiaochengxuMod::get_category($public);
echo json_encode($cats);
?>;
</script>
	<div class="am-u-sm-4">
		<input id="id_title" type="text" class="am-input input300" placeholder="请填写页面标题" value="<?php echo $public['public_name']?>">
	</div>
	<div class="am-u-sm-4 am-u-end">
	<a class="am-btn am-btn-primary am-btn-lg" id="id_audit"><span class="am-icon-upload"></span> 提交审核</a>
	</div>
</div>

<div class="am-g am-form am-padding" style="margin-top:5px;">
	<div class="am-u-sm-2">
		&nbsp;&nbsp;
	</div>
	<div class="am-u-sm-4 am-u-end">
		<input id="id_tag" type="text" class="am-input input300" placeholder="请填写小程序标签,用空格分开最多5个">
	</div>
</div>

<div class="am-g am-form am-padding" style="margin-top:15px;">
	<div class="am-u-sm-2">
		&nbsp;&nbsp;
	</div>
	<div class="am-u-sm-1" style="">
	<select id="id_first_class" class="am-input">
<?php
if($cats)
foreach($cats as $c) {
	echo '<option value="'.$c['name'].'">'.$c['name'].'</option>';
}
?>
	</select>
	</div>
	<div class="am-u-sm-1">
	<select id="id_second_class" class="am-input">
	</select>
	</div>
	<div class="am-u-sm-1 am-u-end">
	<select id="id_third_class" class="am-input">
	</select>
	</div>
</div>

<?php } ?>

<hr/>
<div class="am-g am-padding">
	<div class="am-u-sm-2 am-text-right">
		第四步：发布上线
	</div>
	<div class="am-u-sm-2">
<?php
if(!empty($audit['release_time'])) {
?>
<span class="am-icon-send-o am-text-success"></span> <a id="id_release"><?php echo date('Y-m-d H:i:s', $audit['release_time']);?> 已发布</a>
<?php
} else {
?>
	<a class="am-btn am-btn-success<?php 
if(empty($_GET['_d']) && (empty($audit_status) || $audit_status['status'] != 0)) {
echo ' am-disabled';
}
?>" id="id_release"><span class="am-icon-send-o"></span> 立即上线</a>
<?php
}
?>
	</div>
	<div class="am-u-sm-4 am-u-end">
	<img id="id_qrcode_img" style="display:none;width:220px;height:220px;">
	</div>
</div>

</div>
<script>
var g_public_uid = <?php echo $public['uid'];?>;
</script>

<?php
        $extra_js =  array( 
          //'/static/js/jquery.uploadify-3.1.min.js',
          '/spv3/sp/static/js/xiaochengxu.js',
    );

?>


