define(function (require,exports,module) {
    require('css/addcart.css');
    require('iscroll');
    $(function () {

    });
    /**/
    exports.show = function () {
        $('.addCart-container').show();
        var myScroll = new IScroll('#iscroll-wrapper', { mouseWheel: true });
        $('body').on('touchstart',function () {
            return false
        })
    };
    exports.hide = function () {
        $('.addCart-container').hide();
        $('body').unbind('touchstart')
    };
});

