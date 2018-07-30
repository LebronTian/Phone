<?php include $tpl_path.'/header.tpl'; ?>

<header class="color-main vertical-box">
    <span class="header-title">我的足迹</span>
    <div class="header-left vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/back.png" onclick="history.back()">
    </div>
    <div class="header-right vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/home.png" onclick="window.location.href='?_a=shop'">
    </div>
</header>
<style>
	.container{margin: 0;padding: 0;}
	.container a{width: 32.6%;float: left;margin-right: 1.1%;background-color: #fff;margin-bottom: 0.25em;}
	.container a:nth-child(3n){margin-right: 0;}
	.container a div{position: relative;padding-bottom: 100%;height: 0;overflow: hidden;}
	.container a div img{position: absolute;top:0;left:0;width: 100%;height: 100%;}
	.container a p{color: #333;overflow: hidden;white-space: nowrap;text-overflow: ellipsis;padding:0.5em;}
	
.demo{width:480px; margin:100px auto; border:1px solid #d3d3d3}
.demo h3{height:30px; line-height:30px; padding-left:3px; background:#f7f7f7; border-bottom:1px solid #d3d3d3; font-size:14px}
ul{margin:4px; list-style:inside circle}
ul li{line-height:24px;}
</style>
<div class="container">
	暂无浏览记录。。
</div>
<script>
	//浏览记录
	$.fn.getHTML = function(){
	var th = $(this);
	var jsonData = eval("("+$.cookie("hisArt")+")");
	var json = jsonData.reverse();
	//if(!json || json==null) return false;
	var list = "";
	for(var i=0; i<json.length;i++){
		list = list + "<a href='"+json[i].url+"'><div><img src='"+json[i].img+"'/></div><p>"+json[i].title+"</p></a>";
	}
	th.html(list);
}
	$(".container").getHTML();
</script>
</body>
</html>