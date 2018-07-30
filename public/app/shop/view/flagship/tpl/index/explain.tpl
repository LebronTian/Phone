<?php include $tpl_path.'/header.tpl';?>
<header class="color-main vertical-box">
    <span class="header-title">购前须知</span>
    <div class="header-left vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/back.png" onclick="history.back()">
    </div>
    <div class="header-right vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/home.png" onclick="window.location.href='?_a=shop'">
    </div>
</header>
<div class="container">
<?php echo ($konw['content'])? $konw['content']: '请在后台编辑内容...'; ?>
</div>
</body>
</html>
