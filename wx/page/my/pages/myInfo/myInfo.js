var app = getApp();
var postData = {};

Page({

    data: {
        mainColor: app.globalData.main_color,
        needBank: false,

        bankListIdx: 0,
        bankList: []
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

        // 获取提现方式
        app.request({
            url: "_a=pay&_u=index.get_wd_cfg",
            success: function(ret) {
                console.log("withdraw rule >>>", ret);
                if (ret.data.wd_type == 5) {
                    that.getBankInfo();
                }
            }
        });

        // 获取用户资料
        app.request({
            url: "_a=su&_u=ajax.profile",
            success: function(ret) {
                console.log("user profile >>>", ret);
                var extraInfo = ret.data.profile.extra_info;
                if (extraInfo) {
                    postData = extraInfo;

                    that.setData({
                        extraInfo: extraInfo
                    });
                }
            }
        });
    },

    onShow: function () {

    },

    // 获取银行信息
    getBankInfo: function() {
        var that = this;

        app.request({
            url: "_easy=pay.index.get_banks",
            success: function(ret) {
                console.log("bank info >>>", ret);
                let bankList = ret.data;
                if (bankList.length) {
                    that.setData({
                        bankList: bankList,
                        needBank: true
                    });
                }
            }
        });

    },

    // 选择银行
    bindPickerChange: function(e) {
        console.log('picker event ', e.detail.value);
        this.setData({
            bankListIdx: e.detail.value
        });
    },

    // 提交信息
    postInfo: function() {
        var that = this,
            localData = this.data;

        postData.bankName = localData.needBank ? localData.bankList[localData.bankListIdx] : postData.bankName;

        console.log("post data >>>", postData);

        if (!postData.realName || !postData.bankName || !postData.bankId) {
            wx.showModal({
                title: "信息填写不完全",
                showCancel: false
            });
        } else {
            app.request({
                url: "_a=su&_u=ajax.update_su_profile",
                data: {
                  extra_info: postData
                },
                success: function(ret) {
                  console.log("post ret >>>", ret);
                  if (ret.data) {
                    wx.showToast({
                      title: "上传成功！",
                      success: function() {
                        // wx.navigateBack();
                        that.onLoad();
                      }
                    });
                  } else {
                    wx.showModal({
                      title: "上传失败，请检查您的网络",
                      showCancel: false
                    });
                  }
                }
            });
        }
    },

    inputInfo: function(e) {
        var id = e.currentTarget.id;
        var content = e.detail.value;
        postData[id] = content;
    },

    onPullDownRefresh: function () {

    },

    onReachBottom: function () {

    },

    onShareAppMessage: function () {

    }
})