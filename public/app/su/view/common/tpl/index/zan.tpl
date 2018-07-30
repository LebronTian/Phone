<?php
$_REQUEST['__sp_uid'] = 31;
SuMod::require_su_uid();
$su = AccountMod::get_current_service_user();
$cnt = requestInt('cnt', 10);
if($cnt > 1) {
	$cnt = min($cnt, 200);
	$zans = Dba::readAllOne('select avatar from service_user where sp_uid=31 && uid > '.
						($su['uid']%10000 + 100000 + $cnt).' && uid != '.$su['uid'].' && avatar != "" order by last_time desc limit '.($cnt-1));
	array_unshift($zans, $su['avatar']);
} else {
	$zans = array($su['avatar']);
}

?>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>朋友圈</title>
    <meta charset="utf-8">
    <meta name="viewport" content="initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no">

    <style type="text/css">
/**
 * Created by Administrator on 2016/1/31.
 */
#list,#list li,.po-hd,.post {
    overflow: hidden
}

.po-cmt,.post .list-img:nth-child(1),.time {
    float: left
}

#list li,.cmt-wrap,.r,.time {
    clear: both
}

.btn,a {
    cursor: pointer
}

blockquote,body,code,dd,div,dl,dt,fieldset,form,h1,h2,h3,h4,h5,h6,input,legend,li,ol,p,pre,td,textarea,th,ul {
    margin: 0;
    padding: 0
}

table {
    border-collapse: collapse;
    border-spacing: 0
}

fieldset,img {
    border: 0
}

address,caption,cite,code,dfn,em,strong,th,var {
    font-style: normal;
    font-weight: 400
}

ol,ul {
    list-style: none none
}

caption,th {
    text-align: left
}

h1,h2,h3,h4,h5,h6 {
    font-size: 100%;
    font-weight: 400
}

q::after,q::before {
    content: ""
}

abbr,acronym {
    border: 0;
    font-variant: normal
}

sup {
    vertical-align: text-top
}

sub {
    vertical-align: text-bottom
}

input,select,textarea {
    font-family: inherit;
    font-size: inherit;
    font-weight: inherit
}

legend {
    color: #000
}

a {
    text-decoration: none
}

input {
    -webkit-appearance: none
}

* {
    -webkit-tap-highlight-color: transparent
}

html {
    background-color: #f8f8f8;
    font-family: Arial,sans-serif;
    font-size: 13px
}

@media screen and (min-width:350px) {
    html {
        font-size: 15px
    }

    .cmt-wrap {
        font-size: 14px
    }

    .time {
        font-size: 13px
    }
}

.hide {
    display: none
}

header {
    position: relative
}

#avt,#user-name {
    position: absolute
}

#bg {
    width: 100%
}

#user-name {
    text-align: right;
    right: 114px;
    bottom: 15px;
    color: #fff;
    font-weight: 700;
    font-size: 15px;
    text-shadow: 0 1px .5px #000
}

#share a,.btn {
    font-size: 14px
}

.btn,b {
    font-weight: 400
}

#share a,#share p,.btn {
    text-align: center
}

#avt {
    width: 74px;
    height: 74px;
    border: 1px solid #dbdbdb;
    right: 15px;
    bottom: -22px;
    padding: 1px;
    background-color: #fff
}

#list li,.po-hd {
    position: relative
}

#list {
    padding: 30px 0 10px
}

#list li {
    line-height: 1.5;
    border-bottom: 1px solid #e2e2e2;
    margin-top: 15px;
    padding-bottom: 15px
}

#share a:nth-child(2),.ads,.po-avt {
    position: absolute
}

.ads {
    color: #999;
    right: 5px;
    top: 0
}

.ads img {
    width: 10px;
    padding-left: 8px
}

.ad-link {
    color: #3b5384
}

.post .ad-link img {
    width: 11px;
    padding: 0;
    display: inline-block
}

.po-avt-wrap {
    padding-left: 10px
}

