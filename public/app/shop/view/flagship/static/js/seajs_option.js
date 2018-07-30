seajs.config({
    charset: 'utf-8',
    paths:{
        'js':'/app/shop/view/flagship/static/js',
        'css':'/app/shop/view/flagship/static/css',
        'seajs':'/app/shop/view/flagship/static/seajs'
    },
    alias: {
        'jquery':'js/jquery2.1.min.js',
        'jquery_cookie':'js/jquery.cookie.js',
        'zepto':'js/zepto.min.js',
        'zepto_cookie':'js/zepto.cookie.min.js',

        'doT':'js/doT.min.js',
        'plupload':'js/plupload.full.min.js',   
        'transit':'js/jquery.transit.min.js',
        'fastclick':'js/fastclick.min.js',
        'echo':'js/echo.min.js',
        'iscroll':'js/iscroll.js',

        'swiper_js':'css/swiper/swiper.min.js',
        'swiper_css':'css/swiper/swiper.min.css',

        'swiper' :'js/swiper.js',
        'count_box':'js/count_box.js',
        'addcart':'js/addcart.js',
        'test':'seajs/function1.js'

    }
//        , preload:'style'
});
seajs.use('zepto', function () {
    $(document).ready(function () {
        $(".header-title").tap(function () {
            window.location.reload()
        })
    })
});