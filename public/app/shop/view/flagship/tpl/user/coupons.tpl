<?php include $tpl_path.'/header.tpl'; ?>

<link rel="stylesheet" href="<?php echo $static_path?>/css/coupon.css">
<header class="color-main vertical-box">
    <span class="header-title">我的优惠券</span>
    <div class="header-left vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/back.png" onclick="history.back()">
    </div>
    <div class="header-right vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/home.png" onclick="window.location.href='?_a=shop'">
    </div>
</header>
<?php
if(!empty($type)&&$type=='select'){
    ?>
    <article class="margin-top">
        <footer class="btn-footer footer-one-btn ">
            <button class="cancel-coupon color-primary">不使用优惠券</button>
        </footer>
    </article>

    <p class="tips-font list-bottom-tips margin-top">
        以下为可以使用的优惠券<br/>点击立即使用
    </p>
<?php
}
?>
<article class="coupon-container">
    <?php
    if(!empty($coupons['list'])){
        foreach($coupons['list'] as $c){
            if(!empty($c['out_limit_price'])){
                continue;
            }
            $coupon = $c['info'];
            ?>
            <section class="coupon-section clearfix" data-uid="<?php echo $c['uid'] ?>">
                <div class="coupon-left border-box">
                    <p class="coupon-desc small-text">
                        <!--<img class="coupon-logo" src="<?php echo $static_path?>/images/coupon-logo.png">-->
                        <?php
                        if(!empty($coupon['rule']['min_price'])){
                            echo '付款金额满'.($coupon['rule']['min_price']/100).'可用';
                        }
                        else{
                            echo '无条件使用';
                        }
                        ?>
                    </p>
                    <p class="coupon-price text-ellipsis">
                        ￥<span class="coupon-num"><?php echo substr($coupon['rule']['discount'],0,-2) ?></span><span class="coupon-num-top">.<?php echo substr($coupon['rule']['discount'],-2) ?></span>
                    </p>
                    <p class="coupon-bottom-tips small-text">
                    <span>
                        有效期：
                        <?php
                        if(!empty($c['expire_time'])){
                            echo date('Y.m.d',$c['create_time']) .'-'. date('Y.m.d',($c['expire_time']));
                        }
                        else{
                            echo '永久';
                        }
                        ?>
                    </span>
                    </p>
                </div>
                <div class="coupon-right border-box">
                    <p class="right-text">现金券</p>
                </div>
            </section>
    <?php
        }
    }
    else{
        echo '<p class="list-bottom-tips">暂无可使用优惠券</p>';
    }
    ?>
</article>

<?php
if(empty($type)){
    ?>
    <p class="list-bottom-tips margin-bottom tips-font" style="margin-top: 2rem;" onclick="window.location.href='?_a=shop&_u=index.get_coupon'">
        更多优惠券，点击这里
    </p>
    <?php
}
?>

<?php include $tpl_path.'/footer.tpl'; ?>

<script>
    var type_data = <?php echo(!empty($type)? json_encode($type):"null")?>;
    console.log(type_data);
    //'jquery' or 'zepto' 脚本入口,按情况选择加载
    seajs.use(['zepto'], function () {
        $(document).ready(function () {
            /*选择模式*/
            if(type_data=='select'){
                seajs.use('zepto_cookie', function () {
                    $('.coupon-section').click(function () {
                        var uid = $(this).data('uid');
                        $.cookie('coupon_uid',uid);
                        $.cookie('freshen_data',true);
                        history.back()
                    });
                    $('.cancel-coupon').click(function () {
                        $.cookie('coupon_uid',null);
                        $.cookie('freshen_data',true);
                        history.back()
                    })
                })
            }
        })
    });
</script>
</body>
</html>