.po-avt {
    width: 40px;
    height: 40px;
    top: 0;
    left: 10px
}

.r {
    border-bottom: 8px solid #eee;
    border-left: 8px solid transparent;
    border-right: 8px solid transparent;
    width: 1px;
    margin-top: 5px;
    margin-left: 10px
}

.po-cmt {
    padding-left: 60px;
    padding-right: 10px;
    width: 100%;
    box-sizing: border-box
}

.po-name {
    color: #576b95
}

.post {
    color: #252525;
    padding-bottom: 10px
}

.post img {
    padding: 10px 5px 0 0;
    display: block;
    max-height: 130px;
    max-width: 130px
}

#share a,.btn {
    display: inline-block
}

.post .list-img {
    width: 30%;
    max-height: 80px;
    max-width: 80px;
    padding-right: 5px;
    float: left;
    object-fit: cover
}

.post .list-img:last-child {
    padding-right: 0
}

.time {
    color: #b1b1b1
}

.c-icon {
    width: 20px;
    float: right
}

.cmt-wrap {
    width: 100%;
    background-color: #eee
}

.like {
    color: #576b95;
    padding: 5px 5px 3px 12px
}

.like img {
    width: 32px;
    padding-right: 5px;
}

.cmt-list {
    padding: 5px 12px;
    color: #454545
}

.cmt-list p {
    padding-top: 3px
}

.cmt-list span {
    color: #3b5384
}

#share a {
    border-radius: 5px;
    background-color: #26337e;
    color: #fff;
    line-height: 2.5;
    width: 138px;
    margin: 0 10px
}

#share a:nth-child(1) {
    position: absolute;
    left: 50%;
    margin-left: -148px
}

#share a:nth-child(2) {
    right: 50%;
    margin-right: -148px
}

#share p {
    padding: 45px 0 10px;
    color: #999
}

#guide {
    position: fixed;
    left: 0;
    top: 0;
    bottom: 0;
    right: 0;
    width: 100%;
    height: 100%;
    z-index: 9999;
    background-image: url(../images/guide2.png);
    background-repeat: no-repeat;
    background-position: right top;
    background-color: #191919;
    background-size: contain;
    opacity: .9
}

.btn {
    margin-bottom: 0;
    vertical-align: middle;
    -ms-touch-action: manipulation;
    touch-action: manipulation;
    background-image: none;
    border: 1px solid transparent;
    white-space: nowrap;
    padding: 6px 12px;
    line-height: 1.42857143;
    border-radius: 4px;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none
}

.btn-success {
    color: #fff;
    background-color: #5cb85c;
    border-color: #4cae4c
}

.btn-group-lg>.btn,.btn-lg {
    padding: 10px 16px;
    font-size: 18px;
    line-height: 1.3333333;
    border-radius: 6px
}

.btn-block {
    display: block;
    width: 100%
}

.bq {
    width: 13px;
    padding-left: 2px
}

.hidenone {
    display: none
}
        * {cursor: pointer;}
        .weui_mask_transition {
            display: none;
            position: fixed;
            z-index: 1;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            background: rgba(0, 0, 0, 0);
            -webkit-transition: background .3s;
            transition: background .3s;
        }
        .weui_fade_toggle {
            background: rgba(0, 0, 0, 0.6);
        }
        .weui_actionsheet {
            position: fixed;
            left: 0;
            bottom: 0;
            -webkit-transform: translate(0, 100%);
            -ms-transform: translate(0, 100%);
            transform: translate(0, 100%);
            -webkit-backface-visibility: hidden;
            backface-visibility: hidden;
            z-index: 2;
            width: 100%;
            background-color: #EFEFF4;
            -webkit-transition: -webkit-transform .3s;
            transition: transform .3s;
        }
        .weui_actionsheet_toggle {
            -webkit-transform: translate(0, 0);
            -ms-transform: translate(0, 0);
            transform: translate(0, 0);
        }
        .weui_actionsheet_menu {
            background-color: #FFFFFF;
        }
        .weui_actionsheet_cell:before {
            content: " ";
            position: absolute;
            left: 0;
            top: 0;
            width: 100%;
            height: 1px;
            border-top: 1px solid #D9D9D9;
            -webkit-transform-origin: 0 0;
            -ms-transform-origin: 0 0;
            transform-origin: 0 0;
            -webkit-transform: scaleY(0.5);
            -ms-transform: scaleY(0.5);
            transform: scaleY(0.5);
        }
        .weui_actionsheet_cell:first-child:before {
            display: none;
        }
        .weui_actionsheet_cell {
            position: relative;
            padding: 10px 0;
            text-align: center;
            font-size: 18px;
        }
        .weui_actionsheet_cell.title {
            color: #999;
        }
        .weui_actionsheet_action {
            margin-top: 6px;
            background-color: #FFFFFF;
        }

