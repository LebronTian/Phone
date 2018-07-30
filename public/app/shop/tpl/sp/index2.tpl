<div class="am-cf am-padding">
	<div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">微商城</strong> /
		<small></small>
	</div>
</div>

<div class="am-padding">
	<ul class="am-avg-sm-1 am-avg-md-4 am-margin am-padding am-text-center admin-content-list "
	    style="margin-top: 10px;">
		<li><a href="?_a=shop&_u=sp.orderlist"><span class="am-icon-btn am-icon-file-text am-text-primary"></span><br>总订单数<br>
				<?php echo $cnts['total_orders_cnt']; ?></a></li>
		<li><a href="?_a=shop&_u=sp.orderlist"><span class="am-icon-btn am-icon-file-text am-text-primary"></span><br>今日订单数<br>
				<?php echo $cnts['today_orders_cnt']; ?></a></li>
		<li><a class="am-text-success"><span
					class="am-icon-btn am-icon-money am-text-success"></span><br>总成交额(&yen;)<br>
				<?php echo $cnts['total_deal_cnt'] / 100; ?></a></li>
		<li><a class="am-text-success"><span
					class="am-icon-btn am-icon-money am-text-success"></span><br>今日成交额(&yen;)<br>
				<?php echo $cnts['today_deal_cnt'] / 100; ?></a></li>

		<li><a href="?_a=shop&_u=sp.orderlist&status=2" class="am-text-warning">
				<span class="am-icon-btn am-icon-truck am-text-warning"></span><br>待发货订单<br><?php echo $cnts['wait_delivery_cnt']; ?>
			</a></li>

		<li><a href="?_a=shop&_u=sp.orderlist&status=8" class="am-text-warning">
				<span
					class="am-icon-btn am-icon-money am-text-warning"></span><br>待退款订单<br><?php echo $cnts['under_negotation_cnt']; ?>
			</a></li>

		<li><a href="?_a=shop&_u=sp.productlist&low_stock=5&status=0" class="am-text-danger">
				<span
					class="am-icon-btn am-icon-warning am-text-danger"></span><br>低库存商品<br><?php echo $cnts['stock_low_cnt']; ?>
			</a></li>

		<li></li>

		<li><a href="?_a=shop&_u=sp.visit_record" class="am-text-default">
				<span
					class="am-icon-btn am-icon-file-text am-text-primary"></span><br>今日商城pv<br><?php echo $cnts['shop_pv']; ?>
			</a></li>

		<li><a href="?_a=shop&_u=sp.visit_record" class="am-text-success">
				<span
					class="am-icon-btn am-icon-file-text am-text-success"></span><br>今日商城uv<br><?php echo $cnts['shop_uv']; ?>
			</a></li>
		<li><a href="?_a=shop&_u=sp.visit_record" class="am-text-default">
				<span
					class="am-icon-btn am-icon-file-text am-text-primary"></span><br>今日商品pv<br><?php echo $cnts['product_pv']; ?>
			</a></li>

		<li><a href="?_a=shop&_u=sp.visit_record" class="am-text-success">
				<span
					class="am-icon-btn am-icon-file-text am-text-success"></span><br>今日商品uv<br><?php echo $cnts['product_uv']; ?>
			</a></li>

	</ul>

	<div class="am-g">


			<div class="am-u-md-3">
				手机扫一扫,访问
				<a target="_blank" href="<?php echo DomainMod::get_app_url('shop'); ?>">
					<?php echo $shop['title'] ? $shop['title'] : '微商城'; ?></a>
				<br/>
				<?php echo '<img style="width:220px;height:220px;" src="?_a=web&_u=index.qrcode&url=' . rawurlencode(DomainMod::get_app_url('shop')) . '">'; ?>
			</div>
		<?php
		$agent_set = AgentMod::get_agent_set_by_shop_uid($shop['uid']);
		if (empty($agent_set) || !empty($agent_set['status']) || !(in_array($shop['tpl'],AgentMod::get_agent_tpl_array())))
		{
		}
		else
		{
			?>
			<div class="am-u-sm-3 am-text-left am-u-end">
				手机扫一扫,访问
				<a target="_blank" href="<?php  echo DomainMod::get_app_url('shop',0,array('_a'=>'shop','_u'=>'user.agent_center')) ; ?>">
					<?php echo ($shop['title'] ? $shop['title'] : '微商城') . '分销代理申请页面'; ?></a>
				<br/>
				<?php echo '<img style="width:220px;height:220px;" src="?_a=web&_u=index.qrcode&url=' . rawurlencode(DomainMod::get_app_url('shop',0,array('_a'=>'shop','_u'=>'user.agent_center'))) . '">'; ?>
			</div>


			<?php
		}
		?>

		<?php
		if (!empty($_REQUEST['_d']) ||
			(strncmp('fk_', WeixinMod::get_current_weixin_public('origin_id'), 3))
		)
		{
			?>
			<div class="am-u-md-4">
				您还可以
				<br/><br/>
				<span class="am-icon-info-circle"></span> 把微商城设置到 <a href="?_a=menu&_u=sp">微信菜单</a><br/>
				<span class="am-icon-info-circle"></span> 为微商城添加 <a href="?_a=keywords&_u=sp">微信关键词</a><br/>
				<span class="am-icon-info-circle"></span> <a href="?_a=mass&_u=sp">推文章</a> 告知粉丝<br/>
			</div>
		<?php } ?>
	</div>

</div>

