<div class="am-u-lg-0 am-u-md-32 am-u-sm-centered">

	<div class="am-cf am-padding">
		<div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">会员储值</strong> /
			<small></small><a href="?_a=su&_u=sp.sucashlist">储值记录</a>
		</div>
	</div>
<hr>

	<div class="am-g am-margin-top-sm">
		<div class="am-u-sm-2 am-text-right">
			储值规则
		</div>
		<div class="am-u-sm-8 am-u-end">
			<label class="am-checkbox">
				<input type="checkbox" id="id_check" data-am-ucheck <?php if (!empty($data['status']))
				{
					echo 'checked';
				} ?>>
				开启</label>
		</div>
	</div>

	<div class="am-g am-margin-top-sm form_status">
		<div class="am-u-sm-2 am-text-right">
			储值后自动成为会员
		</div>
		<div class="am-u-sm-8 am-u-end">
			<label class="am-checkbox">
				<input type="checkbox" id="id_yes" data-am-ucheck <?php if (!empty($data['cgroup']))
				{
					echo 'checked';
				} ?>>
				开启</label>
		</div>
	</div>


	<div class="am-form">

		<div class="am-g am-margin-top-sm form_status">
			<div class="am-u-sm-2 am-text-right">&nbsp;</div>
			<div class="am-u-sm-2 am-u-end am-text-center"><span>充多少(元)</span></div>
			<div class="am-u-sm-2 am-u-end am-text-center"><span>送多少(元)</span></div>
			<div class="am-u-sm-2 am-u-end am-text-center"><span>自动获得会员身份</span></div>
		</div>
		<div class="data-rule form_status">
			<?php

			$html            = '';
			$rank_rule_count = count($data['rule']);

			if(!empty($data['rule']))
			foreach ($data['rule'] as $rk => $rv)
			{
			$html .= '<div class="am-g am-margin-top-sm rules"><div class="am-u-sm-2 am-text-right">规则</div>';
				$html .= '<div class="am-u-sm-2 am-u-end">';
				$html .= '<input type="number" id="pay_cash" min="0"  placeholder="充值金额" value="';
				$html .= (empty($rv[0]) ? 0 : sprintf("%.2f", $rv[0]/100)) . '"></div>';

				$html .= '<div class="am-u-sm-2 am-u-end">';
				$html .= '<input type="number" id="get_cash" min="0"  placeholder="赠送金额" value="';
				$html .= (empty($rv[1]) ? 0 : sprintf("%.2f", $rv[1]/100)) . '"></div>';

				$html .= '<div class="am-u-sm-2 am-u-end"><select class="sel-group">';
				$html .= '<option value="">无</option>';
				foreach($groups as $rr){
					$html .= '<option value="'.$rr['uid'].'"'.($rr['uid']==$rv[2]?'selected':'').'>'.$rr['name'].'</option>';
				}
				$html .='</select></div>';

				$html .= '<div><span class="am-btn  am-btn-danger delete_rule_rank">删除<span></div>';

				$html .= '</div>';

			}
			echo $html;
			?>
		</div>
		<div class="am-g am-margin-top-sm form_status">
			<div class="am-u-sm-2 am-text-right">
				&nbsp;
			</div>
			<div class="am-u-sm-10 am-u-end">
				<button class="am-u-sm-8 am-btn am-btn-lg am-btn-success add_rule_rank">增加一条储值规则</button>
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
		<div class="am-g am-margin-top-sm rules">
			<div class="am-u-sm-2 am-text-right">规则</div>
			<div class="am-u-sm-2 am-u-end"><input type="number" id="pay_cash" min="0" placeholder="充值金额" ">
			</div>
			<div class="am-u-sm-2 am-u-end"><input type="text" id="get_cash" placeholder="赠送金额" ></div>
			<div class="am-u-sm-2 am-u-end">
					<select class="sel-group">
						<option value="">不分组</option>
						<?php foreach($groups as $k => $rr){
							echo '<option value="'.$rr['uid'].'">'.$rr['name'].'</option>';
						} ?>
					</select>
			</div>

			<div><span class="am-btn  am-btn-danger delete_rule_rank">删除<span></div>
		</div>
	</div>

</div>
<script>
	var uid = <?php echo(!empty($data['uid']) ? $data['uid']:0) ?>;
</script>
<?php
$extra_js = array(
	'/spv3/su/static/js/cashset.js',
)
?>



