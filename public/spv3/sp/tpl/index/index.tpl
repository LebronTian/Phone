<?php
uct_use_app('shop');
$shop = ShopMod::get_shop_by_sp_uid();
$order2_cnt = Dba::readOne('select count(*) from shop_order where shop_uid = '.$shop['uid'].' && status = 2');
$order8_cnt = Dba::readOne('select count(*) from shop_order where shop_uid = '.$shop['uid'].' && status = 8');
$orderyx_cnt = Dba::readOne('select count(*) from point_product_order where sp_uid = '.$shop['sp_uid']);
$today = strtotime('today');
$yesterday = strtotime('today');
$fee_today = Dba::readOne('select sum(paid_fee) from shop_order where shop_uid = '.$shop['uid'].' && paid_time >= '.$today);
$fee_yesterday = Dba::readOne('select sum(paid_fee) from shop_order where shop_uid = '.$shop['uid'].' && paid_time >= '.$yesterday.' && paid_time < '.$today);
$fee_total = Dba::readOne('select sum(paid_fee) from shop_order where shop_uid = '.$shop['uid'].' && paid_time > 0 ');


?>
<!--面包削导航位置-->
<div class="zhicwl-mib-nav" style="display: none;">
	<ul></ul>
</div>
<!--/面包削导航位置-->

<!--小程序名称-->
<div class="zhicwl-cenksp">
	<div class="zhicwl-nav">
		<h4><?php echo WeixinMod::get_current_weixin_public('public_name');?></h4>
		<ul>
			<li>
				<a href="javascript:;">
					<h5>旗舰版</h5>
				</a>
			</li>
			<li>
				<a href="javascript:;">
					<h5>商城模式</h5>
				</a>
			</li>
			<li>
				<a href="javascript:;">
					<h5>行业切换</h5>
				</a>
			</li>
		</ul>
	</div>
	<div class="zhicwl-dolprt">
		<ul>
			<li><a href="?_a=shop&_u=sp.orderlist&status=2">
				<span class="coutline important-color">
					<i></i><?php echo $order2_cnt;?></span>
				<samp>待发货订单</samp>
			</a></li>
			<li><a href="?_a=shop&_u=sp.orderlist8">
				<span class="coutline">
					<i></i><?php echo $order8_cnt;?></span>
				<samp>维权订单</samp>
			</a></li>
			<li><a href="?_a=qrposter&_u=sp.orderlist">
				<span class="coutline">
					<i></i><?php echo $orderyx_cnt;?></span>
				<samp>营销订单</samp>
			</a></li>
			<li>
				<span class="coutline">
					<i>¥</i><?php echo $fee_yesterday/100;?></span>
				<samp>昨日交易额</samp>
			</li>
			<li>
				<span class="coutline">
					<i>¥</i><?php echo $fee_today/100;?></span>
				<samp>今日交易额</samp>
			</li>
			<li>
				<span class="coutline">
					<i>¥</i><?php echo $fee_total/100;?></span>
				<samp>累计交易额</samp>
			</li>
		</ul>
	</div>
</div>
<!--/小程序名称-->

<!--小程序数据统计-->
<div class="zhicwl-trep zhicwl-tyzjlat">
	<span>小程序数据统计</span>
