// page/test/test.js
Page({
  /**
   * 页面的初始数据
   */
  data: {
 	tpl_json: [] 
  },

  /**
   * 生命周期函数--监听页面显示
   */
  onShow: function () {
	var tpl = [
		{'type': 'search', 'search_btn': '搜一搜', 'url': '../index/pages/search/search'}
		,{'type':'slide', 'background':[{'img': 'https://weixin.uctphp.com/?_a=upload&_u=index.out&uidm=17611eca6',}]
		}
		,{'type': 'placard', 'content': '公告1', 'url': '../index/pages/placard/placard'}
		,{'type': 'search', 'search_btn': '搜二搜'}
		,{'type':'slide', 'background':[{'img': 'http://weixin.uctphp.com/?_a=upload&_u=index.out&uidm=17612e56f',}]
		}
		,{'type': 'search', 'search_btn': '搜三搜', 'url': '../index/index'}
	];  

	this.setData({tpl_json: tpl});
  },

})
