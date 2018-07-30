// page/class/pages/pointGood/pointGood.js
var app = getApp();

Page({
    data: {
        mainColor: app.globalData.main_color,
        showNoMore: false,
        page: 0,
        goodList: []
    },

    onLoad: function (options) {
        var that = this;
        this.setData({
            mainColor: app.globalData.main_color
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
        var page = that.data.page;

        that.getGoods(page);
    },

    getGoods: function(page, cb) {
        var that = this;

        // 获取拼团活动商品
        app.request({
            url: "_easy=qrposter.ajax.point_product_list",
            data: {
                page: page,
                limit: 10,
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

                    goodList.forEach(function(ele) {
                        if (ele.main_img && !ele.main_img.startsWith("http")) ele.main_img = app.globalData.prefix_url + ele.main_img;
                    });

                    var originList = page == 0 ? [] : that.data.goodList;
                    var list = originList.concat(goodList);

                    that.setData({
                        goodList: list,
                        page: page
                    });
                }
            }
        });
    },

    onReachBottom: function () {
        var page = this.data.page + 1;
        this.setData({
            page: page
        });
        this.getGoods(page);
    },

    onShow: function () {
    
    },

    onPullDownRefresh: function () {
    
    },

    onShareAppMessage: function () {
    
    }
})