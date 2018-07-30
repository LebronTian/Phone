// page/class/pages/biddingList/biddingList.js
var app = getApp();
var util = require('../../../../utils/util.js')

Page({
    data: {
        showEmpty: true,
        // page: 0,
        allGoods: {},
        allCats: [],
        selectClassId: 0,
        allBrands: [],
        selectBrandId: 0,
        allSubCats: [],
        selectSubClassId: 0,
        region: ['全部', '全部', '全部'],
        goodsList: [],
        sortModeTitle: '综合排序',

        priceUnit: '元',

        // 筛选信息
        moreSiftData: {},

        selectedIndex: 1,
        siftInfo: 0,
        sort: 0,

        showShadow: false,
        showBigShadow: false,
        showSortBtn: false,
        showMoreSort: false
    },

    onLoad: function (options) {
        this.setData({
            mainColor: app.globalData.main_color
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });

        var that = this;
        var moreSiftData = {};
        moreSiftData.classId = options.classId || 0;

        // 设置侧栏滑动框高度
        wx.getSystemInfo({
            success: function(res) {
                var windowHeight = res.windowHeight;
                var asideHeight = parseInt(windowHeight * 0.85);

                that.setData({
                    asideHeight: asideHeight
                });
            }
        });

        this.setData({
            moreSiftData
        });

        this.getBiddingGoods();
        // this.getGoods();

        // 获取商品所有一级分类
        this.getAllCats();
        // 获取商品所有品牌
        this.getAllBrands();
    },

    onShow: function () {

    },

    // 获取商品所有一级分类
    getAllCats: function(parent_uid) {
        let that = this;

        app.request({
            url: "_a=shop&_u=ajax.product_cats_by_parent_uid",
            data: {parent_uid},
            success: (ret)=>{
                console.log("all cats ret >>>", ret);
                if (ret && ret.data.length) {
                    if (parent_uid) {
                        that.setData({
                            allSubCats: ret.data
                        });
                    } else if (!parent_uid) {
                        that.setData({
                            allCats: ret.data
                        });
                    }
                }
            }
        });
    },
    // 获取商品所有品牌
    getAllBrands: function() {
        let that = this;

        app.request({
            url: "_a=shop&_u=ajax.brand_list",
            data: {
            },
            success: (ret)=>{
                console.log("all brands ret >>>", ret);
                if (ret && ret.data && ret.data.length) {
                    that.setData({
                        allBrands: ret.data
                    });
                }
            }
        });
    },

    // 选择商品品牌
    selectBrand: function(e) {
        let selectBrandId = e.currentTarget.dataset.id,
            originId = this.data.selectBrandId,
            moreSiftData = this.data.moreSiftData;
        if (selectBrandId == originId) {
            selectBrandId = 0;
        }
        moreSiftData.brand_uid = selectBrandId;

        this.setData({
            selectBrandId,
            moreSiftData
        });

        this.getBiddingGoods(0, null, moreSiftData);
    },
    // 选择一级分类
    selectClass: function(e) {
        console.log(e)
        let selectClassId = e.currentTarget.dataset.id,
            originId = this.data.selectClassId,
            moreSiftData = this.data.moreSiftData;

        if (selectClassId == originId) {
            selectClassId = 0;
            this.setData({ allSubCats: [] });
        } else {
            this.getAllCats(selectClassId);
        }

        moreSiftData.classId = selectClassId;

        this.setData({
            selectClassId,
            moreSiftData
        });

        this.getBiddingGoods(0, null, moreSiftData);
    },
    // 选择二级分类
    selectSubClass: function(e) {
        let selectSubClassId = e.currentTarget.dataset.id,
            originId = this.data.selectSubClassId,
            moreSiftData = this.data.moreSiftData;

        if (selectSubClassId == originId) {
            selectSubClassId = 0;
            moreSiftData.classId = this.data.selectClassId;
        } else {
            moreSiftData.classId = selectSubClassId;
        }

        this.setData({
            selectSubClassId,
            moreSiftData
        });

        this.getBiddingGoods(0, null, moreSiftData);
    },
    // 选择区域
    bindRegionChange: function (e) {
        console.log(e);
        let moreSiftData = this.data.moreSiftData,
            locationArr = e.detail.value;

        for (var i = 0; i < locationArr.length; i++) {
            if (locationArr[i] == '全部') {
                locationArr[i] = '';
            }
        }
        // location = location.replace(/全部/g, '');
        moreSiftData.location = locationArr;

        this.setData({
            region: e.detail.value
        });

        this.getBiddingGoods(0, null, moreSiftData);
    },
    // 重置所有筛选选择
    resetSort: function() {
        this.setData({
            selectClassId: 0,
            selectBrandId: 0,
            selectSubClassId: 0,
            allSubCats: [],
            region: ['全部', '全部', '全部'],
            moreSiftData: {}
        });

        this.getBiddingGoods(0, 0, null);
    },

    // getGoods: function() {
    //     let that = this;

    //     app.request({
    //         url: '_a=auction&_u=ajax.itemlist',
    //         success: (res) => {
    //             console.log("get bidding Goods ret >>>", res);
    //             let goods = res.data.list,
    //                 goodsList = that.data.goodsList;

    //             let now = parseInt(new Date().getTime()/1000);

    //             if (!goods) {
    //                 goods = [];
    //             } else {
    //                 goods.forEach(function(good) {
    //                     let img = good.ap.image,
    //                         price = 0,
    //                         priceUnit = '元';

    //                     good.img = img.startsWith("http") ? img : (app.globalData.prefix_url + img);

    //                     // 处理拍卖时间
    //                     if (good.last_time == 0) {
    //                         good.last_time = '无限期';
    //                     } else {
    //                         let time = util.formatTime(good.last_time);
    //                         // good.last_time = [time[0], '年', time[1], '月', time[2], '日'].join('');
    //                         good.last_time = time.join('-');
    //                     }

    //                     // 处理开始时间
    //                     if (now < good.start_time) {
    //                         // 未开始
    //                         good.hasStart = false;
    //                         let time = util.formatTime(good.start_time);
    //                         good.startTime = [time[1], '月', time[2], '日', time[3]].join('');
    //                     } else {
    //                         good.hasStart = true;
    //                     }

    //                     // 处理拍卖价格
    //                     if (good.last_price == 0) {
    //                         price = parseInt(good.ap.min_price/100);
    //                         price = formatPrice(price);
    //                     } else {
    //                         price = parseInt(good.last_price/100);
    //                         price = formatPrice(price);
    //                     }

    //                     good.last_price = price;
    //                     good.priceUnit = priceUnit;
    //                 });
    //             }

    //             goodsList = goodsList.concat(goods);

    //             that.setData({
    //                 goodsList
    //             });
    //         }
    //     });
    // },

    // 根据筛选条件获取竞价商品
    getBiddingGoods: function(page, bid_type, moreSiftData) {
        let that = this,
            brand_uid = 0,
            cat_uid = [],
            address = [];

        page = page || 0;
        bid_type = bid_type || this.data.siftInfo;

        if (moreSiftData) {
            brand_uid = moreSiftData.brand_uid || 0;
            cat_uid = moreSiftData.classId ? [moreSiftData.classId] : [];
            address = moreSiftData.location || [];
        }

        app.request({
            url: '_a=auction&_u=ajax.search_aucitem_list',
            data: {
                brand_uid,
                bid_type,
                cat_uid,
                address,
                page,
                limit: 10
            },
            success: (res) => {
                console.log("get bidding Goods ret >>>", res);
                let goods = res.data.list,
                    goodsList = that.data.goodsList,
                    now = parseInt(new Date().getTime()/1000);

                if (page == 0) goodsList = [];

                if (!goods) {
                    goods = [];
                } else {
                    goods.forEach(function(good) {
                        let img = good.ap.image,
                            price = 0,
                            priceUnit = '元';

                        good.img = img.startsWith("http") ? img : (app.globalData.prefix_url + img);

                        // 处理拍卖时间
                        if (good.last_time == 0) {
                            good.last_time = '无限期';
                        } else {
                            let time = util.formatTime(good.last_time);
                            // good.last_time = [time[0], '年', time[1], '月', time[2], '日'].join('');
                            time.pop();
                            good.last_time = time.join('-');
                        }

                        // 处理开始时间
                        if (now < good.start_time) {
                            // 未开始
                            good.hasStart = false;
                            let time = util.formatTime(good.start_time);
                            // good.startTime = [time[1], '月', time[2], '日', time[3]].join('');
                            good.startTime = [time[1], '-', time[2], '-', time[3]].join('');
                        } else {
                            good.hasStart = true;
                        }

                        // 处理拍卖价格
                        if (good.last_price == 0) {
                            price = util.formatPrice(good.ap.min_price);
                        } else {
                            price = util.formatPrice(good.last_price);
                        }

                        good.last_price = price;
                    });
                }

                goodsList = goodsList.concat(goods);

                that.setData({
                    goodsList,
                    page
                });
            }
        });
    },

    // 筛选商品按钮
    siftTap: function(e) {
        var that = this,
            moreSiftData = this.data.moreSiftData,
            siftInfo = e.currentTarget.id;
            
        this.getBiddingGoods(0, siftInfo, moreSiftData);

        if (siftInfo == 0) {
            this.setData({
                selectedIndex: 1,
                siftInfo
            });
        } else if (siftInfo == 1) {
            this.setData({
                selectedIndex: 2,
                siftInfo
            });
        } else if (siftInfo == 2) {
            this.setData({
                selectedIndex: 3,
                siftInfo
            });
        }
    },

    // 更多筛选
    moreSift: function() {
        var showMoreSort = !this.data.showMoreSort;
        var showBigShadow = !this.data.showBigShadow;

        this.setData({
            showMoreSort: showMoreSort,
            showBigShadow: showBigShadow
        });
    },

    tapShadow: function() {
        this.setData({
            showSortBtn: false,
            showMoreSort: false,
            showShadow: false,
            showBigShadow: false
        });
    },

    preventTouchMove() {},

    onPullDownRefresh: function () {
    
    },

    onReachBottom: function () {
        var page = this.data.page + 1,
            siftInfo = this.data.siftInfo,
            moreSiftData = this.data.moreSiftData;

        this.getBiddingGoods(page, siftInfo, moreSiftData);
    },

    onShareAppMessage: function () {
    
    }
})

// brand_uid=8
// &cat_uid=js数组
// &address=湖南省
// &bid_type=1（1即将结束2即将开始3赛选）