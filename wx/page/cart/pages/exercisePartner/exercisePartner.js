var app = getApp();
var util = require('../../../../utils/util.js');
// var shareUrl = "/pages/exercise/pages/exercisePartner/exercisePartner";

Page({
    data:{
        userData: {},
        wxData: {},
        isChecked: true,
        signedList: [],
        page: 0
    },
    onLoad:function(options){
        var that = this;
        var resourceId = options.activityId;
        that.setData({
            resourceId: resourceId,
            options: options,
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });

        this.getSignedList(resourceId, 0);
    },

    onShow: function() {
        var that = this;
        var id = that.data.resourceId;
    },

    // 获取所有报名人员
    getSignedList: function(id, page) {
        var that = this;

        app.request({
            url: "_a=form&_u=ajax.recordlist",
            data: {
                f_uid: id,
                limit: 10,
                page: page,
                // sp_remark: "2;3"
            },
            success: (ret)=>{
                console.log("signed >>>>", ret);
                var signedList = ret.data.list;
                var partnerList = [];

                signedList.forEach(function(ele) {
                    // ele.avatar = ele.user.avatar;
                    if (ele.order) {
                        if (ele.order.paid_time !== "0") {
                            partnerList.push(ele);
                        }
                    } else {
                        partnerList.push(ele);
                    }
                });
                var list = that.data.signedList.concat(partnerList);
                that.setData({
                    signedList: list,
                    page: page
                });
            }
        });
    },


    // 获取活动报名状态回调函数
    getExerciseCb: function(ret) {
        var that = this;
        var isSigned = false;

        // 已报名
        if (ret.data.record) {
            isSigned = ret.data.record.order.paid_time != 0 ? true : false;
        }
        
        that.setData({
            isSigned: isSigned
        });
    },

    // 上拉加载
    onReachBottom: function() {
        var page = this.data.page + 1;
        var id = this.data.resourceId;

        this.getCoursePartner(id, page);
    },

    onShareAppMessage: function () {
        return {
            title: "活动参与人列表",
            // path: shareUrl
        };
    }

})