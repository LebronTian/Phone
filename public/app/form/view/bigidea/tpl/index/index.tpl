<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-COMPATIBLE" content="IE=Edge,chrome=1">   <!--优先谷歌内核，最新ie-->
    <meta name="format-detection" content="telephone=no,email=no,address=no">     <!--不识别电话邮箱地址-->
    <meta http-equiv="Cache-Control" content="no-siteapp">    <!--不转码-->
    <!-- Mobile Devices Support @begin 使手机上比例正常-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <!--文档宽度与设备宽度1：1 不允许缩放 -->
    <!-- apple devices -->
    <meta name="apple-mobile-web-app-capable" content="yes"/> <!-- wabapp程序支持 -->
    <meta name="apple-mobile-web-app-status-bar-style" content="white"/><!-- 顶端状态条 -->
    <meta name="apple-touch-fullscreen" content="yes"><!--全屏显示 -->
    <!-- Mobile Devices Support @end -->
    <title>深圳麦当劳“巨无霸 Big.idea”创意大赛</title>

    <link rel="stylesheet" href="/app/su/view/bigidea/css/style.css">
    <style>
        #id_form_content{
            margin-bottom: 30px;
        }
        #id_form_content p{
            overflow: hidden;
            margin-bottom: 30px;
        }
        #file_img2{
            float: left;
            width: 30%;!important;
        }
        #file_img2-button{
            background: white;
            color: black;
            border: 0;
            border-radius: 0;
            box-shadow:0 0 6px rgba(0,0,0,1) inset ;
        }
        #SWFUpload_0{
            top: 0;
            left: 0;
            width: 100%;
        }
        .font-left{
            line-height: 27px;
        }
        .desc-font{
            height: 35px;
            text-align: left;
        }
        .close-pic{
            width: 50%;
            max-width: 10em;
            margin-top: 1em;
        }
    </style>
</head>
<body>
<header>
    <div class="header-background">
        <img src="/app/su/view/bigidea/images/header.png"/>
        <img id="header-logo" src="/app/su/view/bigidea/images/logo.png"/>
    </div>
    <!----------------------------------------------------------------------------------------------------------------------------------------------------------->
    <div class="header-top">
        <img class="header-font-title" src="/app/su/view/bigidea//images/font-title1.png"/>
        <img class="header-pic-title" src="/app/su/view/bigidea/images/title2.png"/>
    </div>
</header>

<?php
    uct_use_app('su');
    if($su_uid = AccountMod::has_su_login()) {
        uct_use_app('bigidea');
        if($bmu = BigideaMod::get_user_by_su_uid($su_uid)) {
            echo '';
        }
    }

    if(!$record && ($su_uid = AccountMod::has_su_login())) {
$record = Dba::readRowAssoc('select * from form_record where f_uid = '.$form['uid'].' && su_uid = '.$su_uid
, 'FormMod::func_get_form_record');
}


?>

<article class="body-content">
    <section>
        <span class="font-left" style="line-height: inherit">参赛编码：</span><span style="float: left"><?php if(!empty($bmu)) echo $bmu['sign_code'] ?></span>
    </section>
    <section>
        <span class="font-left" style="line-height: inherit">手机号码：</span><span style="float: left"><?php if(!empty($bmu)) echo $bmu['user']['account'] ?></span>
    </section>
    <!--
    <section>
        <span class="font-left">上传作品：</span>
        <button class="upload-btn" id="uploadBtn">请选择作品</button><span>仅限1张图片,2M以内</span>
    </section>-->

    <div id="id_form_content">

    </div>

</article>
<div class="bottom-button">
    <img class="bottom-1button id_commit" style="width: 89%" src="/app/su/view/bigidea/images/longupload.png"/><br/>
    <a href="javascript:history.back()"><img class="bottom-2button" src="/app/su/view/bigidea/images/back2.png"/></a>
    <a href="javascript:"><img class="bottom-2button showPicBtn" src="/app/su/view/bigidea/images/previewbtn.png"/></a>
</div>

<?php

if(($su_uid = AccountMod::has_su_login())) {
$f_uid = requestInt('f_uid', 9);
$record = Dba::readRowAssoc('select * from form_record where f_uid = '.$f_uid.' && su_uid = '.$su_uid
, 'FormMod::func_get_form_record');
}

?>




<div id="showPic">
    <img id="showPicPic" src="<?php if(!empty($record)) echo $record['data']['file_img2']['url'] ?>"/><br/>
    <img class="close-pic" src="/app/su/view/bigidea/images/close.png"/>
</div>
<div id="darkMask2"></div>
<!----------------------------------------------------------------------------------------------------------------------------------------------------------->
<footer></footer>
<script src="/static/js/jquery2.1.min.js"></script>
<script src="/app/form/view/bigidea/static/js/plupload.full.min.js"></script>
<script src="/app/su/view/bigidea/js/tip.js"></script>
<script>
    <?php echo 'var g_form = '.json_encode($form).';';?>
    <?php echo 'var g_record = '.($record ? json_encode($record) : 'null').'; ';?>
</script>
<script src="/app/form/view/bigidea/static/js/bigidea.js"></script>

<script>
    $(document).ready(function () {
        $(".showPicBtn").click(function () {
            $("#showPic").show();
            $("#darkMask2").show();
        });
        $(".close-pic").click(function () {
            $("#showPic").hide();
            $("#darkMask2").hide();
        });

        $("body").on("click",".closeBtn", function () {
            window.location.href = '?_a=su&_u=index.preview';

        })


    })
</script>
</body>
</html>






