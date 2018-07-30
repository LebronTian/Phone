var app = getApp();

Page({

    data: {
        mainColor: app.globalData.main_color,
        inputData: {}    
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

        app.request({
            url: "_a=vipcard&_u=ajax.is_vip",
            success: function(ret) {
                console.log("vip info ret", ret);
                if (ret.data.su) {
                    // 审核通过
                    if (ret.data.su.status == 0) {
                        var img = ret.data.su.card_url;
                        var imgUrl = img.startsWith("http") ? img : (app.globalData.prefix_url + img);

                        var infoList = ret.data.su.connent;
                        that.setData({
                            imgUrl: imgUrl,
                            infoList: infoList
                        });
                        console.log("imgUrl >>>", imgUrl);
                    } else if (ret.data.su.status == 1) {
                        wx.showModal({
                            title: "您的信息正在审核中，请耐心等待",
                            showCancel: false,
                            success: function(res) {
                                if (res.confirm) {
                                    wx.navigateBack();
                                }
                            }
                        });
                    } else {
                        wx.showModal({
                            title: "您的信息审核未通过，是否重新申请？",
                            confirmText: "重新申请",
                            success: function(res) {
                                if (res.cancel) {
                                    wx.navigateBack();                                    
                                }
                            }
                        });
                    }
                }
                var formList = [];
                var form = ret.data.set.connent;

                for (var key in form) {
                    form[key].key = key;
                    formList.push(form[key])
                }

                console.log("formList >>>", formList);

                that.setData({
                    formList: formList,
                    form: form
                });
            } 
        })
    },

    // 用户输入操作
    userInput: function(e) {
        var id = parseInt(e.currentTarget.id);
        var value = e.detail.value;
        var formList = this.data.formList;
        var inputData = this.data.inputData;

        var key = formList[id].key;
        var group = formList[id].group;

        if (!inputData[group]) {
            inputData[group] = {};
        }
        inputData[group][key] = value;
    },

    // 提交申请表单
    submit: function() {
        var that = this;
        var formList = that.data.formList;
        var inputData = that.data.inputData;
        var canSubmit = true;

        formList.forEach(function(ele) {
            console.log("ele >>>", ele);
            if (!inputData[ele.group] || !inputData[ele.group][ele.key]) {
                canSubmit = false;
                wx.showModal({
                    title: "信息填写不完整",
                    showCancel: false
                });
            }
        });

        if (canSubmit) {
            console.log("inputData >>>", inputData);
            var inputData = JSON.stringify(inputData);
            app.request({
                url: "_a=vipcard&_u=ajax.edit_vip_card",
                data: {
                    vip_card_info: inputData
                },
                success: function(addRet) {
                    console.log("addRet >>>", addRet);
                    if (addRet.data && addRet.data != 0) {
                        that.onLoad();
                    } else {
                        wx.showModal({
                            title: "申请失败，请检查您的网络",
                            showCancel: false
                        });
                    }
                }
            });
        }        

    },

    onPullDownRefresh: function () {
    
    },

    onShareAppMessage: function () {
    
    }
})