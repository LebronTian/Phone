<?php include $tpl_path.'/header.tpl'; ?>
<link rel="stylesheet" href="<?php echo $static_path;?>/css/form.css">
<div id="form-bar-1">
    <header id="form-header">
        <div>
            <img src="<?php echo $static_path;?>/images/header-bg.png">
            <div class="left"></div>
            <div class="right"></div>
        </div>
    </header>
    <style>
        

    </style>
    <div class="loading">
        <img src="<?php echo $static_path;?>/images/loading_bg.png" class="loading_bg">
        <p>页面加载中...<p>
    </div>
    <article id="home-bar">
        <div>
            <div>
                <span></span>
				<img class="clogo" src="<?php echo $reward['img'];?>">
				<div class="ctitle"><?php echo $reward['title'];?></div>
            </div>
        </div>

        <div id="id_open">
            <div>
                <span></span>
				<div class="cchai" style="position:relative;text-align:center;">
                <img src="<?php echo $static_path;?>/images/attention-fl.png" class="index_word_2">
				<span style="position:absolute;left:48%;top:2.6em;color:white;font-weight:bold;">拆</span>
				</div>
            </div>
        </div>

		<div>
			<div style="text-align:left;margin:15px;">
			<p class="cinfo" style="display:none;">
			活动时间： <?php echo date('Y-m-d H:i', $reward['access_rule']['start_time']).' - '.date('Y-m-d H:i', $reward['access_rule']['end_time']);?>
			</p>
			<div class="cinfo">
			活动说明： <?php echo $reward['brief'];?>
			</div>
			</div>
		</div>
    </article>
    <footer id="form-footer">
        <div>
			<a href="http://weixin.uctphp.com">© 深圳市快马加鞭科技有限公司 - 技术支持</a>
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
    <audio style="display:none;opacity:0" hidden="hidden" id="newyear" loop="loop" preload="metadata" controls src="<?php echo $static_path;?>/images/newyear.mp3">
    </audio>
</div>
<script src="/static/js/jquery2.1.min.js"></script>

<script type="text/javascript">
    function getUrlParam(name){
        var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
        var r = window.location.search.substr(1).match(reg);  //匹配目标参数
        if (r!=null) return unescape(r[2]); return null; //返回参数值
    } 

</script>

<script type="text/javascript">
    $(document).ready(function(){
        $('.loading').attr('style','display:none');
    });
    var $newyear = document.getElementById("newyear");
    $newyear.play();

//iphone上播放音乐
document.addEventListener("WeixinJSBridgeReady", function () {  
	document.getElementById("newyear").play(); 
}, false);  

</script>

<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js" type="text/javascript">
</script>

<script>
    <?php
        echo 'var wx_cfg = '.json_encode(WeixinMod::get_jsapi_params()).';'; 
    ?>
    var su_uid = <?php echo(!empty($su['uid'])? json_encode($su['uid']):"null")?>;
    var ruid = <?php echo(!empty($reward['uid'])? json_encode($reward['uid']):"null")?>;

    if(wx_cfg) {
        wx_cfg['debug'] = false;
        wx_cfg['jsApiList'] = ['onMenuShareTimeline','onMenuShareAppMessage'];
        wx.config(wx_cfg);
    }

$('#id_open').click(function(){
	//alert('开！');
	return alert('本次红包活动已结束，感谢大家的支持，请大家锁定关注汇华公司公众号，更多精彩敬请期待。');
<?php
	if(empty($has_subscribed_3rd)) {
		echo ' return alert("仅限公众号粉丝才能参加活动！");';
	}
?>
	if(!su_uid) {
		window.location.href = '?_a=web&_u=index.goto_url&must_login=1&url='+
								encodeURIComponent(window.location.href+'&auto=1');
		return;
	}

	$.get('?_a=reward&_u=ajax.doreward&r_uid='+ruid, function(ret){
		console.log(ret);
		ret = $.parseJSON(ret);
		if(ret.errstr == 'ERROR_OK') {
			//刷新一下页面
			if(!ret.data || !ret.data.length) {
				//alert('红包已经抢光啦！');
				window.location.reload();
			} else {
				window.location.reload();
			}
		}
		else if(ret.errstr == 'ERROR_OUT_OF_LIMIT') {
			alert('已超出抽奖次数限制！');
		}
		else if(ret.errstr == 'ERROR_SERVICE_NOT_AVAILABLE') {
			alert('当前不在活动时间范围！');
		}
		else {
			alert('操作未成功！' + ret.errstr);
		}
	});
});
<?php 
	if(!empty($_GET['auto'])) {
		echo '$("#id_open").click();';
	}
?>
</script>
