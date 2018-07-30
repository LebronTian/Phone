
<script src="<?php echo $static_path?>/js/sea.js"></script>
<script src="<?php echo $static_path?>/js/seajs-css.js"></script>
<!--<script src="/static/js/seajs-preload.js"></script>-->
<!--<script src="/static/js/seajs_option.js"></script>-->
<script>
    seajs.config({
        charset: 'utf-8',
        paths:{
            'js':'<?php echo $static_path?>/js',
            'css':'<?php echo $static_path?>/css',
            'seajs':'<?php echo $static_path?>/seajs'
            // 'js':'/app/shop/view/flagship/static/js',
            // 'css':'/app/shop/view/flagship/static/css',
            // 'seajs':'/app/shop/view/flagship/static/seajs'
        },
        alias: {
            'jquery':'js/jquery2.1.min.js',
            'jquery_cookie':'js/jquery.cookie.js',
            'zepto':'js/zepto.min.js',
            'zepto_cookie':'js/zepto.cookie.min.js',
            'doT':'js/doT.min.js',
            'plupload':'js/plupload.full.min.js',


            'swiper_js':'css/swiper/swiper.min.js',
            'swiper_css':'css/swiper/swiper.min.css',
            'test':'seajs/function1.js',
            'transit':'js/jquery.transit.min.js',
            'echo':'seajs/echo_seajs.js'
        }
//        , preload:'style'
    });
    seajs.use('zepto', function () {
        $(document).ready(function () {
            $(".header-title").click(function () {
                window.location.reload()
            });
        });
    });
    function showTip(type,str){
        alert(str)
    }
</script>
<!--todo:************************************************************************************************************-->
