<!doctype html>
<html class="no-js">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>深圳市快马加鞭科技有限公司 - 专业微信小程序开发</title>
  <meta name="description" content="微信公众号订阅号服务号精致设计极速开发">
  <meta name="keywords" content="三级分销 分销商城 微信公众号 定制开发 微信营销 微信小程序">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
  <meta name="renderer" content="webkit">
  <meta http-equiv="Cache-Control" content="no-siteapp" />

  <link rel="shortcut icon" href="/favicon.ico"/>
  <link rel="stylesheet" type="text/css" href="/static/css/typo.css">
  <link rel="stylesheet" type="text/css" href="/app/web/static/css/index2.css">
 
<style type="text/css">
    #headBox{
		margin: 0 auto;
        width: 100%;
        height: 70px;
        z-index: 99;
		position:fixed;
    }
    .section{ position: relative;}
    .logo{
        display: inline-block;
        margin-left: 88px;
        margin-top: 9px;
    }
    .headNav{
        position: absolute;
        top: 2px;
        right: 120px;
		line-height:70px;
    }
    .headNav li{
        float: left;
    }
    .headNav li a{
        display: inline-block;
        padding: 0 20px;
        color: #FFF;
        font-size: 18px;
    }
    .select_menu{
        z-index: 99;
        width: 142px;
        display: none;
        position: absolute;
        left: 20px; top: 48px;
        padding: 5px 5px 10px;
        text-align: left;
        background: rgba(0,0,0,0.8);
    }
    .select_menu li{ width: 100%; height: 48px; line-height: 48px;}
    .select_menu li a{ font-size: 18px; padding: 0;}
    .fl li:nth-child(1)>a{
        color: #39f;
    }
#headBox {
	background: #333;
	overflow:hidden;
}
.cnavbtn {
height:24px;padding:5px;
line-height:24px;
margin-top:24px;
border:1px solid white;
}
.cnavbtn:hover {
color:#39f;
border-color:#39f;
text-decoration:none;
}
.introduce-list .list {
cursor:pointer;
float:left;
width:24%;
margin-bottom: 40px;
font-size:20px;
text-align:center;
color:#666;
}
.introduce-list .list:hover {
box-shadow: 2px 2px 25px 5px rgba(0, 0, 0, 0.1);
color:#333;
transition: all .3s ease;
}

</style>
</head>
<body style="min-width:1170px">
<script src="/static/js/jquery2.1.min.js"></script>
    <div class="main-body">

<div id="headBox">
<?php if(IndexCtl::is_spider_agent()) {?>
 <a href="?_a=web" class="logo"><img style="display:inline-block;height:110px;margin-top:-27px;" src="/static/images/kuaimalogo2.jpg" alt="深圳快马加鞭 专业微信小程序开发制作"></a>
<?php } else { ?>
<a href="?_a=web" class="logo"><img style="display:inline-block;height:54px;" src="/app/web/static/images/blue/logo1.gif" alt="logo"></a>
<?php } ?>

    <ul class="headNav">
        <li style="position:relative;" class="select_li">
          <a href="javascript:;">产品服务<span>+</span></a>
          <ul class="select_menu">
               <li><a href="http://msms.uctphp.com">自助短信群发</a></li>
               <li><a href="javascript:;">商城小程序</a></li>
               <li><a href="javascript:;">商城公众号</a></li>
          </ul>
        </li>
		<li><a href="javascript:;" id="id_dingzhi" class="cnavbtn">定制开发</a></li>
		<li style="font-size:32px;color:#39f;margin:0 20px 0 40px;"><img src="/static/images/phone.png"> 15820425082 </li>
        <li><a href="?_a=sp&_u=index.login" class="cnavbtn">后台登录</a> /
            <a href="?_a=sp&_u=index.register" class="cnavbtn">免费试用</a> /
            <a href="?_a=web&_u=index.problemlist" class="cnavbtn">常见问题</a></li>
    </ul>
