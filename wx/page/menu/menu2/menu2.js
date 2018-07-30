// page/menu/menu2/menu2.js
var app = getApp();
var util = require('../../../utils/util.js');
var isHandleBargain = true,
    isHandleSeckill = true,
    freshTimeArr = [];

Page({

    data: {
        nodes: []
    },

    onLoad: function (options) {
        // 获取构建页面
        this.getNodes();

        this.setData({
            mainColor: app.globalData.main_color
        });
    },

    onShow: function () {

    },

    // 获取构建页面请求
    getNodes: function() {
        var that = this,
            handleComponentArr = ["xinWen", "huoDong", "kanJia", "pinTuan", "chanPin"];

        app.request({
            url: "_u=xiaochengxu.get_page",
            data: { title: "menu2" },
            success: (ret)=>{
                var nodeString = ret.data.content;
                var allData = nodeString ? JSON.parse(nodeString) : {};                

                if (!allData.nodes && !allData.basicInfo) {
                    that.reload();
                    return;
                }
                console.log("allData data >>>>>", allData);

                if (allData.basicInfo) {
                    var basicInfo = allData.basicInfo,
                        contactInfo = basicInfo.contactInfo,
                        tabData = basicInfo.tabData;
                    
                    wx.setNavigationBarTitle({
                        // title: basicInfo.title || basicInfo.xcxname
                        title: basicInfo.title || basicInfo.pageTitle || basicInfo.xcxname
                    });

                    if (contactInfo && contactInfo.show) {
                        let backImg = contactInfo.imgUrl ? contactInfo.imgUrl : contactInfo.defaultImgUrl;
                        if (backImg.startsWith("http")) {
                            contactInfo.imgUrl = backImg;
                        } else {
                            contactInfo.imgUrl = app.globalData.prefix_url + backImg;
                        }
                        that.setData({
                            contactInfo: contactInfo
                        });
                    }

                    if (tabData) {
                        wx.setNavigationBarColor({
                            frontColor: "#ffffff",
                            backgroundColor: tabData.backgroundColor || app.globalData.main_color,
                        });

                        that.setData({
                            mainColor: tabData.backgroundColor,
                        });

                        wx.setTabBarStyle({
                            color: tabData.color,
                            selectedColor: tabData.selectedColor,
                            backgroundColor: '#f4f5f5'
                        });

                        var tabList = tabData.list;
                        if (basicInfo.isxcxtab && tabList && tabList.length > 0) {
                            wx.showTabBar();

                            console.log("show tabbar >>>",tabList);

                            for (var i = 0; i < tabList.length; i++) {
                                var iconPath = tabList[i].iconPath.replace("/app/shop/static/modules/images/tabbar", "page/resources/pic/tab"),
                                    selectediconpath = tabList[i].selectedIconPath.replace("/app/shop/static/modules/images/tabbar", "page/resources/pic/tab");
                                wx.setTabBarItem({
                                    index: i,
                                    text: tabList[i].text,
                                    iconPath: iconPath,
                                    selectedIconPath: selectediconpath
                                });
                            }
                        }

                        if (!basicInfo.isxcxtab) wx.hideTabBar();
                    }
                }

                var nodes = allData.nodes;
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
                    mainColor: basicInfo.xcxcolor,
                    nodes: nodes
                });
                wx.stopPullDownRefresh();

                var bargainIdxArr = [],
                    seckillArr = [];

                for (var i = 0, len = nodes.length; i < len; i++) {
                    if (nodes[i].component === "xinWen") {
                        that.handleNews(i);
                    } else if (nodes[i].component === "huoDong") {
                        that.handleExers(i);
                    } else if (nodes[i].component === "kanJia") {
                        // 多个砍价刷新时间bug
                        bargainIdxArr.push(i);
                    } else if (nodes[i].component === "pinTuan") {
                        that.handleGroup(i);
                    } else if (nodes[i].component === "chanPin") {
                        that.handleGoods(i);
                    } else if (nodes[i].component === "miaoSha") {
                        seckillArr.push(i);
                    }
                }

                freshTimeArr = bargainIdxArr.concat(seckillArr);

                if (bargainIdxArr.length) that.handleBargains(bargainIdxArr);
                if (seckillArr.length) that.handleSeckill(seckillArr);
            }
        });
    },

    // 处理新闻数据
    handleNews: function(index) {
        var nodes = this.data.nodes,
            list = nodes[index].nodedata.list;

        list.forEach(function(ele) {
            let time = util.formatTime(ele.create_time);
            time.pop();
            ele.addTime = time.join("-");
        });
        this.setData({ nodes: nodes });
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
    handleBargains: function(indexArr) {
        var nodes = this.data.nodes,
            now = new Date(),
            now = parseInt(now.getTime() / 1000),
            that = this;

        for (let i = 0; i < indexArr.length; i++) {
            let idx = indexArr[i];
            let list = nodes[idx].nodedata.list;

            list.forEach(function(ele) {
                if (!ele.main_img.startsWith("http")) ele.main_img = app.globalData.prefix_url + ele.main_img;
                ele.price = parseFloat(ele.lowest_price/100).toFixed(2);
                ele.ori_price = parseFloat(ele.ori_price/100).toFixed(2);

                var remainTime = ele.rule.end_time - now;
                ele.leftTime = remainTime;
                ele.remainTime = util.formatRemainTime(remainTime);
            });
        }

        isHandleBargain = true;
        if (isHandleBargain && isHandleSeckill) that.freshTime();

        this.setData({ nodes: nodes });
    },

    // 处理秒杀数据
    handleSeckill: function(indexArr) {
        var nodes = this.data.nodes,
            now = new Date(),
            now = parseInt(now.getTime() / 1000),
            that = this;

        for (let i = 0; i < indexArr.length; i++) {
            let idx = indexArr[i];
            let list = nodes[idx].nodedata.list;

            list.forEach(function(ele) {

                if (ele.main_img && !ele.main_img.startsWith("http")) ele.main_img = app.globalData.prefix_url + ele.main_img;
                ele.ori_price = parseFloat(ele.ori_price/100).toFixed(2);
                ele.price = (parseFloat(ele.price)/100).toFixed(2);

                // 处理秒杀时间
                let startTime = parseInt(ele.kill_time.start_time);
                let endTime = parseInt(ele.kill_time.end_time);

                if (now < startTime) {
                    ele.seckillStatus = 0;
                    let remainTime = startTime - now;
                    ele.startLeftTime = remainTime;
                    ele.startTime = util.formatRemainTime(remainTime);
                    ele.endLeftTime = endTime - startTime;
                } else if (now < endTime) {
                    ele.seckillStatus = 1;
                    let remainTime = endTime - now;
                    ele.endLeftTime = remainTime;
                    ele.endTime = util.formatRemainTime(remainTime);
                } else {
                    ele.seckillStatus = 2;
                }
            });
            
        }

        isHandleSeckill = true;        
        if (isHandleBargain && isHandleSeckill) that.freshTime();

        this.setData({ nodes: nodes });
    },

    // 处理拼团数据
    handleGroup: function(index) {
        var nodes = this.data.nodes,
            list = nodes[index].nodedata.list;

        list.forEach(function(ele) {
            if (ele.main_img && !ele.main_img.startsWith("http")) ele.main_img = app.globalData.prefix_url + ele.main_img;
            ele.price = parseFloat(ele.group_price/100).toFixed(2);
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
            // good.price = parseFloat(good.price/100).toFixed(2);
        });

        console.log("good list >>>>>", list);

        this.setData({ nodes: nodes });
    },

    // 刷新时间
    freshTime: function() {
        var that = this,
            nodes = that.data.nodes;

        console.log("length >>>>", freshTimeArr);
            
        var sh = setInterval(function() {
            for (let i = 0; i < freshTimeArr.length; i++) {
                let idx = freshTimeArr[i],
                    goodData = nodes[idx],
                    goodList = goodData.nodedata.list;

                if (goodData.component === "kanJia") {

                    goodList.forEach(function(ele) {
                        ele.leftTime--;
                        if (ele.leftTime < 0) {
                            ele.status = 1;
                        } else {
                            ele.remainTime = util.formatRemainTime(ele.leftTime);
                        }
                    });
                } else if (goodData.component === "miaoSha") {
                    goodList.forEach(function(ele) {
                        if (ele.seckillStatus == 0) {
                            ele.startLeftTime--;
                            if (ele.startLeftTime < 0) {
                                ele.seckillStatus = 1;
                            } else {
                                ele.startTime = util.formatRemainTime(ele.startLeftTime);
                            }
                        } else if (ele.seckillStatus == 1) {
                            ele.endLeftTime--;
                            if (ele.endLeftTime < 0) {
                                ele.seckillStatus = 2;
                            } else {
                                ele.endTime = util.formatRemainTime(ele.endLeftTime);
                            }
                        }
                    });
                }
            }

            that.setData({
                nodes: nodes
            });
        }, 1000);
    },

    // 小导航
    subNavTap: function(e) {
        console.log("subNavTap e >>", e);
        var subUrl = e.currentTarget.dataset.link;
            // subUrl = subNav.link;

        if (e.detail.formId) {
            subUrl = e.detail.target.dataset.link;
            app.request({
                url: "_a=su&_u=ajax.add_form_id",
                data: {form_id: e.detail.formId},
            });
        }

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
                url: subUrl,
                fail: ()=>{
                    wx.switchTab({
                        url: subUrl
                    });
                }
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
        var bookId = e.currentTarget.dataset.id;
        var info = e.detail.value;
        var contact = info.phone ? info.phone : "";
        if (!info.phone) {
            wx.showModal({
                title: "温馨提示",
                content: "请输入预约电话",
                showCancel: false
            });
            return;
        }
        app.request({
            url: "_a=book&_u=ajax.add_book_item_record",
            data: {
                b_uid: bookId,
                data: {
                    "姓名": info.name,
                    "电话": info.phone
                }
            },
            success:(ret)=>{
                console.log("book return >>>>", ret);
                if (ret.data && ret.data != 0) {
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