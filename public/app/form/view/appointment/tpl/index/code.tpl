<?php include $tpl_path.'/header.tpl'; ?>
<link rel="stylesheet" href="/app/form/view/appointment/static/css/form.css">
<div id="form-bar-1">
    <header id="form-header">
        <div>
            <img src="/app/form/view/appointment/static/images/header-bg-1.png" alt="">
            <div class="left"></div>
            <div class="right"></div>
            <div class="center">
                <div>
                    <img src="/app/form/view/appointment/static/images/qrcode.png" alt="二维码">
                </div>
            </div>
           <!--  <p class="center_p">喱喱学车</p> -->
        </div>
    </header>
    <article id="code-bar" class="box-sizing">
        <div>
            <img src="/app/form/view/appointment/static/images/code-word.png" style="display: block; width: 10.8rem;margin: 0 auto;">
            <!-- <p>关注喱喱学车</p>
            <p>了解喱喱学车</p> -->
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
    //'jquery' or 'zepto' 脚本入口,按情况选择加载
    seajs.use('jquery', function () {
        $(document).ready(function () {
            //seajs.use('app_js/index.js');
            
        })
    });
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