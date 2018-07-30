var app = getApp()

Page({
    data: {
        mainColor: app.globalData.main_color,
        tabs: [],
        selectedTab: {},

        // 二级分类
        subClassList: [],
        subIndex: 0,

        // 商品列表数据
        goodsList: [],

        showEmpty: false,

        // 商品页面数据
        // id2page: {}
    },
    onLoad: function (option) {
        var that = this;
        this.setData({
            mainColor: app.globalData.main_color
			,activeIndex: option.activeIndex
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });

        that.getClass();
    },

    getClass: function(cb) {
        var that = this;

        // 获取商品分类数据
        app.request({
            url: "_a=shop&_u=ajax.product_cats",
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
        var that = this;
        var catList = [];
        var allCats = ret.data;
        // var id2page = that.data.id2page;
        
        // 取出一级分类
        allCats.forEach(function(ele) {
            var img = ele.image;
            ele.img = !img || img.startsWith("http") ? img : (app.globalData.prefix_url + img);

            // id2page[ele.uid] = 0;
            if (ele.parent_uid == '0') {
                ele.subClassList = [];
                catList.push(ele);
            }
        });

        console.log("all class = ", ret);

        // 为各个一级分类添加二级分类
        allCats.forEach(function(ele) {
            catList.forEach(function(cat) {
                if (ele.parent_uid == cat.uid) {
                    cat.subClassList.push(ele);
                }
            });
        });

        console.log("catList >>>", catList);

		if(catList && catList[0]) {
            that.setData({
                tabs: catList
            });
            that.handleClassData(catList[0]);
		}

        that.setNavigation();
    },

    // 通过分类id获取商品函数
    getGoodsByCat: function(catId) {
        var that = this,
            catList = this.data.tabs;
        
        app.request({
            url: "_a=shop&_u=ajax.products",
            data: {
                cat_uid : catId,
                limit: -1,
                // page: page
            },
            success: function(res) {
                // console.log("first get goods, page = ", page);
                console.log("getGoodsByCat ret >>>", res);
                var goods = res.data.list;

                goods.forEach(function(good) {
                    var img = good.main_img;
                    good.img = img.startsWith("http") ? img : (app.globalData.prefix_url + img);
                    good.price /= 100;
                });

                catList.forEach(function(cat) {
                    if (cat.uid == catId) {
                        cat.classGoods = goods;
                    }
                });

                // if (page > 1) {
                //     var goodsList = that.data.goodsList;
                //     goods = goodsList.concat(goods);
                // }

                console.log("first get goods, goodsList = ", goods);

                that.setData({
                    goodsList: goods,
                    tabs: catList
                });
                
                // that.setData({
                //     goodsList: goods,
                //     allGoods: allGoods
                // });
            }
        });
    },

    // 设置导航条
    setNavigation: function() {
        var that = this;

        // 顶部导航条
        var tabNums = that.data.tabs.length;
        console.log("tabNums >>>>>", tabNums);
        var windowHeight;

        wx.getSystemInfo({
            success: function(res) {
                that.setData({
                    windowHeight: res.windowHeight
                });
            }
        });
    },

    // 点击一级分类事件
    tabClick: function (e) {
        var that = this;

        var id = e.currentTarget.id;
        var catList = that.data.tabs;
        var classImg = "";
        var subClassList = null;

		//全部分类 
		if(!id) return;

        console.log(id);
        console.log(catList);

        catList.forEach(function(ele) {
            if (ele.uid == id) {
				if(ele.title == '超值推荐') {
					wx.navigateTo({url: '../classGoods/classGoods?info=128'});
					return;
				}

                that.handleClassData(ele);
            }
        });
    },

    // 处理分类显示内容数据
    handleClassData: function(cat) {
        var classImg = cat.img;
        if (cat.subClassList && cat.subClassList.length) {
            this.setData({
                classImg: classImg,
                subClassList: cat.subClassList,
                goodsList: [],
                activeIndex: cat.uid
            });
        } else if (cat.classGoods && cat.classGoods.length) {
            this.setData({
                classImg: classImg,
                subClassList: [],
                goodsList: cat.classGoods,
                activeIndex: cat.uid
            });
        } else {
            this.setData({
                classImg: classImg,
                subClassList: [],
                activeIndex: cat.uid
            });
            this.getGoodsByCat(cat.uid);
        }
    },

});