</div>

    <div class="sliderbar hidden-xs">
        <div class="sliderbar-phone" style="top: 210px!important;">
            <div class="sliderbar-item"></div>
            <img src="/static/images/phone.png">
        </div>
     
        <div class="sliderbar-phone-show" style="top: 210px !important; display: none;">
            客服热线: 15820425082
        </div>
        
        <div class="sliderbar-qrcode" style="top: 280px!important;">
            <div class="sliderbar-item"></div>
            <img src="/static/images/qrcode_logo.png">
        </div>
        <div class="sliderbar-qrcode-show" style="top: 280px !important; display: none;">
            <!--<img src="/static/images/qrcode.jpg">-->
            <img src="?_a=upload&_u=index.out&uidm=18483528d">
        </div>
        
        <div class="sliderbar-top" style="top:350px!important">
            <a id="goTop" class="fl" title="去顶部" href="javascript:void(0)"></a>
        </div>
    </div>

<script src="http://qzs.qq.com/tencentvideo_v1/js/tvp/tvp.player.js" charset="utf-8"></script>

<div id="id_video_k" style="position:fixed;z-index:88" >
<!--
<iframe frameborder="0" width="100%" height="100%" src="https://v.qq.com/iframe/player.html?vid=l055224bxvf&tiny=1&auto=1&showend=0&outhost=http%3A%2F%2Fweixin.uctphp.com%2F%3F_a%3Dupload%26_u%3Dindex.out%26uidm%3D17613e803" allowfullscreen></iframe>
-->
</div>
<script>
document.getElementById("id_video_k").style.height=(document.documentElement.clientHeight-72)+"px";
var video = new tvp.VideoInfo();
video.setVid("l055224bxvf");
var player;
player = new tvp.Player('100%', '100%');
//设置播放器初始化时加载的视频
player.setCurVideo(video);
//设置精简皮肤，仅点播有效
player.addParam("flashskin", "http://imgcache.qq.com/minivideo_v1/vd/res/skins/TencentPlayerMiniSkin.swf");
//输出播放器,参数就是上面div的id，希望输出到哪个HTML元素里，就写哪个元素的id
player.addParam("pic", "http://weixin.uctphp.com/?_a=upload&_u=index.out&uidm=17613e803");
player.addParam("autoplay", "1");
player.addParam("wmode", "transparent");
//player.addParam("showcfg", "0");
player.addParam('showend', 0);
player.write("id_video_k");
</script>

    <div class="mfapp-wrap">
        <div class="mfapp" style="">
            <div class="tit tc">
                <h2 class="green">快马加鞭 · 主营业务</h2>
                <p class="grey mt5">微信小程序·公众号·网站建设·APP开发</p>
            </div>
            <div class="have-cont">
                <div class="have-div">
                    <div class="course">
                        <ul class="list1 clearfix">
                            <li class="item-li">
                                <div class="cover-show">
                                    <a href="javascript:;" class="pic">
                                        <img src="http://weixin.uctphp.com/?_a=upload&_u=index.out&uidm=17613e803" alt="">
                                    </a>
                                </div>
                                <div class="details">
                                    <h3><a style="font-weight: 500;color: #333;text-decoration: none;">专业团队</a>
                                    
                                    </h3>
                                    <p class="rule">
