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
    <title>个人中心</title>
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
            echo  !empty($su_pro['realname'])?$su_pro['realname']:$su['name'];
            ?></strong>
        <span class="banner_logo"><img src="<?php echo $su['avatar'] ? $su['avatar'] : '/static/images/null_avatar.png'; ?>"alt=""id="js_logo"></span>
        <!--    <span class="banner_bg"><img src="--><?php //echo $static_path;?><!--/image/banner.jpg" class="banner_pic" id="js_banner"></span>-->
        <span class="banner_bg" style="position:fixed;left:0;right:0;margin:0 auto;transform:scale(22,12);
			top:-125px;width:50px;height:40px;background-color:#09BB07;border-radius:0 0 25px 25px;">
			<!--<img src="<?php echo $static_path;?>/image/banner2.jpg" class="banner_pic" id="js_banner">-->
		</span>
        <div class="shop_modele_mask"><span class="vm_box"></span>
            <a href="javascript:;"class="icon18_common edit_gray js_edit"></a>
        </div>
    </div>


    <div class="bd">
        <div class="weui_cells_title">您当前积分：<?php echo $point['point_remain'];?></div>
        <div class="weui_cells weui_cells_access">
            <a class="weui_cell" href="?_a=book&_u=index.point_orders">
                <div class="weui_cell_bd weui_cell_primary" style="color:gray;">
                    <p><i class="fa fa-clock-o" aria-hidden="true"></i> 预约记录</p>
                </div>
                <div class="weui_cell_ft">
                </div>
            </a>
            <a class="weui_cell" href="?_easy=su.common.index.point">
                <div class="weui_cell_bd weui_cell_primary" style="color:gray;">
                    <p><i class="fa fa-align-justify" aria-hidden="true"></i> 积分明细</p>
                </div>
                <div class="weui_cell_ft">
                </div>
            </a>
            <a class="weui_cell" href="?_a=qrposter">
                <div class="weui_cell_bd weui_cell_primary" style="color:gray;">
                    <p><i class="fa fa-shopping-bag" aria-hidden="true"></i> 积分商城</p>
                </div>
                <div class="weui_cell_ft">
                </div>
            </a>
            <a class="weui_cell" href="?_easy=store.single.index.usercoupons">
                <div class="weui_cell_bd weui_cell_primary" style="color:gray;">
                    <p><i class="fa fa-ticket" aria-hidden="true"></i> 门店卡券</p>
                </div>
                <div class="weui_cell_ft">
                </div>
            </a>
        </div>
    </div>
</div>
<?php include $tpl_path.'/footer.tpl';?>
</body>
</html>
