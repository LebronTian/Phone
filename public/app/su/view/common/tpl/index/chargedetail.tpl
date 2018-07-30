<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<title>充值详情</title>
	<link rel="stylesheet" type="text/css" href="/static/css/amazeui2.1.min.css">
	<style type="text/css">
		.charge-detail-bar{ width: 240px; height: 300px; margin: 58px auto;}	
		.charge-detail-bar button{ width: 100%; margin-bottom: 5px;}
		.charge-detail-bar>p{ text-align: center; overflow: hidden;}
		.charge-detail-bar>h2{ text-align: center; margin-top: 5px;}
		.charge-detail-bar>h2.ok{ color: #4aaa4a;}
		.charge-detail-bar>h2.err{ color: red;}
		.charge-detail-bar>p>i.am-icon-check{ color: #4aaa4a; font-size: 28px;}
		.charge-detail-bar>p>i.am-icon-close{ color: red; font-size: 28px;}
	</style>
</head>
<body>
	<?php //var_dump($order); ?>
	
	<div class="charge-detail-bar">
		<?php 
			if(!empty($order['status']) && in_array($order['status'], array(3,4))){
				echo '<p><i class="am-icon am-icon-check am-icon-lg"></i></p>
						<h2 class="ok">充值成功</h2>
						<p><button type="button" id="view-balance-btn" class="am-btn am-btn-primary">查看余额明细</button></p>
						<p><button type="button" id="back-to-charge-btn" class="am-btn am-btn-warning">返回继续充值</button>
						<button type="button" id="back-to-home-btn" class="am-btn am-btn-success">返回至首页</button></p>';
			}
			else{
				echo '<p><i class="am-icon am-icon-close am-icon-lg"></i></p>
						<h2 class="err">您还未充值</h2>
						<p><button type="button" id="back-to-charge-btn" class="am-btn am-btn-warning">立刻前去充值</button></p>
						<p><button type="button" id="view-balance-btn" class="am-btn am-btn-primary">查看余额明细</button>
						<button type="button" id="back-to-home-btn" class="am-btn am-btn-success">返回至首页</button></p>';
			}
		?>
	</div>
	
	
	<script type="text/javascript" src="/static/js/jquery2.1.min.js"></script>
	<script type="text/javascript" src="/static/js/amazeui2.1.min.js"></script>
	<script type="text/javascript">
		$(document).ready(function(){
			$('#view-balance-btn').on('click',function(){
				window.location.href = '?_easy=su.common.index.cash';
			});
			$('#back-to-charge-btn').on('click',function(){
				//window.location.href = '?_a=express&_u=index.charge';
				var url = window.localStorage.pay_return_url;
				if(url) {
					window.localStorage.removeItem('pay_return_url');
					window.location.href = url;
				}
			});
			$('#back-to-home-btn').on('click',function(){
				//window.location.href = '?_a=express&_u=index';
				var url = window.localStorage.pay_return_home_url;
				if(url) {
					window.localStorage.removeItem('pay_return_home_url');
					window.location.href = url;
				}
			});
		});	
	</script>
</body>
</html>
