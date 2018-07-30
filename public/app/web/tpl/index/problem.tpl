<!doctype html>
<html class="no-js">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title><?php if(!empty($data)) echo $data['title']; ?></title>
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
        margin-left: 40px;
        margin-top: 9px;
    }
    .headNav{
        position: absolute;
        top: 2px;
        right: 50px;
        line-height:70px;
        margin-top: 0px;
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
    .select_menu{ width: 142px; display: none; position: absolute; left: 20px; top: 48px;
        padding: 5px 5px 10px; text-align: left;
        background: rgba(0,0,0,0.8);
    }
    .select_menu li{ width: 100%; height: 48px; line-height: 48px;}
    .select_menu li a{ font-size: 18px; padding: 0;}
    .fl li:nth-child(1)>a{
        color: #39f;
    }
    #headBox {
        background: #333;
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
    .tit {
         margin: 8px;
    }
    .case-list{
        margin: 8px;
    }
    .case-list img{
        max-width: 100%;
    }
    html, body, .h-box, .f_box {
        min-width: 0px;
    }
    .case {
        padding-top: 75px;
        width: 100%;
    }
    ul, ol {
        padding-left: 2em;
    }

</style>
</head>
<body style="min-width:100%">
<script src="/static/js/jquery2.1.min.js"></script>
    <div class="main-body">

<div id="headBox">
    <a href="?_a=web&_u=index.problemlist" class="logo"><h1 style="font-size: 25px;color: #fff;margin-top: 12px;">常见问题</h1></a>
    <ul class="headNav">

        <li <?php if(empty($_GET['_d'])) echo 'style="display:none;"';?>><a href="?_a=sp&_u=index.login" class="cnavbtn">后台登录</a></li>
    </ul>
</div>

    <div class="sliderbar hidden-xs">

        
        <div class="sliderbar-top" style="top:350px!important">
            <a id="goTop" class="fl" title="去顶部" href="javascript:void(0)"></a>
        </div>
    </div>


    <div class="case-wrap">
        <div class="case">
            <div class="tit tc">
                <h2 class="green"><?php if(!empty($data)) echo $data['title']; ?></h2>
                <div class="grey mt5" style="width: 200px;display: inline-block"><?php if(!empty($data)) echo date('Y-m-d',$data['create_time']); ?></div>
                <div class="grey mt5" style="display: inline-block" >阅读数 ：<?php if(!empty($data)) echo $data['read_cnt']; ?></div>
            </div>
            <div class="case-list">
                <?php if(!empty($data)) echo $data['content']; ?>
            </div>
        </div>
    </div>



    <div class="foot" style="background:#333;clear:both;margin-top:60px;">
        <div class="f-box small-font tc">
            <div class="copy grey">
                    <p><div id="imgtest"></div></p>
            </div>
        </div>
    </div>
</body>


</html>

<script type="text/javascript" src="/app/web/static/js/header.js"></script>

<script>


    var showImg = function (url) {
        var frameid = 'frameimg' + Math.random();
        window.img = '<div style="text-align: center"><img style="max-width: 100%" id="img"  src=\'' + url + '&' + Math.random() + '\' /></div><script>window.onload = function() { parent.document.getElementById(\'' + frameid + '\').height = document.getElementById(\'img\').height+8+\'px\'; }<' + '/script>';
        return '<iframe id="' + frameid + '" src="javascript:parent.img;" frameBorder="0" scrolling="no" width="100%"></iframe>';
    }
    $("img").each(function(){
        var img = this.src;
        $(this).parent().append(showImg(img));
        $(this).remove('img');
    });


    //返回顶部
$(function() {

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
