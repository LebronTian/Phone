// page/index/pages/login/login.js
var app = getApp();

Page({

    data: {
    
    },

    /**
     * 生命周期函数--监听页面加载
     */
    onLoad: function (options) {
        let that = this;

        this.setData({
            mainColor: app.globalData.main_color,
        });

        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: that.data.mainColor,
        });
    },

    onShow: function () {
    
    },

    onGotUserInfo: function(ret) {
        console.log("get userInfo OK ret >>>", ret);

        let pages = getCurrentPages();
        console.log("get pages >>>", pages);

        let prePage = pages[pages.length - 2];

        prePage.onLoad(prePage.options);
        wx.navigateBack();
    },

    onShareAppMessage: function () {
    
    }
})