.list-img2{
max-height:150px;
}
    </style>

</head>
<body>

<header>
    <img id="bg" src="https://unsplash.it/640/320/">
    <p id="user-name" class="data-name"><?php echo $su['name'];?></p>
    <img id="avt" class="data-avt" src="<?php echo $su['avatar'];?>">
</header>
<div id="main">
    <div id="list">
        <ul>
            <li>
                <div class="po-avt-wrap">
                    <img class="po-avt data-avt" src="<?php echo $su['avatar'];?>">
                </div>
                <div class="po-cmt">
                    <div class="po-hd">
                        <p class="po-name"><span class="data-name"><?php echo $su['name'];?></span></p>
                        <div class="post">
                            <p class="cedit">朋友圈点赞不求人，你想要几个赞👍👍👍👍</p>
                            <p id="id_imgs" class="po-avt-wrap">
                                <img class="list-img2" src="https://unsplash.it/130/130/">
                            </p>
							<div style="clear:both;"></div>
                        </div>
                        <p class="time "><span class="cedit">刚刚</span> <span id="id_deleteimg" style="margin-left:25px;color:#3b5384">删除</span></p><img id="id_comment" class="c-icon" src="/static/images/comment.png">
                    </div>
                    <div class="r"></div>
                    <div class="cmt-wrap">
                        <div style="float:left;"><img id="id_zan" style="width:12px;padding-top:15px;padding-left:12px;" src="/static/images/like.png"></div>
<!-- 苍井空，陈冠希，杨幂，王思聪，陈赫，刘德华，马云... -->
<div class="like">
<div id="id_zans" style="margin-left:18px;">
<?php
foreach($zans as $z) {
echo '<img src="'.$z.'">';
}
?>
</div>
<div style="clear:both;"></div>
</div>
                    </div>
                        <div class="cmt-list">
                            <p><span class="cedit"><?php echo $su['name'];?>：</span><ii class="cedit"><?php echo $cnt;?>个赞分分钟搞定</ii></p>
                        </div>
                </div>
            </li>

        </ul>
    </div>

    <div id="share">
        <p>（朋友圈点赞生成器）</p>
        <div style="color:#999;text-align:center;">  可修改动态内容，添加评论，
			点赞入数<br/>然后。。。截图即可
			<br>欢迎关注微信公众号<br/>
			<img src="/static/images/qrcode.jpg" style="width:240px;height;240px;">
		</div>
		
        <div style="padding:15px;padding-bottom:20px;display:none;">
            <button id="gotoplay" onClick="showActionSheet();" class="btn btn-success btn-lg btn-block">我也要玩</button>
            <br>
        </div>

    </div>

</div>

