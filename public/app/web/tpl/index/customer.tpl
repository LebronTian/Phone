<!doctype html>
<html class="no-js">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>深圳市快马加鞭科技有限公司</title>
  <meta name="description" content="微信公众号订阅号服务号精致设计极速开发">
  <meta name="keywords" content="三级分销 分销商城 微信公众号 定制开发 微信营销">
  <meta name="renderer" content="webkit">
  <meta http-equiv="Cache-Control" content="no-siteapp" />
  <link rel="shortcut icon" href="/favicon.ico"/>
  <link rel="bookmark" href="/favicon.ico"/>
  <meta name="apple-mobile-web-app-title" content="Amaze UI" />
  
  <link rel="stylesheet" type="text/css" href="/static/css/amazeui2.1.min.css">
  <link rel="stylesheet" type="text/css" href="app/web/static/css/reset.css">
  <link rel="stylesheet" type="text/css" href="app/web/static/css/customer.css">
<style>
*,ul,li{margin:0;padding:0}  
ul,li{list-style:none}
#headBox {
  min-width: 1100px;
  width: 100%;
  height: 70px;
  /*position: absolute;
  left: 0;
  top: 0;*/
  z-index: 99;

}
.logo {
  display: inline-block;
  margin-left: 88px;
  margin-top: 9px;
}
.headNav {
  width: 805px;
  position: absolute;
  top: 18px;
  right: 40px;
  margin: 1.6em;
}
.headNav li {
  float: right;
}
.headNav li a {
  display: inline-block;
  padding: 0 20px;
  color: #FFF;
  font-size: 18px;
}
.bg_img{position:absolute;top:0;z-index:-10;height:655px;overflow:hidden;background-color:#52B4D0;width:100%;}
.bg_img>img{width:100%;}
</style>


</head>
<body style="min-width:1100px;overflow-x:hidden;background-color:#FFFFFF;">
<!-- <div class="bg_img">
<img src="/app/web/static/images/customer_bg.png">
</div> -->
   <?php 
      include $tpl_path.'/header_n.tpl';
    ?>

      <!-- banner开始 -->
  <div class="banner">
    <div class="comWidth">
      <img src="app/web/static/images/customer/banner.png">
      <p>在这里您能找到不同行业的真实客户案例<br/>及他们的解决方式，进而发现您真正的需求<br/>让您的公众号绽放光彩</p>
    </div>
  </div>
  <!-- banner结束 -->
  <!-- 主体内容开始 -->
  <div class="comWidth main">
    <div class="main_left">
      <ul class="sideBar" id="sideBar">
        <li class="active"><a name="#main_present" style="color:#0e90d2;">展示版</a></li>
        <li><a name="#main_sell">营销版</a></li>
        <li><a name="#main_industry">行业版</a></li>
        <li><a name="#main_pc">PC版</a></li>
      </ul>
      <div class="floatr"></div>
    </div>

    <div class="main_right" id="main_right">
      <!-- 展示版  -->
      <div class="industry" id="main_present">
        <div class="case">
          <div class="case_bg">
            <img src="app/web/static/images/customer/aishi.png" alt="">
            <div class="case_intro">
              <img src="app/web/static/images/customer/aishi_logo.png">
              <h4>爱视微信</h4>
              <p>国内领先眼科医疗服务供应商</p>
            </div>
            <div class="case_code">
              <img src="app/web/static/images/customer/aishi_code.jpg">
            </div>
          </div>
          <div class="case_img_r1">
            <img src="app/web/static/images/customer/aishi_1.png">
          </div>
          <div class="case_img_r2">
            <img src="app/web/static/images/customer/aishi_2.png">
          </div>
        </div>

		<!--
        <div class="case">
          <div class="case_bg">
            <img src="app/web/static/images/customer/homepage.png">
            <div class="case_intro">
              <img src="app/web/static/images/customer/homepage_logo.png">
              <h4>UCT官网</h4>
              <p>深圳市快马加鞭科技有限公司</p>
            </div>
            <div class="case_code">
              <img src="app/web/static/images/customer/homepage_code.jpg">
            </div>
          </div>  
          <div class="case_img_l1">
            <img src="app/web/static/images/customer/homepage_1.png">
          </div>
          <div class="case_img_r1">
            <img src="app/web/static/images/customer/homepage_2.png">
          </div>
        </div>        
		-->

      </div>

      <!-- 营销版 -->
      <div class="pc" id="main_sell">
        <div class="case">
          <div class="case_bg">
            <img src="app/web/static/images/customer/dial.png">
            <div class="case_intro">
              <img src="app/web/static/images/customer/homepage_logo.png">
              <h4>幸运大转盘</h4>
              <p>自定义定制专属幸运转盘活动</p>
            </div>
            <div class="case_code">
              <img src="app/web/static/images/customer/dial_code.png" >
            </div>
          </div>
          <div class="case_img_r1">
            <img src="app/web/static/images/customer/dial_1.png">
          </div>
          <div class="case_img_r2">
            <img src="app/web/static/images/customer/dial_2.png">
          </div>
        </div>
        <div class="case">
          <div class="case_bg">
            <img src="app/web/static/images/customer/minions.png">
            <div class="case_intro">
              <img src="app/web/static/images/customer/minions_logo.png">
              <h4>小黄人</h4>
              <p>麦当劳活动<br/>30天8万粉丝，27万次参与</p>
            </div>
            <div class="case_code">
              <img src="app/web/static/images/customer/minions_code.png">
            </div>
          </div>  
          <div class="case_img_l1">
            <img src="app/web/static/images/customer/minions_1.png">
          </div>
          <div class="case_img_r1">
            <img src="app/web/static/images/customer/minions_2.png">
          </div>
        </div>
        <div class="case">
          <div class="case_bg">
            <img src="app/web/static/images/customer/nxt_card.png">
            <div class="case_intro">
              <img src="app/web/static/images/customer/nvxing_logo.png">
              <h4>女行团会员卡</h4>
              <p>女行团会员卡</p>
            </div>
            <div class="case_code">
              <img src="app/web/static/images/customer/nxt_card_code.jpg">
            </div>
          </div>
          <div class="case_img_l2">
            <img src="app/web/static/images/customer/nxt_card_1.png">
          </div>
          <div class="case_img_l1">
            <img src="app/web/static/images/customer/nxt_card_2.png">
          </div>
        </div>
        <div class="case">
          <div class="case_bg">
            <img src="app/web/static/images/customer/dial_c.png">
            <div class="case_intro">
              <img src="app/web/static/images/customer/homepage_logo.png">
              <h4>圣诞大转盘</h4>
              <p>自定义定制专属圣诞转盘活动</p>
            </div>
            <div class="case_code">
              <img src="app/web/static/images/customer/dial_c_code.png">
            </div>
          </div>
          <div class="case_img_r1">
            <img src="app/web/static/images/customer/dial_c_1.png">
          </div>
          <div class="case_img_r2">
            <img src="app/web/static/images/customer/dial_c_2.png">
          </div>
        </div>
        <div class="case">
          <div class="case_bg">
            <img src="app/web/static/images/customer/couple.png">
            <div class="case_intro">
              <img src="app/web/static/images/customer/homepage_logo.png">
              <h4>消灭小情侣</h4>
              <p>消灭小情侣七夕小游戏</p>
            </div>
            <div class="case_code">
              <img src="app/web/static/images/customer/couple_code.png">
            </div>
          </div>  
          <div class="case_img_l1">
            <img src="app/web/static/images/customer/couple_1.png">
          </div>
          <div class="case_img_r1">
            <img src="app/web/static/images/customer/couple_2.png">
          </div>
        </div>
        <div class="case">
          <div class="case_bg">
            <img src="app/web/static/images/customer/jiuyang.png">
            <div class="case_intro">
              <img src="app/web/static/images/customer/jiuyangLogo.png">
              <h4>九阳商城</h4>
              <p>九阳商城</p>
            </div>
            <div class="case_code">
              <img src="app/web/static/images/customer/jiuyangcode.jpg">
            </div>
          </div>
          <div class="case_img_l2">
            <img src="app/web/static/images/customer/jiuyangnext1.png">
          </div>
          <div class="case_img_l1">
            <img src="app/web/static/images/customer/jiuyangnext2.png">
          </div>
        </div>
        <!-- nihao -->
        <div class="case" style="display: block;">
          <div class="case_bg">
            <img src="app/web/static/images/customer/lili2.png" alt="">
            <div class="case_intro">
              <img src="app/web/static/images/customer/homepage_code.jpg">
              <h4>喱喱学车</h4>
              <p>喱喱学车</p>
            </div>
            <div class="case_code">
              <img src="app/web/static/images/customer/lilicode.png">
            </div>
          </div>
          <div class="case_img_r1">
            <img src="app/web/static/images/customer/lili1.png">
          </div>
          <div class="case_img_r2">
            <img src="app/web/static/images/customer/lili3.png">
          </div>
        </div>
      </div>
      <!-- 行业版 -->
      <div class="industry" id="main_industry">
        <div class="case">
          <div class="case_bg">
            <img src="app/web/static/images/customer/nvxing.png">
            <div class="case_intro">
              <img src="app/web/static/images/customer/nvxing_logo.png">
              <h4>女行团</h4>
              <p>为爱摄影爱旅行女性量身定制</p>
            </div>
            <div class="case_code">
              <img src="app/web/static/images/customer/nvxing_code.jpg">
            </div>
          </div>
          <div class="case_img_r1">
            <img src="app/web/static/images/customer/nvxing_1.png">
          </div>
          <div class="case_img_r2">
            <img src="app/web/static/images/customer/nvxing_2.png">
          </div>
        </div>
        <div class="case">
          <div class="case_bg">
            <img src="app/web/static/images/customer/yanglao.png">
            <div class="case_intro">
              <img src="app/web/static/images/customer/yanglao_logo.png">
              <h4>唯有家</h4>
              <p>一站式居家养老服务</p>
            </div>
            <div class="case_code">
              <img src="app/web/static/images/customer/yanglao_code.jpg">
            </div>
          </div>  
          <div class="case_img_l1">
            <img src="app/web/static/images/customer/yanglao_1.png">
          </div>
          <div class="case_img_r1">
            <img src="app/web/static/images/customer/yanglao_2.png">
          </div>
        </div>
        <div class="case">
          <div class="case_bg">
            <img src="app/web/static/images/customer/ticket.png">
            <div class="case_intro">
              <img src="app/web/static/images/customer/ticket_logo.png">
              <h4>优车票</h4>
              <p>春运车票贩售系统</p>
            </div>
            <div class="case_code">
              <img src="app/web/static/images/customer/ticket_code.jpg">
            </div>
          </div>
          <div class="case_img_l2">
            <img src="app/web/static/images/customer/ticket_1.png">
          </div>
          <div class="case_img_l1">
            <img src="app/web/static/images/customer/ticket_2.png">
          </div>
        </div>
        <div class="case">
          <div class="case_bg">
            <img src="app/web/static/images/customer/youyuan.png">
            <div class="case_intro">
              <img src="app/web/static/images/customer/youyuan_logo.png">
              <h4>有园酒店</h4>
              <p>一家强调社交的艺术酒店</p>
            </div>
            <div class="case_code">
              <img src="app/web/static/images/customer/youyuan_code.jpg">
            </div>
          </div>
          <div class="case_img_r1">
            <img src="app/web/static/images/customer/youyuan_1.png">
          </div>
          <div class="case_img_r2">
            <img src="app/web/static/images/customer/youyuan_2.png">
          </div>
        </div>
        <div class="case">
          <div class="case_bg">
            <img src="app/web/static/images/customer/zhaohuo.png">
            <div class="case_intro">
              <img src="app/web/static/images/customer/zhaohuo_logo.png">
              <h4>安心找活微信</h4>
              <p>快速记工实时备份</p>
            </div>
            <div class="case_code">
              <img src="app/web/static/images/customer/zhaohuo_code.png">
            </div>
          </div>  
          <div class="case_img_l1">
            <img src="app/web/static/images/customer/zhaohuo_1.png">
          </div>
          <div class="case_img_r1">
            <img src="app/web/static/images/customer/zhaohuo_2.png">
          </div>
        </div>
      </div>
      <!-- PC版 -->
      <div class="pc" id="main_pc">
        <div class="pc_case_l">
          <a href="http://www.kaihuia.com/" target="_blank">
            <div class="pc_case_pic">
              <img src="app/web/static/images/customer/dadou_pc.png">
            </div>            
            <div class="pc_case_intro">
              <img src="app/web/static/images/customer/dadou_logo.png">
              <h4>大豆活动</h4>
              <p>提供一站式会展活动服务</p>
            </div>
          </a>
        </div>
        <div class="pc_case">
          <a href="http://hotel.uctoo.com" target="_blank">
            <div class="pc_case_pic">
              <img src="app/web/static/images/customer/youyuan_pc.png">
            </div>            
            <div class="pc_case_intro">
              <img src="app/web/static/images/customer/youyuan_logo_b.png">
              <h4>有园酒店</h4>
              <p>一家强调社交的艺术酒店</p>
            </div>
          </a>
        </div>
        <div class="pc_case">
          <a href="http://jgzpw.com/" target="_blank">
            <div class="pc_case_pic">
              <img src="app/web/static/images/customer/zhaohuo_pc.png">
            </div>            
            <div class="pc_case_intro">
              <img src="app/web/static/images/customer/zhaohuo_logo.png">
              <h4>安心找活</h4>
              <p>快速记工实时备份</p>
            </div>
          </a>
        </div>
        <div class="pc_case_l">
          <a href="http://www.zksofa.com/" target="_blank">
            <div class="pc_case_pic">
              <img src="app/web/static/images/customer/zuoke_pc.png">
            </div>            
            <div class="pc_case_intro">
              <img src="app/web/static/images/customer/zuoke_logo.png">
              <h4>坐客</h4>
              <p>自由搭配选沙发不醉不累</p>
            </div>
          </a>
        </div>
        <div class="pc_case">
          <a href="http://www.eyeis.com" target="_blank">
            <div class="pc_case_pic">
              <img src="app/web/static/images/customer/aishi_pc.png">
            </div>            
            <div class="pc_case_intro">
              <img src="app/web/static/images/customer/aishi_logo.png">
              <h4>爱视集团</h4>
              <p>领先眼科医疗服务供应商</p>
            </div>
          </a>
        </div>
        <div class="pc_case">
          <a href="http://www.innovalley.com.cn" target="_blank">
            <div class="pc_case_pic">
              <img src="app/web/static/images/customer/chuangxin_pc.png">
            </div>            
            <div class="pc_case_intro">
              <img src="app/web/static/images/customer/chuangxin_logo.png">
              <h4>创新谷</h4>
              <p>中国最活跃的互联网孵化器和天使投资基金之一</p>
            </div>
          </a>
        </div>
        <div class="pc_case_l">
          <a href="http://4.works" target="_blank">
            <div class="pc_case_pic">
              <img src="app/web/static/images/customer/raven_pc.png">
            </div>            
            <div class="pc_case_intro">
              <img src="app/web/static/images/customer/raven_logo.png">
              <h4>无人机</h4>
              <p>4.0智造工厂</p>
            </div>
          </a>
        </div>
        <div class="pc_case">
          <a href="http://uku.uctoo.com" target="_blank">
            <div class="pc_case_pic">
              <img src="app/web/static/images/customer/youku_pc.png">
            </div>            
            <div class="pc_case_intro">
              <img src="app/web/static/images/customer/youku_logo.png">
              <h4>优库网</h4>
              <p>印刷设备供应商</p>
            </div>
          </a>
        </div>
      </div>
    </div>
  </div>
  <!-- 主体内容结束 -->

<!--<style>
  .show_box{width:1100px;height:655px;padding-top:110px;margin:0px auto;margin-bottom:0}
  .show_header{height:70px;line-height:70px;font-size:30px;color:white;border-bottom:thin solid white}
  .show_detail{height:474px;}
  .show_detail>.left_box{float:left;width:250px;border-right:thin solid white;height:475px;}
  .show_detail>.left_box>div:first-child{margin-top:40px;}
  .show_detail>.left_box>div{padding:3px 0;color:white;font-size:20px;margin-bottom:10px;cursor:pointer;text-align:center;width:92px}
  .show_detail>.left_box>#is_click{border:thin solid white;border-radius:5px;-moz-border-radius: 5px;
  -webkit-border-radius: 5px;}
  .show_detail>.right_box{float:left;height:474px;width:850px;position:relative;}
  .show_detail>.right_box>img{margin:40px 87px 0 87px;}
  .show_detail>.right_box>.module_title{color:white;font-size:22px;position:absolute;left:222px;top:50px;}
  .show_detail>.right_box>.module_detail{position:absolute;left:237px;font-size:16px;color:white;top:140px;display:none;}
  .show_detail>.right_box>#is_show{display:block;}
  .show_detail>.right_box>.module_detail>div{padding:2px 0;}
