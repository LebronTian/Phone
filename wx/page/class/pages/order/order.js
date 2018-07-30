var app = getApp();
var pay = require('../../../../utils/pay.js');
var util = require('../../../../utils/util.js');
var cleanCart = false;


Page({
    data: {
        mainColor: app.globalData.main_color,

        usePoint: false,
        useCash: false,
        showPoint: 0,
        inputCash: 0,

        showCoupon: false,
        address: "",
        couponId: 0
    },

    onLoad: function (options) {
        var that = this;
        this.setData({
            mainColor: app.globalData.main_color
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
        
        var id = options.addressId;

        if (options.from == "cart") {
            cleanCart = true;
        }

        var order = wx.getStorageSync("order");
        var goods = order.list;

        console.log("storage roder >>>", order);
        
        that.setData({
            addressId: id,
            totalNum: goods.length
        });

        // 获取优惠券列表
        that.getCoupon();
        // 获取位置
        that.getLocation();
        // 获取全部商品分类
        that.getAllClass();

        // 获取账户余额
        app.request({
            url: "_a=su&_u=ajax.point",
            success: function(ret) {
                console.log("remain point ret >>>>>", ret);
                var pointRemain = ret.data.point_remain;
                var cashRemain = ret.data.cash_remain/100;

                that.setData({
                    pointRemain: pointRemain,
                    cashRemain: cashRemain,
                    usePoint: pointRemain>0,
                    useCash: cashRemain>0
                });
            }
        });
    },

    onShow: function() {
        var that = this;
        var order = wx.getStorageSync("order");
        var goods = order.list;

        // 判断订单商品是否全是虚拟商品
        for (var i = 0; i < goods.length; i++) {
            var virtual_info = goods[i].detailData.virtual_info;
            if (!virtual_info) {
                that.getUserAddress();
            }
        }
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
            },
            fail: function(res) {
                console.log("get all class fail res >>>>", res);
            }
        });        
    },

    getAllClassCb: function(res) {
        var that = this;
        var order = wx.getStorageSync("order");
        var goods = order.list;

        console.log("storage roder >>>", order);

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

        that.getPoint();
        that.setData({
            catList: catList
        });

        // if (that.data.address) that.calculate(that.data.catList, {});
        that.calculate(that.data.catList, {});
        // that.getUserAddress();
        // console.log("getAllClassCb asyncNum >>>", asyncNum);
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
                    // that.setData({
                    //     address: null
                    // });
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
                    // that.getAllClass();
                    // asyncNum++;
                    if (that.data.catList) that.calculate(null, {address: address});
                    // console.log("get_address asyncNum >>>", asyncNum);
                }
            }
        });
    },

    // 获取当前位置
    getLocation: function() {
        wx.getLocation({
            success: (ret)=>{
                console.log("location >>>>>", ret);
                app.request({
                    url: "_a=shop&_u=ajax.preview_order_send",
                    data: {
                        lat: ret.latitude,
                        lng: ret.longitude
                    },
                    success:(res)=>{
                        console.log("distance >>>>>", res);
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

    // 获取所有优惠券
    getCoupon: function(cb) {
        var that = this;

        app.request({
            url: "_a=shop&_u=ajax.get_coupon",
            success: function(ret) {
                console.log("coupon list >>>>", ret);
                if (typeof cb === "function") {
                    cb(ret);
                } else {
                    var couponList = ret.data.list;
                    couponList.forEach(function(ele) {
                        var image = ele.info.img;
                        ele.image = image.startsWith("http") ? image : (app.globalData.prefix_url + image);

                        if (ele.expire_time == 0) {
                            ele.endTime = "永久有效";
                        } else {
                            var endTime = util.formatTime(ele.expire_time);
                            ele.endTime = endTime[0] + "." + endTime[1] + "." + endTime[2] + " " + endTime[3];                        
                        }
                        ele.price = ele.info.rule.discount / 100;
                    });

                    that.setData({
                        couponList: couponList
                    });
                }
            }
        });
    },

    // 计算选择商品价格
    calculate: function(catList, postData) {
        var that = this;
        var total = 0;
        console.log("calculate postData >>>", postData);

        var list = !!catList ? catList : that.data.catList;

        var orderData = [];
        // 收货地址
        var address = !!postData.address ? postData.address : that.data.address;
        // 使用余额
        // var cashRemain = that.data.cashRemain;
        var cash = !!postData.inputCash ? postData.inputCash : that.data.inputCash;
        var inputCash = Math.ceil(cash*100);
        // console.log
        // 使用积分
        // var showPoint = that.data.showPoint;
        var inputPoint = !!postData.inputPoint ? postData.inputPoint : that.data.inputPoint;
        // 使用优惠券
        var couponId = !!postData.couponId ? postData.couponId : that.data.couponId;

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
        inputPoint && console.log("point >>>", inputPoint);
        couponId && console.log("couponId >>>", couponId);
        inputCash && console.log("inputCash >>>", inputCash);
        console.log("products >>>>>", orderData);

        // 接口计算费用
        app.request({
            url: '_a=shop&_u=ajax.preview_order_fee',
            data: {
                products: orderData,
                address_uid: address.uid,
                point: inputPoint,
                coupon_uid: couponId,
                cash_fee: inputCash,
            },
            success: function(ret) {
                console.log("calculate request >>>>>", ret);
                if (ret.errno == 0) {
                    if (typeof cb == 'function') {
                        cb(ret);
                    } else {
                        var paidPrice = parseFloat(ret.data.paid_fee / 100).toFixed(2);
                        var deliveryPrice = parseFloat(ret.data.delivery_fee/100).toFixed(2);

                        deliveryPrice = deliveryPrice == 0 ? '免运费' : ('¥ ' + deliveryPrice);

                        that.setData({
                            showPrice: paidPrice,
                            deliveryPrice: deliveryPrice
                        });
                    }
                } else if (ret.errno == 607) {
                    var deliveryPrice = parseFloat(ret.data.delivery_fee/100).toFixed(2);

                    that.setData({
                        showPrice: 0.00,
                        deliveryPrice: deliveryPrice
                    });
                }
            }
        });

        that.setData({
            catList: list,
            totalPrice: total,
            // showPrice: total
        });
    },

    // 获取积分
    getPoint: function() {
        var that = this;
        var totalPrice = that.data.totalPrice;

        // 获取积分兑换比例信息
        app.request({
            url: "_a=shop&_u=ajax.shop",
            success: function(ret) {
                console.log("shop point return >>>", ret);
                var pointLimit = ret.data.point;

                if (pointLimit.discount_limit/100 > totalPrice) {
                    that.setData({
                        usePoint: false
                    });
                } else {
                    var pointRemain = that.data.pointRemain;
                    var limitPrice = parseFloat(totalPrice * pointLimit.point_limit / 100).toFixed(2);

                    var maxPoint = limitPrice * pointLimit.discount;
                    var showPoint = pointRemain > maxPoint ? maxPoint : pointRemain;
                    console.log("get showPoint >>>>>>", showPoint);

                    if (showPoint == 0) {
                        that.setData({
                            usePoint: false
                        });
                    } else {
                        that.setData({
                            showPoint: showPoint,
                            // discount: pointLimit.discount
                        });
                    }
                }
            }
        });
    },

    navToAddress: function() {
        var that = this;
        var addressUrl = "../address/address?order=true";

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

    // 填写使用的积分
    inputPoint: function(e) {
        var inputPoint = e.detail.value;
        var totalPrice = this.data.totalPrice;

        inputPoint = inputPoint ? inputPoint : 0;
        this.setData({
            inputPoint: inputPoint,
        });
        this.calculate(null, {inputPoint: inputPoint});
    },

    // 输入余额
    inputCash: function(e) {
        var inputCash = e.detail.value;
        var totalPrice = this.data.totalPrice;

        inputCash = inputCash ? inputCash : 0;

        this.setData({
            inputCash: inputCash,
        });
        console.log("inputCash >>>>>>", inputCash);
        this.calculate(null, {inputCash: inputCash});
    },

    // 打开优惠券列表
    bindShowCoupon: function() {
        var that = this;
        var couponList = that.data.couponList;

        if (couponList.length == 0) {
            wx.showModal({
                content: "没有可使用的优惠券",
                showCancel: false
            });
        } else {
            that.setData({
                showCoupon: true
            });
        }
    },

    // 选择使用优惠券
    selectCoupon: function(e) {
        var that = this;
        var couponId = e.currentTarget.id;
        var couponList = this.data.couponList;
        var totalPrice = this.data.totalPrice;

        couponList.forEach(function(item) {
            if (item.uid == couponId) {
                var minPrice = parseFloat(item.info.rule.min_price / 100).toFixed(2);
                
                // 满足最低使用价格要求                
                if (totalPrice >= minPrice) {
                    that.setData({
                        selectedCoupon: item,
                        showCoupon: false,
                        couponId: couponId,
                    });

                    that.calculate(null, {couponId: couponId});
                // 不满足最低价格要求
                } else {
                    wx.showModal({
                        content: "未达到最低消费金额，不能使用该优惠券",
                        showCancel: false
                    });
                }
            }
        });
    },

    // 不选择优惠券
    cancelSelect: function() {
        this.setData({
            showCoupon: false,
            couponId: 0,
            selectedCoupon: null,
        });
        this.calculate(null, {});
    },

    // 提交订单动作
    postOrder: function(e) {
        console.log("postOrder e >>>", e);
        var that = this,
            formId = e.detail.formId,
            orderData = [],
            catList = that.data.catList,
            address = that.data.address,
            message = that.data.message;

        // 使用余额
        var cashRemain = parseFloat(that.data.cashRemain);
        var inputCash = parseFloat(that.data.inputCash);
        console.log("cashRemain", cashRemain);
        console.log("inputCash", inputCash);

        // 使用积分
        var showPoint = parseFloat(that.data.showPoint);
        var inputPoint = parseFloat(that.data.inputPoint);
        console.log("showPoint", showPoint);
        console.log("inputPoint", inputPoint);

        // 使用优惠券
        var couponId = that.data.couponId;

        if (inputPoint > showPoint) {
            wx.showModal({
                content: "积分超过可使用范围，请重新填写",
                showCancel: false
            });
        } else {
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

                inputCash = inputCash*100;

                app.request({
                    url: "_a=shop&_u=ajax.make_order",
                    data: {
                        products: orderData,
                        address_uid: address.uid,
                        point: inputPoint,
                        coupon_uid: couponId,
                        cash_fee: inputCash,
                        info: {'remark': message, formId: formId}
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
                            app.request({
                                url: "_a=su&_u=ajax.add_form_id",
                                data: {form_id: formId},
                                success: (ret)=>{}
                            });
                            wx.showToast({
                                title: "下单成功",
                                success: function() {
                                    that.cleanCartGoods();
                                    that.do_pay(ret.data);
                                }
                            });
                        } else {
                            wx.showModal({
                                title: '下单失败',
                                content: ret.errstr,
                                showCancel: false,
                                confirmText: '返回',
                                success: function(res) {
                                    if (res.confirm) {
                                        wx.navigateBack();
                                    }
                                }
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

    },

    onReachBottom: function () {

    },
})

// [{sku_uid:xxx, quantity:1}, {}]