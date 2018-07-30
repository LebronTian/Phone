// page/cart/pages/exerSigner/exerSigner.js
var app = getApp();


Page({

    data: {

    },

    onLoad: function (options) {
        var id = options.signId;
        this.getSignerData(id);

        this.setData({
            id: id,
            mainColor: app.globalData.main_color,
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
    },

    onShow: function () {

    },

    getSignerData: function(id) {
        var that = this;

        app.request({
            url: "_a=form&_u=ajax.record",
            data: {
                uid: id
            },
            success: (ret)=>{
                console.log("get signer data ret >>>>", ret);
            }
        });
    },

    // 操作报名状态
    handleSign: function() {
        wx.showActionSheet({
            itemList: ['A', 'B', 'C'],
            success: function(res) {
                console.log(res.tapIndex)
            },
            fail: function(res) {
                console.log(res.errMsg)
            }
        })
    },

    onPullDownRefresh: function () {

    },

    onShareAppMessage: function () {

    }
})