
<?php include $tpl_path.'/header.tpl'; ?>

<style>
    body{background: white}
    .commentlist-section{border-bottom: thin solid #dadada;padding-bottom: 1rem}
    .commentlist-section.left-right-section .right-section{padding-left: 5rem;padding-right: 0.834rem}
    .avatar-img{width: 5rem;height: 5rem;border-radius: 50%;padding: 1rem}
    .commentlist-title{padding-top: 1rem;height: 3rem;line-height: 3rem;}
    .commentlist-star-group{float: right;vertical-align: middle}
    .commentlist-star-group>img{width: 1.5rem;}
    /**/
    .commentlist-pic-article section{ height: 0;width: 22%;position: relative;padding:0 0 22%;float: left;margin-right: 4%;margin-bottom: 1rem;background: white}
    .commentlist-pic-article section:nth-child(4n){margin-right: 0}
    .commentlist-pic-article section>.square-div{ position: absolute;height: 100%;width: 100%;border: thin solid #dadada;text-align: center}
    .square-div>img{width: 100%;height: 100%;}
    .square-div.text-square span{vertical-align: middle;}
    .commentlist-pic-article{margin-top: 0.5rem}
</style>
<header class="color-main vertical-box">
    <span class="header-title">评价</span>
    <div class="header-left vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/back.png" onclick="history.back()">
    </div>
    <div class="header-right vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/home.png" onclick="window.location.href='?_a=shop'">
    </div>
</header>
<article class="margin-top margin-bottom">
    <script id="comment-tpl" type="text/x-dot-template">

        {{~it.list:value:index}}

        <section class="commentlist-section left-right-section">
            <div class="left-section">
                <img class="avatar-img border-box" src="{{? value.user.avatar!=''}}{{=value.user.avatar}}{{??}}<?php echo $static_path?>/images/avatar.png{{?}}">
            </div>
            <div class="right-section border-box">
                <div class="commentlist-title vertical-box">
                    <span class="tips-font">{{=value.user.name}}</span>
                    <div class="commentlist-star-group">
                        {{ for(var i=0;i<value.score;i++){ }}
                            <img src="<?php echo $static_path?>/images/star1.png">
                        {{ } }}
                        {{ for(var i=0;i<5-value.score;i++){ }}
                            <img src="<?php echo $static_path?>/images/star1_.png">
                        {{ } }}
                    </div>
                </div>
                <p class="comment-content tips-font">{{=value.brief}}</p>
                <article class="commentlist-pic-article clearfix">
                    {{~value.images:img}}
                    <section>
                        <div class="square-div"><img src="{{=img}}"></div>
                    </section>
                    {{~}}
                    <!--<section>
                        <div class="square-div text-square vertical-box"><span class="active-font">更多...</span></div>
                    </section>-->
                </article>
                <p class="white-tips-font small-text">{{=doT.date(value.create_time)}} <!--颜色：红色    尺码：S--></p>
            </div>
        </section>

        {{~}}

    </script>

    <p class="load-more"><!--加载中...--></p>
</article>

<?php include $tpl_path.'/footer.tpl'; ?>

<script>
    var product_uid = <?php echo($uid = requestInt('uid'))? $uid:'null' ?>;
    console.log(product_uid);
    //'jquery' or 'zepto' 脚本入口,按情况选择加载
    seajs.use(['jquery','doT'], function () {
        $(document).ready(function () {
            if(!product_uid) history.back();

            getComment();
            function getComment(page){
                var data = {
                    product_uid:product_uid,
                    page:page
                };
                $.getJSON('?_a=shop&_u=ajax.get_product_comments',data,function (ret) {
                    console.log(ret);
                    if(ret.errno==0){
                        var commentTpl = doT.template($('#comment-tpl').text());
                        $('.load-more').before(commentTpl(ret.data))
                    }
                })
            }
            /*
                doT里的时间戳转换
            */
            doT.date = function (tmp) {
                var date = new Date(tmp*1000);
                return date.getFullYear()+'-'+date.getMonth()+'-'+date.getDate()
            };
        })
    });
</script>
</body>
</html>