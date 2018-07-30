var app = getApp();
var util = require('../../utils/util.js');
var isHandleBargain = true,
    isHandleSeckill = true,
    freshTimeArr = [];

Page({
    data: {
        mainColor: app.globalData.main_color,
        company_name: app.globalData.company_name,
        index_style: app.globalData.index_style,
        // inputShowed: false,
        inputVal: "",
        background: [],

		subNavs: [],
        subNavs2: [],

        otherClass: {
            uid: '0',
            list: [],
            title: '其它'
        },
        boardImg: app.globalData.server_url + "_u=common.img&name=board.png",

        contactInfo: null
    },

    onLoad: function(options) {
        var that = this;
        console.log("onload options >>>>", options);
        this.setData({
            mainColor: app.globalData.main_color,
            options:options
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });

        // 扫码分销功能
        if (options && options.parentId) {
            app.request({
                url: "_a=su&_u=ajax.update_su",
                data: {
                    from_su_uid: options.parentId
                },
                success: function(ret) {
                    console.log("add fans ret", ret);
                }
            });
        }

        // 获取构建页面
        this.getNodes();

        this.getSupport();
        // this.reload();
    },

	  // 获取全部商品函数
    getAllGoods_old: function() {
        var that = this;

        // 获取全部商品请求
        app.request({
            url: "_a=shop&_u=ajax.products",
            data: {
                limit: -1,
                // info:128---热销商品
                info: 128,
                is_groupp: 0
            },
            success: that.getGoodsCb_old
        });
    },
	// 获取所有商品后的回调函数
    getGoodsCb_old: function(ret) {
        var that = this;
        var goods = ret.data.list;
        console.log("all goods >>>>", ret);

        goods.forEach(function(ele) {
            //ele.main_img = app.globalData.prefix_url + ele.main_img;
		if (ele.main_img && !ele.main_img.startsWith('http')) ele.main_img = app.globalData.prefix_url + ele.main_img;
            ele.price = ele.group_price == 0 ? ele.price/100 : ele.group_price/100;
        });

        // 获取全部商品分类
        app.request({
            url: "_a=shop&_u=ajax.product_cats",
            success: function(res) {
                console.log("all cats >>>", res);
                var catList = [];
                var otherClass = that.data.otherClass;
                res.data.push(otherClass);
				console.log('otherClass ', otherClass);

                res.data.forEach(function(ele) {
                    ele.img = ele.image ? ele.image : '';
				if (!ele.img.startsWith('http')) ele.img = app.globalData.prefix_url + ele.img;
                    if (ele.parent_uid == '0') {
                        catList.push(ele);
                    }
                    ele.list = [];

                    goods.forEach(function(good) {
                        if (good.cat_uid == '0') {
                            otherClass.list.push(good);
                        } else if (good.cat_uid == ele.uid) {
                            ele.list.push(good);
                        } else if ((good.cat && good.cat.parent_uid == ele.uid)) {
                            ele.list.push(good);
                        }
                    });

                    ele.list.length >= 6 && (ele.list = ele.list.slice(0, 6));
                });
				console.log('otherClass1 ', otherClass);
                otherClass.list.length >= 6 && (otherClass.list = otherClass.list.slice(0, 6));
                catList.push(otherClass);

				console.log('otherClass2 ', otherClass);
                console.log("cat goods >>>>>", catList);

                that.setData({
                    catList: catList
                });
            }
        });

        // 停止刷鞋
        wx.stopPullDownRefresh();
    },

    // 获取技术支持
    getSupport: function() {
        let that = this;

        app.request({
            url: "_u=xiaochengxu.get_agent_info",
            success: function(ret) {
                console.log("get support ret >>>>>", ret);
                that.setData({
                    supportData: ret.data
                });
            }
        });
    },

    reload: function(options) {
        var that = this;

        that.getAllGoods();

		// 获取所有商品
        // that.getAllGoods_old();

        // 获取首页头部轮播图
        app.request({
            url: "_a=shop&_u=ajax.slides",
            success: function(ret) {
                console.log("background ret >>>>>", ret);
                var sliders = ret.data;
                sliders.forEach(function(ele) {
                    if (ele.image && !ele.image.startsWith('http')) ele.image = app.globalData.prefix_url + ele.image;
                });
                that.setData({
                    background: sliders
                });
            }
        });

        // 获取导航列表
        app.request({
            url: "_a=shop&_u=common.slides_list",
            data: {
                limit: -1,
                pos: "xiaochengxu1"
            },
            success: function(ret) {
                console.log("subNavs ret >>>>", ret);
                var subNavs = ret.data.list;
                if (subNavs.length > 0) {
                    subNavs.forEach(function(nav) {
                        if (nav.image && !nav.image.startsWith('http')) nav.image = app.globalData.prefix_url + nav.image;
                        // nav.url = nav.link;
                        nav.contact = nav.link.startsWith("contact");
                    });
                    that.setData({
                        subNavs: subNavs
                    });
                } else {
                    that.setData({
                        subNavs: that.data.subNavs2
                    });
                }
            }
        });

        // 获取公司信息
        app.request({
            url: "_a=shop&_u=ajax.shop",
            success: function(ret) {
                console.log("company data >>>>>", ret);
                var company = ret.data;
                wx.setNavigationBarTitle({
                    // title: "小程序商城"
                    title: company.title
                });
				app.globalData.main_color = '#'+company.color1;
				that.setData({
					mainColor: app.globalData.main_color
				});
				wx.setNavigationBarColor({frontColor:'#ffffff',backgroundColor:app.globalData.main_color});
            }
        });

        // 获取公告列表
        app.request({
            url: "_a=shop&_u=ajax.radio_list",
            success: function(ret) {
                console.log("radio_list info >>>>>>", ret);
                if (ret.data.list && ret.data.list.length > 0) {
                    var radioList = ret.data.list;
                    that.setData({
                        radioList: radioList
                    });
                }
            }
        });

        wx.stopPullDownRefresh()
    },


/*********************** 自定义编辑页面 ***********************/

    // 获取构建页面请求
    getNodes: function() {
        var that = this,
            postData = {},
            allData = {},
            storageNode = {};

        // 页面数据缓存
        try {
            storageNode = wx.getStorageSync('storageNode');
            console.log("storageNode >>>", storageNode);

            if (storageNode) {
                postData = {
                    modify_time: storageNode.modify_time
                };
                that.handleAllData(storageNode.allData);
            }
        } catch (e) {
            console.log("get node storageNode error >>>", e);
        }

        app.request({
            url: "_u=xiaochengxu.get_page&sort=999999",
            data: postData,
            success: (ret)=>{
                console.log("get node data ret >>>>>", ret);
                if (ret.errno == 304) {
                    // allData = storageNode.allData;
                    return;
                } else {
                    if (ret.data && ret.data.content) {
                        let nodeString = ret.data.content;
                        if (nodeString) allData = JSON.parse(nodeString);

                        if (!allData.nodes && !allData.basicInfo) {
                            that.reload();
                            return;
                        }
                        console.log("allData data >>>>>", allData);

                        let storageNodeValue = {
                            modify_time: ret.data.modify_time,
                            allData: allData
                        };
                        that.handleAllData(allData);

                        wx.setStorage({
                            key: "storageNode",
                            data: storageNodeValue
                        });
                    } else {
                        that.reload();
                    }
                }
            },
            fail: (ret)=>{
                that.reload();
            }
        });
    },

    // 处理页面数据
    handleAllData: function(allData) {
        var that = this;

        let nodes = allData.nodes;
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
                    if (!node.nodedata.imgUrl.startsWith("http")) node.nodedata.imgUrl = app.globalData.prefix_url + node.nodedata.imgUrl;
                    
                }
                if (node.nodedata.main_img) {
                    // node.nodedata.main_img = app.globalData.prefix_url + node.nodedata.main_img;
                    if (!node.nodedata.main_img.startsWith("http")) node.nodedata.main_img = app.globalData.prefix_url + node.nodedata.main_img;
                }
            }
        });

        that.setData({
            nodes: nodes
        });
        wx.stopPullDownRefresh();

        // 处理tabbar的数据
        if (allData.basicInfo) {
            var basicInfo = allData.basicInfo,
                contactInfo = basicInfo.contactInfo,
                tabData = basicInfo.tabData;
            
            wx.setNavigationBarTitle({
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
                    for (var i = 0; i < tabList.length; i++) {
                        var iconPath = tabList[i].iconPath,
                            selectediconpath = tabList[i].selectedIconPath;

                        wx.setTabBarItem({
                            index: i,
                            text: tabList[i].text,
                            iconPath: iconPath,
                            selectedIconPath: selectediconpath
                        });
                    }
                }
                // if (!basicInfo.isxcxtab) wx.hideTabBar();
            }
        }

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
                isHandleBargain = false;
            } else if (nodes[i].component === "pinTuan") {
                that.handleGroup(i);
            } else if (nodes[i].component === "chanPin") {
                that.handleGoods(i);

            } else if (nodes[i].component === "miaoSha") {
                seckillArr.push(i);
                isHandleSeckill = false;
            }
        }

        freshTimeArr = bargainIdxArr.concat(seckillArr);

        if (bargainIdxArr.length) that.handleBargains(bargainIdxArr);
        if (seckillArr.length) that.handleSeckill(seckillArr);
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
            nodedata = nodes[index].nodedata,
            that = this;

        if (nodedata.uidArr && nodedata.uidArr.length) {
            let uidArr = [];
            if (nodedata.uidArr.length > 20) {
                uidArr = nodedata.uidArr.slice(0, 20).join(';');
            } else {
                uidArr = nodedata.uidArr.join(";");
            }
            this.getGoodsByIds(index, uidArr);
        } else if (nodedata.list && nodedata.list.length) {
            let list = [];
            if (nodedata.list.length > 20) {
                list = nodedata.list.slice(0, 20);
            } else {
                list = nodedata.list;
            }
            list.forEach(function(good) {
                let img = good.main_img;
                good.img = img.startsWith("http") ? img : (app.globalData.prefix_url + img);
            });
            this.setData({ nodes: nodes });
        }
    },

    // 根据uids获取商品函数
    getGoodsByIds: function(index, uidArr) {
        var that = this;
        // var nodes = that.data.nodes;

        // 获取全部商品请求
        app.request({
            url: "_a=shop&_u=ajax.products",
            data: {
                limit: -1,
                uids: uidArr,
                // info:128---热销商品
                // ,is_group: 0
            },
            success: (ret)=>{
                var goods = ret.data.list;
                var nodes = that.data.nodes;
                console.log("get goods by uids >>>>", ret);

                goods.forEach(function(ele) {
                    if (ele.main_img && !ele.main_img.startsWith('http')) ele.main_img = app.globalData.prefix_url + ele.main_img;
                    ele.price = ele.group_price == 0 ? parseFloat(ele.price/100).toFixed(2) : parseFloat(ele.group_price/100).toFixed(2);
                    ele.oriPrice = parseFloat(ele.ori_price/100).toFixed(2);
                });

                nodes[index].nodedata.list = goods;

                console.log("getGoodsCb nodes >>>", nodes);

                that.setData({
                    nodes: nodes
                });
            }
        });
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
                url: "pages/vedioPage/vedioPage?src=" + vedioUrl
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

    // 预览图片
    previewImg: function(e) {
        var src = e.currentTarget.dataset.src;

        wx.previewImage({
            current: src,
            urls: [src]
        });
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

/*********************** 自定义编辑页面 ***********************/















    

    // 获取全部商品函数
    getAllGoods: function() {
        var that = this;

        // 获取全部商品请求
        app.request({
            url: "_a=shop&_u=ajax.products",
            data: {
                limit: -1,
                // info:128---热销商品
                info: 128
                // ,is_group: 0
            },
            success: that.getGoodsCb
        });
    },

    // 获取所有商品后的回调函数
    getGoodsCb: function(ret) {
        var that = this;
        var goods = ret.data.list;
        var nodes = that.data.nodes;
        console.log("all goods >>>>", ret);

        goods.forEach(function(ele) {
            if (ele.main_img && !ele.main_img.startsWith('http')) ele.main_img = app.globalData.prefix_url + ele.main_img;
            ele.price = ele.group_price == 0 ? ele.price/100 : ele.group_price/100;
            ele.oriPrice = parseFloat(ele.ori_price/100).toFixed(2);
        });

        // 获取全部商品分类
        app.request({
            url: "_a=shop&_u=ajax.product_cats",
            success: function(res) {
                console.log("all cats >>>", res);
                var catList = [];
                var otherClass = that.data.otherClass;
                res.data.push(otherClass);

                res.data.forEach(function(ele) {
                    if (ele.image && !ele.image.startsWith('http')) ele.image = app.globalData.prefix_url + ele.image;
                    if (ele.parent_uid == '0') {
                        catList.push(ele);
                    }
                    ele.list = [];

                    goods.forEach(function(good) {
                        if (good.cat_uid == '0') {
                            otherClass.list.push(good);
                        } else if (good.cat_uid == ele.uid) {
                            ele.list.push(good);
                        } else if ((good.cat && good.cat.parent_uid == ele.uid)) {
                            ele.list.push(good);
                        }
                    });

                    ele.list.length >= 6 && (ele.list = ele.list.slice(0, 6));
                });
                otherClass.list.length >= 6 && (otherClass.list = otherClass.list.slice(0, 6));
                // 其它 分类（商品无分类）
                // catList.push(otherClass);

                console.log("cat goods >>>>>", catList);

                // nodes.forEach(function(node) {
                //     if (node.id == "goods") {
                //         node.catList = catList;
                //     } else if (node.id.startsWith("good")) {
                //         node.goods = goods
                //     }
                // });

                that.setData({
                    nodes: nodes,
                    catList: catList,
                    goods: goods
                });
            }
        });

        // 停止刷鞋
        wx.stopPullDownRefresh();
    },

    // 下拉刷新
    onPullDownRefresh: function(){
        this.getNodes();
    },

    onShareAppMessage: function () {
        var shareUrl = "/page/index/index?parentId=" + app.globalData.su_uid;
        var shareInfo = {
            // title: "",
            path: shareUrl
        };
        return shareInfo;
    },

    navToClass: function(e) {
        var id = e.currentTarget.id;
        wx.navigateTo({
            url: "../class/pages/classGoods/classGoods?classId=" + id
        });
    }
});
