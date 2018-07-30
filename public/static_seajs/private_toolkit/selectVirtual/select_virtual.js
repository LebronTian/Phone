
/*
 ele 选择器
 virtual_info 初始化选中
 callback 选中回调
 */

$(document).ready(function () {
	var g_virtual_select_ele = '#id_virtual';
	var g_virtual_select_callback = null;
	var g_virtual_select_info = null;
	init_select_virtual('#id_virtual', g_virtual_info, function(virtual){
		console.log('selected', virtual);

		g_virtual_info  = virtual['virtual_info'];
		if(virtual['img']) $('#id_img').attr("src", virtual['img']);
		if(virtual['title']) $('#id_title').val(virtual['title']);
		if(virtual['brief']) ue.setContent(virtual['brief']);

	} );
} );
function init_select_virtual(ele, init_virtual_info, callback) {
	g_virtual_select_ele = ele;
	g_virtual_select_info = init_virtual_info || null;
	g_virtual_select_callback = callback;
	var html =
			'<option value="null">否</option>' +
			'<option value="store_coupon">门店优惠券</option>' +
			'<option value="shop_coupon">商城优惠券</option>'+
			'<option value="point">赠送积分</option>'
			+'<option value="cash">赠送余额</option>'
			+'<option value="sys_redpack">系统红包</option>'
			+'<option value="empty_">上门自提或无需发货</option>' 
		;
	$(g_virtual_select_ele).html(html);
	$(g_virtual_select_ele).selected({
		btnSize: 'lg'
	});
	if(g_virtual_select_info && g_virtual_select_info['name']) {
		//$(g_virtual_select_ele).val(g_virtual_select_info['name']);
		by_amaze_init = 1;
		$(' .am-selected-list li[data-value='+g_virtual_select_info['name']+']', $(g_virtual_select_ele).next()).click();
	}

	/*
	 选择虚拟奖品
	 */
	var by_amaze_init = 0;
// $(g_virtual_select_ele).change(function(){
	$(' .am-selected-list li', $(g_virtual_select_ele).next()).click(function(){
		if(by_amaze_init) {
			by_amaze_init = 0;
			return;
		}
		// var key = $(g_virtual_select_ele).val();
		var key = $(this).data('value');
		if(key == null){
			var virtual = { title: '',
				img: '',
				brief: '',
				virtual_info: {}};
			g_virtual_select_info = virtual['virtual_info'];
			on_select_virtual(virtual);
		}
		else if(key == 'empty_') {
			var virtual = { title: '',
				img: '',
				brief: '',
				virtual_info: {'name':'empty_', 'coupon_uid': 0}};
			g_virtual_select_info = virtual['virtual_info'];
			on_select_virtual(virtual);
		}
		else{
			if(key=='point')
			{
				do_set_point();
			}
			else if(key=='cash')
			{
				do_set_cash();
			}
			else if(key=='sys_redpack')
			{
				do_set_sysredpack();
			}
			else
			{
				key=key.replace('_coupon','')
				do_select_coupon(key)
			}
		}
	});
}

//回调
function on_select_virtual(virtual) {
	//console.log('virtual selected ', virtual);
	g_virtual_select_callback && g_virtual_select_callback(virtual);
}



var data_select_coupon = null;

function do_select_coupon(type){
	$('#id_select_'+type+'_coupon').remove();
	$('#id_select_'+type+'_coupon').removeData('amui.modal');
	var e = $('#id_select_'+type+'_coupon');
	if(!e.length) {
		$('body').append(get_select_coupon_html(type));
		$.post('?_a='+type+'&_u=api.'+type+'_coupon', function(ret){
			$('#id_select_'+type+'_coupon .refresh span').removeClass('am-icon-spin');
			//console.log(ret);
			ret = $.parseJSON(ret);
			data_select_coupon = {};

			var html = '';

			$.each(ret.data.list, function(k, v){
				html += '<option value="'+v['uid']+'">'+v['title']+'</option>';
				data_select_coupon[v['uid']] = v;
			});

			$('#id_select_'+type+'_coupon select').html(html);
			$('#id_select_'+type+'_coupon select').selected({
				btnSize: 'lg'
			});


			if(g_virtual_select_info && g_virtual_select_info['name'] == 'store_coupon') {
				$(' .am-selected-list li[data-value='+g_virtual_select_info['coupon_uid']+']', $('#id_select_'+type+'_coupon select').next()).click();
			}
		});
		$('#id_select_'+type+'_coupon .refresh').click();
		e = $('#id_select_'+type+'_coupon');
	}

	e.modal({
		relatedTarget: this,
		onConfirm: function(options) {
			var id = $('#id_select_'+type+'_coupon select').val();
			if(id && data_select_coupon && data_select_coupon[id]) {
				var c = data_select_coupon[id];
				console.log('store_coupon selectet ...', c);
				var virtual = { title: c['title'],
					img: c['img'],
					brief: c['brief'],
					virtual_info: {'name': type+'_coupon', 'coupon_uid': c['uid']}};
				g_virtual_select_info = virtual['virtual_info'];

				on_select_virtual(virtual);
			}
		},
		onCancel: function() {
			$('#id_select_'+type+'_coupon').removeData('amui.modal');
		}
	});
	$('#id_select_'+type+'_coupon .refresh').click(function(){
		$('#id_select_'+type+'_coupon').modal('close');
		//加点延迟 保证正常关闭
		setTimeout(function(){
				do_select_coupon(type)}
			,400);
	});

}
function get_select_coupon_html(type){
	var coupon_name = {
		'store':'门店',
		'shop':'商城'
	}
	return '<div class="am-modal am-modal-confirm" tabindex="-1" id="id_select_'+type+'_coupon">' +
		'  <div class="am-modal-dialog">' +
		'    <div class="am-modal-hd">请选择一张<a target="_blank" href="?_a='+type+'&_u=sp.'+type+'coupon&_r=1">'+coupon_name[type]+'优惠券</a>' +
		' <a class="am-btn am-btn-primary am-btn-sm refresh"><span class="am-icon-refresh"></span> 刷新</a></div>' +
		'    <div class="am-modal-bd">' +
		'		<select data-am-selected="{btnSize: \'lg\' }">' +
		'		</select>' +
		'    </div>' +
		'    <div class="am-modal-footer">' +
		'      <span class="am-modal-btn" data-am-modal-confirm>确定</span>' +
		'      <span class="am-modal-btn" data-am-modal-cancel>取消</span>' +
		'    </div>' +
		'  </div>' +
		'</div>'
		;
}

