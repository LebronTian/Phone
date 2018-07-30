<?php
$sp_uid = AccountMod::get_current_service_provider('uid');
$sum = Dba::readRowAssoc('select sum(cash_remain) as sum_remain,  sum(cash_transfered) as sum_transfered, sum(point_max) as sum_total_pt, sum(point_remain) as sum_remain_pt, sum(point_transfered) as sum_transfered_pt from user_points join service_user on user_points.su_uid = service_user.uid where service_user.sp_uid = '.$sp_uid);
$sum['sum_total'] = $sum['sum_remain'] + $sum['sum_transfered'];
?>
<style>
.zhicwl-yxclsj-left {
	width:48px;
	height:48px;
	background:white;
}
.zhicwl-yxclsj-left span{
color: #0e90d2;
}
</style>
<div class="am-cf am-padding">
	<div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">资产概况</strong> /
		<small></small>
	</div>
</div>
<hr>

<div class="zhicwl-yxclsj">
<ul>
	<li>
		<a href="?_a=su&_u=sp.cashset">
		<div class="zhicwl-yxclsj-left "><span class="am-icon-btn am-icon-money"></span></div>
			<div class="zhicwl-yxclsj-right">
			<h6><?php echo $sum['sum_total']/100?></h6>
			<samp>总资产(&yen;)</samp>
		</div>
		</a>
	</li>
	<li>
		<a href="?_a=su&_u=sp.sucashlist&type=1">
		<div class="zhicwl-yxclsj-left "><span class="am-icon-btn am-icon-money"></span></div>
			<div class="zhicwl-yxclsj-right">
			<h6><?php echo $sum['sum_transfered']/100?></h6>
			<samp>已消费(&yen;)</samp>
		</div>
		</a>
	</li>

	<li>
		<a href="?_a=su&_u=sp.sucashlist&type=2">
		<div class="zhicwl-yxclsj-left "><span class="am-icon-btn am-icon-money"></span></div>
			<div class="zhicwl-yxclsj-right">
			<h6><?php echo $sum['sum_remain']/100?></h6>
			<samp>资金池(&yen;)</samp>
		</div>
		</a>
	</li>
</ul>
</div>

<hr>
<div class="zhicwl-yxclsj">
<ul>
	<li>
		<a href="?_a=su&_u=sp.supointlist">
		<div class="zhicwl-yxclsj-left "><span class="am-icon-btn am-icon-money"></span></div>
			<div class="zhicwl-yxclsj-right">
			<h6><?php echo $sum['sum_total_pt']?></h6>
			<samp>总积分</samp>
		</div>
		</a>
	</li>
	<li>
		<a href="?_a=su&_u=sp.supointlist&type=1">
		<div class="zhicwl-yxclsj-left "><span class="am-icon-btn am-icon-money"></span></div>
			<div class="zhicwl-yxclsj-right">
			<h6><?php echo $sum['sum_transfered_pt']?></h6>
			<samp>已使用</samp>
		</div>
		</a>
	</li>

	<li>
		<a href="?_a=su&_u=sp.supointlist&type=2">
		<div class="zhicwl-yxclsj-left "><span class="am-icon-btn am-icon-money"></span></div>
			<div class="zhicwl-yxclsj-right">
			<h6><?php echo $sum['sum_remain_pt']?></h6>
			<samp>积分池</samp>
		</div>
		</a>
	</li>
</ul>
</div>
