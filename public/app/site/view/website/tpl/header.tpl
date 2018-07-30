<!DOCTYPE html>
<html>
<head lang="en">
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
  <meta property="qc:admins" content="<?php 
  echo Dba::readone('select property from thirdlogin_qq_public where sp_uid="'. AccountMod::require_sp_uid(). '"'); ?>" />
  <meta name="renderer" content="ie-comp"/>
  <meta name="viewport"
        content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <meta name="format-detection" content="telephone=no">
  <meta name="renderer" content="webkit">
  <meta http-equiv="Cache-Control" content="no-siteapp"/>
  
  <link rel="stylesheet" href="/app/site/view/website/static/css/style.css"/>
  <link href="/app/site/view/website/static/css/adipoli.css" rel="stylesheet"/>
  <title><?php echo $site['title']?></title>
</head>
<body>

<div class="header" id="header">

      <div class="header_box" style="position:relative">
            <div class="wap_erweima">
    <?php echo '<img style="width:110px;height:110px;" src="?_a=site&_u=index.qrcode&site_uid='.$site['uid'].'"> '?>
    <div>扫一扫访问手机版</div>
</div>
        <div class="header_title">您好，欢迎光临<?php echo $site['title']?></div>  

<?php 
    $html='';
    if(isIEBrowser()){
        $html.='<div class="mobile_index" style="line-height:28px;padding-top:4px;padding-bottom:0">访问手机版</div>';
    }
    else
      $html.=' <div class="mobile_index">访问手机版</div>';
    echo $html;
?>

<?php 
  if($site['phone']){
    echo '<div class="tel_number" style="">全国免费热线：'.$site['phone'].'</div>
        <img class="tel_pic" src="/app/site/view/website/static/images/phone.png">';
  };
?>
        
      </div>

</div>
