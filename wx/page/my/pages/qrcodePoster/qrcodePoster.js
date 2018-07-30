// page/my/pages/qrcodePoster/qrcodePoster.js
var app = getApp();

Page({

    data: {
        selectedIndex: 0,
        imgs: []
    },

    onLoad: function (options) {
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });

        var that = this;

        app.getUserInfo(function() {
            that.getAllPoster();
        });
    },

    onShow: function () {
    
    },

    getPosterByImg: function(img, cb) {
        var that = this,
            imgId = img.uid,
            time = img.create_time;

        var selectedImg = app.globalData.server_url + "_a=qrxcx&_u=index.image&qp_uid=" + imgId + "&uid=" + app.globalData.su_uid + "&time=" + time;
        console.log("selectedImg url >>>>", selectedImg);
        this.setData({
            posterUrl: selectedImg
        });
    },

    getAllPoster: function(cb) {
        var that = this;

        app.request({
            url: '_a=qrxcx&_u=ajax.posterlist',
            // url: '_a=qrxcx&_u=ajax.posterlist2',
            success: (ret) => {
                console.log("all poster ret >>>>>", ret);
                if (typeof cb == 'function') {
                    cb(ret);
                } else {
                    if (!ret.data || !ret.data.list.length) return;
                    let list = ret.data.list;
                    list.forEach(function(ele) {
                        let img = ele.photo_info.img_url;
                        if (img.startsWith("http")) {
                            ele.image = img;
                        } else {
                            ele.image = app.globalData.prefix_url + img;
                        }
                    });
                    

                    that.setData({
                        imgs: list
                    });
                    that.getPosterByImg(list[0]);

                }
            }
        })
    },

    preview: function() {
        var imgUrl = this.data.posterUrl;

        wx.previewImage({
            current: imgUrl,
            urls: [imgUrl]
        });
    },

    selectImg: function(e) {
        var id = e.currentTarget.id,
            imgs = this.data.imgs;

        this.getPosterByImg(imgs[id]);
        this.setData({
            selectedIndex: id
        });
    },

    onPullDownRefresh: function () {
    
    },

    onShareAppMessage: function () {
    
    }
})