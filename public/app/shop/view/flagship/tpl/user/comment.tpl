
<?php include $tpl_path.'/header.tpl'; ?>

<link rel="stylesheet" href="<?php echo $static_path?>/css/good.css">
<style>
    .star-section{padding: 1.5rem}
    .star-section img{ padding: 0.3rem;width: 1.6667rem}
    .comment-section{padding:0 0.834rem}
    .comment-section textarea{width: 100%;border-radius: 3px;height: 7rem;resize: none;border: thin solid #dadada;padding: 0.7rem}
    .pic-content{padding:0.834rem}
    .pic-content section{ height: 0;width: 22%;position: relative;padding:0 0 22%;float: left;margin-right: 4%;margin-bottom: 1rem;background: white}
    .pic-content section:nth-child(4n){margin-right: 0}
    .pic-content section>.square-div{ position: absolute;height: 100%;width: 100%}
    .square-div>img{width: 100%;height: 100%;border: thin solid #dadada}
    .icon-img{padding:1.5rem}
</style>
<header class="color-main vertical-box">
    <span class="header-title">发表评论</span>
    <div class="header-left vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/back.png" onclick="history.back()">
    </div>
    <div class="header-right vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/home.png" onclick="window.location.href='?_a=shop'">
    </div>
</header>
<article class="">
    <section class="good-section linear-section margin-top">
        <div class="good-section-left">
            <img class="good-section-img" src="<?php if($order['products'][0]['main_img']) echo $order['products'][0]['main_img'] ?>">
        </div>
        <div class="good-section-right border-box">
            <p class="good-section-title"><?php if($order['products'][0]['title']) echo $order['products'][0]['title'] ?></p>
            <?php
            $sku_index =strpos($order['products'][0]['sku_uid'],';');
            if(!empty($sku_index)){
                ?>
                <p class="good-section-option small-text tips-font">
                    <?php echo substr($order['products'][0]['sku_uid'],strpos($order['products'][0]['sku_uid'],';')+1);?>
                </p>
            <?php
            }
            ?>
            <p class="good-section-option small-text tips-font clearfix">
                ￥<?php if($order['products'][0]['paid_price']) echo sprintf("%.2f", $order['products'][0]['paid_price']/100) ?> x <?php if($order['products'][0]['quantity']) echo $order['products'][0]['quantity'] ?>
                <span class="big-text good-section-price secondary-font">
                    ￥<?php if($order['products'][0]['paid_price']) echo sprintf("%.2f", $order['products'][0]['paid_price']*$order['products'][0]['quantity']/100) ?>
                </span>
            </p>
        </div>
    </section>
    <section class="star-section">
        <img class="active-star" src="<?php echo $static_path?>/images/star1.png">
        <img class="active-star" src="<?php echo $static_path?>/images/star1.png">
        <img class="active-star" src="<?php echo $static_path?>/images/star1.png">
        <img class="active-star" src="<?php echo $static_path?>/images/star1.png">
        <img class="active-star" src="<?php echo $static_path?>/images/star1.png">
    </section>
    <section class="comment-section">
        <textarea class="brief-textarea border-box" placeholder="亲，您的评价对其他买家有很大帮助"></textarea>
    </section>
    <section class="pic-content clearfix">
        <section id="uploadBtn" class="upload-btn icon-section"><div class="square-div">
            <img class="icon-img border-box" src="<?php echo $static_path?>/images/add.png">
        </div></section>
        <script id="pic-tpl" type="text/x-dot-template">
            <section class="pic-section"><div class="square-div">
                    <img class="good-img" src="{{=it}}">
            </div></section>
        </script>
    </section>
    <footer class="btn-footer footer-one-btn margin-bottom">
        <button class="saveComment color-primary">提交评论</button>
    </footer>
</article>

<?php include $tpl_path.'/footer.tpl'; ?>

<script>
    var order_data = <?php echo(!empty($order)? json_encode($order):"null")?>;//useful
    //'jquery' or 'zepto' 脚本入口,按情况选择加载
    seajs.use(['jquery','doT'], function () {
        $(document).ready(function () {

            seajs.use('upload');

            $('.star-section img').click(function () {
                $(this)
                    .attr('src','<?php echo $static_path?>/images/star1.png').addClass('active-star')
                    .prevAll().attr('src','<?php echo $static_path?>/images/star1.png').addClass('active-star');
                $(this).nextAll().attr('src','<?php echo $static_path?>/images/star1_.png').removeClass('active-star');
            });
            $('.pic-content').on('click','.pic-section', function () {
                if(confirm('您想取消此图片吗？')){
                    $(this).remove()
                }
            });
            $('.saveComment').click(function () {
                var brief = $('.brief-textarea').val().trim();
                if(brief==''){
                    alert('评价不能为空');
                    return
                }
                var images = [];
                $('.pic-section').each(function () {
                    var src = $(this).find('.good-img').attr('src');
                    images.push(src)
                });
                images = images.join(';');
                var data = {
                    order_uid:order_data.uid,
                    product_uid:order_data.products[0].sku_uid,
                    score:$('.active-star').length,
                    brief:brief,
                    images:images
                };
                console.log(data);
                $.post('?_a=shop&_u=ajax.do_product_comment',data, function (ret) {
                    ret = JSON.parse(ret);
                    if(ret.errno==0){
                        alert('评论成功');
                        history.back()
                    }
                    else{
                        alert('评论失败，错误'+ret.errno);
                        history.back()
                    }

                })
            })
        })
    });
</script>
</body>
</html>