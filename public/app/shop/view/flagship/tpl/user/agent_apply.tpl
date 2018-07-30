<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit"><!--360优先使用极速核-->
    <meta http-equiv="X-UA-COMPATIBLE" content="chrome=1,IE=Edge"><!--优先谷歌内核，最新ie-->
    <meta http-equiv="Cache-Control" content="no-siteapp"><!--不转码-->
    <!-- Mobile Devices Support @begin 针对移动端设置-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <!--文档宽度与设备宽度1：1 不允许缩放 -->
    <!-- apple devices -->
    <meta name="apple-mobile-web-app-title" content="N家原创"> <!--添加到主屏后的标题-->
    <meta name="apple-mobile-web-app-capable" content="yes"/> <!--启用WebApp全屏模式 -->
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent"/><!-- 顶端状态条 -->
    <meta name="apple-touch-fullscreen" content="yes"><!--全屏显示 -->
    <meta name="format-detection" content="telephone=no,email=no,address=no"><!--不识别电话邮箱地址-->
    <!-- Mobile Devices Support @end -->
    <meta name="keywords" content="your keywords"><!--关键字-->
    <meta name="description" content="your description"><!--描述-->
    <meta name="author" content="Near"><!--作者-->
    <title><?php if(!empty($shop['title'])) echo $shop['title'] ?></title>
    <link rel="shortcut icon" href="<?php echo $static_path?>/images/logo.ico" type="image/x-icon">
    <!-- External CSS -->
    <link rel="stylesheet" href="<?php echo $static_path?>/weui/weui.min.css"/>
    <link rel="stylesheet" href="<?php echo $static_path?>/weui/slide.css"/>
</head>
<body ontouchstart="">
<!--todo*************************************************************************************************************-->
<div class="container slide_container">
    <div class="page">
        <div class="hd">
            <h1 class="page_title"><?php if(!empty($shop['title'])) echo $shop['title'] ?></h1>
            <p class="page_desc">分销管理系统</p>
            <!--<a href="javascript:;" class="weui_btn weui_btn_mini weui_btn_primary" style="position: absolute;top: 1em;right: 1em">返回</a>-->
        </div>
        <?php
        if(empty($agent)){
            ?>
            <div class="bd spacing">
                <a href="javascript:;" class="apply-btn <!--slide_to--> weui_btn weui_btn_primary" data-id="register" >点击申请成为分销商</a>
                <div class="weui_msg">
                    <div class="weui_text_area">
                        <p class="weui_msg_desc">动动指头发大财，你也可以！</p>
                    </div>
                </div>
            </div>
        <?php
        }
        else if($agent['status']==0){
            ?>
            <div class="bd spacing">
                <div class="weui_msg" style="padding-top: 0">
                    <div class="weui_icon_area"><i class="weui_icon_msg weui_icon_success"></i></div>
                    <div class="weui_text_area">
                        <h2 class="weui_msg_title">您已申请通过</h2>
                        <p onclick="window.location.href='?_a=shop&_u=user.agent_center'" class="weui_msg_desc" style="cursor: pointer">点击这里进入管理中心</p>
                    </div>
                </div>
            </div>
        <?php
        }
        else if($agent['status']==2){
            ?>
            <div class="bd spacing">
                <div class="weui_msg" style="padding-top: 0">
                    <div class="weui_icon_area"><i class="weui_icon_msg weui_icon_warn"></i></div>
                    <div class="weui_text_area">
                        <h2 class="weui_msg_title">抱歉，分销名额已满</h2>
                        <p class="weui_msg_desc"></p>
                    </div>
                </div>
            </div>
        <?php
        }
        else if($agent['status']==1){
            ?>
            <div class="bd spacing">
                <div class="weui_msg" style="padding-top: 0">
                    <div class="weui_icon_area"><i class="weui_icon_msg weui_icon_waiting"></i></div>
                    <div class="weui_text_area">
                        <h2 class="weui_msg_title">审核中...</h2>
                        <p class="weui_msg_desc">请耐心等待，我们将第一时间通知您</p>
                    </div>
                </div>
            </div>
        <?php
        }
        ?>
        <!--<div class="weui_msg">
            <div class="weui_extra_area">
                <a href="">查看详情</a>
            </div>
        </div>-->
    </div>
