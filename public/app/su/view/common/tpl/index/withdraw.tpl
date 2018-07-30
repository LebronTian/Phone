<?php
	uct_use_app('su');
	$su_uid = SuMod::require_su_uid();
	$point = SuPointMod::get_user_points_by_su_uid($su_uid);
	?>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<title>提现</title>
	<link rel="stylesheet" type="text/css" href="/static/css/loading.css?v=1.5">
	<link rel="stylesheet" href="/app/express/view/v1/static/css/noticedetail.css?v=0.2">
	<link rel="stylesheet" type="text/css" href="/app/express/view/v1/static/css/mycount.css">
	<link rel="stylesheet" type="text/css" href="/app/express/view/v1/static/css/weui.min.css">
   <script src="/static/js/jquery1.7.min.js" type="text/javascript" charset="utf-8"></script>
</head>
<body>
<header class="color-main vertical-box">
    <span class="header-title">提现</span>
    <div class="header-left vertical-box">
        <img class="img-btn" src="static/images/back.png" onclick="history.back()">
    </div>
    <div class="header-right vertical-box">
        <!-- <img class="img-btn" src="/app/shop/view/maotai/static/images/home.png" onclick="window.location.href='/index'"> -->
         <!--<span class="withdrawRecord" onclick="window.location.href='/?_easy=shop.maotai.user.withdrawRecord'">提现记录</span>-->   
    </div>
</header>
<div class="weui_cells weui_cells_form">
	<div class="weui_cell">
	  <div class="weui_cell_bd">
	  	<label class="weui_label" style="width: 6em;">可提金额</label>
	  </div>
      <div class="weui_cell_bd weui_cell_primary">
		<span style="color:#fda93f; ">&yen; <?php echo !empty($point['cash_remain']) ? $point['cash_remain']/100 : 0; ?></span>
	  </div>
    </div>
	<div class="weui_cell">
	  <div class="weui_cell_bd">
	  	<label class="weui_label" style="width: 6em;">金额（元）</label>
	  </div>
      <div class="weui_cell_bd weui_cell_primary">
		<input id="id_cash" class="weui_input" type="number"placeholder="请输入提现金额"/>
	  </div>
    </div>
</div>
<div class="weui_cells_title">提现至您最近用于支付或充值的资金账户</div>
 <!--<a id="id_withdraw" href="javascript:;" class="weui_btn weui_btn_warn" onclick="window.location.href='/?_easy=shop.maotai.user.transtionDetail'" >确定提现</a>-->
  <a id="id_withdraw" href="javascript:;" class="weui_btn weui_btn_warn">确定提现</a>
<script>

$('#id_withdraw').click(function(){
	var cash = 100 * $('#id_cash').val();
	if(!cash) return alert('输入金额!');
	$.post('?_a=pay&_u=index.do_withdraw', {cash: cash}, function(ret){
		console.log(ret);
		ret = $.parseJSON(ret);
		if(ret && (ret.errno == 0 || ret.data)) {
			if(ret.errno == 303) {
				alert('申请成功！正在等待审核 ');
			}
			else {
				alert('成功提现！');
				location.reload();
			}
		}
		else {
			alert('提现接口错误');return
			alert('err', '错误！' + ret.errstr, 3000);
		}
	});
});

</script>
</body>
</html>