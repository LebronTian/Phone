<!DOCTYPE html>
<html><head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta charset="utf-8">
    <meta name="viewport" content="width=320.1, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title><?php echo $coupon['title'];?> - 优惠券详情</title>
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
	padding-top: 60px;
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

.msg_card .card_content {
	position: relative;
	/*padding: 21px 13px 21px 84px; */
	font-size: 20px;
	border-radius: 5px 5px 0 0;
	-moz-border-radius: 5px 5px 0 0;
	-webkit-border-radius: 5px 5px 0 0;
	height: 54px;
	text-align: center;
	font-weight: normal
}

.msg_card .card_content .logo {
	display: block;
	width: 60px;
	height: 60px;
	border-radius: 30px;
	-moz-border-radius: 30px;
	-webkit-border-radius: 30px;
	padding-top: 0;
	margin: 0 auto;
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
	background-color: #e6e7ec;
	color: #a5a6aa !important;
	border: 1px solid #dadbe0
}

.msg_card .info_warning {
	text-align: center;
	padding: 5px 0;
	color: #8d8d8d
}
</style>
<body onselectstart="return false"><!--使网页的内容无法被鼠标或键盘选定-->

<!--预订、取票、退票须知--->
<nav class="contact_info">
<article class="header">
<header>
    <i class="returnico infoPage_close" title="返回" onclick="if(!window.history.go(-1)){window.location.href='?_a=store';};"></i>
    <h1>优惠券详情</h1>
</header>
</article>

<section class="LeafletCon">
<?php
	echo '
<div class="msg_card">
    <div class="card_content">
        <p><img class="logo" src="'.$coupon['img'].'"></p>
		<h2>'.$coupon['title'].'</h2>
        <p class="store">还剩 '.max(0, $coupon['publish_cnt'] - $coupon['used_cnt']).' 张</p>
		';
		if(!empty($coupon['store_uids'][0])) {
			echo '<p class="store2"> 适用店铺: '.Dba::readOne('select name from store where uid = '.$coupon['store_uids'][0]).'</p>';
		}

		if($coupon['publish_cnt'] - $coupon['used_cnt'] > 0) {
			echo '<div class="card_bottom"><a class="btn btn_primary cget" data_uid="'.$coupon['uid'].'">立即领取</a></div>';
		}

		echo '<hr>'.$coupon['brief'].'
			</div>
</div>
		';
?>
 </section>
 </nav>
 
<script src="/static/js/zepto.min.js"></script>
<script>
var g_su_uid =  <?php echo json_encode(AccountMod::has_su_login());?>;
$('.cget').click(function () {
	if(!g_su_uid) {
		window.location.href="?_a=web&_u=index.goto_url&must_login=1&url=" + encodeURIComponent(window.location.href);
		return;
	}

    var uid = $(this).attr('data_uid');
    $.post('?_a=store&_u=ajax.get_coupon',{uid:uid}, function (ret) {
        ret = JSON.parse(ret);
        if(ret.errno==0){
            alert('领取成功');
            window.location.href='?_a=store&_u=index.usercoupons';
        }
        else if(ret.errno==403){
            alert('您已经领取过了');
            //history.back();
        }
        else{
            alert('领取失败，请确认领取资格，错误代码：'+ret.errno);
        }
    });
});
</script>
</body>
</html>
<!-- baidu count -->