</style>-->
<!-- <div class="show_box">
    <div class="show_header">应用中心</div>
    <div class="show_detail">
        <div class="left_box">
          <div data-id="1" id="is_click">特色模块</div>
          <div data-id="2">互动模块</div>
          <div data-id="3">营销模块</div>
          <div data-id="4">硬件模块</div>
        </div>
        <div class="right_box">
          <img src="/app/web/static/images/case_bg.png">
          <div class="module_title">特色模块</div>
          <div class="module_detail detail1" id="is_show">
            <div>微官网</div>
            <div>微网站</div>
            <div>楼层导览</div>
            <div>品牌导购</div>
            <div>微商城</div>
            <div>个人中心</div>
            <div>统计模块</div>
          </div>
          <div class="module_detail detail2">
            <div>大转盘</div>
            <div>刮刮卡</div>
            <div>砸金蛋</div>
            <div>优惠券</div>
          </div>
          <div class="module_detail detail3">
            <div>微社区</div>
            <div>微投票</div>
            <div>微信墙</div>
            <div>微博</div>
          </div>
          <div class="module_detail detail4">
            <div>商业WIFI</div>
            <div>智慧停车卡</div>
          </div>
        </div>
    </div>
</div> -->
<!--<style>
   .case_box{width:1100px;height:auto;margin:40px auto;}
   .case_header{text-align:right;height:72px;border-bottom:thin solid #52B4CF}
   .case_header>span{margin-right:50px;font-size:32px;color:#52B4CF;line-height:72px}-->
   <style>
   .footer{height:70px;color:#52B4CF;font-size:16px;text-align:center;line-height:70px}
  .footer>img{width:15px;}
  </style>
  <!--.case_detail{}
  .case_right{float:right;width:250px;text-align:center;margin-top:50px}
  .case_right>div{height:40px;line-height:40px}
  .case_right>div>a{padding:2px 8px;color:#52B4CF;cursor:pointer;}
  #ischose{border:thin solid #52B4CF;border-radius:5px;-moz-border-radius: 5px;
  -webkit-border-radius: 5px;}
  .case_left{width:850px;margin: 20px auto;min-height:300px;}
  .case_left>.wap_box>ul{width:930px}
  .case_left>.wap_box>ul>li{display:inline;margin-right:70px;position:relative;width:210px;}
  .case_left>.wap_box>ul>li>img{margin-top:30px;width:210px;height:210px;border:thin solid #52B4CF;}
  .wap_box .detail_box{position:absolute;top:-100px;left:200px;width:320px;height:250px;background-color:white;border:thin solid #52B4D0;border-radius:5px;z-index:200;display:none}
  .wap_box .detail_box>.case_view{height:230px;float:left;margin:10px;width:146px}
  .wap_box .detail_box>.case_erweima{position:absolute;bottom:10px;left:190px;width:96px;height:96px;}
  .wap_box .detail_box>p{font-size:14px;margin-top:10px;margin-right:10px;margin-bottom:0;line-height:20px;text-align: justify;}
  .wap_box .btn_show{width:210px;height:210px;background-color:rgba(0,0,0,0.5);line-height:210px;text-align: center;position:absolute;top:-77px;left:0;color:white;display:none;}
</style>
<div class="case_box">-->
  <!-- <div class="case_header">
    <span>客户案例</span>
  </div> -->
 <!-- <div class="case_detail">-->
    <!-- <div class="case_right">
      <div><a>PC端案例</a></div>
      <div><a>移动端案例</a></div>
    </div> -->
 <!--   <div class="case_left">
      <div class="wap_box">
      <ul>
        <li>
            <img src="/app/web/static/images/minions.jpg">
            <div class="btn_show">
                点击查看详情
            </div>
            <div class="detail_box">
                <img class="case_view" src="/app/web/static/images/minion_small.png">
                <p>麦当劳，寻找小黄人，30天8万粉丝，27万次参与。Uctoo针对餐饮行业揽客、会员、营销等需求，提供精准互联网+解决方案。</p>
                <img class="case_erweima" src="/app/web/static/images/minion_erweima.png">
            </div>
        </li>
        <li><img src="/app/web/static/images/mudidi.jpg">
        	<div class="btn_show">
                点击查看详情
            </div>
            <div class="detail_box">
                <img class="case_view" src="/app/web/static/images/mdd_small.png">
                <p>目的地：寻找旅游目的地的私人向导，Uctoo为线上线下旅游服务结合提供平台开发支撑。</p>
                <img class="case_erweima" src="/app/web/static/images/mdd_erweima.png">
            </div>
        </li>
        <li><img src="/app/web/static/images/laimeng.jpg">
        	<div class="btn_show">
                点击查看详情
            </div>
            <div class="detail_box">
                <img class="case_view" src="/app/web/static/images/laimeng_small.png">
                <p>莱蒙国际：东莞莱蒙商业中心指定O2O方案解决商，为商场森马、叮叮码头等品牌提供线上到线下运营方案。</p>
                <img class="case_erweima" src="/app/web/static/images/laimeng_erweima.png">
            </div>
        </li>
        <li><img src="/app/web/static/images/eyeis.jpg">
        	<div class="btn_show">
                点击查看详情
            </div>
            <div class="detail_box">
                <img class="case_view" src="/app/web/static/images/eyeis_small.png">
                <p>爱视集团：领先的眼科医疗服务供应商，通过UCtoo构建咨询发布、咨询诊断、智能导诊及后期跟踪等一系列全程020服务。为患者</p>
                <img class="case_erweima" src="/app/web/static/images/eyeis_erweima.png">
            </div>
        </li>      
        <li><img src="/app/web/static/images/uku.jpg">
        	<div class="btn_show">
                点击查看详情
            </div>
            <div class="detail_box">
                <img class="case_view" src="/app/web/static/images/uku_small.png">
                <p>优库网：以众包及O2O的方式，实现高效精益的仓储管理与交易。</p>
                <img class="case_erweima" src="/app/web/static/images/uku_erweima.png">
            </div>
        </li>    
        <li><img src="/app/web/static/images/zuoke.png">
        	<div class="btn_show">
                点击查看详情
            </div>
            <div class="detail_box">
                <img class="case_view" src="/app/web/static/images/zuoke_small.jpg">
                <p>家居业中的“小米”，针对85后个性化需求，提供可随意组合的家居。区别一般通用化电子商城，UCtoo独家提供个性化定制电商系统。</p>
                <img class="case_erweima" src="/app/web/static/images/zuoke_erweima.png">
            </div>
        </li>
      </ul>
      </div>
    </div>
  </div>
</div>-->
    
<div class="footer">
  <span>2015 深圳市快马加鞭科技有限公司</span><span>&nbsp;&nbsp;|&nbsp;&nbsp;</span><span><img src="/app/web/static/images/phone.png"></span><span>&nbsp;&nbsp;0755-36300086</span>
</div>

<script src="/static/js/jquery2.1.min.js"></script>
<script src="/static/js/amazeui2.1.min.js"></script>
<script type="text/javascript" src="/app/web/static/js/header.js"></script>
<script type="text/javascript" src="/app/web/static/js/customer.js"></script>
<!--<script>
  $('.show_detail>.left_box>div').click(function(){
      $('.show_detail>.left_box>div').attr('id','');
      $(this).attr('id','is_click');
      var show_id=$(this).attr('data-id');
      $('.show_detail>.right_box>.module_detail').attr('id','');
      $('.show_detail>.right_box>.module_title').text($(this).text());
      $('.detail'+show_id).attr('id','is_show');
  });
  $('.wap_box .btn_show').click(function(){
    $(this).siblings('.detail_box').toggle();
  });
  $('.wap_box>ul>li>img').mouseover(function(){
    $(this).siblings('.btn_show').show();
  });
  $('.wap_box .btn_show').mouseout(function(){
    $(this).hide();
    $(this).siblings('.detail_box').hide();
  });
  function getUrlParam(name) {  
   var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象  
   var r = window.location.search.substr(1).match(reg);  //匹配目标参数  
   if (r != null) return unescape(r[2]); return null; //返回参数值  
  }
  var customer = getUrlParam('customer');
  if(customer=='1'){
    $('.customer_link').find('a').css('color','#0e90d2');
  } 
</script>-->
</body>
</html>