专业开发团队, 腾讯、阿里、百度级别的技术工程师
                                    </p>
                                </div>
                            </li>

                            <li class="item-li">
                                <div class="cover-show">
                                    <a href="javascript:;" class="pic">
                                        <img src="http://weixin.uctphp.com/?_a=upload&_u=index.out&uidm=176146c31" alt="">
                                    </a>
                                </div>
                                <div class="details">
                                    <h3><a style="font-weight: 500;color: #333;text-decoration: none;">专业产品</a>
                                    </h3>
                                    <p class="rule">2年商城系统开发技术沉淀 5000+次产品迭代开发与打磨
                                    </p>
                                    </a><h5>
                                </div>
                            </li>

                            <li class="item-li">
                                <div class="cover-show">
                                    <a href="javascript:;" class="pic">
                                        <img src="?_a=upload&_u=index.out&uidm=17611eca6" alt="">
                                    </a>
                                </div>
                                <div class="details">
                                    <h3><a style="font-weight: 500;color: #333;text-decoration: none;">自主开发</a>
                                    </h3>
                                    <p class="rule">真正具备技术开发与定制实力， 非中间代理商
                                    </p>
                                </div>
                            </li>

                            <li class="item-li">
                                <div class="cover-show">
                                    <a href="javascript:;" class="pic">
                                        <img src="?_a=upload&_u=index.out&uidm=18278d5d9" alt="">
                                    </a>
                                </div>
                                <div class="details">
                                    <h3><a style="font-weight: 500;color: #333;text-decoration: none;">极速开发</a>
                                    </h3>
                                    <p class="rule">小程序上线成功后再付款，不满意不收费
                                    </p>
                                </div>
                            </li>

                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div> 

    <div class="mfapp-wrap">
        <div class="mfapp">
            <div class="tit tc">
                <h2 class="green">快马加鞭 · 小程序开发</h2>
                <p class="grey mt5">微信小程序系统</p>
            </div>
            <div class="have-cont">
                <div class="have-div">
                    <div class="course">
                        <ul class="list clearfix">
