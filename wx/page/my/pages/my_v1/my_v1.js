// page/my/pages/my_v1/my_v1.js
var app = getApp()
Page({
    data: {
        mainColor: "",
        orderStatus: [
            {
                title: "待付款",
                img: "/page/resources/pic/unPaid.png",
                url: "/page/my/pages/myOrders/myOrders?index=1"
            },{
                title: "待发货",
                img: "/page/resources/pic/send.png",
                url: "/page/my/pages/myOrders/myOrders?index=2"
            },{
                title: "待收货",
                img: "/page/resources/pic/truck.png",
                url: "/page/my/pages/myOrders/myOrders?index=3"
            },{
                title: "待评价",
                img: "/page/resources/pic/unComment.png",
                url: "/page/my/pages/myOrders/myOrders?index=4"
            }
        ],
        subTitles: [
            {
                title: "会员中心",
                show: true,
                content: "",
                url: "/page/my/pages/myvip/myvip",
                img: "/page/resources/pic/vipCenter.png",
            },
            {
                title: "收货地址",
                show: true,
                content: "",
                url: "/page/class/pages/address/address",
                img: "/page/resources/pic/address.png",
            },
            {
                title: "我的优惠券",
                show: true,
                content: "",
                url: "/page/my/pages/coupon/coupon",
                img: "/page/resources/pic/myCoupon.png",
            },
            {
                title: "我的收藏",
                show: true,
                content: "",
                url: "/page/my/pages/favorite/favorite",
                img: "/page/resources/pic/myFavorite.png",
            },
            {
                title: "分销中心",
                show: true,
                content: "",
                url: "/page/cart/pages/distributionCenter/distributionCenter",
                img: "/page/resources/pic/distributionCenter.png",
            },
            {
                title: "咨询中心",
                show: true,
                content: "",
                url: "contact",
                img: "/page/resources/pic/contactCenter.png",
            },
            {
                title: "设置中心",
                show: true,
                content: "",
                url: "/page/my/pages/editMyInfo/editMyInfo",
                img: "/page/resources/pic/settingCenter.png",
            },
        ]
    },

    onLoad: function() {
        var that = this;

        this.setData({
            mainColor: app.globalData.main_color,
        });

        // 获取公司信息
        that.getCompanyInfo();

        // 自动签到
        that.autoRegister();
    },

    onShow: function() {
        var that = this;
        wx.setNavigationBarColor({frontColor: '#ffffff',
                backgroundColor: that.data.mainColor,
                });

        // 获取用户资料
        that.getMyInfo();

        // 获取订单状态信息
        that.getOrderInfo();

        // 获取用户的积分
        that.getPoint();

        // 获取用户收藏商品数量
        that.getFavorite();
    },

    // 获取公司信息函数
    getCompanyInfo: function(cb) {
        var that = this;
        app.request({
            url: "_a=shop&_u=ajax.shop",
            success: function(ret) {
                if (typeof(cb) === "function") {
                    cb(ret);
                } else {
                    var company = ret.data;
                    var subTitles = that.data.subTitles;

                    subTitles.forEach(function(ele) {
                        if (ele.url === "makePhone") {                            
                            if (company.phone) {
                                ele.content = company.phone;
                            } else {
                                ele.show = false;
                            }
                        }
                    });
                    that.setData({
                        phone: company.phone,
                        subTitles: subTitles
                    });
                }
            }
        });
    },

    // 自动签到
    autoRegister: function() {
        var that = this;
        app.request({
            url:"_a=usign&_u=ajax.sign",
            success: (ret)=>{
                console.log("register info ret >>>", ret);
                if (ret.data && ret.data != 0) {
                    var content = "今日签到成功，获得 " + ret.data + " 积分";
                    wx.showModal({
                        title: "签到成功!",
                        content: content,
                        showCancel: false
                    });
                }
            }
        });
    },


    // 获取积分函数
    getPoint: function(cb) {
        var that = this;
        app.request({
            url: "_a=su&_u=ajax.point",
            success: function(ret) {
                console.log("point ret >>>>>", ret);
                if (typeof(cb) === "function") {
                    cb(ret);
                } else {
                    var pointRemain = ret.data.point_remain;
                    var cashRemain = parseFloat(ret.data.cash_remain/100).toFixed(2);

                    that.setData({
                        showPoint: pointRemain,
                        showCash: cashRemain
                    });
                    wx.stopPullDownRefresh();
                }
                
            }
        });
    },

    // 获取用户收藏商品数量函数
    getFavorite: function() {
        var that = this;
        app.request({
            url: "_a=shop&_u=ajax.favlist",
            data: {
                limit: -1
            },
            success: (ret) =>{
                console.log("favorite business list ret >>>>", ret);
                var bizList = ret.data.list,
                    favNum = bizList.length ? bizList.length : 0;

                that.setData({
                    favNum: favNum
                });
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
                            myInfo: ret.data,
                            vipName: myVipInfo[0].name
                        });
                    } else {
                        that.setData({
                            myInfo: ret.data,
                        });
          }
                    wx.stopPullDownRefresh();
                }
            }
        });
    },

    // 获取订单状态信息函数
    getOrderInfo: function(cb) {
        var that = this;
        app.request({
            url: "_a=shop&_u=ajax.status_cnt",
            success: function(ret) {
                if (typeof(cb) ===  "function") {
                    cb(ret);
                } else {
                    var orderStatus = that.data.orderStatus;
                    var getStatus = ret.data;

                    orderStatus.forEach(function(ele) {
                        ele.count = false;
                    });

                    getStatus.forEach(function(ele) {
                        for (var i = 0; i < orderStatus.length; i++) {
                            ele.status == i + 1 && (orderStatus[i].count = ele.count);
                        }
                    });

                    that.setData({
                        orderStatus: orderStatus
                    });
                    wx.stopPullDownRefresh()
                }
            }
        });
    },

    navToEdit: function() {
        wx.navigateTo({
            url: "/page/my/pages/editMyInfo/editMyInfo"
        });
    },

    // 导航至我的订单
    navToOrderStatus: function() {
        wx.navigateTo({
            url: "/page/my/pages/myOrders/myOrders"
        });
    },

    subHandle: function(e) {
        var that = this;
        var url = e.currentTarget.id;

        if (url == "makePhone") {
            wx.makePhoneCall({
                phoneNumber: that.data.phone
            })
        } else {
            wx.navigateTo({
                url: url
            });
        }
    },

    // 下拉刷新
    onPullDownRefresh: function () {
        this.onLoad();
        this.onShow();
    },
});
