var app = getApp();
var phone = "";
var code = "";

Page({

    data: {
        mainColor: app.globalData.main_color,
        showNum: false,
        countDownNum: 60
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

        // 获取用户资料
        app.request({
            url: "_a=su&_u=ajax.profile",
            success: function(ret) {
                console.log("user profile >>>", ret);
                phone = ret.data.profile.phone;
                if (!!phone) {
                    that.setData({
                        phone: phone
                    });
                }
            }
        });
    },

    // 输入手机号
    inputPhone: function(e) {
        phone = e.detail.value;
    },

    // 获取验证码
    getCode: function() {
        var that = this;

        if(!(/^1[34578]\d{9}$/.test(phone))){ 
          wx.showModal({
            content: "您输入的手机号码有误，请重填",
            showCancel: false
          });
        } else {
          that.setData({
            showNum: true
          });

          that.countDown();

          app.request({
            url: "_a=su&_u=ajax.mobilecode",
            data: {
              phone: phone
            },
            success: function(ret) {
              console.log("get code ret >>>", ret);
              if (ret.data) {
                wx.showToast({
                  title: "发送成功，请稍候"
                });
              }
            }
          })
        }
    },

    // 输入验证码
    inputCode: function(e) {
        code = e.detail.value;
    },

    // 绑定手机号
    bindPhone: function() {
        app.request({
          url: "_a=su&_u=ajax.setphone",
          data: {
            phone: phone,
            code: code
          },
          success: function(ret) {
            console.log("bindPhone >>>", ret);
            if (ret.data) {
              wx.showToast({
                title: "绑定成功！",
                success: function() {
                  wx.navigateBack();
                }
              });
            }
          }
        });
    },

    // 倒计时
    countDown: function() {
        var that = this;
        var countDownNum = this.data.countDownNum;

        var count = setInterval(function() {

            if (countDownNum <= 0) {
                clearInterval(count);
                that.setData({
                    showNum: false,
                    countDownNum: 60
                });
            }
            countDownNum--;
            
            that.setData({
                countDownNum: countDownNum
            });
        }, 1000);

    },

    // 微信获取手机号
    getPhoneNumber: function(e) {
        var that = this;
        console.log(e.detail.errMsg) 
        console.log(e.detail.iv) 
        console.log(e.detail.encryptedData)

        app.request({
            url: "_u=xiaochengxu.decrypt",
            data: {
                iv: e.detail.iv,
                encryptedData: e.detail.encryptedData
            },
            success: function(ret) {
                console.log("decode ret >>>>>", ret);
                phone = ret.data.phoneNumber;
                that.setData({
                    phone: phone
                })
            }
        });
    },

    onShow: function () {

    },
})