function do_modal(onConfirm) {
	//stupid modal
	$('#id_modal_ok').one('click', onConfirm);
	$('#my-prompt3').modal({
	/*
      onConfirm: function(){
			onConfirm();
		}    
	*/
	});
}

/*
	添加一级菜单 
*/
$('.add_menu').click(function(){
	init_prompt3({'name': '', 'name2': ''});
	do_modal(function(e) {
		console.log('add menu ...');
		var data = get_prompt3();
		if(!data) return false; 
		add_menu(data.name, data);
     });
});

/*
	一级菜单工具按钮显示隐藏
*/
$('.menu').on('mouseenter', '.am-dropdown-up', function(){
    $(this).find('.toolbar').show();
    $(this).dropdown('open');
});
$('.menu').on('mouseleave', '.am-dropdown-up', function(){
    $(this).find('.toolbar').hide();
});
$('.menu').on('mouseleave', '.am-dropdown-content', function(){
	$(this).parent().find('.toolbar').hide();
	$(this).parent().dropdown('close');
});

/*
	删除一级菜单
*/
$('.menu').on('click', '.toolbar .am-icon-trash', function(){
	if(!confirm('确定要删除吗?')) {
		return;
	}
	var div = $(this).parent().parent().parent();
	//console.log(div);
	div.remove();
	on_menu_changed();
});

/*
	添加一级菜单
*/
function add_menu(name, data) {
	var html = '<div class="am-dropdown am-dropdown-up" data-am-dropdown>' + 
      '<button class="am-btn am-dropdown-toggle" data-am-dropdown-toggle><span class="menu_name">'+ name + 
            '</span><span class="toolbar" ><span class="am-icon-edit"></span> | <span class="am-icon-trash"></span></span> </button>' +
      '<ul class="am-dropdown-content">' + 
        '<li><a class="add_menu_sub"><span class="am-icon-plus"></span></a></li>' + 
      '</ul>' + 
	'</div>';

	$('.add_menu').before(html);
	//初始化一下上拉菜单
	var div = $('.am-dropdown-up:last');
	div.dropdown();
	
	data = data || {};
	div.data('menu', $.extend(data, {name:name}));
	
	on_menu_changed();
	return div;
}

function on_menu_changed() {
	var total = $('.am-dropdown-up').length;
	if(total >= 3) {
		$('.add_menu').hide();
	}
	else {
		$('.add_menu').show();
	}
}

function init_prompt3(data) {
	if(!data) {
		return;
	}
	//console.log('init prompt3 ', data);
	$('#id_menu_name').val(data.name);
	$('.option_cat').val(data.type || 'null');
	$('.option_cat').change();
	//$('.other').attr('key_name', data.key_name || '');
	data.key_name = $('.other').attr('key_name');
	if(data.key_name) {
		$('.other').val(data[data.key_name]);
	}

	data.key_name2 = $('.other2').attr('key_name');
	if(data.key_name2) {
		$('.other2').val(data[data.key_name2]);
	}
}

function get_prompt3() {
	var data = {name: $('#id_menu_name').val(), type: $('.option_cat').val()};
	var key = $('.other').attr('key_name');
	data.key_name = key || '';
	if(key) {
		data[key] = $('.other').val();
	}
	var key2 = $('.other2').attr('key_name');
	data.key_name2 = key2 || '';
	if(key2) {
		data[key2] = $('.other2').val();
	}
	if(data['type'] == 'miniprogram') data['url'] = 'https://mp.weixin.qq.com/';
	return data;
}

var current_menu_data = null;
/*
	编辑一级菜单
*/
$('.menu').on('click', '.toolbar .am-icon-edit', function(){
	//div
	current_menu_data = $(this).parent().parent().parent();
	console.log(current_menu_data);

	init_prompt3(current_menu_data.data('menu'));
	do_modal(function(e) {
		var data = get_prompt3();
		if(!data) return false; 
		$('.menu_name', current_menu_data).text(data.name);
		current_menu_data.data('menu', data);	
    });
});

/*
	编辑二级菜单
*/
$('.menu').on('click', '.toolbar_sub .am-icon-edit', function(){
	//li
	current_menu_data = $(this).parent().parent().parent();
	console.log(current_menu_data);
	
	init_prompt3(current_menu_data.data('menu'));
	do_modal(function() {
		var data = get_prompt3();
		if(!data) return false; 
		$('.menu_name_sub', current_menu_data).text(data.name);
		current_menu_data.data('menu', data);	
    });

	
});


