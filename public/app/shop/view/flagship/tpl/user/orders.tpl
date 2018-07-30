
<?php include $tpl_path.'/header.tpl'; ?>

<link rel="stylesheet" href="<?php echo $static_path?>/css/good.css">
<style>
    .orderlist-section{background: white;border-top: thin solid #e2e2e2}
    .orderlist-section li{padding: 1rem 0;width: 3rem}
    .btn-group button{border: none;border-radius: 3px;padding: 8px;}
    .load-more{text-align: center}
    .display-table ul li{width: 20%;}

</style>
<header class="color-main vertical-box">
    <span class="header-title">我的订单</span>
    <div class="header-left vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/back.png" onclick="history.back()">
    </div>
    <div class="header-right vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/home.png" onclick="location.href='?_a=shop'">
    </div>
</header>
<article class="orders-article">
    <section class="orderlist-section margin-bottom">
        <div class="display-table">
            <ul>
                <li class="big-text <?php if((isset($option['status']))&&($option['status']=="0")) echo 'active-bottom'?>"
                    onclick="window.location.replace('?_a=shop&_u=user.orders')">全部</li>
                <li class="big-text <?php if((isset($option['status']))&&($option['status']=="1")) echo 'active-bottom'?>"
                    onclick="window.location.replace('?_a=shop&_u=user.orders&status=1')">待付款</li>
                <li class="big-text <?php if((isset($option['status']))&&($option['status']=="2")) echo 'active-bottom'?>"
                    onclick="window.location.replace('?_a=shop&_u=user.orders&status=2')">待发货</li>
                <li class="big-text <?php if((isset($option['status']))&&($option['status']=="3")) echo 'active-bottom'?>"
                    onclick="window.location.replace('?_a=shop&_u=user.orders&status=3')">待收货</li>
                <li class="big-text <?php if((isset($option['status']))&&($option['status']=="4")) echo 'active-bottom'?>"
                    onclick="window.location.replace('?_a=shop&_u=user.orders&status=4')">待评价</li>
            </ul>
        </div>
    </section>

    <script id="order-tpl" type="text/x-dot-template">

        {{~it.list:value:index }}
            {{? value['products'].length!=0 }}
                {{~value['products']:val:ind}}

        <section class="good-section linear-section" onclick="window.location.href='?_a=shop&_u=index.orderdetail&uid={{=value.uid}}'">
            <div class="good-section-left">
                <img class="good-section-img" src="{{=val['main_img']}}">
            </div>
            <div class="good-section-right border-box">
                <p class="good-section-title">{{=val['title']}}</p>
                {{? val['sku_uid'].indexOf(';')!=-1}}
                <p class="good-section-option small-text tips-font">
                    {{=val['sku_uid'].substr(val['sku_uid'].indexOf(';')+1)}}
                </p>
                {{?}}
                <p class="good-section-option small-text tips-font clearfix">
                	{{=value.date_time}}
                </p>
                <p class="good-section-option small-text tips-font clearfix">
                    ￥{{=(val.paid_price/100).toFixed(2)}} x {{=val.quantity}}
                    <span class="big-text good-section-price secondary-font">￥{{=(val.paid_price/100*val.quantity).toFixed(2)}}</span>
                </p>
            </div>
        </section>

                {{~}}

        <section class="good-info-section small-text white-tips-font" onclick="window.location.href='?_a=shop&_u=index.orderdetail&uid={{=value.uid}}'">
            <div class="good-right-div clearfix">
                <span class="normal-text good-status-text">{{= shopStatusExchange(value.status)}}</span>
                <span>共{{=value.products.length}}件商品</span> 实付：<span class="secondary-font big-text">￥{{=(value.paid_fee/100).toFixed(2)}}</span>
            </div>
        </section>
        <section class="good-info-section small-text white-tips-font last-liner-section margin-bottom">
            <div class="good-right-div btn-group"{{? (value['status']==5)||(value['status']==10)}} style="padding:0;border-top:none"{{?}}>

            {{? (value['status']==1)||(value['status']==11) }}
                <button data-uid="{{=value['uid']}}" class="cancel-order-btn color-disable">取消订单</button>
            {{?}}
            {{? value['status']==1 }}
                <button data-uid="{{=value['uid']}}" class="pay-order-btn color-secondary">去支付</button>
            {{?}}
            {{? value['status']==2 }}
                <button data-uid="{{=value['uid']}}" class="return-order-btn color-disable">申请退款</button>
            {{?}}
            {{? value['status']==3 }}
                <button data-uid="{{=value['uid']}}" class="accept-order-btn color-secondary">确认收货</button>
            {{?}}
            {{? value['status']==4 }}
                <button data-uid="{{=value['uid']}}" class="comment-order-btn color-secondary">追加评价</button>
            {{?}}
                <!--<button class="color-primary">查看物流</button>-->
            </div>
        </section>

            {{?}}
        {{~}}

    </script>
    <p class="load-more">加载中...</p>
</article>

<?php include $tpl_path.'/footer.tpl'; ?>

<script>
    var order_option = <?php echo(!empty($option)? json_encode($option):"null")?>;
    //'jquery' or 'zepto' 脚本入口,按情况选择加载
    seajs.use(['jquery','doT'], function () {
        $(document).ready(function () {
            seajs.use('js/order.js', function (order) {
                console.log('?',order);
                $('.orders-article')
                    .on('click','.cancel-order-btn',function () {
                        var uid = $(this).data('uid');
                        order.cancel(uid)
                        console.log(order.cancel)
                    })
                    .on('click','.pay-order-btn',function () {
                        var uid = $(this).data('uid');
                        order.pay(uid)
                    })
                    .on('click','.return-order-btn',function () {
                        var uid = $(this).data('uid');
                        if(confirm('确定申请全额退款吗？')){
                        	alert('已申请退款，请等待审核');
                        }
                    })
                    .on('click','.accept-order-btn',function () {
                        var uid = $(this).data('uid');
                        order.accept(uid)
                    })
                    .on('click','.comment-order-btn',function () {
                        var uid = $(this).data('uid');
                        order.comment(uid)
                    })
                ;
            });



            get_orders(0);
            function get_orders(page){

                if(!page) page=0;
                var option = {
                    status:order_option.status,
                    page:page,
                    limit:10
                };
                $.getJSON('?_a=shop&_u=ajax.orders',option, function (ret) {
                    console.log('22',ret.data);
                    if(ret.errno==0){
                        var orderTpl = doT.template($('#order-tpl').text());
                        $('.load-more').before(orderTpl(ret.data))
                    }
                    /**/
                    if(10*page+ret.data.list.length==ret.data.count){
                        $(".load-more").text("没有更多订单了").unbind()
                    }
                    else{
                        $(".load-more").text("点击加载更多");//点击加载更多
                        $(".load-more").click(function() {
                            console.log(page);
                            get_orders(page+1);
                            $(".load-more").text("").unbind();
                        })
                    }
                })
            }
        });
    });
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
                return '买家取消';
                break;
            case '10':
                return '卖家取消';
                break;
        }
    }
</script>
</body>
</html>