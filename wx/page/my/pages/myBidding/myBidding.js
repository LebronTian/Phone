// page/my/pages/myBidding/myBidding.js
var app = getApp();
var util = require('../../../../utils/util.js')
var sliderWidth = 96;

var formatPrice = function(num) {
    var num = (num || 0).toString(), result = '';
    while (num.length > 3) {
        result = ',' + num.slice(-3) + result;
        num = num.slice(0, num.length - 3);
    }
    if (num) { result = num + result; }
    return result;
}

Page({
    /**
     * 页面的初始数据
     */
    data: {
        // 导航栏数据
        tabs: ["竞拍中", '我拍到的', "未拍到的"],
        activeIndex: 0,
        sliderOffset: 0,
        sliderLeft: 0,

        showEmpty: false
    },

    onLoad: function (options) {
        let that = this;
        this.getMyBidding({
            status: 1
        });
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

    tabClick: function (e) {
        this.setData({
            sliderOffset: e.currentTarget.offsetLeft,
            activeIndex: e.currentTarget.id
        });

        let status = e.currentTarget.id,
            postData = {};

        if (status == 0) {
            postData.status = 1;
        } else if (status == 1) {
            postData.status = 2;
            postData.deal_su_uid = 1;
        } else if (status == 2) {
            postData.status = 2;
            postData.deal_su_uid = 0;
        }

        this.getMyBidding(postData);
    },

    getMyBidding: function(postData) {
      let that = this;

        app.request({
            url: '_a=shop&_u=ajax.get_my_bids',
            data: postData,
            success: (ret)=>{
                console.log(ret)
                let goods = ret.data.list,
                    now = parseInt(new Date().getTime()/1000);

                goods.forEach(function(good) {
                    let img = good.ap.image,
                        price = 0;
                    good.img = img.startsWith("http") ? img : (app.globalData.prefix_url + img);

                    // 处理拍卖时间
                    if (good.last_time == 0) {
                      good.last_time = '无限期';
                    } else {
                      let time = util.formatTime(good.last_time);
                      good.last_time = [time[0], '年', time[1], '月', time[2], '日'].join('');
                    }

                    // if (good.status == 1) {
                    //     good.statusText = '';
                    // } else if (good.status == 2) {}

                    // 处理开始时间
                    if (now < good.start_time) {
                      // 未开始
                      good.hasStart = false;
                      let time = util.formatTime(good.start_time);
                      good.startTime = [time[1], '月', time[2], '日', time[3]].join('');
                    } else {
                      good.hasStart = true;
                    }

                    // 处理拍卖价格
                    if (good.last_price == 0) {
                      price = parseInt(good.ap.min_price/100);
                      price = formatPrice(price);
                    } else {
                      price = parseInt(good.last_price/100);
                      price = formatPrice(price);
                    }

                    good.last_price = price;
                });

                that.setData({
                    goodsList: goods,
                    showEmpty: goods.length < 10
                });
            }
        });
    },

    onPullDownRefresh: function () {
    
    },

    onReachBottom: function () {
    
    }
})