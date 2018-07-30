var app = getApp();
var WxParse = require('../../../common/wxParse/wxParse.js');
var util = require('../../../../utils/util.js')

Page({
    data: {
        mainColor: app.globalData.main_color
    },

    onLoad: function (options) {
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
        var that = this,
            id = options.articleId;
        this.setData({
            mainColor: app.globalData.main_color
        });

        // 获取公告列表
        app.request({
            url: "_a=shop&_u=ajax.shop_radio",
            data: {
                uid: id
            },
            success: function(ret) {
                console.log("article ret >>>>", ret);
                var radioList = ret.data.list;
                var radio = ret.data;

                var time = util.formatTime(radio.create_time);
                radio.time = time[0] + "-" + time[1] + "-" + time[2];

                var article = radio.content;
                WxParse.wxParse('article', 'html', article, that, 5);

                that.setData({
                    radio: radio
                });
            }
        });
    },

    onShow: function () {

    },

    onPullDownRefresh: function () {

    },

    onShareAppMessage: function () {

    }
})