<?php
$ps = Dba::readAllAssoc('select * from product where shop_uid = 5 && cat_uid in(135,136)');
$html = '';
if($ps)
foreach($ps as $p) {
$html.='<li class="item-li">
	<div class="cover-show">
	<a href="javascript:;" class="pic">
		<img src="'.$p['main_img'].'" alt="">
	</a>
	</div>
	<div class="details">
		<h3><a href="javascript:;">'.$p['title'].'</a>
		<!-- <span class="large-font fr red">￥0.00/年</span> -->
		</h3>
	<p class="rule">'.$p['title_second'].'</p>
	</div></li>';
}
echo $html;
?>


                        </ul>
                    </div>
                </div>
            </div>
            <p class="sec-more" style="display: none;"><a class="btn" href="javascript:;">更多应用</a></p>
        </div>
    </div>
    <div class="case-wrap">
        <div class="case">
            <div class="tit tc">
                <h2 class="green">小程序案例</h2>
                <p class="grey mt5">各式小程序案例，请搜索小程序名称进行体验</p>
            </div>
            <div class="case-list">
                <ul class="clearfix">
                    <li>
                        <div class="case-box">
                            <div class="case-m">
                                <div class="case-img">
                                    <img style="" class="thumb" src="?_a=upload&_u=index.out&uidm=17654e5c6" width="70" height="70">
                                </div>
                                <h3>快马加鞭</h3>
                                <p class="small-font mt5 grey">官方小程序</p>
                            </div>
                        </div>
                        <div class="test-app">
                            <img style="" src="/static/images/qrcode.jpg" width="50%">
                        </div>
                    </li>
                    <li>
                        <div class="case-box">
                            <div class="case-m">
                                <div class="case-img">
                                    <img style="" class="thumb" src="?_a=upload&_u=index.out&uidm=17654e5c6" width="70" height="70">
                                </div>
                                <h3>糖果玩具</h3>
                                <p class="small-font mt5 grey">批发商城小程序</p>
                            </div>
                        </div>
                        <div class="test-app">
                            <img style="" src="/static/images/qrcode.jpg" width="50%">
                        </div>
                    </li>

                    <li>
                        <div class="case-box">
                            <div class="case-m">
                                <div class="case-img">
                                    <img style="" class="thumb" src="?_a=upload&_u=index.out&uidm=17654e5c6" width="70" height="70">
                                </div>
                                <h3>绿色日化与美容养生</h3>
                                <p class="small-font mt5 grey">日化商城小程序</p>
                            </div>
                        </div>
                        <div class="test-app">
                            <img style="" src="/static/images/qrcode.jpg" width="50%">
                        </div>
                    </li>

                    <li>
                        <div class="case-box">
                            <div class="case-m">
                                <div class="case-img">
                                    <img style="" class="thumb" src="?_a=upload&_u=index.out&uidm=17654e5c6" width="70" height="70">
                                </div>
                                <h3>玉镯玉佛观音翡翠珠宝商城</h3>
                                <p class="small-font mt5 grey">珠宝玉器商城小程序</p>
                            </div>
                        </div>
                        <div class="test-app">
                            <img style="" src="/static/images/qrcode.jpg" width="50%">
                        </div>
                    </li>

                    <li>
                        <div class="case-box">
                            <div class="case-m">
                                <div class="case-img">
                                    <img style="" class="thumb" src="?_a=upload&_u=index.out&uidm=17654e5c6" width="70" height="70">
                                </div>
                                <h3>舒压宝</h3>
                                <p class="small-font mt5 grey">音乐舒压小程序</p>
                            </div>
                        </div>
                        <div class="test-app">
                            <img style="" src="/static/images/qrcode.jpg" width="50%">
                        </div>
                    </li>

                    <li>
                        <div class="case-box">
                            <div class="case-m">
                                <div class="case-img">
                                    <img style="" class="thumb" src="?_a=upload&_u=index.out&uidm=17654e5c6" width="70" height="70">
                                </div>
                                <h3>机票宝</h3>
                                <p class="small-font mt5 grey">机票预订小程序</p>
                            </div>
                        </div>
                        <div class="test-app">
                            <img style="" src="/static/images/qrcode.jpg" width="50%">
                        </div>
                    </li>

                    <li>
                        <div class="case-box">
                            <div class="case-m">
                                <div class="case-img">
                                    <img style="" class="thumb" src="?_a=upload&_u=index.out&uidm=17654e5c6" width="70" height="70">
                                </div>
                                <h3>快递包裹短信通知</h3>
                                <p class="small-font mt5 grey">快递包裹查询小程序</p>
                            </div>
                        </div>
                        <div class="test-app">
                            <img style="" src="/static/images/qrcode.jpg" width="50%">
                        </div>
                    </li>

                    <li>
                        <div class="case-box">
                            <div class="case-m">
                                <div class="case-img">
                                    <img style="" class="thumb" src="?_a=upload&_u=index.out&uidm=17654e5c6" width="70" height="70">
                                </div>
                                <h3>芒格学院</h3>
                                <p class="small-font mt5 grey">在线教育小程序</p>
                            </div>
                        </div>
                        <div class="test-app">
                            <img style="" src="/static/images/qrcode.jpg" width="50%">
                        </div>
                    </li>

                    <li>
                        <div class="case-box">
                            <div class="case-m">
                                <div class="case-img">
                                    <img style="" class="thumb" src="?_a=upload&_u=index.out&uidm=17654e5c6" width="70" height="70">
                                </div>
                                <h3>图索挪车</h3>
                                <p class="small-font mt5 grey">挪车通知小程序</p>
                            </div>
                        </div>
                        <div class="test-app">
                            <img style="" src="/static/images/qrcode.jpg" width="50%">
                        </div>
                    </li>

                </ul>
            </div>
        </div>
    </div>

		<div class="mfapp-wrap mfapp">
			<div class="tit tc">
        	<h2 class="">小程序价值</h2>
        	<p class="grey">微信小程序，赋能门店商户</p>
			</div>
        	<ul class="introduce-list">
        		<li class="list">
        			<div class="list-title">共享9亿微信用户</div>
        		</li>
        		<li class="list">
        			<div class="list-title">无需安装，降低获客成本</div>
        		</li>
        		<li class="list">
        			<div class="list-title">性能强劲，与APP无差异</div>
        		</li>
        		<li class="list">
        			<div class="list-title">与微信公众号无缝对接</div>
        		</li>
        	</ul>

			<div class="tit tc" style="clear:both;margin-top:120px;">
        	<h2 class="">免费流量入口</h2>
        	<p class="grey">小程序核心使用场景</p>
			</div>
        	<ul class="introduce-list">
        		<li class="list">
        			<div class="list-title">线下小程序码</div>
        		</li>
        		<li class="list">
        			<div class="list-title">微信搜索关键字</div>
        		</li>
        		<li class="list">
        			<div class="list-title">附近的小程序</div>
        		</li>
        		<li class="list">
        			<div class="list-title">转发到微信群</div>
        		</li>
        		<li class="list">
        			<div class="list-title">转发给好友</div>
        		</li>
        		<li class="list">
        			<div class="list-title">使用历史列表</div>
        		</li>
        		<li class="list">
        			<div class="list-title">发现小程序入口</div>
        		</li>
        		<li class="list">
        			<div class="list-title">公众号相关小程序</div>
        		</li>
        		<li class="list">
        			<div class="list-title">公众号自菜单跳转</div>
        		</li>
        		<li class="list">
        			<div class="list-title">公众号文章链接跳转</div>
        		</li>
        		<li class="list">
        			<div class="list-title">小程序直接打开小程序</div>
        		</li>
        		<li class="list">
        			<div class="list-title">公众号关联绑定通知</div>
        		</li>
        	</ul>
        </div>


		<div class="mfapp-wrap mfapp" style="clear:both;">
			<div class="tit tc">
        	<h2 class="">合作伙伴</h2>
        	<p class="grey">多家客户的共同选择</p>
			</div>
        	<ul class="introduce-list">
        		<li class="list">
					<img src="/app/web/static/images/customer/aishi_logo.png">
        		</li>
        		<li class="list">
					<img src="/app/web/static/images/customer/jiuyangLogo.png">
        		</li>
        		<li class="list">
					<img src="/app/web/static/images/customer/minions_logo.png">
        		</li>
        		<li class="list">
					<img src="/app/web/static/images/customer/chuangxin_logo.png">
        		</li>
        		<li class="list">
					<img src="/app/web/static/images/customer/youyuan_logo_b.png">
        		</li>
        		<li class="list">
					<img src="/app/web/static/images/customer/zuoke_logo.png">
        		</li>
        		<li class="list">
					<img src="/app/web/static/images/customer/raven_logo.png">
        		</li>
        		<li class="list">
					<img src="/app/web/static/images/customer/nvxing_logo.png">
        		</li>
        	</ul>
		</div>

    <div class="foot" style="background:#333;clear:both;margin-top:60px;">
        <div class="f-box small-font tc">
            <div class="copy grey">
                    <p>Copyright©2017 快马加鞭 
