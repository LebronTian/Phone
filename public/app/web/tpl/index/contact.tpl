<!doctype html>
<html class="no-js">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>UCT微信O2O营销平台- 商户后台管理系统</title>
  <meta name="description" content="UCT微信O2O公众号营销平台 ">
  <meta name="keywords" content="UCT 微信 O2O 公众号 营销 ">
  <meta name="renderer" content="webkit">
  <meta http-equiv="Cache-Control" content="no-siteapp" />
  <link rel="shortcut icon" href="/favicon.ico"/>
  <link rel="bookmark" href="/favicon.ico"/>
  <meta name="apple-mobile-web-app-title" content="Amaze UI" />
  <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
  <style type="text/css">
    body, html{width: 100%;height: 100%;margin:0;font-family:"微软雅黑";font-size:14px;}
    #l-map{height:300px;width:100%;}
    #r-result{width:100%;}
  </style>
  <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=ChNiw5pq03tmYVDeNGARA6vN"></script>
  
  <link rel="stylesheet" type="text/css" href="/static/css/amazeui2.1.min.css">
  <link rel="stylesheet" type="text/css" href="/app/sp/static/css/login.css">
 
</head>
<body style="min-width:1170px;overflow-x:hidden;background-color:#FFF;">

    <!-- 头部 -->
    <?php 
      include $tpl_path.'/header_n.tpl';
    ?>



    <!-- 主体 -->
    <div class="web_info_bar" style="width:1000px;margin:50px auto;">
      <?php 
        include $tpl_path.'/left_bar.tpl';
      ?>

      <div class="right meb_container">
                    <div class="meb_box">
                        <div class="meb_info">
                            


<div class="content_item" style="background-color:#EEE;">
    <div class="post">
        <h1 style="background-color:#EEE; border-left: 5px solid #4168E2; margin-bottom: 5px;">&nbsp;联系方式
        </h1>
        <div class="post_cont" style="padding:20px;">
            <div id="l-map"></div>
            <div id="r-result">请输入:<input type="text" id="suggestId" size="20" value="深圳市创新谷" style="width:240px;" /></div>
            <div id="searchResultPanel" style="border:1px solid #C0C0C0;width:150px;height:auto; display:none;"></div>
            <div>地址：深圳市南山区TCL国际E城多媒体大厦</div>
            <div>电话：15820425082</div>
            <div>手机：0755-36300086</div>
        </div>
    </div>
</div>



                        </div>
                    </div>
                </div>

    </div>
    
    <div style="clear:both;"></div>

    <?php 
      include $tpl_path.'/footer.tpl';
    ?>

    


<script src="/static/js/jquery2.1.min.js"></script>
<script src="/static/js/amazeui2.1.min.js"></script>
<script type="text/javascript" src="/app/web/static/js/header.js"></script>
<script type="text/javascript">
  // 百度地图API功能
  function G(id) {
    return document.getElementById(id);
  }

  var map = new BMap.Map("l-map");
  map.centerAndZoom("深圳",12);                   // 初始化地图,设置城市和地图级别。

  var ac = new BMap.Autocomplete(    //建立一个自动完成的对象
    {"input" : "suggestId"
    ,"location" : map
  });

  ac.addEventListener("onhighlight", function(e) {  //鼠标放在下拉列表上的事件
  var str = "";
    var _value = e.fromitem.value;
    var value = "";
    if (e.fromitem.index > -1) {
      value = _value.province +  _value.city +  _value.district +  _value.street +  _value.business;
    }    
    str = "FromItem<br />index = " + e.fromitem.index + "<br />value = " + value;
    
    value = "";
    if (e.toitem.index > -1) {
      _value = e.toitem.value;
      value = _value.province +  _value.city +  _value.district +  _value.street +  _value.business;
    }    
    str += "<br />ToItem<br />index = " + e.toitem.index + "<br />value = " + value;
    G("searchResultPanel").innerHTML = str;
  });

  var myValue;
  ac.addEventListener("onconfirm", function(e) {    //鼠标点击下拉列表后的事件
  var _value = e.item.value;
    myValue = _value.province +  _value.city +  _value.district +  _value.street +  _value.business;
    G("searchResultPanel").innerHTML ="onconfirm<br />index = " + e.item.index + "<br />myValue = " + myValue;
    
    setPlace();
  });

  function setPlace(){
    map.clearOverlays();    //清除地图上所有覆盖物
    function myFun(){
      var pp = local.getResults().getPoi(0).point;    //获取第一个智能搜索的结果
      map.centerAndZoom(pp, 18);
      map.addOverlay(new BMap.Marker(pp));    //添加标注
    }
    var local = new BMap.LocalSearch(map, { //智能搜索
      onSearchComplete: myFun
    });
    local.search(myValue);
  }


</script>

</body>
</html>