function do_set_point()
{
	var e = $('#id_set_point');
	if(!e.length) {
		$('body').append(get_set_point_html());
		e = $('#id_set_point');
	}

	e.modal({
		relatedTarget: this,
		onConfirm: function(options) {
			var id = $('#id_point_val').val();
			if(id) {
				var virtual = { title: '',
					img: '',
					brief: '',
					virtual_info: {'name': 'point', 'coupon_uid':id}};
				g_virtual_select_info = virtual['virtual_info'];

				on_select_virtual(virtual);
			}
		},
		onCancel: function() {
			$('#id_set_point').removeData('amui.modal');
		}
	});
}
function get_set_point_html()
{
	var value = g_virtual_info?g_virtual_info['coupon_uid']:'';
	return '<div class="am-modal am-modal-confirm" tabindex="-1" id="id_set_point">' +
		'  <div class="am-modal-dialog">' +
		'    <div class="am-modal-hd">兑换的积分值' +
		'    <div class="am-modal-bd">' +
		'		<input id="id_point_val" value="'+value+'">' +
		'    </div>' +
		'    <div class="am-modal-footer">' +
		'      <span class="am-modal-btn" data-am-modal-confirm>确定</span>' +
		'      <span class="am-modal-btn" data-am-modal-cancel>取消</span>' +
		'    </div>' +
		'  </div>' +
		'</div>'
		;
}

function do_set_sysredpack()
{
	var e = $('#id_set_sysredpack');
	if(!e.length) {
		$('body').append(get_set_sysredpack_html());
		e = $('#id_set_sysredpack');
	}

	e.modal({
		relatedTarget: this,
		onConfirm: function(options) {
			var id = $('#id_sysredpack_val').val();
			if(id) {
				var virtual = { title: '',
					img: '',
					brief: '',
					virtual_info: {'name': 'sys_redpack', 'coupon_uid':id}};
				g_virtual_select_info = virtual['virtual_info'];

				on_select_virtual(virtual);
			}
		},
		onCancel: function() {
			$('#id_set_sysredpack').removeData('amui.modal');
		}
	});
}
function get_set_sysredpack_html()
{
	var value = g_virtual_info?g_virtual_info['coupon_uid']:'';
	return '<div class="am-modal am-modal-confirm" tabindex="-1" id="id_set_sysredpack">' +
		'  <div class="am-modal-dialog">' +
		'    <div class="am-modal-hd">红包金额 单位为分' +
		'    <div class="am-modal-bd">' +
		'		<input id="id_sysredpack_val" value="'+value+'">' +
		'    </div>' +
		'    <div class="am-modal-footer">' +
		'      <span class="am-modal-btn" data-am-modal-confirm>确定</span>' +
		'      <span class="am-modal-btn" data-am-modal-cancel>取消</span>' +
		'    </div>' +
		'  </div>' +
		'</div>'
		;
}

function do_set_cash()
{
	var e = $('#id_set_cash');
	if(!e.length) {
		$('body').append(get_set_cash_html());
		e = $('#id_set_cash');
	}

	e.modal({
		relatedTarget: this,
		onConfirm: function(options) {
			var id = $('#id_cash_val').val();
			if(id) {
				var virtual = { title: '',
					img: '',
					brief: '',
					virtual_info: {'name': 'cash', 'coupon_uid':id}};
				g_virtual_select_info = virtual['virtual_info'];

				on_select_virtual(virtual);
			}
		},
		onCancel: function() {
			$('#id_set_cash').removeData('amui.modal');
		}
	});
}
function get_set_cash_html()
{
	var value = g_virtual_info?g_virtual_info['coupon_uid']:'';
	return '<div class="am-modal am-modal-confirm" tabindex="-1" id="id_set_cash">' +
		'  <div class="am-modal-dialog">' +
		'    <div class="am-modal-hd">用户余额 单位为分' +
		'    <div class="am-modal-bd">' +
		'		<input id="id_cash_val" value="'+value+'">' +
		'    </div>' +
		'    <div class="am-modal-footer">' +
		'      <span class="am-modal-btn" data-am-modal-confirm>确定</span>' +
		'      <span class="am-modal-btn" data-am-modal-cancel>取消</span>' +
		'    </div>' +
		'  </div>' +
		'</div>'
		;
}
