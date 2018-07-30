var app = getApp();
// var uploadImage = [];

Page({
    data:{
        // picFile: "../../resources/pic/default.png",
        showTopTips: false,
        files: [],
        uploadImage: [],
        phone: "",

        buyTop: false,
        dates: [],
        dateIndex: 0,

        loc: {
            longitude: 0,
            latitude: 0
        }
    },

    onLoad: function(options){
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
        var that = this;
        // var classId = options.classId;
        that.setData({
            // classId: classId
            mainColor: app.globalData.main_color
        });
        that.getPostPrice();
        // that.getClassDetail(classId);
        that.getUserPhone();
    },

    // 获取发布消息的各项费用
    getPostPrice: function(cb) {
        var that = this;

        app.request({
            url: '_a=classmsg&_u=ajax.get_classset',
            success: (ret) => {
                console.log("get price ret >>>>", ret);
                if (typeof cb == 'function') {
                    cb(ret);
                } else {
                    var priceList = ret.data,
                        priceArr = [],
                        dates = [];

                    priceList.forEach(function(ele) {
                        var date = ele[0] + '天';
                        dates.push(date);
                        var price = parseFloat(ele[1] / 100).toFixed(2);
                        priceArr.push(price);
                    });
                    that.setData({
                        dates: dates,
                        priceArr: priceArr
                    });
                }
            }
        });
    },

    getClassDetail: function(classId, cb) {
        var that = this;

        app.request({
            url: '_a=classmsg&_u=ajax.get_class_cat_by_uid',
            data: {
                uid: classId
            },
            success: (ret) => {
                console.log("class detail >>>>>", ret);
                if (typeof cb == 'function') {
                    cb(ret);
                } else {
                    var price = parseFloat(ret.data.paid_fee/100).toFixed(2);
                    that.setData({
                        price: price,
                        totalPrice: price
                    });
                }
            }
        })
    },

    getUserPhone: function() {
        var that = this;

        app.request({
            url: '_a=su&_u=ajax.profile',
            data: {},
            success: (ret) => {
                console.log("userInfo >>>>>>", ret);
                if (typeof cb == 'function') {
                    cb(ret);
                } else {
                    var phone = ret.data.profile.phone;
                    if (phone) {
                        that.setData({
                            phone: phone
                        });
                    }
                }
            }
        });
    },

    // 获取打听描述内容
    // getText: function(e) {
    //     this.setData({
    //         content: e.detail.value
    //     });
    // },

    // 用户输入
    userInput: function(e) {
        var content = e.detail.value,
            id = e.currentTarget.dataset.id;
        if (id == "phone") {
            this.setData({
                phone: content
            });
        } else {
            this.setData({
                currentAddress: content
            });
        }
        console.log("input detail >>>>>", content);
    },

    // 选择是否置顶
    switchChange: function(e) {
        var buyTop = !this.data.buyTop;
        this.setData({
            buyTop: buyTop
        });
        // this.calculatePrice();
    },

    // 选择置顶天数
    bindPickerChange: function(e) {
        this.setData({
            dateIndex: e.detail.value
        });
        // this.calculatePrice();
    },

    // 选择图片
    chooseImage: function(e) {
        var that = this;
        var count = 6 - that.data.files.length;

        if (count > 0) {
            wx.chooseImage({
                count: count,
                sizeType: ['original', 'compressed'], // 可以指定是原图还是压缩图，默认二者都有
                sourceType: ['album', 'camera'], // 可以指定来源是相册还是相机，默认二者都有
                success: that.chooseImageCb
            });
        } else {
            this.setData({
                showTopTips: true
            });
            this.delayClose();
        }
    },
    chooseImageCb: function(res) {
        var that = this,
            originFiles = that.data.files,
            length = 6 - originFiles.length,
            chooseFiles = res.tempFilePaths.slice(0, length);
            // files = originFiles.concat(chooseFiles);

        // that.setData({
        //     files: files
        // });

        that.uploadImg(chooseFiles, 0);
        // console.log("tempFilePaths >>>>", files);
    },
    // 依次上传多张图片
    uploadImg: function(imgArr, idx) {
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
                    that.uploadImg(imgArr, idx);
                }
            }
        });
    },

    // 延迟关闭顶部提示
    delayClose: function() {
        var that = this;
        setTimeout(function() {
            that.setData({
                showTopTips: false
            });
        }, 1500);
    },

    // 预览上传图片
    previewImage: function(e){
        var id = parseInt(e.currentTarget.id);
        var current = this.data.files[id];
        wx.previewImage({
            current: current, // 当前显示图片的http链接
            urls: this.data.files // 需要预览的图片http链接列表
        })
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

    // 获取当前位置
    getLocation: function() {
        var that = this;
        wx.getLocation({
            success: function(res) {
                that.setData({
                    loc: res
                });
                var requestUrl = '_easy=web.index.geo2name&lat='+res.latitude+'&lng='+res.longitude+'&type=tencent';
                app.request({
                    url: requestUrl,
                    success: function(ret) {
                        // that.addFriend(ret.data.address);
                        that.setData({
                            currentAddress: ret.data.address
                        });
                    }
                });
            },
            fail: function() {
            }
        });
    },

    // 点击发布打听
    tapPost: function(e) {
        var that = this;

        var content = e.detail.value.textarea,
            // catId = that.data.classId,
            phone = that.data.phone ? that.data.phone : "",
            address = that.data.currentAddress ? that.data.currentAddress : "",
            price = that.data.price ? that.data.price*100 : 0,
            days = that.data.buyTop ? that.data.dates[that.data.dateIndex] : 0,
            topPrice = that.data.buyTop ? (that.data.priceArr[that.data.dateIndex]*100) : 0,
            loc = that.data.loc,
            images = that.data.uploadImage.join(";");

        if (!!days && (days != 0)) days = days.substr(0, days.length-1);

        var priceArr = [10, 5000, 10000, 20000, 50000, 100000];
        var price = priceArr[that.data.priceIndex];
        // var pic = that.data.uploadImage;

        console.log("else_info price >>>", topPrice);
        console.log("else_info days >>>", days);
        console.log("post content >>>", content);
        // 支付流程
        if (!content) {
            wx.showModal({
                content: "请填写消息内容",
                showCancel: false,
            });
        } else if (!address) {
            wx.showModal({
                content: "请填写地址",
                showCancel: false,
            });
        } else if (!phone) {
            wx.showModal({
                content: "请填写联系电话",
                showCancel: false,
            });
        } else {
            // 发布消息
            app.request({
                url: "_a=classmsg&_u=ajax.add_classmsg",
                data: {
                    // cat_uid: catId,
                    tel: phone,
                    images: images,
                    else_info: {
                        days: days,
                        paid_fee: topPrice
                    },
                    paid_fee: price,
                    brief: content,
                    address: address,
                    lng: loc.longitude,
                    lat: loc.latitude
                },
                success: that.postAskCb
            });
        }
    },

    // 发布打听回调函数
    postAskCb: function(ret) {
        console.log("msg post return >>>>", ret);
        if (ret.data && ret.data != 0) {
            var price = this.data.price,
                topPrice = this.data.buyTop ? (this.data.priceArr[this.data.dateIndex]*100) : 0,
                totalPrice = price + topPrice;

            console.log("totalPrice >>>>>", totalPrice);
            if (totalPrice > 0) {
                this.do_pay(ret.data);
            } else {
                wx.showToast({
                    title: '发布成功',
                    success: (ret) => {
                        wx.navigateBack();
                    }
                });
            }
            this.setData({
                postAskId: ret.data
            });
        } else if (ret.errno == 403 && ret.errstr == "ERROR_OUT_OF_LIMIT") {
            wx.showModal({
                title: "发布失败",
                content: "您今天发布的消息总数已超过每日发送消息数量限制，请明日再试",
                showCancel: false
            });
        }
    },

    //支付
    do_pay: function(uid) {
        var that = this;
        var options = that.data.options;
        if(!uid || that.data.paying) return;
        that.setData({paying: true});
        var data = {oid: 'm' + uid, openid: app.globalData.openid};    
        app.request({
            url:'_a=pay&_u=index.wxxiaochengxu',
            data: data,
            'success': function(ret){
                console.log("pay return >>>>>>", ret);
                that.setData({ paying:false });
                if(!ret.data || !ret.data.xiaochengxuParameters) {
                    return app.alert('支付失败！'+ret.errno);
                }
                var obj = ret.data.xiaochengxuParameters;
                obj['success'] = function() {
                    // app.alert('支付成功!');
                    wx.showToast({
                        title: "支付成功"
                    });
                    app.request({
                        url: '_a=pay&_u=index.wxxiaochengxu_update_order',
                        data: data
                    });
                    // that.onLoad(options);
                    wx.navigateBack();
                };  
                obj['complete'] = function() {
                    that.setData({paying:false});
                };  
                wx.requestPayment(obj);
            }
        });
    }
})