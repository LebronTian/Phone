
<?php include $tpl_path.'/header.tpl'; ?>
<link rel="stylesheet" href="<?php echo $static_path?>/css/coupon.css">
<style>
    .btn-footer{  margin-top: 2rem;  }
    .coupon-cover{  margin: 0 auto;  display: block;  }
</style>
<header class="color-main vertical-box">
    <span class="header-title">领取优惠券</span>
    <div class="header-left vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/back.png" onclick="history.back()">
    </div>
    <div class="header-right vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/home.png" onclick="window.location.href='?_a=shop'">
    </div>
</header>

<?php // echo'<pre>';print_r($coupon['list']);echo'</pre>';?>
<article class="coupon-container">
    <?php
    if(!empty($coupon['uid'])){
        if(!empty($coupon['img'])){
            ?>
            <img class="coupon-cover" src="<?php echo $coupon['img'] ?>">
            <?php
        }
        ?>
        <section class="coupon-section clearfix">
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
                <p class="coupon-price">
                    &yen;<span class="coupon-num"><?php echo substr($coupon['rule']['discount'],0,-2) ?></span><span class="coupon-num-top">.<?php echo substr($coupon['rule']['discount'],-2) ?></span>
                </p>
                <p class="coupon-bottom-tips small-text">
                    <span>
                        有效期：
                        <?php
                        if(!empty($coupon['duration'])){
                            echo date('Y.m.d',$coupon['create_time']) .'-'. date('Y.m.d',($coupon['create_time']+$coupon['duration']));
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
        <footer class="btn-footer footer-one-btn clearfix border-box">
            <button class="get-coupon-btn color-primary" data-uid="<?php echo $coupon['uid'] ?>">点击领取</button>
        </footer>
    <?php
    }
    elseif(!empty($coupon['list'])){
        foreach($coupon['list'] as $c){

			$had = 0;
			if(!empty($c['had_coupon'])){
				//没限制用户领取张数
				if($c['rule']['max_cnt'] == 0){
					$had = 0;
					if(!empty($c['had_coupon_day'])){
						//没限制用户一天领取张数
						if($c['rule']['max_cnt_day'] == 0){
							$had = 0;
						}else if($c['had_coupon_day'] >= $c['rule']['max_cnt_day']){
							$had = 1;
						}

					}
				}else if($c['had_coupon'] >= $c['rule']['max_cnt']){
					$had = 1;
				}else{
					//限制一天领取
					if(!empty($c['had_coupon_day'])){
						if($c['rule']['max_cnt_day'] == 0){
							$had = 0;
						}else if($c['had_coupon_day'] >= $c['rule']['max_cnt_day']){
							$had = 1;
						}
					}
				}
			}
			if(!empty($c['used_cnt'])){
				if($c['used_cnt'] >= $c['publish_cnt']){
					$had = 1;
				}
			}
            ?>
            <section class="coupon-section clearfix <?php echo !empty($had)? 'b-ccc':''?>">
                <div class="coupon-left border-box">
                    <p class="coupon-desc small-text">
                        <!--<img class="coupon-logo" src="<?php echo $static_path?>/images/coupon-logo.png">-->
                        <?php
                        if(!empty($c['rule']['min_price'])){
                            echo '付款金额满'.($c['rule']['min_price']/100).'可用';
                        }
                        else{
                            echo '无条件使用';
                        }
                        ?>
                    </p>
                    <p class="coupon-price">
                        ￥<span class="coupon-num"><?php echo substr($c['rule']['discount'],0,-2) ?></span><span class="coupon-num-top">.<?php echo substr($c['rule']['discount'],-2) ?></span>
                    </p>
                    <p class="coupon-bottom-tips small-text">
                    <span>
                        有效期：
                        <?php
                        if(!empty($c['duration'])){
                            echo date('Y.m.d',$c['create_time']) .'-'. date('Y.m.d',($c['create_time']+$c['duration']));
                        }
                        else{
                            echo '永久';
                        }
                        ?>
                    </span>
                    </p>
                </div>
                <div class="coupon-right border-box">
                    <p class="right-text"><?php echo !empty($had)? '已领取':'现金券'?></p>
                </div>
            </section>
            <footer class="btn-footer footer-one-btn clearfix border-box" style="border-bottom: thin solid #d3d3d3;padding-bottom: 2rem">
                <button class="get-coupon-btn color-primary <?php echo !empty($had)? 'hide':''?>" data-uid="<?php echo $c['uid'] ?>">点击领取</button>
            </footer>
            <?php
        }
        ?>
    <?php
    }
    ?>
</article>


<?php include $tpl_path.'/footer.tpl'; ?>

<script>
    //'jquery' or 'zepto' 脚本入口,按情况选择加载
    seajs.use(['zepto'], function () {
        $(document).ready(function () {
            $('.get-coupon-btn').click(function () {

                var uid = $(this).data('uid');
                $.post('?_a=shop&_u=ajax.addusercoupon',{coupon_uid:uid}, function (ret) {
                    ret = JSON.parse(ret);
                    if(ret.errno==0){
                        alert('领取成功');
                        window.location.href='?_a=shop&_u=user.coupons'
                    }
                    else if(ret.errno==403){
                        alert('您已经领取过了');
                        location.href='?_a=shop&_u=user.coupons'
                    }
                    else{
                        alert('领取失败，请确认领取资格，错误代码：'+ret.errno);
                    }
                })
            })
        })
    });
</script>
</body>
</html>