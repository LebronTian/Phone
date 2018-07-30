/*
	微信小程序支付 

	@param oid 订单编号 需要带前缀
	@param that page对象，会用到 page.data.paying
	@param on_success 支付成功回调 
			默认刷新页面 that.onLoad()
			注意是没有带option参数的 
*/
function do_pay(oid, that, on_success) {
	var app = getApp();

	if(!oid || that.data.paying) return;
	that.setData({paying: true});
	var data = {oid: oid, openid: app.globalData.openid};    
		app.request({
            url:'_a=pay&_u=index.wxxiaochengxu',
            data: data, 
			'success': function(ret){
			    console.log("pay ret >>>>>",ret);
			    that.setData({ paying:false });
			    if(!ret.data || !ret.data.xiaochengxuParameters) {
				    return app.alert('支付失败！'+ret.errno);
			    }
    			var obj = ret.data.xiaochengxuParameters;
    			obj['success'] = function() {
					//主动刷新一下
					app.request({url:'_a=pay&_u=index.wxxiaochengxu_update_order', data: data, success:function(){
    					app.alert('支付成功!');
    					on_success ? on_success() : that.onLoad({});
					}});
    			};  
       			obj['complete'] = function() {
    				that.setData({paying:false});
    			};  
    			wx.requestPayment(obj);
            }
        });
}

module.exports={
	do_pay:do_pay
}
