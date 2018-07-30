<?php include $tpl_path.'/header.tpl'; ?>
<style>
    .active-font {
    color: #ff6600;
}.active-bg{background: #55A511}
.color-secondary{
	background: #999 !important;
}
.days button{    border: none;
    border-radius: 3px;
    padding: 7px 2px;
    width: 8rem;}
</style>
<link rel="stylesheet" href="<?php echo $static_path;?>/css/good.css">
<link rel="stylesheet" href="<?php echo $static_path;?>/css/fonts.css">
<link rel="stylesheet" href="<?php echo $static_path;?>/css/count_box.css">
<link rel="stylesheet" href="<?php echo $static_path;?>/css/cart.css">
<header class="vertical-box b-main">
    <span class="header-title">购物车</span>
    <?php
    if(!empty($cart)){
        ?>
        <div class="edit-cart-btn header-right vertical-box white-tips-font">
            <span class="img-btn" style="color: #fff;">编辑</span>
        </div>
    <?php
    }
    ?>
</header>
<article class="<?php echo(!empty($cart)?"cart-":"") ?>nav-footer-margin">
    <article class="cart-article">
        <?php
        if(!empty($cart)){
            $arr_biz  = array();
            foreach ($cart as $c) {
                array_push($arr_biz, $c['product']['biz_uid']);
                sort($arr_biz);
                $arr_biz = array_unique($arr_biz);
            }
            foreach($arr_biz as $b){
                foreach ($cart as $c) {
                    if($c['product']['biz_uid'] == $b){
                ?>

                <section class="good-section linear-section checked-section" data-uid="<?php echo $c['uid'] ?>" data-productuid="<?php echo $c['product']['uid']?>">
                    <div class="good-left-check vertical-box">
                    <span class="circle-checkbox active-bg">
                        <img src="<?php echo $static_path;?>/images/check.png">
                    </span>
                    </div>
                    <div class="good-section-left">
                        <img class="good-section-img" src="<?php echo (empty($c['product']['main_img'])?'':$c['product']['main_img']) ?>">
                    </div>
                    <div class="good-section-right border-box">
                        <p class="good-section-title"><?php echo (empty($c['product']['title'])?'':$c['product']['title']) ?></p>
                        <?php
                        if(!empty($c['product']['sku_uid'][1])){
                            ?>
                            <p class="good-section-option small-text tips-font"><?php echo $c['product']['sku_uid'][1] ?></p>
                            <?php
                        }
                        ?>
                        <?php
                        if(!empty($c['date_time'])){
                            ?>
                            <p class="good-section-option small-text tips-font yy_time"><?php echo $c['date_time'] ?></p>
                            <?php
                        }
                        ?>
                        <p class="good-section-option small-text tips-font clearfix buy-mode">
                            ￥<?php echo (empty($c['product']['price'])?'':sprintf("%.2f", $c['product']['price']/100)) ?> x <?php echo $c['quantity'] ?>
                            <span class="big-text good-section-price secondary-font">
                                ￥<span class="product-price"><?php echo (empty($c['product']['price'])?'':sprintf("%.2f", ($c['product']['price']*$c['quantity'])/100)) ?></span>
                            </span>
                        </p>
                        <p class="good-section-option small-text tips-font clearfix edit-mode" style="display: none">
                            <span class="section-type sku-type count-box clearfix">
                                <button class="count-btn cut-btn big-text">-</button>
                                <input class="count-input" type="text" value="<?php echo $c['quantity'] ?>" readonly="">
                                <button class="count-btn add-btn big-text">+</button>
                            </span>
                        </p>
                    </div>
                </section>

                <?php
                    }
                } echo '&nbsp;';
            }
        }
        else{
            ?>
            <p class="empty-cart-p tips-font">购物车还是空的噢<br/><a class="cart_to_shop c-green" href="?_a=shop">去挑几件商品吧</a></p>
        <?php
        }
        ?>
    </article>

    <?php
    if(!empty($guess['list'])){
        ?>
        <p class="guess-title cut-off-rule-p hide">猜你喜欢</p>
        <article class="guess-article block-good-article clearfix hide">
            <?php
            foreach($guess['list'] as $g){
                ?>
                <section class="block-good-section border-box" onclick="window.location.href='?_a=shop&_u=index.product&uid=<?php echo $g['uid'] ?>'">
                    <div class="block-top">
                        <img class="block-good-img" src="<?php echo $g['main_img'] ?>">
                    </div>
                    <div class="block-bottom">
                        <p class="text-ellipsis"><?php echo $g['title'] ?></p>
                        <p class="secondary-font">￥<?php echo sprintf("%.2f", $g['price']/100) ?></p>
                    </div>
                </section>
            <?php
            }
            ?>
        </article>
    <?php
    }
    ?>

</article>

<?php
if(!empty($cart)){
    ?>
    <footer class="fix-btn-group clearfix big-text">
        <div class="group-left border-box">
            合计：￥<span id="products-price-all">0</span>
        </div>
        <div class="group-right border-box b-main buyImmediately">
            <span class="group-right-text">去结算</span>
            <span class="normal-text">（<span id="products-count">0</span>）</span>
        </div>
    </footer>
    <?php
}
?>

<?php include $tpl_path.'/footer2.tpl';?>
	
<script type="text/javascript">
	$('.index-classify ul li img').height($('.index-classify ul li img').width());
</script>

<?php include $tpl_path.'/footer.tpl'; ?>

<script>
    //'jquery' or 'zepto' 脚本入口,按情况选择加载
    seajs.use('zepto', function () {
        $(document).ready(function () {
            /*
                结算按钮
            */
            $('.buyImmediately').click(function () {
                var uid = $(this).data('uid');
                if(uid&&uid!=''){
                    var edit_status = $(this).hasClass('editing-cart');
                    /*结算*/
                    console.log('22')
					if(!edit_status) {
							window.location.href = '?_easy=shop.index.makeorder&cart_uid=' + uid;
					}
                    /*删除*/
                    else{
                        if(confirm('您确定要删除吗？')){
                            uid = uid.split(',');
                            console.log(uid);
                            $.post('?_a=shop&_u=ajax.delete_cart',{uids:uid}, function (ret) {
                                ret = JSON.parse(ret);
                                console.log(ret);
                                if(ret.errno==0){
                                    showTip('','删除成功','');
                                    window.location.reload();
                                }
                                else{
                                    showTip('','删除失败'+ret.errno,'');
                                    window.location.reload();
                                }
                            })
                        }
                    }
                }
                else{
                    showTip('','请选择商品','')
                }
            });
            /*
                编辑按钮
            */
            $('.edit-cart-btn').click(function () {
                var buy = $('.buyImmediately');
                var text = $('.group-right-text');
                var status = buy.hasClass('editing-cart');
                if(status) {
                    buy.removeClass('editing-cart color-secondary');
                    text.text('去结算');
                    $(this).children().text('编辑');
                }
                else {
                    buy.addClass('editing-cart color-secondary');
                    text.text('删除');
                    $(this).children().text('完成')
                }
//                $('.edit-mode').toggle();
//                $('.buy-mode').toggle();
            });
            seajs.use('seajs/count_box', function (count) {
                $('.count-box .add-btn').click(function (event) {
                    var box = $(this).parents('.count-box');
                    count.add(box)
;                    event.stopPropagation()
                });
                $('.count-box .cut-btn').click(function (event) {
                    var box = $(this).parents('.count-box');
                    count.cut(box);
                    event.stopPropagation()
                })
            });
            /*
                选择购物车里的商品
            */
           $(function(){
                check_price()
           })
            $('.good-left-check').click(function () {
                $(this).parent().toggleClass('checked-section');
                $(this).find('.circle-checkbox').toggleClass('active-bg');
                check_price()
            });
            $('section .good-section-left,section .good-section-right').click(function(){
                 location.href='?_a=shop&_u=index.product&uid='+$(this).parent().data('productuid');
            })
            /*更新价格*/
            function check_price(){
                var price_all = 0;
                var checked_section = $('.checked-section');
                var card_uid = '';/*随手记录购物车uid*/
                checked_section.each(function () {
                    price_all+=parseFloat($(this).find('.product-price').text(),10);
                    /**/
                    var uid = $(this).data('uid');
                    card_uid += ','+uid
                });
                card_uid = card_uid.substr(1);
                //console.log('all',card_uid);
                $('.buyImmediately').data('uid',card_uid);
                $('#products-price-all').text(price_all.toFixed(2));
                $('#products-count').text(checked_section.length)
            }

        })
    });
</script>
</body>
</html>
