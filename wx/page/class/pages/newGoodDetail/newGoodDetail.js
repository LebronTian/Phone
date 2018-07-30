var sliderWidth = 96;
var app = getApp();
var WxParse = require('../../../common/wxParse/wxParse.js');
var util = require('../../../../utils/util.js')

Page({
    data:{
        mainColor: app.globalData.main_color,
        
        // 导航栏数据
        tabs: ["商品", "评价"],
        activeIndex: 0,
        sliderOffset: 0,
        sliderLeft: 0,
        sliderWidth: 96,
        navboxWidth: 0,
        navWidth: 0,
        sliderLeft: 0,

        // 商品轮播图数据
        background: [],
        background_main: '',

        group_price: 0,

        // 是否已收藏
        hasCollect: false,

        // 阴影页是否显示
        isSelect: false,

        // 商品规格选择
        selectedIndex: [],
        selectedNum: 1,
        specialKey: "",

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

        // 获取用户收藏列表 判断该商品是否已收藏
        that.getFavorite(id);

        // 获取商品评论
        that.getComments(id);

        wx.getSystemInfo({
            success: function(res) {
                that.setData({
                    sliderLeft: (res.windowWidth / that.data.tabs.length - sliderWidth) / 2,
                    sliderOffset: res.windowWidth / that.data.tabs.length * that.data.activeIndex
                    ,navboxWidth:  res.windowWidth
                    ,navWidth:  2 * res.windowWidth / that.data.tabs.length  
                });
            }
        });
    },

    // 获取商品详情函数
    getGoodDetail: function(id, cb) {
        var that = this;

        // 获取商品详情
        app.request({
            url: "_a=shop&_u=ajax.product",
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

        // 商品视频
        if (detail.video_url) {
            that.setData({
                vedioUrl: detail.video_url
            });
        } else {
            that.setData({
                vedioUrl: ''
            });
        }

        if (detail.main_img && !detail.main_img.startsWith("http")) detail.main_img = app.globalData.prefix_url + detail.main_img;

        // 商品图片 轮播图
        if(!detail.images) detail.images = [detail.main_img];
        if (detail.images.length > 0) {
            detail.images.forEach(function(image) {
                if (image && !image.startsWith("http")) image = app.globalData.prefix_url + image;
                background.push(image);
            });

            that.setData({
                background: background,
                background_main: detail.main_img
            });
        }

        // 关联商品
        if (detail.linked_products && detail.linked_products.length > 0) {
            var goods = detail.linked_products;

            goods.forEach(function(good) {
                if (good.main_img && !good.main_img.startsWith("http")) good.main_img = app.globalData.prefix_url + good.main_img;
                good.price /= 100;
            });

            console.log("linked goodsList = ", goods);
            
            that.setData({
                goodsList: goods,
            });
        } else {
            that.setData({
                goodsList: null
            });
        }

        // 处理商品价格
        detail.price = parseInt(detail.price) / 100;
        detail.group_price = detail.group_price == 0 ? 0 : detail.group_price/100;

        console.log("good >>>>>", ret);
        var mainImg = detail.main_img.startsWith("http") ? detail.main_img : (app.globalData.prefix_url + detail.main_img);

        that.setData({
            detail: detail,
            quantity: detail.quantity,
            price: detail.price,
            specialImg: mainImg,
            // id: id
            group_price: detail.group_price
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

        // 判断是否为拼团商品 获取开团列表
        if (detail.group_price != 0) {
            app.request({
                url: "_a=shop&_u=ajax.get_product_order_list",
                data: {
                    uid: id
                },
                success: function(ret) {
                    // ret.data.list
                    console.log("group good ret >>>", ret);
                    var groupList = ret.data.list;
                    groupList = groupList.length > 2 ? groupList.slice(0, 2) : groupList;
                    groupList.forEach(function(ele) {
                        var now = new Date();
                        var remainTime = parseInt(ele.paid_time) + 3600*24 - parseInt(now.getTime() / 1000);
                        ele.leftTime = remainTime;
                        ele.remainTime = util.formatRemainTime(remainTime);
                    });

                    that.freshTime(groupList);

                    that.setData({
                        groupList: groupList
                    });
                }
            });
        }
        //商品详情
        WxParse.wxParse('article', 'html', detail.content, that); 
    },

    // 判断商品是否已收藏
    getFavorite: function(id, cb) {
        var that = this;
        app.request({
            url: "_a=shop&_u=ajax.favlist",
            success: function(ret) {
                if (typeof(cb) === "function") {
                    cb(ret);
                } else {
                    console.log("favlist >>>>>>>", ret);
                    var favlist = ret.data.list;

                    favlist.forEach(function(ele) {
                        if (ele.product_uid == id) {
                            that.setData({
                                hasCollect: true,
                                favId: ele.uid
                            });
                        }
                    });
                }
            }
        });
    },

    // 获取商品评论
    getComments: function(id, cb) {
        var that = this;
        app.request({
            url: "_a=shop&_u=ajax.comments",
            data: {
                uid: id
            },
            success: function(ret) {
                console.log("comments >>>>>", ret);
                if (typeof(cb) === "function") {
                    cb(ret);
                } else {
                    var comments = ret.data.list;

                    comments.forEach(function(comment) {
                        // 处理评论人姓名
                        if (comment.user.name.length > 1) {
                            comment.name = comment.user.name.slice(0, 1) + "***" + comment.user.name.slice(-1);
                        } else {
                            comment.name = "*";
                        }

                        // 处理评论评分
                        if (comment.score > 3) {
                            comment.degree = "好评";
                            comment.degreeImg = "../../../resources/pic/good.png";
                        } else if (comment.score > 1) {
                            comment.degree = "中评";
                            comment.degreeImg = "../../../resources/pic/normal.png";
                        } else {
                            comment.degree = "差评";
                            comment.degreeImg = "../../../resources/pic/bad.png";
                        }

                        // 处理评论时间
                        var date = util.formatTime(comment.create_time);
                        comment.time = date[0] + "-" + date[1] + "-" + date[2];

                        // 处理评论图片
                        if (comment.images.length > 0) {
                            for (var i = 0; i < comment.images.length; i++) {
                                var img = comment.images[i];
                                if (img && !img.startsWith("http")) comment.images[i] = app.globalData.prefix_url + img;
                            }
                        }

                    });

                    that.setData({
                        comments: comments
                    });
                }
            }
        });
    },

    // 查看评论图片
    previewImg: function(e) {
        console.log("tap image >>>", e);
        var id = e.currentTarget.id;

        var index = id.split("-"),
            commentIndex = parseInt(index[0]),
            imageIndex = parseInt(index[1]);

        var commentList = this.data.comments;

        wx.previewImage({
            current: commentList[commentIndex].images[imageIndex], // 当前显示图片的http链接
            urls: commentList[commentIndex].images // 需要预览的图片http链接列表
        })

    },

    // 刷新时间
    freshTime: function(groupList) {
        var that = this;
        var sh = setInterval(function() {
            groupList.forEach(function(ele) {
                ele.leftTime--;
                if (ele.leftTime <= 0) {
                    ele.remainTime = "团购已过期";
                } else {
                    ele.remainTime = util.formatRemainTime(ele.leftTime);
                }
            });

            that.setData({
                groupList: groupList
            });
        }, 1000);
    },

    // 参团事件
    navToGroupJoin: function(e) {
        var groupId = e.currentTarget.id,
            goodId = this.data.goodId;
            
        var navUrl = "../joinGroup/joinGroup?goodId=" + goodId + "&groupId=" + groupId;

        wx.navigateTo({
            url: navUrl
        });
    },

    // 查看关联商品
    reload: function(e) {
        var goodId = e.currentTarget.id;
        var options = this.data.options;
        options.uid = goodId;
        this.onLoad(options);
    },

    // 选择商品规格函数
    bindSelectSpecial: function(e) {
        var that = this;
        var id = e.currentTarget.id;
        var keyValue = id.split(' ');

        var specials = that.data.specials;

        specials.forEach(function(special) {
            if (special.name == keyValue[0]) {
                special.selectedIndex = parseInt(keyValue[1]);
            }
        });

        that.calculate(specials);
    },

    // 购买数量减一
    substractNum: function() {
        var that = this;
        var selectedNum = that.data.selectedNum - 1;
        that.setData({
            selectedNum: selectedNum
        });
    },

    // 购买数量加一
    addNum: function() {
        var that = this;
        var selectedNum = that.data.selectedNum + 1;

        that.setData({
            selectedNum: selectedNum
        });        
    },

    // 通过用户选择的规格，获取对应信息
    calculate: function(specials) {
        var that = this;
        var detail = that.data.detail;
        var selectedNum = that.data.selectedNum;
        var selectedSpecialKey = "";

        // 获取所有规格组合下的产品信息
        var specialKeys = Object.keys(detail.sku_table.info);

        // 获取用户选择的规格
        specialKeys.forEach(function(specialKey) {
            for (var i = 0; i < specials.length; i++) {
                if(specialKey.indexOf(specials[i].list[specials[i].selectedIndex]) == -1) {
                    break;
                } else {
                    if (i == specials.length - 1) {
                        selectedSpecialKey = specialKey;
                    }
                }
            }
        });

        var selectSpecial = detail.sku_table.info[selectedSpecialKey];
        var price = selectSpecial.price / 100;
        var quantity = selectSpecial.quantity;
        if (selectSpecial.icon_img && !selectSpecial.icon_img.startsWith("http")) selectSpecial.icon_img = app.globalData.prefix_url + selectSpecial.icon_img;
        var specialImg = selectSpecial.icon_img ? (selectSpecial.icon_img) : detail.main_img;
        selectedNum = selectedNum > quantity ? quantity : selectedNum;
        if (quantity > 0) selectedNum = selectedNum == 0 ? 1 : selectedNum;

        // specials：用户挑选的规格；
        that.setData({
            specials: specials,
            price: price,
            quantity: quantity,
            specialKey: selectedSpecialKey,
            selectedNum: selectedNum,
            specialImg: specialImg
        });
    },

    // 加入收藏
    addToFavorite: function() {
        var that = this;
        var goodId = that.data.goodId;
        var options = that.data.options;
        var hasCollect = that.data.hasCollect;

        if (!hasCollect) {
            app.request({
                url: "_a=shop&_u=ajax.add_to_fav",
                data: {
                    product_uid: goodId
                },
                success: function(ret) {
                    console.log("addToFavorite ret >>>", ret);
                    if (ret.data && ret.data != 0) {
                        wx.showToast({
                            title: "收藏成功!",
                            success: function() {
                                that.onLoad(options);
                            }
                        })
                    }
                }
            });
        } else {
            var favId = that.data.favId;
            console.log("delete favId >>>", favId);
            app.request({
                url: "_a=shop&_u=ajax.delete_fav",
                data: {
                    uids: favId
                },
                success: function(ret) {
                    console.log("delete Favorite ret >>>", ret);
                    if (ret.data && ret.data != 0) {
                        wx.showToast({
                            title: "移出收藏",
                            success: function() {
                                that.onLoad(options);
                                that.setData({hasCollect: false});
                            }
                        })
                    }
                }
            });
        }
    },
    
    // 加入购物车
    bindAddCart: function() {
        var that = this;
        var localData = that.data;
        var id = localData.goodId,
            specialKey = localData.specialKey,
            specials = localData.specials,
            selectedNum = localData.selectedNum,
            detailData = localData.detail,
            price = localData.price;
        var hasGood = false;

        // 微信小程序本地存储
        var good = {
            specialKey: specialKey,
            specials: specials,
            selectedNum: selectedNum,
            detailData: detailData,
            price: price
        };

        if (selectedNum <= 0) {
            wx.showToast({
                icon: 'loading',
                title: '已售罄'
            });
        } else {
            // 检查本地数据是否含有购物车信息
            var cart = wx.getStorageSync("cart");
            console.log("local cart >>>", cart);

            // 本地购物车为空
            if (cart === "") {
                cart = {};
                cart.list = [];
                cart.list.push(good);
            } else {
                // cart.list.push(good);
                cart.list.forEach(function(ele) {
                    if (ele.detailData.uid === good.detailData.uid && ele.specialKey === good.specialKey) {
                        ele.selectedNum += selectedNum;
                        hasGood = true;
                    }
                });

                if (!hasGood) {
                    cart.list.push(good);
                }
            }

            wx.setStorage({
                key: "cart",
                data: cart,
                success: function() {
                    that.tapShadow();
                    wx.showToast({
                        title: "添加成功"
                    });
                }
            });
        }
    },

    // 点击阴影部分，关闭选择规格页
    tapShadow: function() {
        var that = this;
        that.setData({
            isSelect: false
        });
    },

    // 打开选择规格页面
    showSelect: function() {
        var that = this;
        that.setData({
            isSelect: true
        });
    },

    // 查看全部评论
    viewComments: function() {
        var sliderOffset = this.data.navboxWidth / this.data.tabs.length;

        this.setData({
            sliderOffset: sliderOffset,
            activeIndex: 1
        });
    },

    // 前往购物车页面
    navToCart: function() {
        wx.switchTab({
            url: "/page/cart/cart"
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

    // 开团
    findGroup: function() {
        var that = this;

        // 获取需要存储的数据
        var detail = that.data.detail;
        // var price = that.data.price;
        // 团购价
        var price = detail.group_price;
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
            specialKey: specialKey,
            goUid: 0
        };

        if (selectedNum >= 1) {
            order.list.push(goodOrder);

            // 将选中的订单存入本地
            wx.setStorage({
                key: "groupOrder",
                data: order
            });

            wx.navigateTo({
                url: "../groupOrder/groupOrder"
            });
        } else {
            wx.showToast({
                icon: 'loading',
                title: '已售罄'
            });
        }
    },

    // 点击导航项
    tabClick: function (e) {
        this.setData({
            sliderOffset: e.currentTarget.offsetLeft,
            activeIndex: e.currentTarget.id
        });
    },

    // 分享商品页面
    onShareAppMessage: function (res) {
        var goodDetail = this.data.detail;

        return {
            title: app.globalData.userInfo.nickName + '给你分享了一个宝贝 '+ goodDetail.title,
            path: '/page/class/pages/goodDetail/goodDetail?parentId=' + app.globalData.su_uid + "&uid=" + goodDetail.uid,
            success: function(res) {
            // 转发成功
            },
            fail: function(res) {
            // 转发失败
            }
        }
    },
});
