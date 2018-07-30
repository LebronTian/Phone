<?php include $tpl_path.'/header.tpl'; ?>
<link rel="stylesheet" href="/app/form/view/appointment/static/css/form.css">
<div id="form-bar-1">
    <header id="form-header">
        <div>
            <img src="/app/form/view/appointment/static/images/header-bg-1.png" alt="">
            <div class="left"></div>
            <div class="right"></div>
        </div>
    </header>
     <!-- <?php var_dump($form) ?> -->
    <!-- <?php var_dump($su) ?> -->
    <article id="invite-bar" class="box-sizing">
        <div><img src="/app/form/view/appointment/static/images/invite-monkey.png" class="invite_monkey"></div>
        <div>
            <p>分享给朋友，当朋友购买50元礼包时</p>
            <p>您可以获得80元，当朋友成功报名后</p>
            <p>80元即可到帐，可累计哦！</p>
        </div>
        <div>
            <button type="button" id="invite_btn"></button>
        </div>
        <!-- <div>
            <p class="or">或</p>
        </div>
        <div>
            <h3>分享链接</h3>
            <div class="share">
                <input type="text" value="您的专属推荐号：<?php echo $su['uid']?>">
                <a href="?_a=form&__from_su_uid=<?php echo $su['uid']?>&f_uid=<?php echo $form['uid'];?>"></a>
            </div>
        </div> -->
        <div>
            <a href="?_a=form&_u=index.userlist&f_uid=30">查看过去邀请</a>
        </div>
    </article>
    <div class="share_to_off" id="share_to_off">
    </div>
    <footer id="form-footer-2">
        <div>
            <img src="/app/form/view/appointment/static/images/footer-bg-1.png" alt="">
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

    $('#invite_btn').click(function(){
        $('#share_to_off').show();
    });
    $('#share_to_off').click(function(){
        $(this).hide();
    });

</script>