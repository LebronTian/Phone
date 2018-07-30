
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script src="/app/shop/view/wap/static/js/sea.js"></script>
<script>
    seajs.config({
        charset: 'utf-8',
        paths:{
            'top_js':'/static/js/',
            'app_js':'<?php echo $static_path ?>/js'

        },
        alias: {
            'jquery':'top_js/jquery2.1.min.js',
            'jquery_cookie':'js/jquery.cookie.js',
            'zepto':'top_js/zepto.min.js',
            'zepto_cookie':'top_js/zepto.cookie.min.js',
            'plupload':'top_js/plupload.full.min.js',
            'doT':'top_js/doT.min.js'
        }
    });
    seajs.use('zepto', function () {
        $(document).ready(function () {
            $(".header-title").tap(function () {
                window.location.reload()
            });
        });
    });
    function showTip(type,str){
        alert(str)
    }

var wx_cfg = <?php echo json_encode(WeixinMod::get_jsapi_params()).';';?>
var wx_param = {'link' : window.location.origin + '?_easy=form.daikuan.index.formlist&from_su_uid=<?php echo $su['uid'].'&&__sp_uid='.AccountMod::require_sp_uid();?>'
				//,'title' : '易诚贷金融最佳融资方案提供商'
				//,'desc' : '易诚贷金融最佳融资方案提供商'
				,'imgUrl' : window.location.origin + '/app/form/view/daikuan/static/images/share.jpg'
				,'success' : function(){}
				,'cancel' : function(){}
}
if(wx_cfg && wx) {
		wx_cfg['debug'] = <?php echo !empty($_REQUEST['_d']) ? 'true' : 'false';?>;
		//wx_cfg['debug'] = true;
		wx_cfg['jsApiList'] = ['onMenuShareTimeline', 'onMenuShareAppMessage', 'showOptionMenu'];
		wx.config(wx_cfg);
		wx.ready(function () {
			wx.showOptionMenu();
			wx.onMenuShareTimeline(wx_param);
			wx.onMenuShareAppMessage(wx_param);
		});
}

</script>
<!--todo:************************************************************************************************************-->
