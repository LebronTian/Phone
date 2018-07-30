<?php
	$option  = array(
		'f_uid' => $form['uid'],
		'key' => '"'.$su['uid'].'"',
		'page' => 0,
		'limit' => -1,
	);
	uct_use_app('su');
	$records = FormMod::get_form_record_list($option);

	//取用户名称手机
	//$p = SuMod::get_su_profile($uid);
	//$a = AccountMod::get_service_user_by_uid($uid);
?>


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
    <article id="userlist-bar" class="box-sizing">
        <h2>即将到账（<span><?php echo count($records['list']) * 80;?>元</span>）</h2>
        <ul id="user-list-cont">
		<?php
			if($records['list'])
			foreach($records['list'] as $c) {
				$p = SuMod::get_su_profile($c['su_uid']);
				$a = AccountMod::get_service_user_by_uid($c['su_uid']);
			echo '
            <li>
                <div class="left"><img src="'.$a['avatar'].'"></div>
                <div class="middle">
                    <p>'.$p['realname'].'</p>
                    <p></p>
                </div>
                <div class="right">80元</div>
            </li>';
			}
		?>
        </ul>
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