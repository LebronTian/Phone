<?php include $tpl_path.'/header.tpl'; ?>
<link rel="stylesheet" href="<?php echo $static_path?>/css/detail_font.css">
<link rel="stylesheet" href="<?php echo $static_path?>/css/makeorder.css">
<link rel="stylesheet" href="<?php echo $static_path?>/css/good.css">
<header class="color-main vertical-box">
    <span class="header-title">提交订单</span>
    <div class="header-left vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/back.png" onclick="history.back()">
    </div>
    <div class="header-right vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/home.png" onclick="window.location.href='?_a=shop'">
    </div>
</header>
<article class="makeorder-section btn-footer-margin">
    <?php
    if(!empty($address[0])){
        ?>
        <section class="address-section linear-section margin-top-section margin-bottom last-liner-section"
                 onclick="window.location.href='?_a=shop&_u=user.address&type=select'"
                 data-uid="<?php echo $address[0]['uid'] ?>">
            <div class="linear-address-section border-box">
                <p class="big-text">
                    <span class="fa fa-user c-green" style="font-size: 1.3em;"></span><span class="address-user"><?php echo $address[0]['name'] ?></span>
                    <span class="fa fa-mobile c-green fa-2x" style="position: relative;top: 2px;"></span><?php echo $address[0]['phone'] ?>
                </p>
                <p class="small-text tips-font">
                    <?php
                    $full_address='';
                    if(!empty($address[0]['province'])) $full_address.=$address[0]['province'];
                    if(!empty($address[0]['city'])) $full_address.=$address[0]['city'];
                    if(!empty($address[0]['town'])) $full_address.=$address[0]['town'];
                    if(!empty($address[0]['address'])) $full_address.=$address[0]['address'];
                    echo $full_address;
                    ?>
                </p>
            </div>
        <span class="linear-right vertical-box"><span>
            <img src="<?php echo $static_path?>/images/go.png">
        </span></span>
        </section>
    <?php
    }
    else{
        ?>
        <section class="address-section linear-section margin-top-section margin-bottom last-liner-section" onclick="window.location.href='?_a=shop&_u=user.address&type=select'">
            <div class="linear-address-section border-box">
                <p class="big-text">请选择您的收货信息</p>
            </div>
        <span class="linear-right vertical-box"><span>
            <img src="<?php echo $static_path?>/images/go.png">
        </span></span>
        </section>
    <?php
    }
    ?>


    <?php
    /*立即购买模式*/
    if(!empty($product)){
		if(!empty($product['virtual_info'])) $no_address = true;
        ?>
        
        <section class="good-section linear-section">
            <div class="good-section-left">
                <img class="good-section-img" src="<?php if(!empty($product['main_img'])) echo $product['main_img']; ?>">
            </div>
            <div class="good-section-right border-box">
                <p class="good-section-title"><?php if(!empty($product['title'])) echo $product['title']; ?></p>
                <?php
                if(!empty($sku)){
                    ?>
                    <p class="good-section-option small-text tips-font"><?php echo $sku?></p>
                <?php
                }
                ?>
                <p class="good-section-option small-text tips-font clearfix">
                    &yen;<?php echo sprintf("%.2f", $product['price']/100) ?> x <?php if(!empty($quantity)) echo $quantity?>
                    <span class="big-text good-section-price secondary-font">&yen;<?php echo sprintf("%.2f", ($product['price']*$quantity)/100) ?></span>
                </p>
            </div>
        </section>
    <?php
    }
    /*购物车模式*/
    elseif(!empty($cart_list_products)){
        $cart_price = 0;//记录购物车总价格
		$no_address = true;
        foreach ($cart_list_products as $c) {
			if(empty($c['product']['virtual_info'])) $no_address = false;
            $cart_product = $c['product'];
            $cart_price+=$cart_product['price']*$c['quantity']
            ?>
            <section class="good-section linear-section cart-list-a">
                <div class="good-section-left">
                    <img class="good-section-img" src="<?php if(!empty($cart_product['main_img'])) echo $cart_product['main_img']; ?>">
                </div>
                <div class="good-section-right border-box">
                    <p class="good-section-title"><?php if(!empty($cart_product['title'])) echo $cart_product['title']; ?></p>
                    <?php
                    if(!empty($cart_product['sku_uid'][1])){
                        ?>
                        <p class="good-section-option small-text tips-font"><?php echo $cart_product['sku_uid'][1]?></p>
                    <?php
                    }
                    ?>
                    <?php
                    if(!empty($c['date_time'])){
                        ?>
                        <p class="good-section-option small-text tips-font yy_time"><?php echo $c['date_time']?></p>
                    <?php
                    }
                    ?>
                    <p class="good-section-option small-text tips-font clearfix">
                        &yen;<?php echo sprintf("%.2f", $cart_product['price']/100) ?> x <?php if(!empty($c['quantity'])) echo $c['quantity']?>
                        <span class="big-text good-section-price secondary-font">&yen;<?php echo sprintf("%.2f", ($cart_product['price']*$c['quantity'])/100) ?></span>
                    </p>
                </div>
            </section>
        <?php
        }
    }
    ?>

    <section class="delivery-section linear-section yy_time hide">
        <span class="linear-title vertical-box"><span>预定时间</span></span>
        <p class="linear-input border-box small-text tips-font"></p>
    </section>
    <section class="delivery-section linear-section">
        <span class="linear-title vertical-box"><span>配送方式</span></span>
        <p class="linear-input border-box small-text tips-font">快递费：<span class="delivery-fee"></span></p>
    </section>
    <?php
    $real_price = 0;
    if(!empty($product)){
        $real_price =  sprintf("%.2f", ($product['price']*$quantity)/100);
    }
    elseif(!empty($cart_list_products) && !empty($cart_price)){
        $real_price =  sprintf("%.2f", $cart_price/100);
    }
    ?>
    <section class="linear-section margin-top-section"
             onclick="window.location.href='?_a=shop&_u=user.coupons&type=select&paid_fee=<?php echo $real_price*100 ?>'"
             data-uid="<?php if(!empty($coupon['uid'])) echo $coupon['uid'] ?>">
        <span class="linear-title vertical-box"><span>优惠券</span></span>
        <input class="linear-input border-box tips-font" type="text" readonly placeholder="请选择使用优惠券"
               value="<?php if(!empty($coupon['info']['title'])) echo $coupon['info']['title'].'：优惠&yen;'.sprintf("%.2f", $coupon['info']['rule']['discount']/100) ?>">
        <span class="linear-right vertical-box"><span>
            <img src="<?php echo $static_path?>/images/go.png">
        </span></span>
    </section>



    <?php
    if(!empty($vipcard_discount)&&$vipcard_discount!=1){
        ?>
        <!--会员卡优惠-->
        <section class="linear-section">
            <span class="linear-title vertical-box"><span>会员优惠</span></span>
            <input class="linear-input border-box tips-font" type="text" value="<?php echo ($vipcard_discount*10).'折优惠：减免&yen;'.$real_price*$vipcard_discount ?>" readonly placeholder="">
        </section>
    <?php
    }
    ?>


    <section class="linear-section last-liner-section">
        <span class="linear-title vertical-box"><span>备注</span></span>
        <input class="remark-input linear-input border-box tips-font" type="text" value="" placeholder="请填写您的留言">
    </section>
    <!---->
    <section class="linear-section margin-top-section linear-noinput">
        <span class="small-text tips-font linear-title vertical-box"><span>请选择支付方式</span></span>
    </section>
    <section class="pay-type-section linear-section linear-noinput vertical-box last-liner-section" data-payment='11'>
        <span class="linear-title vertical-box"><span>微信支付</span></span>
        <span class="linear-right vertical-box"><span class="circle-checkbox active-bg">
            <img style="margin: 0" src="<?php echo $static_path?>/images/check.png">
        </span></span>
    </section>
    <section class="pay-type-section linear-section linear-noinput vertical-box last-liner-section" data-payment='8'>
        <span class="linear-title vertical-box"><span>余额支付</span></span>
        <span class="linear-right vertical-box"><span class="circle-checkbox">
            <img style="margin: 0" src="<?php echo $static_path?>/images/check.png">
        </span></span>
    </section>
    <!--<section class="pay-type-section linear-section linear-noinput vertical-box last-liner-section margin-bottom">
        <span class="linear-title vertical-box"><span>支付宝支付</span></span>
        <span class="linear-right vertical-box"><span class="circle-checkbox">
            <img style="margin: 0" src="<?php echo $static_path?>/images/check.png">
        </span></span>
    </section>-->
