<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0">
<meta name="apple-mobile-web-app-capable" content="yes"><meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="format-detection" content="telephone=no"><title><?php echo $doc['title'];?></title>        
<style>
body {
background-color: #e7e8eb;
font-family: "Helvetica Neue",Helvetica,"Hiragino Sans GB","Microsoft YaHei",Arial,sans-serif;
}
.rich_media_title {
padding-bottom: 10px;
margin-bottom: 14px;
border-bottom: 1px solid #e7e7eb;
}
.rich_media {
max-width: 740px;
margin-left: auto;
margin-right: auto;
}
.rich_media_inner {
background-color: #fff;
padding-bottom: 100px;
border: 1px solid #d9dadc;
border-top-width: 0;
padding: 20px;
}
img {
margin:auto;
max-width: 100%;
}
table {
width:100% !important;
}
.rich_media_content * {
max-width: 100%!important;
box-sizing: border-box!important;
-webkit-box-sizing: border-box!important;
word-wrap: break-word!important;
}
</style>
</head>    
<body id="activity-detail" class="zh_CN mm_appmsg not_in_mm" ontouchstart="">
<div id="js_article" class="rich_media">
	<div class="rich_media_inner">
		<div id="page-content">
		<h2 class="rich_media_title" id="activity-name"><?php echo $doc['title'];?></h2>
		<div class="rich_media_meta_list"><?php echo date('Y-m-d', $doc['create_time']);?></div>
		<div class="rich_media_content id="js_content"">
		<?php
			echo $doc['content'];
			
			#echo '<hr/>';
			//xiao wei ba
			/*
			if(!empty($spider['add_tail'])) {
				echo $spider['tail'];
			}
			*/
		?>
		</div>
		</div>
	</div>    
	</div>
</body>
</html>
