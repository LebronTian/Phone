function set_price_text(){
    $('#id_buy_limit').html();
}

//点击兑换按钮
$('.goods_list').on('click', '.duihuan', function(){
	if(su_uid == 0) {
		window.location.href = '?_easy=web.index.goto_url&must_login=1&url=' + encodeURIComponent(window.location.href);
		return;
	}

    if(typeof referee!="number"){
    }
    g_uid = $(this).attr('data-uid');
    set_price_text();
    if(g_goods[g_uid]) {
        $('.caddress').show();
    }
    else {
        $('.caddress').hide();
    }

    set_price_text();

    
    var mask = $('#mask');
    var weuiActionsheet = $('#weui_actionsheet');
    weuiActionsheet.addClass('weui_actionsheet_toggle');
    mask.show()
        .focus()//加focus是为了触发一次页面的重排(reflow or layout thrashing),使mask的transition动画得以正常触发
        .addClass('weui_fade_toggle').one('click', function () {
        hideActionSheet(weuiActionsheet, mask);
    });
    /*$('#actionsheet_cancel').one('click', function () {
     hideActionSheet(weuiActionsheet, mask);
     });*/
    mask.unbind('transitionend').unbind('webkitTransitionEnd');

    function hideActionSheet(weuiActionsheet, mask) {
        weuiActionsheet.removeClass('weui_actionsheet_toggle');
        mask.removeClass('weui_fade_toggle');
        mask.on('transitionend', function () {
            mask.hide();
        }).on('webkitTransitionEnd', function () {
            mask.hide();
        })
    }
});

$('#id_minus_quantity').click(function(){
    var q = parseInt($('#id_quantity').val() || 2);
    q--;if(q<1) q=1;
    var buy_limit = parseInt(g_goods[g_uid]['buy_limit']);
    if(buy_limit && q > buy_limit) q = buy_limit;
    $('#id_quantity').val(q);
    set_price_text(g_goods[g_uid]['point_price']*q)
});
$('#id_add_quantity').click(function(){
    var q = parseInt($('#id_quantity').val() || 0);
    q++;if(q<1) q=1;
    var buy_limit = parseInt(g_goods[g_uid]['buy_limit']);
    if(buy_limit && q > buy_limit) q = buy_limit;
    if(!is_ratio_law && g_goods[g_uid]['point_price']*q >point_remain){
        q--;
    }

    $('#id_quantity').val(q);
    set_price_text(g_goods[g_uid]['point_price']*q);
});

function post_check()
{
    //if(typeof referee!="number") referee=0
    //var quantity = $('#id_quantity').val();
    var o = {
        b_uid: g_uid
        //,quantity: quantity
        //,referee:referee
    };

    if(1) {
        var not_ok = 0;
        var address = {};
        $('.caddress input').each(function(ii, i)
        {
            var label = $(i).parent().parent().find('label').text();
            var val = $(i).val();

            if(!val && label != '备注') {
                not_ok = 1;
                alert('请填写 ' + label);
                return false;
            }
            address[label] = val;
        });
        if(not_ok) return;
        o['data'] = address;
    }
    return o;
}
var posting = 0;
$('#id_duihuan_ok').click(function(){
    if(!(o = post_check()))
    {
        return
    }
    if(posting!=0)
    {
        return;
    }
    console.log('going to make ', o);
    posting =1
    $.post('?_a=book&_u=ajax.add_book_item_record', o, function(ret){
        console.log(ret);
        ret = $.parseJSON(ret);
        if(ret.errno==0 && ret.data) {
            if(g_goods[g_uid].price > 0){
            //if(ret.data.status==1){}
                //待付款
                //alert('预约成功！');
                window.location.href="?_a=pay&_u=index.wxjs&oid=l"+ret.data+'&APP=qrposter&TPL=v2'
                // window.location.href="?_a=pay&_u=index.test&oid=k"+ret.data.uid+'&APP=qrposter&TPL=v2'
            }else{
                alert('预约成功！');
                window.location.href="?_a=book&_u=index.point_orders";
            }

            return;
        }
        posting =0;
        alert('预约失败！' + ret.errstr);
    });
});

$('#id_pay').click(function(){
    if(!(o = post_check()))
    {
        return
    }
    $.cookie('post_data',JSON.stringify(o))
    $.post('?_a=book&_u=ajax.make_wx_order', o, function(ret){
        ret = $.parseJSON(ret);
        if(ret.errstr == 'ERROR_OUT_OF_LIMIT') {
            alert('超出兑换数目限制!');
            return;
        }
        if(ret.errstr == 'ERROR_OUT_OF_QUANTITY_LIMIT') {
            alert('库存不足');
            return;
        }
        switch (ret.errno)
        {
            case 0:
                window.location.href="?_a=pay&_u=index.wxjs&oid=l"+ret.data+'&APP=book&TPL=v2';
                break;
            case 408:
                break;
            case 701:
                alert('不支持微信支付兑换积分');
                break;
            case 401:
                alert('购买失败请重试');
                break;
                return
        }
    });
});
