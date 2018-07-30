/**
 *	使用方式：loading(str,option,type,time);
 *	1、str  '数据加载中...'
 *	2、option  'show' => 显示	'hide' => 隐藏
 *	3、若option参数为show：str不能为空；参数为hide：str可空
 *	4、time 为显示时间，为空表示不限制时间
 *	5、type	两种类型（必选）	默认default	覆盖cover
 **/

/*
	传入参数
	参数1	str 提示文字
	参数2	show 显示 hide 隐藏
*/
function loading(str,display,type,time) {
	
	//初始化清除元素
	if(type=='default'){
		$('#my-loading-default').remove();
	}
	else if(type=='cover'){
		$('#my-loading-cover').remove();
	}

	//显示隐藏参数判断
	if(display=='show'){
		display = 'block';
	}
	else if(display=='hide'){
		display = 'none';
	}
	
	//创建元素
	var html = create_html(str,display,type);
	$('body').prepend(html);
	
	//是否传入时间参数
	setTimeOut(type,time);

}

/*
	创建元素
*/
function create_html(string,display,type) {
	
	if(type=='default'){
		var html= '<div id="my-loading-default" style="display:'
				+display
				+'"><div>'
				+'<div><div id="floatingCirclesG">'
				+'<div class="f_circleG" id="frotateG_01"></div>'
				+'<div class="f_circleG" id="frotateG_02"></div>'
				+'<div class="f_circleG" id="frotateG_03"></div>'
				+'<div class="f_circleG" id="frotateG_04"></div>'
				+'<div class="f_circleG" id="frotateG_05"></div>'
				+'<div class="f_circleG" id="frotateG_06"></div>'
				+'<div class="f_circleG" id="frotateG_07"></div>'
				+'<div class="f_circleG" id="frotateG_08"></div>'
				+'</div></div><p>'
				+string
				+'</p></div></div>';
		return html;
	}
	else if(type=='cover'){
		var html= '<div id="my-loading-cover" style="display:'
				+display
				+'"><div><div class="cssload-thecube">'
				+'<div class="cssload-cube cssload-c1"></div>'
				+'<div class="cssload-cube cssload-c2"></div>'
				+'<div class="cssload-cube cssload-c4"></div>'
				+'<div class="cssload-cube cssload-c3"></div>'
				+'</div><p>'
				+string
				+'</p></div></div>';
		return html;
	}

}

/*
	定时显示（有时间参数）
*/
function setTimeOut(type,time) {

	if(time && type=='default') {
		setTimeout(function(){
			$('#my-loading-default').css({'display':'none'});
		},time);
	}
	else if(time && type=='cover'){
		setTimeout(function(){
			$('#my-loading-cover').css({'display':'none'});
		},time);
	}

}






























