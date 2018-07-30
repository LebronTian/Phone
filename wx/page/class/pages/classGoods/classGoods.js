var app = getApp();

Page({

    data: {
        showEmpty: true,
        // page: 0,
        allGoods: {},
        goodsList: [],
        sortBtns: [{
            id: 'default',
            title: '综合排序',
            selected: true,
            argNum: 0
        }
        ,{
            id: 'priceToHigh',
            title: '价格从低到高',
            selected: false,
            argNum: 13
        }
        ,{
            id: 'priceToLow',
            title: '价格从高到低',
            selected: false,
            argNum: 14
        }
        ,{
            id: 'sellCnt',
            title: '销售量',
            selected: false,
            argNum: 12
        }],
        // sortMode: 'default',
        sortModeTitle: '综合排序',

        selectedIndex: 0,
        siftInfo: 0,
        sort: 0,

        showShadow: false,
        showSortBtn: false
    },

    onLoad: function (options) {
        this.setData({
            mainColor: app.globalData.main_color
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
        var classId = options.classId;
        var siftInfo = options.info || 0;  // 64||128

        if (siftInfo == 128) {
            this.setData({
                selectedIndex: 2
            });
        } else if (siftInfo == 64) {
            this.setData({
                selectedIndex: 3
            });
        }

        this.setData({
            classId: classId,
            siftInfo: siftInfo,
        });

        // this.getGoodsByCat(classId, 0);
        this.getGoods(0, siftInfo);
    },

    onShow: function () {

    },

    // 根据筛选条件获取商品
    getGoods: function(sort, siftInfo) {
        var that = this,
            catId = that.data.classId;

        app.request({
            url: '_a=shop&_u=ajax.products',
            data: {
                cat_uid: catId,
                sort: sort,
                info: siftInfo,
                // page: page
                limit: -1
            },
            success: (res) => {
                // console.log("get goods, page = ", page);
                console.log("cat id = ", catId);
                console.log("getGoodsByCat ret >>>", res);
                var goods = res.data.list;
                // if (goods.length < 10) {
                //     that.setData({
                //         showEmpty: true
                //     });
                // }

                goods.forEach(function(good) {
                    var img = good.main_img;
                    good.img = img.startsWith("http") ? img : (app.globalData.prefix_url + img);
                    good.price = parseFloat(good.price/100).toFixed(2);
                });

                var allGoods = that.data.allGoods,
                    key = sort + '-' + siftInfo;

                allGoods[key] = goods;

                // allGoods = allGoods.concat(goods);
                // allGoods[]
                // goodsList = goodsList.concat(goods);

                // console.log("first get goods, goodsList = ", goodsList);
                // var sortMode = that.data.sortMode;
                // var siftInfo = that.data.siftInfo;
                // goodsList = that.sortGoods(goodsList, sortMode);
                // if (!!siftInfo) goodsList = that.siftGoods(goodsList);
                // if (goodsList.length - originLength === 0) {
                //     that.setData({
                //         showEmpty: true
                //     });
                // }
                console.log("show goods >>>>", goods);
                console.log("all goods >>>>", allGoods);
                that.setData({
                    goodsList: goods,
                    allGoods: allGoods
                });
            }
        });
    },

    // 通过分类id获取商品函数
    getGoodsByCat: function(catId, page) {
        var that = this;
        
        app.request({
            url: "_a=shop&_u=ajax.products",
            data: {
                cat_uid : catId,
                limit: 10,
                page: page
            },
            success: function(res) {
                console.log("get goods, page = ", page);
                console.log("cat id = ", catId);
                console.log("getGoodsByCat ret >>>", res);
                var goods = res.data.list;
                if (goods.length < 10) {
                    that.setData({
                        showEmpty: true
                    });
                }

                goods.forEach(function(good) {
                    var img = good.main_img;
                    good.img = img.startsWith("http") ? img : (app.globalData.prefix_url + img);
                    
                    good.price = parseFloat(good.price/100).toFixed(2);
                });

                var goodsList = that.data.goodsList;
                var originLength = goodsList.length;
                var allGoods = that.data.allGoods;

                allGoods = allGoods.concat(goods);
                goodsList = goodsList.concat(goods);

                console.log("first get goods, goodsList = ", goodsList);
                var sortMode = that.data.sortMode;
                var siftInfo = that.data.siftInfo;
                goodsList = that.sortGoods(goodsList, sortMode);
                if (!!siftInfo) goodsList = that.siftGoods(goodsList);
                if (goodsList.length - originLength === 0) {
                    that.setData({
                        showEmpty: true
                    });
                }
                console.log("show goods >>>>", goodsList);
                console.log("all goods >>>>", allGoods);
                that.setData({
                    goodsList: goodsList,
                    allGoods: allGoods
                });
            }
        });
    },

    // 筛选商品按钮
    siftTap: function(e) {
        var that = this,
            siftInfo = e.currentTarget.id,
            sort = that.data.sort,
            // sortMode = that.data.sortMode,
            allGoods = this.data.allGoods;
        // allGoods = this.sortGoods(goodsList, sortMode);

        // var siftedList = [];
        var key = sort + '-' + siftInfo;
        if (!allGoods[key]) {
            this.getGoods(sort, siftInfo);
        } else {
            this.setData({
                goodsList: allGoods[key]
            });
        }

        if (siftInfo == 0) {
            this.setData({
                selectedIndex: 1,
                siftInfo: 0,
                // goodsList: goodsList
            });
        } else if (siftInfo == 128) {
            // goodsList.forEach(function(ele) {
            //     ele.info == 128 && (siftedList.push(ele));
            // });
            this.setData({
                selectedIndex: 2,
                siftInfo: 128,
                // goodsList: siftedList
            });
        } else if (siftInfo == 64) {
            // goodsList.forEach(function(ele) {
            //     ele.info == 64 && (siftedList.push(ele));
            // });
            this.setData({
                selectedIndex: 3,
                siftInfo: 64,
                // goodsList: siftedList
            });
        }
    },

    // 打开商品排序按钮
    openSort: function() {
        var showSortBtn = !this.data.showSortBtn;
        var showShadow = !this.data.showShadow;

        this.setData({
            showSortBtn: showSortBtn,
            showShadow: showShadow
        });
    },

    tapShadow: function() {
        this.setData({
            showSortBtn: false,
            showShadow: false
        });
    },

    // sortGoods: function(goods, sortMode) {
    //     // var sortMode = this.data.sortMode;
    //     switch(sortMode) {
    //         case 'default':
    //             goods = goods.sort(function(a, b) {
    //                 return parseInt(b.sort) - parseInt(a.sort);
    //             });
    //             break;
    //         case 'priceToHigh':
    //             goods = goods.sort(function(a, b) {
    //                 return parseInt(a.price) - parseInt(b.price);
    //             });
    //             break;
    //         case 'priceToLow':
    //             goods = goods.sort(function(a, b) {
    //                 return parseInt(b.price) - parseInt(a.price);
    //             });
    //             break;
    //         case 'sellCnt':
    //             goods = goods.sort(function(a, b) {
    //                 return parseInt(b.sell_cnt) - parseInt(a.sell_cnt);
    //             });
    //             break;
    //     }
    //     this.setData({
    //         showShadow: false,
    //         showSortBtn: false,
    //         // selectedIndex: 0
    //     });

    //     return goods;
    // },

    // siftGoods: function(goods) {
    //     // var sortMode = this.data.sortMode;
    //     var siftInfo = this.data.siftInfo;
    //     var siftedList = [];

    //     goods.forEach(function(ele) {
    //         ele.info == siftInfo && (siftedList.push(ele));
    //     });

    //     console.log("siftInfo >>>", siftInfo);
        
    //     // this.setData({
    //     //     siftInfo: siftInfo
    //     // });

    //     return siftedList;
    // },

    sortTap: function(e) {
        var mode = this.data.sortBtns[parseInt(e.currentTarget.id)],
            allGoods = this.data.allGoods,
            sortBtns = this.data.sortBtns,
            sort = mode.argNum,
            siftInfo = this.data.siftInfo;

        sortBtns.forEach(function(ele) {
            ele.selected = false;
            if (ele.id === mode) ele.selected = true;
        });

        var key = sort + '-' + siftInfo;
        if (!allGoods[key]) {
            this.getGoods(sort, siftInfo);
        } else {
            this.setData({
                goodsList: allGoods[key]
            });
        }

        this.setData({
            // sortMode: mode.id,
            sortModeTitle: mode.title,
            // goodsList: goodsList,
            sortBtns: sortBtns,
            sort: sort,
            showShadow: false,
            showSortBtn: false,
            selectedIndex: 0
        });
    },

    onPullDownRefresh: function () {
    
    },

    onReachBottom: function () {
        // var page = this.data.page + 1;
        // var classId = this.data.classId;
        // this.setData({
        //     page: page
        // });
        // this.getGoodsByCat(classId, page);
    },

    onShareAppMessage: function () {
    
    }
})