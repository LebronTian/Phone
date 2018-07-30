<!doctype html>
<html class="no-js">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>常见问题</title>
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
  <meta name="renderer" content="webkit">
  <meta http-equiv="Cache-Control" content="no-siteapp" />

  <link rel="shortcut icon" href="/favicon.ico"/>
  <link rel="stylesheet" type="text/css" href="/static/css/typo.css">
  <link rel="stylesheet" type="text/css" href="/app/web/static/css/index2.css">
  <link rel="stylesheet" href="/static/css/amazeui2.1.min.css"/>
 
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
		line-height:24px;
        margin-top: 0px;
    }
    .headNav li{
        /*float: left;*/
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
        /*height:24px;*/
        padding:5px;
        line-height:24px;
        margin-top:5px;
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
    .case-list li {
        width: auto;
        padding-right: 30px;
        margin-top: 40px;
        float: left;
        position: relative;
    }
    html, body, .h-box, .f_box {
        min-width: 0px;
    }
    .case {
         width: 100%;
    }
</style>
</head>
<body style="width:100%">
<script src="/static/js/jquery2.1.min.js"></script>
    <div class="main-body">

    <div id="headBox">
    <a href="#" class="logo"><h1 style="font-size: 25px;font-weight: 100;color: #fff;margin-top: 12px;">常见问题</h1></a>
    <ul class="headNav">

        <li><a href="?_a=web&_u=index.problemlist&type=新闻资讯&notnews=0" class="cnavbtn">新闻资讯</a></li>
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

                <p class="grey mt5">
                <div class="am-form-group  am-fl am-u-md-4">
                    <select data-am-selected="{btnSize: 'lg' }" class="option_type">
                        <?php

                    $html = '<option value="0"';
                    if($option['type']==0) $html .= ' selected ';
                    $html .= '>所有问题</option>';

                        foreach($types as  $c) {
                        $html .= '<option value="'.$c.'"';
                        var_dump($c);
                        if($option['type'] == $c) $html .= ' selected';
                        $html .= '>'.$c.'</option>';
                        }
                        echo $html;
                        ?>
                    </select>
                </div>
                <div class="am-u-md-3 am-cf">
                    <div class="am-fr">
                        <div class="am-input-group am-input-group-sm">
                            <input type="text" class="am-form-field option_key" value="<?php echo $option['key'];?>">
                <span class="am-input-group-btn">
                  <button class="am-btn am-btn-default option_key_btn" type="button">搜索</button>
                </span>
                        </div>
                    </div>
                </div>

                </p>

            </div>
            <div class="admin-content">
                <div class="am-u-sm-12" style="min-height: 300px">
                    <table class="am-table am-table-striped am-table-hover table-main">
                        <thead>
                        <tr>
                            <th style="font-size: 20px;width: 30%">发布时间</th>
                            <th style="font-size: 20px;width: 40%">标题</th>
                            <th style="font-size: 20px;">阅读数</th>
                        </tr>
                        </thead>
                        <tbody class="oncli">
                        <?php
        		if(empty($data["list"])) {
        		    echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
                        }else{
                        $html = '';

                        foreach ($data['list'] as $p) {
                            $top = '';
                            if($p['sort']>100){
                               $top = '【置顶】';
                            }

                        $html .= '<tr  data-id="'.$p['uid'].'">';
                        $html .= '<td>'.date('Y-m-d H:i',$p['create_time']).'&nbsp;</td>';

                            $html .= '<td><a href="?_a=web&_u=index.problem&uid='.$p['uid'].'" target="_self"  style="color: #000;">【'.$p['type'].'】'.$p['title'].'</a></td>';
                            $html .= '<td>'.$p['read_cnt'].'</td>';
                            $html .= '<td>'.$top.'</td>';

                            $html .= '</tr>
                        ';
                        }
                        echo $html;
                        }
                        ?>
                        </tbody>
                    </table>
                </div>

                <div class="am-u-sm-12 change_page">
                    <?php
	echo $pagination;
?>
                </div>
            </div>
        </div>
    </div>



    <div class="foot" style="background:#333;clear:both;margin-top:60px;">
        <div class="f-box small-font tc">
            <div class="copy grey">
                    <p></p>
            </div>
        </div>
    </div>
</body>


</html>





<script type="text/javascript" src="/app/web/static/js/header.js"></script>



<script>


    /*
     amazeui 会调用一次change事件,此时不刷新
     */
    var by_amaze_init = 1;
    $('.option_type').change(function(){
//        if(by_amaze_init) {
//            by_amaze_init = 0;
//            return;
//        }
        var type = $(this).val();
        window.location.href='?_a=web&_u=index.problemlist&type=' + type;
    });

    /*
     amazeui 会调用一次change事件,此时不刷新
     */
    var by_amaze_init = 1;
    $('.option_key_btn').click(function(){
        var key = $('.option_key').val();
        //允许关键字为空，表示清空条件
        if(1 || key) {
            window.location.href='?_a=web&_u=index.problemlist&key='+key;
        }
    });
    $('.option_key').keydown(function(e){
        if(e.keyCode == 13) {
            $('.option_key_btn').click();
        }
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

    //分页的
    $('.pagination_page').on('change',function(){
        url = $(this).data('url')+parseInt($(this).val()-1);
        window.location.href=url
    })

    $('.pagination_page').on('keypress',function(){
        var page = $(this).val()
        var width = (25+page.length*10) + 'px'
        $('.pagination_page').css('width',width.toString())
    })
    $(function () {
        $('.pagination_page').keypress()
    })

</script>
</body>
</html>
