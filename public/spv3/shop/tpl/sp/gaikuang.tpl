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
<script src="https://cdn.bootcss.com/echarts/4.0.4/echarts-en.common.js"></script>

<div class="am-padding gaikuang-self">
	<div class="am-g">
		<div class="am-cf">
			<div class="am-fl gaikuang-img">
				<img src="<?php echo $shop['logo'] ? $shop['logo'] : '/spv3/sp/static/images/userpic17.png' ?>">
			</div>
			<div class="am-fl">
				<p class="gaikuang-title"><?php echo $shop['title'] ?></p>
				<div class="gaikuang-icons">
					<ul class="am-cf" style="display:none;">
						<li class="am-fl"><i class="am-icon-check-circle-o"></i>个人认证</li>
						<li class="am-fl"><i class="am-icon-check-circle-o click-green"></i>担保交易</li>
						<li class="am-fl"><i class="am-icon-check-circle-o"></i>线下门店</li>
					</ul>
				</div>
			</div>
			<div class="am-fr gaikuang-btns">
				<a href="?_a=shop&_u=sp.addproduct" target="_blank"><button class="am-btn am-btn-primary blue-self">发布商品</button></a>
				<a href="?_easy=shop.sp.visualview" target="_blank"><button class="am-btn am-btn-primary blue-self">店铺装修</button></a>
				<button class="am-btn gaikuang-btn-blue">访问店铺</button>
			</div>
		</div>
		<div class="zhicwl-yxclsj-self" style="margin-top: 15px;">
			<ul>
				<li>
					<a href="?_a=su&_u=sp.fanslist">
						<div class="zhicwl-yxclsj-right">
						<h6><?php echo $cnts['shop_pv']; ?></h6>
						<samp>今日商城PV</samp>
					</div>
					</a>
				</li>
				<li>
					<a href="?_a=su&_u=sp.fanslist">
						<div class="zhicwl-yxclsj-right">
						<h6><?php echo $cnts['shop_uv']; ?></h6>
						<samp>今日商城UV</samp>
					</div>
					</a>
				</li>
				<li>
					<a href="?_a=su&_u=sp.fanslist">
						<div class="zhicwl-yxclsj-right">
						<h6><?php echo $cnts['product_pv']; ?></h6>
						<samp>今日商品PV</samp>
					</div>
					</a>
				</li>
				<li>
					<a href="?_a=su&_u=sp.fanslist">
						<div class="zhicwl-yxclsj-right">
						<h6><?php echo $cnts['product_uv']; ?></h6>
						<samp>今日商品UV</samp>
					</div>
					</a>
				</li>
<?php
$cnts['pages_cnt'] = Dba::readOne('select count(*) from xiaochengxu_pages where sp_uid = '.$shop['sp_uid']);
$cnts['product_cnt'] = Dba::readOne('select count(*) from product where shop_uid = '.$shop['uid']);
?>
				<li>
					<a href="?_a=sp&_u=index.xcxpagelist">
						<div class="zhicwl-yxclsj-right">
						<h6 class="deep-blue"><?php echo $cnts['pages_cnt']; ?></h6>
						<samp>微页面</samp>
					</div>
					</a>
				</li>
				<li>
					<a href="?_a=shop&_u=sp.productlist">
						<div class="zhicwl-yxclsj-right">
						<h6 class="deep-blue"><?php echo $cnts['product_cnt']; ?></h6>
						<samp>商品</samp>
					</div>
					</a>
				</li>
				</ul>
			</div>
			<div class="content gaikuang-content">
						<div class="zhicwl-trep zhicwl-tyzjlat am-cf" style="margin-bottom: 10px;">
							<div class="am-fl"><span>流量趋势</span></div>
							<div class="am-fl"><a href="?_easy=shop.sp.visit_record">详细 》</a></div>	
							<div class="am-fr"><a href="javascript:;"><i class="am-icon-question-circle"></i></a></div>
						</div>
						<div class="gaikuang-content-show">
							
						<div id="id_echart" class="am-padding am-margin admin-content-list mg0" style="height: 500px;width: 90%">
							图表加载中...
						</div>
						</div>
			</div>
			<div class="content gaikuang-content">
						<div class="zhicwl-trep zhicwl-tyzjlat am-cf" style="margin-bottom: 10px;">
							<div class="am-fl"><span>流量趋势</span></div>
							<div class="am-fl"><a href="javascript:;">详细 》</a></div>	
							<div class="am-fr"><a href="javascript:;"><i class="am-icon-question-circle"></i></a></div>
						</div>
						<div id="id_echart" class="am-padding am-margin admin-content-list gaikuang-content-show mg0">
							<div class="gaikuang-tips">
								<h3>暂无数据</h3>
								<p>你可以 <a href="?_a=shop&_u=sp.addproduct">创建商品</a> 或 <a href="?_easy=shop.sp.visualview">店铺装修</a>，发送给您的微信、微博粉丝。</p>
							</div>
						</div>
			</div>
	</div>
</div>

<?php
//echo "<script>var r_uid=" . $option['r_uid'] . ";</script>";
$extra_js = array(
	'/static/js/echarts/echarts.js',
	'/spv3/shop/static/js/gaikuang.js',
);
echo '<script>var g_echarts=' . json_encode($echarts) . ';</script>';
?>
