// page/cart/pages/applyDistribution/applyDistribution.js
var app = getApp();
var WxParse = require('../../../common/wxParse/wxParse.js');


Page({

    data: {
        isAgree: true,
	    mainColor: app.globalData.main_color
    },

    onLoad: function (options) {
    	this.getDistributionRule();
    	this.setData({
            mainColor: app.globalData.main_color
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: this.data.mainColor,
        });
    },

    onShow: function () {
    
    },

    getDistributionRule: function() {
    	let that = this;

    	app.request({
    		url: "_a=shop&_u=ajax.get_user_agreement",
    		success: (ret)=>{
    			console.log("getDistributionRule ret >>>>>", ret);
                if (!ret.data || !ret.data.content) return;
    			let content = ret.data.content;
		        WxParse.wxParse('content', 'html', content, that, 5);
                that.setData({
                    title: ret.data.title
                });
    		}
    	})
    },

    // 同意协议
    bindAgreeChange: function (e) {
        this.setData({
            isAgree: !!e.detail.value.length
        });
    },

    applyTap: function() {
        let that = this;

        app.request({
            url: "_a=shop&_u=ajax.distribution_apply",
            success: (ret)=>{
                console.log("apply ret >>>>>", ret);
                if (ret.errno == 0) {
                    wx.showToast({
                        title: "申请成功",
                        success: (res)=>{
                            wx.navigateBack()
                        }
                    });
                } else {
                    wx.showModal({
                        title: "申请失败",
                        content: "请检查您的网络是否连接正常，再重试",
                        showCancel: false
                    });
                }
            }
        });
    },

    onShareAppMessage: function () {
    
    }
})