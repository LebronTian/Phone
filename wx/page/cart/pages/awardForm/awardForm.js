// page/cart/pages/awardForm/awardForm.js
var app = getApp();


Page({

    /**
     * 页面的初始数据
     */
    data: {
        postData: {}
    },

    onLoad: function (options) {
        this.getAwardInfo(options.awardId);
        
        this.setData({
            awardId: options.awardId,
            mainColor: app.globalData.main_color
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: this.data.mainColor,
        });
    },

    onShow: function () {
    
    },

    // 获取抽奖内容
    getAwardInfo: function(awardId) {
        var that = this;

        app.request({
            url: "_a=reward&_u=ajax.get_reward",
            data: {
                r_uid: awardId
            },
            success: (ret)=>{
                console.log("getAwardInfo ret >>>>>", ret);
                // that.setAwardList(ret.data.items.list);
                that.setData({
                    winRule: ret.data.win_rule
                });
            }
        });
    },

    // 输入信息
    userInput: function(e) {

        var value = e.detail.value,
            key = e.currentTarget.dataset.id,
            postData = this.data.postData;

        postData[key] = value;

        this.setData({
            postData: postData
        });
        console.log("postData >>>", postData);
    },


    // 提交信息
    postForm: function() {
        var that = this,
            winRule = that.data.winRule,
            awardId = that.data.awardId,
            infoData = [],
            postData = that.data.postData;

        for (var i = 0; i < winRule.data.length; i++) {
            if (!postData[winRule.data[i]]) {
                wx.showModal({
                    title: "提交失败",
                    showCancel: false,
                    content: "请填写完整再提交"
                });
                return;
            } else {
                infoData.push(postData[winRule.data[i]]);
            }
        }

        app.request({
            url: "_a=reward&_u=ajax.set_win_info",
            data: {
                uid: awardId,
                data: infoData
            },
            success: (ret)=>{
                console.log("post ret >>>>>", ret);
                if (ret.data && ret.data != 0) {
                    wx.showToast({
                        title: "提交成功",
                        success: (ret)=>{
                            wx.navigateBack();
                        }
                    });
                }
            }
        });
    },

    onShareAppMessage: function () {
    
    }
})