| <a2 href2="http://www.hxunt.com">环讯通</a2> 
| 贝海股份 
| 浏览中华 
| 粤ICP备14048871号 </p>
                    <p>联系电话： 15820425082 (微信同号)</p>
                    <p>深圳市南山区TCL国际E城多媒体大厦</p>
            </div>
        </div>
    </div>
</body>
<script>
    $(function () {
        
            var $li = $('.fl li');
            var $ul = $('#content ul');

            $li.click(function () {
                var $this = $(this);
                var $t = $this.index();
                $li.removeClass();
                $this.addClass('');
                $ul.css('display', 'none');
                $ul.eq($t).css('display', 'block');
                
            })
        
    });
    $(".sliderbar-qqa").mouseover(function() {
        $(this).find(".sliderbar-item").addClass("active");

        $(".sliderbar-qqa-show").show();
    });

    $(".sliderbar-qqa").mouseout(function() {
        $(".sliderbar-qqa .sliderbar-item").removeClass("active");

        $(".sliderbar-qqa-show").hide();
    });
</script>
<script type="text/javascript">
      $(".imenu").eq(1).hover(function () {
            if ($(this).find('.submnu').length) {
                $(this).find('.submnu').show();
            }
        }, function () {
            if ($(this).find('.submnu').length) {
                $(this).find('.submnu').hide();
            }
        });
        </script>
</html>

    
    


<script type="text/javascript" src="/app/web/static/js/header.js"></script>
<script>
var _hmt = _hmt || []; (function() { var hm = document.createElement("script"); 
<?php 
if(in_array(getDomainName(), array('szkmjb.com', 'www.szkmjb.com'))) {
echo 'hm.src = "https://hm.baidu.com/hm.js?0a71c1ded60c38f42604df66543ff764"; ';
} else {
echo 'hm.src = "https://hm.baidu.com/hm.js?b2c0f69b4be690c85ed03c254da6e723"; ';
}
?>
var s = document.getElementsByTagName("script")[0]; 
s.parentNode.insertBefore(hm, s); })(); </script> 

