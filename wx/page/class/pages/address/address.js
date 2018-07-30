var app = getApp();
// var tcity = require("../../../../utils/citys.js");


Page({

    data: {
        mainColor: app.globalData.main_color,
        isEditAddress: false,
        fromOrder: false,

        addressList: [],

        // 编辑位置数据
        inputData: {},
        setDefault: ["defaultAddress"],

        // 城市选择数据
        region: ['北京市', '北京市', '东城区'],
    },

    onLoad: function (options) {
        var that = this;

        this.setData({
            mainColor: app.globalData.main_color,
            options: options
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });

        if (options.order) {
            this.setData({
                fromOrder: true
            });
            wx.setNavigationBarTitle({
                title: "请选择收货地址"
            });
        }

        if (options.groupOrder) {
            this.setData({
                groupOrder: true
            });
        }

        // 城市选择初始化数据
        that.setCityData(options);
    },

    onShow: function () {
        var that = this;

        // 获取收货地址列表
        that.getAddressList();
    },

    // 设置城市数据
    setCityData: function(options) {
        var that = this;
        var region = that.data.region;

        if (options.province) {
            region[0] = options.province;
        }

        if (options.city) {
            region[1] = options.city;
        }

        if (options.town) {
            region[2] = options.town;
        }

        that.setData({
            region: region
        });
    },

    // 获取收货地址列表
    getAddressList: function(cb) {
        var that = this;

        app.request({
            url: "_a=shop&_u=ajax.get_address",
            success: function(ret) {
                if (typeof(cb) === "function") {
                    cb(ret);
                } else {
                    var addressList = ret.data;
                    console.log("addressList >>>>>", addressList);

                    that.setData({
                        addressList: addressList
                    });
                }
            }
        });
    },

    // 点击阴影部分，关闭选择规格页
    tapShadow: function() {
        var that = this;
        that.setData({
            isEditAddress: false
        });
    },

    // 新增地址
    showEditModal: function(e) {
        var that = this;
        // console.log("add tap e >>>", e);
        // if (e.currentTarget.dataset.type == "addAddress") {
        that.setData({
            isEditAddress: true,
            inputData: {},
            setDefault: ["defaultAddress"],
            // address: {
            //     phone: '',
            //     name: ''
            // },
        });
        // }
    },

    // 编辑地址
    editTap: function(e) {
        console.log("editTap e >>>", e);
        var that = this,
            addressId = e.currentTarget.dataset.addressid,
            addressList = this.data.addressList;

        addressList.forEach(function(ele) {
            if (ele.uid == addressId) {
                that.setCityData(ele);
                that.setData({
                    inputData: ele,
                    // address: ele,
                    isEditAddress: true
                });
            }
        });
    },

    // 删除选择的地址
    deleteAddress: function(e) {
        var that = this;
        var id = e.currentTarget.id;

        wx.showModal({
            content: "确定删除该地址吗？",
            success: function(res) {
                if (res.confirm) {
                    app.request({
                        url: "_a=shop&_u=ajax.delete_address",
                        data: {
                            uids: id
                        },
                        success: function(ret) {
                            if (ret.data != 0) {
                                that.getAddressList();
                            } else {
                                wx.showModal({
                                    content: "删除失败，请检查您的网络",
                                    showCancel: false
                                });
                            }
                        }
                    });
                }
            }
        });
    }, 

    // 选择地址前往订单
    redirectToOrder: function(e) {
        if (this.data.fromOrder) {
            var id = e.currentTarget.id;
            var preUrl = this.data.groupOrder ? "../groupOrder/groupOrder?addressId=" : "../order/order?addressId=";
            var orderUrl = preUrl + id;
            wx.redirectTo({
                url: orderUrl
            });
        }
    },

    // 编辑地址信息
    // 输入收货信息
    inputAct: function(e) {
        var id = e.currentTarget.id;

        var inputData = this.data.inputData;
            // address = this.data.address;

        inputData[id] = e.detail.value;
        // address[id] = e.detail.value;

        this.setData({
            inputData: inputData,
            // address: address
        });
    },

    // 微信获取手机号
    getPhoneNumber: function(e) {
        var that = this;
        // var address = that.data.address;
        var inputData = that.data.inputData;
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
                        uid: inputData.uid,
                        is_default: setDefault.length
                    },
                    success: function(ret) {
                        that.tapShadow();
                        console.log("return >>>>>", ret);
                        if (ret.data !== '0') {
                            wx.showToast({
                                title: "添加成功",
                                success: function() {
                                    that.getAddressList();
                                }
                            });
                        } else {
                            wx.showModal({
                                title: "添加失败",
                                content: "添加／编辑地址失败，请检查您的网络",
                                showCancel: false
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
                        that.tapShadow();
                        console.log("return >>>>>". add_address_ret);
                        if (add_address_ret.data !== '0') {
                            wx.showToast({
                                title: "添加成功",
                                success: function() {
                                    that.getAddressList();
                                }
                            });
                        } else {
                            wx.showModal({
                                title: "添加失败",
                                content: "添加地址失败，请检查您的网络",
                                showCancel: false
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

    onPullDownRefresh: function () {

    },

})