</div>
<?php
$y1 = date('Ymd', strtotime('yesterday'));
$y2 = date('Ymd', strtotime('yesterday -1day'));
$y7 = date('Ymd', strtotime('yesterday -7day'));
$y30 = date('Ymd', strtotime('yesterday -30day'));
$public = WeixinMod::get_current_weixin_public();
$d1 = XiaochengxuMod::get_summary_day($public, $y1);
$d2 = XiaochengxuMod::get_summary_day($public, $y2);
$d7 = XiaochengxuMod::get_summary_day($public, $y7);
$d30 = XiaochengxuMod::get_summary_day($public, $y30);
if(!$d1) {
$d1 = array("session_cnt"=> 0, 
      "visit_pv"=> 0,
      "visit_uv"=> 0,
      "visit_uv_new"=> 0,
      "stay_time_session"=> 0,  
      "visit_depth"=> 0,
	);
}
#var_export($ss);die;
$g_data = array(
	'title' => array('text' => '小程序概况'),
	'xAxis' => array(array(
		'categories' => array('上月', '上周', '前天', '昨天' ),
	)),
	'series' => array(
		array(
			'name' => '访问次数',
			'data' => array($d30['visit_pv'], $d7['visit_pv'], $d2['visit_pv'], $d1['visit_pv']),
		),
		array(
			'name' => '访问人数',
			'data' => array($d30['visit_uv'], $d7['visit_uv'], $d2['visit_uv'], $d1['visit_uv']),
		),
		array(
			'name' => '新增人数',
			'data' => array($d30['visit_uv_new'], $d7['visit_uv_new'], $d2['visit_uv_new'], $d1['visit_uv_new']),
		),
	),
);
echo '<script>var g_data = '.json_encode($g_data).';</script>';
?>
<div class="zhicwl-reatop">
	
	<!--图表-->
	<section class="show-content">
		<div class="chart-show-wrapper no-padding">
			<div id="chart-rmcqf" class="chart-container" data-highcharts-chart="0"></div>
		</div>
	</section>
	<script src="<?php echo $static_path;?>/js/highcharts-8d1615efeb.js"></script>
	<script src="<?php echo $static_path;?>/js/inject-theme-63e94b224e.js"></script>
	<script src="<?php echo $static_path;?>/js/tbdata.js"></script>
	<!--/图表-->
	<div class="zhicwl-reatop-right"> 
		<div class="zhicwl-ztgak">昨日概括  <a href="?_a=shop&_u=sp.index">更多&gt;&gt;</a></div>
		<div class="zhicwl-sulp">
			<ul>
				<li>
					<div class="zhicwl-dplmt">
						<div class="zhicwl-sulp-left">
							打开次数
							<span class="important-color"><?php echo $d1['visit_pv'];?></span>
						</div>
						<div class="zhicwl-sulp-right">
							<dl>
<dd>日<span><?php echo !empty($d2['visit_pv'])  && ($d2['visit_pv'] != 0) ? sprintf('%.2f',100*($d2['visit_pv'] - $d1['visit_pv'])/$d2['visit_pv']).'%' : '-' ?></span></dd>
<dd>周<span><?php echo !empty($d7['visit_pv'])  && ($d7['visit_pv'] != 0) ? sprintf('%.2f',100*($d7['visit_pv'] - $d1['visit_pv'])/$d7['visit_pv']).'%' : '-' ?></span></dd>
<dd>月<span><?php echo !empty($d30['visit_pv']) && ($d30['visit_pv'] != 0) ? sprintf('%.2f',100*($d30['visit_pv'] - $d1['visit_pv'])/$d30['visit_pv']).'%' : '-' ?></span></dd>
							</dl>
						</div>
					</div>
				</li>
				<li>
					<div class="zhicwl-dplmt">
					<div class="zhicwl-sulp-left">
						访问人数
						<span><?php echo $d1['visit_uv'];?></span>
					</div>
					<div class="zhicwl-sulp-right">
						<dl>
<dd>日<span><?php echo !empty($d2['visit_uv'])  && ($d2['visit_uv'] != 0) ? sprintf('%.2f',100*($d2['visit_uv'] - $d1['visit_uv'])/$d2['visit_uv']).'%' : '-' ?></span></dd>
<dd>周<span><?php echo !empty($d7['visit_uv'])  && ($d7['visit_uv'] != 0) ? sprintf('%.2f',100*($d7['visit_uv'] - $d1['visit_uv'])/$d7['visit_uv']).'%' : '-' ?></span></dd>
<dd>月<span><?php echo !empty($d30['visit_uv']) && ($d30['visit_uv'] != 0) ? sprintf('%.2f',100*($d30['visit_uv'] - $d1['visit_uv'])/$d30['visit_uv']).'%' : '-' ?></span></dd>
						</dl>
					</div>
					</div>
				</li>
				<li>
					<div class="zhicwl-dplmt">
					<div class="zhicwl-sulp-left">
						新访问用户数
						<span><?php echo $d1['visit_uv_new'];?></span>
					</div>
					<div class="zhicwl-sulp-right">
						<dl>
