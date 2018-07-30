var app = getApp();
var util = require('../../../../utils/util.js');
var pay = require('../../../../utils/pay.js')

Page({

    data: {
        // pointList: [],
        rules: [],
        mainColor: app.globalData.main_color,
        selectedIndex: -1,
        showCharge: false
    },

    onLoad: function (options) {
        var that = this;
        this.setData({
            mainColor: app.globalData.main_color,
            pointList: [],
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: this.data.mainColor,
        });

        this.getChargeRule();
    },

    onShow: function() {
        var that = this;
    },

    // 获取充值优惠规则
    getChargeRule: function() {
        var that = this;

        app.request({
            url: "_a=su&_u=ajax.get_cash_rules",
            success: (ret) => {
                console.log("charge rule >>>>", ret);
                var rules = ret.data.rule;

                rules.forEach(function(ele) {
                    for (var i = 0; i < ele.length; i++) {
                        ele[i] = parseFloat(ele[i]/100);
                    }
                });

                that.setData({
                    rules: rules
                });
            }
        });
    },

    getCashDetail: function() {
        var that = this;
        var pointList = that.data.pointList;
        // var page = that.data.page;

        // 获取用户的余额
        app.request({
            url: "_a=su&_u=ajax.get_user_cash_list",
            data: {
                page: 0,
                limit: 3
            },
            success: function(ret) {
                var newList = ret.data.list;
                console.log("cash list >>>", newList);
                // console.log("cash list page >>>", page);
      
                newList.forEach(function(ele) {
                    var time = util.formatTime(ele.create_time);
                    ele.time = time[0] + "-" + time[1] + "-" + time[2] + " " + time[3];
                    ele.cash = parseFloat(ele.cash/100).toFixed(2);
                });
      
                that.setData({
                    pointList: pointList.concat(newList)
                });
            }
        });
    },

    // 选择充值数额
    selectPrice: function(e) {
        var id = e.currentTarget.dataset.id,
            rules = this.data.rules;

        if (id == "custom") {
            this.showModal();
        } else {
            var money = rules[id][0];
            this.setData({
                selectedIndex: id,
                money: money
            });
        }
        console.log("selectPrice >>>>", id);
        console.log("selectPrice >>>>", money);
    },

    // 显示提现输入框
    showModal: function(e) {
        this.setData({
            showCharge: true
        });
    },

    // 隐藏提现输入框
    hideModal: function() {
        this.setData({
            showCharge: false,
            selectedIndex: -1
        });
    },

    // 输入提现金额
    inputMoney: function(e) {
        var money = e.detail.value;
        this.setData({
            money: money
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
            title: "充值错误",
            content: title,
            showCancel: false
        });
    },

    //支付
    do_pay: function(uid) {
        return pay.do_pay('g'+uid, this);
    },

    onReachBottom: function () {
        this.getCashDetail();
    },

    onShareAppMessage: function () {

    }
})