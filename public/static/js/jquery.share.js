/**
**分享到朋友圈，分享给朋友
**/

;(function($){

	$.fn.shareToFriendCircle = function(options){

		var settings = $.extend({}, defaults, options); //将一个空对象作为第一个参数

        if(settings.wx_cfg) {
		  	settings.wx_cfg['debug'] = false;
		  	settings.wx_cfg['jsApiList'] = ['onMenuShareTimeline','onMenuShareAppMessage'];
		  	wx.config(settings.wx_cfg);

			wx.ready(function(){
				// 分享到朋友圈
				wx.onMenuShareTimeline({
				    title: settings.shareTitle, // 分享标题
				    desc: settings.shareDesc, // 分享描述
				    link: settings.shareLink, // 分享链接
				    imgUrl: settings.shareImgUrl, // 分享图标
				    success: function () {
				        // 用户确认分享后执行的回调函数
				        settings.success();
				    },
				    cancel: function () { 
				        // 用户取消分享后执行的回调函数
				        settings.cancel();
				    }
				});
				// 分享给朋友
				wx.onMenuShareAppMessage({
				    title: settings.shareTitle, // 分享标题
				    desc: settings.shareDesc, // 分享描述
				    link: settings.shareLink, // 分享链接
				    imgUrl: settings.shareImgUrl, // 分享图标
				    success: function () {
				        // 用户确认分享后执行的回调函数
				        settings.success();
				    },
				    cancel: function () { 
				        // 用户取消分享后执行的回调函数
				        settings.cancel();
				    }
				});
			});
		}

        var defaults = {
        	wx_cfg : '',
        	shareTitle : '',
        	shareDesc : '',
        	shareLink : '',
        	shareImgUrl : '',
        	success : function(){
        		//用户确认分享后执行的回调函数
        	},
        	cancel : function(){
        		//用户取消分享后执行的回调函数
        	}
        };

	};

})(jQuery);
