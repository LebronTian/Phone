// page/class/pages/biddingDetail/biddingDetail.js
var sliderWidth = 96;
var app = getApp();
var WxParse = require('../../../common/wxParse/wxParse.js');
var util = require('../../../../utils/util.js')
var freshTimer = null;

// var formatPrice = function(num) {
//     var num = (num || 0).toString(), result = '';
//     while (num.length > 3) {
//         result = ',' + num.slice(-3) + result;
//         num = num.slice(0, num.length - 3);
//     }
//     if (num) { result = num + result; }
//     return result;
// }

Page({
    data:{
        mainColor: app.globalData.main_color,

        // 商品轮播图数据
        background: [],
        background_main: '',
        // biddingProcess: ['交保证金', '竞价', '付款', '交割', '完成'],
        firstUser: null,
        otherUser: [],

        addPrice: 0
    },
    onLoad:function(options){
        var that = this;
        this.setData({
            mainColor: app.globalData.main_color
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });

        if (!app.globalData.su_uid) {
            app.getUserInfo(function(userInfo) {
                that.onLoad(options);
            });
        } else {
            var id = options.uid;

            // 分销功能
            if (options.parentId) {
                app.request({
                    url: "_a=su&_u=ajax.update_su",
                    data: {
                        from_su_uid: options.parentId
                    },
                    success: function(ret) {
                        console.log("add fans ret", ret);
                    }
                });
            }

            that.setData({
                goodId: id,
                options: options
            });

            // 获取商品详情
            that.getGoodDetail(id);
        }
    },

    // 获取竞价商品详情函数
    getGoodDetail: function(id, cb) {
        var that = this;

        // 获取竞价记录
        that.getBiddingRecord(id);

        // 获取商品详情
        app.request({
            url: "_a=auction&_u=ajax.item",
            data: {
                uid: id,
                hideRequestToast: true
            },
            success: function(ret) {
                if (typeof(cb) === "function") {
                    cb(ret);
                } else {
                    that.getGoodDetailCb(ret);
                }
            }
        });
    },
    getGoodDetailCb: function(ret) {
        console.log("good detail >>>>>", ret);
        let that = this;
        let detail = ret.data;
        let background = [];
        let id = that.data.goodId;
        let showAlarm = false;

        // 商品视频
        if (detail.video_url) {
            background.push({vedio: detail.video_url})
        }
        let img = detail.ap.image;
        detail.main_img = img.startsWith('http') ? img : (app.globalData.prefix_url + img);

        // 商品图片 轮播图
        if(!detail.images) detail.images = [detail.main_img];
        if (detail.images.length > 0) {
            detail.images.forEach(function(image) {
                if (image && !image.startsWith("http")) image = app.globalData.prefix_url + image;
                background.push({img: image});
            });

            that.setData({
                background: background,
                background_main: detail.main_img
            });
        }

        // 处理商品价格
        detail.min_price = util.formatPrice(detail.ap.min_price);
        if (detail.last_price == 0) {
            detail.price = detail.min_price;
            detail.minBiddingPrice = parseFloat((parseInt(detail.ap.min_price) + parseInt(detail.rule.step_price))/100);
        } else {
            detail.price = util.formatPrice(detail.last_price);
            detail.minBiddingPrice = parseFloat((parseInt(detail.last_price) + parseInt(detail.rule.step_price))/100);
        }

        // 保证金
        if (detail.rule.deposit_price == 0) {
            detail.deposit_price = '无需保证金';
        } else {
            detail.deposit_price = util.formatPrice(detail.rule.deposit_price);
        }

        // 处理拍卖加价
        detail.step_price = util.formatPrice(detail.rule.step_price);

        // 判断拍卖状态
        let startTime = parseInt(detail.start_time) || 0,
            endTime = parseInt(detail.end_time) || 0;
        detail.startTime = util.formatTime(startTime).join('-');
        if (endTime == 0) {
            detail.endTime = '无限期';
        } else {
            detail.endTime = util.formatTime(endTime).join('-');
        }
        
        if (detail.deal_time == 0) {
            // 拍卖未成交
            // 处理拍卖 开始/结束 时间
            let now = new Date(),
                nowTime = now.getTime() / 1000;
            
            if (startTime > nowTime) {
                detail.status = "拍卖未开始，距离拍卖开始还有";
                let remainTime = parseInt(startTime) - parseInt(nowTime);
                detail.leftTime = remainTime;
                detail.remainTime = util.formatRemainTime(remainTime);
                if (!freshTimer) {
                    this.freshTime(detail);
                }
                showAlarm = false;
            } else if (endTime == 0) {
                detail.status = "拍卖正在进行中，拍卖时间不限"
                detail.remainTime = "";
                if (!freshTimer) {
                    this.freshTime(detail);
                }
            } else if (nowTime < endTime) {
                detail.status = "拍卖正在进行中，距离拍卖结束还有"
                let remainTime = parseInt(endTime) - parseInt(nowTime);
                detail.leftTime = remainTime;
                detail.remainTime = util.formatRemainTime(remainTime);
                if (!freshTimer) {
                    this.freshTime(detail);
                }
            } else if (nowTime >= endTime) {
                detail.remainTime = '';
                detail.status = '竞拍已结束';
                this.handleBidding(detail);
                if (freshTimer) clearInterval(freshTimer);
            }
        } else {
            // 拍卖已成交
            // 判断是否竞拍成功
            detail.status = '竞拍已结束';
            detail.remainTime = '';
            this.handleBidding(detail);

            if (freshTimer) clearInterval(freshTimer);
        }

        if (!that.data.addPrice) {
            that.setData({
                addPrice: detail.minBiddingPrice
            });
        }

        that.setData({
            showAlarm,
            detail: detail,
        });
        //商品详情
        // WxParse.wxParse('article', 'html', detail.content, that); 
    },
    // 刷新时间
    freshTime: function(detail) {
        var that = this;
        // console.log('fresh detail >>>', detail)
        freshTimer = setInterval(function() {
            if (detail.remainTime) {
                detail.leftTime--;
                if (detail.leftTime <= 0) {
                    clearInterval(freshTimer);
                    freshTimer = null;
                } else {
                    detail.remainTime = util.formatRemainTime(detail.leftTime);
                }
            }
            that.getGoodDetail(detail.uid);
        }, 1000);
    },

    // 竞价记录
    getBiddingRecord: function(uid) {
        let that = this;
        app.request({
            url: '_a=auction&_u=ajax.get_record',
            data: { it_uid: uid, hideRequestToast: true },
            success: (ret) => {
                console.log("bidding record >>>", ret);
                let list = ret.data.list,
                    firstUser = null,
                    otherUser = [];
                list.forEach(function(ele) {
                    ele.price = util.formatPrice(ele.last_price);
                });

                if (list[0]) {
                    firstUser = list[0];
                }

                if (list[1]) {
                    otherUser.push(list[1]);
                }
                if (list[2]) {
                    otherUser.push(list[2]);
                }

                that.setData({
                    recordList: list,
                    recordCount: ret.data.count,
                    firstUser,
                    otherUser
                });
            }
        });
    },

    // 参与竞价
    joinBidding: function() {
        let that = this,
            detail = that.data.detail,
            uid = detail.uid;

        if (detail.status.startsWith('竞拍已结束')) {
            wx.showModal({
                content: '竞拍已结束，等下次再来吧',
                showCancel: false
            });
        } else {
            app.request({
                url: '_a=auction&_u=ajax.add_deposit',
                data: { uid },
                success: (ret) => {
                    console.log("join bidding >>>", ret);
                    if (ret.data) {
                        wx.showToast({
                            title: '参与竞价成功',
                            success: ()=>{
                                that.getGoodDetail(uid);
                            }
                        });
                    } else if (ret.errno == 401) {
                        wx.showModal({
                            title: '参与竞价失败',
                            content: '您的账户余额不足，请充值',
                            confirmText: '去充值',
                            cancelText: '',
                            success: (res)=>{
                                if (res.confirm) {
                                    wx.navigateTo({
                                        url: '/page/cart/pages/charge/charge'
                                    });
                                }
                            }
                        });
                    } else {
                        wx.showModal({
                            title: '参与竞价失败',
                            content: ret.errstr
                        });
                    }
                }
            });
        }
    },

    // 输入竞价价格
    inputPrice: function(e) {
        let addPrice = e.detail.value,
            minBiddingPrice = this.data.detail.minBiddingPrice;

        this.setData({
            addPrice
        });
    },

    // 加价竞价
    addBidding: function() {
        let that = this,
            price = parseInt(that.data.addPrice*100),
            detail = that.data.detail,
            uid = detail.uid;

        if (detail.status.startsWith('拍卖未开始')) {
            wx.showModal({
                content: '拍卖未开始，等拍卖正式开始后再加价吧',
                showCancel: false
            });
        } else if (detail.status.startsWith('竞拍已结束')) {
            wx.showModal({
                content: '竞拍已结束，等下次再来吧',
                showCancel: false
            });
        } else {
            app.request({
                url: '_a=auction&_u=ajax.make_a_quote',
                data: { uid, price },
                success: (ret) => {
                    console.log("add bidding >>>", ret);
                    if (ret.data) {
                        wx.showToast({
                            title: '加价成功'
                        });
                    } else if (ret.errno == 401) {
                        wx.showModal({
                            title: '加价失败',
                            content: '您的账户积分不足',
                            showCancel: false
                        });
                    } else {
                        wx.showModal({
                            title: '参与竞价失败',
                            content: ret.errstr
                        });
                    }
                }
            });
        }
    },

    // 竞价结束处理
    handleBidding: function(detail) {
        let that = this;
        if (detail.deal_su_uid == app.globalData.su_uid) {
            let price = detail.price;
            let content = '恭喜您以 '+price+' 元的价格竞拍到心仪产品'
            wx.showModal({
                title: '竞价成功!',
                content,
                showCancel: false,
                confirmText: '去付款',
                success: (res)=> {
                    if (res.confirm) {
                        that.findGroup();
                    }
                }
            });
        } else {
            wx.showModal({
                title: '很遗憾',
                content: '竞拍已结束，您未能拍下心仪产品，下次再来吧',
                cancelText: '返回',
                success: (res)=>{
                    if (res.cancel) {
                        wx.navigateBack();
                    }
                }
            });
        }
    },

    // 竞拍付款
    findGroup: function() {
        var that = this;

        // 获取需要存储的数据
        var detail = that.data.detail;
        // 竞拍价
        var price = detail.deal_price;
        var specialKey = '';
        var specials = '';
        var selectedNum = 1;

        var order = {};
        order.list = [];
        var goodOrder = {
            detailData: detail,
            price: price,
            selectedNum: selectedNum,
            specials: specials,
            specialKey: specialKey,
            goUid: 0
        };

        order.list.push(goodOrder);

        // 将选中的订单存入本地
        wx.setStorage({
            key: "groupOrder",
            data: order
        });

        wx.navigateTo({
            url: "../groupOrder/groupOrder?from=bidding"
        });
    },

    // 分享商品页面
    onShareAppMessage: function (res) {
        var goodDetail = this.data.detail;

        return {
            title: app.globalData.userInfo.nickName + '给你分享了一个竞拍活动 '+ goodDetail.ap.title,
            path: '/page/class/pages/biddingDetail/biddingDetail?parentId=' + app.globalData.su_uid + "&uid=" + goodDetail.uid,
            success: function(res) {
            // 转发成功
            },
            fail: function(res) {
            // 转发失败
            }
        }
    },

    onUnload: function() {
        console.log('unLoad ');
        clearInterval(freshTimer);
        freshTimer = null;
    }

});
