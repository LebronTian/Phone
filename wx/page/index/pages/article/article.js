var app = getApp();
var WxParse = require('../../../common/wxParse/wxParse.js');
var util = require('../../../../utils/util.js')


Page({

    data: {
        mainColor: app.globalData.main_color    
    },

    onLoad: function (options) {
        var that = this;
        this.setData({
            mainColor: app.globalData.main_color
        });
        wx.setNavigationBarColor({
            frontColor: '#ffffff',
            backgroundColor: app.globalData.main_color,
        });
        if (options.uid) {
            that.getArticle(options.uid);
        } else if (options.type_in) {
            that.getDeal(options.type_in);
        } else if (options.showId) {
            that.getShowArticle(options.showId);
        } else if (options.newsId) {
            that.getNews(options.newsId);
        }
    },

    getArticle: function(id) {
        var that = this;
        app.request({
          url: "_a=shop&_u=common.article",
          data: {
            uid: id
          },
          success: that.getMsgCb
        });
    },

    getNews: function(id) {
        var that = this;
        app.request({
          url: "_a=site&_u=ajax.article",
          data: {
            uid: id
          },
          success: that.getMsgCb
        });
    },

    getShowArticle: function(id) {
        var that = this;
        app.request({
          url: "_a=site&_u=ajax.article",
          data: {
            uid: id
          },
          success: that.getMsgCb
        });
    },

    // 获取商家入驻条款
    getDeal: function(type_in) {
      var that = this;
        app.request({
            url: "_a=shop&_u=ajax.get_user_agreement",
            data: {
                type_in: type_in
            },
            success: that.getMsgCb
        });
    },

    getMsgCb: function(ret) {
        var that = this;
        console.log("article ret >>>", ret);
        var article = ret.data;
        var time = util.formatTime(article.create_time);
        article.time = time[0] + "-" + time[1] + "-" + time[2];

        var content = article.content;
        WxParse.wxParse('content', 'html', content, that, 5);
                
        that.setData({
          article: article
        });
    },

  onShareAppMessage: function () {
  
  }
})