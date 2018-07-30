// page/class/pages/pointGoodDetail/pointGoodDetail.js
var app = getApp();
var WxParse = require('../../../common/wxParse/wxParse.js');
var util = require('../../../../utils/util.js')

Page({
    data:{
        mainColor: app.globalData.main_color,
        
        // 商品轮播图数据
        background: [],
        background_main: '',

        serviceImg: app.globalData.server_url + "_u=common.img&name=service.png",
        cartImg: app.globalData.server_url + "_u=common.img&name=cart.png",
        favoriteImg: app.globalData.server_url + "_u=common.img&name=favorite.png",
        favoriteSelectedImg: app.globalData.server_url + "_u=common.img&name=favorites_fill.png",
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
            })
        }

        that.setData({
            goodId: id,
            options: options
        });

        // 获取商品详情
        that.getGoodDetail(id);
    },

    // 获取商品详情函数
    getGoodDetail: function(id, cb) {
        var that = this;

        // 获取商品详情
        app.request({
            url: "_easy=qrposter.ajax.product",
            data: {
                uid: id
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
        var that = this;
        var detail = ret.data;
        var background = [];
        var id = that.data.goodId;

        if (detail.video_url) {
            background.push({vedio: detail.video_url})
        }

        if (detail.main_img && !detail.main_img.startsWith("http")) detail.main_img = app.globalData.prefix_url + detail.main_img;

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
        // detail.price = parseInt(detail.price) / 100;
        // detail.group_price = detail.group_price == 0 ? 0 : detail.group_price/100;

        console.log("good >>>>>", ret);
        var mainImg = detail.main_img.startsWith("http") ? detail.main_img : (app.globalData.prefix_url + detail.main_img);

        that.setData({
            detail: detail,
        });

        // 商品库存
        var quantity = parseInt(detail.quantity);
        if (quantity === 0) {
            that.setData({
                selectedNum: 0
            });
        }

        if (detail.sku_table) {
            // 商品规格
            // 获取所有规格的名称
            var specialClass = Object.keys(detail.sku_table.table);
            var specials = [];

            specialClass.forEach(function(ele) {
                var special = {
                    name: ele,
                    list: detail.sku_table.table[ele],
                    selectedIndex: 0
                };
                
                specials.push(special);
            });
            that.calculate(specials);
        }

        //商品详情
        WxParse.wxParse('article', 'html', detail.content, that); 
    },

    // 轮播图切换事件
    swiperChange: function(e) {
        console.log("swiperChange event >>>>>", e);
    },

    // 参团事件
    navToGroupJoin: function(e) {
        var goodId = this.data.goodId;
            
        var navUrl = "../groupOrder/groupOrder?pointGoodId=" + goodId + "&from=pointGood";

        wx.navigateTo({
            url: navUrl
        });
    },

    // 立即购买 前往订单页面
    navToOrder: function() {
        var that = this;

        // 获取需要存储的数据
        var detail = that.data.detail;
        var price = that.data.price;
        var specialKey = that.data.specialKey;
        var specials = that.data.specials;
        var selectedNum = that.data.selectedNum;

        var order = {};
        order.list = [];
        var goodOrder = {
            detailData: detail,
            price: price,
            selectedNum: selectedNum,
            specials: specials,
            specialKey: specialKey
        };

        if (selectedNum >= 1) {
            order.list.push(goodOrder);
            // 将选中的订单存入本地
            wx.setStorage({
                key: "order",
                data: order
            });

            wx.navigateTo({
                url: "../order/order"
            });
        } else {
            wx.showToast({
                icon: 'loading',
                title: '已售罄'
            });
        }
    },

    // 分享商品页面
    onShareAppMessage: function (res) {
        var uid = this.data.goodId,
            goodDetail = this.data.detail,
            title = app.globalData.userInfo.nickName + '给你分享了一个宝贝 ' + goodDetail.title,
            pagePath = '/page/class/pages/pointGoodDetail/pointGoodDetail?parentId=' + app.globalData.su_uid + "&uid=" + uid;

        return {
            title: title,
            path: pagePath,
            success: function(res) {
            },
            fail: function(res) {
            }
        }
    },
});
