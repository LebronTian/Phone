var app = getApp();

Page({

    data: {
        businessList: [],
        type: "",

        background: [],
        tabs: [],
        activeIndex: 0,
        sliderOffset: 0,
        sliderLeft: 0,
        sliderWidth: 0,
        navboxWidth: 0,
        navWidth: 0
    },

    onLoad: function (options) {
        var that = this;
        this.setData({
            mainColor: app.globalData.main_color
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
        
        that.getBizCat();
        that.getBizlist(0);
        that.getRecommendList();

        // 获取首页头部轮播图
        app.request({
            url: "_u=common.slides_list&pos=biz1",
            success: function(ret) {
                console.log("background ret >>>>>", ret);
                var sliders = ret.data.list;
                sliders.forEach(function(ele) {
                    if (ele.image && !ele.image.startsWith('http')) ele.image = app.globalData.prefix_url + ele.image;
                });
                that.setData({
                    background: sliders
                });
            }
        });

    },

    onShow: function () {
    
    },

    // 获取商家分类
    getBizCat: function() {
        var that = this;

        app.request({
            url: "_a=shop&_u=ajax.biz_cats",
            success: (ret) => {
                console.log("get business cat ret >>>", ret);
                var tabs = ret.data.unshift({title: "全部"});
                that.setData({
                    tabs: ret.data
                });
                that.initNavigations();
            }
        });
    },

    // 初始化分类导航栏
    initNavigations: function() {
        var that = this;
        var tabNums = that.data.tabs.length;
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
                    sliderOffset = res.windowWidth / tabNums * that.data.activeIndex;
                    navboxWidth = res.windowWidth;
                    navWidth = 2 * res.windowWidth / tabNums;
                }
            });
        } else {
            sliderWidth = 65;
            sliderLeft = (75 - sliderWidth) / 2;
            sliderOffset = 75 * that.data.activeIndex;
            navboxWidth = tabNums * 75;
            navWidth = 100;
        }

        that.setData({
            sliderWidth: sliderWidth,
            sliderLeft: sliderLeft,
            sliderOffset: sliderOffset,
            navboxWidth: navboxWidth,
            navWidth: navWidth
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

    // 获取商家列表
    getBizlist: function(page) {
        var that = this;
        var type = that.data.type;
        if (type == "全部") type = "";

        app.request({
            url: "_a=shop&_u=biz.ajax_bizlist",
            data: {
                type: type,
                limit: 10,
                page: page
            },
            success: function(ret) {
                console.log("business ret >>>", ret);
                var businessList = ret.data.list,
                    len = businessList.length;

                businessList.forEach(function(ele) {
                    if (!ele.main_img.startsWith("http")) ele.main_img = app.globalData.prefix_url + ele.main_img;
                });

                var list = page == 0 ? [] : that.data.businessList;
                list = list.concat(businessList);

                that.setData({
                    businessList: list,
                    page: page,
                    showEmpty: len < 10
                });
                wx.hideLoading();
            }
        });
    },

    // 获取推荐商家列表
    getRecommendList: function() {
        var that = this;
        app.request({
            url: "_a=shop&_u=biz.ajax_bizlist",
            data: {
                limit: -1,
                hadrecommend: 1
            },
            success: (ret)=>{
                console.log("getRecommendList ret >>>", ret);
                var recommendList = ret.data.list;
                recommendList.forEach(function(ele) {
                    if (!ele.main_img.startsWith("http")) ele.main_img = app.globalData.prefix_url + ele.main_img;
                });

                that.setData({
                    recommendList: recommendList
                });
            }
        });
    },

    tabClick: function (e) {
        // wx.showLoading({
        //     title: '加载中',
        // });
        this.setData({
            type: e.currentTarget.dataset.type,
            sliderOffset: e.currentTarget.offsetLeft,
            activeIndex: e.currentTarget.id
        });
        this.getBizlist(0);
    },

    onPullDownRefresh: function () {
    
    },

    onReachBottom: function () {
        var that = this,
            page = that.data.page + 1;

        that.getBizlist(page);
        that.setData({
            page: page
        });
    },

    onShareAppMessage: function () {
    
    }
})
