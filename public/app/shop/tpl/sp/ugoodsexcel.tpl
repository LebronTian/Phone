<head>
  <link rel="stylesheet" type="text/css" href="/static/css/uploadify.css">
  <link rel="stylesheet" type="text/css" href="/static/css/imglist.css">
  <link rel="stylesheet" type="text/css" href="/static/css/uploadify.css">
  <link rel="stylesheet" type="text/css" href="/app/sp/static/css/css.css">
  <link rel="stylesheet" type="text/css" href="/app/sp/static/css/style.css"> 
  <link rel="stylesheet" type="text/css" href="/app/sp/static/css/jquery.Jcrop.css"> 
<style type="text/css">
  .uploadify-button {
    line-height: 25px !important;
  }
	.fstatus {
	}
</style>
</head>

<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">优库网 excel商品数据导入</strong> / <small></small></div>
</div>

<div class="am-cf am-padding">
<p>数据表格式 参考之前发的尾料信息统计表.xls </p>
<p><button id="id_key_file" class="am-btn am-btn-lg am-btn-primary save">上传文件</button></p>
</div>

<?php
        $extra_js =  array( 
          '/static/js/jquery.uploadify-3.1.min.js',
          $static_path.'/js/ugoodsexcel.js',
    );
?>


