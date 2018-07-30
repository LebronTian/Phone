<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<title>充值</title>
	<link rel="stylesheet" type="text/css" href="/static/css/loading.css?v=1.5">
	<link rel="stylesheet" href="/app/express/view/v1/static/css/noticedetail.css?v=0.2">
	<link rel="stylesheet" type="text/css" href="/app/express/view/v1/static/css/mycount.css">
	<link rel="stylesheet" type="text/css" href="/app/express/view/v1/static/css/weui.min.css">
   <script src="/static/js/jquery1.7.min.js" type="text/javascript" charset="utf-8"></script>
</head>
 <body>
	<header class="color-main vertical-box">
	    <span class="header-title">充值</span>
	    <div class="header-left vertical-box">
	        <img class="img-btn" src="static/images/back.png" onclick="window.location.href='?_a=shop&_u=user.index'">
	    </div>
	    <!-- <div class="header-right vertical-box">
	        <img class="img-btn" src="/app/shop/view/maotai/static/images/home.png" onclick="window.location.href='/index'">
	         <span class="balance" onclick="window.location.href='/index.tpl'">余额明细</span>   
	    </div> -->
	</header>
	<article>
	    <div class="weui_cells weui_cells_form">
			<div class="weui_cell">
		       <div class="weui_cell_bd"><label class="weui_label" style="width: 6em;">金额（元）</label></div>
		       <div class="weui_cell_bd weui_cell_primary">
		       		<input id="recharge-input" class="weui_input" type="number" placeholder="请输入充值金额"/>
		       </div>
		    </div>
		</div>
		<section>

			<div class="weui_cells weui_cells_checkbox">
				<div class="weui_cells_title">请选择支付方式</div>
	            <label class="weui_cell weui_check_label" for="x11"  data-payment='11'>
	                <div class="weui_cell_bd weui_cell_primary">	
	                    <p>微信支付</p>
	                </div>

	                <div class="weui_cell_ft">
	                    <input type="radio" class="weui_check" name="radio1" id="x11" checked="checked">
	                    <span class="weui_icon_checked"></span>
	                </div>
	            </label>
	            <!--<label class="weui_cell weui_check_label" for="x12">
	                <div class="weui_cell_bd weui_cell_primary">
	                    <p>支付宝支付</p>
	                </div>
	                <div class="weui_cell_ft">
	                    <input type="radio" name="radio1" class="weui_check" id="x12" >
	                    <span class="weui_icon_checked"></span>
	                </div>
	            </label>
	             <label class="weui_cell weui_check_label" for="x13">

	                <div class="weui_cell_bd weui_cell_primary">
	                    <p>银行卡支付</p>
	                </div>
	                <div class="weui_cell_ft">
	                    <input type="radio" name="radio1" class="weui_check" id="x13" >
	                    <span class="weui_icon_checked"></span>
	                </div>
	            </label>-->
    		</div>
		</section>
		 <a href="javascript:;" id="recharge_submit" class="weui_btn weui_btn_warn">确认</a>

	</article>
	
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<link rel="stylesheet" href="/static/css/loading.css">
<script type="text/javascript" src="/static/js/loading.js"></script>
</body>
<script>
	$('#recharge_submit').on('click',function(){
		var payment = $('.weui_check_label').find('[checked]').parent().parent().data('payment');
		if($.trim($('#recharge-input').val())){
			loading('即将跳转...','show','default');	//等待跳转提示
			var charge_price = ($('#recharge-input').val())*100;
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
			alert('请输入充值金额')
		}
	});
</script>
</html>