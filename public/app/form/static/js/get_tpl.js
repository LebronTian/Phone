$(function () {

    var box = $('.tpls-box');




    /*
        1.可以不传参数，自动取下一页数据
        2.可以传一个数字，取特定页码
        3.可以传参数post，get的参数，注意zepto的get不能传参数。
    */

    function get_tpl(option){

        console.log('!',get_tpl);

        function ajax_get(page){
            $.getJSON('?_a=form&_u=api.get_tpls', function (ret) {
                console.log(ret)
            })
        }
    }

    var html_tpl = get_tpl(0);
    console.log('?',html_tpl,!!html_tpl);
    if(html_tpl){
        box.append(html_tpl)
    }


});