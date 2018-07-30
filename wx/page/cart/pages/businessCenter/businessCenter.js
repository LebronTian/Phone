var app = getApp();

Page({

    data: {
        mainColor: app.globalData.main_color
    },

    onLoad: function (options) {
        this.setData({
            mainColor: app.globalData.main_color
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: this.data.mainColor,
        });
        this.getBizData();
    },

    onShow: function () {
        this.getBusiness();
    },

    // 获取商家信息
    getBusiness: function(cb) {
        var that = this;
        app.request({
            url: "_a=shop&_u=biz.ajax_biz",
            success: function(ret) {
                if (typeof(cb) === "function") {
                    cb(ret);
                } else {
                    that.getBusinessCb(ret);
                }
            }
        });
    },

    getBusinessCb: function(ret) {
        var that = this;
        console.log("get business ret >>>>", ret);
        if (ret.data) {
            wx.setNavigationBarTitle({
                title: ret.data.title
            });
            var status = ret.data.status;
            if (status == 0) {
                wx.showModal({
                    title: "您的信息正在审核中，请耐心等待",
                    showCancel: false,
                    success: function(res) {
                        if (res.confirm) {
                            wx.navigateBack();
                        }
                    }
                });
            } else if (status == 2) {
                wx.showModal({
                    title: "您的信息审核未通过，是否重新申请？",
                    confirmText: "重新申请",
                    success: function(res) {
                        if (res.confirm) {
                            wx.navigateTo({
                                url: "../apply/apply"
                            });
                        } else {
                            wx.navigateBack();
                        }
                    }
                });
            }
        } else {
            wx.showModal({
                title: "您还不是商家",
                content: "是否申请成为商家？",
                confirmText: "去申请",
                success: function(res) {
                    if (res.confirm) {
                        wx.navigateTo({
                            url: "../apply/apply"
                        });
                    } else {
                        wx.navigateBack();
                    }
                }
            })
        }
    },

    // 获取商家营业数据
    getBizData: function(cb) {
        var that = this;
        app.request({
            url: "_a=shop&_u=ajax.get_biz_cnt",
            success: function(ret) {
                if (typeof(cb) === "function") {
                    cb(ret);
                } else {
                    that.initBizData(ret)
                }
            }
        })
    },

    // 初始化商家营业数据
    initBizData: function(ret) {
        console.log("data return >>>", ret);
        if (ret.errno) return;

        var bizData = ret.data;
        bizData.total_orders_paid = handlePrice(bizData.total_orders_paid);
        bizData.today_orders_paid = handlePrice(bizData.today_orders_paid);
        bizData.weekd_orders_create_paid = handlePrice(bizData.weekd_orders_create_paid);
        bizData.yesterday_orders_create_paid = handlePrice(bizData.yesterday_orders_create_paid);
        
        this.setData({
            bizData: ret.data
        });
    },


    onPullDownRefresh: function () {

    },

    onReachBottom: function () {

    },

    onShareAppMessage: function () {

    }
});

// 处理价格函数
var  handlePrice = function(price) {
    return parseFloat(price / 100).toFixed(2);
}