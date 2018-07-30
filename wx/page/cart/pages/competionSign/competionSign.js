var app = getApp();
var inputData = {};


Page({
    data:{
        postData: {},
        id: ""
    },
    onLoad:function(options){
        var id = options.uid;

        this.getExerData(id);

        this.setData({
            id: id,
            mainColor: app.globalData.main_color,
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: this.data.mainColor,
        });
    },

    // 获取活动数据
    getExerData: function(id) {
        var that = this;
        app.request({
            url: "_a=form&_u=ajax.form",
            data: {
                f_uid: id
            },
            success: (ret)=>{
                var infoData = ret.data.data;
                console.log("info data >>>>>", infoData);
                that.setData({
                    infoData: infoData
                });
            }
        });
    },

    // 图片预览
    previewImage: function (e) {
        // var current = e.target.dataset.src
        var mainImg = this.data.mainImg;

        wx.previewImage({
            current: mainImg,
            urls: [mainImg]
        });
    },

    // 选择图片函数
    chooseImage: function(e) {
        var that = this,
            infoId = e.currentTarget.dataset.id;
        that.setData({
            uploadId: infoId
        });
        wx.chooseImage({
            sizeType: ['original', 'compressed'],
            sourceType: ['album', 'camera'],
            success: that.chooseImageCb
        });
    },
    // 选择图片成功回调函数
    chooseImageCb: function(res) {
        var that = this,
            infoData = that.data.infoData,
            imageList = res.tempFilePaths;

        if (imageList.length > 6) {
            wx.showModal({
                content: "最多只能上传6张图片",
                showCancel: false
            });
        } else {
            
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

                        infoData.forEach(function(ele) {
                            if (ele.id == that.data.uploadId) ele.value = app.globalData.prefix_url + uploadImg;
                        });
                        that.setData({
                            infoData: infoData
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

    // 将输入的信息记录保存
    inputInfo: function(e) {
        var id = e.currentTarget.id;
        inputData[id] = e.detail.value;

        this.setData({
            postData: inputData
        });
    },

    // 提交报名信息报名参加
    submitSignInfo: function(e) {
        var that = this,
            infoData = that.data.infoData,
            inputValue = e.detail.value;

        infoData.forEach(function(ele) {
            if (ele.type != "file_img") ele.value = inputValue[ele.id];
        });

        console.log("submit data >>>>>", infoData);

        var id = that.data.id,
            postData = {};
        // var postData = that.data.postData;

        // 判断信息填写是否完整
        for (var i = 0; i < infoData.length; i++) {
            if (infoData[i].required) {
                if (!infoData[i].value) {
                    wx.showModal({
                        title: "信息不完整",
                        content: '您的必填信息填写不完整，请重新填写',
                        showCancel: false
                    });
                    return;
                }
            }

            if (infoData[i].type == "file_img") {
                let img = {};
                img.url = infoData[i].value;
                postData[i] = img;
            } else {
                postData[i] = infoData[i].value;
            }
        }
        postData = JSON.stringify(postData);
        console.log("postData >>>>", postData);

        // 报名请求
        app.request({
            url: "_a=form&_u=ajax.addformrecord",
            data: {
                f_uid: id,
                data: postData
            },
            success: (ret)=>{
                console.log("sign ret >>>>", ret);
                if (ret.errno === 0) {
                    wx.showToast({
                        title: "报名成功",
                        success: function() {
                            wx.redirectTo({
                                url: "../exerciseDetail/exerciseDetail?f_uid=" + id + "&hasSigned=true"
                            });
                        }
                    });
                } else {
                    wx.showModal({
                        content: '报名失败，请检查您的网络是否正常',
                        showCancel: false
                    });
                }
            }
        });
    },

})