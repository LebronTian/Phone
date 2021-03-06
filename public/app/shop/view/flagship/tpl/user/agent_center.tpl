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
    <title><?php if(!empty($shop['title'])) echo $shop['title'].'-' ?>分销系统</title>
    <link rel="shortcut icon" href="<?php echo $static_path?>/images/logo.ico" type="image/x-icon">
    <!-- External CSS -->
    <link rel="stylesheet" href="<?php echo $static_path?>/weui/weui.min.css">
    <link rel="stylesheet" href="<?php echo $static_path?>/weui/slide.css">
</head>
<body ontouchstart="">
<!--todo*************************************************************************************************************-->
<link rel="stylesheet" href="<?php echo $static_path?>/css/style.css">
<link rel="stylesheet" href="<?php echo $static_path?>/css/good.css">
<style>
    .good-article button{border: none;  border-radius: 3px;  padding: 8px;}
    .color-primary{color: white;background: #d43d4f;}  .color-secondary{color: white;background: #ff6600;} .color-green{color:white;background: #09BB07;}
    .color-disable{color: white;background: #999999;}  .color-warning{color: white; background: #fe9402;}
    .color-main{color: white;background: #2f2f2f;}
    .tips-font{color: #666666}
    .active-font{color: #d43d4f;}.active-bg{background: #d43d4f}.active-bottom{border-bottom: thin solid #d43d4f}.active-border{border: thin solid #d43d4f}
    .secondary-font{color: #ff6600;}  .white-tips-font{color: #999999}
    .big-text{font-size: 1.6rem}  .normal-text{font-size: 1.4rem}  .small-text{font-size: 1.2rem}
</style>
<style>
    body{  font-size: 1.4rem;  }  .index-hd{padding-bottom: 1em}
    .center-title{text-align: center;color: #0e90d2;margin-bottom: 0.5rem}
    nav>.nav-table>li>div{width:6rem;margin: 0 auto}
    .nav-table{border-top: thin solid #e9e9ec;border-bottom: thin solid #e9e9ec}
    .nav-table li{border-right: thin solid #e9e9ec;padding: 0.5rem}
    .nav-table li:last-child{border-right: none}
    .nav-table li:nth-child(1){color: #5eb95e}  .nav-table li:nth-child(2){color: #F37B1D}
    .nav-table li:nth-child(3){color: #dd514c}  .nav-table li:nth-child(4){color: #3bb4f2}
    .small-hd{padding: 1em 0} .small-hd h1{font-size: 2rem}
    .qrcode-title{text-align: center}
    .qrcode-box{text-align: center}
    .qrcode-box img{width: 50%}
    .history-back-btn{
        position: fixed;
        top:1em;  left: 1em; z-index: 99;
        transform: rotate(90deg);
        -ms-transform: rotate(90deg);		/* IE 9 */
        -webkit-transform: rotate(90deg);	/* Safari and Chrome */
        -o-transform: rotate(90deg);		/* Opera */
        -moz-transform: rotate(90deg);		/* Firefox */
    }
</style>
<div class="container slide_container">
    <div class="page">
        <div class="hd index-hd">
            <h1 class="page_title"><?php if(!empty($shop['title'])) echo $shop['title'] ?></h1>
            <p class="page_desc">
                <a href="<?php echo $url ?>">分销管理系统</a>
            </p>
        </div>
        <div class="bd">
            <i class="history-back-btn weui_icon_download" onclick="history.back()"></i>
            <p class="center-title">欢迎回来，<?php if(!empty($agent['user']['name'])) echo $agent['user']['name'] ?></p>
            <nav class="display-table nav-table">
                <ul class="">
                    <li><div>订单数<p><?php if(isset($agent['order_count'])) echo $agent['order_count'] ?></p></div></li>
                    <li><div>订单金额<p><?php if(isset($agent['order_fee_sum'])) echo sprintf('%.2f',$agent['order_fee_sum']/100) ?></p></div></li>
                    <li><div>当前收入<p><?php if(isset($agent['cash_sum'])) echo sprintf('%.2f',$agent['cash_sum']/100) ?></p></div></li>
                    <li><div>用户量<p><?php if(isset($agent['user_count'])) echo $agent['user_count'] ?></p></div></li>
                </ul>
            </nav>
            <div class="weui_cells weui_cells_access global_navs">
                <a class="slide_to weui_cell" href="javascript:;" data-id="detail">
                    <span class="weui_cell_hd"><img src="<?php echo $static_path?>/images/suggest.png" class="icon_nav" alt=""></span>
                    <div class="weui_cell_bd weui_cell_primary">
                        <p>商铺资料</p>
                    </div>
                    <div class="weui_cell_ft"></div>
                </a>
                <a class="slide_to weui_cell" href="javascript:;" data-id="option">
                    <span class="weui_cell_hd"><img src="<?php echo $static_path?>/images/suggest.png" class="icon_nav" alt=""></span>
                    <div class="weui_cell_bd weui_cell_primary">
                        <p>商铺基本设置</p>
                    </div>
                    <div class="weui_cell_ft"></div>
                </a>
                <a class="slide_to weui_cell" href="javascript:;" data-id="manage">
                    <span class="weui_cell_hd"><img src="<?php echo $static_path?>/images/suggest.png" class="icon_nav" alt=""></span>
                    <div class="weui_cell_bd weui_cell_primary">
                        <p>商品管理</p>
                    </div>
                    <div class="weui_cell_ft"></div>
                </a>
                <a class="weui_cell slide_to" href="javascript:;" data-id="order">
                    <span class="weui_cell_hd"><img src="<?php echo $static_path?>/images/order.png" class="icon_nav" alt=""></span>
                    <div class="weui_cell_bd weui_cell_primary">
                        <p>订单信息</p>
                    </div>
                    <div class="weui_cell_ft"></div>
                </a>
                <!--<a class="weui_cell slide_to" href="javascript:;" data-id="income">
                    <span class="weui_cell_hd"><img src="<?php echo $static_path?>/images/point.png" class="icon_nav" alt=""></span>
                    <div class="weui_cell_bd weui_cell_primary">
                        <p>收入详情</p>
                    </div>
                    <div class="weui_cell_ft"></div>
                </a>-->
            </div>
        </div>
        <!--<div class="weui_msg">
            <div class="weui_extra_area">
                <a href="">查看详情</a>
            </div>
        </div>-->
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
<!--todo：跳转页------------------------------------------------------------------------------------------------------->
<!--资料页-->
<script type="text/html" id="tpl_detail">
    <div class="page">
        <div class="hd small-hd">
            <h1 class="page_title">商铺资料</h1>
        </div>
        <div class="bd spacing">
            <article class="">
                <p class="qrcode-title tips-font">您的店铺首页二维码</p>
                <div class="qrcode-box">
                    <img src="?_a=web&_u=index.qrcode&url=<?php if(!empty($url)) echo rawurlencode($url) ?>">
                </div>
                <p class="qrcode-title active-font margin-bottom">
                    您可以保存二维码发送给朋友<br>
                    或者进入自己的商铺点击右上角转发<br>
                </p>
                <a href="<?php echo $url; ?>" class="weui_btn weui_btn_warn">点击进入我的商铺</a>
                <a href="javascript:;" class="boss-shop weui_btn weui_btn_primary margin-bottom">点击进入供货商的商铺</a>
            </article>
        </div>
    </div>
</script>
<!--订单页-->
<script type="text/html" id="tpl_option">
    <div class="page">
        <div class="hd small-hd">
            <h1 class="page_title">商铺设置</h1>
        </div>
        <div class="bd">
            <div class="weui_cells weui_cells_form">
                <div class="weui_cell">
                    <div class="weui_cell_hd"><label class="weui_label" style="width: 4em">店铺名称</label></div>
                    <div class="weui_cell_bd weui_cell_primary">
                        <input class="option-title weui_input" type="text" placeholder="请输入店铺名称" value="<?php if(!empty($agent['title'])) echo $agent['title'] ?>">
                    </div>
                </div>
                <div class="weui_cell">
                    <div class="weui_cell_hd"><label class="weui_label" style="width: 4em">店铺公告</label></div>
                    <div class="weui_cell_bd weui_cell_primary">
                        <input class="option-notice weui_input" type="text" placeholder="请输入店铺公告" value="<?php if(!empty($agent['notice'])) echo $agent['notice'] ?>">
                    </div>
                </div>
            </div>
            <div class="weui_btn_area">
                <a class="option-save-btn weui_btn weui_btn_primary" href="javascript:">保存</a>
            </div>
        </div>
    </div>
</script>
<!--商品管理页-->
<script type="text/html" id="tpl_manage">
    <div class="page">
        <div class="hd small-hd">
            <h1 class="page_title">商品管理</h1>
        </div>
        <div class="bd">
            <p class="manage-title weui_cells_title">您正在代理的商品</p>
            <article class="good-article agent-good-article"></article>
            <p class="manage-title2 weui_cells_title">您可以代理的商品</p>
            <article class="good-article agent-bad-article"></article>
        </div>
        <!--底部选择框-->
        <div id="manage_actionSheet_wrap">
            <div class="weui_mask weui_mask_transition"></div>
            <div class="weui_actionsheet">
                <div class="weui_actionsheet_menu">
                    <div class="actionsheet_change-title weui_actionsheet_cell">更改商品标题</div>
                    <div class="actionsheet_change-price weui_actionsheet_cell">更改商品价格</div>
                </div>
                <div class="weui_actionsheet_action">
                    <div class="weui_actionsheet_cell" id="manage_actionsheet_cancel">取消</div>
                </div>
            </div>
        </div>
        <!--input弹出框-->
        <div id="manage-input-dialog" class="weui_dialog_confirm" style="display: none">
            <!--<div class="weui_mask"></div>-->
            <div class="weui_dialog">
                <div class="weui_dialog_hd"><strong class="weui_dialog_title">更改标题</strong></div>
                <div class="weui_dialog_bd">
                    <div class="weui_cell" style="border:thin solid #e6e6e8">
                        <div class="weui_cell_bd weui_cell_primary">
                            <input class="weui_input" type="text" placeholder="请输入标题">
                        </div>
                    </div>
                </div>
                <div class="weui_dialog_ft">
                    <a href="javascript:;" class="weui_btn_dialog default">取消</a>
                    <a href="javascript:;" class="weui_btn_dialog primary">确定</a>
                </div>
            </div>
        </div>
        <div id="manage-input-dialog2" class="weui_dialog_confirm" style="display: none">
            <!--<div class="weui_mask"></div>-->
            <div class="weui_dialog">
                <div class="weui_dialog_hd">
                    <strong class="weui_dialog_title">更改价格</strong>
                    <small class="white-tips-font">/ 价格范围：<span id="price-range">25.00 - 44.00</span></small>
                </div>
                <div class="weui_dialog_bd">
                    <div class="weui_cell" style="border:thin solid #e6e6e8">
                        <div class="weui_cell_bd weui_cell_primary">
                            <input class="weui_input" type="number" placeholder="请输入价格">
                        </div>
                    </div>
                </div>
                <div class="weui_dialog_ft">
                    <a href="javascript:;" class="weui_btn_dialog default">取消</a>
                    <a href="javascript:;" class="weui_btn_dialog primary">确定</a>
                </div>
            </div>
        </div>
        <div class="toptips-price-range weui_toptips weui_warn js_tooltips">请填写价格范围内的数值</div>
    </div>
</script>
<!--订单页-->
<script type="text/html" id="tpl_order">
    <div class="page">
        <div class="hd small-hd">
            <h1 class="page_title">成交订单</h1>
        </div>
        <div class="bd">
            <article class="orders-article"></article>
        </div>
    </div>
</script>
<!--收入-->
<script type="text/html" id="tpl_income">
    <div class="page">
        <div class="hd small-hd">
            <h1 class="page_title">收入</h1>
        </div>
        <div class="bd">
            <article class="income-article">
                <section>

                </section>
            </article>
        </div>
    </div>
</script>
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
        $(function () {
            var $container = $('.slide_container');
            $container
                .on('click','#loading-btn', function () {
                    $('#loadingToast').show();
                    setTimeout(function () {
                        slide.go('result');
                        $('#loadingToast').hide();
                    }, 1000);
                })
            ;
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
                    id:'option',
                    callback: function () {
                        $('.option-save-btn').click(function () {
                            var data = {
                                title:$('.option-title').val(),
                                notice:$('.option-notice').val()
                            };
                            $.post('?_a=shop&_u=ajax.edit_shop_agent',data, function (ret) {
                                ret = JSON.parse(ret);
                                if(ret.errno==0){
                                    alert('保存成功');
                                    window.location.reload()
                                }
                            })
                        })
                    }
                },
                {
                    id:'order',
                    callback: function () {
                        /*seajs.use('css')*/
                        //$('#loadingToast').show();
                        function getProductStatus(status){
                            var status_array = {
                                '1':'待付款',
                                '2':'待发货',
                                '3':'待收货',
                                '4':'已收货',
                                '5':'已评论',
                                '6':'协商',
                                '8':'协商中',
                                '9':'卖家取消',
                                '10':'已取消',
                                '11':'待卖家确认'
                            };
                            if(status_array[status]){
                               return status_array[status]
                            }
                            else{
                                return '未知状态'
                            }
                        }
                        function getLocalTime(nS) {
                            function   formatDate(now) {
                                var year   = now.getYear();
                                var month  = now.getMonth()+1;
                                var date   = now.getDate();
                                var hour   = now.getHours();
                                var minute = now.getMinutes();
                                var second = now.getSeconds();
                                return year+"-"+month+"-"+date+"  "+hour+":"+minute+":"+second;
                            }
                            var date = new Date(parseInt(nS) * 1000);
                            return formatDate(date);
                            //return new Date(parseInt(nS) * 1000).toLocaleString().replace(/年|月/g, "-").replace(/日/g, " ");
                        }
                        $.getJSON('?_a=shop&_u=ajax.get_agent_order', function (ret) {
                            /*$('.page_title').click(function () {
                                window.location.reload()
                            });*/
                            console.log(ret,'a');
                            if(ret.errno==0){
                                var html = '';
                                $.each(ret.data.list, function (ind) {
                                    $.each(this['products'], function (index) {
                                        html+=
                                            ' <section class="good-section linear-section"> '+
                                            '<div class="good-section-left"> ' +
                                            '<img class="good-section-img" src="'+this['main_img']+'"> ' +
                                            '</div> ' +
                                            '<div class="good-section-right border-box"> ' +
                                            '<p class="good-section-title">'+this['title']+'</p> ' +
                                            '<p class="good-section-option small-text tips-font clearfix"> ' +
                                            '￥'+(this['paid_price']/100).toFixed(2)+' x '+this['quantity']+' ' +
                                            '<span class="big-text good-section-price secondary-font">￥'+(this['paid_price']/100*this['quantity']).toFixed(2)+'</span> </p> ' +
                                            '</div> ' +
                                            '</section>';
                                    });
                                    html+=
                                        '<section class="good-info-section small-text white-tips-font margin-bottom last-liner-section"> ' +
                                        '<div class="good-right-div clearfix"> ' +
                                        '<div style="float: left;text-align: left">' +
                                        getProductStatus(this['status'])+'，买家：' +this['user']['name']+
                                        '<p>订单时间：'+getLocalTime(this.create_time)+'</p>' +
                                        '</div>' +
                                        '<span>共'+this['products'].length+'件商品</span> 实付：<span class="secondary-font big-text">￥'+(this.paid_fee/100).toFixed(2)+'</span> ' +
                                        ((this.bonus&&this.bonus!='0')?'<p>交易成功，分红：<span class="big-text active-font">￥'+(this.bonus/100).toFixed(2)+'</span></p>':'' )+
                                        '</div> ' +
                                        '</section>';
                                });
                                if(html==''){html='<p>没有订单</p>'}
                                $('.orders-article').append(html)
                            }
                        })
                    }
                },
                {
                    id:'manage',
                    callback: function () {
                        $('#loadingToast').show();
                        /*正在代理商品*/
                        $.getJSON('?_a=shop&_u=ajax.get_agent_products', function (ret) {
                            console.log(ret);
                            if(ret.errno==0){
                                var html = '';
                                $.each(ret.data.list, function (index) {
                                    html+=
                                        '<section class="good-section linear-section" data-uid='+this.uid+' data-index='+index+'> ' +
                                        '<div class="good-section-left"><img class="good-section-img" src="'+this.main_img+'"></div> ' +
                                        '<div class="good-section-right border-box"> ' +
                                        '<p class="good-section-title">'+this.title+'</p> ' +
                                        //'<p class="good-section-option small-text tips-font"> 颜色:蓝色;尺寸:M </p> ' +
                                        '<p class="good-section-option small-text tips-font clearfix">' +
                                        '售价价格￥' +(parseInt(this.price)/100).toFixed(2)+
                                        '<span class="big-text good-section-price secondary-font">分红￥'+(parseInt(this.bonus)/100).toFixed(2)+'</span> ' +
                                        '</p> ' +
                                        '</div> ' +
                                        '</section> ' +
                                        '<section class="good-info-section small-text white-tips-font last-liner-section margin-bottom" data-uid='+this.uid+' data-index='+index+'> ' +
                                        '<div class="good-right-div btn-group"> ' +
                                        '<button data-title="'+this.title+'" data-price="'+(parseInt(this.price)/100).toFixed(2)+'" class="option-agent-btn color-disable">分销设置</button> ' +
                                        '<button data-status="'+this.status+'" class="product-status-btn color-'+((this.status==1)?"secondary":"green")+'">'+((this.status==1)?"下":"上")+'架中</button> ' +
                                        '</div> ' +
                                        '</section>';
                                });
                                if(html==''){$('.manage-title').text('您没有代理中的商品，在下面选择吧。')}
                                /*底部选框隐藏*/
                                function hideSheet(sheet, mask) {
                                    sheet.removeClass('weui_actionsheet_toggle');
                                    mask.removeClass('weui_fade_toggle');
                                    sheet.on('transitionend', function () {
                                        mask.hide();
                                    }).on('webkitTransitionEnd', function () {
                                        mask.hide();
                                    });
                                    $('#manage-input-dialog').hide();
                                    $('#manage-input-dialog2').hide()
                                }

                                $('.agent-good-article').append(html)
                                    /*分销设置*/
                                    .on('click','.option-agent-btn', function () {
                                        var uid = $(this).closest('.good-info-section').data('uid');
                                        var index = $(this).closest('.good-info-section').data('index');
                                        var title = $(this).data('title');
                                        var price = $(this).data('price');

                                        var action_content = $('#manage_actionSheet_wrap');
                                        var mask = action_content.children('.weui_mask');
                                        var sheet = action_content.children('.weui_actionsheet');
                                        sheet.unbind('transitionend').unbind('webkitTransitionEnd')
                                            .addClass('weui_actionsheet_toggle')
                                            .find('.weui_actionsheet_cell').unbind('click')//小心误伤
                                        ;
                                        mask.show().addClass('weui_fade_toggle').click(function () {
                                            hideSheet(sheet, mask);
                                        });
                                        $('#manage_actionsheet_cancel').click(function () {
                                            hideSheet(sheet, mask);
                                        });
                                        /*更改按钮*/
                                        var input_content = $('#manage-input-dialog');
                                        var input_content2 = $('#manage-input-dialog2');
                                        sheet.find('.actionsheet_change-title').click(function () {
                                            input_content2.hide();
                                            input_content.show().find('.weui_input').val(title);
                                        });
                                        sheet.find('.actionsheet_change-price').click(function () {
                                            input_content.hide();
                                            input_content2.show().find('.weui_input').val(price);
                                            /**/
                                            var price_range = ret.data.list[index]['agent_product'];
                                            input_content2.find('#price-range').text((price_range['price_l']/100).toFixed(2)+' - '+(price_range['price_h']/100).toFixed(2))
                                        });
                                        /*弹出框按钮*/
                                        input_content.find('.weui_btn_dialog').unbind().click(function () {
                                            if($(this).hasClass('primary')){
                                                //var uid = input_content.data('uid');
                                                var title = input_content.find('.weui_input').val();
                                                var data = {
                                                    uid:uid,
                                                    title:title
                                                };
                                                $.post('?_a=shop&_u=ajax.edit_shop_agent_to_user_product',data,function (ret) {
                                                    ret = JSON.parse(ret);
                                                    if(ret.errno==0){window.location.reload()}
                                                })
                                            }
                                            else{
                                                input_content.hide()
                                            }
                                        });
                                        input_content2.find('.weui_btn_dialog').unbind().click(function () {
                                            if($(this).hasClass('primary')){
                                                //var uid = input_content.data('uid');
                                                var price = input_content2.find('.weui_input').val();
                                                var data = {
                                                    uid:uid,
                                                    price:price*100
                                                };
                                                $.post('?_a=shop&_u=ajax.edit_shop_agent_to_user_product',data,function (ret) {
                                                    ret = JSON.parse(ret);
                                                    if(ret.errno==0){window.location.reload()}
                                                    else{
                                                        $('.toptips-price-range').show();
                                                        setTimeout(function () {
                                                            $('.toptips-price-range').hide();
                                                        },1500)
                                                    }
                                                })
                                            }
                                            else{
                                                input_content2.hide()
                                            }
                                        })

                                    })
                                    /*上下架*/
                                    .on('click','.product-status-btn', function () {
                                        var status = parseInt($(this).data('status'));//这里传不进去
                                        var title = '';
                                        console.log(status);
                                        if(status==1)   {title = '您确定要上架商品吗？'}
                                        else            {title = '您确定要下架商品吗？'}
                                        weui_comfirm({
                                            hook:this,
                                            title:title,
                                            //tips:'您真的真的？确定要上架吗？',
                                            onConfirm: function () {
                                                var uid = $(this.hook).closest('.good-info-section').data('uid');
                                                //var status = parseInt($(this.hook).data('status'));
                                                var data = {
                                                    uid:uid,
                                                    status:1-status
                                                };
                                                $.post('?_a=shop&_u=ajax.edit_shop_agent_to_user_product',data,function (ret) {
                                                    ret = JSON.parse(ret);
                                                    if(ret.errno==0){window.location.reload()}
                                                })
                                            }
                                        });
                                    })
                                ;
                                $('#loadingToast').hide();
                            }
                        });
                        /*可以代理商品*/
                        $.getJSON('?_a=shop&_u=ajax.add_agent_products', function (ret) {
                            console.log(ret);
                            if(ret.errno==0){
                                var html = '';
                                $.each(ret.data.list, function () {
                                    html+=
                                        '<section class="good-section linear-section" data-uid="'+this.uid+'"> ' +
                                        '<div class="good-section-left"><img class="good-section-img" src="'+this.main_img+'"></div> ' +
                                        '<div class="good-section-right border-box"> ' +
                                        '<p class="good-section-title">'+this.title+'</p> ' +
                                        '<p class="good-section-option small-text tips-font clearfix">' +
                                        '售价价格￥' +(parseInt(this.price)/100).toFixed(2)+
//                                        '<span class="big-text good-section-price secondary-font">分红￥'+(parseInt(this.bonus)/100).toFixed(2)+'</span> ' +
                                        '</p> ' +
                                        '</div> ' +
                                        '</section> ' +
                                        '<section class="good-info-section small-text white-tips-font last-liner-section margin-bottom" data-uid="'+this.uid+'"> ' +
                                        '<div class="good-right-div btn-group"> ' +
                                        '<button class="apply-agent-btn color-primary">申请分销</button> ' +
                                        '</div> ' +
                                        '</section>';
                                });
                                if(html==''){$('.manage-title2').text('没有可以代理的商品了')}
                                $('.agent-bad-article').append(html)
                                    /*申请分销*/
                                    .on('click','.apply-agent-btn', function () {
                                        weui_comfirm({
                                            hook:this,
                                            title:'您确定要分销此商品吗？',
                                            onConfirm: function () {
                                                var uid = $(this.hook).closest('.good-info-section').data('uid');
                                                var data = {
                                                    p_uids:uid
                                                };
                                                $.post('?_a=shop&_u=ajax.add_shop_agent_to_user_product',data, function (ret) {
                                                    console.log(ret);
                                                    ret = JSON.parse(ret);
                                                    if(ret.errno==0){
                                                        window.location.reload()
                                                    }
                                                })
                                            }
                                        });
                                    })
                                ;
                                $('#loadingToast').hide();
                            }
                        })
                    }
                }
            ];
            /*加入回调*/
            $.each(callback_arr, function () {
                slide.slideCallback(this);
            });
            /*载入页面调用回调*/
            if (/#.*/gi.test(location.href)) {
                var now_hash = location.hash.slice(1);
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
    })
</script>
</body>
</html>