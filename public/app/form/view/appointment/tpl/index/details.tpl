<?php include $tpl_path.'/header.tpl'; ?>
<link rel="stylesheet" href="/app/form/view/appointment/static/css/form.css">
<style type="text/css">
    #form-bar-1>#form-header>div>div{ width: 36px; height: 158px; background: url(/app/form/view/appointment/static/images/boom.png) no-repeat;background-size: 100% 100%;-webkit-background-size: 100% 100%;}
</style>
<!-- <?php var_dump($su) ?> -->
<div id="form-bar-1">
    <header id="form-header">
        <div>
            <img src="/app/form/view/appointment/static/images/header-bg-1.png">
            <div class="left"></div>
            <div class="right"></div>
        </div>
    </header>
    <article id="details-bar">
        <div>
            <h2>
                <span></span>
                <img src="/app/form/view/appointment/static/images/detail-word-1.png" style="width: 19rem;height: auto;">
            </h2>
            <!-- <h2><span></span>春节不打烊，学车送礼包</h2> -->
            <p>活动时间：2月4日~2月29日</p>
        </div>
        <div>
            <h2>
                <span></span>
                <img src="/app/form/view/appointment/static/images/detail-word-2.png" style="width: 18.7rem;height: auto;">
            </h2>
            <p>报名即返200元现金；</p>
            <p>科目二、三基础训练课程抵用券，价值320元；</p>
            <p>科目二、三考场模拟抵用券，价值120元；</p>
            <p>免费1小时证后陪驾课程，价值200元</p>
        </div>
        <div>
            <h2>
                <span></span>
                <img src="/app/form/view/appointment/static/images/detail-word-3.png" style="width: 6.8rem;height: auto;">
            </h2>
            <p>1、50元即可购买千元学车优惠礼包；</p>
            <p>2、购买成功后添加lili-xueyuan微信客服，<br/>进入喱米团子学车群；</p>
            <p>3、后续在喱喱学车APP上完成剩余报名环节，<br/>即可在个人中心查看得到所购买的优惠礼包。</p>
<!--             <p>当朋友成功报名后80元即在喱喱学车学员端个人钱包中</p>
            <p>到帐，可提现，推荐可累计。</p> -->
        </div>
        <div class="go-to-btn">
            <div>
                <a href="?_a=form&_u=index.code&f_uid=<?php echo $form['uid'];?>" class="go_to_code">
                    <img src="/app/form/view/appointment/static/images/detail-word-4.png" style="width: 10.3rem;height: auto;margin-top: 0.5rem;">
                </a>
                <h1>
                    <img src="/app/form/view/appointment/static/images/detail-word-5.png" style="width: 8.65rem;height: auto;margin-top: 0.5rem;">
                </h1>
                <a href="?_a=form&_u=index.forms&f_uid=<?php echo $form['uid'];?>"><span class="monkey-change"></span></a>
            </div>
        </div>
    </article>
    
    <footer id="form-footer-2">
        <div>
            <img src="/app/form/view/appointment/static/images/footer-bg-1.png">
        </div>
    </footer>
</div>
<?php include $tpl_path.'/footer.tpl'; ?>

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


