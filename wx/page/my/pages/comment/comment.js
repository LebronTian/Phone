var app = getApp();

Page({

    data: {
        // picFile: "../../resources/pic/default.png",
        // uploadImg: "",
        scoreArr: [0,1,2,3,4],
        uploadImg: [],

        imageList: [],
        sourceTypeIndex: 2,
        sourceType: ['拍照', '相册', '拍照或相册'],

        sizeTypeIndex: 2,
        sizeType: ['压缩', '原图', '压缩或原图']
        
    },

    onLoad: function (options) {
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
        var id = options.order_id;
        var productId = options.uid;
        var that = this;
        this.setData({
            mainColor: app.globalData.main_color
        });

        console.log("options >>>>>", options);

        app.request({
            url: "_a=shop&_u=ajax.order",
            data: {
                uid: id
            },
            success: function(ret) {
                console.log("order >>>>", ret);
                var order = ret.data;
                if (!order.length) return;

                order.products.forEach(function(good) {
                    good.id = good.sku_uid.split(";")[0];

                    if (good.id == productId) {
                        var img = good.main_img;
                        good.img = img.startsWith("http") ? img : (app.globalData.prefix_url + img);
                        good.price = parseInt(good.paid_price) / 100;

                        that.setData({
                            product: good
                        });
                    }
                });

                that.setData({
                    order: order,
                    id: id,
                    productId: productId
                });
            }
        });
    },

    // 评分
    tapScore: function(e) {
        console.log("id >>>", e.currentTarget.dataset.id);
        var len = parseInt(e.currentTarget.dataset.id) + 1,
            arr = [];

        for (let i = 0; i < len; i++) {
            arr.push(i);
        }
        this.setData({
            scoreArr: arr
        });
    },
    
    previewImage: function (e) {
        var current = e.target.dataset.src

        wx.previewImage({
          current: current,
          urls: this.data.imageList
        })
    },

    // 选择图片函数
    chooseImage: function(e) {
        var that = this;
        wx.chooseImage({
            sizeType: ['original', 'compressed'],
            sourceType: ['album', 'camera'],
            success: that.chooseImageCb
        })
    },
    // 选择图片成功回调函数
    chooseImageCb: function(res) {
        var that = this;
        var imageList = that.data.imageList.concat(res.tempFilePaths);

        if (imageList.length > 6) {
            wx.showModal({
                content: "最多只能上传6张图片",
                showCancel: false
            });
        } else {
            that.setData({
                imageList: imageList
            });

            var uploadImg = that.data.uploadImg;
            var uploadURL = app.globalData.prefix_url + "?_a=upload&_u=index.upload";
                    
            res.tempFilePaths.forEach(function(imageSrc) {
                // 上传商品图片
                wx.uploadFile({
                    url: uploadURL,
                    filePath: imageSrc,
                    name: 'file',
                    success: function(res) {
                        var picData = JSON.parse(res.data);
                        
                        var picUrl = picData.data.url;
                        uploadImg.push(picUrl);
                        
                        wx.showToast({
                            title: '图片上传成功',
                            icon: 'success',
                            duration: 500
                        });

                        that.setData({
                            uploadImg: uploadImg
                        });
                    },
                    fail: function({errMsg}) {
                        console.log('uploadImage fail, errMsg is', errMsg)
                    }
                });
            });
        }
    },

    bindFormSubmit: function(e) {
        console.log("comment text >>>>>", e);
        var that = this,
            comment = e.detail.value.textarea,
        //  products = Object.keys(comments),
            that = this,
            id = that.data.id,
            productId = that.data.productId,
            score = that.data.scoreArr.length,
            images = that.data.uploadImg;
        images = images.join(';');

        console.log("brief >>>>>", comment);
        console.log("images >>>>>", images);

        if (!comment) {
            wx.showModal({
                content: "评论不能为空！",
                showCancel: false
            });
        } else {
            app.request({
                url: "_a=shop&_u=ajax.do_product_comment",
                data: {
                    order_uid: id,
                    product_uid: productId,
                    brief: comment,
                    score: score,
                    images: images
                },
                success: function(ret) {
                    console.log("comment order >>>>", ret);
                    if (ret.data != 0) {
                        wx.showToast({
                            title: "评论成功",
                            success: function() {
                                wx.navigateBack({
                                    delta: 2
                                });
                            }
                        });
                    }
                }
            });
        }
    },


    onShow: function () {
    
    },

    onPullDownRefresh: function () {
    
    },

    onShareAppMessage: function () {
    
    }
})