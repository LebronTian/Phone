<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
    <title>收银台</title>
    <link rel="stylesheet" href="/static/css/weui0.42.css" />
    <style type="text/css">
        .pay-btn{ display: block; width: 90%; margin: 0 auto;}
        .pay-price{ color:#FE6714; font-size:41px}
        .pay-title{ font-weight: bold; margin-right: 15px;}
        .pay-name{ color: #FE6714;}
        .is_pay-btn{ display: block; width: 30%; margin-top: 15px;font-size:10px;margin-right: 5%;}
    </style>
</head>
<body>
<div style="width:90%;margin:41px auto 20px;">
    <p>
        <span class="pay-title">支付金额：</span>
        <span class="pay-price">￥<?php printf('%.2f',$info["total_fee"]/100);?></span>
    </p>
</div>
<div>
    <a href="javascript:;" class="weui_btn weui_btn_primary pay-btn">立即支付</a>
</div>
<div>
<!--    <a href="javascript:;" class="weui_btn weui_btn_default is_pay-btn" type="button" data-id="--><?php //echo $order["uid"];?><!--">已支付点击这里</a>-->
</div>
<script src="/static/js/jquery2.1.min.js"></script>
<script src="/static/js/jquery.cookie.js"></script>
<script type="text/javascript">
    $(document).ready(function(){
        //fastclick消除延迟
        $('.pay-btn').on('click', function() {
        });
        callpay();


    });
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
                        var o = $.cookie('post_data');
                        if( o!=null)
                        {
                            $.cookie('post_data',null);
                            o = $.parseJSON(o);
                            $.post('?_a=qrposter&_u=ajax.make_point_order', o, function(ret){
                                console.log(ret);
                                ret = $.parseJSON(ret);
                                if(ret.errno==0 && ret.data) {
                                    alert('兑换成功！');
                                    window.location.href="?_a=qrposter&_u=index.point_orders";
                                    return;
                                }

                                if(ret.errstr == 'ERROR_OUT_OF_LIMIT') {
                                    alert('超出兑换数目限制!');
                                }
                                if(ret.errstr == 'ERROR_OUT_OF_QUANTITY_LIMIT') {
                                    alert('库存不足');
                                    return;
                                }
                                if(ret.errstr == 'ERROR_OUT_OF_POINT_LIMIT') {
                                    alert('积分不够!');
                                }
                                onok();
                                return;

                            });
                        }
                        else
                        {
                            onok();
                        }
                        return;
                    });
                }
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


</script>
</body>
</html>