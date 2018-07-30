var app = getApp();

Page({

    data: {

    },

    onLoad: function (options) {
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
        this.setData({
            mainColor: app.globalData.main_color,
            userAvatar: app.globalData.userInfo.avatarUrl,
            userName: app.globalData.userInfo.nickName
        });

        // 扫码分销功能
        if (options.parentId) {
            app.request({
                url: "_a=su&_u=ajax.update_su",
                data: {
                    from_su_uid: options.parentId
                },
                success: function(ret) {
                    console.log("add fans ret", ret);
                }
            })
        }

        this.createQRcode();
    },


    // 创建二维码
    createQRcode: function() {
        var that = this;
        
        var encodeUrl = encodeURIComponent("page/index/index?parentId=" + app.globalData.su_uid);
        var qrcodeSrc = app.globalData.server_url + "_u=xiaochengxu.qrcode&path=" + encodeUrl;
        console.log("qrcodeSrc >>>>", qrcodeSrc);

        that.setData({
            qrcode: qrcodeSrc
        });
    },

    previewImage: function() {
        var qrcode = this.data.qrcode;

        wx.previewImage({
            urls: [qrcode]
        });
    },

    /**
    * 用户点击右上角分享
    */
    onShareAppMessage: function () {
        var shareUrl = "/page/index/index?parentId=" + app.globalData.su_uid;
        var shareInfo = {
            title: "向你推荐一个商城",
            path: shareUrl
        };
        console.log("shareUrl >>>", shareUrl);
        return shareInfo;
    }
})