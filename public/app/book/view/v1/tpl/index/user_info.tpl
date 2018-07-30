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
    <title><?php echo $fullname.'-';?>个人中心</title>
    <link rel="stylesheet" href="/static/css/weui0.42.css" />
    <link href="/static/css/font-awesome-4.6.3/css/font-awesome.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<?php echo $static_path;?>/css/index.css" />

    <style>
        i{
            color:#616161;
        }
        .weui_navbar{
            top: 240px;
            position:static;
        }
        .my_ft{
            transform: rotate(180deg);
        }
         .t_head, .t_body{
                overflow:hidden;
                width:100%;

        }
        .card_list .t_head>div{
                color:#ddd;
                float:left;
                width:24%;
                height:3em;
                border-left:1px solid #eee;
                margin:0.2em auto;
                background-color:rgba(4, 136, 0, 0.7);
                line-height:3em;
                font-size:0.9em;
               text-align: center;
            overflow:hidden;
            text-overflow: ellipsis;
        }
       .card_list .t_body>div{
                float:left;
                width:24%;
                height:2em;
                background-color:rgba(216,189,162,0.7);
                border-left:1px solid #eee;
                margin:0.2em auto;
                font-size:0.8em;
                text-align:center;
                line-height:2em;
                 overflow:hidden;
                text-overflow: ellipsis;
        }


         .purchase_history .t_head>div{
            color:#ddd;
            float:left;
            width:30%;
            height:3em;
            border-left:1px solid #eee;
            margin:0.2em auto;
            background-color:rgba(4, 136, 0, 0.7);
            line-height:3em;
            font-weight:bold;
            font-size:0.9em;
            text-align: center;
             overflow:hidden;
             text-overflow: ellipsis;
        }
        .pur_pname{
            width:39% !important;
        }
       .purchase_history  .t_body>div{
            float:left;
            width:30%;
            height:2em;
            background-color:rgba(216,189,162,0.7);
            border-left:1px solid #eee;
            margin:0.2em auto;
            font-size:0.8em;
            text-align:center;
            line-height:2em;
            overflow:hidden;
            text-overflow: ellipsis;
        }


        .liaochengka_box{
            overflow:hidden;
            width:100%;
            margin:0.3em 0;


        }
        .liaochengka_xiangmu{
            width:54%;
            float:left;
            background-color:rgba(4, 136, 0, 0.7);
            height:4.5em;
            line-height:4.5em;
            border-right:2px solid #eee;
            font-weight:bold;
            text-align:center;
            color: #ddd;
        }
        .liaochengka_xinxi{
            width:45%;
            float:left;
            background-color:rgba(216,189,162,0.7);
            height:4.5em;

        }
        .liaochengka_xinxi>div{
            border-bottom:1px solid #eee;
            line-height:1.5em;
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
        <span class="banner_bg"><img src="<?php echo $static_path;?>/image/banner2.jpg" class="banner_pic" id="js_banner"></span>
        <div class="pic_mask"></div><div class="shop_modele_mask"><span class="vm_box"></span>
            <a href="javascript:;"class="icon18_common edit_gray js_edit"></a>
        </div>
    </div>


    <div class="bd" style="margin-bottom: 80px;">
        <div class="weui_cells weui_cells_access">
            <a class="weui_cell" href="?_easy=qrposter.single.index.user">
                <div class="weui_cell_ft my_ft">
                </div>
                <div class="weui_cell_bd weui_cell_primary">
                    <p> <?php echo !empty($a_user['gno'])?(' 会员编号：'.$a_user['gno']):'';?><p>
                </div>
            </a>
        </div>
        <div class="weui_navbar">
            <div class="weui_navbar_item weui_bar_item_on" data-id="card_list">
                储值卡
            </div>
            <div class="weui_navbar_item" data-id="pro_list">
                疗程卡
            </div>
            <div class="weui_navbar_item" data-id="purchase_history">
                消费记录
            </div>
        </div>
        <div class="user_content">
            <div class="card_list" >
                <div class="t_head">
                    <div>卡种名称</div>
                    <div>状态</div>
                    <div>欠款(￥)</div>
                    <div>余额(￥)</div>
                </div>
                <?php
                $a= '
                

                <div class="t_body">
                    <div>%s </div>
                    <div>%s </i></div>
                    <div>%s </div>
                    <div>%s </div>
                </div>
                ';
                foreach ($card_list as $h)
                {
                    $h['status'] = ($h['status']=='正常')?($h['status'].'<i class="fa fa-check-circle" style="color:green;"></i>'):($h['status'].'<i class="fa fa-warning" style="color:red;"></i>');
                    printf($a,$h['vipname'],$h['status'],($h['qkye']<0?$h['qkye']:'0'),$h['balance']);
                }
                ?>

            </div>
            <div class="pro_list" style="display: none">

                <?php
                $a= '               
                <div class="liaochengka_box">
                    <div class="liaochengka_xiangmu">%s</div>
                    <div class="liaochengka_xinxi">
                        <div>状态：<span>%s</span></div>
                        <div>单价：<span>%s</span></div>
                        <div>余次：<span>%s</span></div>
                    </div>
                </div>
                    ';
                foreach($pro_list as $h)
                {
                    $h['status'] = ($h['status']=='正常')?($h['status'].'<i class="fa fa-check-circle" style="color:green;"></i>'):($h['status'].'<i class="fa fa-warning" style="color:red;"></i>');
                    printf($a,$h['PrjName'],$h['status'],$h['PrjPrice'],$h['PrjCount']);
                }
                    ?>
            </div>
            <div class="purchase_history" style="display: none">
                <h5>&nbsp;&nbsp;&nbsp;&nbsp;最近三个月的消费记录：</h5>
                <div class="t_head">
                    <div style="width:39%">项目名称</div>
                    <div>消费日期</div>
                    <div>金额(￥)</div>
                </div>
            <?php
                $a = '
                <div class="t_body">
                    <div class="pur_pname" >%s</div>
                    <div class="pur_date">%s</div>   
                    <div class="pur_fee">%s</div>
                </div>
                  ';
                    foreach ($purchase_history as $h)
                    {
                        printf($a,$h['pname'],$h['data'],$h['fee']);
                    }
                ?>
            </div>
        </div>

    </div>
</div>
<div class="weui_tabbar" style="position:fixed">
    <a href="?_a=qrposter&_u=index.index" class="weui_tabbar_item ">
        <p class="weui_tabbar_label"><span class="fa fa-home fa-2x"></span><br>全部</p>
    </a>
    <a href="javascript:;" class="weui_tabbar_item weui_bar_item_on">
        <p class="weui_tabbar_label"><span class="fa fa-user fa-2x"></span><br>个人中心</p>
    </a>
    <a href="?_a=aitaimei&_u=index.worker_top" class="weui_tabbar_item">
        <p class="weui_tabbar_label"><span class="fa fa-trophy fa-2x"></span><br>预约评价</p>
    </a>
    <a href="<?php echo !empty($link_url) ? $link_url : 'javascript:;';?>" class="weui_tabbar_item">
        <p class="weui_tabbar_label"><span class="fa fa-link fa-2x"></span><br>关于</p>
    </a>
</div>
<script src="/static/js/jquery2.1.min.js"></script>
<script src="/static/js/doT.min.js"></script>
<script>

    $('.weui_navbar').on('click', '.weui_navbar_item', function () {
        $(this).addClass('weui_bar_item_on').siblings('.weui_bar_item_on').removeClass('weui_bar_item_on');
        $('.card_list').hide();
        $('.pro_list').hide();
        $('.purchase_history').hide();
        $('.'+$(this).data('id')).show();

    });

</script>
</body>
</html>
