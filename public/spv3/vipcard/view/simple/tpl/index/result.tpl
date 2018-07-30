<?php
$su_uid = requestInt('su_uid');//需要显示的会员卡的su_uid
if($su_uid)
{
	$su = AccountMod::get_service_user_by_uid($su_uid);
	$sp_uid = $su['sp_uid'];
	$_REQUEST['_sp_uid'] = $sp_uid;
}

$sp_uid = $vip_card_sp_set['sp_uid'];

$vip_card_info = VipcardMod::get_vip_card_info($su_uid,$sp_uid);//取会员卡资料
$ret=WeixinMod::get_current_weixin_public();
if($ret['has_verified'] && $ret['public_type']==2 )
{
	$exit=true;
}
else
{
	$exit=false;
}

uct_use_app('su');
$user_uid = SuMod::require_su_uid($exit);//当前这个人的su_uid
$status = ($su_uid==$user_uid)?"me":"other";//判断是不是自己
// var_dump($user_uid,$status);

?>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-COMPATIBLE" content="chrome=1,IE=Edge">
	<!--优先谷歌内核，最新ie-->
	<meta name="format-detection" content="telephone=no,email=no,address=no">
	<!--不识别电话邮箱地址-->
	<meta http-equiv="Cache-Control" content="no-siteapp">
	<!--不转码-->
	<!-- Mobile Devices Support @begin 使手机上比例正常-->
	<meta name="viewport"
	      content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
	<!--文档宽度与设备宽度1：1 不允许缩放 -->
	<!-- apple devices -->
	<meta name="apple-mobile-web-app-capable" content="yes"/>
	<!-- wabapp程序支持 -->
	<meta name="apple-mobile-web-app-status-bar-style" content="white"/>
	<!-- 顶端状态条 -->
	<meta name="apple-touch-fullscreen" content="yes">
	<!--全屏显示 -->
	<!-- Mobile Devices Support @end -->
	<title>GirlsGroup-你的会员卡</title>
	<link rel="shortcut icon" href="<?php echo $static_path . '/images/logo.png' ?>" type="image/x-icon">
	<link rel="stylesheet" href="<?php echo $static_path . '/css/style.css' ?>">
	<link rel="stylesheet" href="<?php echo $static_path . '/css/index.css' ?>">
	<!--<style>body{background-image: url("<?php /*echo  $static_path.'/images/bg.png'*/?>");}</style>-->
	<style>body{background:#efefef;}</style>
</head>
<body>
<!--todo--------------------------------------------------------------------------start-->
<!--生成页-start-->
<div class="card-content div-content">
	<div class="final-user-pic">
		<img class="card-user-pic" src="<?php echo(!empty($vip_card_info['vip_card_su']['card_url'])? $vip_card_info['vip_card_su']['card_url']:"") ?>">
	</div>

	<div class="form-box">
		<?php
		$html = '';
		if (!empty($vip_card_sp_set['connent']))
		{
			$i = 0;
			foreach ($vip_card_sp_set['connent'] as $ck => $c)
			{
				if (!empty($c['protect']))
				{
					$i++;
					continue;
				}
				if ($ck == 'avatar')
				{
					$value = (empty($vip_card_info['vip_card_su']['connent'][$i]['value']) ? '' : $vip_card_info['vip_card_su']['connent'][$i]['value']);

					$html .= '<section style="border-bottom: none"> <span class="form-title" style="display:none;" ><span>' .
							$c['title'] . '</span></span><input class="form-input special-input-' .
							$ck . '" data-type="' . $ck . '" data-need="' . $c['need'] . '" data-group="' . $c['group'] . '"
                        type="hidden" value="' .
							//					(empty($c['value']) ?$value : $c['value']) .
							'"/></section>';
					//				$avatar = $value;
				}
				else
				{
					$value = (empty($vip_card_info['vip_card_su']['connent'][$i]['value']) ? '' : $vip_card_info['vip_card_su']['connent'][$i]['value']);

					$html .= '
                <section>
                <span class="form-title"><span>' . $c['title'] . '</span></span>
				<input class="form-input border-box" readonly data-type="' . $ck . '" data-need="' . $c['need'] . '" data-group="' . $c['group'] . '"
		        type="text" value="' .
												(empty($c['value']) ? $value : $c['value']) .
							'" placeholder="'.(empty($c['placeholder'])?'':$c['placeholder']).'" />
		        </section>';
				}
				$i++;
			}
		}
		echo $html;

		?>
	</div>

	<!--<p style="margin-top: 1em" class="index-vipcard-describe">我们会定时推送女行信息给您</p>
	<p class="index-vipcard-describe">分享与您女行的快乐</p>-->

	<p>
		<button class="show-mask simple-bottom-btn">分享给好友</button>
	</p>
</div>
<div class="share_mask" style="display: none;"></div>
<!--生成页-end-->
<!--todo----------------------------------------------------------------------------end-->
<script>
	var vip_card_sp_set = <?php echo(!empty($vip_card_sp_set)? json_encode($vip_card_sp_set):"null")?>;//vipcard的设置
	var vip_card_info = <?php echo(!empty($vip_card_info)? json_encode($vip_card_info):"null")?>;      //用户的信息
	var su_uid = <?php echo(!empty($su_uid)? json_encode($su_uid):"null")?>;      //用户的信息
	console.log(vip_card_sp_set, vip_card_info)
</script>
<script src="/static/js/jquery2.1.min.js"></script>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script>
	var window_height = $(window).height();
    $("body").css("min-height", window_height);
    /***************************************************/
	var share_title = "GirlsGroup-我的会员卡";// 分享标题
	var share_link = "<?php  uct_use_app('domain');echo DomainMod::get_app_url('vipcard');?>"; // 分享链接
	var img_url = "<?php echo getUrlName();?>/app/game/view/moon/static/images/moon_share.png";
	var wx_cfg =<?php echo json_encode(WeixinMod::get_jsapi_params());?>;

	if (wx_cfg) {
		wx_cfg['debug'] = false;
		wx_cfg['jsApiList'] = ['onMenuShareTimeline', 'onMenuShareAppMessage', 'showOptionMenu'];
		wx.config(wx_cfg);
		wx.ready(function () {
			wx.showOptionMenu();
			wx.onMenuShareTimeline({
				title: share_title, // 分享标题
				link: "<?php  uct_use_app('domain');echo DomainMod::get_app_url('vipcard');?>&su_uid="+su_uid, // 分享链接
				//imgUrl: img_url
				success: function () {
				},
				cancel: function () {
				// 用户取消分享后执行的回调函数
					alert('hehe')
				}
			});
			wx.onMenuShareAppMessage({
				title: share_title, // 分享标题
				// desc: '',// 分享描述
				link: "<?php  uct_use_app('domain');echo DomainMod::get_app_url('vipcard');?>&su_uid="+su_uid, // 分享链接
				//imgUrl: img_url
				type: '', // 分享类型,music、video或link，不填默认为link
				success: function () {
				},
				cancel: function () {
				// 用户取消分享后执行的回调函数
				}
			});
		});
	}
	$('.show-mask').click(function () {
		$('.share_mask').show()
	});
	$('.share_mask').click(function () {
		$('.share_mask').hide()
	})

</script>
</body>
</html>