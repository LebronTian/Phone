/**
 **移动端，PC端 预加载
 **/
;
(function($) {
    $.fn.loading = function(options) {
        //默认参数
        var defaults = {
            strings: '数据加载中',
            display: 'show',
            type: 'default',
            times: 0
        };
        var settings = $.extend({}, defaults, options); //将一个空对象作为第一个参数
        var $this = this;
        //初始化清空元素
        if (settings.type == 'default') {
            $('#my-loading-default').remove();
        }
        else if (settings.type == 'cover') {
            $('#my-loading-cover').remove();
        }
        //显示或隐藏
        if (settings.display == 'show') {
            settings.display = 'block';
        }
        else if (settings.display == 'hide') {
            settings.display = 'none';
        }
        //console.log(settings)
        //有时间参数times
        if (settings.times) {
            if (settings.type == 'default') {
                setTimeout(function() {
                    $('#my-loading-default').hide();
                }, settings.times);
            }
            else if (settings.type == 'cover') {
                setTimeout(function() {
                    $('#my-loading-cover').hide();
                }, settings.times);
            }
        }
        var html = createHtml();
        $this.prepend(html);

        function createHtml() {
            if (settings.type == 'default') {
                var html = '<div id="my-loading-default" style="display:' + settings.display + '"><div>' + '<div><div id="floatingCirclesG">' + '<div class="f_circleG" id="frotateG_01"></div>' + '<div class="f_circleG" id="frotateG_02"></div>' + '<div class="f_circleG" id="frotateG_03"></div>' + '<div class="f_circleG" id="frotateG_04"></div>' + '<div class="f_circleG" id="frotateG_05"></div>' + '<div class="f_circleG" id="frotateG_06"></div>' + '<div class="f_circleG" id="frotateG_07"></div>' + '<div class="f_circleG" id="frotateG_08"></div>' + '</div></div><p>' + settings.strings + '</p></div></div>';
                return html;
            }
            else if (settings.type == 'cover') {
                var html = '<div id="my-loading-cover" style="display:' + settings.display + '"><div><div class="cssload-thecube">' + '<div class="cssload-cube cssload-c1"></div>' + '<div class="cssload-cube cssload-c2"></div>' + '<div class="cssload-cube cssload-c4"></div>' + '<div class="cssload-cube cssload-c3"></div>' + '</div><p>' + settings.strings + '</p></div></div>';
                return html;
            }
        };
    };
})(jQuery);