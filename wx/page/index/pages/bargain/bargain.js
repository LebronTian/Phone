var app = getApp();
var util = require('../../../../utils/util.js');
var WxParse = require('../../../common/wxParse/wxParse.js');

Page({

    data: {
        bargainStatus: 0,
        isShowIntro: false,
        isShare: false
    },

    onLoad: function (options) {
        console.log("onLoad");
        var that = this;
        if (!app.globalData.su_uid) {
            app.getUserInfo(function(userInfo) {
                that.onLoad(options);
            });
            console.log("no uid");
        } else {
            this.setData({
                mainColor: app.globalData.main_color
            });
            wx.setNavigationBarColor({
                frontColor: '#ffffff',
                backgroundColor: app.globalData.main_color,
            });
            console.log("options >>>>>", options);

            var parentId = 0,
                isMine = true;

            if (options.parentId) {
                parentId = options.parentId;
                isMine = parentId == app.globalData.su_uid;
            }

            // 分销功能
            if (!isMine && parentId) {
                app.request({
                    url: "_a=su&_u=ajax.update_su",
                    data: {
                        from_su_uid: options.parentId
                    },
                    success: function(ret) {
                        console.log("add fans ret", ret);
                    }
                });
            }

            this.getBargainDetail(options.id, parentId);

            this.setData({
                goodId: options.id,
                options: options,
                parentId: parentId,
                isMine: isMine
            });
        }
    },

    onShow: function () {
    
    },

    // 获取砍价详情
    getBargainDetail: function(id, parentId, cb) {
        var that = this;
        app.request({
            url: "_a=bargain&_u=ajax.get_user_bargain",
            data: {
                b_uid: id,
                su_uid: parentId
            },
            success: (ret)=>{
                console.log("bargain detail >>>>>", ret);
                if (typeof cb == "function") {
                    cb(ret);
                } else {
                    var goodData = ret.data.bargain,
                        bargainUser = ret.data.bargain_user,
                        bargainHelp = ret.data.bargain_help ? ret.data.bargain_help : null,
                        img = goodData.product_info.img;

                    var goodId = goodData.product_info.p_uid;
                    if (goodId) that.getGoodDetail(goodId);

                    goodData.image = img.startsWith("http") ? img : (app.globalData.prefix_url + img);
                    goodData.lowest_price = parseFloat(goodData.lowest_price/100).toFixed(2);
                    goodData.ori_price = parseFloat(goodData.ori_price/100).toFixed(2);
                    
                    var article = goodData.info;
                    WxParse.wxParse('article', 'html', article, that, 5);

                    var now = new Date(),
                        now = parseInt(now.getTime() / 1000);
                    var remainTime = goodData.rule.end_time - now;

                    var time = {};
                    time.leftTime = remainTime;
                    time.remainTime = util.formatRemainTime(remainTime);
                    that.freshTime(time);

                    if (bargainUser) {
                        bargainUser.current_price = parseFloat(bargainUser.current_price/100).toFixed(2);
                        that.setData({
                            bargainUserId: bargainUser.uid
                        });
                    }

                    var helpList = [];
                    if (ret.data.helplist) {
                        helpList = ret.data.helplist.list
                        helpList.forEach(function(ele) {
                            ele.fee = parseFloat(ele.bargain_fee/100).toFixed(2);
                            var time = util.formatTime(ele.create_time);
                            ele.time = time.join("-");
                        });
                    }

                    that.setData({
                        bargainStatus: goodData.status,
                        goodData: goodData,
                        time: time,
                        bargainUser: bargainUser,
                        bargainHelp: bargainHelp,
                        helpList: helpList
                    });
                }
            }
        });
    },

    // 刷新时间
    freshTime: function(time) {
        var that = this;
        var sh = setInterval(function() {
            time.leftTime--;
            if (time.leftTime < 0) {
                // goodData.status = 1;
            } else {
                time.remainTime = util.formatRemainTime(time.leftTime);
            }

            that.setData({
                time: time
            });
        }, 1000);
    },

    // 点击显示课程简介
    showIntro: function() {
        var that = this;
        var isShowIntro = !that.data.isShowIntro;

        that.setData({
            isShowIntro: isShowIntro
        });
    },

    // 获取商品详情函数
    getGoodDetail: function(id, cb) {
        var that = this;

        // 获取商品详情
        app.request({
            url: "_a=shop&_u=ajax.product",
            data: {
                uid: id
            },
            success: function(ret) {
                if (typeof(cb) === "function") {
                    cb(ret);
                } else {
                    that.getGoodDetailCb(ret);
                }
            }
        });
    },
    getGoodDetailCb: function(ret) {
        console.log("good detail >>>>>", ret);
        var that = this;
        var detail = ret.data;

        if (detail.main_img && !detail.main_img.startsWith("http")) detail.main_img = app.globalData.prefix_url + detail.main_img;

        // 处理商品价格
        detail.price = parseInt(detail.price) / 100;

        console.log("good >>>>>", ret);
        var mainImg = detail.main_img.startsWith("http") ? detail.main_img : (app.globalData.prefix_url + detail.main_img);

        that.setData({
            goodDetail: detail,
            quantity: detail.quantity,
            price: detail.price,
        });
    },

    // 申请砍价／找人帮砍
    applyBargain: function() {
        var that = this,
            goodId = that.data.goodId,
            bargainUser = that.data.bargainUser,
            options = that.data.options;

            console.log("taptap");

        if (!bargainUser) {
            // 申请砍价
            app.request({
                url: "_a=bargain&_u=ajax.apply_bargain_by_uid",
                data: {
                    b_uid: goodId
                },
                success: (ret)=>{
                    console.log("apply bargain ret >>>>>", ret);
                    that.onLoad(options);
                    wx.showModal({
                        title: "申请成功",
                        content: "申请砍价成功，快分享给你的朋友，让他们帮忙砍价吧",
                        showCancel: false
                    });
                }
            });
        } else {
            that.showShare();
        }
    },

    // 点击阴影部分，关闭分享按钮组
    tapShadow: function() {
        var that = this;
        that.setData({
            isShare: false
        });
    },

    // 打开分享按钮组
    showShare: function() {
        var that = this;
        that.setData({
            isShare: true
        });
    },

    // 前往分享图片页
    navToShareImg: function() {
        var that = this;
        that.tapShadow();
        wx.navigateTo({
            url: "../bargainImg/bargainImg?bargainId=" + that.data.goodId
        });
    },

    // 帮忙砍价
    helpBargain: function() {
        var that = this,
            options = that.data.options,
            b_uid = that.data.bargainUser.uid;
        if (!that.data.bargainHelp) {
            app.request({
                url: "_a=bargain&_u=ajax.help_bargain",
                data: {
                    bu_uid: b_uid
                },
                success: (ret)=>{
                    console.log("help bargain ret >>>>>", ret);
                    if (ret.data && ret.data != 0) {
                        that.onLoad(options);
                        var fee = parseFloat(ret.data.k_fee/100).toFixed(2);
                        var content = "已成功帮忙砍价" + fee + "元";

                        wx.showModal({
                            title: "砍价成功！",
                            content: content,
                            showCancel: false
                        });
                    } else if (ret.errno == 403 && ret.errstr == "ERROR_OUT_OF_LIMIT") {
                        wx.showModal({
                            title: "砍价失败",
                            content: "已超过可砍价次数",
                            showCancel: false
                        });
                    } else if (ret.errno == 701 && ret.errstr == "ERROR_DBG_STEP_1") {
                        wx.showModal({
                            title: "砍价失败",
                            content: "已砍至最低价格",
                            showCancel: false
                        });
                    } else {
                        wx.showModal({
                            title: "砍价失败",
                            content: "请检查您的网络",
                            showCancel: false
                        });
                    }
                }
            });
        }
    },

    // 购买
    buyTap: function() {
        var that = this,
            price = that.data.price,
            detail = that.data.goodDetail;

        if (that.data.bargainUser) {
            var b_uid = that.data.bargainUser.uid;
            var order = {};
            order.list = [];

            var goodOrder = {
                detailData: detail,
                price: price,
                selectedNum: 1,
                specials: "",
                specialKey: "",
                bu_uid: b_uid
            };

            order.list.push(goodOrder);

            // 将选中的订单存入本地
            wx.setStorage({
                key: "groupOrder",
                data: order
            });

            wx.navigateTo({
                url: "../../../class/pages/groupOrder/groupOrder"
            });
        } else {
            wx.navigateTo({
                url: "../../../class/pages/goodDetail/goodDetail?uid=" + detail.uid
            });
        }
    },

    onPullDownRefresh: function () {
    
    },

    onReachBottom: function () {
    
    },

    onShareAppMessage: function () {
        var shareUrl = "/page/index/pages/bargain/bargain?parentId=" + app.globalData.su_uid +"&id=" + this.data.goodId;
        var shareInfo = {
            title: "来帮我砍价吧",
            path: shareUrl
        };
        return shareInfo;
    }
})