var app = getApp();
var util = require('../../../../utils/util.js');

Page({
    data: {
        goodList: []    
    },

    onLoad: function (options) {
        var that = this;
        that.getBargainList(0);
        this.setData({
            mainColor: app.globalData.main_color
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
    },

    onShow: function () {
    
    },

    onPullDownRefresh: function () {
    
    },

    onReachBottom: function () {
        var page = this.data.page + 1;
        this.getBargainList(page);
    },

    onShareAppMessage: function () {
    
    },

    // 获取砍价商品列表
    getBargainList: function(page, cb) {
        var that = this;
        app.request({
            url: "_a=bargain&_u=ajax.get_bargains",
            data: {
                page: page,
                limit: 10
            },
            success: (ret) => {
                if (typeof cb == "function") {
                    cb(ret);
                } else {
                    console.log("getBargainList >>>>>", ret);
                    var goodList = ret.data.list,
                        now = new Date(),
                        now = parseInt(now.getTime() / 1000);

                    goodList.forEach(function(ele) {
                        if (!ele.product_info.img.startsWith("http")) ele.product_info.img = app.globalData.prefix_url + ele.product_info.img;
                        ele.price = parseFloat(ele.lowest_price/100).toFixed(2);
                        ele.ori_price = parseFloat(ele.ori_price/100).toFixed(2);

                        var remainTime = ele.rule.end_time - now;
                        ele.leftTime = remainTime;
                        ele.remainTime = util.formatRemainTime(remainTime);
                    });

                    var originList = page == 0 ? [] : that.data.goodList;
                    var list = originList.concat(goodList);
                    that.freshTime(list);

                    that.setData({
                        goodList: list,
                        page: page
                    });
                }
            }
        });
    },

    // 刷新时间
    freshTime: function(goodList) {
        var that = this;
        var sh = setInterval(function() {
            goodList.forEach(function(ele) {
                ele.leftTime--;
                if (ele.leftTime < 0) {
                    ele.status = 1;
                } else {
                    ele.remainTime = util.formatRemainTime(ele.leftTime);
                }
            });

            that.setData({
                goodList: goodList
            });
        }, 1000);
    },
})