// page/index/pages/articleClass/articleClass.js
var app = getApp()

Page({
    data: {
        mainColor: app.globalData.main_color,
        tabs: [],
        activeIndex: 0,
        sliderOffset: 0,
        sliderLeft: 0,
        sliderWidth: 0,
        navboxWidth: 0,
        navWidth: 0,

        // 二级分类
        activeSubIndex: 0,
        subclass: [],
        subIndex: 0,

        // 所有商品缓存
        allGoods: {},
        // 商品页面数据
        id2page: {}
    },
    onLoad: function (options) {
        var that = this;
        this.setData({
            mainColor: app.globalData.main_color,
            options: options
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });

        that.getClass();
    },

    getClass: function(cb) {
        var that = this;

        // 获取文案分类数据
        app.request({
            url: "_a=site&_u=ajax.cats",
            success: function(ret) {
                if (typeof(cb) === "function") {
                    cb(ret);
                } else {
                    that.getClassCb(ret);
                }
            }
        });
    },
    getClassCb: function(ret) {
        var that = this,
            classId = that.data.options.classId,
            catList = [{uid: classId, title: "全部", subClassList:[]}],
            allCats = ret.data,
            id2page = that.data.id2page;

        allCats.forEach(function(ele) {
            id2page[ele.uid] = 0;
            if (ele.parent_uid == classId) {
                ele.subClassList = [];
                catList.push(ele);
            }
        });
        
        // 取出一级分类
        // allCats.forEach(function(ele) {
        //     id2page[ele.uid] = 0;
        //     if (ele.parent_uid == '0') {
        //         ele.subClassList = [];
        //         catList.push(ele);
        //     }
        // });

        console.log("id2page initial = ", id2page);

        // 为各个一级分类添加二级分类
        // allCats.forEach(function(ele) {
        //     catList.forEach(function(cat) {
        //         if (ele.parent_uid == cat.uid) {
        //             cat.subClassList.push(ele);
        //         }
        //     });
        // });

        console.log("catList >>>", catList);
        if (catList[0].subClassList.length == 0) {
            that.getGoodsByCat(catList[0].uid, 0);

            that.setData({
                activeSubIndex: -1
            });
        } else {
            that.getGoodsByCat(catList[0].subClassList[0].uid, 0);

            that.setData({
                activeSubIndex: catList[0].subClassList[0].uid,
                subclass: catList[0].subClassList
            });
        }

        that.setData({
            tabs: catList,
            activeIndex: catList[0].uid,
            id2page: id2page
        });

        that.setNavigation();
    },

    // 设置导航条
    setNavigation: function() {
        var that = this;

        // 顶部导航条
        var tabNums = that.data.tabs.length;
        console.log("tabNums >>>>>", tabNums);
        var sliderWidth,
            sliderLeft,
            sliderOffset,
            navboxWidth,
            navWidth;
        
        if (tabNums < 5) {
            sliderWidth = 96;

            wx.getSystemInfo({
                success: function(res) {
                    sliderLeft = (res.windowWidth / tabNums - sliderWidth) / 2;
                    sliderOffset = 0;
                    navboxWidth = res.windowWidth;
                    navWidth = 2 * res.windowWidth / tabNums;
                }
            });
        } else {
            sliderWidth = 65;
            sliderLeft = (75 - sliderWidth) / 2;
            sliderOffset = 0;
            navboxWidth = tabNums * 75;
            navWidth = 150;
        }

        that.setData({
            sliderWidth: sliderWidth,
            sliderLeft: sliderLeft,
            sliderOffset: sliderOffset,
            navboxWidth: navboxWidth,
            navWidth: navWidth
        });
    },

    // 点击一级分类事件
    tabClick: function (e) {
        var that = this;

        var id = e.currentTarget.id;
        var catList = that.data.tabs;

        catList.forEach(function(ele) {
            if (ele.uid == id) {
                if (ele.subClassList.length == 0) {
                    that.getGoodsByCat(ele.uid, 0);

                    that.setData({
                        activeSubIndex: -1
                    });
                } else {
                    that.getGoodsByCat(ele.subClassList[0].uid, 0);

                    that.setData({
                        activeSubIndex: ele.subClassList[0].uid
                    });
                }
                that.setData({
                    subclass: ele.subClassList
                });
            }
        });

        this.setData({
            sliderOffset: e.currentTarget.offsetLeft,
            activeIndex: id
        });
    },

    // 点击二级分类
    tapSubClass: function(e) {
        var that = this;

        var subId = e.currentTarget.id;
        var catList = that.data.tabs;

        that.getGoodsByCat(subId, 0);

        that.setData({
            activeSubIndex: subId
        });
    },

    // 通过分类id获取商品函数
    getGoodsByCat: function(catId, page) {
        var that = this;
        var allGoods = that.data.allGoods;
        // var id2page = that.data.id2page;

        if (allGoods[catId]) {
            that.setData({
                goodsList: allGoods[catId],
            });
        } else {
            // 获取分类商品请求
            app.request({
                url: "_a=site&_u=ajax.article_list",
                data: {
                    cat_uid : catId,
                    // limit: 2,
                    page: page
                },
                success: function(res) {
                    console.log("first get goods, page = ", page);
                    console.log("cat id = ", catId);
                    console.log("getGoodsByCat ret >>>", res);
                    var goods = res.data.list;

                    goods.forEach(function(good) {
                        var img = good.image;
                        good.img = img.startsWith("http") ? img : (app.globalData.prefix_url + img);
                        // good.price /= 100;
                    });

                    if (page > 1) {
                        var goodsList = that.data.goodsList;
                        goods = goodsList.concat(goods);
                    }

                    allGoods[catId] = goods;
                    console.log("first get goods, goodsList = ", goods);
                    console.log("first get goods, allGoods = ", allGoods);
                    
                    that.setData({
                        goodsList: goods,
                        allGoods: allGoods
                    });

                    // console.log("article_lis ret >>>>", ret);
                    // var articleList = ret.data.list;
                    // articleList.forEach(function(ele) {
                    //     let img = ele.image;
                    //     ele.img = img.startsWith("http") ? img : (app.globalData.prefix_url + img);
                    // });
                    // listByCat[catId] = articleList

                    // that.setData({
                    //     listByCat: listByCat
                    // });
                }
            });
        }
    },

    // 上拉加载
    onReachBottom: function() {
        var that = this;

        var goodsList = that.data.goodsList,
            activeIndex = that.data.activeIndex,
            activeSubIndex = that.data.activeSubIndex,
            allGoods = that.data.allGoods,
            id2page = that.data.id2page,
            page,
            catId;
        
        console.log("onReachBottom id2page >>>", id2page);

        if (activeSubIndex == -1) {
            page = ++id2page[activeIndex];
            // that.getGoodsByCat(activeIndex, page);
            catId = activeIndex;
            console.log("reach bottom activeIndex = ", activeIndex);
            console.log("reach bottom page = ", page);
        } else {
            page = ++id2page[activeSubIndex];
            // that.getGoodsByCat(activeSubIndex, page);
            catId = activeSubIndex;
            console.log("reach bottom activeSubIndex = ", activeSubIndex);
            console.log("reach bottom page = ", page);
        }

        // 获取分类商品请求
        app.request({
            url: "_a=shop&_u=ajax.products",
            data: {
                cat_uid : catId,
                // limit: 2,
                page: page
            },
            success: function(res) {
                console.log("on reach bottom page >>>", page);
                console.log("cat id = ", catId);
                console.log("reach bottom getGoodsByCat ret >>>", res);
                var goods = res.data.list;

                goods.forEach(function(good) {
                    var img = good.main_img;
                    good.img = img.startsWith("http") ? img : (app.globalData.prefix_url + img);
                    good.price /= 100;
                });

                var goodsList = that.data.goodsList;
                goods = goodsList.concat(goods);

                allGoods[catId] = goods;

                console.log("reach bottom, goodsList = ", goods);
                console.log("reach bottom, allGoods = ", allGoods);
                
                that.setData({
                    goodsList: goods,
                    allGoods: allGoods
                });
            }
        });

        that.setData({
            id2page: id2page
        });
    }

});

