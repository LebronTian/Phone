<?php 
$shop = ShopMod::get_shop(); 
$option['su_uid'] = $su['uid'];
$return = DistributionMod::get_dtb_record_list($option);
//var_export($user_dtb)

?>
<?php if(!empty($shop['sp_uid'])) $color1 = $GLOBALS['arraydb_sys']['cfg_shop_setcolor_1'.$shop['sp_uid']];?>
<?php if(!empty($shop['sp_uid'])) $color2 = $GLOBALS['arraydb_sys']['cfg_shop_setcolor_2'.$shop['sp_uid']];?>
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
<link rel="stylesheet" href="<?php echo $static_path?>/css/style.css">
<link rel="stylesheet" href="<?php echo $static_path?>/weui/weui.min.css"> 
<link rel="stylesheet" href="<?php echo $static_path?>/weui/slide2.css">
<link rel="stylesheet" href="<?php echo $static_path?>/css/good.css">
</head>
<!--todo*************************************************************************************************************-->
<body ontouchstart="">
<style>
	.container{padding: 1%;margin-bottom: 60px;}
	.b-main,.color-main,.active-bg,.bg-primary,.order-green-ball{background: #<?php echo ($color1)? $color1:fff ?> !important;color: #fff;}
	.c-green,.text-active,.secondary-font,.text-primary,.big-text .fa,.active-border{color:#<?php echo ($color1)? $color1:333?> !important;}
	.svg-main{fill:#<?php echo ($color1)? $color1:333?> !important;}
</style>
<header class="color-main vertical-box">
    <span class="header-title">分销中心</span>
    <div class="header-left vertical-box">
        <img class="img-btn" src="static/images/back.png" onclick="history.back()">
    </div>
    <div class="header-right vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/home.png" onclick="window.location.href='?_a=shop'">
    </div>
</header>
<div class="container slide_container">
    <div class="page">
        <div class="bd">
            <div class="weui_cells weui_cells_access global_navs">
                <a class="slide_to weui_cell" href="javascript:;" >
                    <span class="weui_cell_hd"><svg t="1494574059545" class="icon icon_nav" style="" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="4749" xmlns:xlink="http://www.w3.org/1999/xlink" width="150" height="150"><defs><style type="text/css"></style></defs><path d="M957.216 404.32c-3.808-11.36-13.632-19.68-25.504-21.504l-270.336-41.728-120.8-258.624C535.328 71.232 524.032 64.032 511.648 64c0 0-0.032 0-0.064 0-12.384 0-23.648 7.136-28.928 18.336l-121.856 258.016-270.72 40.8c-11.872 1.792-21.728 10.048-25.568 21.408-3.84 11.36-0.992 23.936 7.36 32.512l196.448 202.08L221.44 921.952c-1.984 12.096 3.104 24.256 13.12 31.328 9.984 7.072 23.168 7.808 33.888 1.92l241.824-133.024 241.312 133.856C756.416 958.656 761.76 960 767.104 960c0.256 0 0.48 0 0.64 0 17.696 0 32-14.304 32-32 0-3.968-0.704-7.776-2.016-11.296l-44.896-278.688 196.928-201.248C958.08 428.224 960.992 415.68 957.216 404.32z" p-id="4750"></path></svg></span>
                    <div class="weui_cell_bd weui_cell_primary">
                        <p class="reT-3">分销中心</p>
                    </div>
                    
                </a>
                <a class="weui_cell slide_to" href="javascript:;" data-id="income">
                    <div class="weui_cell_bd weui_cell_primary">
                        <p>收入详情</p>
                    </div>
                    <div class="weui_cell_ft"></div>
                </a>
                
                <a class="slide_to weui_cell" href="javascript:;" data-id="detail">
                    <div class="weui_cell_bd weui_cell_primary">
                        <p>我来邀请</p>
                    </div>
                    <div class="weui_cell_ft"></div>
                </a>
            </div>
        </div>
        <section class="bd border-box">
          
            <div class="weui_cells weui_cells_access global_navs">
                <a class="slide_to weui_cell" href="javascript:;" >
                    <span class="weui_cell_hd"><svg t="1494574398653" class="icon icon_nav" style="" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="5265" xmlns:xlink="http://www.w3.org/1999/xlink" width="150" height="150"><defs><style type="text/css"></style></defs><path d="M620.8 611.2c67.2-38.4 115.2-112 115.2-195.2 0-124.8-99.2-224-224-224s-224 99.2-224 224c0 83.2 44.8 156.8 115.2 195.2-89.6 35.2-156.8 115.2-179.2 211.2-3.2 9.6 0 19.2 6.4 25.6 6.4 6.4 16 12.8 25.6 12.8h512c9.6 0 19.2-3.2 25.6-12.8 6.4-6.4 6.4-16 6.4-25.6-22.4-96-89.6-176-179.2-211.2zM992 630.4c-12.8-64-54.4-115.2-118.4-144 35.2-32 54.4-76.8 54.4-128C928 265.6 857.6 192 768 192c-19.2 0-32 12.8-32 32s12.8 32 32 32c54.4 0 96 44.8 96 102.4 0 51.2-28.8 89.6-73.6 99.2-16 3.2-28.8 22.4-22.4 38.4 0 16 9.6 28.8 25.6 28.8 70.4 12.8 118.4 54.4 131.2 115.2 3.2 16 16 25.6 32 25.6h6.4c19.2 0 32-16 28.8-35.2zM252.8 499.2c6.4-19.2-6.4-35.2-22.4-41.6C188.8 448 160 409.6 160 358.4 163.2 300.8 201.6 256 256 256c19.2 0 32-12.8 32-32s-16-32-32-32c-89.6 0-156.8 70.4-156.8 166.4 0 51.2 19.2 96 51.2 128-60.8 28.8-105.6 80-118.4 144-3.2 16 6.4 35.2 25.6 38.4H64c16 0 28.8-9.6 32-25.6 12.8-60.8 60.8-102.4 131.2-115.2 16 0 25.6-12.8 25.6-28.8z" p-id="5266"></path></svg> </span>
                    <div class="weui_cell_bd weui_cell_primary">
                        <p class="reT-3">我的盟友</p>
                    </div>
                    <div class="cell-right total"></div>
                </a>
                 <a class="slide_to weui_cell" href="javascript:;">
                    <span class="weui_cell_hd"></span>
                    <div class="weui_cell_bd weui_cell_primary">
                         <p>上级盟友</p>
                   </div>
                    <div class="cell-right moreleve"><?php
                    if(isset($user_dtb['parent_user'])){
                       echo (!empty($user_dtb['parent_user']['name']))? $user_dtb['parent_user']['name']:$user_dtb['parent_user']['account'];
                    } ?></div>
                </a>
                 <a class="slide_to weui_cell" href="javascript:;" data-id="leve-frist">
                    <span class="weui_cell_hd"></span>
                    <div class="weui_cell_bd weui_cell_primary">
                         <p>一级盟友</p>
                   </div>
                    <div class="cell-right fristleve"></div>
                </a>
                <a class="slide_to weui_cell" href="javascript:;" data-id="leve-second">
                    <span class="weui_cell_hd"></span>
                    <div class="weui_cell_bd weui_cell_primary">
                         <p>二级盟友</p>
                   </div>
                    <div class="cell-right sencondleve"></div>
                </a>
                <a class="slide_to weui_cell" href="javascript:;" data-id="leve-third">
                    <span class="weui_cell_hd"></span>
                    <div class="weui_cell_bd weui_cell_primary">
                         <p>三级盟友</p>
                   </div>
                    <div class="cell-right thirdleve"></div>
                </a>
            </div>
        </section>
        <!--<section class="bd border-box" onclick="window.location.href='?_a=pay&_u=index.do_withdraw'">-->
        <section class="bd border-box" onclick="window.location.href='?_easy=su.common.index.withdraw'">
            <a class="slide_to weui_cell" href="javascript:;" style="color: #111;font-size:1.1em; ">
            <span><svg t="1494574199042" class="icon icon_nav" style="" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="5007" xmlns:xlink="http://www.w3.org/1999/xlink" width="150" height="150"><defs><style type="text/css"></style></defs><path d="M512 64C264.96 64 64 264.96 64 512s200.96 448 448 448 448-200.96 448-448S759.04 64 512 64zM640.768 576c17.696 0 32 14.304 32 32s-14.304 32-32 32L544 640l0 95.136c0 17.696-14.304 32-32 32s-32-14.304-32-32L480 640l-95.104 0c-17.696 0-32-14.304-32-32s14.304-32 32-32L480 576l0-64-95.104 0c-17.696 0-32-14.304-32-32s14.304-32 32-32L480 448l0-19.776-118.432-118.624c-12.544-12.48-12.064-32.736 0.416-45.248 12.512-12.576 32.704-12.512 45.216-0.064l107.584 107.36 101.632-106.784c12.288-12.832 32.416-13.216 45.152-1.12 12.8 12.192 13.056 32.48 0.864 45.248L544 432.864 544 448l96.768 0c17.696 0 32 14.304 32 32s-14.304 32-32 32L544 512l0 64L640.768 576z" p-id="5008"></path></svg></span>
            <span>申请提现</span>
            </a>
        </section>
    </div>
</div> 
<!--loading box-->
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
        <p class="weui_toast_content">加载中</p>
    </div>
</div>
<!--confirm box-->
<div id="weui-confirm" class="weui_dialog_confirm" style="display: none">
    <div class="weui_mask"></div>
    <div class="weui_dialog">
        <div class="weui_dialog_hd"><strong class="weui_dialog_title"></strong></div>
        <div class="weui_dialog_bd"></div>
        <div class="weui_dialog_ft">
            <a href="javascript:;" class="weui_btn_dialog default">取消</a>
            <a href="javascript:;" class="weui_btn_dialog primary">确定</a>
        </div>
    </div>
</div>
<!--todo：跳转页 -->
<!-- 一级盟友页面 -->
<script type="text/html" id="tpl_leve-frist">

    <div class="page leve-frist">
        <div class="bd">
            <article class="profitContainer">
                <section class="profitMenber">
                    <div class="profitlistleft">
                        <p style=" margin-top: 0.7em;">用户名</p>
                    </div>
                     <div class="profitlistRight_2">
                        <span>消费总金额</span>
                    </div>
                </section>
            </article>
        </div>
    </div>
</script>
<!-- 二级盟友页面 -->
<script type="text/html" id="tpl_leve-second">

    <div class="page leve-frist">
        <div class="bd">
            <article class="profitContainer">
                <section class="profitMenber">
                    <div class="profitlistleft">
                        <p style=" margin-top: 0.7em;">用户名</p>
                    </div>
                     <div class="profitlistRight_2">
                        <span>消费总金额</span>
                    </div>
                </section>
            </article>
        </div>
    </div>
</script>
<!-- 三级盟友页面 -->
<script type="text/html" id="tpl_leve-third">

    <div class="page leve-frist">
        <div class="bd">
            <article class="profitContainer">
                <section class="profitMenber">
                    <div class="profitlistleft">
                        <p style=" margin-top: 0.7em;">用户名</p>
                    </div>
                     <div class="profitlistRight_2">
                        <span>消费总金额</span>
                    </div>
                </section>
            </article>
        </div>
    </div>
</script>
<!--资料页-->
<script type="text/html" id="tpl_detail">
    <div class="page">
        <div class="hd small-hd">
            <h1 class="page_title">我来邀请</h1>
        </div>
        <div class="bd spacing">
            <article class="">
                <p class="qrcode-title tips-font">我的邀请二维码</p>
                <div class="qrcode-box">
                    <img src="?_a=web&_u=index.qrcode&url=<?php if(!empty($url)) echo rawurlencode($url) ?>">
                </div>
                <p class="qrcode-title active-font margin-bottom">
                    您可以保存二维码发送给朋友<br>
                </p>
            </article>
        </div>
    </div>
</script>
<!--订单页-->

<!--订单页-->

<!--收入-->
<script type="text/html" id="tpl_income">
    <div class="page">
        <div class="hd small-hd" style="padding: 0;">
            <h1 class="page_title">收入详情</h1>
        </div>
        <div class="bd">
            <article class="profitContainer">
                <section class="profitMenber">
                    <div class="profitlistleft">
                        <p style=" margin-top: 0.7em;">用户名 时间</p>
                    </div>
                     <div class="profitlistRight">
                        <span>订单价格</span>
                        <span>分红</span>
                    </div>
                </section>
            </article>
           
        </div>
    </div>
</script>
<!-- userlist -->

<!--todo:************************************************************************************************************-->
<script src="<?php echo $static_path?>/js/sea.js"></script>
<script src="<?php echo $static_path?>/js/seajs-css.js"></script>
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
            'qrcode':'/static_seajs/public_toolkit/qrcode/qrcode.js',
            'qrcode_js':'/static_seajs/public_toolkit/qrcode/jquery.qrcode.js',
            /*自己写的*/
            'swiper_js':'css/swiper/swiper.min.js',
            'echo':'seajs/echo_seajs.js'
        }
    });
