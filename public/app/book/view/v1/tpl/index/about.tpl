<?php
$sp_uid = AccountMod::require_sp_uid();
$phones = SpMod::get_sp_about_link($sp_uid);
if(checkString($phones, PATTERN_FULL_URL)) {
	redirectTo($phones);
}
?>

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
    <title><?php echo $fullname.'-';?>咨询</title>
    <link rel="stylesheet" href="/static/css/weui0.42.css" />
    <link href="/static/css/font-awesome-4.6.3/css/font-awesome.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<?php echo $static_path;?>/css/index.css" />

    <style>
        i{
            color:#616161;
        }
    </style>
</head>
<script>
    if(window.scale==0.5){document.write('<body class="zh_CN ratio2 ">');}
    else{document.write('<body class="zh_CN ">');}
</script>
<div class="wx_page">
    <div class="shop_module_item shop_module_banner js_shopModuleWrapper"data-moduletype="banner"name="banner">
        <strong class="shop_banner_title"id="js_title"><?php
            echo  $fullname;
            ?></strong>
        <span class="banner_bg"><img src="<?php echo $static_path;?>/image/banner2.jpg" class="banner_pic" id="js_banner"></span>
        <div class="pic_mask"></div><div class="shop_modele_mask"><span class="vm_box"></span>
            <a href="javascript:;"class="icon18_common edit_gray js_edit"></a>
        </div>
    </div>


    <div class="bd">
        <div class="weui_cells_title">联系我们</div>
        <div class="weui_cells weui_cells_access" style="margin-bottom:85px;">
<?php
if($phones) $phones = explode(';', $phones);
if(!$phones) {
echo '
<a class="weui_cell" href="javascript:;">
    <div class="weui_cell_bd weui_cell_primary">
        <p><i class="fa fa-phone" aria-hidden="true"></i> 暂未设置联系电话！</p>
    </div>
    <div class="weui_cell_ft">
    </div>
</a>';
}
else {
foreach($phones as $p) {
$p = trim($p);
if(!$p)continue;
$pp = checkString($p, '/([0-9\-\+]{3,16})/');
echo '
<a class="weui_cell" href="tel://'.$pp.'">
    <div class="weui_cell_bd weui_cell_primary">
        <p><i class="fa fa-phone" aria-hidden="true"></i> '.$p.'</p>
    </div>
    <div class="weui_cell_ft">
    </div>
</a>';
}
}
?>
        </div>
    </div>
</div>
<div class="weui_tabbar" style="position:fixed">
    <a href="?_a=qrposter&_u=index.index" class="weui_tabbar_item ">
        <p class="weui_tabbar_label"><span class="fa fa-home fa-2x"></span><br>全部</p>
    </a>
    <a href="?_a=qrposter&_u=index.user" class="weui_tabbar_item">
        <p class="weui_tabbar_label"><span class="fa fa-user fa-2x"></span><br>个人中心</p>
    </a>
    <a href="?_a=aitaimei&_u=index.worker_top" class="weui_tabbar_item">
        <p class="weui_tabbar_label"><span class="fa fa-trophy fa-2x"></span><br>预约评价</p>
    </a>
    <a href="<?php echo !empty($link_url) ? $link_url : 'javascript:;';?>" class="weui_tabbar_item weui_bar_item_on">
        <p class="weui_tabbar_label"><span class="fa fa-link fa-2x"></span><br>咨询</p>
    </a>
</div>
</body>
</html>
