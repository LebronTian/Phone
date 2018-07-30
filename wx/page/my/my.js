var app = getApp()
Page({
    data: {
        mainColor: "",
        
    	orderStatus: [
    		{
    			title: "待付款",
                img: app.globalData.server_url + "_u=common.img&name=pay.png",
    			url: "pages/myOrders/myOrders?index=1"
    		},{
    			title: "待发货",
                img: app.globalData.server_url + "_u=common.img&name=send.png",
    			url: "pages/myOrders/myOrders?index=2"
    		},{
    			title: "待收货",
                img: app.globalData.server_url + "_u=common.img&name=truck.png",
    			url: "pages/myOrders/myOrders?index=3"
    		},{
    			title: "待评价",
                img: app.globalData.server_url + "_u=common.img&name=comment.png",
    			url: "pages/myOrders/myOrders?index=4"
    		}
    	],
        subTitles: [
            {
                title: "我的收藏",
                show: true,
                content: "",
                url: "pages/favorite/favorite",
                img: app.globalData.server_url + "_u=common.img&name=my-favorite-full.png",
            },
            {
                title: "兑换订单",
                show: true,
                content: "",
                url: "pages/pointOrders/pointOrders",
                img: app.globalData.server_url + "_u=common.img&name=my-favorite-full.png",
            },
            {
                title: "优惠券",
                show: true,
                content: "",
                url: "pages/coupon/coupon",
                img: app.globalData.server_url + "_u=common.img&name=coupon_1.png",
            },
            {
                title: "地址管理",
                show: true,
                content: "",
                url: "../class/pages/address/address",
                img: app.globalData.server_url + "_u=common.img&name=location.png",
            },{
                title: "绑定手机号",
                show: true,
                url: "pages/setPhone/setPhone",
                img: app.globalData.server_url + "_u=common.img&name=cellphone.png",
            }
            ,{
                title: "客服电话",
                show: true,
                content: "000000",
                url: "makePhone",
                img: app.globalData.server_url + "_u=common.img&name=service.png",
            }
            ,{
                title: "关于我们",
                content: "",
                url: "../index/pages/article/article?uid=29",
                img: app.globalData.server_url + "_u=common.img&name=information.png",
            }
        ]
    },

    onLoad: function() {
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
        
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
		wx.setNavigationBarColor({
            frontColor: '#ffffff',
			backgroundColor: that.data.mainColor,
		});

        // 获取用户资料
        that.getMyInfo();

        // 获取订单状态信息
        that.getOrderInfo();

        // 获取用户的积分
        that.getPoint();
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
                        if (ele.title === "客服电话") {
                            ele.url = "makePhone";
                            
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
            url: "pages/editMyInfo/editMyInfo"
        });
    },

    // 导航至我的订单
    navToOrderStatus: function() {
    	wx.navigateTo({
    		url: "pages/myOrders/myOrders"
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
