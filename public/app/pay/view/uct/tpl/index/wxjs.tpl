
<?php include $tpl_path.'/header.tpl'; ?>

<style>
    .info p{
        font-weight: 400;
        font-size: 1.5em;
    }
</style>
<link rel="stylesheet" href="/app/pay/view/uct/pay.css">
<?php
if(!isWeixinBrowser()) {
    echo '
<a href="javascript:;" class="am-text-warning" style="text-align:center; border: 1px solid #f37b1d; margin-top: -1.6rem;
	display:block;">
	<span class="am-icon-warning"></span>
	微信h5支付只能在微信客户端中使用!
</a>';
}
?>

<div class="am-u-sm-12 am-u-sm-centered info wxjs-box">
    <h2>订单信息</h2>
    <hr/>
    <p>订单名称: <a href="<?php echo $info['return_url'];?>"><strong class="am-text-success"><?php echo $info['title']; ?></strong></a></p>
    <p>订单金额: <strong class="am-text-warning">&yen;<?php echo $info['total_fee']/100; ?></strong></p>
    <p>下单时间: <strong><?php echo date('Y-m-d H:i:s', $info['create_time']); ?></strong></p>
<!--    <p>订单详情: <?php echo $info['detail']; ?></p>   -->
    <p>待收款方: <span class="am-text-primary"><?php echo $info['spname']; ?></span></p>
    <p>待付款方: <span class="am-text-primary"><?php echo $info['suname']; ?></span></p>
    <hr/>
    <a class="am-btn am-btn-lg am-btn-success cpaytype" id="id_weixin_pay"><span class="am-icon-weixin"></span> 立即支付</a>
    <?php
    //微信支付未回调, 或者支付过程取消了
    if(($info['pay_type'] == SpServiceMod::PAY_TYPE_WEIXINPAY) && !empty($info['pay_info']))
        echo '<a class="am-btn am-btn-lg am-btn-danger cls_weixin_pay_error cpaytype"><span class="am-icon-warning"></span> 支付遇到问题</a>';
    ?>
</div>
<?php
//var_export($info);
?>
<div class="am-cf"></div>


<script src="/static/js/jquery2.1.min.js"></script>
<script src="/static/js/amazeui2.1.min.js"></script>
<script src="/static/js/tip.js"></script>
<script>
    var g_uid = '<?php echo $info['trade_no'];?>';
    var g_return_url = '<?php echo $info['return_url'];?>';

    //调用微信JS api 支付
    function jsApiCall()
    {
        WeixinJSBridge.invoke(
            'getBrandWCPayRequest',
            <?php echo $jsApiParameters; ?>,
            function(res){
                if(res.err_msg == "get_brand_wcpay_request:ok" ) {
                    //支付成功, 主动刷新一下订单状态
                    var data = {oid: g_uid};
                    $.post('?_a=pay&_u=weixin.update_order', data, function(ret){
                        onok();
                    });
                    return;
                }
                WeixinJSBridge.log(res.err_msg);
                alert(res.err_code+res.err_desc+res.err_msg);
            }
        );
    }
    function callpay()
    {
        if (typeof WeixinJSBridge == "undefined"){
            if( document.addEventListener ){
                document.addEventListener('WeixinJSBridgeReady', jsApiCall, false);
            }else if (document.attachEvent){
                document.attachEvent('WeixinJSBridgeReady', jsApiCall);
                document.attachEvent('onWeixinJSBridgeReady', jsApiCall);
            }
        }else{
            jsApiCall();
        }
    }

    $('#id_weixin_pay').click(function(){
        callpay();
    });

    /*
     支付完成
     */
    function onok() {
		//交给前端处理
		var url = window.localStorage.pay_return_url;
		if(url) {
			g_return_url = url;
			window.localStorage.removeItem('pay_return_url');
		}
        window.location.replace(g_return_url)
    }

    $('.cls_weixin_pay_error').click(function(){
        var data = {oid: g_uid};
        $.post('?_a=pay&_u=weixin.update_order', data, function(ret){
            console.log(ret);
            ret = $.parseJSON(ret);
            if(ret.data) {
                onok();
            }
            else {
                alert('微信订单查询失败! 请联系客服!');
            }
        });
    });

	if($('.cpaytype').length == 1) { 
		$('.cpaytype').click();
	}

</script>
<?php include $tpl_path.'/footer.tpl'; ?>
