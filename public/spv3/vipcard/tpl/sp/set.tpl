
<head>
<!--	<link rel="stylesheet" type="text/css" href="/static/css/uploadify.css">-->
<!--	<link rel="stylesheet" type="text/css" href="/static/css/imglist.css">-->
	<link rel="stylesheet" type="text/css" href="/static/css/select_tpl.css">
	<style type="text/css">
		.uploadify-button {
			line-height: 25px !important;
		}
	</style>
</head>
<div class="am-cf am-padding">
	<div class="am-fl am-cf">
		<a href="?_a=vipcard&_u=sp">
			<strong class="am-text-primary am-text-lg">会员卡基本设置</strong></a>
		<span class="am-icon-angle-right"></span>
		<small></small>
	</div>
</div>

<div class="am-form  data-am-validator ">
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			会员卡名称
		</div>
		<div class="am-u-sm-8 am-u-end">
			<input type="text" id="id_title" value="<?php if(!empty($vip_card_sp_set['title'])) echo $vip_card_sp_set['title'] ?>">
		</div>
	</div>
	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			状态
		</div>
		<div class="am-u-sm-8 am-u-end">
			<label class="am-checkbox">
				<input type="checkbox" id="id_status" data-am-ucheck <?php if (empty($vip_card_sp_set['status']))
				{
					echo 'checked';
				} ?>>
				是否开启</label>
		</div>
	</div>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			会员卡的前端模板
		</div>
		<div class="am-u-sm-8 am-u-end">
			<div class="tpl-container" data-url="<?php echo '?_a='.$_REQUEST['_a'].'&_u=api.get_tpls' ?>" data-selected="<?php echo(!empty($vip_card_sp_set['tpl'])? $vip_card_sp_set['tpl']:"") ?>">
			</div>
		</div>
	</div>

	<div class="am-g am-margin-top-sm">
        <div class="am-u-sm-2 am-text-right">
            &nbsp;
        </div>
        <div class="am-u-sm-8 am-u-end">
            <p><button class="am-btn am-btn-lg am-btn-primary save-set">保存</button></p>
        </div>
    </div>

</div>

<script>
	var vip_card =<?php echo(!empty($vip_card_sp_set)? json_encode($vip_card_sp_set):"null") ?>;
	var tpl_url =<?php echo '"?_a='.$_REQUEST['_a'].'&_u=api.get_tpls"' ?>;
</script>

<script>
	
</script>
<?php

$extra_js = array(
	'/app/vipcard/static/js/set.js',
);

?>

<script>
    $(function () {
        seajs.use(['selectTpl','selectPic']);
    })
</script>

