seajs.config({
    charset: 'utf-8',
    paths:{
        'js':'/static_seajs/js',
        'css':'/static_seajs/css',
        'public':'/static_seajs/public_toolkit',    //第三方组件文件夹
        'private':'/static_seajs/private_toolkit',  //自写组件文件夹
        'static_path':path_option.static,           //当前app的静态文件路径
        'tpl_path':path_option.tpl,                 //当前app的页面文件路径
        'old_for_test':'/static/js'
    },
    alias: {
        /*public*/
        'amazeui_js'		:'public/amazeui/amazeui2.1.min.js',
        'amazeui_css'		:'public/amazeui/amazeui2.1.min.css',
        'jquery_cookie'		:'public/cookie/jquery.cookie.js',
        'zepto_cookie'		:'public/cookie/zepto.cookie.min.js',
        'datatables_js'		:'public/datatables/amazeui.datatables.min.js',
        'datatables_css'	:'public/datatables/amazeui.datatables.min.css',
        'echarts'			:'public/echarts/echarts.js',
        'echo'				:'public/echo/echo.min.js',
        'jquery'			:'public/jquery/jquery2.1.min.js',
        'plupload'			:'public/plupload/plupload.full.min.js',
        'qqFace'			:'public/qqFace/jquery.qqFace.js',
        'qqFace_data'		:'public/qqFace/qqFaceData.js',
        'jquery_qrode'      :'public/qqFace/jquery.qrcode.js',
        'qrode'             :'public/qqFace/qrcode.js',
        'select2_js'		:'public/select2/select2.full.min.js',
        'select2_css'		:'public/select2/select2.min.css',
        'swiper_js'			:'public/swiper/swiper.min.js',
        'swiper_css'		:'public/swiper/swiper.min.css',
        'ueditor'			:'public/ueditor/echarts.js',
        'uploadify_js'		:'public/uploadify/jquery.uploadify-3.1.min.js',
        'uploadify_css'		:'public/uploadify/uploadify.css',
        'zclip'				:'public/zclip/jquery.zclip.min.js',
        'zepto'				:'public/zepto/zepto.min.js',
        'zui'				:'public/zui/zui.css',
        /*private*/
        'selectTpl'         :'private/selectTpl/select-tpl.js',
        'autoImage'         :'js/auto-image.js',
        'selectPic'         :'private/selectPic/select-pic.js',
        'selectVir'         :'private/selectVirtual/select_virtual.js',
    }
    //,preload:['jquery','amazeui_js','jquery_cookie']  //基础依赖直接在seajs上面引入
});