<dd>日<span><?php echo !empty($d2['visit_uv_new'])  && ($d2['visit_uv_new'] != 0) ? sprintf('%.2f',100*($d2['visit_uv_new'] - $d1['visit_uv_new'])/$d2['visit_uv_new']).'%' : '-' ?></span></dd>
<dd>周<span><?php echo !empty($d7['visit_uv_new'])  && ($d7['visit_uv_new'] != 0) ? sprintf('%.2f',100*($d7['visit_uv_new'] - $d1['visit_uv_new'])/$d7['visit_uv_new']).'%' : '-' ?></span></dd>
<dd>月<span><?php echo (!empty($d30['visit_uv_new']) && ($d30['visit_uv_new'] != 0)) ? sprintf('%.2f',100*($d30['visit_uv_new'] - $d1['visit_uv_new'])/$d30['visit_uv_new']).'%' : '-' ?></span></dd>
						</dl>
					</div>
					</div>
				</li>
				<li style="display:none;">
					<div class="zhicwl-dplmt">
					<div class="zhicwl-sulp-left">
						分享次数/人数
						<span>24545/55464</span>
					</div>
					<div class="zhicwl-sulp-right">
						<dl>
							<dd>日<span>-100%</span></dd>
							<dd>周<span>-100%</span></dd>
							<dd>月<span>-100%</span></dd>
						</dl>
					</div>
					</div>
				</li>						
			</ul>
		</div>
	</div>
</div>
<!--/小程序数据统计-->

<!--常用功能-->
<div class="zhicwl-trep zhicwl-tyzjlat">
	<span>常用功能</span>
</div>		
<div class="zhicwl-cyplsb">
	<ul>
		<li><a href="?_a=bargain&_u=sp"><span><img src="/spv3/sp/static/images/pageicon/kanjia.png" width="24px" height="24px"></span></span><samp>砍价</samp></a></li>
		<li><a href="?_a=shoptuan&_u=sp"><span><img src="/spv3/sp/static/images/pageicon/pintuan.png" width="24px" height="24px"></span></span><samp>拼团</samp></a></li>
		<li><a href="?_a=shopsec&_u=sp"><span><img src="/spv3/sp/static/images/pageicon/miaosha.png" width="24px" height="24px"></span></span><samp>秒杀</samp></a></li>
		<li><a href="?_a=reward&_u=sp"><span><img src="/spv3/sp/static/images/pageicon/choujiang.png" width="24px" height="24px"></span><samp>抽奖</samp></a></li>
		<li><a href="?_a=shopman&_u=sp"><span><img src="/spv3/sp/static/images/pageicon/manjian.png" width="24px" height="24px"></span><samp>满减/送</samp></a></li>
		<li><a href="?_a=shopdist&_u=sp"><span><img src="/spv3/sp/static/images/pageicon/fenxiao.png" width="24px" height="24px"></span><samp>分销商城</samp></a></li>
		<li><a href="?_a=form&_u=sp"><span><img src="/spv3/sp/static/images/pageicon/yuyue.png" width="24px" height="24px"></span><samp>预约</samp></a></li>
		<li><a href="?_a=shopcoupon&_u=sp"><span><img src="/spv3/sp/static/images/pageicon/youhuiquan.png" width="24px" height="24px"></span><samp>优惠券</samp></a></li>
		<li><a href="?_a=qrposter&_u=sp"><span><img src="/spv3/sp/static/images/pageicon/jifen.png" width="24px" height="24px"></span><samp>积分兑换</samp></a></li>
		<li><a href="?_a=bargain&_u=sp"><span><img src="/spv3/sp/static/images/pageicon/hangye.png" width="24px" height="24px"></span><samp>行业解决方案</samp></a></li>
	</ul>
</div>
<!--/常用功能-->
<!--营销插件-->
<div class="zhicwl-trep zhicwl-tyzjlat">
	<span>营销插件</span>
