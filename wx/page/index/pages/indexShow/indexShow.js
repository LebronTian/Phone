// page/index/pages/indexShow/indexShow.js
var app = getApp();

Page({

    /**
     * 页面的初始数据
     */
    data: {
        markers: [{
            iconPath: "/page/resources/pic/loc_purple.png",
            id: 0,
            latitude: 23.099994,
            longitude: 113.324520,
            width: 20,
            height: 20,
            callout: {
                content: "callout content",
                color: "#ccc",
                borderRadius: 10,
                bgColor: "#333",
                padding: 5,
                display: "ALWAYS",
                textAlign: "center",
            }
        }],

        controls: [{
            id: 1,
            iconPath: '/page/resources/pic/navigator.png',
            position: {
                left: 0,
                top: 300 - 40,
                width: 40,
                height: 40
            },
            clickable: true
        }],

        listByCat: {},
    },

    
    onLoad: function (options) {
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
        this.setData({
            mainColor: app.globalData.main_color,
            options:options
        });

        // 获取商家基本信息
        this.getBasicInfo();
        // 获取轮播图
        this.getSwiper();
        // 获取所有分类
        this.getAllCats();
        // 获取文案列表
        // this.getArticleList();
    },

    onShow: function () {
    
    },

    // 获取基本信息（logo）
    getBasicInfo: function() {
        var that = this,
            markers = that.data.markers;

        app.request({
            url: "_a=site&_u=ajax.site",
            success: (ret)=>{
                console.log("getBasicInfo ret >>>", ret);
                var shopInfo = ret.data;
                var img = shopInfo.logo;

                markers[0].callout.content = shopInfo.title;

                shopInfo.logo = img.startsWith("http") ? img : app.globalData.prefix_url + img;
                that.setData({
                    shopInfo: shopInfo,
                    markers: markers
                });
            }
        });
    },

    getSwiper: function() {
        var that = this;

        // 获取首页头部轮播图
        app.request({
            url: "_a=site&_u=ajax.slides",
            success: function(ret) {
                console.log("background ret >>>>>", ret);
                var sliders = ret.data;
                sliders.forEach(function(ele) {
                    if (ele.image && !ele.image.startsWith('http')) ele.image = app.globalData.prefix_url + ele.image;
                });
                that.setData({
                    background: sliders
                });
            }
        });
    },

    // 获取所有分类
    getAllCats: function() {
        var that = this;

        app.request({
            url: "_a=site&_u=ajax.cats",
            success: (ret)=>{
                console.log("catlist ret >>>>", ret);
                var list = ret.data,
                    catlist = [];
                list.forEach(function(ele) {
                    if (ele.parent_uid == 0) {
                        let img = ele.image;
                        ele.image = img.startsWith("http") ? img : (app.globalData.prefix_url + img);
                        catlist.push(ele);
                        that.getArticleList(ele.uid);
                    }
                });
                that.setData({
                    subNavs: catlist
                });
            }
        });
    },

    // 获取文章列表
    getArticleList: function(catId) {
        var that = this,
            listByCat = that.data.listByCat;

        app.request({
            // _a=site&_u=ajax.article
            url: "_a=site&_u=ajax.article_list",
            data: {
                cat_uid: catId,
                limit: 6
            },
            success: (ret)=>{
                console.log("article_lis ret >>>>", ret);
                var articleList = ret.data.list;
                articleList.forEach(function(ele) {
                    let img = ele.image;
                    ele.img = img.startsWith("http") ? img : (app.globalData.prefix_url + img);
                });
                listByCat[catId] = articleList

                that.setData({
                    listByCat: listByCat
                });
            }
        });
    },


    // 点击导航控件
    controltap: function(e) {
        console.log("control tap e >>>", e);
        var shopInfo = this.data.shopInfo,
            latitude = parseFloat(shopInfo.more_info.latitude),
            longitude = parseFloat(shopInfo.more_info.longitude);

        wx.openLocation({  
            latitude: latitude,
            longitude: longitude,
            scale: 18,
            name: shopInfo.title,
            address: shopInfo.location
        });
    },

    subNavTap: function(e) {
        var classId = e.currentTarget.dataset.id;

        wx.navigateTo({
            url: "../articleClass/articleClass?classId=" + classId
        });
    },

    submitInfo: function(e) {
        console.log("post e >>", e);
        var info = e.detail.value;
        var contact = info.phone ? info.phone : "";
        if (!info.textarea) {
            wx.showModal({
                title: "温馨提示",
                content: "请输入建议内容",
                showCancel: false
            });
            return;
        }
        app.request({
            url: "_a=site&_u=ajax.add_message",
            data: {
                brief: info.textarea,
                contact: contact
            },
            success:(ret)=>{
                if (ret.data.errstr == "ERROR_OK") {
                    wx.showToast({
                        title: "提交成功"
                    });
                }
            }
        });
    },

    onPullDownRefresh: function () {
    
    },

    onShareAppMessage: function () {
    
    }
})