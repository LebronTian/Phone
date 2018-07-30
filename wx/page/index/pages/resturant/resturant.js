var app = getApp();
var util = require('../../../../utils/util.js');
var heightArr = [];

Page({

    data: {
        mainColor: app.globalData.main_color,
        // catList: []
        activeIndex: 'sub101',
		catList: [],

        otherClass: {
            uid: '0',
            list: [],
            title: '其它'
        },
        
        totalNum: 0,

        showSpecialsModal: false,
        selectedGood: {},
        specials: [{name: '口味', list: ['微辣', '中辣', '重辣'], selectedIndex: 0}],

        selectedNum: 0,
        totalPrice: 0.00
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
        if (options.uid) {
            // 获取商家数据
            this.getBusiness(options.uid);
        }
        // var businessId = options.uid;
        this.setData({
            options: options
        });

        wx.getSystemInfo({
            success: function(res) {
                that.setData({
                    // windowHeight: res.windowHeight,
                    scrollHeight: res.windowHeight - 151
                });
            }
        });

        // 获取该商家所有商品
        this.getGoods();
    },

    // 获取商家信息
    getBusiness: function(businessId, cb) {
        var that = this;
        app.request({
            url: "_a=shop&_u=biz.ajax_biz_uid",
            data: {
                uid: businessId
            },
            success: function(ret) {
                console.log("business ret >>>", ret);
                if (typeof cb === 'function') {
                    cb(ret);
                } else {
                    var businessData = ret.data;
                    if (!businessData.main_img.startsWith("http")) businessData.main_img = app.globalData.prefix_url + businessData.main_img;
                    that.setData({
                        businessData: businessData
                    });
                }
            }
        });
    },

    // 获取所有商品函数
    getGoods: function() {
        var that = this;
        var businessId = that.data.options.uid;

        // 获取商家在售商品
        app.request({
            url: "_a=shop&_u=ajax.products",
            data: {
                biz_uid : businessId,
                limit: -1
            },
            success: function(ret) {
                console.log("business goods ret >>>", ret);
                var goods = ret.data.list

                goods.forEach(function(good) {
                    if (!good.main_img.startsWith("http")) good.main_img = app.globalData.prefix_url + good.main_img;
                    // good.price /= 100;
                    good.price = parseFloat(good.price/100).toFixed(2);
                    
                    good.selectedNum = 0;
                    good.selectedSpecialKey = "";

                    // 不同规格
                    if (good.sku_table) {
                        // 商品规格
                        // 获取所有规格的名称
                        var specialClass = Object.keys(good.sku_table.table);
                        
                        var specials = [];

                        specialClass.forEach(function(ele) {
                            var special = {
                                name: ele,
                                list: good.sku_table.table[ele],
                                selectedIndex: 0
                            };
                            
                            specials.push(special);
                        });
                        good.specials = specials;
                        // that.calculate(specials);
                    }
                });

                // 获取全部商品分类
                that.getClass(goods);

                that.setData({
                    goods: goods
                });  
            }
        });
    },

    // 获取所有分类
    getClass: function(goods) {
        var that = this;

        app.request({
            url: "_a=shop&_u=ajax.product_cats",
            success: function(res) {
                console.log("all cats >>>", res);
                var catList = [];
                var otherClass = that.data.otherClass;
                res.data.push(otherClass);

                res.data.forEach(function(ele) {
                    // ele.img = app.globalData.prefix_url + ele.image;
                    ele.list = [];

                    goods.forEach(function(good) {
                        if (good.cat_uid === '0') {
                            otherClass.list.push(good);
                        } else if (good.cat_uid == ele.uid) {
                            ele.list.push(good);
                        }
                    });

                    ele.id = "class" + ele.uid;

                    ele.list.length > 0 && catList.push(ele);
                });
                // catList.push(otherClass);

                console.log("cat goods >>>>>", catList);
                that.calculateHeight(catList);

                that.setData({
                    catList: catList,
                    activeIndex: catList[0].id
                });
            }
        });
    },

    // 计算每类产品所占高度
    calculateHeight: function(catList) {
        // var boundaryArr = [];
        var scrollHeight = this.data.scrollHeight;
        var height = 0;

        for (var i = 0; i < catList.length; i++) {
            var newHeight = catList[i].list.length * 100 + 41;
            height += newHeight;

            if (newHeight > scrollHeight || i == catList.length-2) {
                heightArr.push(height - scrollHeight )
            } else {
                heightArr.push(height);
            }
        }
        console.log("height array >>>>", heightArr);
    },

    // 点击分类标题
    tabClick: function(e) {
        var id = e.currentTarget.id;

        this.setData({
            subClassId: id,
            activeIndex: id
        });
        console.log("tab id >>>>>", id);
    },

    // 滑动过程中切换左侧分类选择项
    bindScroll: function(e) {
        // console.log(" scrollTop >>>>>", e.detail.scrollTop);
        // console.log(" scrollTop event >>>>>", e);
        var scrollTop = e.detail.scrollTop;
        for (var i = 0; i < heightArr.length; i++) {
            if (scrollTop < heightArr[i]) {
                var id = this.data.catList[i].id;
                this.setData({
                    activeIndex: id
                });
                return;
            }
        }
    },

    // 选择商品数量
    selectedNumTap: function(e) {
        var that = this;
        var id = e.currentTarget.id.split('-');
        var index = id[0],
            subIndex = id[1],
            method = id[2];

        console.log("select id >>>", id);

        var catList = that.data.catList;
        var good = catList[index]['list'][subIndex];

        if (method === 'add') {
            good.selectedNum++;
            // 库存
        } else if (method === 'sub') {
            good.selectedNum--;
            if (good.selectedNum < 0) good.selectedNum = 0;
        }
        console.log("select good >>>", good);

        that.calculatePrice(catList);
        that.setData({
            catList: catList
        });
    },

    // 选择某规格商品数量
    selectedSpecialNumTap: function(e) {
        var that = this;
        var method = e.currentTarget.id;
        var index = that.data.selectIdxArr[0],
            subIndex = that.data.selectIdxArr[1];

        // console.log("select id >>>", id);

        var catList = that.data.catList;
        var good = catList[index]['list'][subIndex];

        if (method === 'add') {
            good.selectedNum++;
            // 库存
        } else if (method === 'sub') {
            good.selectedNum--;
            if (good.selectedNum < 0) good.selectedNum = 0;
        }
        console.log("select good >>>", good);

        that.calculatePrice(catList);
        that.setData({
            catList: catList,
            selectedGood: good
        });
    },

    // 显示商品规格
    showSpecials: function(e) {
        var id = e.currentTarget.id.split("-");
        var catList = this.data.catList;
        var index = id[0],
            subIndex = id[1];

        var selectedGood = catList[index]['list'][subIndex];

        this.setData({
            showSpecialsModal: true,
            selectedGood: selectedGood,
            specials: selectedGood.specials,
            selectIdxArr: id
        });
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

    // 通过用户选择的规格，获取对应信息
    calculate: function(specials) {
        var that = this;
        var catList = that.data.catList,
            selectIdxArr = that.data.selectIdxArr;
        var detail = catList[selectIdxArr[0]]['list'][selectIdxArr[1]];
        console.log("selectedGood >>>>>", detail);
        var selectedNum = detail.selectedNum;
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

        detail.specials = specials;
        detail.selectSpecial = detail.sku_table.info[selectedSpecialKey];
        detail.selectedSpecialKey = selectedSpecialKey;
        detail.price = detail.selectSpecial.price / 100;
        var quantity = detail.selectSpecial.quantity;
        detail.selectedNum = selectedNum > quantity ? quantity : selectedNum;
        if (quantity > 0) selectedNum = selectedNum == 0 ? 1 : selectedNum;

        // specials：用户挑选的规格；
        that.setData({
            specials: specials,
            // price: price,
            quantity: quantity,
            catList: catList,
            selectedGood: detail
            // specialKey: selectedSpecialKey,
            // selectedNum: selectedNum,
        });
    },

    // 隐藏商品规格
    tapShadow: function() {
        this.setData({
            showSpecialsModal: false
        });
    },

    calculatePrice: function(catList) {
        console.log("catList >>>>>, ", catList);
        var price = 0,
            totalNum = 0;
        catList.forEach(function(cat) {
            cat.list.forEach(function(good) {
                if (good.selectedNum >= 1) {
                    price += good.price * good.selectedNum;
                    totalNum += good.selectedNum;
                }
            });
        });
        console.log("totalPrice >>>", price);

        this.setData({
            totalPrice: parseFloat(price).toFixed(2),
            totalNum: totalNum
        });
    },

    // 加入购物车
    // bindAddCart: function() {
    //     var that = this;
    //     var localData = that.data;
    //     var id = localData.goodId,
    //         specialKey = localData.specialKey,
    //         specials = localData.specials,
    //         selectedNum = localData.selectedNum,
    //         detailData = localData.detail,
    //         price = localData.price;
    //     var hasGood = false;

    //     // 微信小程序本地存储
    //     var good = {
    //         specialKey: specialKey,
    //         specials: specials,
    //         selectedNum: selectedNum,
    //         detailData: detailData,
    //         price: price
    //     };

    //     if (selectedNum <= 0) {
    //         wx.showToast({
    //             icon: 'loading',
    //             title: '已售罄'
    //         });
    //     } else {
    //         // 检查本地数据是否含有购物车信息
    //         var cart = wx.getStorageSync("cart");
    //         console.log("local cart >>>", cart);

    //         // 本地购物车为空
    //         if (cart === "") {
    //             cart = {};
    //             cart.list = [];
    //             cart.list.push(good);
    //         } else {
    //             // cart.list.push(good);
    //             cart.list.forEach(function(ele) {
    //                 if (ele.detailData.uid === good.detailData.uid && ele.specialKey === good.specialKey) {
    //                     ele.selectedNum += selectedNum;
    //                     hasGood = true;
    //                 }
    //             });

    //             if (!hasGood) {
    //                 cart.list.push(good);
    //             }
    //         }

    //         wx.setStorage({
    //             key: "cart",
    //             data: cart,
    //             success: function() {
    //                 that.tapShadow();
    //                 wx.showToast({
    //                     title: "添加成功"
    //                 });
    //             }
    //         });
    //     }
    // },

    // 前往购物车页面
    // navToCart: function() {
    //     wx.switchTab({
    //         url: "/page/cart/cart"
    //     });
    // },

    // 立即购买 前往订单页面
    navToOrder: function() {
        var that = this,
            catList = that.data.catList,
            totalNum = that.data.totalNum;
        if (totalNum <= 0) return;
        console.log("make order catList >>>>", catList);

        var order = {};
        order.list = [];

        catList.forEach(function(cat) {
            cat.list.forEach(function(good) {                
                if (good.selectedNum >= 1) {
                    console.log("make order good >>>>", good);
                    var goodOrder = {
                        detailData: good,
                        price: good.price,
                        selectedNum: good.selectedNum,
                        specials: good.specials,
                        specialKey: good.selectedSpecialKey
                    };
                    order.list.push(goodOrder);
                }
            });
        });

        // 将选中的订单存入本地
        wx.setStorage({
            key: "order",
            data: order
        });

        wx.navigateTo({
            url: "../../../class/pages/order/order"
        });
    },

    onPullDownRefresh: function () {
    
    },

    onShareAppMessage: function () {
    
    }
})
