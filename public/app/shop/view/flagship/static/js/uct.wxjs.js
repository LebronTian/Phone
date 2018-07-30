/*
	注册点击按钮，弹出微信支付功能
	
	1. 需要引入jquery 与 微信js文件
	<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
		

	2. 由于第一次创建支付参数比较慢，加了一个loading动画
	使用了通用loading函数，如果需要可以 引入了这2个文件
	<link rel="stylesheet" href="/static/css/loading.css">
	<script type="text/javascript" src="/static/js/loading.js"></script>


	3. 参数说明
	option = {
		'ele' : '#id_pay_btn', //按钮，必填
		'oid' : 'g1', //支付订单号，必填
		'openid' : 'aaa-bbb' //用户openid，必填,可用php代码 WxPayMod::require_order_wxjs_open_id() 获取

		'onok': function(){alert('pay succeed!')}, //支付成功回调，选填
		//'run' : true  //立即执行支付动作, 选填
	}
*/

	option = {
		'ele' : '#recharge_btn', //按钮，必填
		'oid' : '0', //支付订单号，必填
		'openid' : 'aaa-bbb' //用户openid，必填,可用php代码 WxPayMod::require_order_wxjs_open_id() 获取

		'onok': function(){alert('pay succeed!')}, //支付成功回调，选填
		//'run' : true  //立即执行支付动作, 选填
	}
function uct_wxjs_pay(option) {
	//if(option.oid == 'd400') alert(option);
	//支付参数
	var obj = null;
	//支付失败重试3次
	var retry = 3;

    /*
     支付成功
     */
    function onok() {
		if(option.onok) {
			option.onok();
		}
		else {
			//交给前端处理
			var url = window.localStorage.pay_return_url || obj.return_url;
			window.localStorage.removeItem('pay_return_url');
			window.location.replace(url);
		}
    }

    //调用微信JS api 支付
    function jsApiCall() {
		//alert(obj.jsApiParameters);
		if(option._d) { 
			alert(JSON.stringify(obj));
			/*
			obj.jsApiParameters['timestamp'] = obj.jsApiParameters['timeStamp'];
			delete obj.jsApiParameters['timeStamp'];
			alert('after hack->' + JSON.stringify(obj));
			*/
		}
        WeixinJSBridge.invoke(
            'getBrandWCPayRequest',
            obj.jsApiParameters,
            function(res){
                if(res.err_msg == "get_brand_wcpay_request:ok" ) {
                    //支付成功, 主动刷新一下订单状态
                    var data = {oid: obj.oid};
                    $.post('?_a=pay&_u=weixin.update_order', data, function(ret){
                        onok();
                    });
                    return;
                }
                WeixinJSBridge.log(res.err_msg);

				//出现错误，如商户签名错误，重试
                if(res.err_msg == "get_brand_wcpay_request:fail" ) {
					if(retry --> 0) {
						$(option['ele']).click();	
					}
					else {
						retry = 3;
   	             	alert(res.err_code+res.err_desc+res.err_msg);
					}
					return;
				}
				
				//可能是用户取消
               	alert(res.err_code+res.err_desc+res.err_msg);
            }
        );
    }

	function callpay_jssdk() {
		//alert('callpay jssdk!!1');
		var cfg = obj.jsApiParameters;
		if(cfg['timeStamp']) {
		cfg['timestamp'] = cfg['timeStamp'];
		delete cfg['timeStamp'];
		}
		
		cfg.success = function(res) {
			if(option._d) alert(JSON.stringify(res));
			onok();
		}

		wx.chooseWXPay(cfg);
	}
	
    function callpay() {
		if(0 || option._d) {
			return callpay_jssdk();
		}
	
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



	var do_pay = function() {
		if(!obj) {
			if(typeof loading == 'function') {
				loading('...', 'show', 'default');
			}
			$.post('?_a=pay&_u=index.wxjs', {oid: option['oid'], openid: option['openid']}, function(ret){
				if(typeof loading == 'function') {
					loading('...', 'hide', 'default');
				}
				try{
					obj = $.parseJSON(ret).data;
				} catch(e) {
					console.log(e);
				}
				if(!obj) {
					return alert(ret);
				}
            	callpay();
			});
		}
		else {
        	callpay();
		}
	}

	/*
	$(option['ele']).off('click').on('click', function() {
		do_pay();
	});		

	if(option.run)  $(option['ele']).click();
	*/
	do_pay();
}


