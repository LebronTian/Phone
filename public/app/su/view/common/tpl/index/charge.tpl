<?php 
uct_use_app('su');
$su_uid = SuMod::require_su_uid();
$su = AccountMod::get_current_service_user();
$pt = SuPointMod::get_user_points_by_su_uid($su['uid']);
?>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<title>充值</title>
	<link rel="stylesheet" type="text/css" href="/app/express/view/v1/static/css/amazeui2.1.min.css">
	<link rel="stylesheet" type="text/css" href="/app/express/view/v1/static/css/com.css">
	<link rel="stylesheet" type="text/css" href="/app/express/view/v1/static/css/recharge.css">
	<link rel="stylesheet" type="text/css" href="/static/css/loading.css?v=1.5">
	<link rel="stylesheet" href="/app/express/view/v1/static/css/noticedetail.css?v=0.2">
</head>
<body style="background-color:#3bb4f2;">
	<!-- 金额为空 start -->
	<div class="am-modal am-modal-alert" tabindex="-1" id="my-alert-charge">
	  <div class="am-modal-dialog">
	    <div class="am-modal-bd">
	      请输入充值金额
	    </div>
	    <div class="am-modal-footer">
	      <span class="am-modal-btn">确定</span>
	    </div>
	  </div>
	</div>
	<!-- 金额为空 end -->
	<div class="charge-bar">
		<h3><?php echo(!empty($su['name']) ? $su['name'] : $su['account'] ) ?>的余额：<?php echo ( !empty($pt) ? sprintf('%.2f',($pt['cash_remain']/100)) : '' ) ?></h3>
		<div class="am-dropdown am-dropdown-up" id="charge-dropdown" data-am-dropdown>
		  <input type="number" placeholder="输入充值金额（单位：元）" id="charge-input" class="am-form-field am-radius am-dropdown-toggle" data-am-dropdown-toggle>
		  <ul class="am-dropdown-content">
		  	<li><a href="javascript:;" data-price="30">30 元</a></li>
		    <li><a href="javascript:;" data-price="50">50 元</a></li>
		    <li><a href="javascript:;" data-price="100">100 元</a></li>
		  </ul>
		</div>
		<button type="button" id="charge-btn" class="am-btn am-radius am-btn-warning">充值</button>
		<button type="button" onclick="window.location.href='?_easy=su.common.index.cash'" class="am-btn am-radius am-btn-primary">查看余额明细</button>
		<!--
		<button type="button" id="back-to-home-btn" class="am-btn am-radius am-btn-success">返回</button>
		-->
	</div>
	
	
<script type="text/javascript" src="/app/express/view/v1/static/js/jquery2.1.min.js"></script>
<script type="text/javascript" src="/app/express/view/v1/static/js/amazeui2.1.min.js"></script>
<script type="text/javascript" src="/static/js/loading.js?v=1.5"></script>
<script>
	$('.charge-bar li a').on('click',function(){
		var price = $(this).attr('data-price');
		$('#charge-input').val(price);
		$('#charge-dropdown').dropdown('close');
	});

	$('#charge-btn').on('click',function(){
		if($.trim($('#charge-input').val())){
			loading('即将跳转...','show','default');	//等待跳转提示
			var charge_price = ($('#charge-input').val())*100;
			$.post('?_a=su&_u=ajax.make_sucharge_order',{charge_price : charge_price},function(ret){
          		ret = $.parseJSON(ret);
          		console.log(ret);
          		if(ret.errno==0){
          			loading('','hide','default');
					window.localStorage.pay_return_url = window.location.href;
					window.localStorage.pay_return_home_url =  document.referrer || window.location.href;
          			window.location.href = '?_a=pay&oid=g'+ret.data;
          		}
          	});
		}
		else{
			$('#my-alert-charge').modal('open');
		}
	});

</script>
</body>
</html>
