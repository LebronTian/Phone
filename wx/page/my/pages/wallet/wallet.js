var app = getApp();

Page({
    data: {
        mainColor: app.globalData.main_color,
        navTitles: [
            {
                title: "积分明细",
                url: "../pointDetail/pointDetail?from=point"
            },
            {
                title: "账户余额明细",
                url: "../pointDetail/pointDetail?from=cash"
            },
            {
                title: "银行卡管理",
                url: "../myInfo/myInfo"
            },
        ]
    },

    onLoad: function (options) {
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });

        var that = this;
        this.setData({
            mainColor: app.globalData.main_color
        });

        // 获取用户的积分
        app.request({
            url: "_a=su&_u=ajax.point",
            success: function(ret) {
                console.log("point ret >>>>>", ret);
                var pointRemain = ret.data.point_remain;
                var cashRemain = ret.data.cash_remain/100;
                
                that.setData({
                    showPoint: pointRemain,
                    showCash: cashRemain
                });
            }
        });
    },

    onShow: function () {
    
    },

    onPullDownRefresh: function () {
    
    },

    onReachBottom: function () {
    
    },

    /**
     * 用户点击右上角分享
     */
    onShareAppMessage: function () {
    
    }
})
