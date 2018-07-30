var app = getApp();
// 输入框进行输入时隐藏搜索结果
Page({

    data: {
        inputVal: "",
        page: 0,
        searchResult: [],
        searchRecord: []
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

        // 获取历史搜索记录
        this.getRecord();
    },

    onShow: function () {

    },

    // 获取历史搜索记录函数
    getRecord: function() {
        var that = this;
        wx.getStorage({
            key: 'search',
            success: function(res) {
                // console.log(res.data)
                var searchData = res.data;
                if (searchData) {
                    that.setData({
                        searchRecord: searchData.list
                    });
                }
            }
        });
    },

    // 输入关键字事件
    inputTyping: function(e) {
        var that = this;
        var searchKey = e.detail.value;

        this.setData({
            inputVal: searchKey
        });

    },

    // 搜素关键字事件
    searchTap: function (e) {
        var that = this;
        var searchKey = e.detail.value;
        var searchRecord = that.data.searchRecord;

        this.setData({
            inputVal: searchKey
        });

        if (searchKey) {
            // 存入搜索历史记录
            if (searchRecord.indexOf(searchKey) == -1) {
                searchRecord.unshift(searchKey);
                var searchData = {};
                searchData.list = searchRecord;

                wx.setStorage({
                    key: "search",
                    data: searchData
                });
            }
            that.searchByKey(searchKey, 0);
        }
    },

    searchByKey: function(searchKey, page) {
        var that = this;

        app.request({
            url: "_a=shop&_u=ajax.products",
            data: {
                key: searchKey,
                // limit: 4,
                page: page
            },
            success: function(ret) {
                var list = ret.data.list;
                var searchResult = page == 0 ? [] : that.data.searchResult;
                
                list.forEach(function(ele) {
                    var img = ele.main_img;
                    ele.img = img.startsWith("http") ? img : (app.globalData.prefix_url + img);
                    ele.price /= 100;
                });

                if (page == 0 && list.length == 0) {
                    wx.showModal({
                        title: "无商品",
                        content: "没有搜索到您输入的商品，换个关键字试试？",
                        showCancel: false
                    });
                }

                searchResult = searchResult.concat(list);

                that.setData({
                    searchResult: searchResult,
                    page: page
                });
            }
        });
    },

    // 清除输入框内容
    clearInput: function () {
        this.setData({
            inputVal: ""
        });
    },

    // 点击搜索历史记录
    tapRecord: function(e) {
        var id = e.currentTarget.id;
        this.setData({
            inputVal: id
        });
        this.searchByKey(id, 0);
    },

    // 清除历史记录
    clearRecord: function(e) {
        var that = this;
        wx.removeStorage({
            key: 'search',
            success: function(res) {
                that.setData({
                    searchRecord: []
                });
            }
        });
    },

    // 用户点击输入框进行输入
    inputFocus: function(e) {
        console.log("input e >>>", e);
        this.getRecord();
        this.setData({
            searchResult: []
        });
    },

    onPullDownRefresh: function () {

    },

    onReachBottom: function () {
        var that = this;

        var searchResult = that.data.searchResult,
            searchKey = that.data.inputVal,
            page = that.data.page + 1;

        that.searchByKey(searchKey, page);
    },

    onShareAppMessage: function () {

    }
})