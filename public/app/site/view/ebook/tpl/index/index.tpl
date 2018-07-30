<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title><?php echo $site['title'];?></title>
<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0" name="viewport">
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name='apple-touch-fullscreen' content='yes'>
<meta name="full-screen" content="no">
<meta name="apple-mobile-web-app-status-bar-style" content="black" />
<meta name="format-detection" content="telephone=no"/>
<meta name="format-detection" content="address=no"/>
<link rel="icon" href="favicon.ico" type="image/x-icon" />
<link href="<?php echo $static_path;?>/css/base.css" rel="stylesheet" type="text/css">
<link href="<?php echo $static_path;?>/css/style.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/static/js/jquery2.1.min.js"></script>
<script type="text/javascript">
	var Fromurl = "/index.php?s=/index/message.html";
</script>
<script type="text/javascript" src="<?php echo $static_path;?>/js/touchswipe.js"></script>
<script type="text/javascript" src="<?php echo $static_path;?>/js/tweenmax.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	$(".btn").click(function(){
		$("#dir").hide();
		window.location="?_a=site&_u=index.article_with_reply";
	});
});
function showDes(el){
    var subcon = $(el).parent().next();
    var status = $(el).parent().next().css("display");
	
	if ($(document).scrollTop() >= ($(document).height() - $(window).height())) {
		//alert("最后一个")
		var subconH = subcon.height();
		//$(document).scrollTop($(document).height() - $(window).height() + subconH);
		var st = $(document).scrollTop();
		//alert(st);
		$('html, body').animate({
		  scrollTop: st + subconH+30
		}, 500);
	}
	
    if (status == "block") {
      subcon.fadeOut();
    } else {
      subcon.fadeIn();
    }
}
</script>
</head>

<?php
	if(empty($site['logo'])) $site['logo'] = '/static/images/uctoo.jpg';
?>
<body>
<div id="index" class="wh">
	<h2 class="tit"><img src="<?php echo $site['logo']; ?>"></h2>
	<?php
		if(!empty($slides[0])) {
			$cover = $slides[0]['image'];
			echo '<div class="book"><img src="'.$cover.'"></div>';
		}

		$sp_name = Dba::readOne('select name from service_provider where uid = '.$site['sp_uid']);
		//echo '<h2 style="font-size:34px;color:#004b8e;font-weight:bold;">'.$site['title'].'</h2>';
	?>
	
	<div class="bot tc" style="margin-top: 100px;"> <a href="javascript:;" class="btn" style="font-size:18px;color:#004b8e;text-decoration:none;">邀您推荐</a>
		<p>
	<?php
		if(!empty($slides[0])) {
			$txt = $slides[0]['title'];
			echo $txt.'<br>';
		}

		
	?>
		您是第<span><?php 
		$cnt_total = Dba::readOne('select sum(click_cnt) from site_articles where site_uid = '.$site['uid']);
		if(!$cnt_total) $cnt_total = 0;
		echo $cnt_total;
		?></span>位读者</p>
		<p style="color:#004b8e; margin-top:3px;"><?php echo $sp_name;?> 出品</p>
	</div>
	<div class="next"><img src="<?php echo $static_path;?>/images/arrow2.png"></div>
</div>

<div id="qianyan" class="wh">
	<h2 class="tit">
		<a href="?_a=site"><img src="<?php echo $site['logo']; ?>" alt=""></a>
		<a class="line3" href="?_a=site"><span></span><span></span><span></span></a>
	</h2>
	<h2 class="tit2"><!--扉页--></h2>
	<?php
		if(!empty($slides[1])) {
			$feiye = $slides[1]['image'];
			echo '<p><img src="'.$feiye.'" alt=""></p>';
		}

		uct_use_app('sp');
		$d = SpMod::get_document_by_title('扉页', $site['sp_uid']);
		if($d) {
			echo $d['content'];
		}
	?>

	<div class="next"><img src="<?php echo $static_path;?>/images/arrow2.png"></div>
</div>

<div id="dir">
	<!--h2 class="tit">
		<a href="/index.php?s=/index.html"><img src="/Public/index/img/logo.png" alt=""></a>
		<a href="javascript:;"><span></span><span></span><span></span></a>
	</h2-->
	<div class="header">
		<h2 class="tit js-tit"><a href="?_a=site"><img src="<?php echo $site['logo'];?>" alt=""></a></h2>
	</div>
	<h2 class="tit2">目 录</h2>
	<div class="jscroll">
		<ul class="dir" id='id_content'>
		</ul>
	</div>
</div>
<script type="text/tpl" id="id_tpl">
		<li class="cf">
			<div class="num">{{=g_seq_id++}}</div>
			<div class="titAll">
				<a href="?_a=site&_u=index.article_with_reply&uid={{=it.uid}}" class="imgtit"></a>
				<a href="javascript:;" onClick="showDes(this)" class="txtit">{{=it.title}}</a>
				<p><span>阅读人数：{{=it.click_cnt}}</span>{{=it.cat.title}}</p>
			</div>
			<div class="txtmore">
				<a href="?_a=site&_u=index.article_with_reply&uid={{=it.uid}}">
				{{=it.digest}}
				<span>阅读全文</span></a>
				<b></b>
			</div>
		</li>
</script>
<script src="/static/js/doT.min.js"></script>
<script src="/static/js/scroll_load.js"></script>
<script src="<?php echo $static_path;?>/js/index.js"></script>
<script type="text/javascript">
var g_seq_id = 1;
scroll_load({'ele_container': '#id_content', 'ele_dot_tpl': '#id_tpl',
			'url': '?_a=site&_u=ajax.article_list', 'onfinish': function(){}});
		
$(function() {
	//导航菜单 滚动显示/隐藏效果
	var disScroll;
	var lastScrollTop = 0;
	var delat = 5;
	var navHight = $('.header').outerHeight();
	$(window).scroll(function(event) {
		disScroll = true;
	});
	setInterval(function() {
		if (disScroll) {
			hasScrolled();
			disScroll = false;
		}
	}, 250);

function hasScrolled() {
	var st = $(this).scrollTop();
	if (Math.abs(st - lastScrollTop) <= delat) {
		return;
	};
	// st滚动距离大于导航高度并且大于上次高度
	if (st > navHight + 40 && st > lastScrollTop) {
		$('.js-tit').removeClass('header-show').addClass('header-hide');
	} else {
		if (st + $(window).height() < $(document).height()) {
			$('.js-tit').removeClass('header-hide').addClass('header-show');
		}
	}
		lastScrollTop = st;
	};
});
</script>
</body>
</html>

