var app = getApp();
var util = require('../../../../utils/util.js')

Page({
    data:{
        mainColor: app.globalData.main_color,
        
        // 阴影页是否显示
        isSelect: false,

        // 商品规格选择
        selectedIndex: [],
        selectedNum: 1,
        specialKey: ""
    },
    onLoad:function(options){
        var that = this;
        var id = options.goodId;
        var groupId = options.groupId;
        this.setData({
            mainColor: app.globalData.main_color,
            groupId: groupId,
            options: options
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });

        // 获取该商品的拼团列表
        that.getGroupListById(id);        

        // 获取商品详情
        that.getGoodDetailById(id);
    },

    // 获取该商品的拼团列表函数
    getGroupListById: function(id) {
        var that = this;
        var groupId = that.data.groupId;

        app.request({
            url: "_a=shop&_u=ajax.get_product_order_list",
            data: {
                uid: id
            },
            success: function(ret) {
                console.log("group good ret >>>", ret);
                var groupList = ret.data.list;
                groupList.forEach(function(ele) {
                    if (ele.uid == groupId) {
                        var now = new Date();
                        var startTime = util.formatTime(ele.paid_time);
                        ele.startTime = startTime[0] + "-" + startTime[1] + "-" + startTime[2] + " " + startTime[3];
                        
                        var remainTime = parseInt(ele.paid_time) + 3600*24 - parseInt(now.getTime() / 1000);
                        ele.leftTime = remainTime;
                        console.log("remainTime >>>", remainTime);
                        ele.remainTime = util.formatRemainTime(remainTime);

                        that.freshTime(ele);

                        that.setData({
                            group: ele
                        });
                    }
                });                
            }
        });
    },


    // 获取商品详情函数
    getGoodDetailById: function(id) {
        var that = this;

        app.request({
            url: "_a=shop&_u=ajax.product",
            data: {
                uid: id
            },
            success: function(ret) {
                var detail = ret.data;
                // detail.price = parseInt(detail.price) / 100;

                console.log("good >>>>>", ret);
                var img = detail.main_img;
                detail.img = img.startsWith("http") ? img : (app.globalData.prefix_url + img)

                that.setData({
                    detail: detail,
                    quantity: detail.quantity,
                    price: detail.price,
                    specialImg: detail.img,
                    id: id
                });

                if (detail.sku_table) {
                    // 商品规格
                    // 获取所有规格的名称
                    var specialClass = Object.keys(detail.sku_table.table);
                    var specials = [];

                    specialClass.forEach(function(ele) {
                        var special = {
                            name: ele,
                            list: detail.sku_table.table[ele],
                            selectedIndex: 0
                        };
                        specials.push(special);
                    });

                    that.calculate(specials);
                }
            }
        });
    },

    // 刷新时间
    freshTime: function(ele) {
        var that = this;
        var sh = setInterval(function() {
            ele.leftTime--;
            if (ele.leftTime <= 0) {
                ele.remainTime = "团购已过期";
            } else {
                ele.remainTime = util.formatRemainTime(ele.leftTime);
            }

            that.setData({
                group: ele
            });
        }, 1000);
    },

    // 分享商品页面
    onShareAppMessage: function (res) {
        var goodDetail = this.data.detail,
            goodId = this.data.options.goodId,
            groupId = this.data.options.groupId;

        var title = '我正在' + goodDetail.group_price/100 + "元拼" + goodDetail.title;
        var sharePath = '/page/class/pages/joinGroup/joinGroup?groupId=' + groupId + "&goodId=" + goodId;

        return {
            title: title,
            path: sharePath,
            success: function(res) {
            // 转发成功
            },
            fail: function(res) {
            // 转发失败
            }
        }
    },

    // 选择商品规格函数
    bindSelectSpecial: function(e) {
        var that = this;
        var id = e.currentTarget.id;
        var keyValue = id.split(' ');

        var specials = that.data.specials;

        specials.forEach(function(special) {
            if (special.name == keyValue[0]) {
                special.selectedIndex = parseInt(keyValue[1]);
            }
        });

        that.calculate(specials);
    },

    // 购买数量减一
    substractNum: function() {
        var that = this;
        var selectedNum = that.data.selectedNum - 1;
        that.setData({
            selectedNum: selectedNum
        });
    },

    // 购买数量加一
    addNum: function() {
        var that = this;
        var selectedNum = that.data.selectedNum + 1;

        that.setData({
            selectedNum: selectedNum
        });        
    },

    // 通过用户选择的规格，获取对应信息
    calculate: function(specials) {
        var that = this,
            detail = that.data.detail,
            selectedNum = that.data.selectedNum,
            selectedSpecialKey = "";

        // 获取所有规格组合下的产品信息
        var specialKeys = Object.keys(detail.sku_table.info);

        // 获取用户选择的规格
        specialKeys.forEach(function(specialKey) {
            for (var i = 0; i < specials.length; i++) {
                if(specialKey.indexOf(specials[i].list[specials[i].selectedIndex]) == -1) {
                    break;
                } else {
                    if (i == specials.length - 1) {
                        selectedSpecialKey = specialKey;
                    }
                }
            }
        });

        var selectSpecial = detail.sku_table.info[selectedSpecialKey],
            price = selectSpecial.price / 100,
            quantity = selectSpecial.quantity,
            specialImg = "",
            icon_img = selectSpecial.icon_img;

        if (icon_img) {
            specialImg = icon_img.startsWith("http") ? icon_img : (app.globalData.prefix_url + icon_img);
        } else {
            specialImg = detail.img;
        }

        selectedNum = selectedNum > quantity ? quantity : selectedNum;

        // specials：用户挑选的规格；
        that.setData({
            specials: specials,
            price: price,
            quantity: quantity,
            specialKey: selectedSpecialKey,
            selectedNum: selectedNum,
            specialImg: specialImg
        });

    },

    // 点击阴影部分，关闭选择规格页
    tapShadow: function() {
        var that = this;
        that.setData({
            isSelect: false
        });
    },

    // 打开选择规格页面
    showSelect: function() {
        var that = this;
        var group = that.data.group;
        var detail = that.data.detail;

        if (group.groups.length >= detail.group_cnt) {
            wx.showToast({
                title: "团购已满员"
            });
        } else if (group.leftTime > 0) {
            that.setData({
                isSelect: true
            });
        } else {
            wx.showToast({
                title: "团购已超时"
            });
        }
    },

    // 一键参团
    joinGroup: function() {
        var that = this;
        var group = that.data.group;

        if (group.user.uid === app.globalData.su_uid) {
            wx.showModal({
                title: "不能参加自己发起的团购",
                showCancel: false
            });
        } else {
            // 获取需要存储的数据
            var detail = that.data.detail;
            // var price = that.data.price;
            // 团购价
            var price = detail.group_price / 100;
            var specialKey = that.data.specialKey;
            var specials = that.data.specials;
            var selectedNum = that.data.selectedNum;

            var order = {};
            order.list = [];
            var goodOrder = {
                detailData: detail,
                price: price,
                selectedNum: selectedNum,
                specials: specials,
                specialKey: specialKey,
                goUid: group.go_uid
            };

            order.list.push(goodOrder);

            // 将选中的订单存入本地
            wx.setStorage({
                key: "groupOrder",
                data: order
            });
            console.log("save order >>>>>", order);

            wx.redirectTo({
                url: "../groupOrder/groupOrder"
            });
        }
    },

});
