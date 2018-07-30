var app = getApp();
var util = require('../../../../utils/util.js');
var page = 0;
var sliderWidth = 96; 
var WxParse = require('../../../common/wxParse/wxParse.js');


Page({

    data: {
        mainColor: app.globalData.main_color,
        goods: [],
        page: 0,

        tabs: ["主页", "商品"],
        activeIndex: 0,
        sliderOffset: 0,
        sliderLeft: 0,
        // 评论框
        showCommentModal: false,
    },

    onLoad: function (options) {
        var that = this;
        this.setData({
            options: options,
            mainColor: app.globalData.main_color
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
        var businessId = options.uid;

        wx.getSystemInfo({
            success: function(res) {
                that.setData({
                    sliderLeft: (res.windowWidth / that.data.tabs.length - sliderWidth) / 2,
                    sliderOffset: res.windowWidth / that.data.tabs.length * that.data.activeIndex
                });
            }
        });

        this.getBusinessData(businessId);
        
        // 获取该商家所有商品
        this.getGoods(0);    
    },

    onShow: function() {
        var businessId = this.data.options.uid;
        // 获取商家发布的优惠券
        this.getCoupon(businessId);
    },

    // 获取商家数据
    getBusinessData: function(businessId) {
        var that = this;
        // 获取商家数据
        app.request({
            url: "_a=shop&_u=biz.ajax_biz_uid",
            data: {
                uid: businessId
            },
            success: function(ret) {
                console.log("business ret >>>", ret);
                var businessData = ret.data;
                that.getMsgById(businessData.su_uid);
                if (!businessData.main_img.startsWith("http")) businessData.main_img = app.globalData.prefix_url + businessData.main_img;

                if (businessData.images && businessData.images.length > 0) {
                    for (var i = 0; i < businessData.images.length; i++) {
                        
                        if (!businessData.images[i].startsWith("http")) {
                            businessData.images[i] = app.globalData.prefix_url + businessData.images[i];
                        }
                    }
                }

                WxParse.wxParse('article', 'html', businessData.brief, that); 

                that.setData({
                    businessData: businessData
                });
            }
        });
    },

    // 获取商家发布的优惠券
    getCoupon: function(businessId) {
        var that = this;
        app.request({
            url: "_a=shop&_u=biz.get_bizcoupon",
            data: {
                biz_uid: businessId,
                limit: -1
            },
            success: (ret)=>{
                console.log("coupons ret >>>>>", ret);
                var couponList = ret.data.list;
                couponList.forEach(function(ele) {
                    var img = ele.img;
                    ele.img = img.startsWith("http") ? img : (app.globalData.prefix_url + img);
                });
                that.setData({
                    couponList: couponList
                });
            }
        })
    },

    // 领取优惠券
    drawCoupon: function(e) {
        var that = this;
        var couponId = e.currentTarget.dataset.id;
        var businessId = that.data.options.uid;

        if (couponId) {
            app.request({
                url: "_a=shop&_u=biz.addbizusercoupon",
                data: {
                    biz_uid: businessId,
                    coupon_uid: couponId
                },
                success: (ret)=>{
                    console.log("领取优惠券 >>>>>", ret);
                    if (ret.data && ret.data != 0) {
                        wx.showToast({
                            title: "领取成功"
                        });
                        that.getCoupon(businessId);
                    } else if (ret.error == 607) {
                        wx.showModal({
                            title: "领取失败",
                            content: "已超过领取限制",
                            showCancel: false
                        });
                    }
                }
            });
        }
    },

    // 获取所有商品函数
    getGoods: function(page) {
        var that = this;
        var businessId = that.data.options.uid;

        // 获取商家在售商品
        app.request({
            url: "_a=shop&_u=ajax.products",
            data: {
                biz_uid : businessId,
                page: page
            },
            success: function(ret) {
                console.log("business goods ret >>>", ret);
                var goods = ret.data.list,
                    list = that.data.goods;

                goods.forEach(function(good) {
                    if (!good.main_img.startsWith("http")) good.main_img = app.globalData.prefix_url + good.main_img;
                    good.price /= 100;
                })

                list = list.concat(goods);

                that.setData({
                    goods: list,
                    goodsCount: ret.data.count,
                    page: page,
                    noMore: goods.length < 10
                });  
            }
        });
    },

    // 获取商家发布的信息
    getMsgById: function(id) {
        var that = this;

        app.request({
            url: "_a=classmsg&_u=ajax.get_class_by_su_uid",
            data: {
                su_uid: id,
                limit: -1
            },
            success: (ret)=>{
                console.log("shop msg list ret >>>>", ret);

                var list = ret.data.list;

                list.forEach(function(ele) {
                    // 处理时间
                    var time = util.formatTime(ele.create_time);
                    ele.time = time[1] + '月' + time[2] + '日' + ' ' + time[3];

                    // 判断是否包含图片
                    if (ele.images && ele.images.length !== 0) {
                        for (var i = 0; i < ele.images.length; i++) {
                            ele.images[i] = app.globalData.prefix_url + ele.images[i];
                        }
                    }
                });

                that.setData({
                    showList: list,
                });
                
            }
        });
    },

    // 小导航
    subNavTap: function(e) {
        var subNav = e.currentTarget.dataset.set,
            subUrl = subNav.link;

        if (!subUrl) return;

        if (subUrl.startsWith("map")) {
            var locArr = subUrl.split("-"),
                lat = parseFloat(locArr[1]),
                lng = parseFloat(locArr[2]),
                title = locArr[3];
            wx.openLocation({  
                latitude: lat,  
                longitude: lng,  
                scale: 18,  
                name: title,
                // address:'金平区长平路93号'
            });
        } else if (subUrl.startsWith("phone")) {
            var phone = subUrl.split("-")[1];
            wx.makePhoneCall({
                phoneNumber: phone
            });
        } else if (subUrl.startsWith("app")) {
            var appId = subUrl.split("-")[1];
            wx.navigateToMiniProgram({
                appId: appId,
                // path: 'pages/index/index?id=123',
                extraData: {
                    fromApp: 'mall'
                },
                // envVersion: 'develop',
                success(res) {
                // 打开成功
                }
            })
        } else if (subUrl.startsWith("web")) {
            var webUrl = subUrl.split("-")[1];
            wx.navigateTo({
                url: "pages/webPage/webPage?url=" + webUrl
            });
        } else if (subUrl.startsWith("vedio")) {
            var vedioUrl = encodeURI(subUrl.split("-")[1]);
            wx.navigateTo({
                url: "pages/vedioPage/vedioPage?url=" + vedioUrl
            });
        } else {
            wx.navigateTo({
                url: subUrl
            });
        }
    },

    
    onPullDownRefresh: function () {
    },

    // 收藏店铺
    favTap: function(e) {
        var businessData = this.data.businessData,
            that = this;

        if (businessData.had_fav) {
            // 已收藏
            wx.showModal({
                title: "确定取消收藏？",
                confirmText: "容朕想想",
                cancelText: "取消收藏",
                success: (res)=>{
                    if (res.cancel) {
                        app.request({
                            url: "_a=shop&_u=biz.del_biz_fav",
                            data: {
                                uid: businessData.had_fav
                            },
                            success: (ret)=>{
                                console.log("cancel favorite ret >>>", ret);
                                if (ret.data && ret.data != 0) {
                                    // wx.showToast({
                                    //     title: "收藏成功"
                                    // });
                                    that.getBusinessData(businessData.uid);
                                }
                            }
                        });
                    }
                }
            });
        } else {
            // 未收藏
            app.request({
                url: "_a=shop&_u=biz.add_biz_fav",
                data: {
                    biz_uid: businessData.uid
                },
                success: (ret) => {
                    console.log("favorite tap ret >>>", ret);
                    if (ret.data && ret.data != 0) {
                        wx.showToast({
                            title: "收藏成功"
                        });
                        that.getBusinessData(businessData.uid);
                    }
                }
            });
        }
    },

    // 打电话
    phoneCall: function() {
        var phone = this.data.businessData.phone;
        wx.makePhoneCall({
            phoneNumber: phone
        });
    },

    // 打开地图导航
    openMap: function (e) {
        var businessData = this.data.businessData,
            lat = parseFloat(businessData.lat),
            lng = parseFloat(businessData.lng);

        if (lat != 0 && lng != 0) {
            wx.openLocation({  
                latitude: lat,
                longitude: lng,
                scale: 18,
                name: businessData.title,  
                address: businessData.location  
            });
        } else {
            wx.showModal({
                title: "无法导航",
                content: "这家商家没有提供具体位置",
                showCancel: false
            });
        }
    },

    tabClick: function (e) {
        this.setData({
            sliderOffset: e.currentTarget.offsetLeft,
            activeIndex: e.currentTarget.id
        });
    },

    // 预览消息图片
    previewImages: function(e) {
        var id = e.currentTarget.id.split("-");
        console.log("image id >>>>>>", id);
        var idx = id[0],
            subIdx = id[1];

        var showList = this.data.showList,
            images = showList[idx].images,
            img = images[subIdx];

        wx.previewImage({
          current: img, // 当前显示图片的http链接
          urls: images // 需要预览的图片http链接列表
        });
    },


    // 点赞
    likeTap: function(e) {
        var that = this,
            id = e.currentTarget.id,
            showList = that.data.showList;

        app.request({
            url: '_a=classmsg&_u=ajax.add_good_cnt',
            data: {
                msg_uid: id
            },
            success: (ret) =>{
                console.log("like tap ret >>>>>", ret);
                if (ret.data && ret.data != 0) {
                    wx.showToast({
                        title: '点赞成功'
                    });
                }
            }
        });

        showList.forEach(function(ele) {
            if (ele.uid == id) {
                ele.su_good = !ele.su_good;
                ele.su_good ? (ele.good_cnt++) : (ele.good_cnt--);
            }
        });

        that.setData({
            showList: showList
        });
    },

    // 评论
    commentTap: function(e) {
        var id = e.currentTarget.id;

        this.setData({
            showCommentModal: true,
            commentId: id
        });
    },
    // 提交评论
    bindFormSubmit: function(e) {
        var comment = e.detail.value.textarea;

        if (comment) {
            var that = this,
                commentId = that.data.commentId;

            console.log("commentId >>>>", commentId);

            app.request({
                url: "_a=classmsg&_u=ajax.add_comment",
                data: {
                    msg_uid: commentId,
                    content: comment
                },
                success: that.commentCallback
            });
        } else {
            wx.showModal({
                title: "请填写评论内容",
                showCancel: false
            });
        }
    },
    commentCallback: function(ret) {
        var that = this;
        var options = that.data.options;
        console.log("comment ret >>>>", ret);

        if (ret.data && ret.data != 0) {
            that.setData({
                showCommentModal: false,
            });

            wx.showToast({
                title: "评论成功",
                success: (res)=>{
                    if (res && res != 0) {
                        that.getMsgById(that.data.businessData.su_uid);
                    }
                }
            });
        }
    },
    quitCommentTap: function() {
        this.setData({
            showCommentModal: false
        });
    },



    onReachBottom: function () {
        var that = this;
        var page = this.data.page + 1;

        // 获取商家在售商品
        this.getGoods(page);
    },

    onShareAppMessage: function () {
        var businessData = this.data.businessData;

        return {
            title: (app.globalData.userInfo.nickName||'') + ' 邀请你来逛逛 ' + businessData.title,
            // path: '/page/class/pages/goodDetail/goodDetail?parentId=' + app.globalData.su_uid + "&uid=" + goodDetail.uid,
            success: function(res) {
            // 转发成功
            },
            fail: function(res) {
            // 转发失败
            }
        }
    }
})