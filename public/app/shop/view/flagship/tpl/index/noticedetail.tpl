<?php include $tpl_path.'/header.tpl'; ?>
<header class="color-main vertical-box">
    <span class="header-title"><?php if(!empty($shop['title'])) echo $shop['title'] ?></span>
    <div class="header-left vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/back.png" onclick="history.back()">
    </div>
    <div class="header-right vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/home.png" onclick="window.location.href='?_a=shop'">
    </div>
</header>
<style>
	.container-title{text-align: center;font-size: 2rem;line-height: 2.5rem;font-weight: bold;width: 80%;margin: 1rem auto;}
	.container-content{display: block;width: 95%;margin: 0 auto;}
	.create_time{text-align: right;margin-right: 2%;}
</style>
<?php if(!empty($radio)){ ?>
<div class="container">
	<div class="container-title"><?php echo $radio['title'];?></div>
	<p class="create_time c-green"><?php echo date('Y-m-d H:i:s',$radio['create_time']);?></p>
	<div class="container-content"><?php echo $radio['content'];?></div>
</div>
<?php }else { ?>
	<p> 无内容。。</p>
	<?php }?>
<script>
	var url_uid='<?php echo requestInt('uid')?>';
</script>
</body>
</html>