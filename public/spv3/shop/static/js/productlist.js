
$(document).ready(function () {
    /**/

    /*复制***********************/
    $(".delCopy").click(function () {
		window.location.href="?_a=shop&_u=sp.addproduct&copy_uid="+$(this).attr( "data-id");
		return;
        var r = confirm("确定要复制？");
        if(r==true){
            var uid = $(this).attr( "data-id");
            var data = {uid:uid};
            $.post('?_a=shop&_u=api.copyproduct', data, function(ret){
                ret = $.parseJSON(ret);
                console.log(ret.data);
                //window.location.reload();
                window.location.href="?_a=shop&_u=sp.addproduct&uid="+ret.data;
            });
        }
    });

    /*删除模板***********************/
    $(".delBtn").click(function () {
        var r = confirm("继续删除将无法恢复。");
        if(r==true){
            var Did = $(this).attr( "data-id");
            do_delete(Did)
        }
    });
    /*全部删除**********************/
    $('.delAll').click(function(){
        var uids = getSelectedGoods();
        if(!uids.length) {
            alert('请选择项目!');return;
        }
        if(!confirm('确定要删除吗?')) {
            return;
        }
        do_delete(uids);
    });
    /*全选******************************/
    $('.ccheckall').click(function(){

        console.log("a")
        var checked = $(this).prop('checked');
        $('.delCheck').prop('checked', checked);
    });


    /*上下架按钮*********************/
    $('.pStatus').click(function(){
        var uid = $(this).parent().parent().attr('data-id');
        var status;
        if($(this).hasClass("am-btn-success")){
            status = 1
        }else{
            status = 0
        }
        console.log(uid)
        var data = {uid:uid, status:status};
        console.log(data)

        $.post('?_a=shop&_u=api.addproduct', data, function(ret){
            console.log(ret);
            window.location.reload();
        });
    });
    // 处理一下php接口全选商品下架
    $('.pStatusall').click(function(){
        var uids = getSelectedGoods();
        var status = $(this).attr("data-status");

        if (!uids.length) {
            alert('请选择项目!');
            return;
        }
        console.log(uids)
        var data = {uids: uids.join(';'), status:status};
        console.log(data)
        changeStatus(data);
    });

    $(".choose-cats").click(function() {
        catType = $(this).attr("data-type");
    });
});
var catType = "";
var catUids = [];


// 获取选中的商品
function getSelectedGoods() {
    var uids = [];
    $('.delCheck:checked').each(function(){
        uids.push($(this).parent().parent().attr('data-id'));
    });
    return uids;
}

/*删除接口*****************/
function do_delete(uids) {
    if(!(uids instanceof Array)) {
        uids = [uids];
    }
    var data = {uids: uids.join(';')};
    $.post('?_a=shop&_u=api.delproduct', data, function(ret){
        window.location.reload()
    });
}

// 批量上架/下架商品
function changeStatus(data) {
    $.post('?_a=shop&_u=api.bat_edit_product', data, function(ret){
        console.log(ret);
        window.location.reload();
    });
}

$('.option_key_btn').click(function(){
	var key = $('.option_key').val();

    console.log("key >>>", key);
	//允许关键字为空，表示清空条件
	if(1 || key) {
		window.location.href='?_a=shop&_u=sp.productlist'+'&key='+key;
	}
});
$('.option_key').keydown(function(e){
	if(e.keyCode == 13) {
		$('.option_key_btn').click();
	}
});

// 批量修改商品分类
var cat_click_callback = function(uid, that){
    console.log("cat clicked...", uid, $(that).text());
    console.log("catType >>>", catType);

    if (catType === "screen") {
        window.location.href='?_a=shop&_u=sp.productlist&cat_uid=' + uid;
    } else if (catType === "change") {
        var catUids = getSelectedGoods();
        if (!catUids.length) {
            alert('请选择要改分类的商品项目!');
            return;
        }

        var data = {uids: catUids.join(';'), cat_uid: uid};
        changeStatus(data);
    }
};