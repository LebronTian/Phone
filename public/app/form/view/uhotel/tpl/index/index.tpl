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
    <title>有园酒店</title>
    <link rel="shortcut icon" href="/app/form/view/uhotel/static/images/logo.png" type="image/x-icon">
    <style>
        *{  margin: 0;  padding: 0;  }
        body{
            margin: 0;
            padding: 0;
            font-family: "微软雅黑 Regular","微软雅黑";
            font-size: 1em;
            color:#000;
            font-weight: 400;
        }
        img{ border: 0;max-height: 100%;max-width: 100%}
        ul{ list-style: none}
        button{cursor: pointer}
        .clear{clear: both}
        a:link{text-decoration:none;}       /* 指正常的未被访问过的链接*/
        a:visited{text-decoration:none;}    /*指已经访问过的链接*/
        a:hover{text-decoration:none;}      /*指鼠标在链接*/
        a:active{text-decoration:none;}     /* 指正在点的链接*/
        h1,h2,h3,h4,h5{
            margin: 0;
        }
        .text-ellipsis{             /*自动打点*/
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .border-box{                /*计算边框的盒子*/
            box-sizing:border-box;
            -moz-box-sizing:border-box; /* Firefox */
            -webkit-box-sizing:border-box; /* Safari */
        }
        /*****************************************************************/
        body{
            /*background-image: url(/app/form/view/uhotel/static/images/bg.png);*/
            /*background-size: cover;*/
            /*background-repeat: no-repeat;*/
        }
        .form-contain{
            position: fixed;
            top: 0;left: 0;
            width: 100%;height: 100%;
            background-image: url(/app/form/view/uhotel/static/images/bg.png);
            background-size: cover;
            background-repeat: no-repeat;
            overflow: scroll;
        }
        .form-logo{
            text-align: center;
            margin-top: 15%;
        }
        .form-logo img{
            width: 20%;
        }
        .form-body{
            overflow: hidden;
            margin-top: 1em;
        }
        .input-section{
            float: right;
            background: rgba(0,0,0,.3);
            width: 65%;
            color: #ffffff;
            margin-bottom: 1.5em;
            height: 3em;
            position: relative;
        }
        .input-section:last-child{
            margin-bottom: 0;
        }
        .input-section input{
            border: none;
            height: 3.5em;
            background: none;
            padding-left:0.5em ;
            width: 100%;
            color: #ffffff;
        }
        input:-moz-placeholder { color: #d0d0d0; }
        ::-webkit-input-placeholder { color:#d0d0d0; }
        .half-circle{
            display: inline-block;
            height: 3em;width: 3em;
            background: rgba(0,0,0,.3);
            border-top-left-radius: 50%;
            border-bottom-left-radius: 50%;
            position: absolute;
            top: 0;left: -3em;z-index: 10;
        }
        .input-section img{
            position: absolute;
            z-index: 100;
            width: 1em;
            top:0.8em;left: -1.5em;
        }
        .form-button{
            text-align: center;
            margin-top: 4em;
            margin-bottom: 1em;
        }
        .out-circle{
            display: inline-block;
            width: 25vw;
            height: 25vw;
            background: rgba(255,255,255,0.6);
            border-radius: 50%;
            padding: 0.6em;
        }
        .in-circle{
            display: inline-block;
            background: #fbb634;
            color: #ffffff;
            width: 25vw;height: 25vw;
            line-height: 25vw;
            border-radius: 50%;
            font-size: 155%;
            text-align: center;
        }
        .form-detail{
            padding: 2em;
            margin: 2em auto;
            width: 80%;
            background: rgba(255,255,255,0.6);
            box-sizing: border-box;
            border-radius: 10px;
        }
        .detail-box{
            background: #fbb634;
            padding: 1em;
            color: #ffffff;
            text-align: center;
        }
        .buy-now{
            margin-top: 5px;
            border: none;
            background: #ffffff;
            padding: 0.5em;
            color: #f9b534;
            border-radius: 4px;
        }

    </style>
</head>
<body>

<?php

if(($su_uid = AccountMod::has_su_login())) {
    $f_uid = requestInt('f_uid', 12);
    $record = Dba::readRowAssoc('select * from form_record where f_uid = '.$f_uid.' && su_uid = '.$su_uid
        , 'FormMod::func_get_form_record');
}

?>


<div class="form-contain">
    <div class="form-logo">
        <img src="/app/form/view/uhotel/static/images/logo.png"/>
    </div>
    <!--
    <article class="form-body">
        <section class="input-section">
            <div class="half-circle"></div>
            <img src="/app/form/view/uhotel/static/images/name.png"/>
            <input id="up_name" type="text" placeholder="请输入姓名"/>
        </section>
        <section class="input-section">
            <div class="half-circle"></div>
            <img src="/app/form/view/uhotel/static/images/phone.png"/>
            <input id="up_phone" type="text" placeholder="请输入手机号"/>
        </section>
    </article>
    -->
    <article class="form-body" id="id_form_content">

    </article>

    <?php
    if(!empty($record)){
        $html = '
            <div class="form-detail">
                <div class="detail-box">
                    <p>支付状态：'.(($record['order']['paid_time']?"已支付":"未支付<br/><button id='id_commit' class='buy-now'>立即支付</button><br/>")).'</p>
                    <p>报名状态：'.(($record['order']['paid_time']?"报名成功":"报名失败")).'</p>
                </div>
            </div>';
        echo $html;
    }
    else{
        ?>
        <div class="form-button">
        <span class="out-circle" id="id_commit">
            <span class="in-circle">
                <span style="position: relative;left: 2px">报名</span>
            </span>
        </span>
        </div>
    <?php
    }
    ?>


</div>
</body>
<script src="/static/js/zepto.min.js"></script>
<script>
    <?php echo 'var g_form = '.json_encode($form).';';?>
    <?php echo 'var g_record = '.($record ? json_encode($record) : 'null').'; ';?>

    $(document).ready(function () {
        var all = g_form.access_rule.max_cnt;
        var now = g_form.record_cnt;
        if(all!=0&&all<now){
            alert("活动名额已满，关注有园酒店，更多惊喜活动先睹为快。");
            window.opener=null;
            window.open('','_self');
            window.close();
        }
        /*
        $(".out-circle").click(function () {
            var name = $("#up_name");
            if(name.val().trim()==""){
                alert("请输入姓名");
                name.focus();
                return
            }
            var phone = $("#up_phone");
            if(phone.val().trim()==""){
                alert("请输入手机号");
                name.focus();
                return
            }
            var data = {};
            var post = {
                data:JSON.stringify(data),
                f_uid:12
            };
            if(g_record && g_record.uid) {
                post['uid'] = g_record.uid;
            }
            $.post('?_a=form&_u=ajax.addformrecord',post, function (ret) {
                console.log(ret)
            })
        })*/
    })
</script>
<script src="/app/form/view/uhotel/static/js/index.js"></script>

</html>