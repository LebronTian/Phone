var app = getApp();
var util = require('../../../../utils/util.js')

Page({

    // 页面的初始数据    
    data: {
        mainColor: app.globalData.main_color,
        
        couponList: []
    },

    /**
    * 生命周期函数--监听页面加载
    */
    onShow: function () {
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
        var that = this;
        this.setData({
            mainColor: app.globalData.main_color
        });
        // 获取优惠券列表
        app.request({
            url: "_a=shop&_u=ajax.get_coupon",
            success: function(ret) {
                console.log("coupon list >>>>", ret);
                var couponList = ret.data.list;

                couponList.forEach(function(ele) {
                    // ele.image = app.globalData.prefix_url + ele.info.img;

                    var img = ele.info.img;
                    ele.image = img.startsWith("http") ? img : (app.globalData.prefix_url + img);
                        

                    if (ele.expire_time == 0) {
                        ele.endTime = "永久有效";
                    } else {
                        var endTime = util.formatTime(ele.expire_time);
                        ele.endTime = endTime[0] + "." + endTime[1] + "." + endTime[2] + " " + endTime[3];
                    }

                    ele.price = parseFloat(ele.info.rule.discount / 100);
                });

                that.setData({
                    couponList: couponList
                });

                wx.stopPullDownRefresh()
            }
        });

    },

    /**
    * 页面相关事件处理函数--监听用户下拉动作
    */
    onPullDownRefresh: function () {
        this.onShow();
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