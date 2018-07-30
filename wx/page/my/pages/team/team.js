var app = getApp();
var sliderWidth = 96; // 需要设置slider的宽度，用于计算中间位置
// var userTree = {};
var util = require('../../../../utils/util.js')


Page({

    data: {
        tabs: ["我的一级粉丝", "我的二级粉丝"],
        //tabs: ["我的好邻居"],
        activeIndex: 0,
        sliderOffset: 0,
        sliderLeft: 0,

        level2page: {},
        level2num: {},
        num: 0,
        showNomore: false,

        userList: [],
        userTree: {}
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

        that.getFansTree(1, 0);        

        wx.getSystemInfo({
            success: function(res) {
                that.setData({
                    sliderLeft: (res.windowWidth / that.data.tabs.length - sliderWidth) / 2,
                    sliderOffset: res.windowWidth / that.data.tabs.length * that.data.activeIndex
                });
            }
        });
    },

    // 点击导航栏事件
    tabClick: function (e) {
        this.setData({
            sliderOffset: e.currentTarget.offsetLeft,
            activeIndex: e.currentTarget.id
        });

        var level = parseInt(e.currentTarget.id) + 1,
            userTree = this.data.userTree,
            level2num = this.data.level2num;

        if (userTree[level]) {
            this.setData({
                userList: userTree[level],
                num: level2num[level]
            });
        } else {
            this.getFansTree(level, 0);
        }
    },

    // 获取分销团队用户树函数
    getFansTree: function(level, page) {
        var that = this,
            level2page = that.data.level2page,
            level2num = that.data.level2num,
            userTree = that.data.userTree;
        level2page[level] = page;

        // 获取分销团队用户树
        app.request({
            url: "_a=shop&_u=ajax.get_sub_user_list",
            data: {
                level: level,
                with_cash: 1,
                limit: 10,
                page: page
            },
            success: function(ret) {
                console.log("get user list >>>", ret);
                var getList = ret.data.list,
                    num = ret.data.count;

                level2num[level] = num;
                
                getList.forEach(function(ele) {
                    var time = util.formatTime(ele.create_time);
                    ele.time = time[0] + "." + time[1] + "." + time[2] + " " + time[3];

                    ele.cash = ele.paid_cash / 100;
                });

                that.setData({
                    showNomore: getList.length < 10
                });

                // var userList = userTree[level];
                if (userTree[level] && userTree[level].length >= 0) {
                    userTree[level] = userTree[level].concat(getList);
                } else {
                    userTree[level] = getList;
                }
                console.log("local tree >>>>>", userTree);

                that.setData({
                    userList: userTree[level],
                    level2page: level2page,
                    level2num: level2num,
                    num: num,
                    userTree: userTree
                });
            }
        });
    },
    
    onPullDownRefresh: function () {
        this.onLoad();
    },

    onReachBottom: function () {
        var that = this,
            level = parseInt(that.data.activeIndex) + 1,
            level2page = that.data.level2page,
            page = level2page[level] + 1;
        // level2page[level] = page;
        
        // that.setData({
        //     level2page: level2page
        // });

        that.getFansTree(level, page);
    },

    /**
    * 用户点击右上角分享
    */
    onShareAppMessage: function () {

    }
})
