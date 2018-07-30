/***********************************************
	1、闭包区域 首尾 加上分号，防止插件与使用者函数末尾未加分号引发的报错
	2、语句结束都加上分号
***********************************************/
;(function ($) {

	$.fn.createLoad = function (options) {

		//在这里this指的是jquery选中的元素（有可能是元素集合）
		//defaults默认参数
		var defaults = {
			position: 'fixed',
			left: '0',
			top : '0',
			width: '100%',
			height: '100%',
			background: '#34495e',
			showContainer: 'container1',
			toHideTime: 1500,
			zIndex: 999
		};

		//加上空对象 {} 保护defaults里设置的默认值
		var settings = $.extend({},defaults,options);

		//结构
		var container01 = '<div class="loadBar container1"><div class="bubblingG"><span id="bubblingG_1"></span><span id="bubblingG_2"></span><span id="bubblingG_3"></span></div></div>';
		var container02 = '<div class="loadBar container2"><div class="cssload-thecube"><div class="cssload-cube cssload-c1"></div><div class="cssload-cube cssload-c2"></div><div class="cssload-cube cssload-c4"></div><div class="cssload-cube cssload-c3"></div></div></div>';

		var $this = this;

		var styles = {
			'position' : settings.position,
			'width' : settings.width,
			'height' : settings.height,
			'top' : settings.top,
			'left' : settings.left,
			'z-index' : settings.zIndex
		};

		$this.css(styles);

		$this.each(function(){
			
			var i = settings.showContainer;
			switch(i) {
				case 'container1':
					$this.html(container01);
					break;
				case 'container2':
					$this.html(container02);
					break;
				default :
					$this.html(container01);
			};

		});

		setTimeout(function(){
			$this.fadeOut();
		},settings.toHideTime);

		return this.css({
			'background' : settings.background
		});

	};

	function positionCenter() {
		var windowW = $(window).width();
		var windowH = $(window).height();
		var loadW = $('.loadBar').outerWidth();
		var loadH = $('.loadBar').outerHeight();
		$('.loadBar').css({
			'position' : 'absolute',
			'left' : (windowW/2) - (loadW/2),
			'top' : (windowH/2) - (loadH/2)
		});
	};

	// $(window).load(function(){
	// 	positionCenter();
	// });
	window.onload = function(){
		positionCenter();
	};


})(jQuery);