var current_li_add = null;
/*
	添加二级菜单
*/
$('.menu').on('click', '.add_menu_sub', function(){
	current_li_add = $(this).parent();
	init_prompt3({'name': '', 'name2': ''});
	do_modal(function() {
		console.log('add sub menu ...');
		var data = get_prompt3();
		add_sub_menu(data.name, data);
    });
});

/*
	添加二级菜单
*/
function add_sub_menu(name, data) {
	var html = '<li><a style="position: relative"><span class="menu_name_sub">'+name+
				'</span><span class="toolbar_sub" ><span class="am-icon-edit"></span> | <span class="am-icon-trash"></span></span></a></li>';
	var li_add = current_li_add;
	li_add.after(html);
	on_sub_menu_changed(li_add.parent());

	data = data || {};
	li_add.siblings('li:first').data('menu', $.extend(data, {name:name}));
}

function on_sub_menu_changed(ul) {
	//console.log('changed', ul);
	var total = $('.toolbar_sub', ul).length;
	if(total >= 5) {
		$('.add_menu_sub', ul).hide();
	}
	else {
		$('.add_menu_sub', ul).show();
	}
}

/*
	二级菜单工具按钮显示隐藏
*/
$('.menu').on('mouseenter', 'li', function(){
	$(this).find('.toolbar_sub').show();
});
$('.menu').on('mouseleave', 'li', function(){
	$(this).find('.toolbar_sub').hide();
});

/*
	删除二级菜单
*/
$('.menu').on('click', '.toolbar_sub .am-icon-trash', function(){
	if(!confirm('确定要删除吗?')) {
		return;
	}
	var li = $(this).parent().parent().parent();
	var ul = li.parent();
	li.remove();
	on_sub_menu_changed(ul);
});

/*
	菜单类型变化
	todo 并没有通过公众号后台的类型
*/
$('.option_cat').change(function(){
	var type = $(this).val();
	//console.log('cat changed ', type);
	switch(type) {
		case 'view': {
			$('.other_name').text('跳转地址').show();
			$('.other').attr('key_name', 'url').show();
			$('.other_name2').hide();
			$('.other2').attr('key_name', '').hide();
			break;
		}
		case 'miniprogram': {
			$('.other_name').text('小程序appid').show();
			$('.other').attr('key_name', 'appid').show();
			$('.other_name2').text('路径path').show();
			$('.other2').attr('key_name', 'pagepath').show();
			break;
		}
		case 'null': {
			$('.other_name').hide();
			$('.other').attr('key_name', '').hide();
			$('.other_name2').hide();
			$('.other2').attr('key_name', '').hide();
			break;	
		}
		case 'media_id':
		case 'view_limited':
		{
            getPt(0);
			$('.other_name').text('永久素材id').show();
			$('.other').attr('key_name', 'media_id').show();
			$('.other_name2').hide();
			$('.other2').attr('key_name', '').hide();
			break;
		}
		
		case 'click':
		case 'scancode_push':
		case 'scancode_waitmsg':
		case 'pic_sysphoto':
		case 'pic_photo_or_album':
		case 'pic_weixin':
		case 'location_select':
		
		default: {
			$('.other_name').text('事件名').show();
			$('.other').attr('key_name', 'key').show();
			$('.other_name2').hide();
			$('.other2').attr('key_name', '').hide();
		}
	}
});
/*
	初始化菜单
*/
(function init_menu() {
	if(!g_menu || !g_menu.selfmenu_info || !g_menu.selfmenu_info.button) {
		return;
	}
    console.log(g_menu.selfmenu_info.button);
	$.each(g_menu.selfmenu_info.button, function(i, m){
		var name = m.name;
		var sub = m.sub_button;
		delete m['sub_button'];
		var div = add_menu(name, m);	
		if(sub && sub.list) {
			current_li_add = $('.add_menu_sub', div).parent();
			for(var j=sub.list.length-1; j>=0; j--) {
				add_sub_menu(sub.list[j].name, sub.list[j]);
			}
		}
	});
})();

