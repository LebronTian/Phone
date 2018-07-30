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
    <title>simple PC</title>
    <link rel="stylesheet" type="text/css" href="/static/css/amazeui2.1.min.css">
    <style type="text/css">
        .form-content {
            min-height: 615px;
            padding-bottom: 58px;
            background:url(/app/web/static/images/form_bg.jpg) repeat center center;
        }
        .form-content .tit{
            padding-top: 28px;
        }
        .form-content .tit h1{
            color: #FFFFFF;
            font-size: 35px;
            text-align: center;
        }
        .form-content .cont{
            position: relative;
            margin-top: 35px;
            padding: 58px 115px;
            border: 2px solid #0E90D2;
            border-radius: 4px;
            background-color: #F1F1F1;
        }
        .form-content .cont .section{
            margin: 10px 0;
        }
        .form-content .cont .section textarea{
            
        }
        .form-content .cont .section .form-left{
            line-height: 41px;
            font-size: 14px;
        }
        .form-content .cont .section select{
            height: 41px;
            padding: 0 10px;
            margin-right: 10px;
            border: 1px solid #CCCCCC;
        }
        .form-content .cont .section .info{
            font-size: 12px;
            color: #0E90D2;
        }
        #submit-form-btn{
            padding: 10px 41px;
            font-size: 28px;
            position: absolute;
            bottom: -26px;
            left: 50%;
            margin-left: -98px;
        }
        .form-content .cont .type-box{
            height: 41px;
            line-height: 41px;
        }
        .form-content .cont .type-box label{
            margin-right: 15px;
            font-weight: normal;
            font-size: 14px;
        }
        .form-content .cont .type-box label input{
            margin-right: 10px;
        }
    </style>
</head>
<body onload="setup();preselect('广东省');promptinfo();">
    <div class="form-content">
        <div class="am-container">
            <div class="tit">
                <h1><?php echo(!empty($form['title']) ? $form['title'] : '' ) ?></h1>
            </div>
            <div class="cont">
                <div class="am-g section">
                    <div class="am-u-sm-2 form-left"></div>
                    <div class="am-u-sm-10">
                        <p class="info">提交后，我们会在最短的时间联系您</p>
                    </div>
                </div>
                <input type="button" id="submit-form-btn" class="am-btn am-btn-success am-round" value="提交申请">
            </div>
        </div>
    </div>

</body>
<script src="/static/js/jquery2.1.min.js"></script>
<script src="/static/js/amazeui2.1.min.js"></script>
<script type="text/javascript" src="/static/js/geo.js"></script>
<script>
    var g_form = <?php echo (!empty($form) ? json_encode($form) : 'null' ) ?>;
    var g_record = <?php echo (!empty($record) ? json_encode($record) : 'null' ) ?>;
    function promptinfo(){
        var s1 = document.getElementById('s1');
        var s2 = document.getElementById('s2');
        var s3 = document.getElementById('s3');
    }
</script>
<script src="/app/form/view/simple/static/js/index.js"></script>
<script type="text/javascript">
    $(document).ready(function(){
        if(g_record) {
            var select_type = g_record.data[3];
            //console.log(select_type);
            var labels = $('.type-box').find('label');
            for(var i=0;i<labels.length;i++){
                if($('.type-box').find('label:eq('+i+')').find('span').text()==select_type){
                    $('.type-box').find('label:eq('+i+')').find('input').attr('checked','checked');
                }   
            }
            var select_city = g_record.data[4];
            select_city = select_city.split(',');
            //console.log(select_city.length);
            var province = select_city[0];
            var city = select_city[1];
            var town = select_city[2];
            console.log(province);
            //s1.value = province;
        }
    });
</script>
</html>