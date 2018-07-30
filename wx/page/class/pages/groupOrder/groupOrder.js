var app = getApp();
var pay = require('../../../../utils/pay.js');
var util = require('../../../../utils/util.js');
var cleanCart = false;


Page({
    data: {
        mainColor: app.globalData.main_color,
        useCash: false,
        inputCash: 0,
        goUid: -1,
        address: "",
        bu_uid: 0
    },

    onLoad: function (options) {
        var that = this;
        this.setData({
            mainColor: app.globalData.main_color,
            options: options
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });

        if (options.from === "pointGood") {
            this.setData({
                from: "pointGood"
            });
            this.getGoodDetail(options.pointGoodId);
        } else if (options.from === 'bidding') {
            var order = wx.getStorageSync("groupOrder");
            var detail = order.list[0],
                detailData = detail.detailData,
                showPrice = parseFloat(detail.price/100).toFixed(2);
            console.log(detail);

            this.setData({
                detail,
                detailData,
                showPrice,
                from: "bidding",
            });
        } else {
            var id = options.addressId;

            if (options.from == "cart") {
                cleanCart = true;
            }
            that.getLocation();
            var order = wx.getStorageSync("groupOrder");
            var goods = order.list;

            console.log("storage roder >>>", order);

            if (goods[0].goUid == 0) {
                that.setData({
                    goUid: 0
                });
                console.log("开团 >>>");
            } else if (goods[0].goUid) {
                that.setData({
                    goUid: goods[0].goUid
                });
                console.log("拼团 >>>");
            }

            if (goods[0].bu_uid) {
                that.setData({
                    bu_uid: goods[0].bu_uid
                });
            }
            
            that.setData({
                addressId: id,
                totalNum: goods.length,
                from: "cart"
            });

            // 获取账户余额
            app.request({
                url: "_a=su&_u=ajax.point",
                success: function(ret) {
                    console.log("point ret >>>>>", ret);
                    var pointRemain = ret.data.point_remain;
                    var cashRemain = ret.data.cash_remain/100;

                    that.setData({
                        pointRemain: pointRemain,
                        cashRemain: cashRemain,
                        usePoint: pointRemain>0,
                        useCash: cashRemain>0
                    });
                    // 获取全部商品分类
                    that.getAllClass();
                }
            });
        }
    },

    onShow: function() {
        let from = this.data.options.from;
        if (from === "pointGood" || from === 'bidding') {
            let detail = this.data.detail;
            if (detail) {
                if (!detail.virtual_info) this.getUserAddress();
            }
        } else {
            let that = this;
            let order = wx.getStorageSync("groupOrder");
            let goods = order.list;

            for (let i = 0; i < goods.length; i++) {
                let virtual_info = goods[i].detailData.virtual_info;

                if (!virtual_info) {
                    that.getUserAddress();
                }
            }
        }  
    },

    // 获取商品详情函数
    getGoodDetail: function(id, cb) {
        var that = this;

        // 获取商品详情
        app.request({
            url: "_easy=qrposter.ajax.product",
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

        if (!detail.virtual_info) this.getUserAddress();

        var mainImg = detail.main_img.startsWith("http") ? detail.main_img : (app.globalData.prefix_url + detail.main_img);

        that.setData({
            detail: detail,
        });
    },

    // 获取全部商品分类
    getAllClass: function(cb) {
        var that = this;

        app.request({
            url: "_a=shop&_u=ajax.product_cats",
            success: function(res) {
                if (typeof cb === "function") {
                    cb(res);
                } else {
                    that.getAllClassCb(res);
                }
            }
        });        
    },

    getAllClassCb: function(res) {
        var that = this;
        var order = wx.getStorageSync("groupOrder");
        var goods = order.list;

        console.log("storage groupOrder >>>", order);

        var catList = [];
        res.data.forEach(function(ele) {
            ele.list = [];

            goods.forEach(function(good) {
                good.selected = true;
                var img = good.detailData.main_img;
                good.img = img.startsWith("http") ? img : (app.globalData.prefix_url + img);
                if (good.detailData.cat_uid == ele.uid) {
                    good.catTitle = ele.title;
                    ele.list.push(good);
                }
            });

            if (ele.list.length > 0) {
                catList.push(ele);
            }
        });

         // 未分类商品
        var othersCat = {
            uid: "0",
            title: "其它",
            list: []
        };

        goods.forEach(function(good) {
            if (good.detailData.cat_uid == 0) {
                good.catTitle = othersCat.title;
                othersCat.list.push(good);
            }
        });

        if (othersCat.list.length > 0) {
            catList.push(othersCat);
        }

        // that.getPoint();
        that.setData({
            catList: catList
        });

        that.calculate(that.data.catList);
    },

    getUserAddress: function() {
        var that = this;
        // 获取收货地址列表
        app.request({
            url: "_a=shop&_u=ajax.get_address",
            success: function(ret) {
                var addressList = ret.data;

                console.log("addressList >>>>>", addressList);
                // 没有收货地址
                if (addressList.length === 0) {
                    wx.showModal({
                        content: "请填写收货地址",
                        cancelText: "返回",
                        confirmText: "去填写",
                        success: function(res) {
                            if (res.confirm) {
                                wx.navigateTo({
                                    url: "../editAddress/editAddress"
                                });
                            } else if (res.cancel) {
                                wx.navigateBack();
                            }
                        }
                    });

                } else {
                    var addressId = that.data.addressId;
                    var address = addressList[0];

                    addressList.forEach(function(ele) {
                        ele.uid == addressId && (address = ele);
                    });

                    that.setData({
                        address: address
                    });
                    if (that.data.catList) that.calculate();
                }
            }
        });
    },

    // 获取当前位置
    getLocation: function() {
        wx.getLocation({
            success: (ret)=>{
                app.request({
                    url: "_a=shop&_u=ajax.preview_order_send",
                    data: {
                        lat: ret.latitude,
                        lng: ret.longitude
                    },
                    success:(res)=>{
                        if (res.data == 0) {
                            wx.showModal({
                                title: "温馨提示",
                                content: "您现在的位置在商家的配送距离之外，是否继续？",
                                confirmText: "继续下单",
                                success:(modalRes)=>{
                                    if (modalRes.cancel) {
                                        wx.navigateBack()
                                    }
                                }
                            });
                        }
                    }
                });
            }
        })
    },

    // 计算选择商品价格
    calculate: function(catList) {
        var that = this;
        var total = 0;

        var list = !!catList ? catList : that.data.catList;

        var orderData = [];
        // 收货地址
        var address = that.data.address;
        // 使用余额
        var inputCash = that.data.inputCash*100;

        // 计算总价格 并判断是否全选
        list.forEach(function(cat) {
            cat.account = 0;
            cat.list.forEach(function(good) {
                cat.account += good.price * good.selectedNum;
                total += good.price * good.selectedNum;

                var orderItem = {};
                orderItem.sku_uid = good.detailData.uid + ";" + good.specialKey;
                orderItem.quantity = good.selectedNum;

                orderData.push(orderItem);
            });
            cat.account = parseFloat(cat.account).toFixed(2);
        });

        address && console.log("address_uid >>>", address.uid);
        inputCash && console.log("inputCash >>>", inputCash);

        // 接口计算费用
        app.request({
            url: '_a=shop&_u=ajax.preview_order_fee',
            data: {
                products: orderData,
                address_uid: address.uid,
                cash_fee: inputCash,
                bu_uid: that.data.bu_uid,
                go_uid: that.data.goUid
            },
            success: function(ret) {
                console.log("calculate request >>>>>", ret);
                if (typeof cb == 'function') {
                    cb(ret);
                } else if (ret.errno == 607) {
                    var deliveryPrice = parseFloat(ret.data.delivery_fee/100).toFixed(2);

                    that.setData({
                        showPrice: 0.00,
                        deliveryPrice: deliveryPrice
                    });
                } else {
                    var paidPrice = parseFloat(ret.data.paid_fee / 100).toFixed(2);
                    var deliveryPrice = parseFloat(ret.data.delivery_fee/100).toFixed(2);

                    deliveryPrice = deliveryPrice == 0 ? '免运费' : ('¥ ' + deliveryPrice);

                    that.setData({
                        showPrice: paidPrice,
                        deliveryPrice: deliveryPrice
                    });
                }
            }
        });

        that.setData({
            catList: list,
            totalPrice: total,
        });
    },

    navToAddress: function() {
        var that = this;
        var addressUrl = "../address/address?order=true&groupOrder=1";

        wx.navigateTo({
            url: addressUrl
        });
    },

    // 选择微信收货地址
    chooseWechatAddress: function() {
        // 选择微信内部收货地址
        wx.chooseAddress({
            success: function(addressRet) {
                console.log("choose addressRet >>>", addressRet);

                // 将用户选择的微信收货地址新增到用户信息中
                app.request({
                    url: "_a=shop&_u=ajax.add_address",
                    data: {
                        name: addressRet.userName,
                        phone: addressRet.telNumber,
                        province: addressRet.provinceName,
                        city: addressRet.cityName,
                        town: addressRet.countyName,
                        address: addressRet.detailInfo,
                        uid: addressRet.addressId,
                        is_default: 1
                    },
                    success: function(add_address_ret) {
                        console.log("return >>>>>". add_address_ret);
                        if (add_address_ret.data !== '0') {
                            wx.showToast({
                                title: "添加成功",
                                success: function() {
                                    wx.navigateBack();
                                }
                            });
                        }
                    }
                });
            }
        });
    },

    // 填写留言
    inputMsg: function(e) {
        var msg = e.detail.value;
        this.setData({
            message: msg
        });
    },

    // 输入余额
    inputCash: function(e) {
        var inputCash = e.detail.value;
        var totalPrice = this.data.totalPrice;

        inputCash = inputCash ? inputCash : 0;

        this.setData({
            inputCash: inputCash,
        });
        this.calculate();
    },

    // 提交订单动作
    postOrder: function(e) {
        var from = this.data.from,
            that = this,
            address = that.data.address;

        if (from === "pointGood") {
            var goodId = that.data.detail.uid;

            app.request({
                    url: "_easy=qrposter.ajax.make_point_order",
                    data: {
                        product_uid: goodId,
                        address: address
                    },
                    success: function(ret) {
                        console.log("make order >>>", ret);
                        if (ret.errstr === "ERROR_OUT_OF_LIMIT") {
                            wx.showModal({
                                title: "下单失败",
                                content: '已超出该商品的兑换数量',
                                showCancel: false,
                                success: function(res) {
                                    if (res.confirm) {
                                        wx.navigateBack();
                                    }
                                }
                            });
                        } else if (ret.errstr === "ERROR_INVALID_REQUEST_PARAM") {
                            wx.showModal({
                                title: "下单失败",
                                content: '账户积分不足',
                                showCancel: false,
                                success: function(res) {
                                    if (res.confirm) {
                                        wx.navigateBack();
                                    }
                                }
                            });
                        } else if (ret.errno != 0) {
                            wx.showModal({
                                title: "下单失败",
                                content: ret.errstr,
                                showCancel: false,
                                success: function(res) {
                                    if (res.confirm) {
                                        wx.navigateBack();
                                    }
                                }
                            });
                        } else {
                            wx.showToast({
                                title: "下单成功"
                            });
                            wx.redirectTo({
                                url: "../../../my/pages/orderDetail/orderDetail?from=pointGood&uid=" + ret.data 
                            });
                        }
                    }
                });

        } else if (from === 'bidding') {
            let detailData = that.data.detailData;
                // uid = detailData.uid,
            // console.log(detailData);
            app.request({
                url: '_a=auction&_u=ajax.make_a_auction_order',
                data: {
                    it_uid: detailData.uid,
                    address_uid: address.uid,
                    info: {'remark': message, formId: formId},
                },
                success: function(ret) {
                    console.log('make auction order >>', ret);
                    if (ret.errno === 607) {
                        wx.showToast({
                            title: "下单成功"
                        });
                        wx.redirectTo({
                            url: "../../../my/pages/orderDetail/orderDetail?uid=" + ret.data
                        });
                    } else if (ret.data != 0) {
                        wx.showToast({
                            title: "下单成功",
                            success: function() {
                                that.do_pay(ret.data);
                            }
                        });
                    } else {
                        wx.showModal({
                            title: "下单失败",
                            content: '清检查您的网络',
                            showCancel: false
                        });
                    }
                }
            });
        } else {
            var orderData = [],
                catList = that.data.catList,
                address = that.data.address,
                message = that.data.message,
                formId = e.detail.formId;

            // 使用余额
            var cashRemain = parseFloat(that.data.cashRemain);
            var inputCash = parseFloat(that.data.inputCash);
            console.log("cashRemain", cashRemain);
            console.log("inputCash", inputCash);

            
            if (inputCash > cashRemain) {
                wx.showModal({
                    content: "填写余额超过账户余额，请重新填写",
                    showCancel: false
                });
            } else {
                catList.forEach(function(cat) {
                    cat.account = 0;
                    cat.list.forEach(function(good) {
                        var orderItem = {};
                        orderItem.sku_uid = good.detailData.uid + ";" + good.specialKey;
                        orderItem.quantity = good.selectedNum;

                        orderData.push(orderItem);
                    });
                });

                console.log("post products >>>>>", orderData);
                console.log("go uid >>>>>", that.data.goUid);
                console.log("bu uid >>>>>", that.data.bu_uid);

                inputCash = inputCash*100;

                app.request({
                    url: "_a=shop&_u=ajax.make_order",
                    data: {
                        products: orderData,
                        address_uid: address.uid,
                        cash_fee: inputCash,
                        info: {'remark': message, formId: formId},
                        go_uid: that.data.goUid,
                        bu_uid: that.data.bu_uid
                    },
                    success: function(ret) {
                        console.log("make order >>>", ret);
                        if (ret.errno === 607) {
                            wx.showToast({
                                title: "下单成功"
                            });
                            wx.redirectTo({
                                url: "../../../my/pages/orderDetail/orderDetail?uid=" + ret.data
                            });
                        } else if (ret.data != 0) {
                            wx.showToast({
                                title: "下单成功",
                                success: function() {
                                    that.cleanCartGoods();
                                    that.do_pay(ret.data);
                                }
                            });
                        } else {
                            wx.showModal({
                                title: "下单失败",
                                content: '清检查您的网络',
                                showCancel: false
                            });
                        }
                    }
                });
            }
        }
    },

    // 清理购物车已下单商品
    cleanCartGoods: function() {
        if (cleanCart) {
            var cart = wx.getStorageSync("cart");
            var cartGoods = cart.list;
            var orderGoods = wx.getStorageSync("order").list;
            console.log("cartGoods >>>", cartGoods);
            console.log("orderGoods >>>", orderGoods);

            orderGoods.forEach(function(orderGood) {
                for (var i = 0; i < cartGoods.length; i++) {
                    var cartGood = cartGoods[i];
                    if (orderGood.specialKey === cartGood.specialKey && orderGood.selectedNum === cartGood.selectedNum && orderGood.detailData.uid === cartGood.detailData.uid) {
                        console.log(" === >>>", orderGood);
                        cartGoods.splice(i, 1);
                        break;
                    }
                }
            });
            console.log("cleanCart >>>", cartGoods);
            wx.setStorage({
                key: "cart",
                data: cart
            });
        }
    },

    //支付
    do_pay: function(uid) {
        return pay.do_pay('b'+uid, this, function(){
            var orderUrl = "../../../my/pages/orderDetail/orderDetail?uid=" + uid;
            wx.redirectTo({url: orderUrl});
        });  
    },

    onShareAppMessage: function () {

    }
})