</div>
<!--加载框-->
<div id="loadingToast" class="weui_loading_toast" style="display: none;">
    <div class="weui_mask_transparent"></div>
    <div class="weui_toast">
        <div class="weui_loading">
            <div class="weui_loading_leaf weui_loading_leaf_0"></div>
            <div class="weui_loading_leaf weui_loading_leaf_1"></div>
            <div class="weui_loading_leaf weui_loading_leaf_2"></div>
            <div class="weui_loading_leaf weui_loading_leaf_3"></div>
            <div class="weui_loading_leaf weui_loading_leaf_4"></div>
            <div class="weui_loading_leaf weui_loading_leaf_5"></div>
            <div class="weui_loading_leaf weui_loading_leaf_6"></div>
            <div class="weui_loading_leaf weui_loading_leaf_7"></div>
            <div class="weui_loading_leaf weui_loading_leaf_8"></div>
            <div class="weui_loading_leaf weui_loading_leaf_9"></div>
            <div class="weui_loading_leaf weui_loading_leaf_10"></div>
            <div class="weui_loading_leaf weui_loading_leaf_11"></div>
        </div>
        <p class="weui_toast_content">数据加载中</p>
    </div>
</div>
<!--todo：跳转页------------------------------------------------------------------------------------------------------->
<!--申请页-->
<script type="text/html" id="tpl_register">
    <div class="page">
        <div class="hd">
            <h1 class="page_title">申请分销商</h1>
        </div>
        <div class="bd">
            <div class="weui_cells weui_cells_form">
                <div class="weui_cell">
                    <div class="weui_cell_hd"><label class="weui_label">手机</label></div>
                    <div class="weui_cell_bd weui_cell_primary">
                        <input class="weui_input" type="number" placeholder="请输入qq号">
                    </div>
                </div>
                <div class="weui_cell">
                    <div class="weui_cell_hd"><label class="weui_label">银行卡</label></div>
                    <div class="weui_cell_bd weui_cell_primary">
                        <input class="weui_input" type="number" placeholder="请输入银行卡号">
                    </div>
                </div>
                <div class="weui_cell weui_cell_select weui_select_after">
                    <div class="weui_cell_hd">国家/地区</div>
                    <div class="weui_cell_bd weui_cell_primary">
                        <select class="weui_select" name="select2">
                            <option value="1">中国</option>
                            <option value="2">美国</option>
                            <option value="3">英国</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="bd spacing weui_btn_area">
                <a href="javascript:history.back();" class="weui_btn weui_btn_primary" id="loading-btn">提交</a>
            </div>
        </div>
    </div>
</script>
<!--等待审核页-->
<script type="text/html" id="tpl_result">
    <div class="page">
        <div class="weui_msg">
            <div class="weui_icon_area"><i class="weui_icon_success weui_icon_msg"></i></div>
            <div class="weui_text_area">
                <h2 class="weui_msg_title">申请已经提交</h2>
                <p class="weui_msg_desc">审核通过后，我们会第一时间通知您。</p>
            </div>
            <div class="weui_opr_area">
                <p class="weui_btn_area">
                    <a href="javascript:history.back();" class="apply-success weui_btn weui_btn_primary">确定</a>
                </p>
            </div>
        </div>
    </div>
</script>
<!--todo:************************************************************************************************************-->
<script src="<?php echo $static_path?>/js/sea.js"></script>
<script type="text/javascript">
    /*初始化*/
    seajs.config({
        charset: 'utf-8',
        paths:{
            'js':'<?php echo $static_path?>/js',
            'css':'<?php echo $static_path?>/css',
            'seajs':'<?php echo $static_path?>/seajs',
            'weui':'<?php echo $static_path?>/weui'
        },
        alias: {
            'jquery':'js/jquery2.1.min.js',
            'jquery_cookie':'js/jquery.cookie.js',
            'zepto':'js/zepto.min.js',
            'zepto_cookie':'js/zepto.cookie.min.js',
            'doT':'js/doT.min.js',
            'plupload':'js/plupload.full.min.js',
            'transit':'js/jquery.transit.min.js',
            /*自己写的*/
            'swiper_js':'css/swiper/swiper.min.js',
            'echo':'seajs/echo_seajs.js'
        }
    });
</script>
<script type="text/javascript">
    /*slide包含zepto*/
    seajs.use(['weui/slide'], function (slide) {
        $(function () {
            var $container = $('.slide_container');
            $container
                .on('click','.apply-success', function () {
                    setTimeout(function () {
                        window.location.reload()
                    },100)
                })
            ;
            $('.apply-btn').on('click', function () {
                $('#loadingToast').show();
                $.post('?_a=shop&_u=ajax.agent_apply', function (ret) {
                    ret = JSON.parse(ret);
                    console.log(ret)
                    setTimeout(function () {
                      if(ret.errno==0){
                            slide.go('result');
                            $('#loadingToast').hide();
                      }else{
                      	alert('错误，缺少字段')
                      }
                    },300);
                })
            })
        });
    })
</script>
</body>
</html>