<?php include $tpl_path.'/header.tpl'; ?>
<link rel="stylesheet" href="/static/css/amazeui2.1.min.css">
<link rel="stylesheet" href="/app/form/view/appointment/static/css/form.css">
<div id="form-bar-1">
    <header id="form-header">
        <div>
            <img src="/app/form/view/appointment/static/images/header-bg-1.png" alt="">
            <div class="left"></div>
            <div class="right"></div>
        </div>
    </header>
    <article id="success-bar" class="box-sizing">
        <div>
            <h1><img src="/app/form/view/appointment/static/images/pay-ok.png" class="pay-ok"></h1>
            <p class="ok">
                <img src="/app/form/view/appointment/static/images/success-title.png" style="width: 9.5rem;">
            </p>
        </div>
        <!-- <div class="pointer_box">
            <img src="/app/form/view/appointment/static/images/pointer_yellow.png" class="success_pointer">
        </div> -->
        <div>
            <a href="?_a=form&_u=index.attention&f_uid=<?php echo $form['uid'];?>'">
                <img src="/app/form/view/appointment/static/images/success-word-1.png" style="width: 17.5rem;">
            </a>
            <img src="/app/form/view/appointment/static/images/pointer_yellow.png" class="success_pointer_new">
        </div>
        <div>
            <a href="?_a=form&_u=index.invite&f_uid=<?php echo $form['uid'];?>'">
                <img src="/app/form/view/appointment/static/images/success-word-2.png" style="width: 17.5rem;">
            </a>
        </div>
        <div>
            <a href="#" id="download-btn">
                <img src="/app/form/view/appointment/static/images/success-word-3.png" style="width: 15.6rem;">
            </a>
        </div>
    </article>
    <!-- <div class="am-modal am-modal-no-btn" tabindex="1" id="doc-modal-1">
      <div class="am-modal-dialog">
        <div class="am-modal-hd">
          <a href="javascript: void(0)" class="am-close am-close-spin" data-am-modal-close>&times;</a>
        </div>
        <div class="am-modal-bd">
            <p>Android学员端下载链接 
                <a href="http://download.lilixc.com/driver/android/stu">http://download.lilixc.com/driver/android/stu</a></p>
            <p>iOS学员端下载链接
                <a href="http://download.lilixc.com/driver/ios/stu">http://download.lilixc.com/driver/ios/stu</a></p>
            <p>由于目前iOS版本使用的是企业版证书，iOS9以下系统版本直接使用，iOS9以上系统版本下载完成后在 通用－>描述文件（与设备管理）－>企业级应用点击，选择信任，就可以使用了。</p>
        </div>
      </div>
    </div> -->
    <div class="link_box">
        <div class="link_content">
            <p>Android学员端下载链接 
                <a href="http://download.lilixc.com/driver/android/stu">http://download.lilixc.com/driver/android/stu</a></p>
            <p>iOS学员端下载链接
                <a href="http://download.lilixc.com/driver/ios/stu">http://download.lilixc.com/driver/ios/stu</a></p>
            <p>由于目前iOS版本使用的是企业版证书，iOS9以下系统版本直接使用，iOS9以上系统版本下载完成后在 通用－>描述文件（与设备管理）－>企业级应用点击，选择信任，就可以使用了。</p>
            <img src="/app/form/view/appointment/static/images/off.png" id="off_img">
        </div>
    </div>
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
    <footer id="form-footer-2">
        <div>
            <img src="/app/form/view/appointment/static/images/footer-bg-1.png" alt="">
        </div>
    </footer>

    

</div>
<?php include $tpl_path.'/footer.tpl'; ?>
<script type="text/javascript" src="/static/js/jquery2.1.min.js"></script>
<script type="text/javascript" src="/static/js/amazeui2.1.min.js"></script>
<script>
    $('#download-btn').on('click', function(e){
        // e.preventDefault();
        $('.link_box').show();
        // $('#doc-modal-1').modal('open');
    });
    $('#off_img').on('click', function(e){
        $('.link_box').hide();
    });
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