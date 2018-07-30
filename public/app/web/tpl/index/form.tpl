<!doctype html>
<html class="no-js">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>UCT微信O2O营销平台</title>
  <meta name="description" content="UCT微信O2O公众号营销平台 ">
  <meta name="keywords" content="UCT 微信 O2O 公众号 营销 ">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
  <meta name="renderer" content="webkit">
  <meta http-equiv="Cache-Control" content="no-siteapp" />
  <link rel="shortcut icon" href="/favicon.ico"/>
  <link rel="bookmark" href="/favicon.ico"/>
  <meta name="apple-mobile-web-app-title" content="Amaze UI" />
  
  <link rel="stylesheet" type="text/css" href="/static/css/amazeui2.1.min.css">
  <link rel="stylesheet" type="text/css" href="/static/css/reset.css">
  <link rel="stylesheet" type="text/css" href="/app/web/static/css/index.css">
  <link rel="stylesheet" type="text/css" href="/app/sp/static/css/login.css">
  <link rel="stylesheet" type="text/css" href="/app/web/static/css/form.css">
</head>
<body style="min-width:1170px;background-color:#FFF;font-size:16px;overflow-x:hidden;" onload="setup();preselect('广东省');promptinfo();">

    <?php 
      include $tpl_path.'/header_n.tpl';
    ?>
  	
	<div class="form-content" style="background:url(/app/web/static/images/form_bg.jpg) repeat center center;">
        <div class="am-container">
	        <div class="tit">
	        	<h1>申请加盟<span>代理商</span></h1>
	        </div>
	        <div class="cont">
	        	<div class="am-g">
		        	<div class="am-u-sm-2 form-left">加盟类型</div>
		        	<div class="am-u-sm-10">
		        		<div class="am-u-sm-3">
			        		<label class="am-radio" id="radio-label-1">
						      <input type="radio" name="radio1" value="" data-am-ucheck checked>
						      企业
						    </label>
					    </div>
					    <div class="am-u-sm-3">
						    <label class="am-radio" id="radio-label-2">
						      <input type="radio" name="radio1" value="" data-am-ucheck>
						      个人
						    </label>
					    </div>
					    <div class="am-u-sm-6"></div>
		        	</div>
	        	</div>
	        	<div class="am-g company-bar">
		        	<div class="am-u-sm-2 form-left">公司名称</div>
		        	<div class="am-u-sm-10">
		        		<input class="am-form-field" type="text">
		        	</div>
	        	</div>
	        	<div class="am-g">
		        	<div class="am-u-sm-2 form-left">所在区域</div>
		        	<div class="am-u-sm-10">
		        		<form>
				            <select class="select" name="province" id="s1">
				              <option></option>
				            </select>
				            <select class="select" name="city" id="s2">
				              <option></option>
				            </select>
				            <select class="select" name="town" id="s3">
				              <option></option>
				            </select>
				        </form>
		        	</div>
	        	</div>
	        	<div class="am-g">
		        	<div class="am-u-sm-2 form-left">联系人</div>
		        	<div class="am-u-sm-10">
		        		<input class="am-form-field" type="text">
		        	</div>
	        	</div>
	        	<div class="am-g">
		        	<div class="am-u-sm-2 form-left">手机号</div>
		        	<div class="am-u-sm-10">
		        		<input class="am-form-field" type="text">
		        	</div>
	        	</div>
	        	<div class="am-g">
		        	<div class="am-u-sm-2 form-left"></div>
		        	<div class="am-u-sm-10">
		        		<p class="info">提交后，我们会在最短的时间联系您</p>
		        	</div>
	        	</div>
	        	<input type="button" id="submit-btn" class="am-btn am-btn-success am-round" value="提交申请">
	        </div>
        </div>
    </div>



    <div style="clear:both;"> </div>
    <?php 
      include $tpl_path.'/footer.tpl';
    ?>

<!-- <script src=”http://ie7-js.googlecode.com/svn/version/2.0(beta)/IE7.js” type=”text/javascript”></script> -->
<script src="/static/js/jquery2.1.min.js"></script>
<script src="/static/js/amazeui2.1.min.js"></script>
<script src="http://webapi.amap.com/js/marker.js"></script>
<script type="text/javascript" src="http://webapi.amap.com/maps?v=1.3&key=fe8d0e9cfe462f86662a359a0168d173"></script> 
<script type="text/javascript" src="/app/web/static/js/header.js"></script>
<script type="text/javascript" src="/static/js/geo.js"></script>
<script type="text/javascript" src="/app/web/static/js/form.js"></script>

<script type="text/javascript">
  	function promptinfo(){
	    var s1 = document.getElementById('s1');
	    var s2 = document.getElementById('s2');
	    var s3 = document.getElementById('s3');
	}
</script>
<?php 
    include $tpl_path.'/qq.tpl';
?>
</body>
</html>
