<!DOCTYPE html>
<html><head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta charset="utf-8">
    <meta name="viewport" content="width=320.1, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>我的优惠券</title>
</head>

<style>
.contact_info .header {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 44px;
  z-index: 99;
  background: #35b14b;
}
.returnico:before {
  background: url(<?php echo $static_path;?>/image/list.png) no-repeat;
  background-size: 80px auto;
  content: '';
  background-position: -65px -18px;
  position: absolute;
  top: 50%;
  margin-top: -12px;
  left: 14px;
  display: inline-block;
  border-width: 0;
  width: 24px;
  height: 24px;
}
.returnico {
  position: absolute;
  left: 0;
  top: 0;
  height: 44px;
  width: 44px;
  margin: 0;
  padding: 0;
}
.header h1 {
  color: #fff;
  padding: 0 42px 0 42px;
  font-size: 20px;
  line-height: 44px;
  height: 44px;
  text-align: center;
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
  font-weight: 400;
  margin: 0;
  padding: 0;
}

/*
.contact_info section {
  padding-top: 44px;
  padding-bottom: 10px;
}
*/
.LeafletCon {
	padding-top: 10px;
	max-width: 100%;
}

.contact_info {
	max-width: 100%;
}

.group:after {
	content: ".";
	display: block;
	height: 0;
	font-size: 0;
	clear: both;
	visibility: hidden
}

.l {
	float: left
}

.r {
	float: right
}

h4,p {
	margin: 0;
	padding: 0;
	font-weight: normal
}

h4 a {
	color: white;
	text-decoration: none;
}

.msg_card .card_content {
	position: relative;
	padding: 21px 13px 21px 84px;
	font-size: 20px;
	border-radius: 5px 5px 0 0;
	-moz-border-radius: 5px 5px 0 0;
	-webkit-border-radius: 5px 5px 0 0;
	color: #fff;
	height: 54px;
	font-weight: normal
}

.msg_card .card_content .logo {
	position: absolute;
	top: 21px;
	left: 13px;
	display: block;
	width: 60px;
	height: 60px;
	border-radius: 30px;
	-moz-border-radius: 30px;
	-webkit-border-radius: 30px;
	padding-top: 0;
	margin-top: 0
}

.msg_card .card_content .deco {
	position: absolute;
	bottom: -1px;
	left: 0;
	width: 100%;
	height: 5px;
	background-image: url(<?php echo $static_path;?>/image/card_tpl_deco200a94.png);
	background-repeat: repeat-x;
	background-position: center center
}

.msg_card .store {
	font-size: 14px;
	margin-top: 15px;
}
.msg_card .store2 {
	font-size: 14px;
	margin-top: 8px;
}


.msg_card .card_bottom {
	border-radius: 0 0 5px 5px;
	-moz-border-radius: 0 0 5px 5px;
	-webkit-border-radius: 0 0 5px 5px;
	border: 1px solid #e7e7eb;
	padding: 10px 0;
	margin-bottom: 15px;
	text-align: center
}

.msg_card .btn {
	display: inline-block;
	text-decoration: none;
	padding: 0 25px;
	text-align: center;
	font-size: 15px;
	height: 32px;
	line-height: 32px;
	border-radius: 5px;
	-moz-border-radius: 5px;
	-webkit-border-radius: 5px
}

.msg_card .btn.btn_primary {
	background-color: #04be02;
	color: #fff
}

.msg_card .btn.btn_disabled, .disabled {
	background-color: #e6e7ec !important;
	color: #a5a6aa !important;
	border: 1px solid #dadbe0
}

.msg_card .info_warning {
	text-align: center;
	padding: 5px 0;
	color: #8d8d8d
}

.am-pagination {
  padding-left: 0;
  margin: 1.5rem 0;
  list-style: none;
  color: #999;
  text-align: left;
}
.am-pagination>li {
  display: inline-block;
}
.am-pagination>li>a, .am-pagination>li>span {
  position: relative;
  display: block;
  padding: .5em 1em;
  text-decoration: none;
  line-height: 1.2;
  background-color: #fff;
  border: 1px solid #ddd;
  border-radius: 0;
  margin-bottom: 5px;
  margin-right: 5px;
}
.am-pagination>.am-active>a, .am-pagination>.am-active>span, .am-pagination>.am-active>a:hover, .am-pagination>.am-active>span:hover, .am-pagination>.am-active>a:focus, .am-pagination>.am-active>span:focus {
  z-index: 2;
  color: #fff;
  background-color: #55BD47;
  border-color: #55BD47;
  cursor: default;
}
.am-pagination>.am-disabled>span, .am-pagination>.am-disabled>span:hover, .am-pagination>.am-disabled>span:focus, .am-pagination>.am-disabled>a, .am-pagination>.am-disabled>a:hover, .am-pagination>.am-disabled>a:focus {
  color: #999;
  background-color: #fff;
  border-color: #ddd;
  cursor: not-allowed;
  pointer-events: none;
}
a {
	color: #55BD47;
}

</style>
<body onselectstart="return false"><!--使网页的内容无法被鼠标或键盘选定-->

<!--预订、取票、退票须知--->
<nav class="contact_info">
<article class="header">
<header>
    <i class="returnico infoPage_close" title="返回" onclick="if(!window.history.go(-1)){window.location.href='?_a=store';};"></i>
    <h1>我的优惠券</h1>
</header>
</article>

<div style="text-align: center; font-size: 16px; margin-top: 50px;"><a href="?_a=store&_u=index.coupons">去看看还有啥优惠券</a></div>
<section class="LeafletCon">
<?php
	if(empty($coupons['list'])) {
		echo '<div style="text-align: center; font-size: 14px; margin-bottom: 15px;">【您目前还没有优惠券哟, 请留意我们的最新活动】</div>';
	}
	else {
		$html = '
<div class="rich_media_content " id="js_content">
<div style="text-align: center; font-size: 14px; margin-bottom: 15px;">【优惠券有过期时间，记得及时使用哟】</div>';
	foreach($coupons['list'] as $c) {
			$html .= '
<div class="msg_card">
    <div class="card_content';
		$available = $c['used_time'] == 0 && ($c['expire_time'] == 0 || $c['expire_time'] >= $_SERVER['REQUEST_TIME']);
		#var_export($c);
		if(!$available) $html .= ' disabled';
		$html .= '" style="background-color:#55BD47;">
        <img class="logo" src="'.$c['info']['img'].'">
        <div class="card_info">
            <h4 class="card_title" ><a href="?_a=store&_u=index.coupondetail&uid='.$c['coupon_uid'].'">'.$c['info']['title'].'</a></h4>
            <p class="store">'.($c['used_time'] ? '使用时间: '.date('Y-m-d H:i', $c['used_time']) :
				'到期时间: '.($c['expire_time'] ? date('Y-m-d H:i', $c['expire_time']) : '永久')).'</p>
			';
		if(!empty($c['store_uid'])) {
			$html .= '<p class="store2"> 适用店铺: '.Dba::readOne('select name from store where uid = '.$c['store_uid']).'</p>';
		}
        $html .= '</div>
        <div class="deco"></div>
    </div>
    <div class="card_bottom">';
		if($available) {
	 		$html .= '
		        <a class="btn btn_primary btn_disableddd" href="?_a=store&_u=index.usercoupondetail&uid='.$c['uid'].'">立即使用</a>';
		}
	$html .= '</div></div>';
	}

$html .= '</div>';
		echo $html;
	}
?>
 </section>
<div>
<?php
	echo $pagination;
?>
</div>
 </nav>
 
</body>
</html>
<!-- baidu count -->


