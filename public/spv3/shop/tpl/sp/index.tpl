<?php
//新版不能把首页指定到商城了
uct_use_app('sp');
if(($index = SpMod::get_index()) && ($index['type'] == 'redirect') && 
	($index['url'] == '?_a=shop&_u=sp' || $index['url'] == '?_easy=shop.sp.index')) {
	SpMod::set_index('null');
echo '<script>window.location.href="?_a=sp";</script>';
	exit();
}
?>

<link rel="stylesheet" href="/app/shop/static/css/index.css"/>

<div class="am-padding">
	<div class="news-content">
		<ul class="am-avg-sm-4 am-thumbnails ml0 mr0">
			<li style="background-color:#2A7EF0"><a target="_self" href="?_a=shop&_u=sp.visit_record"><img src="/app/shop/static/images/icon-money.png"><div class="li-title"><h1><?php echo sprintf('%.2f',$cnts['today_deal_cnt']/100); ?></h1><p>今日销售总额</p></div></a></li>
			<li style="background-color:#FF4526"><a target="_self" href="?_a=shop&_u=sp.orderlist"><img src="/app/shop/static/images/icon-tongji.png"><div class="li-title"><h1><?php echo $cnts['today_orders_cnt']; ?></h1><p>今日订单量</p></div></a></li>
			<li style="background-color:#8E71B2"><a target="_self" href="?_a=shop&_u=sp.bizlist"><img src="/app/shop/static/images/icon-ruzhu.png"><div class="li-title"><h1><?php echo $cnts['today_addbiz_cnt']; ?></h1><p>今日入驻商家</p></div></a></li>
			<li style="background-color:#3CAE48"><a target="_self" href="?_a=su&_u=sp.fanslist"><img src="/app/shop/static/images/icon-per.png"><div class="li-title"><h1><?php echo $cnts['today_adduser_cnt']; ?></h1><p>今日注册会员</p></div></a></li>
		</ul>
	</div>
	<div class="zhicwl-yxclsj-self" style="margin-top: 15px;">
		<ul>
			<li>
				<a target="_self" href="?_a=shop&_u=sp.orderlist&status=1">
					<div class="zhicwl-yxclsj-right">
					<h6><?php echo $cnts['wait_pay_cnt']; ?></h6>
					<samp>待付款</samp>
				</div>
				</a>
			</li>
			<li>
				<a target="_self" href="?_a=shop&_u=sp.orderlist&status=2">
					<div class="zhicwl-yxclsj-right">
					<h6><?php echo $cnts['wait_delivery_cnt']; ?></h6>
					<samp>待发货</samp>
				</div>
				</a>
			</li>
			<li>
				<a target="_self" href="?_a=shop&_u=sp.orderlist&status=3">
					<div class="zhicwl-yxclsj-right">
					<h6><?php echo $cnts['wait_receipt_cnt']; ?></h6>
					<samp>已发货</samp>
				</div>
				</a>
			</li>
			<li>
				<a target="_self" href="?_a=shop&_u=sp.orderlist&status=8">
					<div class="zhicwl-yxclsj-right">
					<h6><?php echo $cnts['wait_negotation_cnt']; ?></h6>
					<samp>退款中</samp>
				</div>
				</a>
			</li>
			<li>
				<a target="_self" href="?_a=shop&_u=sp.orderlist&status=4">
					<div class="zhicwl-yxclsj-right">
					<h6><?php echo $cnts['ok_cnt']; ?></h6>
					<samp>已完成</samp>
				</div>
				</a>
			</li>
		</ul>
	</div>
	<!-- <div class="order-content">
		<ul class="am-avg-sm-5 am-thumbnails">
			<li><a target="_self" href="?_a=shop&_u=sp.orderlist&status=1"><span style="background-color:#ff9575;" class="am-icon-btn am-icon-money"></span><div class="li-title" ><h1><?php echo $cnts['wait_pay_cnt']; ?></h1><p>待付款</p></div></a></li>

			<li><a target="_self" href="?_a=shop&_u=sp.orderlist&status=2"><span style="background-color:#b3cb91;" class="am-icon-btn am-icon-cube"></span><div class="li-title"><h1><?php echo $cnts['wait_delivery_cnt']; ?></h1><p>待发货</p></div></a></li>

			<li><a target="_self" href="?_a=shop&_u=sp.orderlist&status=3"><span style="background-color:#f3ce9a;" class="am-icon-btn am-icon-truck"></span><div class="li-title"><h1><?php echo $cnts['wait_receipt_cnt']; ?></h1><p>已发货</p></div></a></li>

			<li><a target="_self" href="?_a=shop&_u=sp.orderlist&status=8"><span style="background-color:#a590db;" class="am-icon-btn am-icon-reply"></span><div class="li-title"><h1><?php echo $cnts['wait_negotation_cnt']; ?></h1><p>退款中</p></div></a></li>

			<li><a target="_self" href="?_a=shop&_u=sp.orderlist&status=4"><span  style="background-color:#51daed;" class="am-icon-btn am-icon-check"></span><div class="li-title"><h1><?php echo $cnts['ok_cnt']; ?></h1><p>已完成</p></div></a></li>
			<li><a target="_self" href="?_a=shop&_u=sp.orderlist&status=5"><span style="background-color:#63ceb2;" class="am-icon-btn am-icon-edit"></span><div class="li-title"><h1>444</h1><p>待评价</p></div></a></li>
		</ul>
	</div> -->


	<div class="content">
		<div id="id-echart">
			<div class="zhicwl-trep zhicwl-tyzjlat bgnone pl0">
				<span>商城统计</span>
			</div>
			<div class="chart-content">
				<!--图表-->
				<section class="chart-content-show">
						<div id="id_echart" class="chart-container"  style="height: 500px;">
								图表加载中...
							</div>
				</section>
			</div>
		</div>
		<div id="id-link">

				<div class="zhicwl-trep zhicwl-tyzjlat bgnone pl0" style="text-align: left;">
					<span>运营快速入口</span>
				</div>
			<div class="chart-content-rigth">
				<div id="button-link">
					<ul class="am-avg-sm-2 am-thumbnails ml0 mr0">
						<!--<li><a target="_self" href="?_a=shop&__sp_uid=2"><span style="background-color:#88d8f9;" class="am-icon-btn am-icon-home"></span><div class="li-title">网站首页</div></a></li>-->
						<li><a target="_self" href="?_a=shop&_u=sp.orderlist"><span style="background-color:#88d8f9;" class="am-icon-btn am-icon-files-o"></span><span class="li-title" >订单列表</span></a></li>
						<li><a target="_self" href="?_a=su&_u=sp.fanslist"><span style="background-color:#88d8f9;" class="am-icon-btn am-icon-users"></span><span class="li-title">用户管理</span></a></li>
						<li><a target="_self" href="?_a=vipcard&_u=sp.vip_card_list"><span style="background-color:#88d8f9;" class="am-icon-btn am-icon-list-alt"></span><span class="li-title">会员管理</span></a></li>
						<li><a target="_self" href="?_a=shop&_u=sp.order_record"><span style="background-color:#88d8f9;" class="am-icon-btn am-icon-line-chart"></span><span class="li-title">货单统计</span></a></li>
						<li><a target="_self" href="?_a=shop&_u=sp.shopcoupon"><span style="background-color:#88d8f9;" class="am-icon-btn am-icon-money"></span><span class="li-title">优惠券管理</span></a></li>
						<li><a target="_self" href="?_a=shop&_u=sp.distribution_user_list"><span style="background-color:#88d8f9;" class="am-icon-btn am-icon-gear"></span><span class="li-title" >分销设置</span></a></li>
					</ul>
				</div>
				<div class="title">
					微信扫一扫,访问商城
				</div>
				<div class="wxqrcode">
					<?php
					 if($wx['public_type'] != 8){
					     echo '<img style="width:220px;height:220px;" src="?_a=web&_u=index.qrcode&url=' . rawurlencode(DomainMod::get_app_url('shop',0,array('_a'=>'shop','_u'=>'index.index'))) . '">';
					 }
					 ?>
				</div>
			</div>
			<!--<div style="margin: 10px;">
				<div class="am-fr">
					<div class="am-input-group am-input-group-sm">
						<input type="text" class="am-form-field option_key" value="" placeholder="页面搜索">
                <span class="am-input-group-btn">
                  <button class="am-btn am-btn-default option_key_btn" type="button">搜索</button>
                </span>
					</div>
				</div>
			</div>-->

		</div>

	</div>

</div>

<script>
	$('.option_key_btn').click(function(){
		var key = $('.option_key').val();
		//允许关键字为空，表示清空条件
		if(1 || key) {
//			window.location.href='?_a=sp&_u=index.links&key='+key;
			window.open('?_a=sp&_u=index.links&key='+key);
		}
	});
	$('.option_key').keydown(function(e){
		if(e.keyCode == 13) {
			$('.option_key_btn').click();
		}
	});



	var uct_token = '<?php echo $uct_token ?>';
	var wx_type = '<?php echo $wx['public_type'] ?>';
	console.log(wx_type);
	if((wx_type & 8) == 8){
		var encodeUrl = encodeURIComponent("page/index/index");
		$('.wxqrcode').append('<img style="width:200px;height:200px;margin-top: 20px;" src="?_uct_token='+uct_token+'&_u=xiaochengxu.qrcode&path='+encodeUrl+'">');
	}


</script>


<?php
$extra_js =  array(
		'/static/js/echarts/echarts.js',
		'/app/shop/static/js/index.js',
);
echo '<script>var g_echarts=' . json_encode($echarts) . ';</script>';
?>



