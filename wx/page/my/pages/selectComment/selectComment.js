var app = getApp();
var util = require('../../../../utils/util.js');

Page({

    /**
     * 页面的初始数据
     */
    data: {

    },

    /**
     * 生命周期函数--监听页面加载
     */
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
                    good.id = good.sku_uid.split(";")[0];
                    var img = good.main_img;
                    good.img = img.startsWith("http") ? img : (app.globalData.prefix_url + img);
                     
                    // good.img = app.globalData.prefix_url + good.main_img;
                    good.price = parseInt(good.paid_price) / 100;
                });

                that.setData({
                    order: order
                });
            }
        });
    },

    /**
     * 生命周期函数--监听页面初次渲染完成
     */
    onReady: function () {

    },

    /**
     * 生命周期函数--监听页面显示
     */
    onShow: function () {

    },

    /**
     * 生命周期函数--监听页面隐藏
     */
    onHide: function () {

    },

    /**
     * 生命周期函数--监听页面卸载
     */
    onUnload: function () {

    },

    /**
     * 页面相关事件处理函数--监听用户下拉动作
     */
    onPullDownRefresh: function () {

    },

    /**
     * 页面上拉触底事件的处理函数
     */
    onReachBottom: function () {

    },

    /**
     * 用户点击右上角分享
     */
    onShareAppMessage: function () {

    }
})