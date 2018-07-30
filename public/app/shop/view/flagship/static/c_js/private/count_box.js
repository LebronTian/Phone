define(function (require,exports,module) {

    /*如果页面多出显示同样数据的count，可以用name作标识*/
    /*提取最小值最大值设置操作*//*可以正的就最大值，负的最小值，先只做最大值，现在最小值是1*/
    require('css/count_box.css');

    var max_value = 10;
    exports.max = function (max) {
    };

    exports.add = function (box) {
        var input = box.find('.count-input');
        var now_num,new_num;
        if(input.is('input')){
            now_num = parseInt(input.val());
            new_num = (isNaN(now_num))?1:now_num+1;
            input.val(new_num);
        }
        else {
            now_num = parseInt(input.text());
            new_num = (isNaN(now_num))?1:now_num+1;
            input.text(new_num);
        }
    };

    exports.cut = function (box) {
        var input = box.find('.count-input');
        var now_num,new_num;

        if(input.is('input')){
            now_num = parseInt(input.val());
        }
        else {
            now_num = parseInt(input.text());
        }
        new_num = (isNaN(now_num))?1:now_num-1;
        if(new_num>=1) {
            if(input.is('input')){
                input.val(new_num);
            }
            else {
                input.text(new_num);
            }
        }
    };


});

