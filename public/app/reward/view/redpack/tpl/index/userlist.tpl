<link rel="stylesheet" href="<?php echo $static_path;?>/css/form.css">
<div id="form-bar-1" style="margin-bottom:7em;padding-bottom:7em;">
    <header id="form-header">
        <div>
            <img src="<?php echo $static_path;?>/images/header-bg-1.png" alt="">
            <div class="left"></div>
            <div class="right"></div>
        </div>
    </header>

    <article style="text-align:center;margin-top:2em;margin-bottom:3em;">
        <div>
            <div>
				<img style="width:4em;height:4em;border:1px solid gold;" src="<?php echo $reward['img'];?>">
				<div style="color:black;font-size:16px;margin-bottom:5px;"><?php echo $reward['title'];?></div>
				<div class="ctitle" style="font-size:32px;font-weight:bold;"><?php echo $me_record['item']['title'];?></div>
				<div style="color:#78489d;font-size:12px;margin-bottom:5px;">红包将自动发放到您的微信余额中，请注意查收</div>
            </div>
        </div>
	</article>

    <div id="userlist-bar2" style="margin:5px;margin-bottom:4em;">
		<div style="color:gray; border-bottom:1px solid gold;padding-bottom:3px;">
			已有 <?php echo $records['count'] ?> 人抢到红包, 共<?php 
$cnt = 0;foreach($items['list'] as $it) $cnt += $it['total_cnt'];
echo $cnt;
			?>个红包
		</div>
        <ul id="user-list-cont">
        </ul>
    </div>

    <footer id="form-footer">
        <div>
			<a href="http://weixin.uctphp.com">© 深圳市快马加鞭科技有限公司 - 技术支持</a>
            <img src="/app/form/view/appointment/static/images/footer-bg-1.png" alt="">
        </div>
    </footer>
</div>

<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js" type="text/javascript">
</script>
<script src="/static/js/jquery2.1.min.js"></script>
<script src="/static/js/doT.min.js"></script>
<script src="/static/js/scroll_load.js"></script>
<script src="/static/js/php/date.js"></script>
<script id="id_tpl" type="text/tpl">
<li>
	<div class="left"><img src="{{=it.user.avatar}}"></div>
	<div class="middle">
		<p style="margin-bottom:2px;">{{=it.user.name || it.user.account}}</p>
		<p>{{=(date('Y-m-d H:i:s', it.create_time))}}</p>
		</div>
		<div class="right">{{=it.item.title}}</div>
</li>
<div style="clear:both;"></div>
</script>
<script>
scroll_load({'ele_container': '#user-list-cont'
	,'ele_dot_tpl': '#id_tpl'
	,'url': '?_a=reward&_u=ajax.get_user_record_list&r_uid=<?php echo $reward['uid'];?>&all=1&no_remark=false'
});

    <?php
        echo 'var wx_cfg = '.json_encode(WeixinMod::get_jsapi_params()).';'; 
    ?>
    var su_uid = <?php echo(!empty($su['uid'])? json_encode($su['uid']):"null")?>;

    if(wx_cfg) {
        wx_cfg['debug'] = false;
        wx_cfg['jsApiList'] = ['onMenuShareTimeline','onMenuShareAppMessage'];
        wx.config(wx_cfg);
    }

</script>
