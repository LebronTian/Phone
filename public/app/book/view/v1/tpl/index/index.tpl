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
<title>门店预约</title>
<link rel="stylesheet" href="/static/css/weui0.42.css" />
<link href="/static/css/font-awesome-4.6.3/css/font-awesome.min.css" rel="stylesheet">
<link rel="stylesheet" href="<?php echo $static_path;?>/css/index.css" />

<style>
body{
	min-width: 320px;
}
@media screen and (device-aspect-ratio: 2/3) {
	.shop_module_slist .banner_logo{top:40px;}
	.shop_module_slist .category_list{bottom:40px;}
	.ratio2{
		.shop_module_slist .banner_logo{top:80px;}
		.shop_module_slist .category_list{bottom:80px;}
	}
}
	.shop_module_floor .goods_item .price{
		font-size: 3.1vw;
		font-family: "微软雅黑";
	}
	.weui_btn.weui_btn_mini{
		font-size: 13px;
	}
    #to_search{
        position: absolute;
        right: 10px;
        top: 1px;
    }
    #search_bar{
        z-index: 1;
    }
    .to_share_btn{
        -webkit-box-shadow: 0 0.5px 1px 0 rgba(0, 0, 0, 0.6);
        -webkit-border-radius: 50%;
        margin: 0 5px 0 0;
        display: inline-block;
        width: 18px;
        height: 18px;
        text-align-last: center;
        line-height: 22px;
        font-size: 10px;
        text-align: center;
    }
    .to_share_btn i{
        text-align: center;
        color: #888;
    }
.swiper-wrapper img {
/*max-height:100%;*/
display:none;
}
.ccat li{
width:25%;
float:left;
list-style:none;
height:128px;
text-align:center;
}
.ccat li a{
color:gray;
font-size:12px;
height:12px;
line-height:12px;
}
.ccat li img{
max-width:100%;
max-height:100%;
}
.weui_navbar_item.weui_bar_item_on {
    background-color: #04BE02;
    color: white;
}
</style>
</head>

<script>
    if(window.scale==0.5){document.write('<body class="zh_CN ratio2">');}
    else{document.write('<body class="zh_CN">');}
</script>

<div>
    <nav>
        <div class="nav-swiper-container">
            <div class="swiper-wrapper">
                <?php
                if(!empty($slides)){
                    foreach($slides as $s){
                        ?>
                        <div class="swiper-slide ">
                            <a href="<?php echo $s['link'] ?>">
                                <img class="slide-img index-nav-scale banner_pic" src="<?php echo $s['image'] ?>">
                            </a>
                        </div>
                        <?php
                    }
                }
                ?>
            </div>
            <div class="swiper-count-box">
                <span class="active-index-num">1</span> / <span class="all-index-num">1</span>
            </div>
        </div>
    </nav>

	<nav>
	<ul class="ccat">
<?php
if(!empty($slides2)){
$html = '';
foreach($slides2 as $s) {
$html .= '<li><a href="'.($s['link'] ? $s['link'] : 'javascript:;').
		'"><img src="'.$s['image'].'"><p>'.$s['title'].'</p></a></li>';
}
echo $html;
}
?>
	</ul>
	</nav>
</div>
<div class="weui_navbar" style="position: relative;">
<?php
if(!empty($all_type)) {
if(!$option['type']) $option['type'] = current($all_type);
$html = '';
foreach($all_type as $t) {
	$html .= '<div class="weui_navbar_item';
	if($option['type'] == $t) $html .= ' weui_bar_item_on';
	$html .= '">'.$t.'</div>';
}
echo $html;
}
?>
</div>
<div class="weui_search_bar" id="search_bar" style="display:none;">
    <div class="weui_search_outer">
        <div class="weui_search_inner">
            <i class="weui_icon_search"></i>
            <input type="search" class="weui_search_input" id="search_input" placeholder="输入商品" required="" value="<?php echo $option['key'];?>">
            <a href="javascript:" class="weui_btn weui_btn_mini weui_btn_default" id="to_search">搜索</a>
        </div>

    </div>
    <a href="javascript:" class="weui_search_cancel" id="search_cancel">取消</a>
