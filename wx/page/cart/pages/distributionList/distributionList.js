// page/cart/pages/distributionList/distributionList.js
var app = getApp();
var util = require("../../../../utils/util.js");

Page({

    data: {
        orderList: [],
        noMore: true,
        page: 0
    },

    onLoad: function (options) {
        this.getList(0);
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
    },

    onShow: function () {
    
    },

    getList: function(page, cb) {
        var that = this;

        app.request({
            url: "_a=shop&_u=ajax.distributionlist",
            data: {
                page: page
            },
            success: (ret)=>{
                console.log("list ret >>>>>>>",ret);
                var list = ret.data.dtblist.list,
                    orderList = that.data.orderList;

                list.forEach(function(ele) {
                    ele.price = parseFloat(ele.cash/100).toFixed(2);
                    
                    let date = util.formatTime(ele.create_time);
                        ele.date = date.join("-");

                    let img = ele.order.products[0].main_img;
                    ele.img = img.startsWith("http") ? img : (app.globalData.prefix_url + img);
                });

                orderList = orderList.concat(list);

                that.setData({
                    orderList: orderList,
                    noMore: list.length < 10,
                    page: page
                });
            }
        });
    },

    onPullDownRefresh: function () {
    
    },

    /**
     * 页面上拉触底事件的处理函数
     */
    onReachBottom: function () {
        var page = this.data.page + 1;
        this.getList(page);
    },

    /**
     * 用户点击右上角分享
     */
    onShareAppMessage: function () {
    
    }
})