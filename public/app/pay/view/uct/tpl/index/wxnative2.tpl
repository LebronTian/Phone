
<?php include $tpl_path.'/header.tpl'; ?>

<style>
    .info p{
        font-size: large;
    }
</style>
<link rel="stylesheet" href="/app/pay/view/uct/pay.css">
<div class="am-u-lg-8 am-u-md-12 am-u-sm-centered info">
    <div class="am-g">
        <div class="am-u-sm-4 left-box">
            <h2><?php echo isWeixinBrowser() ? '微信长按二维码支付' : '微信扫一扫支付'; ?>:</h2>
            <hr/>
            <img src="?_a=pay&_u=weixin.native2qrcode&oid=<?php echo $info['trade_no'];?>" style="width:300px;height:300px;" />
            <hr/>
            <?php
            //微信支付未回调, 或者支付过程取消了
            if(($info['pay_type'] == SpServiceMod::PAY_TYPE_WEIXINPAY) && !empty($info['pay_info']))
                echo '<a class="am-btn am-btn-lg am-btn-danger cls_weixin_pay_error"><span class="am-icon-warning"></span> 支付遇到问题</a>';
            ?>
            <a class="am-btn am-btn-lg am-btn-success" id="id_weixin_pay_over">支付完成请点我</a>
        </div>
        <div class="am-u-sm-8 right-box">
            <h2>订单信息</h2>
            <hr/>
            <p>订单名称: <a href="<?php echo $info['return_url'];?>"><strong class="am-text-success"><?php echo $info['title']; ?></strong></a></p>
            <p>订单金额: <strong class="am-text-warning">&yen;<?php echo $info['total_fee']/100; ?></strong></p>
            <p>下单时间: <strong><?php echo date('Y-m-d H:i:s', $info['create_time']); ?></strong></p>
            <p>订单详情: <?php echo $info['detail']; ?></p>
            <p>待收款方: <span class="am-text-primary"><?php echo $info['spname']; ?></span></p>
            <p>待付款方: <span class="am-text-primary"><?php echo $info['suname']; ?></span></p>
        </div>
    </div>
    <?php
    //var_export($info);
    ?>
</div>
<div class="am-cf"></div>


<script src="/static/js/jquery2.1.min.js"></script>
<script src="/static/js/amazeui2.1.min.js"></script>
<script src="/static/js/tip.js"></script>
<script>
    var g_uid = '<?php echo $info['trade_no'];?>';
    var g_return_url = '<?php echo $info['return_url'];?>';
    $('#id_weixin_pay_over').click(function(){
        //支付成功, 主动刷新一下订单状态
        var data = {oid: g_uid};
        $.post('?_a=pay&_u=weixin.update_order', data, function(ret){
			//交给前端处理
			var url = window.localStorage.pay_return_url;
			if(url) {
				g_return_url = url;
				window.localStorage.removeItem('pay_return_url');
			}
            window.location.replace(g_return_url)
        });
    });
    $('.cls_weixin_pay_error').click(function(){
        var data = {oid: g_uid};
        $.post('?_a=pay&_u=weixin.update_order', data, function(ret){
            console.log(ret);
            ret = $.parseJSON(ret);
            if(ret.data) {
				//交给前端处理
				var url = window.localStorage.pay_return_url;
				if(url) {
					g_return_url = url;
					window.localStorage.removeItem('pay_return_url');
				}
                window.location.replace(g_return_url)
            }
            else {
                alert('微信订单查询失败! 请联系客服!');
            }
        });
    });

var g_int = 0;
function poll_check_paid(time) {
	time = time || 3000;
	if(g_int) return;
	g_int = setTimeout(function(){
        var data = {oid: g_uid};
		$.post('?_a=pay&_u=weixin.update_order', data, function(ret){
			console.log('check paid', ret);
			ret = $.parseJSON(ret);
			if(ret && ret.data) {
				//交给前端处理
				var url = window.localStorage.pay_return_url;
				if(url) {
					g_return_url = url;
					window.localStorage.removeItem('pay_return_url');
				}
       	     	window.location.replace(g_return_url);
			}
			else {
				g_int = 0;
				poll_check_paid(time);
			}
		});
	}, time);
}
poll_check_paid();

</script>
<?php include $tpl_path.'/footer.tpl'; ?>
