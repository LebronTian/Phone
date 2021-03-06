// page/my/pages/pointOrders/pointOrders.js
var app = getApp();
var util = require('../../../../utils/util.js')

Page({

    data: {
        mainColor: app.globalData.main_color,        
        allList: {}
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
        var index = parseInt(options.index) || 0;
    },

    onShow: function() {
        console.log("on show");
        var that = this;
        var activeIndex = this.data.activeIndex;
        this.getOrderList(activeIndex);
    },

    // 获取订单列表
    getOrderList: function(index) {
        var that = this;
        var list, orderEmpty;

        app.request({
            url: "_easy=qrposter.ajax.point_order_list",
            data: {
                limit: -1,
                status: index
            },
            success: function(ret) {
                list = ret.data.list;
                console.log("index >>>", index);
                console.log("list >>>", list);

                list.forEach(function(order) {
                    var date = util.formatTime(order.create_time);
                    order.date = date[0] + "-" + date[1] + "-" + date[2];
                    order.price = parseFloat(order.paid_fee / 100).toFixed(2);
                    
                    order.status = that.convertStatus(order.status);

                    var img = order.products[0].main_img;
                    order.img = img.startsWith("http") ? img : (app.globalData.prefix_url + img);

                });

                orderEmpty = (list.length === 0);

                that.setData({
                    orderList: list,
                    orderEmpty: orderEmpty
                });
            }
        });
    },

    convertStatus: function(status) {
        var numToWord = {
            "1" : "待付款", "2" : "待发货", "3" : "待收货",
            "4" : "已收货", "5" : "已评价", "6" : "协商完成",
            "8" : "协商中(退货，换货)", "9" : "店家已取消", "10" : "已取消",
            "11" : "等待卖家确认", "12" : "待成团"
        }
        return numToWord[status];
    },

    // 操作订单
    handleOrder: function(e) {
        var that = this;
        var handleId = e.currentTarget.id;

        var handle = handleId.split(" ")[0];
        var id = handleId.split(" ")[1];

        console.log("handle >>>>>", handle);

        switch(handle) {
            case "取消订单":
                wx.showModal({
                    content: "确认要取消该订单吗？",
                    cancelText: "取消订单",
                    confirmText: "点错了",
                    success: function(res) {
                        if (res.confirm) {
                            console.log('用户点击确定')
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
                                                that.getOrderList(index);
                                            }
                                        })
                                    }
                                }
                            });
                        }
                    }
                });
                break;

            case "确认收货":
                app.request({
                    url: "_a=shop&_u=ajax.do_receipt",
                    data: {
                        uid: id
                    },
                    success: function(ret) {
                        console.log("receive success >>>>", ret);
                        if (ret.data) {
                            wx.showToast({
                                title: "确认成功",
                                success: function() {
                                    //that.getOrderList(index);
                                    that.onShow();
                                }
                            });
                        }
                    }
                });
                break;

            case "联系发货":

                break;

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

    onReachBottom: function () {

    },

    // onShareAppMessage: function (res) {
    //     if (res.from == "button") {
    //         console.log("res.target >>>", res.target);
    //         var id = res.target.id;
    //         var orders = this.data.allList;
    //         var sharePath = "/page/class/pages/joinGroup/joinGroup?goodId=";
    //         orders.forEach(function(order) {
    //             if (order.uid == id) {
    //                 sharePath = sharePath + order.products[0].sku_uid.split(";")[0] + "&groupId=" + order.go_uid;
    //             }
    //         });

    //         var title = "参与团购，和我一起拼团吧！";

    //         return {
    //             title: title,
    //             path: sharePath,
    //             success: function() {
    //                 console.log("share success, url>>", sharePath);
    //             }
    //         }

    //     }
    // },

})
