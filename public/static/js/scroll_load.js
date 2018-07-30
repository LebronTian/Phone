/*

	简易滚动加载

	http://olado.github.io/doT/index.html
	模板解析使用了 doT
	<script src="/static/js/doT.min.js"></script>
	
	option = {
		'ele_container' : '#id_content', //容器选择器
		'ele_dot_tpl' : '#id_tpl', //模板选择器

		'url': '?_a=expresstui&_u=ajax.applist', //数据接口
		'g_data_name': //可选， 保存数据到此变量
	}
*/


function scroll_load(option) {
	var g_url = option.url;
	var g_page = option.page || 0;
	var g_limit= option.limit || 10;
	var g_over = 0;
	var g_running = 0;
	var g_dot = doT.template($(option.ele_dot_tpl).html());

	if(!option.onfinish)  option.onfinish = function(){
		$(option.ele_container).append('<p style="text-align:center;color:gray;">没有数据了。。。</p>');
	};	
	if(option.g_data_name) window[option.g_data_name] = {};

	function get_data_list() {
			if(g_running || g_over) return;
			g_running = 1;
			$.post(g_url, {page: g_page++, limit: g_limit}, function(ret){
				g_running = 0;
				ret = $.parseJSON(ret);
				if(!ret.data.list || !ret.data.list.length) {
					g_over = 1;
					option.onfinish && option.onfinish(option);
					return;
				}
	
				//console.log('hehe', ret.data.list.length);
				$.each(ret.data.list, function(ii, i){
					//console.log('append ...');
					$(option.ele_container).append(g_dot(i));
					if(option.g_data_name)
					window[option.g_data_name][i.uid] = i;
				});
			});
		}
	
		$(window).scroll(function(){
			if($(this).scrollTop()+$(window).height()+80>=$(document).height()){
				//console.log('scrll .....');
				get_data_list();
		}
		});	

		//触发一下
		if(!option.no_go) {
			get_data_list();
		}
}

