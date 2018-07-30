<div class="am-cf am-padding">
	<div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">代理基本设置</strong> /
		<small></small>
	</div>
</div>

<div class="am-form">
	<div class="am-g am-margin-top-sm" <?php if(empty($_GET['_d'])) echo 'style="display:none;"'; ?>>
		<div class="am-u-sm-2 am-text-right">
			代理邀请页面
		</div>
		<div class="am-u-sm-6 am-text-left am-u-end">
			手机扫一扫,访问
			<a target="_blank" href="<?php echo DomainMod::get_app_url('shop',0,array('_a'=>'shop','_u'=>'user.agent_center')) ; ?>">
				<?php echo ($shop['title'] ? $shop['title'] : '微商城').'分销代理申请页面'; ?></a>
			<br/>
			<?php echo '<img style="width:220px;height:220px;" src="?_a=web&_u=index.qrcode&url=' . rawurlencode(DomainMod::get_app_url('shop',0,array('_a'=>'shop','_u'=>'user.agent_center'))) . '">'; ?>
		</div>
	</div>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			开启代理系统
		</div>
		<div class="am-u-sm-8 am-u-end">
			<label class="am-checkbox">
				<input type="checkbox" id="id_status" data-am-ucheck <?php if (empty($shop_agent_set['status']))
				{
					echo 'checked';
				} ?>>
				默认开启</label>
		</div>
	</div>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			代理商审核
		</div>
		<div class="am-u-sm-8 am-u-end">
			<label class="am-checkbox">
				<input type="checkbox" id="id_need_check"
				       data-am-ucheck <?php if (!empty($shop_agent_set['need_check']))
				{
					echo 'checked';
				} ?>>
				代理商加入是否需要审核，默认不需要</label>
		</div>
	</div>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-3 am-text-right am-u-end">
			<strong class="am-text-lg">默认的代理分红模式</strong>
		</div>
		<div class="am-u-sm-6  am-u-end">
			（设置你的默认分红模式，可多选，红利直接叠加）

		</div>
		<div class="am-u-sm-3 am-u-end">
			&nbsp;
		</div>

	</div>

	<div class="am-g am-margin-top-sm agent_cost">
		<div class="am-u-sm-3 am-text-right">
			扣去成本为红利
		</div>
		<div class="am-u-sm-1 am-center am-text-right ">
			<input type="checkbox" name="" <?php
			echo empty($shop_agent_set['rule_data']['cost']['status']) ? '' : 'checked';
			?>>
		</div>
		<div class="am-u-sm-2 am-u-end">
			<input type="number" style="visibility: hidden">
		</div>
		<div class="am-u-sm-6 am-u-end">
			<small>红利=代理商设置的商品价格-供货商设置的商品价格</small>
		</div>
	</div>

	<div class="am-g am-margin-top-sm agent_paid_fee">
		<div class="am-u-sm-3 am-text-right">
			销售价格的固定百分比
		</div>
		<div class="am-u-sm-1 am-center am-text-right ">
			<input type="checkbox" name="" <?php
			echo empty($shop_agent_set['rule_data']['paid_fee']['status']) ? '' : 'checked';
			?>>
		</div>
		<div class="am-u-sm-2 am-u-end">

			<input class="" type="number" max="100" min="0" step="0.01" <?php
			echo 'value="' . (empty($shop_agent_set['rule_data']['paid_fee']['weight']) ? '' : sprintf('%.2f', $shop_agent_set['rule_data']['paid_fee']['weight'] / 100)) . '"';
			?>/>

		</div>
		<div class="am-u-sm-6 am-u-end">
			<small>红利=代理商设置的商品价格*设置百分百</small>
		</div>
	</div>
	<div class="am-g am-margin-top-sm agent_bonus">
		<div class="am-u-sm-3 am-text-right">
			每个卖出商品给予固定佣金
		</div>
		<div class="am-u-sm-1 am-center am-text-right ">
			<input type="checkbox" name="" <?php
			echo empty($shop_agent_set['rule_data']['bonus']['status']) ? '' : 'checked';
			?>>
		</div>
		<div class="am-u-sm-2 am-u-end">

			<input class="" type="number" min="0" step="0.01" <?php
			echo 'value="' . (empty($shop_agent_set['rule_data']['bonus']['value']) ? '' : sprintf('%.2f', $shop_agent_set['rule_data']['bonus']['value'] / 100)) . '"';
			?>/>

		</div>
		<div class="am-u-sm-6 am-u-end">
			<small>红利=供货商设置的佣金*代理商卖出商品数 （单位：元）</small>
		</div>
	</div>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			&nbsp;
		</div>
		<div class="am-u-sm-8 am-u-end">
			<p>
				<button
					class="am-btn am-btn-lg am-btn-primary save"><?php echo empty($shop_agent_set) ? '开始勤劳致富之路' : '保存'; ?></button>
			</p>
		</div>
	</div>

</div>

<?php
echo '<script>var uid = ' . (empty($shop_agent_set['uid']) ? 0 : $shop_agent_set['uid']) . ';</script>';
$extra_js = array(
	$static_path . '/js/agent_set.js',
);
?>
