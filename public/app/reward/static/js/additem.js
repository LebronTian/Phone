$(document).ready(function () {
//百度富编辑器初始化
	var ue = UE.getEditor('container');

//获取url参数
	function getUrlParam(name) {
		var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
		var r = window.location.search.substr(1).match(reg);  //匹配目标参数
		if (r != null) return unescape(r[2]); return null; //返回参数值
	}
	var n_uid = getUrlParam('n_uid');
	n_uid = parseInt(n_uid);

	var text;
	$('.save').click(function(){
		ue.ready(function(){
			text = ue.getContent();
		});
		var title = $('#id_title').val();
		var brief = text;
		var img = $('#id_img').attr('src');
		var total_cnt = $('#id_total_cnt').val();
		var weight = $('#id_weight').val();
		if($.trim(weight)!=""&&(weight<0||weight>10000)){
			showTip('err','请重新填写概率',1000);
			return false;
		}
		var win_cnt = $('#id_win_cnt').val();
		var sort = $('#id_sort').val();
		//var v_uid = v_uid;

		if($.trim(title)==""){
			showTip('err','标题不能为空',1000);
			return false;
		}
		var data = {
			r_uid:r_uid,
			uid:uid,
			title:title,
			brief:brief,
			img:img,
			total_cnt:total_cnt,
			weight:weight*100,
			win_cnt:win_cnt,
			sort:sort,
			virtual_info: JSON.stringify(g_virtual_info) //support for empty
		};
		$.post('?_a=reward&_u=api.addrewarditem', data, function(ret){
			ret = $.parseJSON(ret);
			//console.log(ret);return;
			if(ret.errno==0){
				showTip('ok','保存成功',1000);
				if(n_uid==1){
					setTimeout(function(){
						window.location.href = '?_a=reward&_u=sp.addreward_3&r_uid='+r_uid;
					},1000);
				}else{
					setTimeout(function(){
							window.location.href='?_a=reward&_u=sp.itemlist&r_uid='+r_uid;}
						,1000);
				}
			}
			else
				showTip('err','保存失败',1000);
		});
	});
});