</article>
<footer class="btn-footer">

    <div class="makeorder-footer-left color-main border-box fz-16">
        实付款：&yen;
        <span id="real-pay"
              data-price="<?php echo $real_price ?>"
              data-coupon="<?php if(!empty($coupon['info']['rule']['discount'])) echo $coupon['info']['rule']['discount']/100 ?>"
              data-discount="<?php if(!empty($vipcard_discount)&&$vipcard_discount!=1) echo $vipcard_discount ?>">
            <?php 
                echo $real_price;
             ?>
        </span>
    </div>
    <div class="makeorderBtn makeorder-footer-right b-red fz-16">提交订单</div>
</footer>

<?php 

include $tpl_path.'/footer.tpl'; 
?>

<script>
    var product_data = <?php echo(!empty($product)? json_encode($product):"null")?>;//useful
    var address_data = <?php echo(!empty($address[0])? json_encode($address[0]):"null")?>;//useful
    var quantity_data = <?php echo(!empty($quantity)? json_encode($quantity):"null")?>;//useful
    var sku_data = <?php echo(!empty($sku)? json_encode($sku):"null")?>;//useful
    var cart_data = <?php echo(!empty($cart_list_products)? json_encode($cart_list_products):"null")?>;//useful
    var cart_uid = <?php echo(!empty($cart_uid)? json_encode($cart_uid):"null")?>;//useful
    var coupon_data = <?php echo(!empty($coupon)? json_encode($coupon):"null")?>;
	var g_no_address = <?php echo !empty($no_address) ? 'true' : 'false';?>;
    //'jquery' or 'zepto' 脚本入口,按情况选择加载
    seajs.use('jquery', function () {
        $(document).ready(function () {
            seajs.use('jquery_cookie', function () {
				if(g_no_address) {
					$('.address-section').hide();
				}

                /*
                    下单,下单完清楚优惠券信息
                */
                $(".makeorderBtn").click(function () {
                    var delivery = $('.delivery-section').data('type');
                    var pay_type = $('.pay-type-section .linear-right .active-bg').parents('.pay-type-section').data('payment');
                    var data = {
                        delivery:delivery,//不传就包邮
                        pay_type:pay_type,
                        info:{
                            remark:$('.remark-input').val()
                        }
                    };
                    var address_uid = $('.address-section').data('uid');//
					if(!g_no_address) {
	                    if(!address_uid){
                        	alert('请选择地址');
	                        return
                    	}
						data['address_uid'] = address_uid;
					}

                    /*立即购买*/
                    if(product_data){
                        var products = {
                            "0":{
                                sku_uid:product_data['uid'],
                                quantity:quantity_data
                            }
                        };
                        if(sku_data){
                            products['0']['sku_uid'] += ';'+sku_data
                        }
                        data['products'] = products
                    }
                    /*购物车*/
                    else if(cart_data){
//						if($('.makeorder-section .cart-list-a').length != 1) {
//							var a = new Array();
//							var b = false;
//							$($('.makeorder-section .cart-list-a')).each(function(ii, i) {
//								a.push($(i).find('.yy_time').text());
//							});
//							
//							for(var i = 1;i<a.length;i++){
//								if(a[i] != a[i-1]){
//									alert('购物车规则：预约时间必须一致方可下单，请取消或替换不一致商品');
//									b = true;
//									break;
//								}
//							}
//							
//							if(!b){
//								alert('一致');
//							}else{
//								return;
//							}
//						} 
	                        data['cart_uid'] = cart_uid;
                    }
                    /*优惠券*/
                    if(coupon_data){
                        data['coupon_uid'] = coupon_data['uid'];
                    }

//                    //计算距离、价格
//                    data['lng'] = 113.928375;
//                    data['lat'] = 22.568987;
//                    $.post('?_a=shop&_u=ajax.preview_order_send',data,function (ret) {
//                        ret = JSON.parse(ret);
//                        console.log(ret);
//                    })
//                    return;
                    $.post('?_a=shop&_u=ajax.make_order',data,function (ret) {
                        ret = JSON.parse(ret);console.log(ret);
                        if(ret.errno==0){

                            $.cookie('coupon_uid',null);//清除
//                          showTip('','下单成功','1000');
                            window.location.replace('?_a=pay&oid=b'+ret.data);
                        }
                        else if(ret.errno==403){
                            showTip('','库存不足，下单失败','1000');
                            history.back();
                            setTimeout(function () {

                            },1000);
                        }
                        else{
                            showTip('','下单失败','1000');
                        }
                    })
                });
                /*
                    根据cookie刷新页面获取新的内容，解决微信的缓存
                */
                var freshen_data = $.cookie('freshen_data');
                if(freshen_data=='true'){
                    $.cookie('freshen_data','false');
                    window.location.reload()
                }
            });

            /*付款数整合计算*/
            function countPrice(ele){
                var base_price = parseFloat(ele.data('price'));
                if(!base_price){return NaN}
                /*折扣先算*/
                var discount_price = parseFloat(ele.data('discount'));
                if(discount_price){
                    base_price*=discount_price
                }
                /*加减类优惠券*/
                var coupon_price = parseFloat(ele.data('coupon'));
                if(coupon_price){
                    base_price-=coupon_price
                }
                /*最后算邮费*/
                /*邮费*/
                var delivery_price = parseFloat(ele.data('delivery'));
                if(delivery_price){
                    base_price+=delivery_price
                }
                return base_price;
            }
            $('#real-pay').text(countPrice($('#real-pay')).toFixed(2));//自调用初始化一次
            /*
                获取邮费信息,也需要刷新页面更新地址产品信息
            */
            if(address_data){
                /*地址信息*/
                var data = {
                    province:address_data.province,
                    city:address_data.city,
                    town:address_data.town
                };
                /*单物品信息*/
                if(product_data){
                    data['uid'] = product_data.uid;
                    data['quantity'] = quantity_data
                }
                /*购物车多物品信息*/
                else if(cart_data){
                    var products = {};
                    $.each(cart_data, function (index) {
                        products[index] = {
                            uid:this.product.uid,
                            quantity:this.quantity
                        }
                    });
                    console.log(products);
                    data['products'] = products
                }
                $.post('?_a=shop&_u=ajax.preview_delivery', data, function (ret) {
                    ret = JSON.parse(ret);
//                    console.log(ret);
                    if(ret.errno==0){
                        /*配送方式显示数据*/
                        var delivery_fee = (ret.data.mail)? (ret.data.mail/100).toFixed(2)+'元':'包邮';
                        $('.delivery-fee').text(delivery_fee);
                        /*为提交的数据记录一下*/
                        $('.delivery-section').data('type',(ret.data.mail)?'mail':'');
                        /*old:实付款更新
                        var old_price = parseInt($('#real-pay').text());
                        var delivery_price = ret.data.mail ? (ret.data.mail/100):0;
                        var new_price = old_price + delivery_price;
                        $('#real-pay').text(new_price.toFixed(2))*/
                        /*整合计算*/
                        $('#real-pay')
                            .data('delivery',ret.data.mail ? (ret.data.mail/100):0)
                            .text(countPrice($('#real-pay')).toFixed(2));
                    }
                })
            }
        })
    });
//支付方式选择
		$('body').on('click','.pay-type-section .linear-right span',function(){
			$(this).toggleClass('active-bg');
			$(this).parents('.pay-type-section').siblings('.pay-type-section').find('.linear-right span').toggleClass('active-bg');
		})
</script>
</body>
</html>
