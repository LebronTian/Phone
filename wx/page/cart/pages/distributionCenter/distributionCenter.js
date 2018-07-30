// page/cart/pages/distributionCenter/distributionCenter.js
var app = getApp();
var util = require("../../../../utils/util.js");

Page({

    data: {
        mainColor: app.globalData.main_color,
        navTitles: [
            {
                title: "佣金明细",
                url: "/page/my/pages/pointDetail/pointDetail?from=cash"
            },
            {
                title: "我的团队",
                url: "/page/my/pages/team/team"
            },
            {
                title: "邀请好友",
                url: "/page/my/pages/qrCode/qrCode"
            },
            {
                title: "分销订单",
                url: "/page/cart/pages/distributionList/distributionList"
            }
        ],

        navList: [
            {
                title: '分销佣金',
                link: '',
                imgUrl: '../../pic/money.png',
                num: '',
                text: '元'
            },{
                title: '分销订单',
                link: '/page/cart/pages/distributionList/distributionList',
                imgUrl: '../../pic/order.png',
                num: '',
                text: '个'
            },{
                title: '佣金明细',
                link: '/page/my/pages/pointDetail/pointDetail?from=cash',
                imgUrl: '../../pic/detail.png',
                num: '',
                text: '佣金明细'
            },{
                title: '我的团队',
                link: '/page/my/pages/team/team',
                imgUrl: '../../pic/myTeam.png',
                num: '',
                text: '人'
            },
            // {
            //     title: '我的客户',
            //     link: '',
            //     imgUrl: '../../pic/client.png',
            //     num: '',
            //     text: ''
            // },
            {
                title: '二维码',
                link: '/page/my/pages/qrCode/qrCode',
                imgUrl: '../../pic/qrcode.png',
                num: '',
                text: '推广二维码'
            }
        ]
    },

    onLoad: function (options) {
        var that = this;
        this.setData({
            mainColor: app.globalData.main_color
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: this.data.mainColor,
        });

        this.getMyInfo();
        this.getCashInfo();
        this.getList();
        this.getFans();
    },

    onShow: function () {
        this.getDisInfo();
    },

    // 获取分销信息
    getDisInfo: function(cb) {
        var that = this;

        app.request({
            url: "_a=shop&_u=ajax.get_user_distribution",
            success: (ret) => {
                console.log("getDisInfo ret >>>>", ret);
                if (typeof cb == "function") {
                    cb(ret);
                } else {
                    if (ret.data.create_time) {
                        var time = util.formatTime(ret.data.create_time),
                            joinTime = time.join("-");
                        that.setData({
                            joinTime: joinTime
                        });
                    }

                    if (!ret.data) {
                        // 未申请
                        wx.showModal({
                            title: "未申请",
                            content: "您还不是分销商，是否申请成为分销商？",
                            confirmText: "去申请",
                            success: (res)=>{
                                if (res.confirm) {
                                    wx.navigateTo({
                                        url: "../applyDistribution/applyDistribution"
                                    });
                                }
                                if (res.cancel) {
                                    wx.navigateBack();
                                }
                            }
                        });
                    } else if (ret.data.status == 2) {
                        // 未通过审核
                        wx.showModal({
                            title: "审核失败",
                            content: "您的申请未通过后台审核，请重新申请，详情请联系客服",
                            confirmText: "联系客服",
                            success: (res)=>{
                                if (res.confirm) {
                                    wx.navigateTo({
                                        url: "../applyDistribution/applyDistribution"
                                    });
                                }
                                if (res.cancel) {
                                    wx.navigateBack();
                                }
                            }
                        });
                    } else if (ret.data.status == 0) {
                        // 审核中
                        wx.showModal({
                            title: "审核中",
                            content: "您的申请正在后台审核中，请耐心等待",
                            // confirmText: "联系客服",
                            showCancel: false,
                            success: (res)=>{
                                if (res.confirm) {
                                    // wx.navigateTo({
                                    //     url: "../applyDistribution/applyDistribution"
                                    // });
                                    wx.navigateBack();
                                }
                                // if (res.cancel) {
                                //     wx.navigateBack();
                                // }
                            }
                        });
                    }
                }
            }
        });
    },

    // 获取用户资料
    getMyInfo: function(cb) {
        var that = this;
        app.request({
            url: "_a=su&_u=ajax.profile",
            success: function(ret) {
                if (typeof(cb) === "function") {
                    cb(ret);
                } else {
                    console.log("user profile >>>", ret);
                    var myVipInfo = ret.data.groups;
                    // var customAvatar = myInfo.profile.extra_info.avatar;
                    // myInfo.avatar = customAvatar ? (app.globalData.prefix_url + customAvatar) : myInfo.su.avatar;
                    that.setData({
                        avatar: ret.data.su.avatar,
                        name: ret.data.su.name,
                    });
                    if (myVipInfo.length > 0) {
                        that.setData({
                            // myInfo: ret.data,
                            vipName: myVipInfo[0].name
                        });
                    }
                }
            }
        });
    },

    // 获取佣金信息
    getCashInfo: function() {
        var that = this;
        // 获取用户的积分
        app.request({
            url: "_a=su&_u=ajax.point",
            success: function(ret) {
                console.log("point ret >>>>>", ret);
                let navList = that.data.navList;
                var pointRemain = ret.data.point_remain;
                var cashRemain = ret.data.cash_remain/100;
                navList[0].num = cashRemain

                that.setData({
                    navList
                });
            }
        });
    },

    // 分销订单
    getList: function() {
        var that = this;

        app.request({
            url: "_a=shop&_u=ajax.distributionlist",
            success: (ret)=>{
                console.log("list ret >>>>>>>",ret);
                let navList = that.data.navList;
                navList[1].num = ret.data.dtblist.count;
                that.setData({navList});
            }
        });
    },

    // 下级用户
    getFans: function() {
        let that = this;

        app.request({
            url: '_a=shop&_u=ajax.get_sub_user_list',
            success: (ret)=>{
                console.log("fans ret >>>", ret);
                let navList = that.data.navList;
                navList[3].num = ret.data.count
                that.setData({navList});
            }
        });
    },

    onPullDownRefresh: function () {
    
    },

    onShareAppMessage: function () {
    
  }
})