<?php include $tpl_path.'/header.tpl'; ?>
<link rel="stylesheet" href="/app/form/view/appointment/static/css/form.css">
<div id="form-bar-1">
    <header id="form-header">
        <div>
            <img src="/app/form/view/appointment/static/images/header-bg.png">
            <div class="left"></div>
            <div class="right"></div>
        </div>
    </header>
    <style>
        

    </style>
    <div class="loading">
        <img src="/app/form/view/appointment/static/images/loading_bg.png" class="loading_bg">
        <p>页面加载中...<p>
    </div>
    <article id="home-bar">
        <div>
            <div onclick="window.location.href='?_a=form&_u=index.details&f_uid=<?php echo $form['uid'];?>'">
                <span></span>
                <img src="/app/form/view/appointment/static/images/index_word_1.png" class="index_word_1">
                <!-- <p>千元学车</p>
                <p>优惠大礼包</p> -->
            </div>
        </div>
        <div>
            <div onclick="window.location.href='?_a=form&_u=index.attention&f_uid=<?php echo $form['uid'];?>'">
                <span></span>
                <img src="/app/form/view/appointment/static/images/index_word_2.png" class="index_word_2">
                <!-- <p>进“喱米团子”</p>
                <p>微信群 抢红包</p> -->
            </div>
        </div>
        <div>
            <div onclick="window.location.href='?_a=form&_u=index.invite&f_uid=<?php echo $form['uid'];?>'">
                <span></span>
                <img src="/app/form/view/appointment/static/images/index_word_3.png" class="index_word_3">
                <!-- <p>荐者有礼—推荐朋友</p>
                <p>买学车礼包赚现金</p> -->
            </div>
        </div>
        <input type="hidden" id="from_su_uid" value="">
        
    </article>
    <footer id="form-footer">
        <div>
            <img src="/app/form/view/appointment/static/images/footer-bg.png">
        </div>
    </footer>
    <div class="money_wrap">
        <div>
            <img src="/app/form/view/appointment/static/images/money_1.png">
            <img src="/app/form/view/appointment/static/images/money_2.png">
            <img src="/app/form/view/appointment/static/images/money_1.png">
            <img src="/app/form/view/appointment/static/images/money_2.png">
            <img src="/app/form/view/appointment/static/images/money_1.png">
            <img src="/app/form/view/appointment/static/images/money_2.png">
            <img src="/app/form/view/appointment/static/images/money_1.png">
            <img src="/app/form/view/appointment/static/images/money_2.png">
        </div>
    </div>
    <audio style="display:none;opacity:0" hidden="hidden" id="newyear" loop="loop" preload="metadata" controls src="/app/form/view/appointment/static/images/newyear.mp3">
    </audio>
</div>
<?php include $tpl_path.'/footer.tpl'; ?>
<script src="/static/js/jquery2.1.min.js"></script>
<script src="/static/js/jquery.cookie.js"></script>

<script type="text/javascript">
    function getUrlParam(name){
        var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
        var r = window.location.search.substr(1).match(reg);  //匹配目标参数
        if (r!=null) return unescape(r[2]); return null; //返回参数值
    } 

    var from_su_uid = getUrlParam('__from_su_uid');

    $.cookie('from_su_uid', from_su_uid, { expires: 7, path: '/' });

</script>

<script type="text/javascript">
    $(document).ready(function(){
        $('.loading').attr('style','display:none');
    });
    var $newyear = document.getElementById("newyear");
    $newyear.play();
</script>

<script type="text/javascript">
    define = null;
    require = null;
</script>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js" type="text/javascript">
</script>

<script>
    <?php
        echo 'var wx_cfg = '.json_encode(WeixinMod::get_jsapi_params()).';'; 
    ?>
    var su_uid = <?php echo(!empty($su['uid'])? json_encode($su['uid']):"null")?>;
    var fuid = <?php echo(!empty($form['uid'])? json_encode($form['uid']):"null")?>;

    if(wx_cfg) {
        wx_cfg['debug'] = false;
        wx_cfg['jsApiList'] = ['onMenuShareTimeline','onMenuShareAppMessage'];
        wx.config(wx_cfg);
        
        
        wx.ready(function(){
            wx.onMenuShareTimeline({
                title: "50元学车干不干？！", // 分享标题
                desc: "用力戳进来，抢巨额学车现金抵用券", // 分享描述
                link: window.location.origin+"/?_a=form&__from_su_uid="+su_uid+"&f_uid="+fuid, // 分享链接
                imgUrl: "http://weixin.uctoo.com/app/form/view/appointment/static/images/cover.png", // 分享图标
                success: function () {
                        // alert("分享成功！");
                        
                    
                    // 用户确认分享后执行的回调函数
                },
                cancel: function () { 
                    // 用户取消分享后执行的回调函数
                }
            });

            wx.onMenuShareAppMessage({
                title: "50元学车干不干？！", // 分享标题
                desc: "用力戳进来，抢巨额学车现金抵用券", // 分享描述
                link: window.location.origin+"/?_a=form&__from_su_uid="+su_uid+"&f_uid="+fuid, // 分享链接
                imgUrl: "http://weixin.uctoo.com/app/form/view/appointment/static/images/cover.png", // 分享图标
                success: function () {
                    // 用户确认分享后执行的回调函数
                },
                cancel: function () { 
                    // 用户取消分享后执行的回调函数
                }
            });
        });
    }

</script>