<script src="/static/js/jquery1.7.min.js" type="text/javascript"></script>
<script src="/static/js/plupload.full.min<?php echo (getUserAgent()&1)?'':'.android';?>.js" type="text/javascript"></script>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script>
    function gotoplay(scene) {
    }
    function safetostring(str) {
        return String(str).replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"').replace(/&#39;/g, "'");
    }

    setTimeout(function () {
        // $(".data-name").text(safetostring(nickname));
        //$(".data-avt").attr("src", headimgurl);
        var cw = $('.list-img').width();
        $('.list-img').css({'height': cw + 'px'});
    }, 0);

    $(window).resize(function () {
        var cw = $('.list-img').width();
        $('.list-img').css({'height': cw + 'px'});
    });


    $(document.body).show();


    function hideActionSheet(weuiActionsheet, mask) {
        weuiActionsheet.removeClass('weui_actionsheet_toggle');
        mask.removeClass('weui_fade_toggle');
        weuiActionsheet.on('transitionend', function () {
            mask.hide();
        }).on('webkitTransitionEnd', function () {
            mask.hide();
        })
    }
    function showActionSheet() {
        var mask = $('#mask');
        var weuiActionsheet = $('#weui_actionsheet');
        weuiActionsheet.addClass('weui_actionsheet_toggle');
        mask.show().addClass('weui_fade_toggle').click(function () {
            hideActionSheet(weuiActionsheet, mask);
        });
        $('#actionsheet_cancel').click(function () {
            hideActionSheet(weuiActionsheet, mask);
        });
        weuiActionsheet.unbind('transitionend').unbind('webkitTransitionEnd');
    }

$('.cmt-wrap').click(function(){
var cnt = parseInt(prompt('你想要几个赞？', $('#id_zans img').length));
if(cnt > 1) {
	window.location.href = '?_easy=su.common.index.zan&cnt=' + cnt;
}
});

$('#id_comment').click(function(){
var txt = prompt('写评论');
if(txt) {
$('.cmt-list').append('<p><span class="cedit"><?php echo $su['name'];?>：</span><ii class="cedit">'+txt+'</ii></p>');
}
});

$('#id_deleteimg').click(function(){
if(!confirm('要删除图片吗？')) return;
$('#id_imgs').html('');
});

var uploader_img = new plupload.Uploader({
browse_button:"id_imgs",
url: '?_a=upload&_u=index.upload&type=1',
filters: {
max_file_size: '10mb',
mime_types: [
{title: "Image files", extensions: "jpg,gif,png,bmp,jpeg"}
]
},
init: {
FilesAdded: function (up, files) {
uploader_img.start();
},
FileUploaded: function (up, files, res) {
	res = JSON.parse(res.response); //PHP上传成功后返回的参数
	if(res.data.url){
		$('#id_imgs').append('<img class="list-img2" src="'+res.data.url+'"/>');
		if($('#id_imgs .list-img2').length > 1) {
			$('#id_imgs .list-img2').css({'width':'72px','height':'72px','float':'left', 'margin-left':'5px'});
		}
	}
},
Error: function (upload,error) {
	if(error.code==(-600)){
		alert('图片大小为0-10mb范围内')
	}
	else{
		alert('上传失败，未知错误:'+error.code)
	}
}
}
});
uploader_img.init();

$('body').on('click', '.cedit', function(){
$(this).text(prompt('修改文字', $(this).text()) || $(this).text());
});



    var wx_cfg =<?php echo json_encode(WeixinMod::get_jsapi_params());?>;
    if(wx_cfg){
        // wx_cfg['debug']= true;
        wx_cfg['jsApiList']= ['onMenuShareTimeline','onMenuShareAppMessage'];
        wx.config(wx_cfg);
    }

    wx.ready(function(){
      var shareData = {
        title: '再也不怕朋友圈求点赞了',
        desc: '你想要几个赞我都给你！',
        link: window.location.href,
        imgUrl:window.location.origin+'/static/images/like.png',
      };
      wx.onMenuShareAppMessage(shareData);
      wx.onMenuShareTimeline(shareData);
    });

//百度统计代码
var _hmt = _hmt || [];
(function() {
  var hm = document.createElement("script");
  hm.src = "https://hm.baidu.com/hm.js?f40d69de01a2f312022bdaddc993d54c";
  var s = document.getElementsByTagName("script")[0]; 
  s.parentNode.insertBefore(hm, s);
})();
</script>



</body>
</html>


