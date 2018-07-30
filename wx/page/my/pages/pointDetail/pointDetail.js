var app = getApp();
var util = require('../../../../utils/util.js');
var pay = require('../../../../utils/pay.js')

Page({

    data: {
        pointList: [],
        mainColor: app.globalData.main_color,
        page: 0,
        showWithdraw: false,
        maxPrice: 0,
        maxPriceDay: 0,
        minPrice: 0
    },

    onLoad: function (options) {
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
        var that = this;
        this.setData({
            from: options.from,
            options: options,
            mainColor: app.globalData.main_color,
            pointList: [],
            page: 0
        });
        var title = "";
        
        if (options.from == "point") {
            this.getPointDetail();
            title = "积分明细";
        } else {
            this.getCashDetail();
            title = "余额明细";
        }

        wx.setNavigationBarTitle({
            title: title
        });

        // 获取提现额度限制
        app.request({
            url: "_a=pay&_u=index.get_wd_cfg",
            success: function(ret) {
                console.log("cash withdraw limit >>>", ret);
                if (ret.data && ret.data.withdraw_rule) {
                    let rule = ret.data.withdraw_rule;
                    let maxPrice = parseFloat(rule.max_price/100).toFixed(2);
                    let maxPriceDay = parseFloat(rule.max_price_day/100).toFixed(2);
                    let minPrice = parseFloat(rule.min_price/100).toFixed(2);

                    that.setData({
                        maxPrice: maxPrice,
                        maxPriceDay: maxPriceDay,
                        minPrice: minPrice
                    });
                }
            }
        });
    },

    onShow: function() {
        var that = this;
        // 获取用户资料
        app.request({
            url: "_a=su&_u=ajax.profile",
            success: function(ret) {
                console.log("user profile >>>", ret);
                that.setData({
                    profile: ret.data.profile
                });
            }
        });
    },

    // 获取用户的积分详情
    getPointDetail: function() {
        var that = this;
        var pointList = that.data.pointList;
        var page = that.data.page;

        // 获取用户的积分
        app.request({
            url: "_a=su&_u=ajax.get_user_point_list",
            data: {
                page: page
            },
            success: function(ret) {
                var newList = ret.data.list;
                console.log("point list >>>", newList);
                console.log("point list page >>>", page);
      
                newList.forEach(function(ele) {
                    let time = util.formatTime(ele.create_time);
                    ele.time = time[0] + "-" + time[1] + "-" + time[2] + " " + time[3];
                });
      
                that.setData({
                    pointList: pointList.concat(newList)
                });
            }
        });
    },

    getCashDetail: function() {
        var that = this;
        var pointList = that.data.pointList;
        var page = that.data.page;

        // 获取用户的余额
        app.request({
            url: "_a=su&_u=ajax.get_user_cash_list",
            data: {
                page: page
            },
            success: function(ret) {
                var newList = ret.data.list;
                console.log("cash list >>>", newList);
                console.log("cash list page >>>", page);
      
                newList.forEach(function(ele) {
                    let time = util.formatTime(ele.create_time);
                    ele.time = time[0] + "-" + time[1] + "-" + time[2] + " " + time[3];
                    ele.cash = parseFloat(ele.cash/100).toFixed(2);
                });
      
                that.setData({
                    pointList: pointList.concat(newList)
                });
            }
        });
    },

    // 显示提现输入框
    showModal: function(e) {
        var profile = this.data.profile;
        var id = e.currentTarget.id;

        if (id == 'charge') {
            this.setData({
                showCharge: true
            });
        } else {
            if (profile && profile.extra_info && profile.extra_info.bankId) {
                if (id == 'withdraw') {
                    this.setData({
                        showWithdraw: true
                    });
                }
            } else {
                wx.showModal({
                    title: "您还没有完善资料，不能提现",
                    confirmText: "去完善",
                    success: function(res) {
                        if (res.confirm) {
                            wx.navigateTo({
                                url: "../myInfo/myInfo"
                            });
                        }
                    }
                });
            }
        }
    },

    // 隐藏提现输入框
    hideModal: function() {
        this.setData({
            showWithdraw: false,
            showCharge: false
        });
    },

    // 输入提现金额
    inputMoney: function(e) {
        var money = e.detail.value;
        this.setData({
            money: money
        });
    },

    // 确定提现操作
    withdraw: function() {
        var that = this,
            cash = this.data.money*100,
            cashRemain = this.data.pointList[0].cash_remain,
            // cashLimit = this.data.cashLimit,
            minPrice = this.data.minPrice*100,
            maxPrice = this.data.maxPrice*100,
            maxPriceDay = this.data.maxPriceDay*100;

        if (!cash || cash == 0) {
            that.warningModal("请输入大于0的具体金额数目");
            console.log("请输入大于0的具体金额数目");
            return;
        } else if (cash > cashRemain) {
            that.warningModal("提现金额超过了账户余额，请重新填写");
            console.log("提现金额超过了账户余额，请重新填写");
            return;
        } else if (cash < minPrice) {
            that.warningModal("提现金额低于最低提现余额，请重新填写");
            console.log("提现金额低于最低提现余额，请重新填写");
            return;
        } else if (maxPrice > 0 ) {
            if (cash > maxPrice) {
                that.warningModal("提现金额超过了最高提现额度，请重新填写");
                console.log("提现金额超过了最高提现额度，请重新填写");
                return;
            }
        } else if (maxPriceDay > 0) {
            if (cash > maxPriceDay) {
                that.warningModal("提现金额超过了日最高提现额度，请重新填写");
                console.log("提现金额超过了日最高提现额度，请重新填写");
                return;
            }
        } 
        // cash = cash*100;
        var options = that.data.options;
        app.request({
            method: "POST",
            url: "_a=pay&_u=index.do_withdraw",
            data: {
                cash: cash,
                openid: app.globalData.openid
            },
            success: function(ret) {
                console.log("withdraw ret >>>", ret);
                if (ret.errno === 0) {
                    wx.showToast({
                        title: "提现成功"
                    });
                } else if (ret.errno === 303) {
                    wx.showToast({
                        title: "提现审核中",
                    });
                } else {
                    that.warningModal("提现失败，请检查您的网络");
                }
                that.hideModal();
                that.regetCashDetail();
            }
        });
    },

    // 确认充值操作
    charge: function() {
        var that = this,
            cash = this.data.money;

        if (!cash || cash == 0) {
            that.warningModal("请输入大于0的具体金额数目");
        } else {
            cash *= 100;
            var options = that.data.options;
            app.request({
                method: "POST",
                url: "_a=su&_u=ajax.make_sucharge_order",
                data: {
                    charge_price: cash
                },
                success: function(ret) {
                    console.log("withdraw ret >>>", ret);
                    if (ret.data && ret.data != 0) {
                        that.do_pay(ret.data);
                    } else {
                        that.warningModal("充值失败，请检查您的网络");
                    }
                    that.hideModal();
                }
            });
        }        
    },

    warningModal: function(title) {
        wx.showModal({
            title: "提现错误",
            content: title,
            showCancel: false
        });
    },

    regetCashDetail: function() {
        var that = this;

        // 获取用户的余额
        app.request({
            url: "_a=su&_u=ajax.get_user_cash_list",
            success: function(ret) {
                var newList = ret.data.list;
      
                newList.forEach(function(ele) {
                    var time = util.formatTime(ele.create_time);
                    ele.time = time[0] + "-" + time[1] + "-" + time[2] + " " + time[3];
                    ele.cash = parseFloat(ele.cash/100).toFixed(2);
                });
      
                that.setData({
                    pointList: newList,
                    page: 0
                });
            }
        });
    },

    //支付
    do_pay: function(uid) {
        return pay.do_pay('g'+uid, this);
    },

    onReachBottom: function () {
        var page = this.data.page + 1;
        this.setData({
            page: page
        });

        var options = this.data.options;

        if (options.from == "point") {
            this.getPointDetail();
        } else {
            this.getCashDetail();
        }
    },

    onShareAppMessage: function () {

    }
})