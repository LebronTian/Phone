
<script src="/app/shop/view/wap/static/js/sea.js"></script>
<script>
    seajs.config({
        charset: 'utf-8',
        paths:{
            'top_js':'/static/js/',
            'app_js':'<?php echo $static_path ?>/js'

        },
        alias: {
            'jquery':'top_js/jquery2.1.min.js',
            'jquery_cookie':'js/jquery.cookie.js',
            'zepto':'top_js/zepto.min.js',
            'zepto_cookie':'top_js/zepto.cookie.min.js',
            'plupload':'top_js/plupload.full.min.js',
            'doT':'top_js/doT.min.js'
        }
    });
</script>
<!--todo:************************************************************************************************************-->
