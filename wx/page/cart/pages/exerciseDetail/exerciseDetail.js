var sliderWidth = 96;
var app = getApp();
var WxParse = require('../../../common/wxParse/wxParse.js');
var util = require('../../../../utils/util.js');


Page({
    data:{
        tabs: ["活动详情", "活动留言"],
        activeIndex: 0,
        sliderOffset: 0,
        sliderLeft: 0,

        detailData: {},
        signedList: [],

        resourceId: "",
        commentList: [],
        isWriteComment: false,
        parentId: "0",
        
        isAble2Tap: true
    },

    onLoad:function(options){
        var that = this;

        // 获取传过来的 uid 参数
        var id = options.f_uid;
        that.setData({
            mainColor: app.globalData.main_color,
            resourceId: id,
            options: options
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });

        wx.getSystemInfo({
            success: function(res) {
                that.setData({
                    sliderLeft: (res.windowWidth / that.data.tabs.length - sliderWidth) / 2,
                    sliderOffset: res.windowWidth / that.data.tabs.length * that.data.activeIndex
                });
            }
        });

        if (!app.globalData.su_uid) {
            app.getUserInfo(function(userInfo) {
                that.onLoad(options);
            });
        } else {
            // 获取活动数据
            that.getExerData();

            // 获取评论列表
            that.getComment(id);

            // 获取所有报名成功人员(报名成功／已签到)
            app.request({
                url: "_a=form&_u=ajax.recordlist",
                data: {
                    f_uid: id,
                    limit: 10,
                    // sp_remark: "2;3"
                },
                success: that.getSignedCb
            });
        }
    },

    // 获取活动数据
    getExerData: function() {
        var that = this;
        app.request({
            url: "_a=form&_u=ajax.form",
            data: {
                f_uid: that.data.resourceId
            },
            success: that.getCallback
        });
    },
    // 获取活动详情数据成功回调函数
    getCallback: function(ret) {
        console.log("detail exer >>>>>", ret);
        var that = this;

        var detailData = ret.data;

        // 添加图片链接前缀
        detailData.img = app.globalData.prefix_url + detailData.img;
        
        // 处理价格
        detailData.price = util.formatPrice(detailData.access_rule.order.price);
        
        // 处理人数限制
        detailData.numLimit = detailData.access_rule.total_cnt === 0 ? "不限" : (detailData.access_rule.max_cnt + " / " + detailData.access_rule.total_cnt);

        // 处理活动开始／结束时间
        var startDate = util.formatTime(detailData.access_rule.astart_time);
        detailData.startDate = startDate.join("-");
        // detailData.endDate = util.formatTime(detailData.access_rule.aend_time)[2];
    
        // 处理报名时间限制
        var now = (new Date().getTime()) / 1000;
        var end_time = detailData.access_rule.end_time;

        // 处理报名按钮信息
        var isAble2TapBtn = null;
        // 判断活动是否过期
        // 未过期
        if (end_time == 0 || now < end_time) {
            console.log("未过期 ／／／／／／／");
            // 判断用户是否为报名签到管理员
            if (detailData.is_admin) {
                console.log("是管理员 ／／／／／／／");
                detailData.signStatu = "报名管理";
            } else {
                console.log("不是管理员 ／／／／／／ ")
                // 判断用户是否已经报名
                // 已报名
                if (detailData.record) {
                    console.log("已报名 ／／／／／／")
                    if (detailData.price != "免费") {
                        // 已支付
                        if (detailData.record.order.paid_time != 0) {
                            console.log("已支付 ／／／／／／／")
                            detailData.signStatu = "报名成功";
                        } else {
                        // 未支付
                            console.log("未支付 ／／／／／／／")
                            if (that.data.options.hasSigned) {
                                that.do_pay(detailData.record.uid);
                            }
                            detailData.signStatu = "已报名，去支付";
                        }
                    }else {
                        console.log("活动免费 ／／／／／／／")
                        detailData.signStatu = "报名成功";
                    }
                    
                } else {
                // 未报名
                    console.log("未报名 ／／／／／／／ >>>>>");
                    detailData.signStatu = "我要报名";
                }
            }
            isAble2TapBtn = true;
        } else if (now >= end_time) {
        // 已过期
            detailData.signStatu = "活动已结束,不接受报名";
            isAble2TapBtn = false;
        }

        // 处理活动介绍
        var article = detailData.brief.replace(/\?_a/, app.globalData.prefix_url + "?_a");
        // var article = detailData.brief;
        WxParse.wxParse('article', 'html', article, that, 5);

        // 将处理后的数据赋值
        that.setData({
            detailData: detailData,
            isAble2Tap: isAble2TapBtn,
            // signId: detailData.record.uid
        });
    },
    
    // 获取全部报名人员的回调函数
    getSignedCb: function(ret) {
        console.log("signed >>>>>>", ret);
        var that = this;

        var signedList = ret.data.list;
        var partnerList = [];

        signedList.forEach(function(ele) {
            ele.avatar = ele.user.avatar;
            if (ele.order) {
                if (ele.order.paid_time !== "0") {
                    partnerList.push(ele);
                }
            } else {
                partnerList.push(ele);
            }
        });

        that.setData({
            signedList: partnerList,
            signedNum: partnerList.length
        });
    },

    // 获取评论列表
    getComment: function(id) {
        var that = this;
        app.request({
            url: "_a=form&_u=ajax.replylist",
            data: {
                // type: "activity",
                limit: -1,
                f_uid: id
            },
            success: that.getCommentCb
        });
    },
    // 获取评论列表回调函数
    getCommentCb: function(ret) {
        console.log("comments ret >>>>>", ret);

        var that = this;
        if (!ret.data) return;
        var comments = ret.data.list;
        var contactComments = [];

        comments.forEach(function(ele) {
            // 设置用户的头像、名称
            ele.img = ele.su.avatar
            ele.name = ele.su.name;

            // 判断这条评论是不是自己的
            ele.isMine = ele.su_uid === app.globalData.su_uid ? true : false;

            // 判断这条评论是不是管理员的
            if (ele.p_uid != 0) {
                ele.isContact = true;
                ele.name = "管理员";
                contactComments.push(ele);
            } else {
                ele.isContact = false;
            }
        });

        var commentsList = [];
        for (var i = 0; i < comments.length; i++) {
            if(comments[i].p_uid == 0) {
                commentsList.push(comments[i]);
                for (var j = 0; j < contactComments.length; j++) {
                    if(contactComments[j].p_uid == comments[i].uid) {
                        commentsList.push(contactComments[j]);
                    }
                }
            }
        }

        console.log("commentsList >>>>>", commentsList);

        that.setData({
            commentList: commentsList
        });

        // 数据加载设置完成后停止刷新
        wx.stopPullDownRefresh({
            complete: function (res) {
                wx.hideToast()
            }
        })
    },
    writeCommentTap: function() {
        this.setData({ isWriteComment: true });
    },
    // 管理员回复评论
    receiveCommentTap: function(e) {
        var parentId = e.currentTarget.id;
        if (this.data.isReceiver) {
            this.setData({
                isWriteComment: true,
                parentId: parentId
            });
        }
    },
    quitCommentTap: function() {
        this.setData({ isWriteComment: false });
    },
    // 提交评论
    bindFormSubmit: function(e) {
        var comment = e.detail.value.textarea;
        var that = this;

        app.request({
            url: "_a=form&_u=ajax.add_form_reply",
            data: {
                content: comment,
                f_uid: that.data.resourceId,
                // p_uid: that.data.parentId
            },
            success: (ret)=>{
                console.log("post comment ret >>>", ret);
                var options = that.data.options;

                if (ret.errno === 0) {
                    that.setData({ isWriteComment: false });

                    wx.showToast({
                        title: "评论成功",
                        success: that.onLoad(options)
                    });
                }
            }
        });
    },
    
    // 删除评论点击事件
    removeCommentTap: function(e) {
        var id = e.currentTarget.id;
        console.log("delete comment id", id);
        var that = this;
        app.request({
            url: "_a=mange&_u=ajax.delresourcecomment",
            data: {
                uid: id
            },
            success: that.removeCallback
        });
    },
    // 删除评论函数回调函数
    removeCallback: function(ret) {
        var that = this;
        var options = that.data.options;
        console.log("delete ret >>>", ret);

        if (ret.errno === 0) {
            wx.showToast({
                title: "删除成功",
                complete: that.onLoad(options)
            });
        }
    },

    // 点击报名
    signTap: function(e) {
        // 判断该用户是否设置了名片，再报名
        var that = this;

        // 判断按钮的状态
        var status = e.currentTarget.id;

        switch(status) {
            case "报名管理":
                var adminUrl = "../exerSignAdmin/exerSignAdmin?activityId=" + that.data.resourceId;
                wx.navigateTo({
                    url: adminUrl
                });
                break;

            case "我要报名":
                that.sign();
                break;

            case "已报名，去支付":
                that.sign();
                break;
        }
    },
    // 报名请求
    sign: function() {
        var that = this,
            detailData = that.data.detailData;

        if (detailData.record) {
            that.do_pay(detailData.record.uid)
        } else {
            // wx.hideLoading();
            if (detailData.data) {
                var url = "../competionSign/competionSign?uid=" + that.data.resourceId;
                wx.navigateTo({
                    url: url
                });
            } else {
                // 报名请求
                app.request({
                    url: "_a=form&_u=ajax.addformrecord",
                    data: {
                        f_uid: that.data.resourceId,
                    },
                    success: (ret)=>{
                        console.log("sign ret >>>>", ret);
                        if (ret.errno === 0) {
                            that.onLoad(that.data.options);
                        } else {
                            wx.showModal({
                                content: '报名失败，请检查您的网络是否正常',
                                showCancel: false
                            });
                        }
                    }
                });
            }
            
        }
    },

    // 管理员回复评论
    receiveCommentTap: function(e) {
        var parentId = e.currentTarget.id;
        if (this.data.isReceiver) {
            this.setData({
                isWriteComment: true,
                parentId: parentId
            });
        }
    },

    // 导航栏事件
    tabClick: function (e) {
        this.setData({
            sliderOffset: e.currentTarget.offsetLeft,
            activeIndex: e.currentTarget.id
        });
    },

    onShareAppMessage: function () {
        var title = this.data.detailData.title;
        return {
            title: title,
        };
    },

    //支付
    do_pay: function(uid) {
        var that = this;
        wx.showLoading({
            title: "等待支付"
        });
        var options = that.data.options;
        if(!uid || that.data.paying) return;
        that.setData({paying: true});
        var data = {oid: 'd' + uid, openid: app.globalData.openid};    
        app.request({
            url:'_a=pay&_u=index.wxxiaochengxu',
            data: data,
            'success': function(ret){
                wx.hideLoading();
                console.log("pay return >>>>>>", ret);
                that.setData({ paying:false });
                if(!ret.data || !ret.data.xiaochengxuParameters) {
                    return app.alert('支付失败！'+ret.errno);
                }
                var obj = ret.data.xiaochengxuParameters;
                obj['success'] = function() {
                    // app.alert('支付成功!');
                    wx.showToast({
                        title: "支付成功"
                    });
                    app.request({
                        url: '_a=pay&_u=index.wxxiaochengxu_update_order',
                        data: data
                    });
                    that.onLoad(options);
                };  
                obj['complete'] = function() {
                    that.setData({paying:false});
                };  
                wx.requestPayment(obj);
            }
        });
    }
})