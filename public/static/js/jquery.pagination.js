/***
** jQuery.pagination.js 1.0.2
***/
;(function($) {
    $.fn.pagination = function(options) {
        var settings = $.extend({}, defaults, options); //将一个空对象作为第一个参数
        var $this = this; //this指向被选中的dom元素
        
        //获取数据，并执行相应方法
        var ajaxData = function(page, limit, key) {
            var data = $.extend({}, settings.data, {
                page: page,
                limit: limit,
                key: key
            });
            $.ajax({
                type: settings.type,
                dataType: settings.datatype,
                url: settings.url,
                data: data,
                beforeSend: function(ret) {
                    //发送请求之前，预加载提示...
                    settings.beforeSend(ret);
                },
                success: function(ret) {
                    //成功时...
                    settings.datalist(ret); //执行创建html方法
                    getPageBar(ret); //执行创建页码方法
                }
            });
        };
        
        //初始化
        ajaxData(settings.page, settings.limit, settings.key);
        
        //定义变量
        var pageTotle, pageCur, pageSize, pageStr, count, curcount;
        var getPageBar = function(ret) {
            //初始化 
            pageCur = settings.page;
            pageTotle = Math.ceil(parseInt(ret.data.count) / settings.limit); //总页面数	==> 总条数/limit
            //console.log(pageTotle);
            pageSize = settings.maxnum; //页数限制 ==> maxnum
            pageStr = "";
            if(settings.device == 'pc'){
                //调用分页
                createPage();
            }
            else if(settings.device == 'mobile'){
                //加载数据
                mobileScroll();
            }  
            
        };

        //移动端加载
        var mobileScroll = function() {
            $(window).scroll(function(){
                if($(this).scrollTop()+$(window).height()+80>=$(document).height()){
                    if(settings.page>=pageTotle){
                        return false;
                    }
                    settings.page+=1;
                    ajaxData(settings.page, settings.limit, settings.key);
                };
            });
        };
        
        //点击按钮
        $(document).on('click', '#createPage>a', function(event) {
            event.stopPropagation();
            var num = parseInt($(this).attr('data-num'));
            settings.page = num; //大坑大坑大坑！！！万万不可直接赋值给pageCur！！！可是我这么做了，更被坑了，艹！！！
            goToPage(settings.page);
        });
        
        //跳转至某一页
        $(document).on('click', '#go-to-page-btn', function() {
            var go_to_page_val = parseInt($('#go-to-page-text').val());
            if(go_to_page_val){
                settings.page = go_to_page_val - 1;
                if(go_to_page_val>0 && go_to_page_val<=pageTotle){
                    ajaxData(settings.page, settings.limit, settings.key);    
                }
                else{
                    alert('页码超出范围');
                    return;
                }
            }
        });
        
        //跳转页码输入框限制
        $(document).on('keyup', '#go-to-page-text', function() {
            if(isNaN($(this).val())){
                $(this).val('');
                $(this).attr('placeholder', '请输入数字');
            }
        });
        
        //点击发送ajax请求
        var goToPage = function(target) {
            settings.page = target; //把页面计数定位到第几页 
            ajaxData(settings.page, settings.limit, settings.key);
        };
        
        //搜索
        $('#' + settings.schBtnId ).on('click', function() {
            var key = $('#' + settings.schTextId ).val();
            // pc端
            if(settings.device == 'pc'){
                settings.key = key;
                settings.page = 0;
                ajaxData(settings.page, settings.limit, settings.key);
            }
            // 移动端
            else if(settings.device == 'mobile'){
                settings.key = key;
                settings.page = 0;
                if(settings.page == 0){
                    $('#'+settings.containerId).children().remove();
                }
                ajaxData(settings.page, settings.limit, settings.key);

            }
        });
        
        //创建分页html
        var createPage = function() {
            if (pageTotle <= pageSize) { //总页数小于限制页数 
                for (count = 0; count < pageTotle; count++) {
                    if (count != pageCur) {
                        pageStr += "<a href='javascript:void(0)' data-num='" + count + "'>" + (count + 1) + "</a>";
                    } else {
                        pageStr += "<span class='current' >" + (count + 1) + "</span>";
                    }
                }
            }
            if (pageTotle > pageSize) { //总页数大于限制页数 
                if (parseInt(pageCur / pageSize) == 0) {
                    for (count = 0; count < pageSize; count++) {
                        if (count != pageCur) {
                            pageStr += "<a href='javascript:void(0)' data-num='" + count + "'>" + (count + 1) + "</a>";
                        } else {
                            pageStr += "<span class='current'>" + (count + 1) + "</span>";
                        }
                    }
                    pageStr += "<a href='javascript:void(0)' data-num='" + count + "'> &gt; </a>";
                } else if (parseInt(pageCur / pageSize) == parseInt(pageTotle / pageSize)) {
                    pageStr += "<a href='javascript:void(0)' data-num='" + (parseInt(pageCur / pageSize) * pageSize - 1) + "'>&lt;</a>";
                    for (count = parseInt(pageTotle / pageSize) * pageSize; count < pageTotle; count++) {
                        if (count != pageCur) {
                            pageStr += "<a href='javascript:void(0)' data-num='" + count + "'>" + (count + 1) + "</a>";
                        } else {
                            pageStr += "<span class='current'>" + (count + 1) + "</span>";
                        }
                    }
                } else {
                    pageStr += "<a href='javascript:void(0)' data-num='" + (parseInt(pageCur / pageSize) * pageSize - 1) + "'>&lt;</a>";
                    for (count = parseInt(pageCur / pageSize) * pageSize; count < parseInt(pageCur / pageSize) * pageSize + pageSize; count++) {
                        if (count != pageCur) {
                            pageStr += "<a href='javascript:void(0)' data-num='" + count + "'>" + (count + 1) + "</a>";
                        } else {
                            pageStr += "<span class='current'>" + (count + 1) + "</span>";
                        }
                    }
                    pageStr += "<a href='javascript:void(0)' data-num='" + count + "'> &gt; </a>";
                }
            };
            // 根据需要是否显示跳转至某页按钮级输入框
            if(settings.goToPage){
                $this.html("<div id='createPage'><span id='info'>共" + pageTotle + "页<\/span>" + pageStr + "<input type='text' id='go-to-page-text'><button id='go-to-page-btn'>确认</button><\/div>");
            }else{
                $this.html("<div id='createPage'><span id='info'>共" + pageTotle + "页<\/span>" + pageStr + "<\/div>");
            }
            
            pageStr = "";
        };
        return this;
    };
    
    //默认参数
    var defaults = {
        device: 'pc',   //使用设备，默认pc，若在移动端使用则设置mobile
        page: 0,        //当前第几页
        limit: 10,      //每页显示数目
        key: '',        //搜索关键字
        maxnum: 10,     //最多页码数
        schBtnId: '',   //搜索按钮id
        schTextId: '',  //搜索文本框id
        containerId: '',//仅使用mobile方式时需要设置容器id
        goToPage: true, //是否显示跳转到某页输入框及按钮
        data: {},       //向后台发送的数据 包括 page limit key等
        type: 'POST',
        datatype: 'json',
        url: '',        //接口地址 默认为空
        datalist: function() {}, //返回数据处理（）
        beforeSend: function() {} //发送请求之前（预加载）
    };
})(jQuery);