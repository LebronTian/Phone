<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title><?php echo !empty($article['cat']['title']) ? $article['cat']['title'] : $site['title'];?></title>
<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0" name="viewport">
<link rel="icon" href="favicon.ico" type="image/x-icon" />
<link href="<?php echo $static_path;?>/css/base.css" rel="stylesheet" type="text/css">
<link href="<?php echo $static_path;?>/css/style.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/static/js/jquery2.1.min.js"></script>
<script type="text/javascript" src="<?php echo $static_path;?>/js/weixinapi.js"></script>
<!--
<script src="/Public/index/js/common_js.js?t=0.13122400 1470367507"></script>
-->
<!--
<script type="text/javascript" src="/Public/index/js/touchwipe.js"></script>
<script type="text/javascript" src="/Public/index/jscroll-master/jquery.jscroll.min.js"></script>
-->
</head>

<?php
    if(empty($site['logo'])) $site['logo'] = '/static/images/uctoo.jpg';
?>

<body>

<div id="qianyan">
	<div class="header">
		<h2 class="tit js-tit"><a href="?_a=site"><img src="<?php echo $site['logo'];?>" alt=""></a></h2>
		<a class="line3" href="?_a=site"><span></span><span></span><span></span></a>
			</div>
	<div class="p10">
<?php
if(!empty($article)) {
	$sp_name = Dba::readOne('select name from service_provider where uid = '.$site['sp_uid']);
	if(!empty($article['cat']['title'])) echo '<h2 class="blueTit">'.$article['cat']['title'].'</h2>';?>
		<h2 class="mormalTit"><?php echo $article['title'];?></h2>
		<ul class="otherTxt cf">
		<?php echo '<li class="br1s">作者：'.($article['author'] ? $article['author'] : $sp_name).'</li>';?>
		<li>阅读人数：<?php echo $article['click_cnt'];?></li>
		</ul>
		<div class="editbody f16">
<?php
	echo $article['content'];

	echo '
<!-- <div class="zan-disable cf"> -->
<div class="zan cf zannum">
	<p data-id="'.$article['uid'].'"><span> '.$article['like_cnt'].'</span></p>
</div>				
';

$reply_cnt = $article['reply_cnt'];
}
else {
	$reply_cnt = Dba::readOne('select count(*) from site_article_reply where site_uid = '.$site['uid'].' && article_uid = 0');
}



?>

<div class="box-shuping bt1s_c9cdcc pt20">
			<h2>一句话书评(<?php echo $reply_cnt;?>)</h2>
			<form id="FromID">
				<textarea name="content" id="content" cols="30" rows="10" placeholder="写点什么吧~"></textarea>
				<input type="button" data-id="<?php echo !empty($article['uid']) ? $article['uid'] : 0; ?>" class="btn subFrom" value="提交">
			</form>
			<h3>置顶书评</h3>
			<ul class="cf">
<?php
	$option = array('site_uid' => $site['uid'],
			'page' => 0, 'limit' => 10, 
			'sort' => SORT_CREATE_TIME_DESC,
			'available' => 1,
			'article_uid' => !empty($article['uid']) ? $article['uid'] : 0);
	
	$list = SiteMod::get_article_reply_list($option);
	if(!$list['list']) {
		echo '-';
	}
	else {
	$html = '';
	foreach($list['list'] as $l) {
		$html .= '<li>
<img src="'.($l['su']['avatar'] ? $l['su']['avatar'] : 'static/images/null_avatar.png').'" alt="" width="60" />
<div>
<h4>'.($l['su']['name'] ? $l['su']['name'] : $l['su']['account']).'</h4>
<p>'.$l['brief'].'</p>
</div>
</li>';
	}
	echo $html;
	}
	

?>
			</ul>
			<h3>最新书评</h3>
			<div class="jscroll">
				<ul class="cf" id="id_content">
				</ul>
			</div>
		</div>
	</div>
</div>
</body>
</html>
<script id="id_tpl" type="text/tpl">
<li>
<img src="{{=it.su.avatar || '/static/images/null_avatar.png'}}" alt="" width="60" />
<div>
<h4>{{=it.su.name||it.su.account}}</h4>
<p>{{=it.brief}}</p>
</div>
</li>
</script>
<script src="/static/js/doT.min.js"></script>
<script src="/static/js/scroll_load.js"></script>
<script> 
scroll_load({'ele_container': '#id_content', 'ele_dot_tpl': '#id_tpl',
			'url': '?_a=site&_u=ajax.article_reply_list&article_uid=<?php echo !empty($article['uid']) ? $article['uid'] : 0;?>', 'onfinish': function(){}});
		
$('.zan p').click(function(){
	var zan_num = parseInt($(".zan p span").text());
	$(".zan p span").text(zan_num+1);
		
	$(".zannum").removeClass("zan");
	$(".zannum").addClass("zan-disable");
	var article_uid = $(this).attr('data-id');
	$.post('?_a=site&_u=ajax.like_article&article_uid='+article_uid, function(ret){
		ret = $.parseJSON(ret);
		if(!ret || ret.errno) {
			alert('请勿重复点赞！');
		}
	})
});

/*
	要求登录后操作
*/
function require_login() {
	var has_login = <?php echo AccountMod::has_su_login();?>;
	if(has_login) return true;

	window.location.href = '?_a=web&_u=index.goto_url&must_login=1&url='+encodeURIComponent(window.location.href);
	return false;
}

$('.subFrom').click(function(){
	if(!require_login()) return;

	var brief = $('#content').val().trim();
	if(!brief) return alert('请填写内容！');
		
	var article_uid = $(this).attr('data-id');
	var data = {
		brief: brief,
		article_uid: article_uid
	};
	$.post('?_a=site&_u=ajax.add_article_reply', data, function(ret){
		
		ret = $.parseJSON(ret);
		if(!ret || ret.errno) {
			return	alert('操作失败，请重试！');
		}
		window.location.reload();
	});
});

document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
    window.shareData = { 
        "sendFriendLink": window.location.href + "&__sp_uid=<?php echo $site['sp_uid'];?>",
        "fTitle": "<?php echo $site['title'];?>",
        "fContent": "",
        };
        
        WeixinJSBridge.on('menu:share:appmessage', function (argv) {
            WeixinJSBridge.invoke('sendAppMessage', {
                "img_url": "<?php echo $site['logo'];?>",
                "img_width": "200",
                "img_height": "200",
                "link": window.shareData.sendFriendLink,
                "desc": window.shareData.fContent,
                "title": window.shareData.fTitle
            }, function (res) {
                _report('send_msg', res.err_msg);
            })
        });
 
}, false);


WeixinApi.ready(function(Api) {
  var imgList = new Array();
  $(".editbody img").each(function(){
    var imgSrc=$(this).attr("src");
    if(!/^http/.test(imgSrc)) imgSrc = window.location.origin + '/' + imgSrc;
    imgList.push(imgSrc);
  })
  $(".editbody img").click(function(){
    var index = $('img').index(this)-1;
    Api.imagePreview(imgList[index], imgList);
  })
});
/*$(document).ready(function(){
	var wh=$(window).width()-20;
	$("#iframeV").css({
		"width":wh,
		"height":wh/4*3
	})*/
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
})
</script>
