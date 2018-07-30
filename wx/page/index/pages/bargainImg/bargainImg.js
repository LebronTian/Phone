// page/index/pages/bargainImg/bargainImg.js
var app = getApp();


Page({

    data: {
    
    },

    onLoad: function (options) {
        var imgUrl = app.globalData.server_url + "_a=bargain&_u=ajax.card_image&uid=" + options.bargainId + "&su_uid=" + app.globalData.su_uid;
        this.setData({
            imgUrl: imgUrl
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
        wx.showToast({
            title: '加载中',
            icon: 'loading'
        });
    },

    onShow: function () {
    
    },

    // 图片加载完成
    imageLoaded: function(event) {
        console.log("image loaded");
        // wx.hideLoading();
        wx.hideToast();
    },

    // 长按保存名片
    saveNameCard: function() {
        console.log("long tap action >>>");
        var that = this;

        wx.downloadFile({
            url: that.data.imgUrl,
            success: function(res) {                
                wx.saveImageToPhotosAlbum({
                    filePath: res.tempFilePath,
                    success: function(ret) {
                        console.log("errMsg >>>", ret.errMsg);
                        wx.showToast({
                            title: '保存成功'
                        });
                    },
                    fail: function(ret) {
                        console.log("save fail >>>", ret);
                        wx.showToast({
                            title: '保存失败，请授权'
                        });
                    }
                });
            }
        });
    },

    onShareAppMessage: function () {
    
    }
})