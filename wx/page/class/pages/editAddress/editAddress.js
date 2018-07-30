var app = getApp();
// var tcity = require("../../../../utils/citys.js");

Page({

    data: {
        inputData: {},
        setDefault: ["defaultAddress"],
        
        // 城市选择数据
        region: ['北京市', '北京市', '东城区'],
    },

    onLoad: function (options) {
        var that = this;
        
        console.log("options >>>>>", options);
        that.setData({
            mainColor: app.globalData.main_color
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });

        if (options.name) {
            that.setData({
                // address: options,
                inputData: options
            });
        }

    },

    // 输入收货信息
    inputAct: function(e) {
        var id = e.currentTarget.id;

        var inputData = this.data.inputData;
        inputData[id] = e.detail.value;

        this.setData({
            inputData: inputData
        });
    },

    // 微信获取手机号
    getPhoneNumber: function(e) {
        var that = this;
        var inputData = that.data.inputData;
        // var inputData = that.data.inputData;
        console.log(e.detail.errMsg) 
        console.log(e.detail.iv) 
        console.log(e.detail.encryptedData)

        app.request({
            url: "_u=xiaochengxu.decrypt",
            data: {
                iv: e.detail.iv,
                encryptedData: e.detail.encryptedData
            },
            success: function(ret) {
                console.log("decode ret >>>>>", ret);
                // address.phone = ret.data.phoneNumber;
                inputData.phone = ret.data.phoneNumber;
                that.setData({
                    // address: address,
                    inputData: inputData
                });
            }
        });
    },

    // 设置为默认地址
    checkboxChange: function(e) {
        var setDefault = e.detail.value;

        console.log("setDefault >>>>>", setDefault);
        this.setData({
            setDefault: setDefault
        });
    },

    // 点击确定提交地址
    bindConfirm: function() {
        var that = this,
            setDefault = that.data.setDefault,
            region = that.data.region,
            inputData = this.data.inputData;

        // 设置为默认地址？？？
        if (!inputData.name || !inputData.phone || !inputData.address) {
            wx.showModal({
                content: "您输入的信息不完整",
                showCancel: false
            });
        } else {
            var phone = inputData.phone;

            if(!(/^1[34578]\d{9}$/.test(phone))){ 
                wx.showModal({
                    content: "您输入的手机号码有误，请重填",
                    showCancel: false
                });
                
            } else {
                app.request({
                    url: "_a=shop&_u=ajax.add_address",
                    data: {
                        name: inputData.name,
                        phone: inputData.phone,
                        province: region[0],
                        city: region[1],
                        town: region[2],
                        address: inputData.address,
                        uid: inputData.addressId,
                        is_default: setDefault.length
                    },
                    success: function(ret) {
                        console.log("return >>>>>", ret);
                        if (ret.data !== '0') {
                            wx.showToast({
                                title: "添加成功",
                                success: function() {
                                    wx.navigateBack();
                                }
                            });
                        }
                    }
                });
            }
        }
    },

    // 选择微信地址信息
    chooseAddress: function() {
        wx.chooseAddress({
            success: function(addressRet) {
                console.log("wechat addressRet >>>", addressRet);
                // 将用户选择的微信收货地址新增到用户信息中
                app.request({
                    url: "_a=shop&_u=ajax.add_address",
                    data: {
                        name: addressRet.userName,
                        phone: addressRet.telNumber,
                        province: addressRet.provinceName,
                        city: addressRet.cityName,
                        town: addressRet.countyName,
                        address: addressRet.detailInfo,
                        uid: addressRet.addressId,
                        is_default: 1
                    },
                    success: function(add_address_ret) {
                        console.log("return >>>>>". add_address_ret);
                        if (add_address_ret.data !== '0') {
                            wx.showToast({
                                title: "添加成功",
                                success: function() {
                                    wx.navigateBack();
                                }
                            });
                        }
                    }
                });
            }
        });
    },

    // picker 选择不同的城市
    bindRegionChange: function (e) {
        console.log('picker发送选择改变，携带值为', e.detail.value)
        this.setData({
            region: e.detail.value
        });
    },

    onShow: function () {

    },
})