</div>
<div class="wx_page weui_tab">
    <div class="wx_body weui_tab_bd">
        <div class="wap_shop_module_list">

            <div class="shop_module_item shop_module_floor js_shopModuleWrapper">
                <div class="shop_module_bd">
                    <ul class="goods_list">
                    </ul>
                </div>
            </div>
            <!--
            <a href="javascript:;" class="more_link">更多兑换商品</a>
            -->
        </div>
    </div>

<?php 
	include($tpl_path.'/footer.tpl'); 
	include($tpl_path.'/buy.tpl'); 
?>
</div>
<script id="id_tpl" type="text/tpl">
<li class="goods_item wx_product">
    <a href2="?_a=book&_u=index.itemdetail&uid={{=it.uid}}">
        <img class="cover" src="{{=it.main_img}}">
    </a>
    <strong class="title">{{=it.title}}</strong>
    <span class="price">
    {{? it.point_price > 0}}<a>{{=it.point_price}}</a>积分{{?}}
    {{? it.point_price > 0 &  it.price > 0}} + {{?}}
    {{? it.price > 0}}<a>{{=it.price/100}}</a>元{{?}}</span>
    {{? it.quantity != 0}}
    <span class="weui_btn weui_btn_mini weui_btn_primary duihuan" style="display:inline-block;float:right;"
    data-uid="{{=it.uid}}">预约</span>
    {{??}}
    <span class="weui_btn weui_btn_mini weui_btn_default " style="display:inline-block;float:right;"
    data-uid="{{=it.uid}}">已兑完</span>
    {{?}}

    </li>&nbsp;
	<script type="text/javascript">
		var imgw=$('.shop_module_floor .goods_item a img').width();
        $('.shop_module_floor .goods_item a img').height(imgw*0.73);
	</script>
</script>
<script src="/static/js/jquery2.1.min.js"></script>
<script src="/static/js/jquery.cookie.js"></script>
<script src="/static/js/doT.min.js"></script>
<script src="/static/js/scroll_load.js"></script>
<script>
    var g_uid = 0;
    var type= "<?php echo $option['type'];?>"
    var key = "<?php echo $option['key'];?>"

</script>
</body>

<script src="<?php echo $static_path;?>/js/sea.js"></script>
<script src="<?php echo $static_path;?>/js/seajs-css.js"></script>
<script src="<?php echo $static_path;?>/js/index.js?2"></script>
<!--<script src="/static/js/seajs-preload.js"></script>-->
<!--<script src="/static/js/seajs_option.js"></script>-->
<script>

    var static_path  = "<?php echo $static_path;?>";
    var su_uid = "<?php echo AccountMod::has_su_login();?>";
    seajs.config({
        charset: 'utf-8',
        paths:{
            'js':static_path+'/js',
            'css':static_path+'/css',
            'seajs':static_path+'/seajs'
        },
        alias: {
//            'zepto':'js/zepto.min.js',
            'swiper_js':'css/swiper/swiper.min.js',
            'swiper_min_css':'css/swiper/swiper.min.css',
            'swiper_css':'css/swiper.css',
        }
//        , preload:'style'
    });
    seajs.use(['swiper_js','swiper_css','swiper_min_css']);
    $(document).ready(function () {
	$('.swiper-wrapper img').css('height', $('body').width()/2).show();
        seajs.use('seajs/swiper');
    });
    $('.weui_navbar').on('click', '.weui_navbar_item', function () {
        $(this).addClass('weui_bar_item_on').siblings('.weui_bar_item_on').removeClass('weui_bar_item_on');
        window.location.href = '?_a=book&_u=index.index&type='+$(this).text()+"&key="+$('#search_input').val()
    });
    scroll_load({'ele_container': '.goods_list', 'ele_dot_tpl': '#id_tpl', 'g_data_name': 'g_goods',
        'url': '?_a=book&_u=ajax.book_item_list&type='+type+"&key="+key, 'onfinish': function(){
            $('.goods_list').after('<p style="text-align:center;color:gray;">没有更多了。。。</p>');
        }});
    $('#to_search').on('click',function(){
        window.location.href = '?_a=book&_u=index.index&type='+type+"&key="+$('#search_input').val()
    })
</script>
</html>
