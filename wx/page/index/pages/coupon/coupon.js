// pages/coupon/coupon.js
var app = getApp();
var WxParse = require('../../../common/wxParse/wxParse.js');
var util = require('../../../../utils/util.js');

Page({

    /**
     * 页面的初始数据
     */
    data: {
        open: false
    },

    /**
     * 生命周期函数--监听页面加载
     */
    onLoad: function (options) {
        var bizId = options.bizId,
            couponId = options.couponId;
        
        this.setData({
            options: options
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });

        // 获取商家数据
        this.getBusinessData(bizId);

        // 获取优惠券数据
        this.getCouponData(couponId);
    },

    onShow: function () {
    
    },

    // 获取商家数据
    getBusinessData: function(businessId) {
        var that = this;
        // 获取商家数据
        app.request({
            url: "_a=shop&_u=biz.ajax_biz_uid",
            data: {
                uid: businessId
            },
            success: function(ret) {
                console.log("business ret >>>", ret);
                var businessData = ret.data;
                if (!businessData.main_img.startsWith("http")) businessData.main_img = app.globalData.prefix_url + businessData.main_img;

                that.setData({
                    businessData: businessData
                });
            }
        });
    },

    // 获取优惠券数据
    getCouponData: function(couponId) {
        var that = this;

        app.request({
            url: "_a=shop&_u=biz.bizcoupon",
            data: {
                coupon_uid: couponId
            },
            success:(ret)=>{
                console.log("coupon data >>>", ret);
                var couponData = ret.data;
                var img = couponData.img;
                couponData.img = img.startsWith("http") ? img : (app.globalData.prefix_url + img);

                if (couponData.duration == 0) {
                    couponData.time = "长期有效";
                } else {
                    var duration = parseInt(couponData.duration),
                        create_time = parseInt(couponData.create_time),
                        startTime = util.formatTime(create_time),
                        endTime = util.formatTime(create_time + duration);

                    couponData.time = startTime.join(".") + " - " + endTime.join(".");
                }
                WxParse.wxParse('article', 'html', couponData.brief, that);

                if (couponData.user_coupon) {
                    that.createQRcode(couponData.user_coupon);
                }

                that.setData({
                    couponData: couponData
                });
            }
        })
    },

    // 领取红包
    openTap: function() {
        var that = this,
            options = that.data.options;

        this.setData({
            open: true
        });
        // var t = setTimeout(function() {
        app.request({
            url: "_a=shop&_u=biz.addbizusercoupon",
            data: {
                biz_uid: options.bizId,
                coupon_uid: options.couponId
            },
            success: (ret)=>{
                console.log("领取优惠券 >>>>>", ret);
                if (ret.data && ret.data != 0) {
                    setTimeout(function() {
                        wx.showToast({
                            title: "领取成功"
                        });
                        that.getCouponData(options.couponId);
                    }, 2000);
                }
            }
        });
        // }, 2000);
    },

    // 获取二维码
    createQRcode: function(userCoupon) {
        var that = this;
        // var businessData = that.data.businessData;

        // if (businessData && businessData.hadv == 1) {
            var encodeUrl = encodeURIComponent("/pages/verification/verification?couponId=" + userCoupon.uid + "&bizId=" + userCoupon.biz_uid + "&userId=" + userCoupon.user_id);
            var qrcodeUrl = app.globalData.server_url + "_u=xiaochengxu.qrcode&type=1&path=" + encodeUrl;
            console.log("qrcodeUrl >>>>", qrcodeUrl);

            that.setData({
                qrcode: qrcodeUrl
            });
        // }       
    },

    previewCode: function() {
        var qrcodeUrl = this.data.qrcode;
        
        wx.previewImage({
            current: qrcodeUrl, // 当前显示图片的http链接
            urls: [qrcodeUrl] // 需要预览的图片http链接列表
        });
    },

    onPullDownRefresh: function () {
    
    },

    onShareAppMessage: function () {
    
    }
})