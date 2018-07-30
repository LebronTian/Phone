seajs.config({
    charset: 'utf-8',
    paths:{
         'public':'/app/shop/view/flagship/static/c_js/public',
         'private':'/app/shop/view/flagship/static/c_js/private',
         'css':'/app/shop/view/flagship/static/css',
        // 'js':'/app/shop/view/flagship/static/js'
         'seajs':'/app/shop/view/flagship/static/seajs'
    },
    alias: {
        'jquery':'public/jquery2.1.min.js',
        'jquery_cookie':'public/jquery.cookie.js',
        'zepto':'public/zepto.min.js',
        'zepto_cookie':'public/zepto.cookie.min.js', 
        'doT':'public/doT.min.js', 
        'plupload':'public/plupload.full.min.js', 
        
        'fastclick':'public/fastclick.min.js',
        'echo':'public/echo.min.js',
        'iscroll':'public/iscroll.js', 
 
        'count_box':'private/count_box.js',
        'addcart':'private/addcart.js',

        'swiper_js':'swiper/swiper.min.js',
        'swiper_css':'swiper/swiper.min.css',
        'test':'seajs/function1.js',
        'transit':'public/jquery.transit.min.js',
        // 'echo':'seajs/echo_seajs.js'
    }
});

seajs.use('zepto', function () {
    $('.header-title').click(function () {
        window.location.reload()
    });
    $('.window-reload').click(function () {
        window.location.reload()
    })
});