</div>		
<div class="zhicwl-yxclsj">
	<ul>
		<li>
			<a href="?_a=shoptuan&_u=sp">
				<div class="zhicwl-yxclsj-left"><img src="/spv3/sp/static/images/100100/pintuan.png" width="34px" height="34px"></div>
				<div class="zhicwl-yxclsj-right">
					<h6>拼团</h6>
					<samp>设置产品团购</samp>
				</div>
			</a>
			<span class="label-hot">Hot</span>
		</li>
		<li>
			<a href="?_a=bargain&_u=sp">
				<div class="zhicwl-yxclsj-left"><img src="/spv3/sp/static/images/100100/kanjia.png" width="34px" height="34px"></div>
				<div class="zhicwl-yxclsj-right">
					<h6>砍价</h6>
					<samp>营销插件</samp>
				</div>
			</a>
			<span class="label-hot">Hot</span>
		</li>
		<li>
			<a href="?_a=shopsec&_u=sp">
				<div class="zhicwl-yxclsj-left"><img src="/spv3/sp/static/images/100100/miaosha.png" width="34px" height="34px"></div>
				<div class="zhicwl-yxclsj-right">
					<h6>秒杀</h6>
					<samp>引导客户快速成交</samp>
				</div>
			</a>
			<span class="label-hot">Hot</span>
		</li>
		<li>
			<a href="?_a=reward&_u=sp">
				<div class="zhicwl-yxclsj-left"><img src="/spv3/sp/static/images/100100/choujiang.png" width="34px" height="34px"></div>
				<div class="zhicwl-yxclsj-right">
					<h6>抽奖</h6>
					<samp>与客户互动，抽取奖品</samp>
				</div>
			</a>
			<span class="label-hot">Hot</span>
		</li>
		<li>
			<a href="?_a=shopcoupon&_u=sp">
				<div class="zhicwl-yxclsj-left"><img src="/spv3/sp/static/images/100100/youhuiquan.png" width="34px" height="34px"></div>
				<div class="zhicwl-yxclsj-right">
					<h6>优惠券</h6>
					<samp>向客户发放店铺优惠券</samp>
				</div>
			</a>
		</li>
		<li>
			<a href="?_a=qrposter&_u=sp">
				<div class="zhicwl-yxclsj-left"><img src="/spv3/sp/static/images/100100/jifen.png" width="34px" height="34px"></div>
				<div class="zhicwl-yxclsj-right">
					<h6>积分兑换</h6>
					<samp>让客户用积分兑换产品</samp>
				</div>
			</a>
		</li>
		<li>
			<a href="?_a=shopman&_u=sp">
				<div class="zhicwl-yxclsj-left"><img src="/spv3/sp/static/images/100100/manjian.png" width="34px" height="34px"></div>
				<div class="zhicwl-yxclsj-right">
					<h6>满减/送</h6>
					<samp>购买一定金额优惠</samp>
				</div>
			</a>
		</li>
		<li>
			<a href="?_a=shopdist&_u=sp">
				<div class="zhicwl-yxclsj-left"><img src="/spv3/sp/static/images/100100/fenxiao.png" width="34px" height="34px"></div>
				<div class="zhicwl-yxclsj-right">
					<h6>分销</h6>
					<samp>让客户来推广产品，赚佣金</samp>
				</div>
			</a>
		</li>
		<li>
			<a href="?_a=book&_u=sp">
				<div class="zhicwl-yxclsj-left"><img src="/spv3/sp/static/images/100100/yuyue.png" width="34px" height="34px"></div>
				<div class="zhicwl-yxclsj-right">
					<h6>预约</h6>
					<samp>预约活动、产品销售</samp>
				</div>
			</a>
		</li>
		<li>
			<a href="?_a=qrposter&_u=sp">
				<div class="zhicwl-yxclsj-left"><img src="/spv3/sp/static/images/100100/erweima.png" width="34px" height="34px"></div>
				<div class="zhicwl-yxclsj-right">
					<h6>二维码海报</h6>
					<samp>海报分享推广产品</samp>
				</div>
			</a>
			<span class="label-stay">Stay</span>
		</li>				
	</ul>
</div>
<!--/营销插件-->
<!--他们用的很好-->
<div class="zhicwl-trep zhicwl-tyzjlat">
	<span>他们用的很好</span>
</div>

<div class="zhicwl-tmydhre">
	<ul>
		<li>
			<a href="javascript:;">
				<div class="zhicwl-akmsnvrt">
					<img src="<?php echo $static_path;?>/images/userpic17.png">
				</div>
				<h5>张三</h5>
			</a>
		</li>
		<li>
			<a href="javascript:;">
				<div class="zhicwl-akmsnvrt">
					<img src="<?php echo $static_path;?>/images/userpic17.png">
				</div>
				<h5>张四</h5>
			</a>
		</li>
	</ul>
</div>
<!--/他们用的很好-->

<div class="iekdl" style="height:80px;"></div>
<script>
$(function(){
	if($('.kzlst2').hasClass('zy-sq2')) {
		$('.kzlst2').click();
	}
});
</script>



