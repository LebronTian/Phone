$(function() {
  $('.cdelete').on('click', function() {
  		var uid = $(this).attr('data-id');
      $('#my-confirm').modal({
        relatedTarget: this,
        onConfirm: function(options) {
			do_delete(uid);
        },
        onCancel: function() { 		
        }
      });
    });
});


function do_delete(uids) {
	if(!(uids instanceof Array)) {
		uids = [uids];
	}
	var data = {uids: uids.join(';')}
	$.post('?_a=sp&_u=api.delslide', data, function(ret){
		console.log(ret);
		window.location.reload();
	});
}

$('.cstatus').click(function(){
	var uid = $(this).parent().parent().attr('data-id');
	var status = $(this).attr('data-status');
	console.log(uid, status);
	var data = {uid:uid, status:1-status};
	$.post('?_a=sp&_u=api.addslide', data, function(ret){
		console.log(ret);
		window.location.reload();
	});
	
});

$('.ccheckall').click(function(){
	var checked = $(this).prop('checked');
	$('.ccheck').prop('checked', checked);
});

$('.cdeleteall').click(function(){
	var uids = [];
	$('.ccheck').each(function(){
		if ($(this).prop('checked')) {
			uids.push($(this).parent().parent().attr('data-id'));
		}
	});
	console.log(uids);
	if(!uids.length) {
		alert('请选择项目!');return;
	}
	if(!confirm('确定要删除吗?')) {
		return;
	}
	do_delete(uids);
});

/*
	amazeui 会调用一次change事件,此时不刷新
*/
var by_amaze_init = 1;
$('.option_cat').change(function(){
	if(by_amaze_init) {
		by_amaze_init = 0;
		return;
	}

	var cat = $(this).val();
	window.location.href='?_a=sp&_u=index.slidelist&pos=' + cat;
});

$('#id_add_tpl').click(function(){
	var key = $('.option_cat2').val();	
	if(!key) return;
	if(!confirm('确定添加['+key+']吗？')) return;	
	$.post('?_a=sp&_u=api.add_tpl_slide&key='+key,function(ret){
		window.location.reload();
	});
});

