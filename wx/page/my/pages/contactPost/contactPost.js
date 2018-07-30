// pages/contactPost/contactPost.js
var app = getApp();

Page({

    /**
     * 页面的初始数据
     */
    data: {
        date: "2018-01-08",
        time: "10:00",
    },

    /**
     * 生命周期函数--监听页面加载
     */
    onLoad: function (options) {
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
        var contactId = options.id;
        this.setData({
            id: options.uid,
            mainColor: app.globalData.main_color
        });

        // this.getContactInfo(contactId);
    },

    onShow: function () {
    
    },


    bindDateChange: function (e) {
        this.setData({
            date: e.detail.value
        })
    },
    bindTimeChange: function (e) {
        this.setData({
            time: e.detail.value
        })
    },

    // 提交信息表单
    submitInfo: function(e) {
        console.log("postdata >>>", e);
        var that = this;
        var id = that.data.id;
        var info = e.detail.value;
        if (info.phone && info.brief) {
            var time = that.data.date + "-" + that.data.time;

            app.request({
                url: "_a=book&_u=ajax.add_book_item_record",
                data: {
                    b_uid: id,
                    data: {
                        "姓名": info.name,
                        "电话": info.phone,
                        "预约时间": time,
                        "预约内容": info.brief,
                    }
                },
                success: (ret)=>{
                    if (ret.data && ret.data != 0) {
                        wx.showToast({
                            title: "提交成功！"
                        });
                    }
                }
            });
        } else {
            wx.showModal({
                title: "提交失败",
                content: "请输入完整信息",
                showCancel: false
            });
        }
    },

    onShareAppMessage: function () {
    
    }
})