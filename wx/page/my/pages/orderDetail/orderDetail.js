var app = getApp();
var util = require('../../../../utils/util.js');
var pay = require('../../../../utils/pay.js')

Page({

    data: {

    },

    onLoad: function (options) {
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
        var that = this;
        this.setData({
            mainColor: app.globalData.main_color,
            options: options
        });
    },

    onShow: function() {
        var that = this,
            id = that.options.uid;

        if (that.options.from === "pointGood") {
            that.getPointOrder(id);
        } else {
            that.getOrderStatus(id);
        }
    },

    getOrderStatus: function(id, cb) {
        var that = this;

        app.request({
            url: "_a=shop&_u=ajax.order",
            data: {
                uid: id
            },
            success: function(ret) {
                console.log("order >>>>", ret);
                if (typeof cb == 'function') {
                    cb(ret);
                } else {
                    var order = ret.data;

                    var time = util.formatTime(order.create_time);
                    order.time = time[0] + "-" + time[1] + "-" + time[2] + " " + time[3];

                    var status = order.status;

                    if (status === "1") {
                        order.handles = ["去付款", "取消订单"];
                    } else if (status === "2") {
                        order.handles = ["联系发货", "申请退款"];
                    } else if (status === "3") {
                        order.handles = ["确认收货", "申请退款"];
                    } else if (status === "4") {
                        order.handles = ["去评价", "申请退款"];
                    } else if (status === "5") {
                        order.handles = ["已评价"];
                    }

                    order.status = that.convertStatus(status);
                    order.price = parseFloat(order.paid_fee / 100).toFixed(2);

                    order.products.forEach(function(good) {
                        var img = good.main_img;
                        good.img = img.startsWith("http") ? img : (app.globalData.prefix_url + img);
                        // good.img = app.globalData.prefix_url + good.main_img;
                        good.price = parseInt(good.paid_price) / 100;

                        var specials = good.sku_uid.split(";");
                        specials.shift();

                        good.specials = "";

                        if (specials[0] != "") {
                            specials.forEach(function(ele) {
                                var special = ele.split(":")[1];
                                good.specials += special + " ";
                            });
                        }                    
                    });

                    that.setData({
                        order: order
                    });
                }
                
            }
        });
    },

    getPointOrder: function(id, cb) {
        var that = this;

        app.request({
            url: "_easy=qrposter.ajax.order",
            data: {
                uid: id
            },
            success: function(ret) {
                console.log("point order >>>>", ret);
                if (typeof cb == 'function') {
                    cb(ret);
                } else {
                    var order = ret.data;

                    var time = util.formatTime(order.create_time);
                    order.time = time[0] + "-" + time[1] + "-" + time[2] + " " + time[3];

                    var status = order.status;

                    if (status === "1") {
                        order.handles = ["去付款", "取消订单"];
                    } else if (status === "2") {
                        order.handles = ["联系发货"];
                    } else if (status === "3") {
                        order.handles = ["确认收货"];
                    } else if (status === "4") {
                        order.handles = ["去评价"];
                    } else if (status === "5") {
                        order.handles = ["已评价"];
                    }

                    order.status = that.convertStatus(status);

                    order.products.forEach(function(good) {
                        var img = good.main_img;
                        good.img = img.startsWith("http") ? img : (app.globalData.prefix_url + img);
                    });

                    that.setData({
                        order: order
                    });
                }
                
            }
        });
    },

    convertStatus: function(status) {
        var numToWord = {
            "1" : "待付款", "2" : "待发货", "3" : "待收货",
            "4" : "已收货", "5" : "已评价", "6" : "协商完成",
            "8" : "协商中(退货，换货)", "9" : "店家已取消", "10" : "已取消",
            "11" : "等待卖家确认"
        }
        return numToWord[status];
    },

	//支付
	do_pay: function(uid) {
		return pay.do_pay('b'+uid, this);
	},

    // 操作订单
    handleOrder: function(e) {
        var formId = e.detail.formId;
        var that = this;
        var handleId = e.currentTarget.id;
        var options = that.data.options;
        console.log("handle e >>>>", e);

        var handle = handleId.split(" ")[0];
        var id = handleId.split(" ")[1];

        switch(handle) {
            case "去付款":
                return that.do_pay(id);
                break;

            case "取消订单":
                wx.showModal({
                    content: "确认要取消该订单吗？",
                    cancelText: "取消订单",
                    confirmText: "点错了",
                    success: function(res) {
                        if (res.confirm) {
                            console.log('用户点错了')
                        } else if (res.cancel) {
                            app.request({
                                url: "_a=shop&_u=ajax.delete_order",
                                data: {
                                    uid: id
                                },
                                success: function(ret) {
                                    if (ret) {
                                        var index = that.data.activeIndex;
                                        wx.showToast({
                                            title: "取消成功",
                                            success: function() {
                                                wx.navigateBack();
                                            }
                                        })
                                    }
                                }
                            });
                        }
                    }
                });
                break;

            case "申请退款":
                wx.showModal({
                    content: "确认要取消订单并申请退款吗？",
                    cancelText: "申请退款",
                    confirmText: "点错了",
                    success: function(res) {
                        if (res.cancel) {
                            var refundUrl = "../refund/refund?uid=" + id;
                            wx.navigateTo({
                                url: refundUrl
                            });
                        }
                    }
                });
                break;

            case "确认收货":
                if (options.from === "pointGood") {
                    app.request({
                        url: "_easy=qrposter.ajax.do_receipt",
                        data: {
                            uid: id
                        },
                        success: function(ret) {
                            console.log("receive success >>>>", ret);
                            if (ret.data) {
                                wx.showToast({
                                    title: "确认成功"
                                });
                                that.onShow();
                            }
                        }
                    });
                } else {
                    app.request({
                        url: "_a=shop&_u=ajax.do_receipt",
                        data: {
                            uid: id
                        },
                        success: function(ret) {
                            console.log("receive success >>>>", ret);
                            if (ret.data) {
                                wx.showToast({
                                    title: "确认成功"
                                });
                                that.onShow();
                            }
                        }
                    });
                }
                
                break;

            // case "联系发货":
                
            //     break;

            case "去评价":
                var commentUrl = "../selectComment/selectComment?uid=" + id;
                wx.navigateTo({
                    url: commentUrl
                })
                break;
        }
    },

    onPullDownRefresh: function () {

    },

    onShareAppMessage: function () {

    }
})