<script>
//在线客服
$(function() {
    $(window).scroll(function() {
        if ($(window).scrollTop() > 800) {
            $(".sliderbar-up").fadeIn(500);
        } else {
            $(".sliderbar-up").fadeOut(500);
        }
    });

    $(".sliderbar-qq:eq(0)").click(function() {
        window.open(
            "http://wpa.qq.com/msgrd?v=3&uin=3367414088&site=qq&menu=yes"
        );
        return false;
    });

    $(".sliderbar-qq:eq(1)").click(function() {
        window.open(
            "http://wpa.qq.com/msgrd?v=3&uin=1642709442&site=qq&menu=yes"
        );
        return false;
    });

    $(".sliderbar-up").click(function() {
        $("body, html").animate({ scrollTop: 0 }, 1000);
        return false;
    });

    $(".sliderbar-up").mouseover(function() {
        $(".sliderbar-up .sliderbar-item").addClass("active");

        $(".sliderbar-up-show").show();
    });

    $(".sliderbar-up").mouseout(function() {
        $(".sliderbar-up .sliderbar-item").removeClass("active");

        $(".sliderbar-up-show").hide();
    });

    $(".sliderbar-qq").mouseover(function() {
        $(this).find(".sliderbar-item").addClass("active");

        $(".sliderbar-qq-show").show();
    });

    $(".sliderbar-qq").mouseout(function() {
        $(".sliderbar-qq .sliderbar-item").removeClass("active");

        $(".sliderbar-qq-show").hide();
    });

    $(".sliderbar-phone").mouseover(function() {
        $(".sliderbar-phone .sliderbar-item").addClass("active");

        $(".sliderbar-phone-show").show();
    });

    $(".sliderbar-phone").mouseout(function() {
        $(".sliderbar-phone .sliderbar-item").removeClass("active");

        $(".sliderbar-phone-show").hide();
    });

    $(".sliderbar-qrcode").mouseover(function() {
        $(".sliderbar-qrcode .sliderbar-item").addClass("active");

        $(".sliderbar-qrcode-show").show();
    });

    $(".sliderbar-qrcode").mouseout(function() {
        $(".sliderbar-qrcode .sliderbar-item").removeClass("active");

        $(".sliderbar-qrcode-show").hide();
    });
});
function max_video() {
document.getElementById("id_video_k").style.left="0px";
document.getElementById("id_video_k").style.top="72px";
document.getElementById("id_video_k").style.width="100%";
document.getElementById("id_video_k").style.height=(document.documentElement.clientHeight-72)+"px";
}
max_video();
function min_video() {
document.getElementById("id_video_k").style.left=(document.documentElement.clientWidth-75-320)+"px";
document.getElementById("id_video_k").style.top=(document.documentElement.clientHeight-70-240)+"px";
document.getElementById("id_video_k").style.width="320px";
document.getElementById("id_video_k").style.height="240px";
}

//返回顶部
$(function() {
    $(window).bind(
        "scroll",
        {
            fixedOffsetBottom: parseInt($("#Fixed").css("bottom"))
        },
        function(e) {
            var scrollTop = $(window).scrollTop();
            var referFooter = $("#newBottomHtml");
            scrollTop > 100 ? $("#goTop").show() : $("#goTop").hide();
            scrollTop > 100 ? min_video() : max_video();
            if (!/msie 6/i.test(navigator.userAgent)) {
                if (
                    $(window).height() -
                        (referFooter.offset() - $(window).scrollTop()) >
                    e.data.fixedOffsetBottom
                ) {
                    $("#Fixed").css(
                        "bottom",
                        $(window).height() -
                            (referFooter.offset() - $(window).scrollTop())
                    );
                } else {
                    $("#Fixed").css("bottom", e.data.fixedOffsetBottom);
                }
            }
        }
    );
    $("#goTop").click(function() {
        $("body,html").stop().animate({
            scrollTop: 0,
            duration: 100,
            easing: "ease-in"
        });
    });

	$('#id_dingzhi').click(function(){
		$('#nb_icon_wrap').click();
	});
});
</script>
</body>
</html>
