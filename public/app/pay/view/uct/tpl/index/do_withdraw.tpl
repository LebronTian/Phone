<!doctype html>
<html class="no-js">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title><?php echo (isset($info['spname'])?$info['spname']:'快马加鞭微信服务平台').'- 收银台'; ?></title>
    <meta name="description" content="快马加鞭微信公众号服务平台">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp" />
    <link rel="icon" type="image/png" href="/i/favicon.png">
    <link rel="apple-touch-icon-precomposed" href="/i/app-icon72x72@2x.png">
    <meta name="apple-mobile-web-app-title" content="Amaze UI" />
    <link rel="stylesheet" href="/static/css/amazeui2.1.min.css"/>
    <link rel="stylesheet" href="/app/sp/static/css/index.css"/>
</head>

<body>

<header class="am-topbar admin-header">
    <div class="am-topbar-brand">
        <a target="_blank" href="?"><strong><?php echo isset($info['spname'])?$info['spname']:'快马加鞭'; ?></strong> <small>自助提现</small></a>
    </div>
</header>

<style>
    .info p{
        font-size: large;
    }
</style>
<link rel="stylesheet" href="/app/pay/view/uct/pay.css">
<div class="am-u-lg-8 am-u-md-12 am-u-sm-centered info">
    <div class="am-g">
        <div class="am-u-sm-4 left-box am-form">
			<?php
				#var_export($cfg);
				if(empty($cfg['enabled'])) {
					echo '<p>提现功能已关闭！</p>';
				}
				else {
					if(!empty($cfg['withdraw_rule']['min_price'])) {
						echo '<p>满 '.($cfg['withdraw_rule']['min_price']/100).'元即可提现</p>';
					}
					if(!empty($cfg['withdraw_rule']['max_price'])) {
						echo '<p>单笔最高 '.($cfg['withdraw_rule']['max_price']/100).'元</p>';
					}
					if(!empty($cfg['withdraw_rule']['max_price_day'])) {
						echo '<p>每日最高 '.($cfg['withdraw_rule']['max_price_day']/100).'元</p>';
					}
				}
			?>
			
			<p>您当前余额: <a href="?_easy=vipcard.single.index.cash">&yen; <?php echo !empty($point['cash_remain']) ? $point['cash_remain']/100 : 0; ?></a></p>
			<p><input type="text" id="id_cash" placeholder="请输入提现金额"></p>
			<a class="am-btn am-btn-lg am-btn-primary" id="id_withdraw">提现</a>
        </div>
    </div>

    <script src="/static/js/jquery2.1.min.js"></script>
    <script src="/static/js/amazeui2.1.min.js"></script>
    <script src="/static/js/tip.js"></script>
<script>

$('#id_withdraw').click(function(){
	var cash = 100 * $('#id_cash').val();
	if(!cash) return alert('输入金额!');

	$.post('?_a=pay&_u=index.do_withdraw', {cash: cash}, function(ret){
		console.log(ret);
		ret = $.parseJSON(ret);
		if(ret && (ret.errno == 0 || ret.data)) {
			if(ret.errno == 303) {
				showTip('ok', '申请成功！正在等待审核 ', 3000);
			}
			else {
				showTip('ok', '成功！', 3000);
			}
		}
		else {
			showTip('err', '错误！' + ret.errstr, 3000);
		}
	});
});

</script>

</div>


<footer style="padding-top: 50px;">
    <hr>
   <?php
        echo '<!-- <p class="am-u-lg-8 am-u-md-12 am-u-sm-centered">© 2015 深圳市优创智投科技有限公司 | ☏ 0755-36300086</p> -->';
   ?>
</footer>
</body>
</html>
