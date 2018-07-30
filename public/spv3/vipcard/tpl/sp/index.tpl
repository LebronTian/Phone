<div class="am-u-lg-0 am-u-md-32 am-u-sm-centered">

	<div class="am-cf am-padding">
		<div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">会员卡主页</strong> /
			<small></small>
		</div>
	</div>

</div>

<div class="am-padding">
	<ul class="am-avg-sm-1 am-avg-md-4 am-margin am-padding am-text-center admin-content-list " style="margin-top: 10px;">
		<li><a href="?_a=vipcard&_u=sp.vip_card_list"><span class="am-icon-btn am-icon-file-text am-text-primary"></span><br>会员卡总数<br>
				<?php echo $cnts['total_vipcard_cnt'];?></a></li>
		<li><a href="?_a=vipcard&_u=sp.vip_card_list"><span class="am-icon-btn am-icon-file-text am-text-primary"></span><br>今日新增数<br>
				<?php echo $cnts['today_vipcard_cnt'];?></a></li>
		<li><a href="?_a=vipcard&_u=sp.vip_card_list&status=1" class="am-text-success"><span class="am-icon-btn am-icon-warning am-text-success"></span><br>待审核数<br>
				<?php echo $cnts['total_uncheck_cnt'];?></a></li>

	</ul>

	<div class="am-g" style="display:none;">
		手机扫一扫,访问
		<a target="_blank" href="<?php echo DomainMod::get_app_url('vipcard'); ?>">
			<?php echo '会员卡'; ?></a>
		<br/>
		<?php echo '<img style="width:220px;height:220px;" src="?_a=web&_u=index.qrcode&url=' . rawurlencode(DomainMod::get_app_url('vipcard')) . '">'; ?>
	</div>
</div>
<?php
$extra_js = array();
?>
