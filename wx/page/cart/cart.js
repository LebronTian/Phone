var app = getApp()
Page({
    data: {
        mainColor: "",
        
    	selectedAll: true,
        selectedImg: app.globalData.server_url + "_u=common.img&name=selected.png",

        otherClass: {
            uid: '0',
            list: [],
            title: '其它'
        },
    },

    onLoad: function(options) {
        this.setData({
            mainColor: app.globalData.main_color
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: this.data.mainColor,
        });
    },

    onShow: function() {
    	var that = this;

    	var cart = wx.getStorage({
    		key: "cart",
    		success: function(ret) {
    			var goods = ret.data.list;
                console.log("cart goods >>>>", goods);
    			if (goods.length === 0) {
                    that.setData({
                        cartEmpty: true
                    });
                    return;
                }

    			// 获取全部商品分类
		        app.request({
		            url: "_a=shop&_u=ajax.product_cats",
		            success: function(res) {                
		                var catList = [];
                        var otherClass = that.data.otherClass;
                        res.data.push(otherClass);
                        
                        console.log("all cats >>>>", res.data);

		                res.data.forEach(function(ele) {
		                    
		                    ele.list = [];
                            ele.editStatus = false;

		                    goods.forEach(function(good) {
		                    	good.selected = true;
                                var img = good.detailData.main_img;
                                good.img = img.startsWith("http") ? img : (app.globalData.prefix_url + img);
		                        
                                if (good.detailData.cat_uid === '0') {
                                    otherClass.list.push(good);
                                } else if (good.detailData.cat_uid == ele.uid) {
                                    good.catTitle = ele.title;
		                            ele.list.push(good);
		                        }
                                
		                    });

		                    if (ele.list.length > 0) {
		                        catList.push(ele);
		                    }
		                });
		                that.calculate(catList);
		            }
		        });
    		},
            fail: function(ret) {
                that.setData({
                    cartEmpty: true
                });
            }
    	});
    },


    getCart: function() {
        var that = this;

        // 获取购物车全部商品
        app.request({
            url: "_a=shop&_u=ajax.cart",
            success: function(ret) {                
                console.log("cart ret >>>>", ret);
            }
        });
    },

	// 全选／全不选
    bindSelectAll: function() {
    	var that = this;
    	var catList = that.data.catList;

    	var selectedAllStatus = !that.data.selectedAll;

    	catList.forEach(function(cat) {
    		cat.list.forEach(function(good) {
    			good.selected = selectedAllStatus;
    		});
    	});

    	that.calculate(catList);
    },

    // 选择／不选择 该商品
    bindSelect: function(e) {
    	var id = e.currentTarget.id.split('-');
    	var that = this;
    	var catList = that.data.catList;

        var index = id[0],
            subIndex = id[1];

        catList[index]['list'][subIndex].selected = !catList[index]['list'][subIndex].selected;

    	that.calculate(catList);
    },

    // 编辑某商品
    bindEdit: function(e) {
        var that = this;
        var id = e.currentTarget.id;
        var catList = that.data.catList;

        catList.forEach(function(cat) {
            if (cat.uid == id) {
                cat.editStatus = !cat.editStatus;
            }            
        });

        that.setData({
            catList: catList
        });
    },

    // 编辑该商品的数量
    editNum: function(e) {
        var that = this;
        var id = e.currentTarget.id.split('-');
        var method = id[0],
            index = id[1],
            subIndex = id[2];

        var catList = that.data.catList;
        
        var cart = {
            list: []
        };

        var good = catList[index]['list'][subIndex];
        good.selectedNum = method === "add" ? (good.selectedNum + 1) : (good.selectedNum - 1);
        good.selectedNum = good.selectedNum <= 1 ? 1 : good.selectedNum;

        catList.forEach(function(cat) {
            cart.list = cart.list.concat(cat.list);
        });

        wx.setStorage({
            key: "cart",
            data: cart
        });

        that.calculate(catList);
    },

    // 删除选择的商品
    bindDelete: function(e) {
        var that = this;
        var id = e.currentTarget.id.split('-');
        var catList = that.data.catList;
        console.log("delete id >>>", id);
        var index = parseInt(id[0]),
            subIndex = parseInt(id[1]);

        var cart = {};
        cart.list = [];

        catList[index]['list'].splice(subIndex, 1);

        catList.forEach(function(cat) {
            if (cat.list.length > 0) {
                cart.list = cart.list.concat(cat.list);
            }
        });

        wx.setStorage({
            key: "cart",
            data: cart
        });

        var newCatList = [];
        catList.forEach(function(ele) {
            if (ele.list.length > 0) {
                newCatList.push(ele);
            }
        });

        console.log("delete cart >>>>>", newCatList);        

        that.calculate(newCatList);
    },

    // 记录当前选中商品 计算价格、全选状态
    calculate: function(catList) {
    	var that = this;
    	var selectedAll = true;
    	var selectedEmpty = true;
    	var total = 0;
        var cartEmpty = false;

        if (catList.length === 0) {
            cartEmpty = true
        } else {
            // 计算总价格 并判断是否全选
            catList.forEach(function(cat) {
                cat.list.forEach(function(good) {
                    if (good.selected) {
                        total += good.price * good.selectedNum;
                        selectedEmpty = false;
                    } else {
                        selectedAll = false;
                    }
                });
            });
        }
        total = parseFloat(total).toFixed(2);

    	that.setData({
    		catList: catList,
    		selectedAll: selectedAll,
    		selectedEmpty: selectedEmpty,
    		totalPrice: total,
            cartEmpty: cartEmpty
    	});
        console.log("good list >>>>", catList);
    },

    // 前往订单结算页面
    navToOrder: function() {
    	var disable = this.data.selectedEmpty;

    	if (!disable) {
            var catList = this.data.catList;
            var order = {};
            order.list = [];

            // 筛选出用户选择的商品
            catList.forEach(function(cat) {
                cat.list.forEach(function(good) {
                    if (good.selected) {
                        order.list.push(good);
                    }
                });
            });

            // 将选中的订单存入本地
            wx.setStorage({
                key: "order",
                data: order
            });

    		wx.navigateTo({
    			url: "../class/pages/order/order?from=cart"
    		});
    	}
    }
});