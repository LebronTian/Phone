<?php include $tpl_path.'/header.tpl'; ?>
<style>
    .suggest-title{  padding: 0.4em 0.6em;  }
    #suggest-box{
        width: 95%;
        height: 12em;
        border: 0;
        border-top: thin solid #d9d9d9;
        border-bottom: thin solid #d9d9d9;
        padding: 0.4em 2.5%;
        resize: none;
        font-size: 16px;
    }
</style>
<header class="color-main vertical-box">
    <span class="header-title">我的建议</span>
    <div class="header-left vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/back.png" onclick="history.back()">
    </div>
    <div class="header-right vertical-box">
        <img class="img-btn" src="<?php echo $static_path?>/images/home.png" onclick="window.location.href='?_a=shop'">
    </div>
</header>
<article class="suggest-article">
    <p class="suggest-title">我的建议</p>
    <textarea id="suggest-box" placeholder="我们期待你的宝贵意见！"></textarea>
</article>
<footer class="btn-footer footer-one-btn">
    <button class="suggest-btn color-primary big-text">提交建议</button>
</footer>

<?php include $tpl_path.'/footer.tpl'; ?>

<script>
    seajs.use('zepto', function () {
        $(document).ready(function () {
            $(".suggest-btn").click(function () {
                var text = $("#suggest-box").val();
                if(text.trim()==""){
                    showTip(1000,"请输入您的宝贵意见。");
                    return
                }
                $.post("?_a=shop&_u=ajax.add_message",{brief:text }, function (ret) {
                    showTip(1000,"谢谢您对我们工作的建议与支持！");
                    history.back();
                })
            })
        })
    });

</script>
</body>
</html>

