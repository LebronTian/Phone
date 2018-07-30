var app = getApp();
var sliderWidth = 96; // 需要设置slider的宽度，用于计算中间位置

Page({

    data: {
        cartImg: app.globalData.server_url + "_u=common.img&name=cart.png",
        favlist: [],
        bizList: [],

        tabs: ["收藏商品", "关注商铺"],
        activeIndex: 0,
        sliderOffset: 0,
        sliderLeft: 0
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

        wx.getSystemInfo({
            success: function(res) {
                that.setData({
                    sliderLeft: (res.windowWidth / that.data.tabs.length - sliderWidth) / 2,
                    sliderOffset: res.windowWidth / that.data.tabs.length * that.data.activeIndex
                });
            }
        });

        that.getFavoriteList(0);
        that.getFavBizList(0);
    },

    onShow: function () {

    },

    // 获取收藏的商店列表
    getFavBizList: function(page) {
        var that = this;

        app.request({
            url: "_a=shop&_u=biz.get_biz_fav",
            data: {
                page: page
            },
            success: (ret) =>{
                console.log("favorite business list ret >>>>", ret);
                var bizList = ret.data.list;
                bizList.forEach(function(ele) {
                    if (ele.biz) {
                        if (!ele.biz.main_img.startsWith("http")) ele.biz.main_img = app.globalData.prefix_url + ele.biz.main_img;
                    }
                });
                var list = that.data.bizList.concat(bizList);

                that.setData({
                    page1: page,
                    bizList: list
                })
            }
        });
    },

    // 获取收藏的商品列表
    getFavoriteList: function(page) {
        var that = this;

        // 获取用户收藏列表
        app.request({
            url: "_a=shop&_u=ajax.favlist",
            data: {
                page: page
            },
            success: function(ret) {
                console.log("favlist >>>>>>>", ret);
                var favlist = ret.data.list;

                favlist.forEach(function(ele) {
                    if (!ele.product.main_img.startsWith("http")) ele.product.main_img = app.globalData.prefix_url + ele.product.main_img;
                    ele.price = parseFloat(ele.product.price) / 100;
                });

                var list = that.data.favlist.concat(favlist);

                that.setData({
                    favlist: list,
                    page0: page
                });
            }
        });
    },

    tabClick: function (e) {
        this.setData({
            sliderOffset: e.currentTarget.offsetLeft,
            activeIndex: e.currentTarget.id
        });

    },

    onPullDownRefresh: function () {

    },

    // 页面上拉触底事件的处理函数
    onReachBottom: function () {
        if (this.data.activeIndex == 0) {
            var page = this.data.page0 + 1;
            this.getFavoriteList(page);
        } else if (this.data.activeIndex == 1) {
            var page = this.data.page1 + 1;
            this.getFavBizList(page);
        }
        
    },

    onShareAppMessage: function () {

    }
})