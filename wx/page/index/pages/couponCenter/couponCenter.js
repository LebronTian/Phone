var app = getApp();

Page({

    data: {
        mainColor: app.globalData.main_color
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

        // 获取所有优惠券列表
        app.request({
            url: "_a=shop&_u=ajax.get_couponlist",
            success: function(ret) {
                console.log("coupon list >>>>", ret);
                var couponList = ret.data.list;

                couponList.forEach(function(ele) {
                    if (!ele.img.startsWith("http")) ele.img = app.globalData.prefix_url + ele.img;
                    ele.price = parseFloat(ele.rule.discount / 100);
                });

                that.setData({
                    couponList: couponList
                });
            }
        });
    },

    // 点击领取优惠券
    getCouponTap: function(e) {
        var that = this;
        var couponId = e.currentTarget.id;

        app.request({
            url: "_a=shop&_u=ajax.addusercoupon",
            data: {
                coupon_uid: couponId
            },
            success: function(ret) {
                console.log("get coupon ret >>>", ret);
                if (ret.data && ret.data != 0) {
                    wx.showToast({
                        title: "领取成功"
                    });
                } else {
                    if (ret.errstr == "ERROR_OUT_OF_LIMIT") {
                        wx.showModal({
                            content: "领取失败，已超出领取限制",
                            showCancel: false
                        });
                    } else if (ret.errstr == "ERROR_OBJ_NOT_EXIST") {
                        wx.showModal({
                            content: "领取失败，已超出领取限制",
                            showCancel: false
                        });
                    } else {
                        wx.showModal({
                            content: "领取失败，请检查您的网络",
                            showCancel: false
                        });
                    }
                }
            }
        });
    },

    /**
     * 生命周期函数--监听页面初次渲染完成
     */
    onReady: function () {
    
    },

    /**
     * 生命周期函数--监听页面显示
     */
    onShow: function () {
    
    },

    /**
     * 生命周期函数--监听页面隐藏
     */
    onHide: function () {
    
    },

    /**
     * 生命周期函数--监听页面卸载
     */
    onUnload: function () {
    
    },

    /**
     * 页面相关事件处理函数--监听用户下拉动作
     */
    onPullDownRefresh: function () {
    
    },

    /**
     * 页面上拉触底事件的处理函数
     */
    onReachBottom: function () {
    
    },

    /**
     * 用户点击右上角分享
     */
    onShareAppMessage: function () {
    
    }
})