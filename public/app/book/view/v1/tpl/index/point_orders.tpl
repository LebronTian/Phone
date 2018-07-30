<!DOCTYPE html>
<html>
<head>
<meta http-equiv=Content-Type content="text/html;charset=utf-8">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="format-detection" content="telephone=no">
<script>
window.scale=1;
if (window.devicePixelRatio === 2 && window.navigator.appVersion.match(/iphone/gi)) {
    //scale = 0.5;
}
var text = '<meta name="viewport" content="initial-scale=' + scale + ', maximum-scale=' + scale +', minimum-scale=' + scale + ', user-scalable=no" />';
document.write(text);
</script>
<title>预约记录</title>
<link rel="stylesheet" href="/static/css/weui0.42.css" />
<link href="/static/css/font-awesome-4.6.3/css/font-awesome.min.css" rel="stylesheet">
<link rel="stylesheet" href="<?php echo $static_path;?>/css/point_orders.css" />

<style>
@media screen and (device-aspect-ratio: 2/3) {
	.shop_module_slist .banner_logo{top:40px;}
	.shop_module_slist .category_list{bottom:40px;}
	.ratio2{
		.shop_module_slist .banner_logo{top:80px;}
		.shop_module_slist .category_list{bottom:80px;}
	}
}
</style>
</head>

<script>
    if(window.scale==0.5){document.write('<body class="zh_CN ratio2 ">');}
    else{document.write('<body class="zh_CN ">');}
</script>


<style>
    .orderlist-section{background: white;border-top: thin solid #e2e2e2}
    .orderlist-section li{padding: 1rem 0;width: 3rem}
    .btn-group button{border: none;border-radius: 3px;padding: 8px;}

    .load-more{text-align: center}

</style>

<div class="weui_navbar" style="position:fixed">
            <a href2="?_easy=qrposter.index.point_orders" class="weui_navbar_item 
					<?php if(($option['status']=="0")) echo 'weui_bar_item_on'?>">
                我的预约
            </a>
</div>

<article class="orders-article" style="margin-top:50px;margin-bottom:80px;">
</article>

    <script id="id_tpl" type="text/tpl">
        <div class="orderdetail"  data-uid="{{=it['uid']}}">
        <section class="good-section linear-section">
            <div class="good-section-left">
                <img class="good-section-img" src="{{=it['book']['main_img']}}">
            </div>
            <div class="good-section-right border-box">
                <p class="good-section-title" style="color:#04BE02;font-size:18px;">{{=it['book']['title']}}</p>
            	{{? it['data']}}
                {{ for(k in it['data']) { }}
                <p class="good-section-option small-text tips-font" style="color:gray;font-size:12px;">
					{{=k}}: {{=it['data'][k]}}
                </p>
				{{ } }}
				{{?}}
            </div>
        </section>

		{{?it['book']['store']}}
        <section class="good-info-section small-text white-tips-font">
            <div class="good-right-div clearfix">
                <span class="normal-text good-status-text" style="color:gray;">
					{{=it['book']['store']['name']}} 
<a href="?_easy=web.index.map&lat={{=it['book']['store']['lat']}}&lng={{=it['book']['store']['lng']}}&name={{=it['book']['store']['name']}}">
					<span style="font-size:12px;"><a2 class="fa fa-map-marker"></a2> {{=it['book']['store']['address']}}</span></a>
				</span>
                <span><a href="tel:{{=it['book']['store']['telephone']}}" class="fa fa-phone" ></a></span>
            </div>
        </section>
		{{?}}

        <section class="good-info-section small-text white-tips-font last-liner-section margin-bottom">
            <div class="good-right-div btn-group">
                <span class="normal-text good-status-text" style="color:gray;">{{= date('Y-m-d H:i', it.create_time)}}</span>
            {{? (it['order'] && it['order']['paid_time'] == 0) }}
                <button data-uid="{{=it['uid']}}" style="background:#04BE02;" class="weui_btn weui_btn_mini pay-order-btn  ">立即支付</button>
            {{?}}
            {{? (it['sp_remark']==0) }}
                <button data-uid="{{=it['uid']}}" style="background:gray;" class="weui_btn weui_btn_mini cancel-order-btn  ">取消预约</button>
            {{?}}
            </div>
        </section>
        </div>
    </script>

<?php include $tpl_path.'/footer.tpl';?>

<script src="/static/js/jquery2.1.min.js"></script>
<script src="/static/js/doT.min.js"></script>
<script src="/static/js/scroll_load.js"></script>
<script src="/static/js/php/date.js"></script>

<script>
if(!$.parseJSON) {
$.parseJSON = function(str) {
	return JSON.parse(str);
};
}

var option = <?php echo json_encode($option);?>;

scroll_load({'ele_container': '.orders-article', 'ele_dot_tpl': '#id_tpl',
'url': '?_a=book&_u=ajax.book_record_list&status='+option.status  
});

    //'jquery' or 'zepto' 脚本入口,按情况选择加载
        $(document).ready(function () {
                $('.orders-article')
                    .on('click','.orderdetail',function () {
                        var uid = $(this).data('uid');
                        //window.location.href = '?_easy=book.index.orderdetail&uid='+uid;
                        return false;
                    })
                    .on('click','.cancel-order-btn',function () {
                        var uid = $(this).data('uid');
                        cancel_order(uid)
                        return false;
                    })
                    .on('click','.pay-order-btn',function () {
                        var uid = $(this).data('uid');
                        pay_order(uid)
                        return false;
                    })
                    .on('click','.accept-order-btn',function () {
                        var uid = $(this).data('uid');
                        accept_order(uid);
                        return false;
                    })
                    .on('click','.comment-order-btn',function () {
                        var uid = $(this).data('uid');
                        //order.comment(uid)
                    });


	});

	//确认收货
	function accept_order(uid) {
            if(confirm('您确定要确认收货吗？')){
                $.post('?_a=book&_u=ajax.do_receipt',{uid:uid}, function (ret) {
                    ret = $.parseJSON(ret);
                    if(ret.errno==0){
                        window.location.reload()
                    }
                })
            }
	}

    //取消订单
    function cancel_order(uid) {
        if(confirm('您确定要确认取消订单吗？')){
             $.post('?_a=book&_u=ajax.delete_record', {uid:uid}, function(ret){
                 ret = $.parseJSON(ret);
                 if(ret.errno==0){
                     window.location.reload()
                 } else {
					alert('操作失败！请联系客服！ ' + ret.errstr);
				 }
             });
        }
    }

    //付款
    function pay_order(uid) {
        window.location.href="?_a=pay&_u=index.wxjs&oid=l"+uid+'&APP=qrposter&TPL=v2'
    }

    function shopStatusExchange(status){
        switch (status){
            case '1':
                return '待付款';
                break;
            case '11':
                return '待确认';
                break;
            case '2':
                return '待发货';
                break;
            case '3':
                return '待收货';
                break;
            case '4':
                return '已收货';
                break;
            case '5':
                return '已评价';
                break;
            case '6':
                return '协商完成';
                break;
            case '8':
                return '协商中';
                break;
            case '9':
                return '卖家取消';
                break;
            case '10':
                return '已取消';
                break;
        }
    }
</script>
</body>
</html>