</script>
<script type="text/javascript">
    /*slide包含zepto*/
    seajs.use(['weui/slide'], function (slide) {
            $.post("?_a=shop&_u=ajax.get_user_dtb_tree&level=3", function(ret){
                ret = JSON.parse(ret);
                console.log('get_user_dtb_tree...', ret);
                if(ret.errno==0){
                    html=ret.data.user_dtb_tree.count;
                    $('.total').append(html+'人');
                    // 一级盟友
                    if(!html){
                        html=0;
                    }else{html=ret.data.user_dtb_tree[1].count;}
                    $('.fristleve').append(html+'人');
                    // 二级盟友
                    if(!html){
                         html=0;
                    }else{html=ret.data.user_dtb_tree[2].count;}
                    $('.sencondleve').append(html+'人');
                    // 三级盟友
                    if(!html){
                         html=0;
                    }else{html=ret.data.user_dtb_tree[3].count;}
                    $('.thirdleve').append(html+'人');  
                }
            });
            var $container = $('.slide_container');
            $container.on('click','#loading-btn', function () {
                    $('#loadingToast').show();
                    setTimeout(function () {
                        slide.go('result');
                        $('#loadingToast').hide();
                    }, 1000);
                });
            /*回调数组*/
            var callback_arr = [
                {
                    id:'detail',
                    callback: function () {
                        $('.boss-shop').click(function () {
                            seajs.use('zepto_cookie', function () {
                                $.fn.cookie('__s_a_uid',null);
                                window.location.href = '?_a=shop&__sp_uid=<?php echo $shop['sp_uid'] ?>'
                            })
                        });
                    }
                },
                {
                    id:'leve-frist',
                    callback:function(){
                         var level = 3;
                         var link = "?_a=shop&_u=ajax.get_user_dtb_tree&level="+level;
                        
                        $.post(link, function(ret){
                        ret = JSON.parse(ret);
//                      console.log('get_user_dtb_tree...', ret);
                        if(ret.errno==0){
                             var html = ''; 
                             if (ret.data.user_dtb_tree[1]) {
                                  $.each(ret.data.user_dtb_tree[1].list, function (ind) {
                                    if(!this.user.name){
                                    	this.user.name=this.user.account;
                                    }
                                    var price=(this.order_fee/100).toFixed(2);
                                    html += '<section class="profitMenber">'
                                            +'<div class="profitlistleft">'
                                              +  '<p class="lineh3">'+' '+this.user.name+'</p>'
                                            +'</div>'
                                             +'<div class="profitlistRight_2">'
                                                +'<span>'+'￥'+price+'</span>'
                                            +'</div>'
                                        +'</section>'
                                 });  
                              } 
                              if(html==''){html='<p>没有用户，快去邀请吧</p>';
                              	$('.leve-frist').append(html)
                              }
                              else{
                              	$('.leve-frist .profitContainer').append(html)
                              }
                        }

                    })
                    }
                },
                {
                    id:'leve-second',
                    callback:function(){
                         var level = 3;
                         var link = "?_a=shop&_u=ajax.get_user_dtb_tree&level="+level;
                        // var link = "?_a=shop&_u=ajax.get_user_dtb_tree";
                        $.post(link, function(ret){
                        ret = JSON.parse(ret);
                        // console.log('get_user_dtb_tree...', ret);
                        if(ret.errno==0){
                             var html = ''; 
                             if (ret.data.user_dtb_tree[2]) {
                                 $.each(ret.data.user_dtb_tree[2].list, function (ind) { 
                                    if(!this.user.name){
                                    	this.user.name=this.user.account;
                                    }
                                    var price=(this.order_fee/100).toFixed(2);
                                    html += '<section class="profitMenber">'
                                            +'<div class="profitlistleft">'
                                              +  '<p class="lineh3">'+' '+this.user.name+'</p>'
                                            +'</div>'
                                             +'<div class="profitlistRight_2">'
                                                +'<span>'+'￥'+price+'</span>'
                                            +'</div>'
                                        +'</section>'
                                 });   
                              } 
                              if(html==''){html='<p>没有用户，快去邀请吧</p>';
                              	$('.leve-frist').append(html)
                              }
                              else{
                              	$('.leve-frist .profitContainer').append(html)
                              }
                        } 

                    })
                    }
                },
                {
                    id:'leve-third',
                    callback:function(){
                         var level = 3;
                         var link = "?_a=shop&_u=ajax.get_user_dtb_tree&level="+level;
                        // var link = "?_a=shop&_u=ajax.get_user_dtb_tree";
                        $.post(link, function(ret){
                        ret = JSON.parse(ret);
                        console.log('get_user_dtb_tree...', ret);
                        if(ret.errno==0){
                             var html = '';
                             if (ret.data.user_dtb_tree[3]) {
                             $.each(ret.data.user_dtb_tree[3].list, function (ind) {
                                    if(!this.user.name){
                                    	this.user.name=this.user.account;
                                    }
                                    var price=(this.order_fee/100).toFixed(2);
                                    html += '<section class="profitMenber">'
                                            +'<div class="profitlistleft">'
                                              +  '<p class="lineh3">'+' '+this.user.name+'</p>'
                                            +'</div>'
                                             +'<div class="profitlistRight_2">'
                                                +'<span>'+'￥'+price+'</span>'
                                            +'</div>'
                                        +'</section>'
                                 });  
                              } 
                              if(html==''){html='<p>没有用户，快去邀请吧</p>';
                              	$('.leve-frist').html(html)
                              }
                              else{
                              	$('.leve-frist .profitContainer').append(html)
                              }
                        }

                    })
                    }
                },
                
                {
                    id:'income',
                    callback: function () {
                         $.post('?_a=shop&_u=ajax.distributionlist', function(ret){
                        ret = JSON.parse(ret);
                        console.log('distributionlist...', ret)
                        function getLocalTime(str) {      
                             var s = new Date(parseInt(str) * 1000);    
                             var y = s.getFullYear();    
                             var m = s.getMonth()+1;    
                             if(m<10){        m = '0' + m;    }    
                             var d = s.getDate();   
                             if(d<10){        d = '0' + d;    }   
                           
                             var translate_str = y +'-' + m + '-' + d ;  
                             return translate_str; 
                         }
                         if(ret.errno==0){
                             var html = '';
                             $.each(ret.data.dtblist.list, function (ind) {
                                console.log(this)
                                    var price=((this['paid_fee'])/100).toFixed(2);
                                    var bonouse=(this['cash']/100).toFixed(2);
                                    var username;
                                    if(this['order']['user']['name']!=""){
                                        username=this['order']['user']['name'];
                                    }
                                    else{username='匿名用户'}
                                    html+= '<section class="profitMenber">'
                                            +'<div class="profitlistleft">'
                                              +  '<p>'+' '+username+'</p>'
                                                +'<p>'+getLocalTime(this.create_time) +'</p>'
                                            +'</div>'
                                             +'<div class="profitlistRight">'
                                                +'<span>'+'￥'+price+'</span>'
                                                +' <span>'+'￥'+bonouse+'</span>'
                                            +'</div>'
                                        +'</section>'
                                                   
                             });
                             if(html==''){html='<p>没有订单</p>'}
                             $('.profitContainer').append(html);
                             $('.leve-frist .profitContainer').append(html)
                        }

                    }); 
                   }
                },
                
            ];
            /*加入回调*/
            $.each(callback_arr, function () {
                slide.slideCallback(this);
            });
            /*载入页面调用回调*/
            if (/#.*/gi.test(location.href)) {
                var now_hash = location.hash.slice(1);
                // console.log(now_hash,'aaa')
                $.each(callback_arr, function () {
                    if(this.id==now_hash&&this.callback&&(typeof this.callback=='function')){
                        this.callback()
                    }
                })
            }

            /*weui基础建设*//*todo：待封装*/
            function weui_comfirm(option){
                var comfirm_box = $('#weui-confirm');
                if(option.title){
                    comfirm_box.find('.weui_dialog_title').text(option.title)
                }
                if(option.tips){
                    comfirm_box.find('.weui_dialog_bd').text(option.tips)
                }
                comfirm_box.show();
                comfirm_box.find('.weui_btn_dialog').unbind('click').on('click', function () {
                    comfirm_box.hide();
                    if(($(this).hasClass('primary'))&&option.onConfirm){
                        option.onConfirm()
                    }
                    else if(option.onCancel){
                        option.onCancel()
                    }
                });
            }
        });
//     })
// })
</script>
</body>
</html>