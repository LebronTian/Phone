var app = getApp();
var util = require('../../../../utils/util.js')

Page({

    data: {
        lat: 0,
        lng: 0,
        id: 0
    },

    onLoad: function (options) {
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
        var id = options.id;
        this.setData({
            id: id
        });
        this.getLoc();
    },

    onShow: function () {

    },

    getLoc: function() {
        // 获取用户地理位置
        var that = this;

        wx.getLocation({
            success: function(res) {
                if (typeof cb == 'function') {
                    cb(res);
                } else {
                    that.setData({
                        lat: res.latitude,
                        lng: res.longitude
                    });
                }
            },
            fail: function() {
                wx.showToast({
                    title: '获取位置失败',
                    icon: 'loading'
                });
            },
            complete: function() {
                that.getMsgDetail();
            }
        });
    },

    // 添加消息查看次数
    getMsgDetail: function() {
        var that = this;
        var id = that.data.id,
            lat = that.data.lat,
            lng = that.data.lng;

        app.request({
            url: '_a=classmsg&_u=ajax.get_class_by_uid',
            data: {
                uid: id,
                lat: lat,
                lng: lng
            },
            success: (ret) => {
                console.log("getMsgDetail ret >>>>>", ret);
                var detail = ret.data;
                // 处理时间
                var time = util.formatTime(detail.create_time);
                detail.time = time[1] + '月' + time[2] + '日' + ' ' + time[3];

                // 判断是否包含图片
                if (detail.images && detail.images.length !== 0) {
                    for (var i = 0; i < detail.images.length; i++) {
                        detail.images[i] = app.globalData.prefix_url + detail.images[i];
                    }
                }

                if (detail.biz) {
                    var mainImg = detail.biz.main_img;
                    detail.biz.main_img = mainImg.startsWith("http") ? mainImg : (app.globalData.prefix_url + mainImg);
                }

                detail.distance = detail.juli ? (parseInt(detail.juli) + 'km') : '未获取位置';

                that.setData({
                    msgData: detail
                });

                // 停止刷新
                wx.stopPullDownRefresh();
            }
        });
    },

    previewImg: function(e) {
        var idx = e.currentTarget.id,
            images = this.data.msgData.images;

        wx.previewImage({
            current: images[idx], // 当前显示图片的http链接
            urls: images // 需要预览的图片http链接列表
        })

    },

    // 点赞
    likeTap: function() {
        var that = this,
            id = that.data.id,
            msgData = that.data.msgData,
            like = msgData.su_good;

        app.request({
            url: '_a=classmsg&_u=ajax.add_good_cnt',
            data: {
                msg_uid: id
            },
            success: (ret) =>{
                console.log("like tap ret >>>>>", ret);
                if (ret.data && ret.data != 0) {
                    var title = like ? '取消成功' : '点赞成功';
                    wx.showToast({
                        title: title
                    });
                }
            }
        });

        msgData.su_good = !like;
        msgData.su_good ? (msgData.good_cnt++) : (msgData.good_cnt--);

        that.setData({
            msgData: msgData
        });
    },

    // 评论
    commentTap: function(e) {
        // var id = this.data.id;

        this.setData({
            showCommentModal: true,
            // commentId: id
        });
    },

    // 提交评论
    bindFormSubmit: function(e) {
        var comment = e.detail.value.textarea;
        var that = this,
            commentId = that.data.id;
            // parentId = that.data.parentId;

        console.log("commentId >>>>", commentId);
        // console.log("parentId >>>>", parentId);

        app.request({
            url: "_a=classmsg&_u=ajax.add_comment",
            data: {
                msg_uid: commentId,
                // parent_uid: parentId,
                content: comment
            },
            success: that.commentCallback
        });
    },
    commentCallback: function(ret) {
        var that = this;
        var options = that.data.options;
        console.log("comment ret >>>>", ret);

        if (ret.data && ret.data != 0) {
            that.setData({
                showCommentModal: false,
                // parentId: 0
            });

            wx.showToast({
                title: "评论成功",
                // success: that.getComment(that.data.resourceId)
            });

            that.getMsgDetail();
        }
    },

    quitCommentTap: function() {
        this.setData({
            showCommentModal: false
        });
    },

    makePhoneCall: function(e) {
        var phone = this.data.msgData.tel;
        wx.makePhoneCall({
            phoneNumber: phone
        });
    },

    onPullDownRefresh: function () {
        that.getMsgDetail();
    },

    onReachBottom: function () {

    },

    onShareAppMessage: function () {

    }
})