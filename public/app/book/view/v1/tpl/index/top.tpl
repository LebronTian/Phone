<!DOCTYPE html>
<html>
<head>
<meta http-equiv=Content-Type content="text/html;charset=utf-8">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="format-detection" content="telephone=no">
<script>
window.scale=1;
if (window.devicePixelRatio === 2 && window.navigator.appVersion.match(/iphone/gi)) {
    //scale = 0.5;
}
var text = '<meta name="viewport" content="initial-scale=' + scale + ', maximum-scale=' + scale +', minimum-scale=' + scale + ', user-scalable=no" />';
document.write(text);
</script>
<title><?php echo $fullname.'-';?>排行榜</title>
<link rel="stylesheet" href="/static/css/weui0.42.css" />
<link href="/static/css/font-awesome-4.6.3/css/font-awesome.min.css" rel="stylesheet">
<body>
<div style="max-width:640px;margin:0 auto; text-align:center;">
<img style="width:104px;height:104px;border-radius:52px;margin-bottom:10px;margin-top:20px;" 
src="<?php echo $su['avatar'] ? $su['avatar'] : '/static/images/null_avatar.png'; ?>">
<h2 style=""><?php echo $su['name'] ? $su['name'] : $su['account']; ?></h2>
<div class="weui_grids">
<a class="weui_grid" style="color:black;" href="?_easy=su.common.index.point"><?php echo $pt_name?>:<span style="color: #3cc51f;font-weight:bold;font-size:22px;">
<?php echo $pt['point_max'];?></span></a>
<a class="weui_grid">排名: <span style="color: #3cc51f;font-weight:bold;font-size:22px;"><?php echo $rank;?></span></a>
<a class="weui_grid" style="color:black;" href="?_easy=qrposter.v2.index.follower">粉丝: <span style="color: #3cc51f;font-weight:bold;font-size:22px;">
<?php echo $fans_cnt;?></span></a>
</div>
<div class="weui_panel weui_panel_access" style="margin-bottom:80px;">
<div class="weui_panel_hd" style="color: #3cc51f"><?php echo $pt_name?>排行榜</div>
<div class="weui_panel_bd">
<?php 
	if(empty($top20['list'])) {
		echo '暂无数据。。。';
	}
	else {
	$html = '';
		foreach($top20['list'] as $k => $v) {
		$html .= '
			<a href="javascript:;" class="weui_media_box weui_media_appmsg">
                <div class="weui_media_hd">
					第<span style="color: #3cc51f;font-weight:bold;font-size:17px;"> '.($k+1).' </span>名
                </div>
                <div class="weui_media_hd">
                    <img class="weui_media_appmsg_thumb" src="'.($v['su']['avatar'] ? $v['su']['avatar'] : 
						'/static/images/null_avatar.png').'">
                </div>
                <div class="weui_media_bd">
                    <h4 class="weui_media_title">'.($v['su']['name'] ? $v['su']['name'] : $v['su']['account']).'</h4>
                    <p class="weui_media_desc">总'.$pt_name.': '.$v['point_max'].'</p>
                </div>
            </a>';
		}
	echo $html;
	}
?>
</div>
</div>
</div>

<div class="weui_tabbar" style="position:fixed">
        <a href="?_a=qrposter&_u=index.index" class="weui_tabbar_item">
            <p class="weui_tabbar_label"><span class="fa fa-home fa-2x"></span><br>全部</p>
        </a>
        <a href="?_a=qrposter&_u=index.user" class="weui_tabbar_item">
            <p class="weui_tabbar_label"><span class="fa fa-user fa-2x"></span><br>个人中心</p>
        </a>
        <a href="javascript:;" class="weui_tabbar_item weui_bar_item_on">
            <p class="weui_tabbar_label"><span class="fa fa-trophy fa-2x"></span><br>排行</p>
        </a>
        <a href="<?php echo !empty($link_url) ? $link_url : 'javascript:;';?>" class="weui_tabbar_item">
            <p class="weui_tabbar_label"><span class="fa fa-link fa-2x"></span><br>关于</p>
        </a>
</div>
</body>

</html>
