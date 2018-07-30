var app = getApp();
var util = require('../../../../utils/util.js');
var sliderWidth = 96;

Page({

    data: {
        bargainList: [],
        overdueList: [],

        tabs: ["进行中的砍价", "已过期的砍价"],
        activeIndex: 0
    },

    onLoad: function (options) {
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
        var that = this,
            id = app.globalData.su_uid;

        this.setData({
            mainColor: app.globalData.main_color
        });

        this.getMyBargainList(id, 0);

        wx.getSystemInfo({
            success: function(res) {
                that.setData({
                    sliderLeft: (res.windowWidth / that.data.tabs.length - sliderWidth) / 2,
                    sliderOffset: res.windowWidth / that.data.tabs.length * that.data.activeIndex
                });
            }
        });
    },

    onShow: function () {
    
    },

    getMyBargainList: function(userId, status) {
        var that = this;

        app.request({
            url: "_a=bargain&_u=ajax.get_user_bargains",
            data: {
                limit: -1,
                status: status,
                su_uid: userId
            },
            success: (ret)=>{
                console.log("get my bargain >>>>>", ret);
                var bargainList = ret.data.list,
                    now = new Date(),
                    now = parseInt(now.getTime() / 1000);

                bargainList.forEach(function(ele) {
                    var img = ele.bargain.product_info.img;
                    ele.bargain.product_info.img = img.startsWith("http") ? img : (app.globalData.prefix_url + img);

                    ele.price = parseFloat(ele.bargain.lowest_price/100).toFixed(2);
                    ele.ori_price = parseFloat(ele.bargain.ori_price/100).toFixed(2);

                    var remainTime = ele.bargain.rule.end_time - now;
                    ele.leftTime = remainTime;
                    ele.remainTime = util.formatRemainTime(remainTime);
                });

                that.setData({
                    list: bargainList
                });

                if (status == 0) {
                    that.freshTime(bargainList);
                    that.setData({
                        bargainList: bargainList
                    });
                } else {
                    that.setData({
                        overdueList: bargainList
                    });
                }
            }
        });
    },

    // 刷新时间
    freshTime: function(bargainList) {
        var that = this;
        var sh = setInterval(function() {
            bargainList.forEach(function(ele) {
                ele.leftTime--;
                if (ele.leftTime < 0) {
                    ele.status = 1;
                } else {
                    ele.remainTime = util.formatRemainTime(ele.leftTime);
                }
            });

            that.setData({
                bargainList: bargainList,
            });

            if (that.data.activeIndex == 0) {
                that.setData({
                    list: bargainList
                });
            }
        }, 1000);
    },


    tabClick: function(e) {
        var id = e.currentTarget.dataset.id,
            bargainList = this.data.bargainList,
            overdueList = this.data.overdueList,
            userId = app.globalData.su_uid;

        if (id == 0) {
            if (bargainList.length > 0) {
                this.setData({
                    list: bargainList
                });
            } else {
                this.getMyBargainList(userId, id);
            }
        } else {
            if (overdueList.length > 0) {
                this.setData({
                    list: overdueList
                });
            } else {
                this.getMyBargainList(userId, id);
            }
        }

        this.setData({
            activeIndex: id,
            sliderOffset: e.currentTarget.offsetLeft,
        });
    },

    onPullDownRefresh: function () {
    
    },

    onReachBottom: function () {
    
    },

    onShareAppMessage: function () {
    
    }
})