function get_menu() {
	var menu = [];
	var error="";
	$('.menu .am-dropdown-up').each(function(i, m){
		var lis = $('.toolbar_sub', $(m)).parent().parent();
		var d = $(m).data('menu');
		console.log(lis.length);
		if(lis.length) {
			var sub_button = [];
			lis.each(function(j, sm){
				var dd = $(sm).data('menu');
				// delete dd['key_name'];
				if(dd['type'] == 'null' || dd['type'] == undefined) {
					error+='请不要在二级菜单添加一级菜单，位置是:【'+d['name']+'】=>【'+dd['name']+'】\n\r';
					// delete dd['type'];
				}
				sub_button.push(dd);
			});	
			
			//d['sub_button']= {list: sub_button};
			d['sub_button']= sub_button;
		}
		else{
			console.log(d['type']);
			// delete d['key_name'];
			if(d['type'] == 'null' || d['type'] == undefined) {
				error+='设置为一级菜单的【'+d['name']+'】并无二级菜单。请添加二级菜单或设置为其他类型\n\r';
				// delete d['type'];
			}
		}
		menu.push(d);
	});
	console.log(error.length);
	if(error.length==0)
	{
		return {button: menu};
	}
	else
	{	
		alert('设置错误:\n'+error);
		return false;
	}
	
}

$('.save').click(function(){
	$(this).button('loading');
	var menu = get_menu();
	if(!menu) {
		$('.save').button('reset');
		return;
	} 
	console.log('get menu..', menu);
	// var data = {menu: JSON.stringify(menu)};
	var data = {menu:JSON.stringify(menu)};
	$.post('?_a=menu&_u=sp.save_menu', data, function(ret){
		ret = $.parseJSON(ret);
		if(ret.data==true){
			showTip('ok','保存成功',1000);
		}
		else
		{
			showTip('err',show_weixin_error(ret.data),2000);
		}
			
		$('.save').button('reset');
		console.log(ret);
		//alert('设置成功, 重新关注公众号查看新菜单');
	});
});

$('.sync').click(function(){
	if(!confirm('确定要从微信同步菜单吗? \n您的本地修改将会丢失.')) {
		return;
	}
	$(this).button('loading');
	$.get('?_a=menu&_u=sp.sync_menu', function(ret){
		$('.sync').button('reset');
		console.log(ret);
		window.location.reload();
	});
});

/*
	取字节长度
*/
getBLen = function(str) {
  if (str == null) return 0;
  if (typeof str != "string"){
    str += "";
  }
  return str.replace(/[^x00-xff]/g,"01").length;
};


/*test*/
$(".am-text-primary.am-text-lg").click(function () {
    /*
    var account = $(".asdasdasd").val();

    var reg = /^[0-9]{10}$/;
    var reg2 = /^1[0-9]{10}$/;
    if(!(reg.test(account)||reg2.test(account))){
        console.log("AA",account)
    }
    else{                       //目标是10跟11的到这里来
        console.log("BB",account)
    }*/
});

/*历史记录-start*/
$(document).ready(function () {
    var mySwiper = new Swiper('.history-swiper', {
        pagination : '.swiper-pagination',
        paginationClickable :true,
        prevButton:'.swiper-button-prev',
        nextButton:'.swiper-button-next',
        direction : 'vertical'
    });
    $(".recover-btn").click(function () {
        var index = $(this).data("index");
        var data = recordData[index];
        data = JSON.parse(data);
        data = data.selfmenu_info;
        console.log(data.button);
        $(".am-dropdown.am-dropdown-up").remove();
        /*恢复*/
        $.each(data.button, function(i, m){
            var name = m.name;
            var sub = m.sub_button;
            delete m['sub_button'];
            var div = add_menu(name, m);
            if(sub && sub.list) {
                current_li_add = $('.add_menu_sub', div).parent();
                for(var j=sub.list.length-1; j>=0; j--) {
                    add_sub_menu(sub.list[j].name, sub.list[j]);
                }
            }
        });
        /*显示*/
        $(".menu .am-dropdown-content").show()

    })
});
/*历史记录-end*/
/*订阅号选择功能-start*/
$("#my-prompt3 .other").click(function () {
    var type = $(this).attr("key_name");
    if(type=="media_id"){
        console.log("!");
        getPt(0);
    }
});

$(".mass-modal-body").on("click",".picText-brief-box",function () {
    var mid = $(this).data("mid");
    console.log(mid);
    $("#mass-modal").modal("close");
    $("#my-prompt3").find(".other").val(mid)
});
/*订阅号选择功能-end*/
