<?php include $tpl_path.'/header.tpl';?>
<header class="color-main vertical-box">
    <span class="header-title">官方客服</span>
    <div class="header-left vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/back.png" onclick="history.back()">
    </div>
    <div class="header-right vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/home.png" onclick="window.location.href='?_a=shop'">
    </div>
</header>
<style>
	.container{padding: 1%;}
	.kefu_qr img{
    position: absolute;
    width: 50%;
    max-width: 300px;
    top: 50%;
    left: 50%;
    -webkit-transform: translate(-50%, -50%);
    transform: translate(-50%, -50%);
    background-color: #FAFAFC;
    text-align: center;
    border-radius: 3px;
    overflow: hidden;
	}
	.kefu_qr p{
		position: absolute;
		top: 30%;
	    left: 50%;
	    -webkit-transform: translate(-50%, -50%);
	    transform: translate(-50%, -50%);
		
	}
</style>
<div class="container">
	<div class="kefu_qr">
		<img src="<?php echo $static_path?>/images/guanfang_qr.bmp" alt="二维码" />
		<p>长按二维码联系客服</p>
	</div>
</div>
<script>
	$('.kefu_qr img').height($('body').width()/2)
</script>
</body>
</html>
