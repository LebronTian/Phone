var app = getApp();
var util = require('../../../../utils/util.js');


Page({

    data: {
        nodes: []
    },

    onLoad: function (options) {
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
        // 获取构建页面
        this.getNodes(options.uid);

        this.setData({
            mainColor: app.globalData.main_color
        });
    },

    onShow: function () {

    },

    // 获取构建页面请求
    getNodes: function(uid) {
        var that = this,
            handleComponentArr = ["xinWen", "huoDong", "kanJia", "pinTuan", "chanPin"];

        app.request({
            url: "_u=xiaochengxu.get_page",
            data: { uid: uid },
            success: (ret)=>{
                var nodeString = ret.data.content;
                var allData = nodeString ? JSON.parse(nodeString) : {};
                if (!allData.nodes) return;

                var nodes = allData.nodes,
                    basicInfo = allData.basicInfo;
                wx.setNavigationBarTitle({
                    title: basicInfo.title
                });
                wx.setNavigationBarColor({
                    backgroundColor: basicInfo.navigationBgColor
                });
                // var nodes = nodeString ? JSON.parse(nodeString) : [];
                console.log("show nodes >>>>>", nodes);

                nodes.forEach(function(node) {
                    if (node.nodedata.list) {
                        node.nodedata.list.forEach(function(ele) {
                            if (ele.imgUrl) {
                                if (!ele.imgUrl.startsWith("http")) {
                                    ele.imgUrl = app.globalData.prefix_url + ele.imgUrl;
                                }
                            }
                            if (ele.main_img) {
                                if (!ele.main_img.startsWith("http")) {
                                    ele.main_img = app.globalData.prefix_url + ele.main_img;
                                }
                            }
                        });
                    } else {
                        if (node.nodedata.imgUrl) {
                            node.nodedata.imgUrl = app.globalData.prefix_url + node.nodedata.imgUrl;
                        }
                        if (node.nodedata.main_img) {
                            node.nodedata.main_img = app.globalData.prefix_url + node.nodedata.main_img;
                        }
                    }
                });

                that.setData({
                    nodes: nodes
                });

                for (var i = 0, len = nodes.length; i < len; i++) {
                    if (nodes[i].component === "xinWen") {
                        that.handleNews(i);
                    } else if (nodes[i].component === "huoDong") {
                        that.handleExers(i);
                    } else if (nodes[i].component === "kanJia") {
                        that.handleBargains(i);
                    } else if (nodes[i].component === "pinTuan") {
                        that.handleGroup(i);
                    } else if (nodes[i].component === "chanPin") {
                        that.handleGoods(i);
                    }
                }
            }
        });
    },

    // 处理新闻数据
    handleNews: function(index) {
        var nodes = this.data.nodes,
            list = nodes[index].nodedata.list;
    },

    // 处理活动数据
    handleExers: function(index) {
        var nodes = this.data.nodes,
            list = nodes[index].nodedata.list;

        list.forEach(function(ele) {
            let time = util.formatTime(ele.access_rule.astart_time);
            time.pop();
            ele.date = time.join("/");
            ele.img = ele.img.startsWith("http") ? ele.img : (app.globalData.prefix_url + ele.img);

            ele.price = util.formatPrice(ele.access_rule.order.price);
        });

        this.setData({ nodes: nodes });
    },

    // 处理砍价数据
    handleBargains: function(index) {
        var nodes = this.data.nodes,
            now = new Date(),
            now = parseInt(now.getTime() / 1000),
            that = this,
            list = nodes[index].nodedata.list;

        list.forEach(function(ele) {
            if (!ele.product_info.img.startsWith("http")) ele.product_info.img = app.globalData.prefix_url + ele.product_info.img;
            ele.price = parseFloat(ele.lowest_price/100).toFixed(2);
            ele.ori_price = parseFloat(ele.ori_price/100).toFixed(2);

            var remainTime = ele.rule.end_time - now;
            ele.leftTime = remainTime;
            ele.remainTime = util.formatRemainTime(remainTime);
        });

        that.freshTime(index);

        this.setData({ nodes: nodes });
    },

    // 处理拼团数据
    handleGroup: function(index) {
        var nodes = this.data.nodes,
            list = nodes[index].nodedata.list;

        list.forEach(function(ele) {
            if (ele.main_img && !ele.main_img.startsWith("http")) ele.main_img = app.globalData.prefix_url + ele.main_img;
            ele.price =  ele.group_price/100;
        });

        this.setData({ nodes: nodes });
    },

    // 处理产品数据
    handleGoods: function(index) {
        var nodes = this.data.nodes,
            list = nodes[index].nodedata.list;

        list.forEach(function(good) {
            var img = good.main_img;
            good.img = img.startsWith("http") ? img : (app.globalData.prefix_url + img);
            
            good.price = parseFloat(good.price/100).toFixed(2);
        });

        this.setData({ nodes: nodes });
    },


    // 刷新时间
    freshTime: function(index) {
        var that = this;
        var nodes = this.data.nodes;
        var goodList = nodes[index].nodedata.list;
        var sh = setInterval(function() {
            goodList.forEach(function(ele) {
                ele.leftTime--;
                if (ele.leftTime < 0) {
                    ele.status = 1;
                } else {
                    ele.remainTime = util.formatRemainTime(ele.leftTime);
                }
            });

            that.setData({
                nodes: nodes
            });
        }, 1000);
    },

    // 小导航
    subNavTap: function(e) {
        var subUrl = e.currentTarget.dataset.link;
            // subUrl = subNav.link;

        if (!subUrl) return;

        if (subUrl.startsWith("map")) {
            var locArr = subUrl.split("-"),
                lat = parseFloat(locArr[1]),
                lng = parseFloat(locArr[2]),
                title = locArr[3];
            wx.openLocation({  
                latitude: lat,  
                longitude: lng,  
                scale: 18,  
                name: title,
                // address:'金平区长平路93号'
            });
        } else if (subUrl.startsWith("phone")) {
            var phone = subUrl.split("-")[1];
            wx.makePhoneCall({
                phoneNumber: phone
            });
        } else if (subUrl.startsWith("app")) {
            var appId = subUrl.split("-")[1];
            wx.navigateToMiniProgram({
                appId: appId,
                // path: 'pages/index/index?id=123',
                extraData: {
                    fromApp: 'mall'
                },
                // envVersion: 'develop',
                success(res) {
                // 打开成功
                }
            })
        } else if (subUrl.startsWith("web")) {
            var webUrl = subUrl.replace("web-", "");
            webUrl = encodeURIComponent(webUrl);
            console.log("webUrl >>>>>>", webUrl);
            wx.navigateTo({
                url: "pages/webPage/webPage?url=" + webUrl
            });
        } else if (subUrl.startsWith("vedio")) {
            var vedioUrl = subUrl.replace("vedio-", "");
            wx.navigateTo({
                url: "pages/vedioPage/vedioPage?" + vedioUrl
            });
        } else {
            wx.navigateTo({
                url: subUrl
            });
        }
    },

    // 点击推广图片
    tapImg: function(e) {
        var link = e.currentTarget.dataset.link;

        wx.navigateTo({
            url: link
        });
    },

    // 提交预约信息
    submitInfo: function(e) {
        console.log("post e >>", e);
        var info = e.detail.value;
        var contact = info.phone ? info.phone : "";
        if (!info.textarea) {
            wx.showModal({
                title: "温馨提示",
                content: "请输入建议内容",
                showCancel: false
            });
            return;
        }
        app.request({
            url: "_a=site&_u=ajax.add_message",
            data: {
                brief: info.textarea,
                contact: contact
            },
            success:(ret)=>{
                if (ret.data.errstr == "ERROR_OK") {
                    wx.showToast({
                        title: "提交成功"
                    });
                }
            }
        });
    },


    // 地图导航
    navToLoc: function(e) {
        console.log("e >>>>", e)
        var dataset = e.currentTarget.dataset,
            title = dataset.title,
            address = dataset.address,
            lat = parseFloat(dataset.lat),
            lng = parseFloat(dataset.lng);

        wx.openLocation({  
            latitude: lat,
            longitude: lng,
            scale: 18,  
            name: title,
            address: address
        });
    },

    // 打电话
    makePhone: function(e) {
        var phone = e.currentTarget.dataset.phone;
        wx.makePhoneCall({
            phoneNumber: phone
        });
    },

    // 下拉刷新
    onPullDownRefresh: function(){
        this.onLoad();
    },


    onPullDownRefresh: function () {

    },

    onReachBottom: function () {

    },

    /**
    * 用户点击右上角分享
    */
    onShareAppMessage: function () {

    }
})