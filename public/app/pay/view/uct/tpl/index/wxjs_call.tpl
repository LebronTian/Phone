<?php header('Content-Type:application/javascript');?>
var __wxjs_call_<?php echo $info['trade_no'];?>= {
jsApiCall:function () {
    WeixinJSBridge.invoke(
    'getBrandWCPayRequest',
<?php echo $jsApiParameters; ?>,
    function(res){
    if(res.err_msg == "get_brand_wcpay_request:ok" ) {
        var data = {oid: '<?php echo $info['trade_no'];?>'};
        $.post('?_a=pay&_u=weixin.update_order', data, function(ret){
            window.location.replace('<?php echo $info['return_url'];?>');
        });
            return;
        }
    });
},
callpay:function()
{
    if (typeof WeixinJSBridge == "undefined"){
        if( document.addEventListener ){
            document.addEventListener('WeixinJSBridgeReady', this.jsApiCall, false);
        }else if (document.attachEvent){
            document.attachEvent('WeixinJSBridgeReady', this.jsApiCall);
            document.attachEvent('onWeixinJSBridgeReady', this.jsApiCall);
        }
        }else{
             this.jsApiCall();
        }
    }
};
__wxjs_call_<?php echo $info['trade_no'];?>.callpay();