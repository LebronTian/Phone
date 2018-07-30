<?php include $tpl_path.'/header.tpl'; ?>
<link rel="stylesheet" href="/app/form/view/appointment/static/css/form.css">
<div id="form-bar-1">
    <header id="form-header">
        <div>
            <img src="/app/form/view/appointment/static/images/header-bg.png" alt="">
            <div class="left"></div>
            <div class="right"></div>
        </div>
    </header>
    <!-- <article class="form-article">
        <section id="id_form_content"></section>
        <button class="" id="id_commit">提交</button>
    </article> -->
    <!-- <?php var_dump($form) ?> -->
    <!-- <?php var_dump($su) ?> -->
    <article id="form-content" class="box-sizing">
        <h1><img src="/app/form/view/appointment/static/images/lmzml.png" style="width: 7rem;vertical-align: middle;"></h1>
        <div><input type="text" id="username-val" placeholder="姓名"></div>
        <div><input type="tel" id="teleplone-val" placeholder="手机号" data-uid="<?php echo $su['uid'];?>" data-f-uid="<?php echo $form['uid']?>"></div>
        <div>
            <input type="text" id="mobile-code-val" placeholder="验证码">
            <button id="get-mobile-code-btn">获取</button>
        </div>
        <div id="form-submit-btn" class="submit-btn" style="width: 16rem;">提交</div>
    </article>
    <footer id="form-footer">
        <div>
            <img src="/app/form/view/appointment/static/images/footer-bg.png">
            <div></div>
        </div>
    </footer>
</div>
<div id="form-bar-2" style="display:none;">
    <header id="form-header-2">
        <div>
            <img src="/app/form/view/appointment/static/images/header-bg-1.png" alt="">
            <div class="left"></div>
            <div class="right"></div>
        </div>
    </header>
    <article id="form-content-2" class="box-sizing">
        <div class="monkey-box"><img src="/app/form/view/appointment/static/images/monkey-1.png" class="detail-monkey"></div>
        <div class="text box-sizing">
            <h2><img src="/app/form/view/appointment/static/images/form-word-1.png" style="width: 25.7rem; "></h2>
            <ul>
                <li><span></span><p>报名即返200元现金</p></li>
                <li><span></span><p>科目二、三基础训练课程抵用券，价值320元</p></li>
                <li><span></span><p>科目二、三考场模拟抵用券，价值120元</p></li>
                <li><span></span><p>免费1小时证后陪驾课程，价值200元</p></li>
            </ul>
            <p>注：预售商品，不予退还</p>
            <p class="font-size-18">支付金额：<b>50</b>元</p>
           <!--  <button type="button" onclick="window.location.href='?_a=pay&oid=g30'" class="submit-btn" id="submit_order_btn">提交</button> -->
           <button type="button" class="submit-btn" id="submit_order_btn"></button>
        </div>
        
    </article>
    <footer id="form-footer-2">
        <div>
            <img src="/app/form/view/appointment/static/images/footer-bg-1.png" alt="">
        </div>
    </footer>
</div>
<?php include $tpl_path.'/footer.tpl'; ?>

<script>
    var g_form = <?php echo(!empty($form)? json_encode($form):"null")?>;
    var g_record = <?php echo(!empty($record)? json_encode($record):"null")?>;
    var g_record_order_uid = <?php echo(!empty($record['order']['r_uid'])? json_encode($record['order']['r_uid']):"null")?>;
    var g_record_order_time = <?php echo(!empty($record['order']['paid_time'])? json_encode($record['order']['paid_time']):"null")?>;
    //'jquery' or 'zepto' 脚本入口,按情况选择加载
    seajs.use('jquery', function () {
        $(document).ready(function () {
            seajs.use('app_js/index.js');
            seajs.use('app_js/form.js');
            $('#form-content').stop(true,true).animate({'height' : '33.8rem'}, 1000);
        })
    });
</script>


<script src="/static/js/jquery2.1.min.js"></script>
<script src="/static/js/jquery.cookie.js"></script>
<script type="text/javascript">

    var cookie = $.cookie('from_su_uid');
    if (cookie == null) {
        cookie = "0";
    }else{
        cookie = cookie;
    }


    var cookie_uid = $.cookie('__form_order_uid');


</script>

<script type="text/javascript">
    define = null;
    require = null;
</script>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js" type="text/javascript">
</script>
<script src="/static/js/jquery2.1.min.js"></script>

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
