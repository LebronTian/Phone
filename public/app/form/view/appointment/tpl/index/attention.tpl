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
    <article id="attention-bar" style="margin-top:-20rem !important;">
        <p>请添加<span>lili-xueyuan，</span></p>
        <p>由咱们小喱喱拉您入群</p>
        <p>这里可能是有史以来<i></i>最多的群</p>
        <p><img src="/app/form/view/appointment/static/images/att-1.png" style="width: 17rem;vertical-align: middle;padding-right: 1rem;">别再犹豫喽！</p>
        <p><img src="/app/form/view/appointment/static/images/att-2.png" style="display:inline-block;width: 12rem;padding-right: 1rem;vertical-align: middle;"><i style="vertical-align: middle;"></i></p>
		<p style="text-align:center;"><img style="width: 120px; height:120px; "
			 src="?_a=upload&_u=index.out&uidm=5408e56e"></p>
    </article>
    <footer id="form-footer">
        <div>
            <img src="/app/form/view/appointment/static/images/footer-bg.png" alt="">
        </div>
    </footer>
</div>
<?php include $tpl_path.'/footer.tpl'; ?>

<script>
    //'jquery' or 'zepto' 脚本入口,按情况选择加载
    seajs.use('jquery', function () {
        $(document).ready(function () {
            
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
