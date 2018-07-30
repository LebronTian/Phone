var app = getApp();

Page({

    data: {
        showTopTips: false,

        accounts: ["零食", "女装", "鞋靴"],
        accountIndex: 0,

        mainColor: "",

        postData: {
            extra_info: {}
        },
        mainImg: "",
        uploadImg: "",

        checkboxItems: [
            {value: 'WIFI', checked: false},
            {value: '停车位', checked: false},
            {value: '支付宝支付', checked: false},
            {value: '微信支付', checked: false}
        ],

        files: [],
        uploadImage: [],

        isAgree: false
    },

    onLoad: function (options) {
        this.setData({
            mainColor: app.globalData.main_color
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: this.data.mainColor,
        });
        // 获取填写过的信息
        this.getBizInfo();
        // 获取所有商家分类
        this.getBizClass();
    },

    onShow: function () {

    },

    getBizInfo: function(cb) {
        var that = this;
        var postData = that.data.postData;

        app.request({
            url: "_a=shop&_u=biz.ajax_biz",
            success: function(ret) {
                if (typeof(cb) === "function") {
                    cb(ret);
                } else {
                    console.log("get business ret >>>>", ret);
                    var getData = ret.data;
                    if (!getData) return;
                    postData.title = getData.title;
                    postData.location= getData.location;
                    postData.phone = getData.phone;
                    postData.account = getData.account;
                    postData.extra_info.name = getData.extra_info.name;
                    postData.brief = getData.brief;
                    postData.main_img = getData.main_img;
                }
            }
        });
    },

    // 获取所有商家分类函数
    getBizClass: function(cb) {
        var that = this;

        app.request({
            url: "_a=shop&_u=ajax.biz_cats",
            success: function(ret) {
                if (typeof(cb) === "function") {
                    cb(ret);
                } else {
                    console.log("cat >>>", ret);
                    var catList = ret.data;
                    var accounts = [];
                    catList.forEach(function(ele) {
                        accounts.push(ele.title);
                    });
                    that.setData({
                        accounts: accounts
                    });
                }
            }
        });
    },

    // 填写信息
    userInput: function(e) {
        let id = e.currentTarget.id;
        let value = e.detail.value;
        let properties = ['title', 'location','phone', 'account', 'passwd', 'contact'];
        let postData = this.data.postData;

        if (properties.includes(id)) {
            postData[id] = value;
        } else {
            postData.extra_info[id] = value;
        }

        this.setData({
            postData: postData
        });
    },

    // 确认密码
    pswConfirm: function(e) {
        var newPassword = e.detail.value;
        var oldPasswd = this.data.postData.passwd;
        var showTopTips = false;

        if (newPassword === oldPasswd) {
            showTopTips = false;
        } else {
            showTopTips = true;
        }

        this.setData({
            showTopTips: showTopTips
        });
    },

    // 选择店内设施
    checkboxChange: function (e) {
        console.log('checkbox发生change事件，携带value值为：', e.detail.value);
        var postData = this.data.postData;
        var checkboxItems = this.data.checkboxItems, values = e.detail.value;
        postData.extra_info.bar_installation = values;

        for (var i = 0, lenI = checkboxItems.length; i < lenI; ++i) {
            checkboxItems[i].checked = false;

            for (var j = 0, lenJ = values.length; j < lenJ; ++j) {
                if(checkboxItems[i].value == values[j]){
                    checkboxItems[i].checked = true;
                    break;
                }
            }
        }

        this.setData({
            checkboxItems: checkboxItems
        });
    },

    bindAccountChange: function(e) {
        console.log('picker account 发生选择改变，携带值为', e.detail.value);

        this.setData({
            accountIndex: e.detail.value
        });
    },

    // 选择商家地址
    chooseLoc: function() {
        var that = this,
            postData = that.data.postData;
        wx.chooseLocation({
            success: (ret)=>{
                console.log("chooseLocation rer >>>>>", ret);
                postData.location = ret.address + ret.name;
                postData.lng = ret.longitude;
                postData.lat = ret.latitude;
                that.setData({
                    postData: postData
                });
            }
        });
    },
    // 清空地址
    clearLoc: function() {
        var postData = this.data.postData;
        postData.location = postData.lng = postData.lat = "";
        this.setData({
            postData: postData
        });
    },

    // 设置营业时间
    bindTimeChange: function (e) {
        var id = e.currentTarget.id;

        this.setData({
            time: e.detail.value
        });
    },

    // 图片预览
    previewImage: function (e) {
        var mainImg = this.data.mainImg;

        wx.previewImage({
          current: mainImg,
          urls: [mainImg]
        });
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
                // 上传图片
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

    
    // 选择商家图片
    chooseShopImage: function(e) {
        var that = this;

        wx.chooseImage({
            sizeType: ['original', 'compressed'], // 可以指定是原图还是压缩图，默认二者都有
            sourceType: ['album', 'camera'], // 可以指定来源是相册还是相机，默认二者都有
            success: that.chooseShopImageCb
        });
    },
    chooseShopImageCb: function(res) {
        var that = this,
            chooseFiles = res.tempFilePaths;

        that.uploadShopImg(chooseFiles, 0);
    },
    // 依次上传多张图片
    uploadShopImg: function(imgArr, idx) {
        var that = this,
            uploadImage = that.data.uploadImage,
            uploadURL = app.globalData.prefix_url + "?_a=upload&_u=index.upload";

        // 上传图片
        wx.uploadFile({
            url: uploadURL,
            filePath: imgArr[idx],
            name: 'file',
            success: function(res) {
                var picData = JSON.parse(res.data);
                
                var files = that.data.files.concat(imgArr[idx]);
                that.setData({
                    files: files
                });
                
                var picUrl = picData.data.url;
                console.log("chooseImage url >>>>", picUrl);
                uploadImage.push(picUrl);
                console.log("uploadImage >>>>>>", uploadImage);
                that.setData({
                    uploadImage: uploadImage
                });
            },
            fail: function({errMsg}) {
                console.log('uploadImage fail, errMsg is', errMsg)
            },
            complete: () => {
                idx++;
                if (idx >= imgArr.length) {
                    wx.showToast({
                        title: '图片上传成功'
                    });
                } else {
                    that.uploadShopImg(imgArr, idx);
                }
            }
        });
    },
    // 预览上传图片
    previewShopImage: function(e){
        var id = parseInt(e.currentTarget.id);
        var current = this.data.files[id];
        wx.previewImage({
            current: current,
            urls: this.data.files
        });
    },

    // 删除长按的图片
    deleteImg: function(e) {
        var id = parseInt(e.currentTarget.id),
            uploadImage = that.data.uploadImage,
            files = this.data.files;
        console.log("delete id >>>", id);
        files.splice(id, 1);
        uploadImage.splice(id, 1);
        console.log("files show >>>>>", files);
        console.log("uploadImage >>>>>", uploadImage);
        this.setData({
            files: files,
            uploadImage: uploadImage
        });
    },


    // 是否同意协议
    bindAgreeChange: function (e) {
        this.setData({
            isAgree: !!e.detail.value.length
        });
    },

    // 提交信息
    submitInfo: function(e) {
        var that = this;

        // 获取输入框中的内容
        var brief = e.detail.value.textarea;
        var data = that.data;

        var postData = data.postData;
        postData.main_img = data.uploadImg;
        var type = data.accounts[data.accountIndex];
        postData.type = type ? type : "其他";
        postData.brief = brief;
        postData.images = data.uploadImage.join(";");

        console.log("postData >>>>>", postData);
        // return;

        if (this.data.showTopTips) {
            wx.showModal({
                title: "请确认密码",
                showCancel: false
            });
        } else if (!this.data.isAgree) {
            wx.showModal({
                title: "请确认阅读并同意相关条款",
                showCancel: false
            });
        } else if (postData.title && postData.location && postData.phone && postData.main_img && postData.brief && postData.contact) {
            app.request({
                url: "_a=shop&_u=biz.ajax_apply",
                data: postData,
                success: function(ret) {
                    console.log("reply return >>>", ret);
                    if (ret.errno == 0 & ret.data !== "0") {
                        wx.showToast({
                            title: "申请提交成功！"
                        });
                        wx.navigateBack();
                    } else {
                        wx.showModal({
                            title: "提交失败",
                            content: "请检查您的网络",
                            showCancel: false
                        });
                    }
                }
            });
        } else {
            wx.showModal({
                title: "请将信息填写完整",
                showCancel: false
            });
        }
    }
})