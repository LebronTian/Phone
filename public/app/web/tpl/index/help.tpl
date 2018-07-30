<!doctype html>
<html class="no-js">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>UCT微信O2O营销平台- 商户后台管理系统</title>
  <meta name="description" content="UCT微信O2O公众号营销平台 ">
  <meta name="keywords" content="UCT 微信 O2O 公众号 营销 ">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
  <meta name="renderer" content="webkit">
  <meta http-equiv="Cache-Control" content="no-siteapp" />
  <link rel="shortcut icon" href="/favicon.ico"/>
  <link rel="bookmark" href="/favicon.ico"/>
  <meta name="apple-mobile-web-app-title" content="Amaze UI" />
  
  <link rel="stylesheet" type="text/css" href="/static/css/amazeui2.1.min.css">
  <link rel="stylesheet" type="text/css" href="/app/sp/static/css/login.css">
  <link rel="stylesheet" type="text/css" href="/app/web/static/css/help.css">
 
</head>
<body style="min-width:1170px;overflow-x:hidden;background-color:#FFF">

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
        <div class="content_item">
            <div class="post" style="overflow: hidden;">
                <h1 style="background-color:#EEE; border-left: 5px solid #4168E2; margin-bottom: 5px;">&nbsp;使用教程
                </h1>
          </div>
        </div>



      </div>
    </div>


    <div style="/*margin-right: 200px;*/">
      <select data-am-selected class="option_cat">
        <optgroup label="请选择您想了解的组件">
          <!-- <option value="all">全部分类</option>
          <option value="basic">公众号</option>
          <option value="content">内容</option>
          <option value="advance">高级</option>
          <option value="activity">活动</option>
          <option value="hardware">智能硬件</option>
          <option value="industry">行业</option>
          <option value="tool">工具</option>
          <option value="game">游戏</option>
          <option value="other">其他</option> -->
          <?php
            $html = '<option value="all"';
            if(!$option['cat']) $html .= ' selected ';
            $html .= '>全部分类</option>';
            
            foreach($cats as $k => $cat) {
            $html .= '<option value="'.$k.'"';
            if($option['cat'] == $k) $html .= ' selected';
            $html .= '>'.$cat['name'].'</option>';
            }
            echo $html;
          ?>
        </optgroup>
      </select>
              
      <div style="float: right;">
        <input type="text" class="am-form-field search_input option_key" value="">
        <button class="search_btn option_key_btn" type="button" id="search_btn">搜索</button>
      </div>

      <div class="case_box">
        <?php
          #var_export($option);
          #var_export($cats);
          #var_export($data['list']);
        ?>
        <?php
          if(!$data['list']) {
            echo '<div>暂无数据！</div>';
          }
          else {
            $html = '';
            foreach($data['list'] as $l) {
              $html .= '
              <div class="case">
                <img src="'.$l['thumb'].'">
                <p>'.$l['name'].'</p>
                <div class="case_intro">
                    <img src="'.$l['thumb'].'">
                    <span>'.$l['name'].'</span>
                    <p>使用简介：</p>
                    <p>'.$l['brief'].'</p>
                </div>
             </div>';
            }
            echo $html;
          }
        ?>
<!--          <div class="case">
            <img src="/app/domain/static/images/icon.png">
            <p>域名绑定</p>
            <div class="case_intro">
                <img src="/app/domain/static/images/icon.png">
                <span>域名绑定</span>
                <p>试用教程：</p>
                <p>绑定域名绑定域名</p>
            </div>
         </div> -->
   
      </div><!--end of case_box-->

      <div style="clear: both;">
        <?php
          echo $pagination;
        ?>
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
<script type="text/javascript" src="/app/web/static/js/help.js"></script>
</body>
</html>
