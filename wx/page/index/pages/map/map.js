// page/index/pages/map/map.js
var app = getApp();

Page({

    data: {
        businessList: [],
        markers: [{
            // iconPath: "/resources/others.png",
            id: 0,
            latitude: 23.099994,
            longitude: 113.324520,
            width: 50,
            height: 50
        }],
        polyline: [{
            points: [{
                longitude: 113.3245211,
                latitude: 23.10229
            }, {
                longitude: 113.324520,
                latitude: 23.21229
            }],
            color:"#000",
            width: 20,
            dottedLine: true
        }],
        // controls: [{
        //     id: 1,
        //     iconPath: '../../../resources/pic/good.png',
        //     position: {
        //         left: 0,
        //         top: 300 - 50,
        //         width: 50,
        //         height: 50
        //     },
        //     clickable: true
        // }]
    },

    controltap: function (e) {  
        // wx.openLocation({  
        //     latitude: 23.362490,  
        //     longitude: 116.715790,  
        //     scale: 18,  
        //     name: '华乾大厦',  
        //     address:'金平区长平路93号'  
        // });
    }, 

    onLoad: function (options) {
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
        // 获取当前位置
        wx.getLocation({
            type: 'wgs84',
            success: function(res) {
                console.log("getLocation ret >>>", res);
                var latitude = res.latitude
                var longitude = res.longitude
                var speed = res.speed
                var accuracy = res.accuracy
            }
        });

        // 获取商家列表
        this.getBizlist(0);
    },

    onShow: function () {
    
    },

    // 获取商家列表
    getBizlist: function(page) {
        var that = this;

        app.request({
            url: "_a=shop&_u=biz.ajax_bizlist",
            data: {
                // limit: 10,
                page: page
            },
            success: function(ret) {
                console.log("business ret >>>", ret);
                var businessList = ret.data.list,
                    len = businessList.length,
                    markers = that.data.markers;

                businessList.forEach(function(ele) {
                    if (!ele.main_img.startsWith("http")) ele.main_img = app.globalData.prefix_url + ele.main_img;
                    
                    var marker = {
                        id: ele.uid,
                        latitude: ele.lat,
                        longitude: ele.lng,
                        title: ele.title
                    };
                    // marker.id = ele.uid;
                    // marker.latitude = ele.lat;
                    // marker.longitude = ele.lng;
                    // marker.title = ele.title;
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


    onPullDownRefresh: function () {
    
    },

    onShareAppMessage: function () {
    
    }
})