<head>
<style type="text/css">
    #headBox{
        min-width: 1170px;
        width: 100%;
        height: 70px;
        /*position: fixed;
        left: 0;
        top: 0;*/
        z-index: 99;
    }
    .section{ position: relative;}
    .logo{
        display: inline-block;
        margin-left: 88px;
        margin-top: 9px;
    }
    .headNav{
        width: 830px;
        position: absolute;
        top: 2px;
        right: -60px;
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
    .select_menu{ width: 142px; display: none; position: absolute; left: 20px; top: 12px; padding: 5px 5px 10px; text-align: left;}
    .select_menu li{ width: 100%; height: 28px; line-height: 28px;}
    .select_menu li a{ font-size: 16px; padding: 0;}
</style>
</head>
<div id="headBox">
    <a href="/" class="logo"><img src="/app/web/static/images/blue/logo.png" alt="logo"></a>
    <ul class="headNav">
        <li><a href="/">首页</a></li>
        <li style="position:relative;" class="select_li">
          <a href="javascript:;">产品服务<span>+</span></a>
          <ul class="select_menu">
               <li><a href="http://msms.uctphp.com">快捷短信群发</a></li>
               <li><a href="?_easy=web.index.mall&mall=1">优商城</a></li>
               <li><a href="?_easy=web.index.ticket&ticket=1">优车票</a></li>
               <li><a href="?_easy=web.index.master&master=1">运营大师</a></li>
		<!--
               <li><a href="?_easy=web.index.exhibition&exhibition=1">展示型公众号</a></li>
               <li><a href="?_easy=web.index.marketing&marketing=1">营销型公众号</a></li>
               <li><a href="?_easy=web.index.industry&industry=1">行业型公众号</a></li>
		-->
          </ul>
        </li>
        <li class="customer_link"><a href="?_easy=web.index.customer&customer=1">客户案例</a></li>
        <li class="partnership_link" style="display:none;"><a href="?_easy=web.index.partnership&partnership=1">合作加盟</a></li>
        <li style="position:relative;" class="select_li">
            <a href="?_a=web&_u=index.about&about=1" target="_black">关于我们<span>+</span></a>
            <ul class="select_menu">
               <li><a href="?_easy=web.index.about&about=1">关于快马加鞭</a></li>
               <li><a href="?_easy=web.index.joinus&joinus=1">加入我们</a></li>
               <li><a href="?_easy=web.index.contact&contact=1">联系方式</a></li>
               <li><a href="?_easy=web.index.statement&statement=1">免责声明</a></li>
            </ul>
        </li>
        <li style="position:relative;" class="select_li">
            <a href="javascript:;" target="_black">帮助<span>+</span></a>
            <ul class="select_menu">
                <li><a href="?_a=web&_u=index.help&help=1">使用教程</a></li>
                <li><a href="?_easy=web.index.develop_document&develop_document=1">开发文档</a></li>
                <li><a href="?_easy=web.index.support&support=1">技术支持</a></li>
            </ul>
        </li>
        <li><a href="?_a=sp&_u=index.login" style="padding-right:0;">登录</a> <a href="?_a=sp&_u=index.register" style="padding-left:5px;">注册</a></li>
        <!-- <li><a href="?_a=sp&_u=index.register">注册</a></li> -->
    </ul>
</div>
