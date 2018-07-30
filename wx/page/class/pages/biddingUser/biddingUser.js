// page/class/pages/biddingUser/biddingUser.js
var app = getApp();
var util = require('../../../../utils/util.js');
var formatPrice = function(num) {
    var num = (num || 0).toString(), result = '';
    while (num.length > 3) {
        result = ',' + num.slice(-3) + result;
        num = num.slice(0, num.length - 3);
    }
    if (num) { result = num + result; }
    return result;
}

Page({

  /**
   * 页面的初始数据
   */
  data: {
    userList: [],
    showEmpty: false
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    this.getRecord(0, options.uid);
    this.setData({
      it_uid: options.uid
    });
  },

  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  onReady: function () {
  
  },

  getRecord: function(page, it_uid) {
    const that = this;

    app.request({
      url: '_a=auction&_u=ajax.get_record',
      data: {
        it_uid,
        page, limit: 20
      },
      success: (ret)=>{
        console.log(ret)
        let userList = that.data.userList,
            list = ret.data.list;

        if (page == 0) {
          userList = [];
        }

        list.forEach(function(ele) {
          let avatar = ele.su.avatar,
              time = util.formatTime(ele.start_time);
          ele.avatar = avatar.startsWith('http') ? avatar : (app.globalData.prefix_url + avatar);
          ele.price = util.formatBigPrice(parseInt(ele.price/100));
          ele.time = time.join('-');
        });

        userList = userList.concat(list);

        that.setData({
          userList, page,
          showEmpty: list.length < 20
        });
      }
    })

  },

  /**
   * 生命周期函数--监听页面显示
   */
  onShow: function () {
  
  },

  onPullDownRefresh: function () {
    let it_uid = this.data.it_uid;
    this.getRecord(0, it_uid)
  },

  /**
   * 页面上拉触底事件的处理函数
   */
  onReachBottom: function () {
    let page = this.data.page + 1,
        it_uid = this.data.it_uid;

    this.getRecord(page, it_uid);
  },

  onShareAppMessage: function () {
  
  }
})