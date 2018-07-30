var app = getApp();
var util = require('../../../../utils/util.js')

Page({

    data: {
        mainColor: app.globalData.main_color,
        page: 0,
        goodList: [],
        showNoMore: false,
    },

    onLoad: function (options) {
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
        // 获取秒杀活动商品
        this.getSeckillGoods(0);
        this.setData({
            mainColor: app.globalData.main_color
        });
    },

    onShow: function () {

    },

    // 获取秒杀活动商品函数
    getSeckillGoods(page, cb) {
        var that = this;

        app.request({
            url: "_a=shop&_u=ajax.products",
            data: {
                info: 32,
                limit: 10,
                page: page,
            },
            success: function(ret) {
                if (typeof(cb) === "function") {
                    cb(ret);
                } else {
                    console.log("page >>>", page);
                    console.log("good list ret >>>", ret);
                    var goodList = ret.data.list;
                    if (goodList.length < 10) {
                        that.setData({
                            showNoMore: true
                        });
                    }

                    var now = new Date();
                    now = parseInt(now.getTime() / 1000);

                    goodList.forEach(function(ele) {
                        if (ele.main_img && !ele.main_img.startsWith("http")) ele.main_img = app.globalData.prefix_url + ele.main_img;
                        ele.ori_price = parseFloat(ele.ori_price/100).toFixed(2);
                        ele.price = (parseFloat(ele.price)/100).toFixed(2);

                        // 处理秒杀时间
                        var startTime = parseInt(ele.kill_time.start_time);
                        var endTime = parseInt(ele.kill_time.end_time);
                        
                        if (now < startTime) {
                            ele.seckillStatus = 0;
                            var remainTime = startTime - now;
                            ele.startLeftTime = remainTime;
                            ele.startTime = util.formatRemainTime(remainTime);
                            ele.endLeftTime = endTime - startTime;
                        } else if (now < endTime) {
                            ele.seckillStatus = 1;
                            var remainTime = endTime - now;
                            ele.endLeftTime = remainTime;
                            ele.endTime = util.formatRemainTime(remainTime);
                        } else {
                            ele.seckillStatus = 2;
                        }
                    });

                    var list = that.data.goodList.concat(goodList);
                    that.freshTime(goodList);

                    that.setData({
                        goodList: list
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
                if (ele.seckillStatus == 0) {
                    ele.startLeftTime--;
                    if (ele.startLeftTime < 0) {
                        ele.seckillStatus = 1;
                    } else {
                        ele.startTime = util.formatRemainTime(ele.startLeftTime);
                    }
                } else if (ele.seckillStatus == 1) {
                    ele.endLeftTime--;
                    if (ele.endLeftTime < 0) {
                        ele.seckillStatus = 2;
                    } else {
                        ele.endTime = util.formatRemainTime(ele.endLeftTime);
                    }
                }
            });

            that.setData({
                goodList: goodList
            });
        }, 1000);
    },

    onPullDownRefresh: function () {

    },

    onReachBottom: function () {
        var page = this.data.page + 1;
        this.setData({
            page: page
        });
        this.getGoods(page);
    },

    onShareAppMessage: function () {

    }
})