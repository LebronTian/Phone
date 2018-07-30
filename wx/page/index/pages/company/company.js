// page/index/pages/company/company.js
var app = getApp();

Page({
    on_call: function(e) {
              wx.makePhoneCall({
                  phoneNumber: '15820425082'
              });
    },

    on_call2: function(e) {
              wx.makePhoneCall({
                  phoneNumber: '13423951166'
              });
    },

    /**
     * 页面的初始数据
     */
    data: {
        tapNum: 0
    },

    /**
     * 生命周期函数--监听页面加载
     */
    onLoad: function (options) {
      wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
    },

    onShow: function () {
    
    },

    // 打开调试
    enableDebug: function() {
        var tapNum = this.data.tapNum + 1;
        console.log("tapNum >>>", tapNum);
        if (tapNum >= 5) {
            this.setData({
                tapNum: 0
            });
            // 打开调试
            wx.setEnableDebug({
                enableDebug: true
            })
        } else {
            this.setData({
                tapNum: tapNum
            });
        }
    },

    onPullDownRefresh: function () {
    
    },

    onShareAppMessage: function () {
    
    }
})
