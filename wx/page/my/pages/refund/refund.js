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
        
        var that = this;
        var id = options.uid;
        this.setData({
            mainColor: app.globalData.main_color
        });

        app.request({
            url: "_a=shop&_u=ajax.order",
            data: {
                uid: id
            },
            success: function(ret) {
                console.log("order >>>>", ret);
                var order = ret.data;

                var time = util.formatTime(order.create_time);
                order.time = time[0] + "-" + time[1] + "-" + time[2] + " " + time[3];

                order.products.forEach(function(good) {
                    var img = good.main_img;
                    good.img = img.startsWith("http") ? img : (app.globalData.prefix_url + img);
                        
                    good.price = parseInt(good.paid_price) / 100;

                });

                that.setData({
                    order: order,
                    id: id
                });
            }
        });        
    },

    bindFormSubmit: function(e) {
        var refundInfo = e.detail.value.textarea;
        var that = this;
        var id = that.data.id;

        app.request({
            url: "_a=shop&_u=ajax.add_refund",
            data: {
                uid: id,
                refund_info: {
                    refund_info: refundInfo
                }
            },
            success: function(ret) {
                console.log("delete order >>>>", ret);
                if (ret.data) {
                    wx.showToast({
                        title: "申请成功"
                    });
                    wx.navigateBack();
                } else {
                    wx.showModal({
                        title: "申请失败",
                        content: "请检查您的订单是否符合退款条件",
                        showCancel: false
                    });
                }
            }
        });
    },

    onShow: function () {

    },

    onPullDownRefresh: function () {

    },
})