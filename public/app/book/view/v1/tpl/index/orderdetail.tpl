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
<title><?php echo $fullname.'-';?>兑换详情</title>
<link rel="stylesheet" href="/static/css/weui0.42.css" />
<link href="/static/css/font-awesome-4.6.3/css/font-awesome.min.css" rel="stylesheet">
<link rel="stylesheet" href="<?php echo $static_path;?>/css/orderdetail.css" />

<style>
    .status-section{padding: 0.834rem;}
    .detail-title{line-height: 1.7;}
    .delivery-section{padding-right: 2rem}
    .delivery-status{color: #359A2B}
    .detail-footer.btn-footer{text-align: right;padding-right: 0.834rem}
    .remark-input{padding-left: 7rem}
</style>
</head>
<header class="color-main vertical-box">
    <span class="header-title">订单详情</span>
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
        'title' => '卖家取消'
    ),
    '10' => array(
        'title' => '已取消'
    ),
);;
?>
<article class="btn-footer-margin">
    <section class="status-section color-main">
        <p class="big-text detail-title">状态： <?php if(!empty($order['status'])) echo $status_data[$order['status']]['title'] ?></p>
<!--        <p class="small-text white-tips-font">--><?php //echo $pt_name;?><!-- <span>--><?php //if(isset($order['paid_point'])) echo $order['paid_point']; ?><!--</span></p>-->
    </section>
    <?php if(!empty($order['address'])){?>
    <section class="linear-section last-liner-section margin-bottom">
        <div class="linear-address-section border-box">
            <p class="big-text">
                <span class="detail-icon-user active-font"></span>
                <span class="address-user"><?php if(!empty($order['address']['姓名'])) echo '姓名:'.$order['address']['姓名'] ?></span>
                <span class="detail-icon-phone2 active-font"></span><?php if(!empty($order['address']['手机号码'])) echo '手机号码:'.$order['address']['手机号码'] ?>
            </p>
            <p class="small-text tips-font">
                <?php
                $full_address='';
                if(!empty($order['address']['收货地址'])){
                    $full_address.=$order['address']['收货地址'];
                    echo '收货地址:'.$full_address;
                }
                ?>
            </p>
        </div>
    </section>
    <?php }?>
    <?php
    if(!empty($order['products'])){
        $product_num = 0;//暂时没用
        $product_price = 0;
        foreach($order['products'] as $p){
            $product_num+=$p['quantity'];
            $product_price+=$p['paid_point']*$p['quantity'];
            ?>
            <section class="good-section linear-section">
                <div class="good-section-left">
                    <img class="good-section-img" src="<?php echo $p['main_img'] ?>">
                </div>
                <div class="good-section-right border-box">
                    <p class="good-section-title"><?php echo $p['title'] ?></p>
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
                        <?php $p['paid_point'] && printf('积分：%d ',$p['paid_point']) ?>
                        <?php ($p['paid_point'] && $p['paid_fee']) && printf('%s','＋') ?>
                        <?php $p['paid_fee'] && printf('￥%.2f ',$p['paid_fee']/100) ?>
                        <span class="big-text good-section-price secondary-font">
                            x <?php echo $p['quantity'] ?></span>
                    </p>
                </div>
            </section>
    <?php
        }
    }
    ?>
    <section class="good-info-section small-text white-tips-font">
        <div class="good-right-div">
            实付：<span class="secondary-font big-text">
                 <?php $order['paid_point'] && printf('积分：%d ',$order['paid_point']) ?>
                 <?php ($order['paid_point'] && $p['paid_fee']) && printf('%s','＋') ?>
                 <?php $order['paid_fee'] && printf('￥%.2f ',$order['paid_fee']/100) ?>
            </span>
        </div>
    </section>
    <section class="good-info-section tips-font last-liner-section margin-bottom">
        <div>
            <p>订单号：<?php if(!empty($order['uid'])) echo $order['uid'] ?></p>
            <p>下单时间：<?php if(!empty($order['create_time'])) echo date('Y-m-d H:i:s',$order['create_time']) ?></p>
        </div>
    </section>

    <section class="good-info-section tips-font last-liner-section margin-bottom">
        <div>
            <?php
            if(!empty($order['send_time'])){
                $odate = date("Y年m月d日 H:i:s",$order['send_time']);
                if($odate){
                    echo '<p>发货时间：'.$odate.'</p>';
                }
            }
            if(!empty($order['delivery_info'])) {
                foreach($order['delivery_info'] as $k => $v) {
                    if($k == '快递单号') {
                        echo '<p>'.$k.' : <a target="_blank" href="https://www.kuaidi100.com/?nu='.$v.'">'.$v.'</a></p>';
                    }
                    else {
                        echo '<p>'.$k.' : '.$v.'</p>';
                    }
                }
            }
            ?>
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
		<!--
        <button class="cancel-order-btn color-disable">取消订单</button>
		-->
    <?php }
    if($order['status']==1){ ?>
		<!--
        <button class="pay-order-btn color-secondary">去支付</button>
		-->
    <?php }
    if($order['status']==2){ ?>
		<!--
        <button class=" color-disable">申请退款</button>
		-->
    <?php }
    if($order['status']==3){ ?>
        <button class="accept-order-btn weui_btn weui_btn_mini weui_btn_primary">确认收货</button>
    <?php }
    if($order['status']==4){ ?>
		<!--
        <button class="comment-order-btn color-secondary">追加评价</button>
		-->
    <?php }
    ?>

    <!--<button class="color-primary">查看物流</button>-->
</footer>

<script src="/static/js/jquery2.1.min.js"></script>
<script>
	//确认收货
	function accept_order(uid) {
            if(confirm('您确定要确认收货吗？')){
                $.post('?_a=qrposter&_u=ajax.do_receipt',{uid:uid}, function (ret) {
                    ret = $.parseJSON(ret);
                    if(ret.errno==0){
                        window.location.reload()
                    }
                })
            }
	}

        $(document).ready(function () {
                $('.btn-group')
                    .on('click','.cancel-order-btn',function () {
                        var uid = $(this).parent().data('uid');
                        //order.cancel(uid)
                    })
                    .on('click','.pay-order-btn',function () {
                        var uid = $(this).parent().data('uid');
                        //order.pay(uid)
                    })
                    .on('click','.accept-order-btn',function () {
                        var uid = $(this).parent().data('uid');
                        accept_order(uid)
                    })
                    .on('click','.comment-order-btn',function () {
                        var uid = $(this).parent().data('uid');
                        //order.comment(uid)
                    })
                ;
        });
</script>
</body>
</html>
