var app = getApp();
var util = require('../../../../utils/util.js')

Page({

    data: {
    
    },

    onLoad: function (options) {
        var that = this;
        
        that.setData({
            mainColor: app.globalData.main_color,
            options: options
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
        var id = options.goodId;

        app.request({
            url: "_a=shop&_u=ajax.get_product_order_list",
            data: {
                uid: id,
                limit: -1
            },
            success: function(ret) {
                // ret.data.list
                console.log("group good ret >>>", ret);
                var groupList = ret.data.list;
                // groupList = groupList.length > 2 ? groupList.slice(0, 2) : groupList;
                groupList.forEach(function(ele) {
                    var now = new Date();

                    var remainTime = parseInt(ele.paid_time) + 3600*24 - parseInt(now.getTime() / 1000);
                    ele.leftTime = remainTime;
                    ele.remainTime = util.formatRemainTime(remainTime);
                });

                that.freshTime(groupList);

                that.setData({
                    groupList: groupList
                });
            }
        });
    },

    // 参团事件
    navToGroupJoin: function(e) {
        // var group = this.data.group;
        var group = e.currentTarget.dataset.group;
        if (group.leftTime > 0) {
            var groupId = group.uid,
                goodId = this.data.options.goodId;
            
            var navUrl = "../joinGroup/joinGroup?goodId=" + goodId + "&groupId=" + groupId;

            wx.navigateTo({
                url: navUrl
            });
        }
    },

    // 刷新时间
    freshTime: function(groupList) {
        var that = this;
        var sh = setInterval(function() {
            groupList.forEach(function(ele) {
                ele.leftTime--;
                if (ele.leftTime <= 0) {
                    ele.remainTime = "团购已过期";
                } else {
                    ele.remainTime = util.formatRemainTime(ele.leftTime);
                }
            });

            that.setData({
                groupList: groupList
            });
        }, 1000);
    },

    onShow: function () {
    
    },

    onPullDownRefresh: function () {
    
    },

    /**
     * 用户点击右上角分享
     */
    onShareAppMessage: function () {
    
    }
})