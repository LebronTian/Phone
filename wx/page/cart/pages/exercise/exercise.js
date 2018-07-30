// page/cart/pages/exercise/exercise.js
var sliderWidth = 96;
var app = getApp();
var util = require('../../../../utils/util.js');

Page({
    data:{
        headerLoop: [],
        // 导航栏标签数组
        tabs: [],
        sliderOffset: 0,
        sliderLeft: 0,

        noMore: false,

        // 活动列表
        list: []
    },
    onLoad:function(options){
        var that = this;
        this.setData({
            mainColor: app.globalData.main_color,
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });

        // 获取活动列表
        that.getExerList(0);
    },

    // 获取活动列表请求
    getExerList: function(page) {
        var that = this;

        app.request({
            url: "_a=form&_u=ajax.formlist",
            data: {
                type: "activity",
                limit: 10,
                page: page,
                no_brief: true
            },
            success: (ret)=>{
                console.log("exer list cb>>>>>", ret);
                var exerList = ret.data.list;

                exerList.forEach(function(ele) {
                    let time = util.formatTime(ele.access_rule.astart_time);
                    time.pop();
                    ele.date = time.join("/");
                    ele.img = ele.img.startsWith("http") ? ele.img : (app.globalData.prefix_url + ele.img);

                    // ele.price = parseFloat(ele.access_rule.order.price/100).toFixed(2);
                    ele.price = util.formatPrice(ele.access_rule.order.price);
                });

                var list = that.data.list.concat(exerList);

                that.setData({
                    page: page,
                    list: list,
                    noMore: list.length < 10
                });
                
                wx.stopPullDownRefresh();
            }
        });
    },

    // 分享该页面
    onShareAppMessage: function () {
        return {
          title: '',
          success: function(res) {
            // 转发成功
          },
          fail: function(res) {
            // 转发失败
          }
        }
    },

    // 上拉加载
    onReachBottom: function () {
        var page = this.data.page + 1;

        this.getExerList(page);
    },

    // 下拉刷新
    onPullDownRefresh: function(){
        this.setData({
            list: []
        });
        this.onLoad();
    }
})