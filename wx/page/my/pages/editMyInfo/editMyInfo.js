var app = getApp();

Page({

    data: {
        mainColor: app.globalData.main_color,
        sexes: ["男", "女", "保密"],
        sexIndex: 0,
        postData: {},
    },

    onLoad: function (options) {
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
        // 获取个人信息
        this.getMyInfo();
        this.setData({
            mainColor: app.globalData.main_color
        });
    },

    onShow: function () {
    
    },

    // 获取个人信息函数
    getMyInfo: function(cb) {
        var that = this;

        app.request({
            url: "_a=su&_u=ajax.profile",
            success: function(ret) {
                console.log("my info >>", ret)
                if (typeof(cb) === "function") {
                    cb(ret);
                } else {
                    var getData = ret.data;
                    var postData = that.data.postData;
                    postData.name = getData.su.name;
                    if (postData.profile) {
                        postData.email = getData.profile.email;
                        // postData.avatar = getData.profile.avatar;
                        postData.phone = getData.profile.phone;
                    }
                    that.setData({
                        postData: postData,
                        mainImg: getData.su.avatar
                    });
                }
            }
        });
    },

    // 填写信息
    userInput: function(e) {
        var id = e.currentTarget.id;
        var value = e.detail.value;
        var postData = this.data.postData;

        postData[id] = value;

        this.setData({
            postData: postData
        });
    },

    // 图片预览
    previewImage: function (e) {
        // var current = e.target.dataset.src
        var mainImg = this.data.mainImg;

        wx.previewImage({
          current: mainImg,
          urls: [mainImg]
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
        var imageList = res.tempFilePaths;

        if (imageList.length > 6) {
            wx.showModal({
                content: "最多只能上传6张图片",
                showCancel: false
            });
        } else {
            that.setData({
                mainImg: imageList[0]
            });
            console.log("local show img >>>", imageList[0]);

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
                        
                        uploadImg = picData.data.url;
                        
                        wx.showToast({
                            title: '图片上传成功',
                            icon: 'success',
                            duration: 500
                        });

                        that.setData({
                            uploadImg: uploadImg
                        });

                        console.log("uploadImg >>>", uploadImg);
                    },
                    fail: function({errMsg}) {
                        console.log('uploadImage fail, errMsg is', errMsg)
                    }
                });
            });
        }        
    },

    // 提交信息
    postInfo: function() {
        var that = this;
        var postData = that.data.postData;

        // 更新头像、昵称
        // if (that.data.uploadImg) {
        // if (that.data.un) {}

        var avatar = that.data.uploadImg ? (app.globalData.prefix_url + that.data.uploadImg) : that.data.mainImg;
        var name = postData.name;
        console.log("name >>>", name);
        console.log("avatar >>>", avatar);
        app.request({
            url: "_a=su&_u=ajax.update_su",
            data: {
                avatar: avatar,
                name: name
            },
            success: function(ret) {
                console.log("post ret >>>", ret);
                if (ret.data) {
                    wx.showToast({
                      title: "上传成功！",
                      success: function() {
                        // that.onLoad();
                        wx.navigateBack();
                      }
                    });
                } else {
                    wx.showModal({
                      title: "上传失败，请检查您的网络",
                      showCancel: false
                    });
                }
            }
        });
        // }

        // app.request({
        //     url: "_a=su&_u=ajax.update_su_profile",
        //     data: postData,
        //     success: function(ret) {
        //         console.log("post ret >>>", ret);
        //         if (ret.data) {
        //             wx.showToast({
        //               title: "上传成功！",
        //               success: function() {
        //                 // that.onLoad();
        //                 wx.navigateBack();
        //               }
        //             });
        //         } else {
        //             wx.showModal({
        //               title: "上传失败，请检查您的网络",
        //               showCancel: false
        //             });
        //         }
        //     }
        // });
        
    },

    onPullDownRefresh: function () {
    
    },

    onShareAppMessage: function () {
    
    }
})