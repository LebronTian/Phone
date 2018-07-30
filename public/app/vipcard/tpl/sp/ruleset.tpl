<div class="am-u-lg-0 am-u-md-32 am-u-sm-centered">

	<div class="am-cf am-padding">
		<div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">规则设置</strong> /
			<small></small>
		</div>
	</div>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			开启审核
		</div>
		<div class="am-u-sm-8 am-u-end">
			<label class="am-checkbox">
				<input type="checkbox" id="id_check" data-am-ucheck <?php if (!empty($vip_card_set['need_check']))
				{
					echo 'checked';
				} ?>>
				新会员加入是否需要审核，默认不需要</label>
		</div>
	</div>


	<div class="am-form">

		<div class="am-g am-margin-top-sm">
			<div class="am-u-sm-2 am-text-right">&nbsp;</div>
			<div class="am-u-sm-2 am-u-end am-text-center"><span>积分（不超过10位）</span></div>
			<div class="am-u-sm-2 am-u-end am-text-center"><span>头衔</span></div>
			<div class="am-u-sm-2 am-u-end am-text-center"><span>商城折扣（单位：折）</span></div>
		</div>
		<div class="data-rule">
			<?php

			$html            = '';
			$rank_rule_count = count($vip_card_set['rank_rule']);
			$info_arr        = array('', '购买者拿到的佣金比例', '购买者拿到的佣金比例', '购买者拿到的佣金比例');
			if(!empty($vip_card_set['rank_rule']))
			foreach ($vip_card_set['rank_rule'] as $rk => $rv)
			{
				$html .= '<div class="am-g am-margin-top-sm"><div class="am-u-sm-2 am-text-right">大于或等于</div>';
				$html .= '<div class="am-u-sm-2 am-u-end">';
				$html .= '<input type="number" id="id_rule_point" min="0"  placeholder="积分" value="';
				$html .= (empty($rk) ? 0 : $rk) . '"></div>';

				$html .= '<div class="am-u-sm-2 am-u-end">';
				$html .= '<input type="text" id="id_rule_name"  placeholder="等级头衔" value="';
				$html .= (empty($rv['rank_name']) ? '' : $rv['rank_name']) . '"></div>';

				$html .= '<div class="am-u-sm-2 am-u-end">';
				$html .= '<input type="number" max="10" min="0" step="0.1"  id="id_rule_discount"  placeholder="购物折扣" value="';
				$html .= (empty($rv['rank_discount']) ? '' : ($rv['rank_discount']/10)) . '"></div>';
				$html .= '<div><span class="am-btn  am-btn-danger delete_rule_rank">删除<span></div>';

				$html .= '</div>';

			}
			echo $html;
			?>
		</div>
		<div class="am-g am-margin-top-sm">
			<div class="am-u-sm-2 am-text-right">
				&nbsp;
			</div>
			<div class="am-u-sm-10 am-u-end">
				<button class="am-u-sm-8 am-btn am-btn-lg am-btn-success add_rule_rank">增加一个等级</button>
			</div>
		</div>
		<div class="am-g am-margin-top-sm">
			<div class="am-u-sm-2 am-text-right">
				&nbsp;
			</div>
			<div class="am-u-sm-8 am-u-end">
				<p>
					<button class="am-btn am-btn-lg am-btn-primary saveBtn">保存</button>
				</p>
			</div>
		</div>

	</div>
	<div class="hide-explame" style="display:none">
		<div class="am-g am-margin-top-sm">
			<div class="am-u-sm-2 am-text-right">大于或等于</div>
			<div class="am-u-sm-2 am-u-end"><input type="number" id="id_rule_point" min="0" placeholder="积分" ">
			</div>
			<div class="am-u-sm-2 am-u-end"><input type="text" id="id_rule_name" placeholder="等级头衔" ></div>
			<div class="am-u-sm-2 am-u-end"><input type="number" max="10" min="0" step="0.1"  id="id_rule_discount"  placeholder="购物折扣" ></div>
			<div><span class="am-btn  am-btn-danger delete_rule_rank">删除<span></div>
		</div>
	</div>

</div>
<script>
	var uid = <?php echo(!empty($vip_card_set['uid']) ? $vip_card_set['uid']:0) ?>;
</script>
<?php
$extra_js = array(
	'/app/vipcard/static/js/ruleset.js',
)
?>



