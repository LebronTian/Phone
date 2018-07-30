<?php include $tpl_path.'/header.tpl'; ?>

<!--todo*************************************************************************************************************-->
<link rel="stylesheet" href="<?php echo $static_path?>/css/detail_font.css">
<link rel="stylesheet" href="<?php echo $static_path?>/css/makeorder.css">
<link rel="stylesheet" href="<?php echo $static_path?>/css/good.css">
<style>
    .status-section{padding: 0.834rem;}
    .detail-title{line-height: 1.7;}
    .delivery-section{padding-right: 2rem}
    .delivery-status{color: #359A2B}
    .detail-footer.btn-footer{text-align: right;padding-right: 0.834rem}
    .remark-input{padding-left: 7rem}
</style>
<header class="color-main vertical-box">
    <span class="header-title">订单详情</span>
    <div class="header-left vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/back.png" onclick="window.location.href='?_easy=shop.user.orders'">
    </div>
    <div class="header-right vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/home.png" onclick="window.location.href='?_easy=shop'">
    </div>
</header>
<?php
$status_data = array(
    '1' => array(
        'title' => '待付款'
    ),
    '11' => array(
        'title' => '待确认'
    ),
    '2' => array(
        'title' => '待发货'
    ),
    '3' => array(
        'title' => '待收货'
    ),
    '4' => array(
        'title' => '已收货'
    ),
    '5' => array(
        'title' => '已评价'
    ),
    '6' => array(
        'title' => '协商完成'
    ),
    '8' => array(
        'title' => '协商中'
    ),
    '9' => array(
        'title' => '买家取消'
    ),
    '10' => array(
        'title' => '卖家取消'
    ),
)
?>
<article class="btn-footer-margin">
    <section class="status-section color-main">
        <p class="big-text detail-title"><?php if(!empty($order['status'])) echo $status_data[$order['status']]['title'] ?></p>
        <p class="small-text c-w">订单金额（含运费）：<span>￥<?php if(isset($order['paid_fee'])) echo sprintf("%.2f", $order['paid_fee']/100) ?></span></p>
        <p class="small-text c-w">运费金额：<span>￥<?php if(isset($order['delivery_fee'])) echo sprintf("%.2f", $order['delivery_fee']/100) ?></span></p>
    </section>

    <section style="padding:5px;" class="linear-section last-liner-section margin-bottom">
<?php
#if(!empty($_REQUEST['_d'])) var_export($order);
if(!empty($order['send_time'])){
echo '发货时间: '.date("Y年m月d日 H:i:s",$order['send_time']);
}
if(!empty($order['delivery_info'])) {
	foreach($order['delivery_info'] as $k => $v) {
		if($k == '快递单号') {
		echo '<p>'.$k.': <a href="https://m.kuaidi100.com/result.jsp?nu='.$v.'">'.$v.'</a></p>';
		}
		else 
		echo '<p>'.$k.': '.$v.'</p>';
	}
}
?>
    </section>
	
    <section class="linear-section last-liner-section margin-bottom">
        <div class="linear-address-section border-box">
            <p class="big-text">
                <span class="fa fa-user c-green" style="font-size: 1.3em;"></span><span class="address-user"><?php if(!empty($order['address']['name'])) echo $order['address']['name'] ?></span>
                <span class="fa fa-mobile c-green fa-2x" style="position: relative;top: 2px;"></span><?php if(!empty($order['address']['phone'])) echo $order['address']['phone'] ?>
            </p>
            <p class="small-text tips-font">
                <?php
                $full_address='';
                if(!empty($order['address']['province']))   $full_address.=$order['address']['province'];
                if(!empty($order['address']['town']))       $full_address.=$order['address']['town'];
                if(!empty($order['address']['city']))       $full_address.=$order['address']['city'];
                if(!empty($order['address']['address']))    $full_address.=$order['address']['address'];
                echo $full_address;
                ?>
            </p>
        </div>
    </section>
    <!--<section class="delivery-section linear-section linear-noinput last-liner-section">
        <p class="big-text detail-title">物流信息</p>
        <p class="delivery-status small-text">已签收，感谢使用顺丰，期待再次为您服务</p>
        <p class="tips-font small-text">2015-10-23</p>
        <span class="linear-right vertical-box"><span>
            <img src="<?php echo $static_path?>/images/go.png">
        </span></span>
    </section>-->
    <?php
    if(!empty($order['products'])){
        $product_num = 0;//暂时没用
        $product_price = 0;
        foreach($order['products'] as $p){
            $product_num+=$p['quantity'];
            $product_price+=$p['paid_price']*$p['quantity'];
            ?>
            <section class="good-section linear-section">
                <div class="good-section-left">
                    <img class="good-section-img" src="<?php echo $p['main_img'] ?>">
                </div>
                <div class="good-section-right border-box">
                    <p class="good-section-title"><?php echo $p['title'] ?></p>
                    <?php
                    if(!empty($order['date_time'])){
                        ?>
                        <p class="good-section-option small-text tips-font">
                            <?php echo $order['date_time'];?>
                        </p>
                        <?php
                    }
                    ?>
                    <?php
                    $sku_index =strpos($p['sku_uid'],';');
                    if(!empty($sku_index)){
                        ?>
                        <p class="good-section-option small-text tips-font">
                            <?php echo substr($p['sku_uid'],strpos($p['sku_uid'],';')+1);?>
                        </p>
                        <?php
                    }
                    ?>
                    <p class="good-section-option small-text tips-font clearfix">
                        ￥<?php echo sprintf("%.2f", $p['paid_price']/100) ?> x <?php echo $p['quantity'] ?>
                        <span class="big-text good-section-price secondary-font">￥<?php echo sprintf("%.2f", $p['paid_price']*$p['quantity']/100) ?></span>
                    </p>
                </div>
            </section>
    <?php
        }
    }
    ?>
    <section class="good-info-section small-text white-tips-font">
        <div class="good-right-div">
            <span>共<?php /*$product_num*/ echo count($order['products']) ?>件商品</span> 实付：<span class="secondary-font big-text">￥<?php echo sprintf("%.2f", $order['paid_fee']/100) ?></span>
        </div>
    </section>
    <section class="good-info-section tips-font last-liner-section margin-bottom">
        <div>
            <p>订单号：<?php if(!empty($order['uid'])) echo $order['uid'] ?></p>
            <p>下单时间：<?php if(!empty($order['create_time'])) echo date('Y-m-d H:i:s',$order['create_time']) ?></p>
        </div>
    </section>

    <section class="linear-section last-liner-section margin-top-section margin-bottom">
        <span class="linear-title vertical-box"><span>备注</span></span>
        <input class="remark-input linear-input border-box" type="text" value="<?php if(!empty($order['info']['remark'])) echo $order['info']['remark'] ?>" readonly placeholder="无">
    </section>
</article>
<footer class="btn-group detail-footer btn-footer border-box" data-uid="<?php if(!empty($order['uid'])) echo $order['uid'] ?>">

    <?php
    if(($order['status']==1)||($order['status']==11)){ ?>
        <button class="cancel-order-btn color-disable">取消订单</button>
    <?php }
    if($order['status']==1){ ?>
        <button class="pay-order-btn color-secondary">去支付</button>
    <?php }
    if($order['status']==2){ ?>
        <button class=" color-disable">申请退款</button>
    <?php }
    if($order['status']==3){ ?>
        <button class="accept-order-btn color-secondary">确认收货</button>
    <?php }
    if($order['status']==4){ ?>
        <button class="comment-order-btn color-secondary">追加评价</button>
    <?php }
    ?>

    <!--<button class="color-primary">查看物流</button>-->
</footer>

<?php include $tpl_path.'/footer.tpl'; ?>

<script>
    //'jquery' or 'zepto' 脚本入口,按情况选择加载
    seajs.use('jquery', function () {
        $(document).ready(function () {
            seajs.use('js/order.js', function (order) {
                console.log('?',order);
                $('.btn-group')
                    .on('click','.cancel-order-btn',function () {
                        var uid = $(this).parent().data('uid');
                        order.cancel(uid)
                    })
                    .on('click','.pay-order-btn',function () {
                        var uid = $(this).parent().data('uid');
                        order.pay(uid)
                    })
                    .on('click','.accept-order-btn',function () {
                        var uid = $(this).parent().data('uid');
                        order.accept(uid)
                    })
                    .on('click','.comment-order-btn',function () {
                        var uid = $(this).parent().data('uid');
                        order.comment(uid)
                    })
                ;
            });
        })
    });
</script>
</body>
</html>
