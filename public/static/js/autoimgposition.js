(function($){
	var defaults = {
		
	}
	$.fn.autoPosition = function(options){
		var settings = $.extend(true,{},defaults, options);
		this.each(function(){
			var $this = $(this);
			/*$this.parent().css('position','relitive');*/
			$this.css({
				'position':'relative',
				'max-width':'none',
				'max-height':'none',
				
			}).parent()
			.css({
				'position':'relative',
				'overflow':'hidden'
			});
			var parent_box = {
				width:$this.parent().width(),
				height:$this.parent().height()
			}
			
			var img_url =  $this.attr('src');
			var origin_img = new Image();
			origin_img.src = img_url;
			var originHW = setInterval(function () {
				if(origin_img.width>0 || origin_img.height>0){
					console.log(parent_box,origin_img);
					console.log(parent_box.width,origin_img.width);
					//成功获取原图长宽和盒子长宽
					var parent_length_width = parent_box.height/parent_box.width;
					var img_length_width = origin_img.height/origin_img.width;

					console.log(parent_length_width,img_length_width);/*长宽比*/


					if(parent_length_width>=img_length_width){
						console.log('in');

						$this.height(parent_box.height);
						var new_width = parent_box.height/img_length_width;
						var left = (new_width-parent_box.width)/2;

						$this.css({
							'left':'-'+left+'px',
							'width':'auto'
						});

					}
					else{
						$this.width(parent_box.width);
						var new_height = parent_box.width*img_length_width;
						var top = (new_height-parent_box.height)/2;

						$this.css({
							'top':'-'+top+'px',
							'height':'auto'
						});						
					}

        			clearInterval(originHW);
    			}	
			},50);
		})
	}
})(jQuery);

// $('img[data-auto-position]').autoPosition()