var app = getApp();
var util = require('../../../../utils/util.js');

Page({
    data: {
    
    },

    onLoad: function (options) {
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
        var orderId = options.orderId;
        this.getOrderInfo(orderId);
    },

    onShow: function () {
    
    },

    getOrderInfo: function(id, cb) {
        var that = this;

        app.request({
            url: "_a=shop&_u=ajax.order",
            data: {
                uid: id
            },
            success: function(ret) {
                console.log("order >>>>", ret);
                if (typeof cb == 'function') {
                    cb(ret);
                } else {
                    var order = ret.data;
                    order.status = that.convertStatus(order.status);

                    var company = order.delivery_info['快递公司'],
                        num = order.delivery_info['快递单号'];
                    that.getDeliveryInfo(company, num);

                    that.setData({
                        order: order
                    });
                }
                
            }
        });
    },

    convertStatus: function(status) {
        var numToWord = {
            "1" : "待付款", "2" : "待发货", "3" : "待收货",
            "4" : "已收货", "5" : "已评价", "6" : "协商完成",
            "8" : "协商中(退货，换货)", "9" : "店家已取消", "10" : "已取消",
            "11" : "等待卖家确认"
        }
        return numToWord[status];
    },

    // 订单追踪
    getDeliveryInfo: function(company, num, cb) {
        var that = this;
        app.request({
            url: '_a=shop&_u=ajax.get_kuaidi_msg',
            data: {
                kuaidi: company,
                cno: num
            },
            success: (ret) => {
                if (typeof cb == 'function') {
                    cb(ret);
                } else {
                    console.log("delivery_info >>>>>>", ret);
                    if (ret.data && ret.data.track_data && ret.data.track_data.data) {
                        var delivertArr = ret.data.track_data.data.reverse();
                        that.setData({
                            delivertArr: delivertArr
                        });
                    }
                }
            }
        });
    },

    onPullDownRefresh: function () {
    
    },

    onShareAppMessage: function () {
    
    }
})