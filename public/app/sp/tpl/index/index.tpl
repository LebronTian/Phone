
<div class="newPerson"><a href="javascript:;">新手引导</a></div>

<div class="am-cf am-padding">
  <div class="NewsBar" style="text-align:right;color:#0e90d2;margin:0;padding-right:8%;">
    <ul>
      <!--<li>快马加鞭微信公众号营销平台上线啦!</li>
      <li>好消息! UCTPHP 免费试用啦!</li>-->
    </ul>
  </div>
  <div class="ChangeBar">
    <div class="fans am-u-md-4" style="padding-left:20px;">
      <span class="word">昨日新增粉丝</span>
      <span class="num" id="TodayFans" style="display:none;"><?php echo $fans_yesterday;?></span>
    </div>
    <div class="attention am-u-md-4">
      <span class="word">总关注数</span>
      <a href="?_a=su&_u=sp"><span class="num" id="TotalFans" style="display:none;"><?php echo $fans_total;?></span></a>
    </div>
    <div class="access am-u-md-4" style="padding-left:158px;padding-top:54px;">
      <!-- <span><a href="?_a=su&_u=sp">用户管理入口&gt;&gt;</a></span> -->
    </div>
  </div>
  <!-- 最近常用 -->
  <div class="RegularlyBar">
    <p class="RegularlyTit"><span>最近常用</span></p>
    
    <div class="RegularlyCont">
    <?php
        $cats = array(0 => '伪公众号', 1 => '订阅号', 2 => '服务号', 3 => '企业号');
          //最近使用的模块
          $i = 0;
          foreach(SpMod::getRecentUsedApp() as $r) {
            if($i == 3){
              break;
            }
            $p = WeixinPlugMod::get_plugin_by_dir($r);
            if(empty($_REQUEST['_d']) && ($p['type'] == 'basic') &&
              !strncmp('fk_', WeixinMod::get_current_weixin_public('origin_id'), 3)) {
              continue;
            }
                echo '<li><span class="am-icon-btn"><img src="'.$p['thumb'].'"><a href="?_a='.$p['dir'].'&_u=sp" class="am-text-primary"></a></span><p class="a_tit">'.$p['name'].'</p></li>';
              $i++;
          }
      ?>
      <li><span class="am-icon-btn"><img src="/app/sp/static/images/word-add.png"><a href="?_a=sp&_u=index.pluginstore"></a></span><p class="a_tit">添加</p></li>
      </div>

  </div>
  <!-- 应用版块 -->
  <div class="ApplyBar" style="clear:both;display: none;">

  <div style="width:100%;height:168px;clear:both;" class="show_or_hide">
    <div class="ApplyCont setting" style="margin-right:20px;">
      <div class="left"><img src="/app/sp/static/images/public-set.png"></div>
      <div class="right">
        <p class="title">公众号</p>
        <p class="content">公众号菜单,关注欢迎,关键词回复</p>
        <p class="content">自由设置</p>

        <div class="MaskBar">
          <div class="cont1">
            <p><a href="?_a=default&_u=sp"><img src="/app/sp/static/images/word-edit.png"></a></p>
            <p class="word">默认回复</p>
          </div>
          <div class="cont2">
            <p><a href="?_a=keywords&_u=sp"><img src="/app/sp/static/images/keywords.png"></a></p>
            <p class="word">自定义回复</p>
          </div>

          <div class="cont3">
            <p><a href="?_a=menu&_u=sp"><img src="/app/sp/static/images/menu.png"></a></p>
            <p class="word">自定义菜单</p>
          </div>
          <div class="cont4">
            <p><a href="?_a=welcome&_u=sp"><img src="/app/sp/static/images/hi.png"></a></p>
            <p class="word">欢迎语</p>
          </div>
        </div>

        <div class="Mask"></div>
      </div>
    </div>

    <div class="ApplyCont sendArticle">
      <div class="left"><img src="/app/sp/static/images/books.png"></div>
      <div class="right">
        <p class="title">推文章</p>
        <p class="content">多层次的综合推广利器，信</p>
        <p class="content">息更丰富</p>

        <div class="MaskBar">
          <div class="cont1">
            <p><a href="?_a=material&_u=sp.searcharticle"><img src="/app/sp/static/images/find-article.png"></a></p>
            <p class="word">找文章</p>
          </div>
          <div class="cont2">
            <p><a href="?_a=material&_u=sp.editPicText"><img src="/app/sp/static/images/write-article.png"></a></p>
            <p class="word">写文章</p>
          </div>

          <div class="cont3">
            <p><a href="?_a=mass&_u=sp"><img src="/app/sp/static/images/send-articles.png"></a></p>
            <p class="word">发文章</p>
          </div>
          <div class="cont4">
            <p><a href="?_a=sp&_u=index.pluginstore&cat=content"><img src="/app/sp/static/images/more.png"></a></p>
            <p class="word">更多</p>
          </div>
        </div>

        <div class="Mask"></div>
      </div>
    </div>

  </div>

  <div style="width:100%;height:168px;clear:both;">
    <div class="ApplyCont" style="margin-right:20px;">
       <div class="left" style="padding-top:25px;"><img src="/app/sp/static/images/balloon.png"></div>
      <div class="right">
        <p class="title">做活动</p>
        <p class="content">海量专属的线上、线下微信</p>
        <p class="content">活动，各种吸粉大招，让您</p>
        <p class="content">的运营如此容易</p>
        <div class="MaskBar">
          <div class="cont1">
            <p><a href="?_a=vote&_u=sp"><img src="/app/sp/static/images/vote.png"></a></p>
            <p class="word">投票</p>
          </div>
          <div class="cont2">
            <p><a href="?_a=reward&_u=sp"><img src="/app/sp/static/images/icon.png"></a></p>
            <p class="word">抽奖</p>
          </div>
          <div class="cont3">
            <p><a href="?_a=form&_u=sp"><img src="/app/sp/static/images/form.png"></a></p>
            <p class="word">表单</p>
          </div> 
          <div class="cont4">
            <p><a href="?_a=sp&_u=index.pluginstore&cat=activity"><img src="/app/sp/static/images/more.png"></a></p>
            <p class="word">更多</p>
          </div>
        </div>
        <div class="Mask"></div>
      </div>
    </div>

    <div class="ApplyCont">
      <div class="left" style="padding-top:20px;"><img src="/app/sp/static/images/square.png"></div>
      <div class="right">
        <p class="title">玩游戏</p>
        <p class="content">对当前互联网热门游戏进行</p>
        <p class="content">个性化设置，既能吸引粉丝</p>
        <p class="content">又能达到推广效果</p>
        <div class="MaskBar">
          
        </div>
        <div class="Mask" style="text-align:center;font-size:50px;color:#FFF;line-height:150px;">敬请期待</div>
      </div>
    </div>

  </div>
  <div style="width:100%;height:168px;clear:both;">

  <div class="ApplyCont"  style="margin-right:20px;">
      <div class="left"><img src="/app/sp/static/images/industry.png"></div>
      <div class="right">
        <p class="title">微行业</p>
        <p class="content">各种行业模块，让您轻点鼠标</p>
        <p class="content">构建行业网站</p>

        <div class="MaskBar">
          <div class="cont1">
            <p><a href="?_a=site&_u=sp"><img style="width:88px;height:88px" src="/app/sp/static/images/site.png"></a></p>
            <p class="word">微官网</p>
          </div>
          <div class="cont2">
            <p><a href="?_a=shop&_u=sp"><img style="width:88px;height:88px" src="/app/sp/static/images/shop.png"></a></p>
            <p class="word">微商城</p>
          </div>

          <div class="cont3">
            <p><a href="?_a=old&_u=sp"><img style="width:88px;height:88px" src="/app/sp/static/images/old.png"></a></p>
            <p class="word">微医疗</p>
          </div>
          <div class="cont4">
            <p><a href="?_a=sp&_u=index.pluginstore&cat=industry"><img  style="width:88px;height:88px" src="/app/sp/static/images/more.png"></a></p>
            <p class="word">更多</p>
          </div>
        </div>

        <div class="Mask"></div>
      </div>
    </div>

    <div class="ApplyCont">
      <div class="left" style="padding-top:20px;"><img src="/app/sp/static/images/look.png"></div>
      <div class="right">
        <p class="title">探索发现</p>
        <p class="content">更多神秘功能等您探索发现</p>
        <div class="MaskBar">

            <div class="cont1" style="padding-top:30px;">
              <p>已安装应用：<span class="has_installed"></span></p>
              <p>未安装应用：<span class="none_installed"></span></p>
            </div>
            <div class="cont2">
              <p><a href="?_a=sp&_u=index.servicestore"><img src="/app/sp/static/images/serve.png"></a></p>
              <p class="word">服务商城</p>
            </div>
            <div class="cont3">
              <p><a href="?_a=sp&_u=index.pluginstore"><img src="/app/sp/static/images/plugins.png"></a></p>
              <p class="word">插件商城</p>
            </div>
            <div class="cont4">
              
            </div>
            
         
        </div>
        <div class="Mask"></div>
      </div>
    </div>
    
    <div id="walkthrough-content">
        <div id="walkthrough-1">
            <h3>欢迎进入后台管理系统！</h3>
            <p>点击下一步了解更多...</p>
        </div>

        <div id="walkthrough-2">
            这里是头部菜单栏
        </div>

        <div id="walkthrough-3">
            这里是侧边栏导航菜单
        </div>

        <div id="walkthrough-4">
            最近使用过功能在这里哦~~
        </div>

        <div id="walkthrough-5">
            功能模块在这里展示哦~~
        </div>
    </div>
    

  </div>

  </div>
  <!-- <div class="hr_200"></div> -->


</div>

<?php
  $extra_js = array(
    '/app/sp/static/js/new-index.js',
    '/app/sp/static/js/jquery.pagewalkthrough.min.js',
    '/app/sp/static/js/new-person.js',
    '/app/sp/static/js/install.js'
  );
?>
<script>
  var visitData = <?php echo(!empty($visit))? json_encode($visit):"null" ?>
</script>


