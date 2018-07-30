var app = getApp();

Page({
    data:{
        colorsArr: ["rgb(204,204,204)", "red", "green", "#1e91d0"],
        signedList: []
    },
    onLoad:function(options){
        var that = this;
        var activityId = options.activityId;

        that.setData({
            options: options
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });

        this.getSignedList();
    },

    // 获取所有报名人员
    getSignedList: function(key) {
        var that = this;

        if (!key) key = "";

        app.request({
            url: "_a=form&_u=ajax.recordlist",
            data: {
                f_uid: that.data.options.activityId,
                limit: -1,
                key: key,
            },
            success: (ret)=>{
                console.log("signed >>>>", ret);
                var signedList = ret.data.list;
                that.setData({
                    signedList: signedList
                });
            }
        });
    },

    // 搜索输入框操作
    showInput: function () {
        this.setData({
            inputShowed: true
        });
    },
    hideInput: function () {
        this.setData({
            inputVal: "",
            inputShowed: false
        });
        this.getSignedList();
    },
    clearInput: function () {
        this.setData({
            inputVal: ""
        });
    },
    inputTyping: function (e) {
        var value = e.detail.value,
            that = this;
        that.getSignedList(value);        
    },


    // 操作报名状态
    handleSign: function(e) {
        var id = e.currentTarget.dataset.id,
            signedList = this.data.signedList,
            that = this;

        wx.showActionSheet({
            itemList: ["0", "1", "2", "3"],
            success: function(res) {
                console.log(res.tapIndex)
                that.changeSignStatus(id, res.tapIndex);
            },
            fail: function(res) {
                console.log(res.errMsg)
            }
        })

        
    },

    // 改变报名状态请求
    changeSignStatus: function(id, status) {
        var that = this;

        app.request({
            url: "_a=form&_u=ajax.editformrecord",
            data: {
                f_uid: that.data.options.activityId,
                uid: id,
                sp_remark: status
            },
            success: (ret)=>{
                console.log("change sign status ret >>>>>", ret);
                if (ret.data && ret.data != 0) {
                    wx.showToast({
                        title: "修改成功"
                    });
                    that.onLoad(that.data.options);
                }
            }
        });
    },
})